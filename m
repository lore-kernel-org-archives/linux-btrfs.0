Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59093 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbcFOHuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 03:50:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bD5aO-0000bA-TB
	for linux-btrfs@vger.kernel.org; Wed, 15 Jun 2016 09:50:05 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:50:04 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 09:50:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: BTRFS, remarkable problem: filesystem turns to read-only
 caused by firefox download
Date: Wed, 15 Jun 2016 07:49:57 +0000 (UTC)
Message-ID: <pan$3fee4$e477c79f$27d94bd3$5226b0ff@cox.net>
References: <CAK9QOun4rHcd6om7ZXaiv=ZGMCSufcZTJAFs2Sop=vBhcnxHJQ@mail.gmail.com>
	<CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Verreth posted on Wed, 15 Jun 2016 08:29:49 +0200 as excerpted:

> When I download a video using  Firefox DownloadHelper addon, the
> filesystem suddenly turns read only. Not a coincedence, I tried it
> several times, and it happened every time again
> 
> Info:
> Linux wolfgang 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux

Well first of all, that 4.2 kernel version isn't really supported any 
more, except possibly by your distro.  It's not a mainstream LTS kernel, 
with 4.1 and 4.4 being the LTS kernels on either side, and as a short-
term support kernel, its mainstream support lasted thru 4.3...

Of course distros can choose to support whatever kernel they like, but 
then it's them doing the patch backporting and we don't track what 
they've backported and what they haven't.  So if you want to stick with a 
distro-supported kernel, the best option is to get your support from them 
as they know what they've backported and are thus in the best position to 
support it.

As far as this list, 4.6 is the current stable kernel, with 4.7 in 
development, so 4.5 is the earliest non-LTS kernel series that's really 
supported.  Or go LTS series and choose, as mentioned, 4.1 or 4.4.  3.18 
was the LTS previous to that, but it's getting a bit long in tooth by now.

> btrfs --version btrfs-progs v4.0

That too is a bit dated.  While userspace version isn't as critical for 
runtime operations as it's mostly calling on the kernel to do the real 
work, once something goes wrong and you're trying to repair it, userspace 
code becomes vitally important.  With btrfs still stabilizing, not fully 
stable and mature, and still under heavy development, and with userspace 
versions synced to kernelspace releases and about five kernel series 
releases per year, given that 4.6 is current, 4.0 is over a year outdated 
now.  And a lot of bugs have been fixed in that year-plus...

> extract from dmesg:

> [171145.415466] BTRFS error (device sda5): unable to find ref byte
> nr 75093794816 parent 0 root 257  owner 0 offset 0
> [171145.415467] ------------[ cut here ]------------
> [171145.415473] WARNING: CPU: 3 PID: 15124 at
> /build/linux-HVWSXI/linux-4.2.0/fs/btrfs/extent-tree.c:6264
> __btrfs_free_extent.isra.69+0x92f/0xd70 [btrfs]()
> [171145.415474] BTRFS: Transaction aborted (error -2)
> [171145.415492] CPU: 3 PID: 15124 Comm: kworker/u16:0 Tainted: G
>  W       4.2.0-35-generic #40-Ubuntu
> [171145.415493] Hardware name: ASUS All Series/Z87-PLUS, BIOS 1707
> 12/13/2013
> [171145.415500] Workqueue: btrfs-extent-refs
> btrfs_extent_refs_helper [btrfs]

[...]

> [171145.415568] ---[ end trace 42e5b5054b17a8a2 ]---
> [171145.415570] BTRFS: error (device sda5) in __btrfs_free_extent:6264:
> errno=-2 No such entry
> [171145.415571] BTRFS info (device sda5): forced
> readonly [171145.415572] BTRFS: error (device sda5) in
> btrfs_run_delayed_refs:2788: errno=-2 No such entry


I'm not a dev, just a btrfs user and list regular, so the stack dump 
doesn't mean a whole lot to me.  What I can say, however, is that yes, 
this is btrfs involved...

And it's pretty standard for btrfs to force itself read-only when it sees 
an unexpected error that could otherwise lead to further damage, with the 
force to read-only thus protecting the filesystem from that further 
damage.

> I was able to mount RW again using -o recovery.
> 
> Based on these messages, I thought it would be usefull to do btrfs
> balance but it gave a segmentation fault after some minutes:
> 
> [246678.922508] BTRFS: error (device sdb5) in __btrfs_free_extent:6549:
> errno=-2 No such entry
> [246678.922509] BTRFS info (device sdb5): forced readonly
> [246678.922510] BTRFS: error (device sdb5) in
> btrfs_run_delayed_refs:2927: errno=-2 No such entry
> [246678.922520] BTRFS error (device sdb5): Error removing orphan entry,
> stopping orphan cleanup
> [246678.922521] BTRFS error (device sdb5): could not do orphan
> cleanup -22
> [246678.937230] BTRFS error (device sdb5): cleaner transaction attach
> returned -30

FWIW, orphans are files that were deleted when the file was in-use, 
typically *.so libraries that were replaced on package update, but where 
some executable that was running at the time was still using them, so 
they couldn't be fully deleted as there was still and open reference to 
them.

Normally, orphans will be deleted on umount or for the root filesystem, 
on (normal) remount-read-only, after whatever executables that were 
holding them open have terminated or been killed.  However, that doesn't 
have a chance to happen when the filesystem is forced read-only due to 
error, as above, so then they have to be cleaned up when the filesystem 
is remounted writable once again.

Btrfs does this normally, so this would have been unrelated to the 
balance.

> Balance:
> 
> btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
> Dumping filters: flags 0x7, state 0x0, force is off
> DATA (flags 0x100): converting, target=16, soft is off
> METADATA (flags 0x100): converting, target=16, soft is off
> SYSTEM (flags 0x100): converting, target=16, soft is off
> 
> 
> Segmentation fault

So you were doing a balance-convert to raid1, not just a regular 
balance...

> 
> Jun  5 15:03:15 ubuntu kernel: [ 2062.544303] BTRFS info (device sdb5):
> relocating block group 383447465984 flags 17
> Jun  5 15:03:17 ubuntu kernel: [ 2064.483744] BTRFS info (device sdb5):
> found 69 extents
> Jun  5 15:03:19 ubuntu kernel: [ 2067.085773] BTRFS info (device sdb5):
> found 69 extents

This is balance doing its normal thing, relocating chunks aka block-
groups.

> Jun  5 15:03:27 ubuntu kernel: [ 2074.572964]
> ------------[ cut here ]------------
> Jun  5 15:03:27 ubuntu kernel: [ 2074.572981] kernel BUG at
> /build/linux-Ay7j_C/linux-4.4.0/fs/btrfs/relocation.c:2683!
> Jun  5 15:03:27 ubuntu kernel: [ 2074.572999] invalid opcode: 0000 [#1]

Invalid opcode 0000 is btrfs' way of forcing a kernel abort when it 
detects a critical error.  As such it's a common notification to see in 
logs where something goes wrong.

Again, I'm not a dev so the dump and traces mean little to me, and I'm 
deleting them here.

> From this moment on, the filesystem is useless. Every reboot (with live
> USB) the crashed balance operation restarts, and gives a segmentation
> fault after a while. Booting from the disk is not possible anymore.
> 
> What can I do to repair this problem?

There's a mount option to cancel a pending balance.  See the btrfs (5) 
manpage (note, man 5 btrfs, not the default (8) btrfs you'd get without 
passing a man-section parameter) or look on the wiki if you want more 
than I mention here...

skip_balance

After mounting with that option, run btrfs balance cancel to cancel the 
balance.  That should keep it from trying to restart the balance again at 
the next mount.


Then I'd take the opportunity to freshen your backups if you need to.  
With btrfs not fully stable and mature yet, backups are of course 
strongly recommended, but that doesn't mean they're absolutely the 
freshest and this is a good opportunity to be sure they're current before 
trying anything else.

Then I'd suggest updating to a current kernel and userspace, and seeing 
if the problem persists.  If further repair is necessary when running on 
a current kernel, try a scrub first, then (with backups freshened) a 
balance and/or a btrfs check.  Note that btrfs check without further 
options should be a read-only operation.  You can post the results from 
that and ask if it's safe to run check with the --repair option, or if 
you should try something else.

Of course, particularly once you have fresh backups available, another 
option is to simply blow away the existing filesystem and recreate it 
with a new mkfs.btrfs.  Then you can restore your data from the backups 
to a freshly created filesystem, and hopefully be fine. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

