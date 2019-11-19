%% clear
clear
clc

%% Initial the parameter
speed = 2; 
global snk_dir;
global snk_alive;
snk_alive = true;

%% draw layer
f = figure;
hold on

axis off
axis equal
for i = 0:10
    plot([i i],[0 10],'b') 
    plot([0 10],[i i],'b')
end

%% set key callback function
set(f, 'KeyPressFcn', @key_callback)

%% inital snake
snk = zeros(10,10);
% the snake matrix that indicate the previous state
snk_pre = zeros(10,10);
% apple
apple = zeros(10,10);
apple_pre = zeros(10,10);
apple_pos = fix(rand() * 100) + 1;

% generate the initial position of the snake
snk_head = fix(rand() * 100) + 1; 
snk_tail = snk_head;
% the previous head position & number of the snake
snk_head_pre = 0;
snk_head_pre_num = 1;
snk(snk_head) = 1;
% generate the initial travelling diraction of the snake 
% 1:up 2: left 3:down 4: right
snk_dir = fix(rand() * 4) + 1;

% re-generate apple if apple is on the snake
while apple_pos == snk_head
    apple_pos = fix(rand() * 100) + 1;
end
apple(apple_pos) = 1;
draw_snake(snk,snk_pre,apple,apple_pre);

%% move the snake
while snk_alive
   pause(1 / speed);
   snk_pre = snk;
   snk_head_pre_num = snk_pre(snk_head);
   snk_head_pre = snk_head;
   
   % detect fault
   if snk_head_pre <= 10 && snk_dir == 3
       fail(snk_head_pre_num); return;
   elseif mod(snk_head_pre,10) == 1 && snk_dir == 2
       fail(snk_head_pre_num); return;
   elseif mod(snk_head_pre,10) == 0 && snk_dir == 4
       fail(snk_head_pre_num); return;
   elseif snk_head_pre >= 91 && snk_dir == 1
       fail(snk_head_pre_num); return;
   else
       % did not fail
   end
   
   % move change the head and tail position depend on the set direction
   switch snk_dir
       case 1 
           snk_head = snk_head + 10;
       case 2
           snk_head = snk_head - 1;
       case 3
           snk_head = snk_head - 10;
       case 4
           snk_head = snk_head + 1;         
   end
   
   % update the snake data
   snk(snk_head) = snk_head_pre_num + 1;
   
   % if not eat the apple, set the snake position and number
   for i = 1:100
      if snk(i) > 0 && apple(snk_head) == 0
         snk(i) = snk(i) - 1; 
      end
   end
   
   % re-generate the apple, if the snake ate the apple
   
   apple = zeros(10,10);
   while snk(apple_pos) == 1
       apple_pos = fix(rand() * 100) + 1;
   end
   apple(apple_pos) = 1;
   draw_snake(snk,snk_pre,apple,apple_pre);
end

%% draw the snake
function draw_snake(snk,snk_pre,apple,apple_pre)
    % the gap between the cell and the grid to avoid cover on the grid
    padding = 0.01;
    % the size of the cell
    cell_size = 1;
    for i = 1:100
        % locate the cell
        pos_x = mod(i,10); % 1:9,0
        if pos_x == 0
           pos_x = 10; 
        end
        pos_y = ceil(i/10); % 1:10
        pos_x_abs = pos_x - 1 + padding;
        pos_y_abs = pos_y - 1 + padding;
        % draw the new place that the snake arrives
        if snk(i) > 0 && snk_pre(i) == 0
            rectangle('Position', [pos_x_abs, pos_y_abs, ...
                cell_size - 2*padding,...
                cell_size - 2*padding],...
                'FaceColor', 'y',...
                'EdgeColor', 'b')
        end
        % cancel the old place the the snake passed by
        if snk(i) == 0 && snk_pre(i) > 0
            rectangle('Position', [pos_x_abs, pos_y_abs, ...
                cell_size - 2*padding,...
                cell_size - 2*padding],...
                'FaceColor', 'w',...
                'EdgeColor', 'b')
        end
        % draw the new apple
        if apple(i) == 1 && apple_pre(i) == 0
            rectangle('Position', [pos_x_abs, pos_y_abs, ...
                cell_size - 2*padding,...
                cell_size - 2*padding],...
                'FaceColor', 'r',...
                'EdgeColor', 'b')
        end
        % cancel the old place the the snake passed by
        if apple(i) == 0 && apple_pre(i) == 1
            rectangle('Position', [pos_x_abs, pos_y_abs, ...
                cell_size - 2*padding,...
                cell_size - 2*padding],...
                'FaceColor', 'w',...
                'EdgeColor', 'b')
        end
    end
end

%% key callback function
function key_callback(src, event)
    global snk_dir;
    key = char(event.Key);
    if strcmp(key, 'uparrow')
        snk_dir = 1;
    end
    if strcmp(key, 'downarrow')
        snk_dir = 3;
    end
    if strcmp(key, 'leftarrow')
        snk_dir = 2;
    end
    if strcmp(key, 'rightarrow')
        snk_dir = 4;
    end
end

%% when the snack fails
function fail(score)
    global snk_alive
    snk_alive = false;
    disp('Snake failed: ')
    disp(score)
end