From: Alexander Koch <lynix47@googlemail.com>
Subject: btrfs-raid10 <-> btrfs-raid1 confusion
Date: Sun, 06 May 2012 16:48:48 +0200
Message-ID: <4FA68F50.60505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

until yesterday I was running a btrfs filesystem across two 2.0 TiB
disks in RAID1 mode for both metadata and data without any problems.

As space was getting short I wanted to extend the filesystem by two
additional drives lying around, which both are 1.0 TiB in size.

Knowing little about the btrfs RAID implementation I thought I had to
switch to RAID10 mode, which I was told is currently not possible (and
later found out that it is indeed).
Then I read this [1] mailing list post basically saying that, in the
special case of four disks, btrfs-raid1 behaves exactly like RAID10.

So I added the two new disks to my existing filesystem

    $ btrfs device add /dev/sde1 /dev/sdf1 /mnt/archive

and as the capacity reported by 'btrfs filesystem df' did not increase,
I started a balancing run:

    $ btrfs filesystem balance start /mnt/archive


Waiting for the balancing run to finish (which will take much longer
than I thought; still running) I found out that as of kernel 3.3
changing the RAID level (aka restriping) is now possible: [2].

I got two questions now:

1.) Is there really no difference between btrfs-raid1 and btrfs-raid10
    in my case (2 x 2TiB, 2 x 1TiB disks)? Same degree of fault
    tolerance?

2.) Summing up the capacities reported by 'btrfs filesystem df' I only
    get ~2.25 TiB for my filesystem, is that a realistic net size for
    3 TiB gross?

    $ btrfs filesystem df /mnt/archive
    Data, RAID1: total=2.10TB, used=1.68TB
    Data: total=8.00MB, used=0.00
    System, RAID1: total=40.00MB, used=324.00KB
    System: total=4.00MB, used=0.00
    Metadata, RAID1: total=112.50GB, used=3.21GB
    Metadata: total=8.00MB, used=0.00


Thanks in advance for any advice!

Regards,

lynix


[1] http://www.spinics.net/lists/linux-btrfs/msg15867.html
[2] https://lkml.org/lkml/2012/1/17/381
