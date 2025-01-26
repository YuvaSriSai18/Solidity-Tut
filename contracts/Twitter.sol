// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Twitter {
    uint16 public MAX_TWEET_LENGTH = 280;

    // Struct to store tweet data
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    // Mapping to store tweets by user
    mapping(address => Tweet[]) private tweets;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You aren't the owner!");
        _;
    }

    // Change tweet length
    function changeTweetLength(uint16 length) public onlyOwner {
        MAX_TWEET_LENGTH = length;
    }

    // Event for tweet creation
    event TweetCreated(
        uint256 id,
        address author,
        string content,
        uint256 timestamp
    );

    // Event for tweet liked
    event TweetLiked(
        address indexed liker,
        address indexed author,
        uint256 tweetId,
        uint256 likes
    );

    // Event for tweet unliked
    event TweetUnliked(
        address indexed unliker,
        address indexed author,
        uint256 tweetId,
        uint256 likes
    );

    // Create a new tweet
    function createTweet(string memory _content) public {
        require(bytes(_content).length > 0, "Tweet content cannot be empty");
        require(
            bytes(_content).length <= MAX_TWEET_LENGTH,
            "Tweet is too long"
        );
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length + 1,
            author: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id , newTweet.author, newTweet.content, newTweet.timestamp);
    }

    // Like a tweet
    function likeTweet(uint256 _tweet_id, address _author) external {
        require(_tweet_id > 0, "Invalid tweet ID");
        require(_tweet_id <= tweets[_author].length, "Tweet doesn't exist");

        Tweet storage tweet = tweets[_author][_tweet_id - 1];
        tweet.likes++;

        emit TweetLiked(msg.sender, _author, _tweet_id, tweet.likes);
    }

    // Unlike a tweet
    function unlikeTweet(uint256 _tweet_id, address _author) external {
        require(_tweet_id > 0, "Invalid tweet ID");
        require(_tweet_id <= tweets[_author].length, "Tweet doesn't exist");

        Tweet storage tweet = tweets[_author][_tweet_id - 1];
        require(tweet.likes > 0, "No likes to remove");
        tweet.likes--;

        emit TweetUnliked(msg.sender, _author, _tweet_id, tweet.likes);
    }

    // Get a specific tweet by user and index
    function getTweet(address _author, uint256 _idx)
        public
        view
        returns (Tweet memory)
    {
        require(_idx < tweets[_author].length, "Invalid tweet index");
        return tweets[_author][_idx];
    }

    // Get all tweets of a user
    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
