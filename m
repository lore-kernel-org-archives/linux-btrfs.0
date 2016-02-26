Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35584 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbcBZMfQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 07:35:16 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Stanislav Brabec <sbrabec@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56CF5490.7040102@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D04630.1020809@gmail.com>
Date: Fri, 26 Feb 2016 07:33:52 -0500
MIME-Version: 1.0
In-Reply-To: <56CF5490.7040102@suse.cz>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added linux-btrfs as this should be documented there as a known issue 
until it gets fixed (although I have no idea which side is the issue).
On 2016-02-25 14:22, Stanislav Brabec wrote:
> While writing a test suite for util-linux[1], I experienced a a strange
> behavior of loop device:
>
> When two loop devices refer to the same file, and two btrfs mounts are
> called on them, the second mount changes loop device of the first,
> already mounted sub-volume. (Note that the current implementation of
> util-linux mount -oloop works exactly in this way, and it allocates new
> loop device for each mount command, so this bug can be easily
> reproduced without losetup, just using "mount -oloop" or fstab.)
I'm not 100% certain, but I think this is a interaction between how 
BTRFS handles multiple mounts of the same filesystem on a given system 
and how mount handles loop mounts.  AFAIUI, all instances of a given 
BTRFS filesystem being mounted on a given system are internally 
identical to bind mounts of a hidden mount of that filesystem.  This is 
what allows both manual mounting of sub-volumes, and multiple mounting 
of the FS in general.
>
> /proc/self/mountinfo after first btrfs loop mount:
>
> 107 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop0 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
>
> This line changes after second first btrfs loop to:
>
> 07 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop1 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
>
> See the change of /dev/loop0 to /dev/loop1!
>
> It is apparently not only proc file change, but it also causes a
> corruption of loop device subsystem, as I observed severe problems
> on the affected system later:
>
> - mount(2) returning 0 but doing nothing.
>
> - mount(8) entering an infinite loop while searching for free loop
> device.
This seems odd that it would cause such a degree of inconsistency in the 
kernel itself.  My guess though is that mount(8) sees that you're trying 
to mount a file and unconditionally tries to bind it to a loop device 
without checking any in-use loop devices to see if it's already bound to 
them, and then when it calls mount(2), this ends up somehow confusing 
the BTRFS driver (probably because you've now mounted two filesystems 
with effectively identical super-blocks, BTRFS already has issues if 
multiple filesystems have the same UUID, and I have no idea how it might 
react to filesystems that appear identical but are on separate devices).
>
>
> Here is a main reproducer:
>
> =====================
> #!/bin/sh
> # Prepare the environment:
> /btrfs.sh
> mkdir -p /mnt/1 /mnt/2
> losetup /dev/loop0 /btrfs.img
> # Verify that nothing is mounted:
> cat /proc/self/mountinfo | grep /mnt
> mount /dev/loop0 /mnt/1
> echo "One file system should be mounted now."
> cat /proc/self/mountinfo | grep /mnt
> # Create another loop.
> losetup /dev/loop1 /btrfs.img
> echo "Going to mount second one."
> mount -osubvol=/ /dev/loop1 /mnt/2 2>&1
> echo "Two file system should be mounted now."
> cat /proc/self/mountinfo | grep /mnt
> echo "Strange. First mount changed its loop device!"
> umount /mnt/2
> echo "And now check, whether it remains changed after umount."
> cat /proc/self/mountinfo | grep /mnt
> umount /mnt/1
> losetup -d /dev/loop1
> losetup -d /dev/loop0
> rmdir /mnt/1 /mnt/2
> =====================
>
> And here is its output:
>
> One file system should be mounted now.
> 107 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop0 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
> Going to mount second one.
> Two file system should be mounted now.
> 107 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop1 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
> 108 59 0:59 / /mnt/2 rw,relatime shared:47 - btrfs /dev/loop1 rw,space_cache,subvolid=5,subvol=/
> Strange. First mount changed its loop device!
> And now check, whether it remains changed after umount.
> 107 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop1 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
>
> It was actually reproduced on linux-4.4.1 on openSUSE Tumbleweed.
>
>
> Test image creator:
>
> ===== /btrfs.sh =====
> #!/bin/sh
> truncate -s 42M /btrfs.img
> mkfs.btrfs -f -d single -m single /btrfs.img >/dev/null
> mount -o loop /btrfs.img /mnt
> pushd . >/dev/null
> cd /mnt
> mkdir -p d0/dd0/ddd0
> cd ./d0/dd0/ddd0
> touch file{1..5}
> btrfs subvol create s1 >/dev/null
> cd ./s1
> touch file{1..5}
> mkdir bind-point
> mkdir -p d1/dd1/ddd1
> cd ./d1/dd1/ddd1
> btrfs subvol create s2 >/dev/null
> DEFAULT_SUBVOLID=$(btrfs inspect rootid s2)
> btrfs subvol set-default $DEFAULT_SUBVOLID . >/dev/null
> NON_DEFAULT_SUBVOLID=$(btrfs subvol list /mnt |
> while read dummy id rest ; do if test $id = $DEFAULT_SUBVOLID ; then
> continue ; fi ; echo $id ; done)
> cd ../../../..
> mkdir -p d2/dd2/ddd2
> cd ./d2/dd2/ddd2
> btrfs subvol create s3 >/dev/null
> mkdir -p s3/bind-mnt
> popd >/dev/null
> NON_DEFAULT_SUBVOL=d0/dd0/ddd0/d2/dd2/ddd2/s3
> umount /mnt
> =====================
>
> [1] http://marc.info/?l=util-linux-ng&m=145590643206663&w=2
>

