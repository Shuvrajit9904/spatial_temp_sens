%% Calib timing file , @author kirang/shuvrajitm, @version 02-05-2018
% select block 1 if you want to stimulate
%%-------------------------------------------------------------------------
%% Variables, experimenter can either edit variable by using "V" while the task is paused on ML or edit variable in the next section 
% editable('fixationWindow', 'wait4fix','holdonFix','delayAfterReward','interval','goodboy');

%%-------------------------------------------------------------------------
%% Edit variables
% Location parameters
disp('Starting expt');
fixation_window=3;                                                                                                        

%Timing and check points
wait_for_fix=4000;                                                                                                          
hold_on_fix=1500;                                                                                                         
interval=3000;                                                                                                          

% Error Codes
CORRECT = 0;
NO_RESPONSE = 1; 
BRK_FIXATION = 3;
NO_FIXATION = 4;
EARL_RESPONSE = 5;
INCORR_RESPONSE = 6;
LEVER_BREAK = 7;
IGNORED = 8;
ABORT = 9;

% Objects : Images and stimulus (Do not change these!)
fixation_point=1;                                                                                                    
o1 = 2;
o2 = 3;
phd_point = 4;

set_iti(interval);

%Task
toggleobject(fixation_point, 'status', 'on');

% Acquire Fixation
if ~eyejoytrack('acquirefix', fixation_point, fixation_window, wait_for_fix)
   trialerror(NO_FIXATION); 
   return;
end
disp('Fix Acquired');

disp('Hold Fix Started');
% Check for fixation hold
if ~eyejoytrack('holdfix', fixation_point, fixation_window, interval)
   trialerror(BRK_FIXATION);
   return;
end
disp('Hold Fix ended');

% Show objects
toggleobject([o1 o2], 'status', 'on');
if ~eyejoytrack('holdfix', fixation_point, fixation_window, hold_on_fix)
   trialerror(BRK_FIXATION);
   toggleobject([o1 o2], 'status', 'off');
   return;
end

disp('Press Key');
scancode = '';
flag = 1;
time = 0;
while(flag)
    time = time + 50;
    scancode = getkeypress(50);
    fix_held = eyejoytrack('holdfix', fixation_point, fixation_window, 50);
    if (time > 2000 | scancode)
       flag = 0; 
    end
    if ~fix_held
        trialerror(BRK_FIXATION);
        return;
    end
end
% Left for 1.
if scancode ~= 203 & scancode ~= 205
   trialerror(NO_RESPONSE);
   disp('No or inappropriate response');
   return;
end

if TrialRecord.CurrentCondition == 1
    if  scancode == 203
       trialerror(CORRECT);
       toggleobject([o1, o2], 'status', 'off');
       disp('Correct response for 1 stimulus');
       return;
    else
        trailerror(INCORR_RESPONSE);
        toggleobject([o1, o2], 'status', 'off');
       disp('Incorrect response for 1 stimulus');
    end
end

if TrialRecord.CurrentCondition == 2
    if  scancode == 205
       trialerror(CORRECT);
       toggleobject([o1, o2], 'status', 'off');
       disp('Correct response for 2 stimuli');
       return;
    else
        trailerror(INCORR_RESPONSE);
        toggleobject([o1, o2], 'status', 'off');
       disp('Incorrect response for 2 stimuli');
    end
end
return;