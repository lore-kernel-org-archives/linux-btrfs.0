Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:33607 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3BWAgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 19:36:08 -0500
Date: Sat, 23 Feb 2013 01:36:02 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <512248F6.2000108@giantdisaster.de>
Message-ID: <alpine.DEB.2.02.1302230124300.8295@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <201302141544.05747.Martin@lichtvoll.de> <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com> (sfid-20130215_095505_610309_779D53E5) <201302151005.29014.Martin@lichtvoll.de>
 <alpine.DEB.2.02.1302152250280.8810@shack.dolda2000.com> <512248F6.2000108@giantdisaster.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 18 Feb 2013, Stefan Behrens wrote:
> On Fri, 15 Feb 2013 22:56:19 +0100 (CET), Fredrik Tolf wrote:
>> The oops cut can be found here:
>> <http://www.dolda2000.com/~fredrik/tmp/btrfs-oops>
>
> This scrub issue is fixed since Linux 3.8-rc1 with commit
> 4ded4f6 Btrfs: fix BUG() in scrub when first superblock reading gives EIO

I see, thanks!

Rebooting the system did get me running again, allowing me to remove the 
missing device from filesystem. However, I encountered a couple of 
somewhat strange happenings as I did that. I don't know if they're 
considered bugs or not, but I thought I had best report them.

To begin with, the act of removing the missing device from the filesystem 
itself caused the resynchronization to the "new" device to happen in 
blocking mode, so the "btrfs device delete missing" operation took about a 
day to finish. My expectation would have been that the device removal 
would have been a fast operation and that I would have had to scrub the 
filesystem or something in order to resynchronize, but I can see how this 
would be intented behavior.

However, what's weirder is that while the resynchronization was underway, 
I couldn't mount subvolumes on other mountpoints. The mount commands 
blocked (disk-slept) until the entire synchronization was done, and I 
don't think this was intended behavior, because I had the kernel saying 
the following while it happened:

Feb 16 06:01:27 nerv kernel: [ 3482.512106] INFO: task mount:3525 blocked for more than 120 seconds.
Feb 16 06:01:28 nerv kernel: [ 3482.518484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 16 06:01:28 nerv kernel: [ 3482.526324] mount           D ffff88003e220e40     0  3525   3524 0x00000000
Feb 16 06:01:28 nerv kernel: [ 3482.533587]  ffff88003e220e40 0000000000000082 ffffffffa0067470 ffff88003e2300c0
Feb 16 06:01:28 nerv kernel: [ 3482.541088]  0000000000013b40 ffff88001126dfd8 0000000000013b40 ffff88001126dfd8
Feb 16 06:01:28 nerv kernel: [ 3482.548584]  0000000000013b40 ffff88003e220e40 0000000000013b40 ffff88001126c010
Feb 16 06:01:28 nerv kernel: [ 3482.556280] Call Trace:
Feb 16 06:01:28 nerv kernel: [ 3482.558776]  [<ffffffff81396132>] ? __mutex_lock_common+0x10d/0x175
Feb 16 06:01:28 nerv kernel: [ 3482.565078]  [<ffffffff81396260>] ? mutex_lock+0x1a/0x2c
Feb 16 06:01:28 nerv kernel: [ 3482.570661]  [<ffffffffa05a38c2>] ? btrfs_scan_one_device+0x40/0x133 [btrfs]
Feb 16 06:01:28 nerv kernel: [ 3482.577752]  [<ffffffffa0564e8b>] ? btrfs_mount+0x1c4/0x4d8 [btrfs]
Feb 16 06:01:28 nerv kernel: [ 3482.584080]  [<ffffffff810e56cb>] ? pcpu_next_pop+0x37/0x43
Feb 16 06:01:28 nerv kernel: [ 3482.589709]  [<ffffffff810e52c0>] ? cpumask_next+0x18/0x1a
Feb 16 06:01:28 nerv kernel: [ 3482.595226]  [<ffffffff811012aa>] ? alloc_pages_current+0xbb/0xd8
Feb 16 06:01:28 nerv kernel: [ 3482.601345]  [<ffffffff81113778>] ? mount_fs+0x6c/0x149
Feb 16 06:01:28 nerv kernel: [ 3482.606595]  [<ffffffff811291f7>] ? vfs_kern_mount+0x67/0xdd
Feb 16 06:01:28 nerv kernel: [ 3482.612292]  [<ffffffffa056516b>] ? btrfs_mount+0x4a4/0x4d8 [btrfs]
Feb 16 06:01:28 nerv kernel: [ 3482.618673]  [<ffffffff810e52c0>] ? cpumask_next+0x18/0x1a
Feb 16 06:01:28 nerv kernel: [ 3482.624178]  [<ffffffff811012aa>] ? alloc_pages_current+0xbb/0xd8
Feb 16 06:01:28 nerv kernel: [ 3482.630347]  [<ffffffff81113778>] ? mount_fs+0x6c/0x149
Feb 16 06:01:28 nerv kernel: [ 3482.635580]  [<ffffffff811291f7>] ? vfs_kern_mount+0x67/0xdd
Feb 16 06:01:28 nerv kernel: [ 3482.641258]  [<ffffffff811292e0>] ? do_kern_mount+0x49/0xd6
Feb 16 06:01:29 nerv kernel: [ 3482.646855]  [<ffffffff81129a98>] ? do_mount+0x72b/0x791
Feb 16 06:01:29 nerv kernel: [ 3482.652186]  [<ffffffff81129b86>] ? sys_mount+0x88/0xc3
Feb 16 06:01:29 nerv kernel: [ 3482.657464]  [<ffffffff8139d229>] ? system_call_fastpath+0x16/0x1b

Furthermore, it struck me that the consequences of having to mount a 
filesystem with missing deviced with -o degraded can be a bit strange. I 
realize what the intentions of the behavior is, of course, but I think it 
might cause quite some difficulties when trying to mount a degraded btrfs 
filesystem as root on a system that you don't have physical access to, 
like a hosted server, because it might be hard to manipulate the boot 
process so as to pass that mountflag to the initrd. Note that this is not 
a problem with md-raid; it will simply assemble its arrays in degraded 
mode automatically, without intervention. I'm not necessarily saying 
that's better, but I thought I should bring up the point.

--

Fredrik Tolf
