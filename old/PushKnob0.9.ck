// PushKnob


public class PushKnob{
    Push p;
    
    MidiIn min;
    MidiMsg msg;
    int minPort;
    
    string cursorThing;
    string myLabel;
    string myText;
    
    int myKnob;        // which knob
    
    int displayLabel;  // whether to display or not
    int displayValue;
    int displayCursor;
    int displayText;
    
    int cStyle;        // cursor style
    
    int labelX;        // location for display elements
    int labelY;
    int valX;        
    int valY;
    int cursorX;
    int cursorY;
    int textX;
    int textY;
    
    int valStyle;    // Styles:
    float valScale;  // 0- Scaled float
    float valOffset; // 1- Scaled int (rounded float)
    int useValLabel; // 2- Frequency
    string valLabel;
    
    int touchMode;     // visible only on touch
    int touched;       // being touched currently (regardless of touchMode)
    
    int inFocus;       // only displays or reacts to input when in focus
    
    int selfInc;
    int selfUpdate;    // whether or not to Update the PushDisplay object
    
    int shift;
    
    float myVal;
    float myPos;
    float inc;
    
    int incVal;
    
    Event shiftOn;
    Event shiftOff;
    Event moved;
    Event touchOn;
    Event touchOff;
    Event increment;
    Event decrement;
    
    //=========== FUNCTIONS ============
    
    
    //======= --| INITIALIZERS |-- =====
    fun void init(){
        init(-1,p,2,"");
    }
    
    fun void init(int iKnob,Push ip,int port,string iLabel){
        if(iKnob>=0&iKnob<11){
            iKnob=>myKnob;
            if(iKnob<8){              //  Knobs 0-7, by default, display their info
                setLabelPos(iKnob,0); // directly below the knob in label, value,
                setValuePos(iKnob,1); // cursor order.
                setCursorPos(iKnob,2);
                setTextPos(iKnob,3);
                displaysValue(1);
                displaysCursor(1);
                displaysLabel(1);
                displaysText(0);
            }else{
                setLabelPos(0,0);
                setValuePos(0,0);
                setCursorPos(0,0);   
                setTextPos(0,0);
                displaysValue(0);    
                displaysCursor(0);   
                displaysLabel(0);  
                displaysText(0); 
            }
        }
        
        0=>useValLabel;
        ""=>valLabel;
        
        1=>valScale;
        0=>valOffset;
        
        1=>selfInc;
        0=>selfUpdate;
        0=>inFocus;
        
        0=>shift;
        
        0=>touchMode;
        
        ip@=>p;
        
        port=>minPort;
        
        label(iLabel);
        
        ""   =>cursorThing;
        0.5  =>      myPos;
        0.005=>        inc;
        
        if(!touchMode){
            displayUpdate();
        }
        spork~control();
        spork~shiftListen();
    }
    
    //======= --| SETTERS & GETTERS |-- =====
    
    // knob
    fun int knob(){
        return myKnob;
    }
    
    fun int knob(int nKnob){
        nKnob=>myKnob;
        if(nKnob>10)-1=>myKnob;
        if(nKnob<0)-1=>myKnob;
        return myKnob;
    }
    
    // pos
    fun float pos(){
        return myPos;
    }
    
    fun float pos(float nPos){
        while(nPos>1)1-=>nPos;
        while(nPos<0)1+=>nPos;
        nPos=>myPos;
        return myPos;
    }
    
    fun float incrementAmt(){
        return inc;
    }
    
    fun float incrementAmt(float nInc){
        nInc=>inc;
    }
    
    // value stuff
    fun float value(){
        return myVal;
    }
    
    fun float value(float val){
        val=>myVal;
        return myVal;
    }
    
    fun int valueStyle(){
        return valStyle;
    }
    
    fun int valueStyle(int s){
        if(s<0)0=>valStyle;
        else if(s>2)2=>valStyle;
        else s=>valStyle;
        return valStyle;
    }
    
    fun float valueScale(){
        return valScale;
    }
    
    fun float valueScale(float v){
        v=>valScale;
        1.0/v=>inc;
        return valScale;
    }
    
    fun float valueScale(int v){
        v$float=>valScale;
        return valScale;
    }
    
    fun float valueOffset(){
        return valOffset;
    }
    
    fun float valueOffset(float o){
        o=>valOffset;
        return valOffset;
    }
    
    fun float valueOffset(int o){
        o$float=>valOffset;
        return valOffset;
    }
    
    // label
    fun string label(){
        return myLabel;
    }
    
    fun string label(string nLabel){
        if(nLabel.length()>8){
            nLabel.substring(8)=>myLabel;
        }else if(nLabel.length()<8){
            while(nLabel.length()<8){
                " "+=>nLabel;
            }
            nLabel=>myLabel;
        }else nLabel=>myLabel;
        return myLabel;
    }
    
    fun int displaysLabel(){
        return displayLabel;
    }
    
    fun int displaysLabel(int d){
        if(d)1=>displayLabel;
        else 0=>displayLabel;
        return displayLabel;
    }
    
    fun int labelPosX(){
        return labelX;
    }
    
    fun int labelPosX(int x){
        if(x>7)7=>x;
        if(x<0)0=>x;
        x=>labelX;
        return labelX;
    }
    
    fun int labelPosY(){
        return labelY;
    }
    
    fun int labelPosY(int y){
        if(y>7)7=>y;
        if(y<0)0=>y;
        y=>labelY;
        return labelY;
    }
    
    fun void setLabelPos(int x,int y){
        if(x>7)7=>x;
        if(x<0)0=>x;
        if(y>7)7=>y;
        if(y<0)0=>y;
        x=>labelX;
        y=>labelY;
    }
    
    // value
    fun int displaysValue(){
        return displayValue;
    }
    
    fun int displaysValue(int d){
        if(d)1=>displayValue;
        else 1=>displayValue;
        return displayValue;
    }
    
    fun int valuePosX(){
        return valX;
    }
    
    fun int valuePosX(int x){
        if(x>7)7=>x;
        if(x<0)0=>x;
        x=>valX;
        return valX;
    }
    
    fun int valuePosY(){
        return valY;
    }
    
    fun int valuePosY(int y){
        if(y>7)7=>y;
        if(y<0)0=>y;
        y=>valY;
        return valY;
    }
    
    fun void setValuePos(int x,int y){
        if(x>7)7=>x;
        if(x<0)0=>x;
        if(y>7)7=>y;
        if(y<0)0=>y;
        x=>valX;
        y=>valY;
    }
    
    // cursor
    fun int displaysCursor(){
        return displayCursor;
    }
    
    fun int displaysCursor(int d){
        if(d)1=>displayCursor;
        else 1=>displayCursor;
        return displayCursor;
    }
    
    fun int cursorPosX(){
        return cursorX;
    }
    
    fun int cursorPosX(int x){
        if(x>7)7=>x;
        if(x<0)0=>x;
        x=>cursorX;
        return cursorX;
    }
    
    fun int displayPosY(){
        return cursorY;
    }
    
    fun int cursorPosY(int y){
        if(y>7)7=>y;
        if(y<0)0=>y;
        y=>cursorY;
        return cursorY;
    }
    
    fun void setCursorPos(int x,int y){
        x=>cursorX;
        y=>cursorY;
    }
    
    fun int cursorStyle(){
        return cStyle;
    }
    
    fun int cursorStyle(int nStyle){
        if(nStyle>=3)3=>cStyle;
        else if(nStyle<0)0=>cStyle;
        else nStyle=>cStyle;
        return cStyle;
    }
    
    // text
    fun string text(){
        return myText;
    }
    
    fun string text(string t){
        while(t.length()<8)" "+=>t;
        if(t.length()>8)t.substring(0,8)=>t;
        t=>myText;
    }
    
    fun int displaysText(){
        return displayText;
    }
    
    fun int displaysText(int d){
        if(d)1=>displayText;
        else 1=>displayText;
        return displayText;
    }
    
    fun int textPosX(){
        return textX;
    }
    
    fun int textPosX(int x){
        if(x>7)7=>x;
        if(x<0)0=>x;
        x=>textX;
        return textX;
    }
    
    fun int textPosY(){
        return textY;
    }
    
    fun int textPosY(int y){
        if(y>7)7=>y;
        if(y<0)0=>y;
        y=>textY;
        return textY;
    }
    
    fun void setTextPos(int x,int y){
        x=>textX;
        y=>textY;
    }
    
    // self increment
    
    fun int selfIncrement(){
        return selfInc;
    }
    
    fun int selfIncrement(int sI){
        sI=>selfInc;
        return selfInc;
    }
    
    // focus
    fun int focus(){
        return inFocus;
    }
    
    fun int focus(int f){
        f=>inFocus;
        if(inFocus){
            if(touchMode){
                if(touched){
                    displayUpdate();
                }
            }else displayUpdate();
        }else{
            if(!touched){
                clearValue();
                clearCursor();
            }
        }
        return inFocus;
    }
    
    //================= --| MIDI |-- ===============
    fun void control(){
        MidiIn min;
        MidiMsg msg;
        min.open(minPort);
        while(min=>now){
            while(min.recv(msg)){
                if(msg.data1==0xB0){
                    if(inFocus){
                        if(msg.data2==p.knobs[myKnob]){
                            if(msg.data3<64){
                                if(selfInc)msg.data3*inc+=>myPos; // increment
                                msg.data3=>incVal;
                                increment.broadcast();
                            }else{
                                if(selfInc)(128-msg.data3)*inc-=>myPos;      // decrement
                                (128-msg.data3)*-1=>incVal;
                                decrement.broadcast();
                            }
                            if(myPos>1)1=>myPos;       // clip to 0 and 1
                            if(myPos<0)0=>myPos;
                            displayUpdate();
                            moved.broadcast();
                        }else if(msg.data2==p.bcol0[0]){
                            if(msg.data3==0x7F)shiftOn.broadcast();   
                            else shiftOff.broadcast();                 
                        }
                    }
                }
                if(msg.data1==0x90){
                    if(msg.data2==p.touch[myKnob]){
                        if(msg.data3==127){
                            if(touchMode){
                                if(inFocus){
                                    displayUpdate();
                                }
                                touchOn.broadcast();
                                p.updateDisplay();
                                1=>touched;
                            }
                        }
                        else{
                            if(touchMode){
                                if(inFocus){
                                    clearCursor();
                                    clearValue();
                                    clearLabel();
                                }
                                touchOff.broadcast();
                                p.updateDisplay();
                                0=>touched;
                            }
                        }
                    }
                }
            }
        }
    }
    
    fun void shiftListen(){
        while(true){
            shiftOn=>now;
            0.1*=>inc;
            1=>shift;
            shiftOff=>now;
            10.0*=>inc;
            0=>shift;
        }
    }
    
    // display stuff
    
    fun void displayUpdate(){
        Math.round(myPos*16)$int=>int iPos;
        string dValue;
        myPos*valScale+valOffset=>myVal;
        if(valStyle==0){
            Std.ftoa(myVal,6)=>dValue;
        }else if(valStyle==1){
            Std.itoa(Math.round(myVal)$int)=>dValue;
            if(dValue.length()!=8){
                while(dValue.length()<8)" "+=>dValue;
                if(dValue.length()>8)dValue.substring(0,8)=>dValue;
            }
        }else if(valStyle==2){
            if(myVal<10){
                Std.ftoa(myVal,6)=>dValue;
                if(shift)<<<0.01/19980.0=>inc>>>;
                else 0.1/19980.0=>inc;
            }
            if(myVal<100){
                Std.ftoa(myVal,6)=>dValue;
                if(shift)0.1/19980=>inc;
                else 1.0/19980.0=>inc;
            }
            else if(myVal<1000){
                Std.ftoa(myVal,6)=>dValue;
                if(shift)1.0/19980.0=>inc;
                else 10.0/19980.0=>inc;
            }else{
                Std.itoa(Math.round(myVal)$int)=>dValue;
                if(shift)10.0/19980=>inc;
                else 100.0/19980.0=>inc;
            }
            while(dValue.length()<8)" "+=>dValue;
            dValue.replace(5," Hz");
        }
        if(useValLabel==1){
            dValue.replace(8-valLabel.length(),valLabel);
        }
        if(inFocus){
            if(displayCursor)makeCursor(cursorX,cursorY,cStyle);
            if(displayValue)p.setSubsegment(valX,valY,dValue);
            if(displayLabel)p.setSubsegment(labelX,labelY,myLabel);
            if(displayText)p.setSubsegment(textX,textY,myText);
            if((selfUpdate)&&(displayCursor|displayValue|displayLabel))p.updateDisplay();
        }
    }
    
    fun void clearValue(){
        p.setSubsegment(valX,valY,"");
        if(selfUpdate)p.updateDisplay();
    }
    
    fun void clearCursor(){
        p.setSubsegment(cursorX,cursorY,"");
        if(selfUpdate)p.updateDisplay();
    }
    
    fun void clearLabel(){
        p.setSubsegment(labelX,labelY,"");
        if(selfUpdate)p.updateDisplay();
    }
    
    fun void makeCursor(int c,int r,int style){
        (myPos*16)$int=>int iPos;
        if(style==0){
            if(iPos==0){
                "\005"=>cursorThing;
                for(0=>int i;i<15;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\004"=>cursorThing;
            }else if(iPos==16){
                "\003"=>cursorThing;
                for(0=>int i;i<15;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\005"=>cursorThing;
            }else{
                "\003"=>cursorThing;
                for(0=>int i;i<iPos-1;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\010"=>cursorThing;
                for(0=>int i;i<15-iPos;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\004"=>cursorThing;
            }
            p.setSegment(c,r,cursorThing);
            if(selfUpdate)p.updateDisplay();
        }
        else if(style==1){
            if(iPos==0){
                "\005"=>cursorThing;
            }
            else if(iPos==16){
                "\003"=>cursorThing;
                for(0=>int i;i<15;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\004"=>cursorThing;
            }
            else{
                "\003"=>cursorThing;
                for(0=>int i;i<iPos-1;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\010"=>cursorThing;
                
            }
            p.setSegment(c,r,cursorThing);
            if(selfUpdate)p.updateDisplay();
        }else if(style==2){
            if(iPos==0){
                "\005"=>cursorThing;
                for(0=>int i;i<7;i++){
                    cursorThing+"\006"=>cursorThing;
                }
            }
            else if(iPos==16){
                ""=>cursorThing;
                for(0=>int i;i<7;i++){
                    cursorThing+"\006"=>cursorThing;
                }
                cursorThing+"\005"=>cursorThing;
            }
            else{
                Math.round(myPos*15)$int=>int nPos;
                ""=>cursorThing;
                if((nPos%2)==0){
                    for(0=>int i;i<(nPos*0.5)$int-1;i++){
                        cursorThing+"\006"=>cursorThing;
                    }
                    cursorThing+"\004\003"=>cursorThing;
                    for(0=>int i;i<7-nPos*0.5;i++){
                        cursorThing+"\006"=>cursorThing;
                    }
                }else{
                    for(0=>int i;i<(nPos*0.5)$int;i++){
                        cursorThing+"\006"=>cursorThing;
                    }
                    cursorThing+"\005"=>cursorThing;
                    for(0=>int i;i<8-nPos*0.5;i++){
                        cursorThing+"\006"=>cursorThing;
                    }
                }
            }
            p.setSubsegment(c,r,cursorThing);
            if(selfUpdate)p.updateDisplay();
        }else if(style==3){
            Math.round(myPos*8)$int=>int iPos;
            ""=>cursorThing;
            for(0=>int i;i<Math.round(myPos*8)$int;i++){
                "\005"+=>cursorThing;
            }
            if(((myPos*16)$int %2)==1){
                for(0=>int i;i<8-iPos;i++){
                    "\006"+=>cursorThing;
                }
            }else{
                "\003"+=>cursorThing;
                for(0=>int i;i<7-iPos;i++){
                    "\006"+=>cursorThing;
                }
            }
            if(myPos==1){
                cursorThing.substring(0,8)=>cursorThing;
            }
            p.setSubsegment(c,r,cursorThing);
            if(selfUpdate)p.updateDisplay();
        }
    }
}
