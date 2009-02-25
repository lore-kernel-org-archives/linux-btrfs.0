From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Performance results on Experimental branch
Date: Wed, 25 Feb 2009 15:07:33 -0600
Message-ID: <49A5B315.9070805@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Have completed the first run of the experimental  branch on my RAID 
system and the results are encouraging.

Compared to 2.6.29-rc2:
Large file creates  increase 50% plus across all thread counts.
Mail Server is up about 20%
Random reads  are pretty much flat
Random Writes are up 50% or more
Sequential reads took a 10% hit on single thread, but 20% gain on 128 
threads.

All in all good progress.  Results and graphs can be found here:

http://btrfs.boxacle.net/repository/raid/history/History.html

Steve
