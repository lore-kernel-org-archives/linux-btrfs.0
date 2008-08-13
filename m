From: Morey Roof <moreyroof@gmail.com>
Subject: New feature Idea
Date: Wed, 13 Aug 2008 11:57:53 -0600
Message-ID: <48A320A0.80609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have been thinking about a new feature to start work on that I am 
interested in and I was hoping people could give me some feedback and 
ideas of how to tackle it.  Anyways, I want to create a data 
deduplication system that can work in two different modes.  One mode is 
that when the system is idle or not beyond a set load point a background 
process would scan the volume for duplicate blocks.  The other mode 
would be used for systems that are nearline or backup systems that don't 
really care about the performance and it would do the deduplication 
during block allocation.

One of the ways I was thinking of to find the duplicate blocks would be 
to use the checksums as a quick compare.  If the checksums match then do 
a complete compare before adjusting the nodes on the files.  However, I 
believe that I will need to create a tree based on the checksum values.

So any other ideas and thoughts about this?

Thanks,

Morey
