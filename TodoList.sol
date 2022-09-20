//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// Hands on Task (Intermediate Level): Build and Deploy a To-Do List
// Owner: 0xbabacA9617a2cC30bC34A18E5F251F4Bd8CAbfac
// Contract Address: 0x1435eCd483DC3c00e6B9Acc5538a56e96e021e14
contract TodoList{
    
    // Store all the tasks
    struct ToDo {
        string text;
        bool isCompleted;
    }

    ToDo[] public todos;

    // Create a task
    function create(string calldata _text) external {
        todos.push(ToDo({
            text: _text,
            isCompleted: false
        }));
    }

    // Get the to-do list
    function updateText(uint _index, string calldata _text) external {
        todos[_index].text = _text;

        // Alternative implementation
        // ToDo storage todo = todos[_index];
        // todo.text = _text;
    }

    // Get the list
    function get(uint _index) external view returns (string memory text, bool isCompleted) {
        ToDo storage todo = todos[_index];
        return (todo.text, todo.isCompleted);
    }
    
    // Update if the task completed or something went wrong about completed tasks
    function complete(uint _index) external {
        todos[_index].isCompleted = !todos[_index].isCompleted;
    }

}