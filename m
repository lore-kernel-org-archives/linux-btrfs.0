From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: How to expand a BTRFS partition... backwards
Date: Sun, 2 May 2010 07:32:34 +0200
Message-ID: <j2v8a48dc7a1005012232pa765876fscc41e97b940333de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys,

I kinda figured out the syntax for resizing BTRFS arrays, but is it
possible to use free space that is behind the current BTRFS partition?
I kinda figure it's not, but ideally I'd like it so that there is no
unused disk space on the disk.

My partition setup looks something like this:

Partition 1: 100MB (used)
Partition 2: 256MB (not used, this is what I want to use)
Partition 3: 200GB (used, for BTRFS)
Partition 4: 50GB (not used, but this will be expanded to the current
BTRFS partition)

Also as a last note (just in case I've misunderstood something), to
resize properly, you should first delete the partition using a
partition editor like fdisk, then recreate a new partition with the
same start cylinders as the original setup, but with bigger/later end
cylinders than the original setup, right? Then e.g. btrfsctl -r +45G /
What if I have a RAID-0 array (which I do), which uses the RAID-0
routine by BTRFS (and not mdraid or dmraid). Should I then do a
"btrfsctl -R +(size*disks)G /" or btrfsctl -R +(size of all disks)G
/"?

Regards,
Sebastian J.
