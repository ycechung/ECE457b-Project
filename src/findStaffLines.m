function foundLines = findStaffLines( sheet , algorithm , varargin )
    % Brief: Determines vertical positions of staff lines for given sheet of music using specified algorithm.
    %
    %     foundLines = findStaffLines( sheet , algorithm , ... )
    %
    % Outputs:
    %     foundLines - Each row of represents a found staff line and is a 1 by N vector, where N is the
    %     number of columns of the sheet image data (ie. width of sheet in pixels), that contain
    %     vertical positions of each line corresponding to each horizontal position (ie. vector of y
    %     values for each x value represented by index into vector) with respect to top of sheet.
    %
    % Inputs:
    %     sheet - Thresholded image data for sheet of music; entries > 0 considered features, <= 0 is background
    %     algorithm - String defining detection algorithm to be used; more details below.
    %
    % NOTES:
    %     - Additional parameters for specific algorithms can be appended at the end.
    %
    % Valid options for algorithm and their parameters are provided below:
    %
    %     simple: Simplest method of staff line detection using horizontal projection.
    [ M , N ] = size(sheet);
    
    if strcmp( algorithm , 'simple' )
        %% simple
        features = sheet > 0;
        projH = sum(features,2);
        lines = find( projH > 0 );
        if nargin == 2
            minPercentage = 0.95;
        else
            minPercentage = varargin(1);
        end
        average = mean( projH(lines) );
        while sum( projH(lines) < minPercentage * average ) > 0
            lines = find( projH >= minPercentage * average );
            average = mean( projH(lines) );
        end
        foundLines = repmat( lines , 1 , N );
    else
        %% error
        error( 'Invalid algorithm specified' );
    end
end
