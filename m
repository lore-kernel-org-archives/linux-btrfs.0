Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:36020 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbcBZUGW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 15:06:22 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Stanislav Brabec <sbrabec@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D0B007.2050106@gmail.com>
Date: Fri, 26 Feb 2016 15:05:27 -0500
MIME-Version: 1.0
In-Reply-To: <56D0A38B.3050701@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-26 14:12, Stanislav Brabec wrote:
> Al Viro wrote:
>> On Fri, Feb 26, 2016 at 11:39:11AM -0500, Austin S. Hemmelgarn wrote:
>>
>>> That's just it though, from what I can tell based on what I've seen
>>> and what you said above, mount(8) isn't doing things correctly in
>>> this case.  If we were to do this with something like XFS or ext4,
>>> the filesystem would probably end up completely messed up just
>>> because of the log replay code (assuming they actually mount the
>>> second time, I'm not sure what XFS would do in this case, but I
>>> believe that ext4 would allow the mount as long as the mmp feature
>>> is off).  It would make sense that this behavior wouldn't have been
>>> noticed before (and probably wouldn't have mattered even if it had
>>> been), because most filesystems don't allow multiple mounts even if
>>> they're all RO, and most people don't try to mount other filesystems
>>> multiple times as a result of this.
>
> Well, in such case kernel should return an error when mount(8) is
> trying to use multiple mount devices for a single file for mount(2).
As I said in my other e-mail, there are perfectly legitimate reasons to 
be doing this.  And I should also point out that anybody who has one of 
those reasons for doing this should be setting up the loop devices 
themselves, so mount(8) behaving this way is still wrong.
>
> But kernel does not return error, it starts to do strange things.
>
>> They most certainly do.  The problem is mount(8) treatment of -o loop -
>> you can mount e.g. ext4 many times, it'll just get you extra references
>> to the same struct super_block from those new vfsmounts.  IOW, that'll
>> behave the same way as if you were doing mount --bind on subsequent ones.
>
> I just tested the same with ext4. The rewriting of mountinfo happens
> only with btrfs.
>
> But after that mount(2) stops to work. See the last mount(2). It
> returns 0, but nothing is mounted! Kernel mount(2) refuses to work!
>
> # mount -oloop /ext4.img /mnt/1
> # cat /proc/self/mountinfo | grep /mnt
> 238 59 7:0 / /mnt/1 rw,relatime shared:153 - ext4 /dev/loop0 rw,data=ordered
> # mount -oloop /ext4.img /mnt/2
> # cat /proc/self/mountinfo | grep /mnt
> 238 59 7:0 / /mnt/1 rw,relatime shared:153 - ext4 /dev/loop0 rw,data=ordered
> 243 59 7:1 / /mnt/2 rw,relatime shared:156 - ext4 /dev/loop1 rw,data=ordered
> # umount /mnt/*
> # mount -oloop /btrfs.img /mnt/1
> # cat /proc/self/mountinfo | grep /mnt
> 238 59 0:94 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:153 - btrfs /dev/loop0 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
> # mount -oloop,subvol=/ /btrfs.img /mnt/2
> # cat /proc/self/mountinfo | grep /mnt
> 238 59 0:94 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:153 - btrfs /dev/loop1 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
>
> I is really strange! Mount was called, but nothing appeared in the
> mountinfo. Just a rewritten /dev/loop0 -> /dev/loop1 in the existing
> mount.
>
> To be sure, that it is mount(2) issue and not mount(8), let's try it
> again with strace.
>
> # strace mount -oloop,subvol=/ /btrfs.img /mnt/2 2>&1 | tail -n 7
> mount("/dev/loop1", "/mnt/2", "btrfs", MS_MGC_VAL, "subvol=/") = 0
> access("/mnt/2", W_OK)                  = 0
> close(4)                                = 0
> close(1)                                = 0
> close(2)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
> # cat /proc/self/mountinfo | grep /mnt
> 238 59 0:94 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:153 - btrfs /dev/loop1 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
>
> Where is /mnt/2?
It's kind of interesting, but I can't reproduce _any_ of this behavior 
with either ext4 or BTRFS when I manually set up the loop devices and 
point mount(8) at those instead of using -o loop on a file. That really 
seems to indicate that this is caused by something mount(8) is doing 
when it's calling losetup. I'm running a mostly unmodified version of 
4.4.2 (the only modification that would come even remotely close to this 
is that I changed the default mount options for everything from relatime 
to noatime), and util-linux 2.27.1 from Gentoo.
>
>> And as far as kernel is concerned, /dev/loop* isn't special in any respects;
>> if you do explicit losetup and mount the resulting /dev/loop<n> as many
>> times as you wish, it'll work just fine.
>
> mount(8) just calls losetup internally for every -o loop. Once per
> "loop" option. Nobody probably tried to loop mount the same ext4 volume
> more times, so no problems appeared.
>
> But for btrfs, one would. And mounting two btrfs subvolumes with two
> "-oloop" calls losetup twice for the same file.
>
>> And from the kernel POV it's not
>> different from what it sees with -o loop; setting the loop device up is
>> done first by separate syscall, then mount(2) for that device is issued.
>
> Yes, it is different.
> - You have one file.
> - You have two loop devices pointing to the same file.
> - btrfs subvolumes are internally handled similarly like bind mounts.
>    It means, that all subvolumes should have the same mount source. But
>    these two mounts don't have.
There is insufficient information given just the context of the syscall 
to differentiate this particular case in kernel code.
>
>> It's mount(8) that screws up here.
>
> Yes mount(8) screws mount(2). And it corrupts kernel:
>
> 1) /proc/self/mountinfo changes its contents.
>
> 2) mount(2) called after the reproducer returns OK but does nothing.
>
OK, we've determined that mount(2) is misbehaving.  That doesn't change 
the fact that mount(8) is triggering this, and therefore should itself 
be corrected.  Assume that mount(2) gets fixed so it doesn't lose it's 
mind and /proc/self/mountinfo doesn't change.  There will still be 
issues resulting from mount(8)'s behavior:
1. BTRFS will lose it's mind and corrupt data when using a multi-device 
filesystem (due to the problems with duplicate FS UUID's).
2. XFS might have similar issues to 1 when using metadata checksumming, 
although it's more likely that it won't allow the second mount to succeed.
3. Most other filesystems will likely end up corrupting data.

