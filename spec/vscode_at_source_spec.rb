# frozen_string_literal: true

RSpec.describe VscodeAtSource do
  describe ".open" do
    let(:dummy_class) { Class.new { def dummy_method; end } }
    let(:dummy_object) { dummy_class.new }

    context "when the method is defined in Ruby" do
      it "opens VSCode at the method's source location" do
        allow(dummy_object).to receive(:method).with(:dummy_method).and_return(double(source_location: [
                                                                                        "/path/to/file.rb", 42
                                                                                      ]))
        expect(VscodeAtSource).to receive(:system).with("code --goto /path/to/file.rb:42")

        VscodeAtSource.open(dummy_object, :dummy_method)
      end
    end

    context "when given a class" do
      it "creates an instance and opens VSCode at the method's source location" do
        expect(dummy_class).to receive(:new).and_return(dummy_class.new)
        allow_any_instance_of(dummy_class).to receive(:method).with(:dummy_method).and_return(double(source_location: [
                                                                                                       "/path/to/file.rb", 42
                                                                                                     ]))
        expect(VscodeAtSource).to receive(:system).with("code --goto /path/to/file.rb:42")

        VscodeAtSource.open(dummy_class, :dummy_method)
      end
    end

    context "when given an instance" do
      it "does not attempt to create a new instance and opens VSCode at the method's source location" do
        instance = dummy_class.new
        expect(dummy_class).not_to receive(:new)
        allow(instance).to receive(:method).with(:dummy_method).and_return(double(source_location: ["/path/to/file.rb",
                                                                                                    42]))
        expect(VscodeAtSource).to receive(:system).with("code --goto /path/to/file.rb:42")

        VscodeAtSource.open(instance, :dummy_method)
      end
    end

    context "when the method is not defined in Ruby" do
      it "outputs a message" do
        allow(dummy_object).to receive(:method).with(:dummy_method).and_return(double(source_location: nil))
        expect do
          VscodeAtSource.open(dummy_object,
                              :dummy_method)
        end.to output(/Method not defined in Ruby or file path not accessible./).to_stdout
      end
    end
  end
end
