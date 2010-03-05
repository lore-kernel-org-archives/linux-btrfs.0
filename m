From: Grady Neely <grady.neely@adtran.com>
Subject: Raid1 with 3 drives
Date: Fri, 5 Mar 2010 13:28:00 -0600
Message-ID: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a 3 1TB drives that I wanted to make a Raid1 system on.  I issued the following command "mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc /dev/sdd" And it seems to have created the fs, with no issue.  When I do an df -h, I see that the available space is 3TB.  Seems like with RAID1 I would only see 1TB available, and the other two drives would mirror the first.  Am I misunderstanding how the RAID1 works under btrfs?  Can you have more than two drives in RAID1 in btrfs, so you can survive multiple drive failures?  Is there a better option with only 3 drives?  I am not wedded to RAID1 if there is a better way.



Here is my uname -a:

Linux gemini 2.6.31-19-generic #56-Ubuntu SMP Thu Jan 28 01:26:53 UTC 2010 i686 GNU/Linux


And I am using btrfs 0.19.

Thank you,


