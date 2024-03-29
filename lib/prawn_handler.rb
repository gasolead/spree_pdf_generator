require 'prawn'

module ActionView
  module Template::Handlers
    class Prawn 
      def self.register!
        Template.register_template_handler :prawn, self
      end
            
      def self.call(template)
        %(extend #{DocumentProxy}; #{template.source}; pdf.render)
      end
      
      module DocumentProxy
        def pdf
          @pdf ||= ::Prawn::Document.new(Spree::PdfGenerator::Config[:prawn_options])
        end
        
      private
      
        def method_missing(method, *args, &block)
          pdf.respond_to?(method) ? pdf.send(method, *args, &block) : super
        end
      end
    end
  end
end

ActionView::Template::Handlers::Prawn.register!
