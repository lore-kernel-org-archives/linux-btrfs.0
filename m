From: "Ken D'Ambrosio" <ken@jots.org>
Subject: RAID not RAIDing? Or at least not showing correct usage?
Date: Sat, 24 Sep 2011 14:51:12 -0400
Message-ID: <96eceb54b5f19f36507deb29d049fbaf@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all.  I'd never done RAID on btrfs before, so bear with me if I'm missing
something obvious.  I just created a RAIDed btrfs partition with 

mkfs.btrfs -m raid10 -d raid10 -L bigguy /dev/sdb /dev/sdc

(I also did the same, but with RAID-1, getting the same results I'm about to
outline.)  That's two 3-TB disks; since they're RAIDed, I expected to wind up
with ~3 TB of free space.  But df reports 5858378624 available.  Knowing that
df and btrfs don't always see eye-to-eye, I copied over a 350 MB .avi, and
fired up btrfs-show, which came back with:

Label: bigguy  uuid: 5e062e02-f55e-4d7f-866c-3b851b3c6e02
	Total devices 2 FS bytes used 350.57MB
	devid    1 size 2.73TB used 1.27GB path /dev/sdb
	devid    2 size 2.73TB used 0.00 path /dev/sdc

That don't look very mirrored to me.  All the instructions I found said I
should just mount /dev/sd(b|c) singly; is there, instead, a logical RAID
partition I should be mounting?  Or... is there something else I'm just
missing?

Thanks, and apologies if my ignorance is showing,

-Ken





