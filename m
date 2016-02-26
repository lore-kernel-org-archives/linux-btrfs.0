Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34330 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbcBZQjs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 11:39:48 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Stanislav Brabec <sbrabec@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D07FAF.3080605@gmail.com>
Date: Fri, 26 Feb 2016 11:39:11 -0500
MIME-Version: 1.0
In-Reply-To: <56D0743F.9040102@suse.cz>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-26 10:50, Stanislav Brabec wrote:
> Austin S. Hemmelgarn wrote:
>  > Added linux-btrfs as this should be documented there as a known issue
>  > until it gets fixed (although I have no idea which side is the issue).
>
> This is a very bad behavior, as it makes impossible to safely use btrfs
> loop bind mounts in fstab. (Well, it is possible to write a work-around
> in util-linux: Remember the source file, and if -oloop is specified
> next time, and source file is already assigned to a loop device, use
> existing loop device.)
>
>> I'm not 100% certain, but I think this is a interaction between how
>> BTRFS handles multiple mounts of the same filesystem on a given system
>> and how mount handles loop mounts.  AFAIUI, all instances of a given
>> BTRFS filesystem being mounted on a given system are internally
>> identical to bind mounts of a hidden mount of that filesystem.  This is
>> what allows both manual mounting of sub-volumes, and multiple mounting
>> of the FS in general.
>
> Yes, internal implementation is the same.
>
> But here it causes a  real trouble: However both mounts point to the
> same file, first and second mount use different loop device. To create
> a bind mount, something ugly needs to be done. And it is done in an
> incorrect way.
That's just it though, from what I can tell based on what I've seen and 
what you said above, mount(8) isn't doing things correctly in this case. 
  If we were to do this with something like XFS or ext4, the filesystem 
would probably end up completely messed up just because of the log 
replay code (assuming they actually mount the second time, I'm not sure 
what XFS would do in this case, but I believe that ext4 would allow the 
mount as long as the mmp feature is off).  It would make sense that this 
behavior wouldn't have been noticed before (and probably wouldn't have 
mattered even if it had been), because most filesystems don't allow 
multiple mounts even if they're all RO, and most people don't try to 
mount other filesystems multiple times as a result of this.  If this 
behavior of allocating a new loop device for each call on a given file 
is in fact not BTRFS specific (as implied by your statement about a 
possible workaround in mount(8)), then mount(8) really should be fixed 
to not do that before we even consider looking at the issues in BTRFS, 
as that is behavior that has serious potential to result in data 
corruption for any filesystem, not just BTRFS.

Now, if this does get fixed, mount(8) doesn't necessarily need to 
maintain it's own copy of the state of /dev/loop mappings, it could 
simply check the currently allocated loop devices.  You would of course 
need some form of locking relative to other mount -o loop instances and 
losetup, and it would be slow, but if you're using enough loop devices 
that this causes noticeable delays, then you really shouldn't be 
complaining all that much about performance.
>
>
> I already found another inconsistency caused by this implementation:
>
> /proc/self/mountinfo reports subvolid of the nearest upper sub-volume
> root for the bind mount, not the sub-volume that was used for creating
> this bind mount, and subvolid that potentially does not correspond to
> any subvolume root.
>
> This could causes problem for evaluation of order of umount(2) that
> should prevent EBUSY.
>
> I was talking about it with David Sterba, and he told, that in the
> current implementation is not optimal. btrfs driver does not have
> sufficient information to evaluate true root of the bind mount.
I've noticed this before myself, but I've never seen any issues 
resulting from it; however, I've also not tried calling BTRFS related 
ioctls on or from such a mount, so I may just have been lucky.
>
> Maybe the same is valid for the reported loop issue, and this is just
> an ugly side effect.
I'd be more than willing to bet that that isn't the case, loop mounts 
and bind mounts are entirely different inside the kernel, and I think 
the loop mount issue on the BTRFS side is a result of the issues it has 
when dealing with filesystems with the same UUID (if this is in fact the 
case, similar behavior should be seen when trying to either mount 
multiple lower level components of a multi-path device, or by manually 
creating multiple /dev/loop associations for the same file and mounting 
them all at once using the /dev/loop names instead of the file).
>
>
> P. S.: There are some use differences between bind mounts and btrfs
> sub-volumes:
>
> - Bind mounts can be created for any file or directory.
> - Sub-volume mounts can be created only for inodes marked as sub-volume
>    root.
>
> - Bind mounts can be mounted only if any of upper sub-volume root is
>    mounted.
> - Sub-volumes can be mounted even if volume root is not mounted.
FWIW, it's actually possible to simulate this behavior with bind mounts 
by mounting the root at the eventual mount point, then bind mounting the 
desired directory from that root over top of it.  Of course, there is 
almost zero practical purpose to anyone doing this on most traditional 
filesystems unless they're actively trying to hide data.

