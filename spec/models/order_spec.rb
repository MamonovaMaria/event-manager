require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:u_id) do
    User.order(id: :desc).first
  end
  let(:event) do
    Event.order(id: :desc).first
  end
  let(:invalid_event_id) { event[:id] + 1 }

  let(:room) do
    Room.order(id: :desc).first
  end
  let(:invalid_room_id) { room[:id] + 1 }

  let(:order) do
    Order.new(
      begin_datetime: event.begin_datetime,
      end_datetime: event.end_datetime,
      room_id: room.id,
      event_id: event.id
    )
  end

  describe ".new" do

    it "is valid with valid attributes" do
      expect(order).to be_valid
    end

    # BEGIN_DATETIME tests
    context "BEGIN_DATETIME tests" do
      it "is invalid if nil begin_datetime is set" do
        order[:begin_datetime] = nil
        expect(order).not_to be_valid
      end

      it "is invalid if empty begin_datetime is set " do
        order[:begin_datetime] = ""
        expect(order).not_to be_valid
      end

      it "is invalid if wrong begin_datetime is set " do
        order[:begin_datetime] = "0o0o0"
        expect(order).not_to be_valid
      end
    end

    # END_DATETIME tests
    context "END_DATETIME tests" do
      it "is invalid if nil end_datetime is set" do
        order[:end_datetime]=nil
        expect(order).not_to be_valid
      end

      it "is invalid if empty end_datetime is set" do
        order[:end_datetime] = ""
        expect(order).not_to be_valid
      end

      it "is invalid if wrong end_datetime is set " do
        order[:end_datetime] = "0o0o0"
        expect(order).not_to be_valid
      end
    end

    # DATETIME tests
    context "DATETIME tests" do
      it "is invalid if end_datetime is earlier than begin_datetime" do
        order[:end_datetime] = order[:begin_datetime] - 15.minutes
        expect(order).not_to be_valid
      end

      it "is invalid if order length is less than 15 minutes" do
        order[:end_datetime] = order[:begin_datetime] + 2.minutes
        expect(order).not_to be_valid
      end

      it "is invalid if order is longer than event" do
        order[:begin_datetime] = event[:begin_datetime]
        order[:end_datetime] = event[:end_datetime] + 10.minutes
        expect(order).not_to be_valid
      end

      it "is invalid if order time is beyond of the room work time" do
        order[:end_datetime] = order[:end_datetime].change({hour: room[:end_work_time].hour + 1})
        expect(order).not_to be_valid
      end
    end

    # ROOM tests
    context "ROOM tests" do
      it "is invalid if nil room_id is set" do
        order[:room_id] = nil
        expect(order).not_to be_valid
      end

      it "is invalid if missed room_id is set" do
        order[:room_id] = invalid_room_id
        expect(order).not_to be_valid
      end
    end

    # EVENT tests
    context "EVENT tests" do
      it "is invalid if nil event_id is set" do
        order[:event_id] = nil
        expect(order).not_to be_valid
      end

      it "is invalid if missed event_id is set" do
        order[:event_id] = invalid_event_id
        expect(order).not_to be_valid
      end
    end

  end

end
