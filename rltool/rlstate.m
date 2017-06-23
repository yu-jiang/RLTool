classdef rlstate < handle
    properties (SetAccess = private)
        Xdata
        Size        
        Length
        % StateName
    end
    
    methods
        function this = rlstate(varargin)            
            this.Xdata = varargin;
            this.Size = zeros(numel(this.Xdata),1);
            for ct = 1:numel(this.Xdata)
                this.Size(ct) = numel(this.Xdata{ct});
            end            
            this.Length = prod(this.Size);
        end
        
        function stateIdx = getIndex(this, statevalue)
            % statevalue must have compatibe size with dim
            % states are linear indexed
            assert(numel(statevalue) == numel(this.Size), 'wrong dimension!')
            statefullIdx = cell(1, numel(this.Size)); % Initialization
            for ct = 1:numel(this.Size)
                statefullIdx{ct} = localgetindex(this.Xdata{ct}, statevalue(ct));
            end
            % convert to linearindexing  
            if numel(this.Size) == 1
                stateIdx = statefullIdx{1};
            else
            stateIdx = sub2ind(this.Size, statefullIdx{:});
            end
        end        
        
%         function val = getValue(this, index)
%             if isscalar(index) && numel(this.Size>1)
%                 index = ind2sub(this.Size, index);
%             end            
%             val = this.Size; %Init
%             for ct = 1:numel(this.Size)
%                 vec = this.Xdata{ct};
%                 val(ct) = vec(index);
%             end            
%         end
    end
end

function index = localgetindex(griddata, statevalue)
if statevalue <=  min(griddata)
    index = 1;
else
    index = find(griddata <= statevalue, 1, 'Last');
end
end