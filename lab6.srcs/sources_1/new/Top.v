`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/08 08:41:43
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input Clk,
    input Reset
    );
    reg IE_WB_regWrite;
    reg IE_WB_memToReg;
    reg [1:0]IE_M_branch;
    reg IE_M_memRead;
    reg IE_M_memWrite;
    reg IE_EX_regDst;
    reg [3:0]IE_EX_aluOp;
    reg IE_EX_aluSrc;
    reg [31:0] IE_EX_INST;
    reg IE_EX_shift;
    
    
    
    reg EM_WB_regWrite;
    reg EM_WB_memToReg;
    reg [1:0]EM_M_branch;
    reg EM_M_memRead;
    reg EM_M_memWrite;
    
    
    
    
    reg MW_WB_regWrite;
    reg MW_WB_memToReg;
    
    // IF Stage
    reg [31:0] PC;
    wire [31:0] nextPC;
    reg [31:0] ID_nextPC;
    reg [31:0] EX_nextPC;
    wire [31:0] EX_branchPC;
    reg [31:0] MEM_branchPC;
    assign nextPC = PC + 4;
    wire [31:0] INST;
    reg [31:0] ID_INST;
    InstMemory IM (
        .addr(PC),
        .inst(INST)
    );
    
    // ID Stage
    wire regDst;
    wire aluSrc;
    wire memToReg;
    wire regWrite;
    wire memRead;
    wire memWrite;
    wire [1:0]branch;
    wire [3:0] aluOp;
    wire jump;
    wire shift;
    reg ctlReset;
    Ctr control(
        .reset(ctlReset),
        .funct(ID_INST[5:0]),
        .opCode(ID_INST[31:26]),
        .regDst(regDst),
        .aluSrc(aluSrc),
        .memToReg(memToReg),
        .regWrite(regWrite),
        .memRead(memRead),
        .memWrite(memWrite),
        .branch(branch),
        .aluOp(aluOp),
        .jump(jump),
        .shift(shift)
    );
    reg [4:0] EX_writeAddr;
    reg [4:0] MEM_writeAddr;
    reg [4:0] WB_writeAddr;
    
    reg [31:0] WB_writeData;
    wire [31:0] readData1;
    reg [31:0] EX_readData1;
    wire [31:0] readData2;
    reg [31:0] EX_readData2;
    Registers r0(
        .Clk(Clk),
        .Reset(Reset),
        .readReg1(ID_INST[25:21]),
        .readReg2(ID_INST[20:16]),
        .writeReg(WB_writeAddr),
        .writeData(WB_writeData),
        .regWrite(MW_WB_regWrite),
        .readData1(readData1),
        .readData2(readData2)
    );
    
    wire [31:0] SIGNEXT;
    reg [31:0] EX_SIGNEXT;
    signext s0(
        .inst(ID_INST[15:0]),
        .data(SIGNEXT)
    );
    
    // EX Stage
    wire [4:0] aluCtrOut;
    ALUCtr ac0(
        .funct(EX_SIGNEXT[5:0]),
        .aluOp(IE_EX_aluOp),
        .aluCtrOut(aluCtrOut)
    );
    always @ (IE_EX_INST or IE_EX_regDst)
    begin
        EX_writeAddr = IE_EX_regDst ? IE_EX_INST[15:11] : IE_EX_INST[20:16];
    end
    
    reg [31:0] ALUInput2;
    reg [31:0] MEM_ALUInput2;
    reg [31:0] ALUInput1;
    wire Zero;
    reg MEM_Zero;
    wire [31:0] aluRes;
    reg [31:0] MEM_aluRes;
    reg [31:0] WB_aluRes;
    
    
    ALU a0(
        .input1(ALUInput1),
        .input2(ALUInput2),
        .aluCtr(aluCtrOut),
        .zero(Zero),
        .aluRes(aluRes)
    );
    
    assign EX_branchPC = (EX_SIGNEXT << 2) + EX_nextPC;
    
    // MEM Stage
    wire [31:0] mreadData;
    reg [31:0] WB_mreadData;
    reg [31:0] EX_writeData;
    reg [31:0] writeData;
    
    dataMemory dm(
        .Clk(Clk),
        .address(MEM_aluRes),
        .writeData(writeData),
        .memWrite(EM_M_memWrite),
        .memRead(EM_M_memRead),
        .readData(mreadData)
    );
    
    always @(IE_EX_aluSrc or EX_SIGNEXT or EX_readData2 or mreadData)
    begin
        if (IE_EX_INST[20:16] == MEM_writeAddr && EM_WB_regWrite)
            EX_writeData = EM_WB_memToReg ? mreadData : MEM_aluRes;
        else if (IE_EX_INST[20:16] == WB_writeAddr && MW_WB_regWrite)
            EX_writeData = WB_aluRes;
        else EX_writeData = EX_readData2;
            
        if (IE_EX_aluSrc)
            ALUInput2 = EX_SIGNEXT;
        else ALUInput2 = EX_writeData;
    end
    always @(IE_EX_shift or EX_SIGNEXT or EX_readData1 or mreadData)
    begin
        if (IE_EX_shift)
            ALUInput1 = EX_SIGNEXT;
        else if (IE_EX_INST[25:21] == MEM_writeAddr && EM_WB_regWrite)
            ALUInput1 = EM_WB_memToReg ? mreadData : MEM_aluRes;
        else if (IE_EX_INST[25:21] == WB_writeAddr && MW_WB_regWrite)
            ALUInput1 = WB_aluRes;
        else ALUInput1 = EX_readData1;
    end
    
    // WB Stage
    always @(MW_WB_memToReg or WB_mreadData or WB_aluRes)
    begin
        WB_writeData = MW_WB_memToReg ? WB_mreadData : WB_aluRes;
    end
    
    
    // PC Write
    always @(posedge Clk, posedge Reset)
    begin
        if (Reset == 1)
            PC <= 8'h00000000;
        else
            begin
                if ((MEM_Zero && EM_M_branch == 2'b01) || (!MEM_Zero && EM_M_branch == 2'b11)) // predict fail, flush and jump
                begin
                    PC <= MEM_branchPC;
                    IE_WB_regWrite <= 0;
                    IE_WB_memToReg <= 0;
                    IE_M_branch <= 0;
                    IE_M_memRead <= 0;
                    IE_M_memWrite <= 0;
                    IE_EX_regDst <= 0;
                    IE_EX_aluOp <= 0;
                    IE_EX_aluSrc <= 0;
                    IE_EX_shift <= 0;
                    
                    ID_INST <= 32'b11111111111111111111111111111111;
                    
                    EM_WB_regWrite <= 0;
                    EM_WB_memToReg <= 0;
                    EM_M_branch <= 0;
                    EM_M_memRead <= 0;
                    EM_M_memWrite <= 0;
                    
                    
                end
                else
                begin
                    if (IE_M_memRead && (ID_INST[20:16] == EX_writeAddr || ID_INST[25:21] == EX_writeAddr )&&ID_INST[31:26]!=6'b100011) // lw stall
                    begin
                        IE_WB_regWrite <= 0;
                        IE_WB_memToReg <= 0;
                        IE_M_branch <= 0;
                        IE_M_memRead <= 0;
                        IE_M_memWrite <= 0;
                        IE_EX_regDst <= 0;
                        IE_EX_aluOp <= 0;
                        IE_EX_aluSrc <= 0;
                        IE_EX_shift <= 0;
                    
                    end
                    else
                    begin
                        if (ID_INST[31:26] == 6'b000011)    // jal 在 ID阶段给一个stall 
                            begin
                                // PC 不更新
                                // ID阶段清空
                                ID_INST <= 32'b11111111111111111111111111111111;
                                PC <= {nextPC[31:28],{ID_INST[25:0]},2'b00};
                            end
                        else 
                        begin
                            ID_INST <= INST;
                            if (INST[31:26] == 6'b000010) // jump
                                PC <= {nextPC[31:28],{INST[25:0]},2'b00};
                            else if(ID_INST[31:26] == 6'b000000 && ID_INST[5:0] == 5'b001000) // jr
                                begin
                                    ID_INST <= 32'b11111111111111111111111111111111;    // 一个stall
                                    if (IE_WB_regWrite && INST[25:21] == EX_writeAddr)  // forwarding
                                        PC <=  aluRes << 2;
                                    else if (EM_WB_regWrite && INST[25:21] == MEM_writeAddr)
                                        PC <= EM_WB_memToReg ? (mreadData << 2) : (MEM_aluRes << 2);
                                    else if (MW_WB_regWrite && INST[25:21] == WB_writeAddr)
                                        PC <= WB_aluRes << 2;
                                    else PC <= readData1 << 2;
                                end
                            else
                                PC <= nextPC;
                        end
                        
                        ID_nextPC <= nextPC;
                        
                        IE_WB_regWrite <= regWrite;
                        IE_WB_memToReg <= memToReg;
                        IE_M_branch <= branch;
                        IE_M_memRead <= memRead;
                        IE_M_memWrite <= memWrite;
                        IE_EX_regDst <= regDst;
                        IE_EX_aluOp <= aluOp;
                        IE_EX_aluSrc <= aluSrc;
                        IE_EX_shift <= shift;
                    end
                   
                
                    EM_WB_regWrite <= IE_WB_regWrite;
                    EM_WB_memToReg <= IE_WB_memToReg;
                    EM_M_branch <= IE_M_branch;
                    EM_M_memRead <= IE_M_memRead;
                    EM_M_memWrite <= IE_M_memWrite;
                end
                
                if (IE_EX_INST[31:26] == 6'b000011)  // jal
                    begin
                        MEM_aluRes <= EX_nextPC >> 2;
                        MEM_writeAddr <= 5'b11111;
                    end
                else
                    begin
                        MEM_aluRes <= aluRes;
                        MEM_writeAddr <= EX_writeAddr;
                    end
                WB_mreadData <= mreadData;
                WB_aluRes <= MEM_aluRes;
                
                MEM_Zero <= Zero;
                
                writeData <= EX_writeData;
                EX_readData2 <= readData2;
                EX_readData1 <= readData1;
                if(ID_INST[31:26] == 001001 || ID_INST[31:26] == 001100 || ID_INST[31:26] == 001101 || ID_INST[31:26] == 001110 || ID_INST[31:26] == 001011)
                    EX_SIGNEXT <= ID_INST[15:0];
                else EX_SIGNEXT <= SIGNEXT;
                WB_writeAddr <= MEM_writeAddr;
                
                IE_EX_INST <= ID_INST;
                
                MEM_branchPC <= EX_branchPC;
                EX_nextPC <= ID_nextPC;
                
                MW_WB_memToReg <= EM_WB_memToReg;
                MW_WB_regWrite <= EM_WB_regWrite;
                
                
                
            end
            
    end
    
    initial begin
        ctlReset = 0;
        ID_INST = 32'b11111111111111111111111111111111;
        IE_EX_INST = 0;
        IE_M_branch = 0;
        EM_M_branch = 0;
        MEM_Zero = 0;
    end
    
    
    
endmodule
