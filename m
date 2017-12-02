Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:53503 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbdLBAxk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 19:53:40 -0500
Date: Sat, 2 Dec 2017 01:53:39 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202005338.GA20205@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20171201213614.GE29898@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 21:36:14 +0000, Hugo Mills wrote:

>    The thing I'd first go looking for here is some rogue process
> writing lots of data. I've had something like this happen to me
> before, a few times. First, I'd look for large files with "du -ms /* |
> sort -n", then work down into the tree until you find them.

I already did a handful of searches (mounting parent node in separate
directory and diving into default working subvolume on order to unhide
possible things covered by any other mounts on top of actual root fs).
That's how it looks like:

[~/test/@]#  du -sh . 
15G     .

>    If that doesn't show up anything unusually large, then lsof to look
> for open but deleted files (orphans) which are still being written to
> by some process.

No (deleted) files, the only activity on iotop are internals...

  174 be/4 root       15.64 K/s    3.67 M/s  0.00 %  5.88 % [btrfs-transacti]
 1439 be/4 root        0.00 B/s 1173.22 K/s  0.00 %  0.00 % [kworker/u8:8]

Only the systemd-journald is writing, but the /var/log is mounted to
separate ext3 parition (with journald restarted after the mount); this
is also confirmed by looking into separate mount. Anyway that can't be
opened-deleted files, as the usage doesn't change after booting into
emergency. The worst thing is that the 8 GB was lost during the night,
when nothing except for stats collector was running.

As already said, this is not the classical "Linux eats my HDD" problem.

>    This is very likely _not_ to be a btrfs problem, but instead some
> runaway process writing lots of crap very fast. Log files are probably
> the most plausible location, but not the only one.

That would be visible in iostat or /proc/diskstats - it isn't. The free
space disappears without being physically written, which means it is
some allocation problem.


I also created a list of files modified between the snapshots with:

find test/@ -xdev -newer some_reference_file_inside_snapshot

and there is nothing bigger than a few MBs.


I've changed the snapshots to rw and removed some data from all the
instances: 4.8 GB in two ISO images and 5 GB-limited .ccache directory.
After this I got 11 GB freed, so the numbers are fine.

#  btrfs fi usage /
Overall:
    Device size:                 128.00GiB
    Device allocated:            117.19GiB
    Device unallocated:           10.81GiB
    Device missing:                  0.00B
    Used:                        103.56GiB
    Free (estimated):             11.19GiB      (min: 11.14GiB)
    Data ratio:                       1.98
    Metadata ratio:                   2.00
    Global reserve:              146.08MiB      (used: 0.00B)

Data,single: Size:1.19GiB, Used:1.18GiB
   /dev/sda2       1.07GiB
   /dev/sdb2     132.00MiB

Data,RAID1: Size:55.97GiB, Used:50.30GiB
   /dev/sda2      55.97GiB
   /dev/sdb2      55.97GiB

Metadata,RAID1: Size:2.00GiB, Used:908.61MiB
   /dev/sda2       2.00GiB
   /dev/sdb2       2.00GiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/sda2      32.00MiB
   /dev/sdb2      32.00MiB

Unallocated:
   /dev/sda2       4.93GiB
   /dev/sdb2       5.87GiB

>> Now, the weird part for me is exclusive data count:
>> 
>> # btrfs sub sh ./snapshot-171125
>> [...]
>>         Subvolume ID:           388
>> # btrfs fi du -s ./snapshot-171125 
>>      Total   Exclusive  Set shared  Filename
>>   21.50GiB    63.35MiB    20.77GiB  snapshot-171125
>> 
>> How is that possible? This doesn't even remotely relate to 7.15 GiB
>> from qgroup.~The same amount differs in total: 28.75-21.50=7.25 GiB.
>> And the same happens with other snapshots, much more exclusive data
>> shown in qgroup than actually found in files. So if not files, where
>> is that space wasted? Metadata?
> 
>    Personally, I'd trust qgroups' output about as far as I could spit
> Belgium(*).

Well, there is something wrong here, as after removing the .ccache
directories inside all the snapshots the 'excl' values decreased
...except for the last snapshot (the list below is short by ~40 snapshots
that have 2 GB excl in total):

qgroupid         rfer         excl 
--------         ----         ---- 
0/260        12.25GiB      3.22GiB	from 170712 - first snapshot
0/312        17.54GiB      4.56GiB	from 170811
0/366        25.59GiB      2.44GiB	from 171028
0/370        23.27GiB     59.46MiB 	from 111118 - prev snapshot
0/388        21.69GiB      7.16GiB	from 171125 - last snapshot
0/291        24.29GiB      9.77GiB	default subvolume


[~/test/snapshot-171125]#  du -sh .
15G     .


After changing back to ro I tested how much data really has changed
between the previous and last snapshot:

[~/test]#  btrfs send -p snapshot-171118 snapshot-171125 | pv > /dev/null
At subvol snapshot-171125
74.2MiB 0:00:32 [2.28MiB/s]

This means there can't be 7 GiB of exclusive data in the last snapshot.

Well, even btrfs send -p snapshot-170712 snapshot-171125 | pv > /dev/null
5.68GiB 0:03:23 [28.6MiB/s]

I've created a new snapshot right now to compare it with 171125:
75.5MiB 0:00:43 [1.73MiB/s]


OK, I could even compare all the snapshots in sequence:

# for i in snapshot-17*; btrfs prop set $i ro true
# p=''; for i in snapshot-17*; do [ -n "$p" ] && btrfs send -p "$p" "$i" | pv > /dev/null; p="$i" done
 1.7GiB 0:00:15 [ 114MiB/s]
1.03GiB 0:00:38 [27.2MiB/s]
 155MiB 0:00:08 [19.1MiB/s]
1.08GiB 0:00:47 [23.3MiB/s]
 294MiB 0:00:29 [ 9.9MiB/s]
 324MiB 0:00:42 [7.69MiB/s]
82.8MiB 0:00:06 [12.7MiB/s]
64.3MiB 0:00:05 [11.6MiB/s]
 137MiB 0:00:07 [19.3MiB/s]
85.3MiB 0:00:13 [6.18MiB/s]
62.8MiB 0:00:19 [3.21MiB/s]
 132MiB 0:00:42 [3.15MiB/s]
 102MiB 0:00:42 [2.42MiB/s]
 197MiB 0:00:50 [3.91MiB/s]
 321MiB 0:01:01 [5.21MiB/s]
 229MiB 0:00:18 [12.3MiB/s]
 109MiB 0:00:11 [ 9.7MiB/s]
 139MiB 0:00:14 [9.32MiB/s]
 573MiB 0:00:35 [15.9MiB/s]
64.1MiB 0:00:30 [2.11MiB/s]
 172MiB 0:00:11 [14.9MiB/s]
98.9MiB 0:00:07 [14.1MiB/s]
  54MiB 0:00:08 [6.17MiB/s]
78.6MiB 0:00:02 [32.1MiB/s]
15.1MiB 0:00:01 [12.5MiB/s]
20.6MiB 0:00:00 [  23MiB/s]
20.3MiB 0:00:00 [  23MiB/s]
 110MiB 0:00:14 [7.39MiB/s]
62.6MiB 0:00:11 [5.67MiB/s]
65.7MiB 0:00:08 [7.58MiB/s]
 731MiB 0:00:42 [  17MiB/s]
73.7MiB 0:00:29 [ 2.5MiB/s]
 322MiB 0:00:53 [6.04MiB/s]
 105MiB 0:00:35 [2.95MiB/s]
95.2MiB 0:00:36 [2.58MiB/s]
74.2MiB 0:00:30 [2.43MiB/s]
75.5MiB 0:00:46 [1.61MiB/s]

This is 9.3 GB of total diffs between all the snapshots I got.
Plus 15 GB of initial snapshot means there is about 25 GB used,
while df reports twice the amount, way too much for overhead:
/dev/sda2        64G   52G   11G  84% /


# btrfs quota enable /
# btrfs qgroup show /
WARNING: quota disabled, qgroup data may be out of date
[...]
# btrfs quota enable /		- for the second time!
# btrfs qgroup show /
WARNING: qgroup data inconsistent, rescan recommended
[...]
0/428        15.96GiB     19.23MiB 	newly created (now) snapshot



Assuming the qgroups output is bugus and the space isn't physically
occupied (which is coherent with btrfs fi du output and my expectation)
the question remains: why is that bogus-excl removed from available
space as reported by df or btrfs fi df/usage? And how to reclaim it?


[~/test]#  btrfs device usage /
/dev/sda2, ID: 1
   Device size:            64.00GiB
   Device slack:              0.00B
   Data,single:             1.07GiB
   Data,RAID1:             55.97GiB
   Metadata,RAID1:          2.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             4.93GiB

/dev/sdb2, ID: 2
   Device size:            64.00GiB
   Device slack:              0.00B
   Data,single:           132.00MiB
   Data,RAID1:             55.97GiB
   Metadata,RAID1:          2.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             5.87GiB

-- 
Tomasz Pala <gotar@pld-linux.org>
