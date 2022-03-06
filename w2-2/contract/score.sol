//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IScore{
    function updateScore(address student, uint score)  external;
}

contract Teacher{
    function updateScore(address _score,address student, uint score) external{
        IScore(_score).updateScore(student, score);
    }
}

contract Score is IScore{
    mapping(address => uint) public scores;
    address public _teacher;

    modifier onlyTeacher(){
        require(isTeacher(), "Function accessible only by the teacher !");
        _;
    }

    function isTeacher() public view returns(bool){
        return msg.sender == _teacher;
    }

    constructor(address teacher){
        _teacher = teacher;
    }

    function updateScore(address student, uint score) onlyTeacher public{
        require(score>=0 && score<=100, "score can't >100 or <0");
        scores[student] = score;
    }
}