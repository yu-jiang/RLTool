classdef rlaction < handle
    properties (SetAccess = private)
        Adata
        Size        
        Length
        % StateName
    end
    
    methods
        function this = rlaction(varargin)            
            this.Adata = varargin;
            this.Size = zeros(numel(this.Adata),1);
            for ct = 1:numel(this.Adata)
                this.Size(ct) = numel(this.Adata{ct});
            end            
            this.Length = prod(this.Size);
        end
        
        function actionIdx = getIndex(this, actionvalue)
            % actionvalue must have compatibe size with dim
            % states are linear indexed
            assert(numel(actionvalue) == numel(this.Size), 'wrong dimension!')
            actionafullidx = zeros(1, numel(this.Size)); % Initialization
            for ct = 1:numel(this.Size)
                actionafullidx(ct) = localgetindex(this.Adata{ct}, actionvalue(ct));
            end
            % convert to linear indexing
%             if numel(this.Size) == 1
%                 actionIdx = actionafullidx{1};
%             else
%                 actionIdx = sub2ind(this.Size, actionafullidx{:});
%             end
            actionIdx = sub2ind2(this.Size, actionafullidx); 
        end        
        
        function val = getValue(this, index)
            if isscalar(index) && numel(this.Size>1)
                index = ind2sub(this.Size, index);
            end
            val = this.Size; %Init
            for ct = 1:numel(this.Size)
                vec = this.Adata{ct};
                val(ct) = vec(index);
            end
        end
    end
end

function index = localgetindex(griddata, actionvalue)
if actionvalue <=  min(griddata)
    index = 1;
else
    index = find(griddata <= actionvalue, 1, 'Last');
end
end