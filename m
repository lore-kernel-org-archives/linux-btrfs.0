From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: btrfs thinks its full
Date: Wed, 19 Nov 2008 17:24:34 -0500
Message-ID: <20081119222434.GA29942@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because the last bug I dealt with had so much to do with the disk being
full I decided to test and see what happens when I fill up the disk.
Unfortunatly the disk thinks its full before it actually is. I have a
7539M btrfs partition and tried to fill it by doing

dd if=/dev/zero of=/mnt/btrfs/fill

btrfs reports its full after 6408M have been used. dd, ls, and df all
confirm this. This uses only 85% of the disk but I can not put one more
bit onto the partition. The only thing that shows up in my system logs
is "space info full 1." I am using the latest git sources.

Lee
