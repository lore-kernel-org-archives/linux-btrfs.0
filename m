From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: btrfs always writes something after sync
Date: Tue, 6 Sep 2011 19:06:36 +0200
Message-ID: <CABVOS09hntXYUsCJBg+byEGC5y53j4DeT6b49Rx1AaRpqFV54A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When I check /proc/diskstats on mounted partitions before and after
'sync' on idle system, I can tell from write activity which partitions
are btrfs and which are ext3/ext4/swap.

On idle system after running sync, there is no activity on any
ext3/ext4/swap except root filesystem. But there are writes on all
btrfs filesystems.

Without 'sync' command btrfs behave well, and there is no read/write
activity on idle system to distinguish from ext4.

for example some btrfs and ext4 partition before and after sync:

# grep -P "dm-10|dm-6" /proc/diskstats
 253      10 dm-10 477158 0 26422280 33602927 2721495 0 26556408
216043746 0 7504653 249648820
 253       6 dm-6 11958 0 618266 431644 3315 0 26520 27535 0 147647 459184
# sync
# grep -P "dm-10|dm-6" /proc/diskstats
 253      10 dm-10 477158 0 26422280 33602927 2721724 0 26558408
216050353 0 7504999 249655428
 253       6 dm-6 11958 0 618266 431644 3315 0 26520 27535 0 147647 459184

in summary:
Field  5 -- # of writes completed increased from 2721495 to 2721724
(total 229 writes)
Field  7 -- # of sectors written increased from 26556408 to 26558408
(total 2000 sectors)
Field  8 -- # of milliseconds spent writing increased from 216043746
to 216050353 (total 6607 milliseconds)

and this repeats after each 'sync' with similar totals

My system is Fedora 15 kernel 2.6.40.3-2.fc15.i686.PAE (this is should
be 3.0.3 with some Fedora patches)


Thanks

Roman Kapusta
