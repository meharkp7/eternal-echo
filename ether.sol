// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TimelockedStorage {
    struct Entry {
        string data;
        uint256 unlockTime;
    }

    mapping(address => Entry) private entries;

    event DataStored(address indexed user, uint256 unlockTime);
    event DataRetrieved(address indexed user, string data);

    function storeData(string memory _data) external {
        uint256 _unlockTime = block.timestamp + 10; // Auto-lock for 10 seconds

        entries[msg.sender] = Entry({
            data: _data,
            unlockTime: _unlockTime
        });

        emit DataStored(msg.sender, _unlockTime);
    }

    function retrieveData() external view returns (string memory) {
        Entry storage entry = entries[msg.sender];
        require(block.timestamp >= entry.unlockTime, "Data is still locked");

        return entry.data;
    }
}
