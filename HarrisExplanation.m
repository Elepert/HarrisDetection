function HarrisExplanation
    % Adapted from: https://matlabcorner.wordpress.com/2012/11/17/does-harris-corner-detector-finds-corners-intuitive-explanation-to-harris-corner-detector/     
 
    % load image
    im = imread('light.jpg');

    % get matrix size
    [m,n] = size(im);
    eigenfeatures = containers.Map;
    index = 0;
    %index into every 100 by 100 pixel square with a 100 pixel step
    for i=1:100:(m-100)
        for j=1:100:(n-100)
            xpos_1 = j;
            ypos_1 = i;
            pos = [xpos_1, ypos_1, 100, 100];
            % create a dictionary of the sum of eigenvalues to the position
            % of the section
            eigenfeatures = Callback(pos,im,eigenfeatures);
            index = index+ 1;
        end
    end
    
    % list of the maximum eigenvalues
    maximumeigen = [0,0,0,0,0,0,0,0,0,0];
    % matrix of the positions of the maximum eigenvalues
    maximumpos = [1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1;1 1];
    % for every eigenvalue sum in eigenfeatures
    for indexer = keys(eigenfeatures)
        % convert the string value of the eigenvalue into a number again
        currentkey = indexer;
        eigenvalues = str2double(currentkey);
        % find the associated position values
        posvalues = values(eigenfeatures,currentkey);
        % index of eigenvalues
        eigenindex = 1;
        % index for positions
        posindex = 1;
        % has a value been replaced already?
        replaced = 0;
        % check if the current eigenvalue is larger than any eigenvalue
        % currently in maximumeigen
        while eigenindex < (length(maximumeigen)+1)
            % find the M miminimum value with index I
            [M,I] = min(maximumeigen);
            if eigenvalues > M
                % if we haven't already replaced a value in maximumeigen by
                % this value yet
                if replaced == 0
                    % replaced the current eigenvalue in maximumeigen by
                    % this larger value
                    maximumeigen(I) = eigenvalues;
                    % convert the type of the position
                    newposvalues = cell2mat(posvalues);
                    % store the x and y position of the eigenvalue in
                    % maximumpos
                    maximumpos(I*2-1) = newposvalues(1);
                    maximumpos(I*2) = newposvalues(2);
                    % a value has been replaced
                    replaced = 1;
                end
            end
            eigenindex = eigenindex + 1;
            posindex = posindex + 2;
        end
    end
    %disp(maximumeigen); 
    %disp(maximumpos);
    % draw the feature boxes on the image
    im = drawFeatures(im, maximumpos);
    % show image
    imshow(im);
end
 
function newfeatures = Callback(position,im, eigenfeatures)
    % upper left hand corner x,y position of 100x100 pixel square
    x1 = position(1);
    y1 = position(2);
    % lower right hand corner x,y position
    x2 = position(1) + position(3);
    y2 = position(2) + position(4);
    
    thumbnail = double(im(y1:y2,x1:x2));
    dx = [-1 0 1;
          -1 0 1;
          -1 0 1];
    dy = dx';
    % finds the intensity in the x and y directions
    Ix = conv2(thumbnail,dx,'valid');
    Iy = conv2(thumbnail,dy,'valid');
    
    % the H matrix
    H = [ sum(Ix(:).*Ix(:)) sum(Ix(:).*Iy(:)); sum(Ix(:).*Iy(:)) sum(Iy(:).*Iy(:)) ];
    % finds the eigenvalues and eigenvectors of H
    [V,vals] = eig(H);
 
    lambda(1) = vals(1,1);
    lambda(2) = vals(2,2);
    
    % adds the sum of the eigenvalues of one box and assigns the x and y
    % position of the box to it in the dictionary "newfeatures"
    newfeatures = eigenfeatures;
    newfeatures(mat2str((lambda(1)+lambda(2)))) = [x1, y1];
end

function RGB = drawFeatures(im, positions)
    % matrix of positions of each box with the width and height of the box
    A = [positions(1) positions(2) 100 100;
        positions(3) positions(4) 100 100;
        positions(5) positions(6) 100 100;
        positions(7) positions(8) 100 100;
        positions(9) positions(10) 100 100;
        positions(11) positions(12) 100 100;
        positions(13) positions(14) 100 100;
        positions(15) positions(16) 100 100;
        positions(17) positions(18) 100 100;
        positions(19) positions(20) 100 100];
    
    % create boxes at each location
    RGB = insertShape(im,'rectangle',A,'LineWidth',5);
   
end