# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `aasm` gem.
# Please instead update this file by running `bin/tapioca gem aasm`.

# typed: true

module AASM
  include ::AASM::Persistence::PlainPersistence

  mixes_in_class_methods ::AASM::ClassMethods

  # this is the entry point for all instance-level access to AASM
  def aasm(name = T.unsafe(nil)); end

  private

  def aasm_failed(state_machine_name, event_name, old_state, failures = T.unsafe(nil)); end
  def aasm_fire_event(state_machine_name, event_name, options, *args, &block); end
  def aasm_fired(state_machine_name, event, old_state, new_state_name, options, *args); end
  def fire_default_callbacks(event, *processed_args); end
  def fire_exit_callbacks(old_state, *processed_args); end
  def initialize_dup(other); end

  # Takes args and a from state and removes the first
  # element from args if it is a valid to_state for
  # the event given the from_state
  def process_args(event, from_state, *args); end

  class << self
    # provide a state machine for the including class
    # make sure to load class methods as well
    # initialize persistence for the state machine
    def included(base); end
  end
end

# Persistence
class AASM::Base
  def initialize(klass, name, state_machine, options = T.unsafe(nil), &block); end

  def after_all_events(*callbacks, &block); end
  def after_all_transactions(*callbacks, &block); end
  def after_all_transitions(*callbacks, &block); end

  # This method is both a getter and a setter
  def attribute_name(column_name = T.unsafe(nil)); end

  def before_all_events(*callbacks, &block); end
  def before_all_transactions(*callbacks, &block); end
  def ensure_on_all_events(*callbacks, &block); end
  def error_on_all_events(*callbacks, &block); end

  # define an event
  def event(name, options = T.unsafe(nil), &block); end

  def events; end
  def from_states_for_state(state, options = T.unsafe(nil)); end

  # aasm.event(:event_name).human?
  def human_event_name(event); end

  def initial_state(new_initial_state = T.unsafe(nil)); end

  # Returns the value of attribute klass.
  def klass; end

  # make sure to create a (named) scope for each state
  def state(*args); end

  # Returns the value of attribute state_machine.
  def state_machine; end

  # make sure to create a (named) scope for each state
  def state_with_scope(*args); end

  # define a state
  # args
  # [0] state
  # [1] options (or nil)
  # or
  # [0] state
  # [1..] state
  def state_without_scope(*args); end

  def states; end
  def states_for_select; end

  private

  def configure(key, default_value); end
  def create_scope(name); end
  def create_scope?(name); end
  def create_scopes(name); end
  def default_column; end
  def interpret_state_args(args); end
  def namespace; end
  def namespace?; end
  def safely_define_method(klass, method_name, method_definition); end
  def setup_no_direct_assignment(aasm_name); end
  def setup_timestamps(aasm_name); end
  def skip_instance_level_validation(event, name, aasm_name, klass); end
end

module AASM::ClassMethods
  # this is the entry point for all state and event definitions
  def aasm(*args, &block); end

  # make sure inheritance (aka subclassing) works with AASM
  def inherited(base); end
end

class AASM::Configuration
  # for all persistence layers: which database column to use?
  def column; end

  # for all persistence layers: which database column to use?
  def column=(_arg0); end

  # for all persistence layers: create named scopes for each state
  def create_scopes; end

  # for all persistence layers: create named scopes for each state
  def create_scopes=(_arg0); end

  # Returns the value of attribute enum.
  def enum; end

  # Sets the attribute enum
  def enum=(_arg0); end

  # Configure a logger, with default being a Logger to STDERR
  def logger; end

  # Configure a logger, with default being a Logger to STDERR
  def logger=(_arg0); end

  # namespace reader methods and constants
  def namespace; end

  # namespace reader methods and constants
  def namespace=(_arg0); end

  # forbid direct assignment in aasm_state column (in ActiveRecord)
  def no_direct_assignment; end

  # forbid direct assignment in aasm_state column (in ActiveRecord)
  def no_direct_assignment=(_arg0); end

  # for ActiveRecord: use pessimistic locking
  def requires_lock; end

  # for ActiveRecord: use pessimistic locking
  def requires_lock=(_arg0); end

  # for ActiveRecord: use requires_new for nested transactions?
  def requires_new_transaction; end

  # for ActiveRecord: use requires_new for nested transactions?
  def requires_new_transaction=(_arg0); end

  # for ActiveRecord: store the new state even if the model is invalid and return true
  def skip_validation_on_save; end

  # for ActiveRecord: store the new state even if the model is invalid and return true
  def skip_validation_on_save=(_arg0); end

  # automatically set `"#{state_name}_at" = ::Time.now` on state changes
  def timestamps; end

  # automatically set `"#{state_name}_at" = ::Time.now` on state changes
  def timestamps=(_arg0); end

  # for ActiveRecord: use transactions
  def use_transactions; end

  # for ActiveRecord: use transactions
  def use_transactions=(_arg0); end

  # for ActiveRecord: when the model is invalid, true -> raise, false -> return false
  def whiny_persistence; end

  # for ActiveRecord: when the model is invalid, true -> raise, false -> return false
  def whiny_persistence=(_arg0); end

  # let's cry if the transition is invalid
  def whiny_transitions; end

  # let's cry if the transition is invalid
  def whiny_transitions=(_arg0); end

  # allow a AASM::Base sub-class to be used for state machine
  def with_klass; end

  # allow a AASM::Base sub-class to be used for state machine
  def with_klass=(_arg0); end

  class << self
    # Returns the value of attribute hide_warnings.
    def hide_warnings; end

    # Sets the attribute hide_warnings
    def hide_warnings=(_arg0); end
  end
end

module AASM::Core; end

class AASM::Core::Event
  include ::AASM::DslHelper

  def initialize(name, state_machine, options = T.unsafe(nil), &block); end

  def ==(event); end

  # Returns the value of attribute default_display_name.
  def default_display_name; end

  def failed_callbacks; end
  def fire(obj, options = T.unsafe(nil), to_state = T.unsafe(nil), *args); end
  def fire_callbacks(callback_name, record, *args); end
  def fire_global_callbacks(callback_name, record, *args); end
  def fire_transition_callbacks(obj, *args); end

  # a neutered version of fire - it doesn't actually fire the event, it just
  # executes the transition guards to determine if a transition is even
  # an option given current conditions.
  def may_fire?(obj, to_state = T.unsafe(nil), *args); end

  # Returns the value of attribute name.
  def name; end

  # Returns the value of attribute options.
  def options; end

  # Returns the value of attribute state_machine.
  def state_machine; end

  def to_s; end

  # DSL interface
  def transitions(definitions = T.unsafe(nil), &block); end

  def transitions_from_state(state); end
  def transitions_from_state?(state); end
  def transitions_to_state(state); end
  def transitions_to_state?(state); end

  private

  def _fire(obj, options = T.unsafe(nil), to_state = T.unsafe(nil), *args); end
  def attach_event_guards(definitions); end
  def clear_failed_callbacks; end

  # called internally by Ruby 1.9 after clone()
  def initialize_copy(orig); end

  def invoke_callbacks(code, record, args); end
end

# main invoker class which encapsulates the logic
# for invoking literal-based, proc-based, class-based
# and array-based callbacks for different entities.
class AASM::Core::Invoker
  # Initialize a new invoker instance.
  # NOTE that invoker must be used per-subject/record
  # (one instance per subject/record)
  #
  # ==Options:
  #
  # +subject+ - invoking subject, may be Proc,
  # Class, String, Symbol or Array
  # +record+  - invoking record
  # +args+    - arguments which will be passed to the callback
  def initialize(subject, record, args); end

  def invoke; end

  # Change default return value of #invoke method
  # if none of invokers processed the request.
  #
  # The default return value is #DEFAULT_RETURN_VALUE
  #
  # ==Options:
  #
  # +value+ - default return value for #invoke method
  def with_default_return_value(value); end

  # Collect failures to a specified buffer
  #
  # ==Options:
  #
  # +failures+ - failures buffer to collect failures
  def with_failures(failures); end

  # Pass additional options to concrete invoker
  #
  # ==Options:
  #
  # +options+ - hash of options which will be passed to
  # concrete invokers
  #
  # ==Example:
  #
  # with_options(guard: proc {...})
  def with_options(options); end

  private

  # Returns the value of attribute args.
  def args; end

  def class_invoker; end

  # Returns the value of attribute default_return_value.
  def default_return_value; end

  # Returns the value of attribute failures.
  def failures; end

  def invoke_array; end
  def literal_invoker; end

  # Returns the value of attribute options.
  def options; end

  def proc_invoker; end

  # Returns the value of attribute record.
  def record; end

  def sub_invoke(new_subject); end

  # Returns the value of attribute subject.
  def subject; end
end

AASM::Core::Invoker::DEFAULT_RETURN_VALUE = T.let(T.unsafe(nil), TrueClass)
module AASM::Core::Invokers; end

# Base concrete invoker class which contain basic
# invoking and logging definitions
class AASM::Core::Invokers::BaseInvoker
  # Initialize a new concrete invoker instance.
  # NOTE that concrete invoker must be used per-subject/record
  # (one instance per subject/record)
  #
  # ==Options:
  #
  # +subject+ - invoking subject comparable with this invoker
  # +record+  - invoking record
  # +args+    - arguments which will be passed to the callback
  def initialize(subject, record, args); end

  # Returns the value of attribute args.
  def args; end

  # Returns the value of attribute failures.
  def failures; end

  # Execute concrete invoker, log the error and return result
  def invoke; end

  # Execute concrete invoker
  def invoke_subject; end

  # Log failed invoking
  def log_failure; end

  # Check if concrete invoker may be invoked for a specified subject
  def may_invoke?; end

  # Returns the value of attribute record.
  def record; end

  # Returns the value of attribute result.
  def result; end

  # Returns the value of attribute subject.
  def subject; end

  # Collect failures to a specified buffer
  #
  # ==Options:
  #
  # +failures+ - failures buffer to collect failures
  def with_failures(failures_buffer); end
end

# Class invoker which allows to use classes which respond to #call
# to be used as state/event/transition callbacks.
class AASM::Core::Invokers::ClassInvoker < ::AASM::Core::Invokers::BaseInvoker
  def invoke_subject; end
  def log_failure; end
  def may_invoke?; end

  private

  def instance; end
  def log_method_info; end
  def log_source_location; end
  def retrieve_instance; end
  def subject_arity; end
end

# Literal invoker which allows to use strings or symbols to call
# record methods as state/event/transition callbacks.
class AASM::Core::Invokers::LiteralInvoker < ::AASM::Core::Invokers::BaseInvoker
  def invoke_subject; end
  def log_failure; end
  def may_invoke?; end

  private

  def exec_subject; end
  def record_error; end
  def subject_arity; end
end

# Proc invoker which allows to use Procs as
# state/event/transition callbacks.
class AASM::Core::Invokers::ProcInvoker < ::AASM::Core::Invokers::BaseInvoker
  def invoke_subject; end
  def log_failure; end
  def may_invoke?; end

  private

  def exec_proc(parameters_size); end
  def log_proc_info; end
  def log_source_location; end
  def parameters_to_arity; end
  def support_parameters?; end
end

class AASM::Core::State
  def initialize(name, klass, state_machine, options = T.unsafe(nil)); end

  def <=>(state); end
  def ==(state); end

  # Returns the value of attribute default_display_name.
  def default_display_name; end

  def display_name; end
  def fire_callbacks(action, record, *args); end
  def for_select; end
  def human_name; end
  def localized_name; end

  # Returns the value of attribute name.
  def name; end

  # Returns the value of attribute options.
  def options; end

  # Returns the value of attribute state_machine.
  def state_machine; end

  def to_s; end

  private

  def _fire_callbacks(action, record, args); end

  # called internally by Ruby 1.9 after clone()
  def initialize_copy(orig); end

  def update(options = T.unsafe(nil)); end
end

class AASM::Core::Transition
  include ::AASM::DslHelper

  def initialize(event, opts, &block); end

  def ==(obj); end
  def allowed?(obj, *args); end

  # Returns the value of attribute event.
  def event; end

  def execute(obj, *args); end

  # Returns the value of attribute failures.
  def failures; end

  # Returns the value of attribute from.
  def from; end

  def from?(value); end
  def invoke_success_callbacks(obj, *args); end

  # Returns the value of attribute opts.
  def options; end

  # Returns the value of attribute opts.
  def opts; end

  # Returns the value of attribute to.
  def to; end

  private

  def _fire_callbacks(code, record, args); end

  # called internally by Ruby 1.9 after clone()
  def initialize_copy(orig); end

  def invoke_callbacks_compatible_with_guard(code, record, args, options = T.unsafe(nil)); end
end

module AASM::DslHelper
  def add_options_from_dsl(options, valid_keys, &block); end
end

class AASM::DslHelper::Proxy
  def initialize(options, valid_keys, source); end

  def method_missing(name, *args, &block); end

  # Returns the value of attribute options.
  def options; end

  # Sets the attribute options
  def options=(_arg0); end
end

class AASM::InstanceBase
  # instance of the class including AASM, name of the state machine
  def initialize(instance, name = T.unsafe(nil)); end

  # Returns the value of attribute current_event.
  def current_event; end

  # Sets the attribute current_event
  def current_event=(_arg0); end

  def current_state; end
  def current_state=(state); end
  def determine_state_name(state); end
  def enter_initial_state; end
  def events(options = T.unsafe(nil), *args); end
  def fire(event_name, *args, &block); end
  def fire!(event_name, *args, &block); end

  # Returns the value of attribute from_state.
  def from_state; end

  # Sets the attribute from_state
  def from_state=(_arg0); end

  def human_state; end
  def may_fire_event?(name, *args); end
  def permitted_transitions; end
  def set_current_state_with_persistence(state); end
  def state_object_for_name(name); end
  def states(options = T.unsafe(nil), *args); end

  # Returns the value of attribute to_state.
  def to_state; end

  # Sets the attribute to_state
  def to_state=(_arg0); end
end

class AASM::InvalidTransition < ::RuntimeError
  def initialize(object, event_name, state_machine_name, failures = T.unsafe(nil)); end

  # Returns the value of attribute event_name.
  def event_name; end

  # Returns the value of attribute failures.
  def failures; end

  # Returns the value of attribute object.
  def object; end

  # Returns the value of attribute originating_state.
  def originating_state; end

  def reasoning; end

  # Returns the value of attribute state_machine_name.
  def state_machine_name; end
end

class AASM::Localizer
  def human_event_name(klass, event); end
  def human_state_name(klass, state); end

  private

  def ancestors_list(klass); end

  # Can use better arguement name
  def default_display_name(object); end

  # added for rails < 3.0.3 compatibility
  def i18n_klass(klass); end

  # added for rails 2.x compatibility
  def i18n_scope(klass); end

  def item_for(klass, state, ancestor, options = T.unsafe(nil)); end
  def translate_queue(checklist); end
end

# this is used internally as an argument default value to represent no value
AASM::NO_VALUE = T.let(T.unsafe(nil), Symbol)

class AASM::NoDirectAssignmentError < ::RuntimeError; end

module AASM::Persistence
  class << self
    def load_persistence(base); end

    private

    def capitalize(string_or_symbol); end
    def constantize(string); end
    def include_persistence(base, type); end
    def require_persistence(type); end
  end
end

module AASM::Persistence::Base
  mixes_in_class_methods ::AASM::Persistence::Base::ClassMethods

  def aasm_new_record?; end

  # Returns the value of the aasm.attribute_name - called from <tt>aasm.current_state</tt>
  #
  # If it's a new record, and the aasm state column is blank it returns the initial state
  # (example provided here for ActiveRecord, but it's true for Mongoid as well):
  #
  # class Foo < ActiveRecord::Base
  # include AASM
  # aasm :column => :status do
  # state :opened
  # state :closed
  # end
  # end
  #
  # foo = Foo.new
  # foo.current_state # => :opened
  # foo.close
  # foo.current_state # => :closed
  #
  # foo = Foo.find(1)
  # foo.current_state # => :opened
  # foo.aasm_state = nil
  # foo.current_state # => nil
  #
  # NOTE: intended to be called from an event
  #
  # This allows for nil aasm states - be sure to add validation to your model
  def aasm_read_state(name = T.unsafe(nil)); end

  class << self
    def included(base); end
  end
end

module AASM::Persistence::Base::ClassMethods
  def aasm_column(attribute_name = T.unsafe(nil)); end
end

module AASM::Persistence::PlainPersistence
  # may be overwritten by persistence mixins
  def aasm_read_state(name = T.unsafe(nil)); end

  # may be overwritten by persistence mixins
  def aasm_write_state(new_state, name = T.unsafe(nil)); end

  # may be overwritten by persistence mixins
  def aasm_write_state_without_persistence(new_state, name = T.unsafe(nil)); end
end

class AASM::StateMachine
  def initialize(name); end

  def add_event(name, options, &block); end
  def add_global_callbacks(name, *callbacks, &block); end
  def add_state(state_name, klass, options); end

  # the following four methods provide the storage of all state machines
  def config; end

  # the following four methods provide the storage of all state machines
  def config=(_arg0); end

  # the following four methods provide the storage of all state machines
  def events; end

  # the following four methods provide the storage of all state machines
  def events=(_arg0); end

  # the following four methods provide the storage of all state machines
  def global_callbacks; end

  # the following four methods provide the storage of all state machines
  def global_callbacks=(_arg0); end

  # the following four methods provide the storage of all state machines
  def initial_state; end

  # the following four methods provide the storage of all state machines
  def initial_state=(_arg0); end

  # the following four methods provide the storage of all state machines
  def name; end

  # the following four methods provide the storage of all state machines
  def name=(_arg0); end

  # the following four methods provide the storage of all state machines
  def states; end

  # the following four methods provide the storage of all state machines
  def states=(_arg0); end

  private

  # called internally by Ruby 1.9 after clone()
  def initialize_copy(orig); end

  def set_initial_state(name, options); end
end

class AASM::StateMachineStore
  def initialize; end

  def [](name); end
  def clone; end
  def keys; end
  def machine(name); end
  def machine_names; end
  def register(name, machine, force = T.unsafe(nil)); end

  class << self
    def [](klass, fallback = T.unsafe(nil)); end

    # do not overwrite existing state machines, which could have been created by
    # inheritance, see AASM::ClassMethods method inherited
    def []=(klass, overwrite = T.unsafe(nil), state_machine = T.unsafe(nil)); end

    def fetch(klass, fallback = T.unsafe(nil)); end

    # do not overwrite existing state machines, which could have been created by
    # inheritance, see AASM::ClassMethods method inherited
    def register(klass, overwrite = T.unsafe(nil), state_machine = T.unsafe(nil)); end

    def stores; end
    def unregister(klass); end
  end
end

class AASM::UndefinedState < ::RuntimeError; end
class AASM::UnknownStateMachineError < ::RuntimeError; end
AASM::VERSION = T.let(T.unsafe(nil), String)
