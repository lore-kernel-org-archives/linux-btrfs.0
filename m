Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38825 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcDBIrV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 04:47:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amHDA-0004xu-Om
	for linux-btrfs@vger.kernel.org; Sat, 02 Apr 2016 10:47:16 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 10:47:16 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 10:47:16 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Sat, 2 Apr 2016 10:47:04 +0200
Message-ID: <20160402104704.600b1184@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<56FDCA94.3030001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 1 Apr 2016 09:10:44 +0800
schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:

> The real problem is, the extent has mismatched reference.
> Normally it can fixed by --init-extent-tree option, but it normally 
> means bigger problem, especially it has already caused kernel 
> delayed-ref problem.
> 
> No to mention the error "extent item 11271947091968 has multiple
> extent items", which makes the problem more serious.
> 
> 
> I assume some older kernel have already screwed up the extent tree,
> as although delayed-ref is bug-prove, it has improved in recent years.
> 
> But it seems fs tree is less damaged, I assume the extent tree 
> corruption could be fixed by "--init-extent-tree".
> 
> For the only fs tree error (missing csum), if "btrfsck 
> --init-extent-tree --repair" works without any problem, the most
> simple fix would be, just removing the file.
> Or you can use a lot of CPU time and disk IO to rebuild the whole
> csum, by using "--init-csum-tree" option.

Okay, so I'm going to inode-resolve the file with csum errors.
Actually, it's a file from Steam which has been there for ages and
never showed csum errors before which make me wonder if csum errors may
sneak in on long existing files through other corruptions.

I now removed this file and had to reboot because btrfs went RO. Here's
the backtrace:

https://gist.github.com/kakra/a7be40c23e08fc6e237f9108371afadf

[137619.835374] ------------[ cut here ]------------
[137619.835385] WARNING: CPU: 1 PID: 4840 at fs/btrfs/extent-tree.c:1625 lookup_inline_extent_backref+0x156/0x620()
[137619.835394] Modules linked in: nvidia_drm(PO) uas usb_storage vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO) nvidia(PO)
[137619.835405] CPU: 1 PID: 4840 Comm: rm Tainted: P           O    4.5.0-gentoo-r1 #1
[137619.835407] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
[137619.835409]  0000000000000000 ffffffff8159eae9 0000000000000000 ffffffff81ea1d08
[137619.835412]  ffffffff810c6e37 ffff8803d56a4d20 ffff88040c7daa00 00000a4075114000
[137619.835415]  0000000000201000 0000000000000000 ffffffff81489836 0000001d00000000
[137619.835418] Call Trace:
[137619.835423]  [<ffffffff8159eae9>] ? dump_stack+0x46/0x5d
[137619.835429]  [<ffffffff810c6e37>] ? warn_slowpath_common+0x77/0xb0
[137619.835432]  [<ffffffff81489836>] ? lookup_inline_extent_backref+0x156/0x620
[137619.835435]  [<ffffffff814bdfce>] ? btrfs_get_token_32+0xee/0x110
[137619.835440]  [<ffffffff8115de48>] ? __set_page_dirty_nobuffers+0xf8/0x150
[137619.835443]  [<ffffffff81489d54>] ? insert_inline_extent_backref+0x54/0xe0
[137619.835450]  [<ffffffff8119ebd8>] ? __slab_free+0x98/0x220
[137619.835453]  [<ffffffff8119e6ad>] ? kmem_cache_alloc+0x14d/0x160
[137619.835456]  [<ffffffff8148a1e9>] ? __btrfs_inc_extent_ref.isra.64+0x99/0x270
[137619.835459]  [<ffffffff8148ecc3>] ? __btrfs_run_delayed_refs+0x673/0x1020
[137619.835463]  [<ffffffff814c6e01>] ? btrfs_release_extent_buffer_page+0x71/0x120
[137619.835466]  [<ffffffff814c6eef>] ? release_extent_buffer+0x3f/0x90
[137619.835469]  [<ffffffff8149222f>] ? btrfs_run_delayed_refs+0x8f/0x2b0
[137619.835473]  [<ffffffff814b0978>] ? btrfs_truncate_inode_items+0x8b8/0xdc0
[137619.835477]  [<ffffffff814b1d4e>] ? btrfs_evict_inode+0x3fe/0x550
[137619.835481]  [<ffffffff811cd4f7>] ? evict+0xb7/0x180
[137619.835484]  [<ffffffff811c37cc>] ? do_unlinkat+0x12c/0x2d0
[137619.835488]  [<ffffffff81bdb017>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
[137619.835491] ---[ end trace 6e8061336c42ff93 ]---
[137619.835494] ------------[ cut here ]------------
[137619.835497] WARNING: CPU: 1 PID: 4840 at fs/btrfs/extent-tree.c:2946 btrfs_run_delayed_refs+0x279/0x2b0()
[137619.835499] BTRFS: Transaction aborted (error -5)
[137619.835500] Modules linked in: nvidia_drm(PO) uas usb_storage vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO) nvidia(PO)
[137619.835506] CPU: 1 PID: 4840 Comm: rm Tainted: P        W  O    4.5.0-gentoo-r1 #1
[137619.835508] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
[137619.835509]  0000000000000000 ffffffff8159eae9 ffff880255d1bc98 ffffffff81ea1d08
[137619.835512]  ffffffff810c6e37 ffff88040c7daa00 ffff880255d1bce8 00000000000001c6
[137619.835514]  ffff8803211b4510 000000000000000b ffffffff810c6eb7 ffffffff81e8a0a0
[137619.835517] Call Trace:
[137619.835519]  [<ffffffff8159eae9>] ? dump_stack+0x46/0x5d
[137619.835522]  [<ffffffff810c6e37>] ? warn_slowpath_common+0x77/0xb0
[137619.835525]  [<ffffffff810c6eb7>] ? warn_slowpath_fmt+0x47/0x50
[137619.835528]  [<ffffffff81492419>] ? btrfs_run_delayed_refs+0x279/0x2b0
[137619.835531]  [<ffffffff814b0978>] ? btrfs_truncate_inode_items+0x8b8/0xdc0
[137619.835535]  [<ffffffff814b1d4e>] ? btrfs_evict_inode+0x3fe/0x550
[137619.835538]  [<ffffffff811cd4f7>] ? evict+0xb7/0x180
[137619.835541]  [<ffffffff811c37cc>] ? do_unlinkat+0x12c/0x2d0
[137619.835543]  [<ffffffff81bdb017>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
[137619.835545] ---[ end trace 6e8061336c42ff94 ]---
[137619.835547] BTRFS: error (device bcache2) in btrfs_run_delayed_refs:2946: errno=-5 IO failure
[137619.835550] BTRFS info (device bcache2): forced readonly
[137619.886069] pending csums is 410705920

So it looks like fixing one error introduces other errors. Should I try
init-extent-tree after taking a backup?

BTW: "btrfsck --repair" does not work: I complains about unsupported
cases due to compression of extents and that I need to contact the
developers for covering this case.

-- 
Regards,
Kai

Replies to list-only preferred.

