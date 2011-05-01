From: =?UTF-8?Q?Claes_Gyllensw=C3=A4rd?= <letharion@gmail.com>
Subject: Btrfs raid1 "full sized"?
Date: Sun, 1 May 2011 20:33:23 +0200
Message-ID: <BANLkTikthjOMgrF6pCGMGNABXitKxdNzmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've tried setting up a raid1 on two drives like this:

mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc

Then I copy my old install onto the new drives, and check the drives' status:

# mount | grep "on / "
/dev/sdb on / type btrfs (rw,noatime)
# btrfs fi df /
Data, RAID1: total=259.00GB, used=256.64GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=44.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=4.50GB, used=1.27GB
Metadata: total=8.00MB, used=0.00
# btrfs fi show
Label: none  uuid: c6c89292-ea29-484c-ad29-9003a5fedf90
        Total devices 2 FS bytes used 257.93GB
        devid    1 size 931.51GB used 263.53GB path /dev/sdb
        devid    2 size 931.51GB used 263.51GB path /dev/sdc

Label: none  uuid: 6f2f8317-3012-4e79-a82d-ab2e8eaa6cd6
        Total devices 1 FS bytes used 354.99GB
        devid    1 size 465.65GB used 465.65GB path /dev/sda2

My interpretation of the above data is that /dev/sdb and /dev/sdc are
exact mirrors of each other, and contain my / root partition.

This would make complete sense if it wasn't for the fact that I've
copied all the data from /dev/sda2 onto /dev/sdb. From the information
above, it looks like the data has been split like in raid-0, instead
of the what I expect, mirrored like in raid-1.

I tried reading the FAQ about "Why are there so many ways to check the
amount of free space?" hoping this would make it more clear, but it
doesn't. Can anyone tell me what's going on?

I found one thread with a similar question that went unanswered, and
it was also back in 2008 so the answer might differ quite a bit
anyway.
