require_relative "base"
require_relative "../tasks"

module Media
  module Upload
    module Models
      class Upload < Base
        many_to_one :state
        one_to_many :parts

        transitionable

        def before_validation
          self.state ||= State::PENDING
          validates_uuid [:file_id, :resource_id, :state_id]
          super
        end

        def validate
          super
          validates_transition :state_id
        end

        def after_update
          super
          return unless column_changed?(:state_id) && completed?
          Tasks::Concatenation.enqueue(id: id)
        end

        def state=(value)
          return super if value.respond_to?(:pk)
          super(State[name: value])
        end

        def completed?
          state == State::COMPLETED
        end

        def concatenating!
          update(state: State::CONCATENATING)
        end

        def concatenated!
          update(state: State::CONCATENATED)
        end

        def failed!
          update(state: State::FAILED)
        end

        def state_id_transitions
          {
            nil                     => [ State::PENDING.id ],
            State::PENDING.id       => [ State::COMPLETED.id ],
            State::COMPLETED.id     => [ State::CONCATENATING.id ],
            State::CONCATENATING.id => [ State::CONCATENATED.id, State::FAILED.id ]
            State::CONCATENATED.id  => []
          }
        end

        def basename
          File.basename(name)
        end

        def extension
          File.extname(name)
        end
      end
    end
  end
end
