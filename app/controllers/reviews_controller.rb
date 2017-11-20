# frozen_string_literal: true

# Allows reviewers to view data requests.
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_data_request_or_redirect, only: [
    :show, :print, :transactions, :vote, :update_tags, :supporting_document,
    :signature, :duly_authorized_representative_signature, :reviewer_signature
  ]
  before_action :find_supporting_document_or_redirect, only: [:supporting_document]

  # GET /reviews
  def index
    params[:order] = "agreements.last_submitted_at desc" if params[:order].blank?
    @order = scrub_order(DataRequest, params[:order], [:id])
    agreement_scope = current_user.reviewable_data_requests.search(params[:search]).order(@order)
    agreement_scope = agreement_scope.with_tag(params[:tag_id]) if params[:tag_id].present?
    agreement_scope = agreement_scope.where(status: params[:status]) if params[:status].present?
    @data_requests = agreement_scope.page(params[:page]).per(40)
    render layout: "layouts/full_page_dashboard_no_drawer"
  end

  # # GET /reviews/1
  # def show
  # end

  # GET /reviews/1/print
  def print
    @data_request.generate_printed_pdf!
    if @data_request.printed_file.present?
      send_file @data_request.printed_file.path, filename: "#{@data_request.user.last_name.gsub(/[^a-zA-Z\p{L}]/, '')}-#{@data_request.user.first_name.gsub(/[^a-zA-Z\p{L}]/, '')}-#{@data_request.agreement_number}-data-request-#{(@data_request.submitted_at || @data_request.created_at).strftime("%Y-%m-%d")}.pdf", type: "application/pdf", disposition: "inline"
    else
      render "data_requests/print", layout: false
    end
  end

  # GET /reviews/:id/supporting-documents/:supporting_document_id
  def supporting_document
    send_file_if_present @supporting_document.document, disposition: "inline"
  end

  # GET /reviews/1/signature
  def signature
    send_file_if_present @data_request.signature_file
  end

  # GET /reviews/1/duly_authorized_representative_signature
  def duly_authorized_representative_signature
    send_file_if_present @data_request.duly_authorized_representative_signature_file
  end

  # GET /reviews/1/reviewer_signature
  def reviewer_signature
    send_file_if_present @data_request.reviewer_signature_file
  end

  # # GET /reviews/1/transactions
  # def transactions
  # end

  # POST /reviews/1/vote.js
  def vote
    @review = @data_request.reviews.where(user_id: current_user.id).first_or_create
    original_approval = @review.approved
    @review.update approved: (params[:approved].to_s == "1") if %w(0 1).include?(params[:approved].to_s)
    event_type = if @review.approved == original_approval
                   ""
                 elsif @review.approved == true && original_approval == false
                   "reviewer_changed_from_rejected_to_approved"
                 elsif @review.approved == false && original_approval == true
                   "reviewer_changed_from_approved_to_rejected"
                 elsif @review.approved == true
                   "reviewer_approved"
                 elsif @review.approved == false
                   "reviewer_rejected"
                 end
    @agreement_event = @data_request.agreement_events.create(event_type: event_type, user_id: current_user.id, event_at: Time.zone.now) if event_type.present?
    render "agreement_events/create"
  end

  # POST /reviews/1/update_tags.js
  def update_tags
    submitted_tags = Tag.review_tags.where(id: params[:data_request][:tag_ids])
    added_removed_tag_ids = []
    Tag.review_tags.each do |tag|
      if submitted_tags.include?(tag) && !@data_request.tags.include?(tag)
        added_removed_tag_ids << [tag.id, true]
      elsif !submitted_tags.include?(tag) && @data_request.tags.include?(tag)
        added_removed_tag_ids << [tag.id, false]
      end
    end
    if added_removed_tag_ids.count > 0
      @data_request.update tags: submitted_tags
      @agreement_event = @data_request.agreement_events.create event_type: "tags_updated", user_id: current_user.id, event_at: Time.zone.now
      added_removed_tag_ids.each do |tag_id, added|
        @agreement_event.agreement_event_tags.create tag_id: tag_id, added: added
      end
    end
    render "agreement_events/index"
  end

  private

  def find_data_request_or_redirect
    @data_request = current_user.reviewable_data_requests.find_by(id: params[:id])
    empty_response_or_root_path(reviews_path) unless @data_request
  end

  def find_supporting_document_or_redirect
    @supporting_document = @data_request.supporting_documents.find_by(id: params[:supporting_document_id])
    empty_response_or_root_path(review_path(@data_request)) unless @supporting_document
  end
end
