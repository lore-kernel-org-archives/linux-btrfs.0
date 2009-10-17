From: John Dong <jdong@ubuntu.com>
Subject: Way to quickly "revert back" to a snapshot?
Date: Sat, 17 Oct 2009 13:20:28 -0400
Message-ID: <4AD9FCDC.6060107@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Suppose I want to do test something insane (like a massive OS update) to 
my system, and create a snapshot before doing so. Afterwards, if I 
decide my system is hosed and I'd like to revert back to the snapshot 
and forget any of this actually happened, what's the quickest way of 
doing it. It seems like by btrfs's design there should be a way to just 
"set the head" of the filesystem back to the snapshot, like git-reset, 
right?


John
