Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:43286 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbcCYIcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 04:32:11 -0400
Date: Fri, 25 Mar 2016 09:25:26 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Jones <davej@codemonkey.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_destroy_inode WARN_ON.
Message-ID: <20160325082526.GA314@x4>
References: <20160324225411.GA1612@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160324225411.GA1612@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016.03.24 at 18:54 -0400, Dave Jones wrote:
> Just hit this on a tree from earlier this morning, v4.5-11140 or so.
> 
> WARNING: CPU: 2 PID: 32570 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x389/0x3f0 [btrfs]
> CPU: 2 PID: 32570 Comm: rm Not tainted 4.5.0-think+ #14
>  ffffffffc039baf9 00000000ef721ef0 ffff88025966fc08 ffffffff8957bcdb
>  0000000000000000 0000000000000000 ffff88025966fc50 ffffffff890b41f1
>  ffff88045d918040 0000242d4eed6048 ffff88024eed6048 ffff88024eed6048
> Call Trace:
>  [<ffffffffc039baf9>] ? btrfs_destroy_inode+0x389/0x3f0 [btrfs]
>  [<ffffffff8957bcdb>] dump_stack+0x68/0x9d
>  [<ffffffff890b41f1>] __warn+0x111/0x130
>  [<ffffffff890b43fd>] warn_slowpath_null+0x1d/0x20
>  [<ffffffffc039baf9>] btrfs_destroy_inode+0x389/0x3f0 [btrfs]
>  [<ffffffff89352307>] destroy_inode+0x67/0x90
>  [<ffffffff893524e7>] evict+0x1b7/0x240
>  [<ffffffff893529be>] iput+0x3ae/0x4e0
>  [<ffffffff8934c93e>] ? dput+0x20e/0x460
>  [<ffffffff8933ee26>] do_unlinkat+0x256/0x440
>  [<ffffffff8933ebd0>] ? do_rmdir+0x350/0x350
>  [<ffffffff890031e7>] ? syscall_trace_enter_phase1+0x87/0x260
>  [<ffffffff89003160>] ? enter_from_user_mode+0x50/0x50
>  [<ffffffff8913c3b5>] ? __lock_is_held+0x25/0xd0
>  [<ffffffff891411f2>] ? mark_held_locks+0x22/0xc0
>  [<ffffffff890034ed>] ? syscall_trace_enter_phase2+0x12d/0x3d0
>  [<ffffffff893400b0>] ? SyS_rmdir+0x20/0x20
>  [<ffffffff893400cb>] SyS_unlinkat+0x1b/0x30
>  [<ffffffff89003ac4>] do_syscall_64+0xf4/0x240
>  [<ffffffff89d520da>] entry_SYSCALL64_slow_path+0x25/0x25
> ---[ end trace a48ce4e6a1b5e409 ]---
> 
> 
> That's WARN_ON(BTRFS_I(inode)->csum_bytes);
> 
> *maybe* it's a bad disk, but there's no indication in dmesg of anything awry.
> Spinning rust on SATA, nothing special.

Same thing here:

Mar 24 10:37:27 x4 kernel: ------------[ cut here ]------------
Mar 24 10:37:27 x4 kernel: WARNING: CPU: 3 PID: 11838 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x22b/0x2a0
Mar 24 10:37:27 x4 kernel: CPU: 3 PID: 11838 Comm: rm Not tainted 4.5.0-11787-ga24e3d414e59-dirty #64
Mar 24 10:37:27 x4 kernel: Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Mar 24 10:37:27 x4 kernel: 0000000000000000 ffffffff813c0d1a ffffffff81b8bb84 ffffffff812ffd0b
Mar 24 10:37:27 x4 kernel: ffffffff81099a9a 0000000000000000 ffff880149b86088 ffff88021585f000
Mar 24 10:37:27 x4 kernel: ffffffff812ffd0b 0000000000000000 ffff88005f526000 0000000000000000
Mar 24 10:37:27 x4 kernel: Call Trace:
Mar 24 10:37:27 x4 kernel: [<ffffffff813c0d1a>] ? dump_stack+0x46/0x6c
Mar 24 10:37:27 x4 kernel: [<ffffffff812ffd0b>] ? btrfs_destroy_inode+0x22b/0x2a0
Mar 24 10:37:27 x4 kernel: [<ffffffff81099a9a>] ? warn_slowpath_null+0x5a/0xe0
Mar 24 10:37:27 x4 kernel: [<ffffffff812ffd0b>] ? btrfs_destroy_inode+0x22b/0x2a0
Mar 24 10:37:27 x4 kernel: [<ffffffff811ab31c>] ? do_unlinkat+0x13c/0x3e0
Mar 24 10:37:27 x4 kernel: [<ffffffff810930db>] ? entry_SYSCALL_64_fastpath+0x13/0x8f
Mar 24 10:37:27 x4 kernel: ---[ end trace e9bae5be848e7a9e ]---

-- 
Markus
