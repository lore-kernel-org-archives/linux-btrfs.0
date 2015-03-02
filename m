Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:42520 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbCBLZv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Mar 2015 06:25:51 -0500
Date: Mon, 2 Mar 2015 12:25:47 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8693
 btrfs_destroy_inode+0x278/0x2a0()
Message-ID: <20150302112547.GA345@x4>
References: <20150220100934.GA343@x4>
 <20150224122901.GC343@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150224122901.GC343@x4>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015.02.24 at 13:29 +0100, Markus Trippelsdorf wrote:
> On 2015.02.20 at 11:09 +0100, Markus Trippelsdorf wrote:
> > 
> > I get the following warnings during Firefox LTO build. lto1-wpa-stream
> > outputs the final object files in parallel and therefore stresses the
> > filessystem.
> > These warnings started with the git merge above.
> > 
> > The disk is a conventional drive:
> > 
> > [    2.438132] scsi 1:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 5
> > [    2.438308] sd 1:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> > [    2.438310] sd 1:0:0:0: [sda] 4096-byte physical blocks
> > 
> > /dev/sda2      btrfs     1.9T  905G  946G  49% /var
> > /dev/sda2 on /var type btrfs (rw,relatime,compress=lzo,noacl,space_cache)
> > 
> > 
> > [ 4155.708579] ------------[ cut here ]------------
> > [ 4155.708590] WARNING: CPU: 1 PID: 8850 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
> > [ 4155.708593] CPU: 1 PID: 8850 Comm: lto1-wpa-stream Not tainted 3.19.0-08975-g3d883483dc0a-dirty #101
> > [ 4155.708594] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> > [ 4155.708595]  0000000000000000 ffffffff81999aad ffffffff8168d303 0000000000000000
> > [ 4155.708597]  ffffffff8106d2d2 ffff8800dad9bb78 ffff88018554ccc0 ffff880215e2e000
> > [ 4155.708599]  ffff880215f23000 0000000000000000 ffffffff8121b6f8 0000000000000000
> > [ 4155.708601] Call Trace:
> > [ 4155.708606]  [<ffffffff8168d303>] ? dump_stack+0x40/0x50
> > [ 4155.708609]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> > [ 4155.708611]  [<ffffffff8121b6f8>] ? btrfs_destroy_inode+0x278/0x2a0
> > [ 4155.708614]  [<ffffffff81129381>] ? dispose_list+0x41/0x60
> > [ 4155.708615]  [<ffffffff81129669>] ? prune_icache_sb+0x49/0x60
> > [ 4155.708618]  [<ffffffff8111205a>] ? super_cache_scan+0x13a/0x1a0
> > [ 4155.708621]  [<ffffffff810e0a1b>] ? shrink_slab.part.52.constprop.62+0x19b/0x240
> > [ 4155.708623]  [<ffffffff810e3049>] ? shrink_zone+0x89/0xa0
> > [ 4155.708625]  [<ffffffff810e3241>] ? try_to_free_pages+0x1e1/0x320
> > [ 4155.708626]  [<ffffffff810daa82>] ? __alloc_pages_nodemask+0x382/0x680
> > [ 4155.708629]  [<ffffffff810f597d>] ? handle_mm_fault+0xbbd/0xe60
> > [ 4155.708631]  [<ffffffff81092e15>] ? put_prev_task_fair+0x75/0x320
> > [ 4155.708632]  [<ffffffff810903b0>] ? __dequeue_entity+0x30/0x40
> > [ 4155.708633]  [<ffffffff81094975>] ? pick_next_task_fair+0x415/0x480
> > [ 4155.708636]  [<ffffffff81064144>] ? __do_page_fault+0x104/0x3a0
> > [ 4155.708637]  [<ffffffff8168fb77>] ? __schedule+0x257/0x860
> > [ 4155.708639]  [<ffffffff8169518f>] ? page_fault+0x1f/0x30
> > [ 4155.708640] ---[ end trace 265993ee076d84aa ]---
> > [ 4155.708641] ------------[ cut here ]------------
> > [ 4155.708643] WARNING: CPU: 1 PID: 8850 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
> > [ 4155.708644] CPU: 1 PID: 8850 Comm: lto1-wpa-stream Tainted: G        W       3.19.0-08975-g3d883483dc0a-dirty #101
> > [ 4155.708645] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> > [ 4155.708645]  0000000000000000 ffffffff81999aad ffffffff8168d303 0000000000000000
> > [ 4155.708647]  ffffffff8106d2d2 ffff8800dad9bb78 ffff88018554ccc0 ffff880215e2e000
> > [ 4155.708648]  ffff880215f23000 0000000000000000 ffffffff8121b672 0000000000000000
> > [ 4155.708649] Call Trace:
> > [ 4155.708651]  [<ffffffff8168d303>] ? dump_stack+0x40/0x50
> > [ 4155.708652]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> > [ 4155.708654]  [<ffffffff8121b672>] ? btrfs_destroy_inode+0x1f2/0x2a0
> > [ 4155.708655]  [<ffffffff81129381>] ? dispose_list+0x41/0x60
> > [ 4155.708656]  [<ffffffff81129669>] ? prune_icache_sb+0x49/0x60
> > [ 4155.708658]  [<ffffffff8111205a>] ? super_cache_scan+0x13a/0x1a0
> > [ 4155.708659]  [<ffffffff810e0a1b>] ? shrink_slab.part.52.constprop.62+0x19b/0x240
> > [ 4155.708661]  [<ffffffff810e3049>] ? shrink_zone+0x89/0xa0
> > [ 4155.708662]  [<ffffffff810e3241>] ? try_to_free_pages+0x1e1/0x320
> > [ 4155.708664]  [<ffffffff810daa82>] ? __alloc_pages_nodemask+0x382/0x680
> > [ 4155.708665]  [<ffffffff810f597d>] ? handle_mm_fault+0xbbd/0xe60
> > [ 4155.708667]  [<ffffffff81092e15>] ? put_prev_task_fair+0x75/0x320
> > [ 4155.708668]  [<ffffffff810903b0>] ? __dequeue_entity+0x30/0x40
> > [ 4155.708669]  [<ffffffff81094975>] ? pick_next_task_fair+0x415/0x480
> > [ 4155.708670]  [<ffffffff81064144>] ? __do_page_fault+0x104/0x3a0
> > [ 4155.708672]  [<ffffffff8168fb77>] ? __schedule+0x257/0x860
> > [ 4155.708673]  [<ffffffff8169518f>] ? page_fault+0x1f/0x30
> > [ 4155.708674] ---[ end trace 265993ee076d84ab ]---
> > [ 4156.021127] ------------[ cut here ]------------
> > [ 4156.021136] WARNING: CPU: 3 PID: 35 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
> > [ 4156.021139] CPU: 3 PID: 35 Comm: kswapd0 Tainted: G        W       3.19.0-08975-g3d883483dc0a-dirty #101
> > [ 4156.021140] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> > [ 4156.021141]  0000000000000000 ffffffff81999aad ffffffff8168d303 0000000000000000
> > [ 4156.021143]  ffffffff8106d2d2 ffff8802160dfcb8 ffff88006b07a690 ffff880215e2e000
> > [ 4156.021145]  ffff880215f23000 0000000000000000 ffffffff8121b6f8 0000000000000000
> > [ 4156.021146] Call Trace:
> > [ 4156.021151]  [<ffffffff8168d303>] ? dump_stack+0x40/0x50
> > [ 4156.021154]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> > [ 4156.021156]  [<ffffffff8121b6f8>] ? btrfs_destroy_inode+0x278/0x2a0
> > [ 4156.021159]  [<ffffffff81129381>] ? dispose_list+0x41/0x60
> > [ 4156.021160]  [<ffffffff81129669>] ? prune_icache_sb+0x49/0x60
> > [ 4156.021163]  [<ffffffff8111205a>] ? super_cache_scan+0x13a/0x1a0
> > [ 4156.021166]  [<ffffffff810e0a1b>] ? shrink_slab.part.52.constprop.62+0x19b/0x240
> > [ 4156.021168]  [<ffffffff810e3049>] ? shrink_zone+0x89/0xa0
> > [ 4156.021169]  [<ffffffff810e3698>] ? kswapd+0x318/0x6c0
> > [ 4156.021171]  [<ffffffff810e3380>] ? try_to_free_pages+0x320/0x320
> > [ 4156.021173]  [<ffffffff81084c3c>] ? kthread+0xbc/0xe0
> > [ 4156.021175]  [<ffffffff81084b80>] ? __kthread_parkme+0x80/0x80
> > [ 4156.021177]  [<ffffffff81693bec>] ? ret_from_fork+0x7c/0xb0
> > [ 4156.021178]  [<ffffffff81084b80>] ? __kthread_parkme+0x80/0x80
> > [ 4156.021179] ---[ end trace 265993ee076d84ac ]---
> > [ 4156.021180] ------------[ cut here ]------------
> > [ 4156.021182] WARNING: CPU: 3 PID: 35 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
> > [ 4156.021183] CPU: 3 PID: 35 Comm: kswapd0 Tainted: G        W       3.19.0-08975-g3d883483dc0a-dirty #101
> > [ 4156.021184] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> > [ 4156.021184]  0000000000000000 ffffffff81999aad ffffffff8168d303 0000000000000000
> > [ 4156.021186]  ffffffff8106d2d2 ffff8802160dfcb8 ffff88006b07a690 ffff880215e2e000
> > [ 4156.021187]  ffff880215f23000 0000000000000000 ffffffff8121b672 0000000000000000
> > [ 4156.021188] Call Trace:
> > [ 4156.021190]  [<ffffffff8168d303>] ? dump_stack+0x40/0x50
> > [ 4156.021191]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> > [ 4156.021192]  [<ffffffff8121b672>] ? btrfs_destroy_inode+0x1f2/0x2a0
> > [ 4156.021194]  [<ffffffff81129381>] ? dispose_list+0x41/0x60
> > [ 4156.021195]  [<ffffffff81129669>] ? prune_icache_sb+0x49/0x60
> > [ 4156.021197]  [<ffffffff8111205a>] ? super_cache_scan+0x13a/0x1a0
> > [ 4156.021198]  [<ffffffff810e0a1b>] ? shrink_slab.part.52.constprop.62+0x19b/0x240
> > [ 4156.021200]  [<ffffffff810e3049>] ? shrink_zone+0x89/0xa0
> > [ 4156.021201]  [<ffffffff810e3698>] ? kswapd+0x318/0x6c0
> > [ 4156.021203]  [<ffffffff810e3380>] ? try_to_free_pages+0x320/0x320
> > [ 4156.021204]  [<ffffffff81084c3c>] ? kthread+0xbc/0xe0
> > [ 4156.021205]  [<ffffffff81084b80>] ? __kthread_parkme+0x80/0x80
> > [ 4156.021207]  [<ffffffff81693bec>] ? ret_from_fork+0x7c/0xb0
> > [ 4156.021208]  [<ffffffff81084b80>] ? __kthread_parkme+0x80/0x80
> > [ 4156.021209] ---[ end trace 265993ee076d84ad ]---
> 
> Also happens when I remove directories:
> 
> [83159.023857] ------------[ cut here ]------------
> [83159.023865] WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
> [83159.023868] CPU: 2 PID: 32343 Comm: rm Not tainted 4.0.0-rc1-dirty #104
> [83159.023869] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> [83159.023870]  0000000000000000 ffffffff8199990f ffffffff8168d723 0000000000000000
> [83159.023872]  ffffffff8106d2d2 0000000000000000 ffff880008dd8560 ffff880215805800
> [83159.023873]  ffff880169477eb8 ffff880008dd8560 ffffffff8121bab8 ffff880100675000
> [83159.023874] Call Trace:
> [83159.023878]  [<ffffffff8168d723>] ? dump_stack+0x40/0x50
> [83159.023881]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> [83159.023882]  [<ffffffff8121bab8>] ? btrfs_destroy_inode+0x278/0x2a0
> [83159.023885]  [<ffffffff8111f747>] ? do_unlinkat+0x1a7/0x2e0
> [83159.023887]  [<ffffffff81083974>] ? task_work_run+0xb4/0x100
> [83159.023889]  [<ffffffff8103b9a9>] ? do_notify_resume+0x69/0x80
> [83159.023891]  [<ffffffff81694092>] ? system_call_fastpath+0x12/0x17
> [83159.023892] ---[ end trace 3b7c45c6e46fe8db ]---
> [83159.023892] ------------[ cut here ]------------
> [83159.023894] WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
> [83159.023895] CPU: 2 PID: 32343 Comm: rm Tainted: G        W       4.0.0-rc1-dirty #104
> [83159.023896] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> [83159.023897]  0000000000000000 ffffffff8199990f ffffffff8168d723 0000000000000000
> [83159.023898]  ffffffff8106d2d2 0000000000000000 ffff880008dd8560 ffff880215805800
> [83159.023899]  ffff880169477eb8 ffff880008dd8560 ffffffff8121ba32 ffff880100675000
> [83159.023900] Call Trace:
> [83159.023902]  [<ffffffff8168d723>] ? dump_stack+0x40/0x50
> [83159.023903]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> [83159.023905]  [<ffffffff8121ba32>] ? btrfs_destroy_inode+0x1f2/0x2a0
> [83159.023906]  [<ffffffff8111f747>] ? do_unlinkat+0x1a7/0x2e0
> [83159.023907]  [<ffffffff81083974>] ? task_work_run+0xb4/0x100
> [83159.023909]  [<ffffffff8103b9a9>] ? do_notify_resume+0x69/0x80
> [83159.023910]  [<ffffffff81694092>] ? system_call_fastpath+0x12/0x17
> [83159.023911] ---[ end trace 3b7c45c6e46fe8dc ]---
> [83159.038708] ------------[ cut here ]------------
> [83159.038716] WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
> [83159.038718] CPU: 2 PID: 32343 Comm: rm Tainted: G        W       4.0.0-rc1-dirty #104
> [83159.038719] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> [83159.038720]  0000000000000000 ffffffff8199990f ffffffff8168d723 0000000000000000
> [83159.038722]  ffffffff8106d2d2 0000000000000000 ffff88005756edf0 ffff880215805800
> [83159.038723]  ffff880169477eb8 ffff88005756edf0 ffffffff8121bab8 ffff880100675000
> [83159.038725] Call Trace:
> [83159.038728]  [<ffffffff8168d723>] ? dump_stack+0x40/0x50
> [83159.038731]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> [83159.038732]  [<ffffffff8121bab8>] ? btrfs_destroy_inode+0x278/0x2a0
> [83159.038735]  [<ffffffff8111f747>] ? do_unlinkat+0x1a7/0x2e0
> [83159.038737]  [<ffffffff81083974>] ? task_work_run+0xb4/0x100
> [83159.038740]  [<ffffffff8103b9a9>] ? do_notify_resume+0x69/0x80
> [83159.038742]  [<ffffffff81694092>] ? system_call_fastpath+0x12/0x17
> [83159.038743] ---[ end trace 3b7c45c6e46fe8dd ]---
> [83159.038744] ------------[ cut here ]------------
> [83159.038745] WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
> [83159.038746] CPU: 2 PID: 32343 Comm: rm Tainted: G        W       4.0.0-rc1-dirty #104
> [83159.038747] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> [83159.038747]  0000000000000000 ffffffff8199990f ffffffff8168d723 0000000000000000
> [83159.038749]  ffffffff8106d2d2 0000000000000000 ffff88005756edf0 ffff880215805800
> [83159.038750]  ffff880169477eb8 ffff88005756edf0 ffffffff8121ba32 ffff880100675000
> [83159.038751] Call Trace:
> [83159.038753]  [<ffffffff8168d723>] ? dump_stack+0x40/0x50
> [83159.038754]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> [83159.038755]  [<ffffffff8121ba32>] ? btrfs_destroy_inode+0x1f2/0x2a0
> [83159.038757]  [<ffffffff8111f747>] ? do_unlinkat+0x1a7/0x2e0
> [83159.038758]  [<ffffffff81083974>] ? task_work_run+0xb4/0x100
> [83159.038760]  [<ffffffff8103b9a9>] ? do_notify_resume+0x69/0x80
> [83159.038761]  [<ffffffff81694092>] ? system_call_fastpath+0x12/0x17
> [83159.038762] ---[ end trace 3b7c45c6e46fe8de ]---

Unfortunately the issue isn't 100% reproducible, so I unfortunately
cannot bisect.

Another example:
...
Mar  2 06:58:24 x4 kernel: BTRFS info (device sdb3): disk space caching is enabled
Mar  2 06:58:25 x4 kernel: microcode: CPU0: new patch_level=0x010000db
Mar  2 06:58:25 x4 kernel: microcode: CPU1: new patch_level=0x010000db
Mar  2 06:58:25 x4 kernel: microcode: CPU2: new patch_level=0x010000db
Mar  2 06:58:25 x4 kernel: microcode: CPU3: new patch_level=0x010000db
Mar  2 06:58:26 x4 kernel: Adding 4095996k swap on /dev/sda1.  Priority:-1 extents:1 across:4095996k
Mar  2 09:09:58 x4 kernel: BTRFS warning (device sda2): block group 885866364928 has wrong amount of free space
Mar  2 09:09:58 x4 kernel: BTRFS warning (device sda2): failed to load free space cache for block group 885866364928, rebuild it now
Mar  2 09:20:02 x4 kernel: ------------[ cut here ]------------
Mar  2 09:20:02 x4 kernel: WARNING: CPU: 0 PID: 14596 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
Mar  2 09:20:02 x4 kernel: CPU: 0 PID: 14596 Comm: rm Not tainted 4.0.0-rc1-00151-ga38ecbbd0be0-dirty #110
Mar  2 09:20:02 x4 kernel: Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Mar  2 09:20:02 x4 kernel: 0000000000000000 ffffffff8199e119 ffffffff8169214e 0000000000000000
Mar  2 09:20:02 x4 kernel: ffffffff8106c4f2 0000000000000000 ffff8801095b8910 ffff880216a6d000
Mar  2 09:20:02 x4 kernel: ffff88007060beb8 ffff8801095b8910 ffffffff8121a3b8 ffff88019db09000
Mar  2 09:20:02 x4 kernel: Call Trace:
Mar  2 09:20:02 x4 kernel: [<ffffffff8169214e>] ? dump_stack+0x40/0x50
Mar  2 09:20:02 x4 kernel: [<ffffffff8106c4f2>] ? warn_slowpath_common+0x72/0xc0
Mar  2 09:20:02 x4 kernel: [<ffffffff8121a3b8>] ? btrfs_destroy_inode+0x278/0x2a0
Mar  2 09:20:02 x4 kernel: [<ffffffff8111e9e7>] ? do_unlinkat+0x127/0x300
Mar  2 09:20:02 x4 kernel: [<ffffffff81082dd4>] ? task_work_run+0xb4/0x100
Mar  2 09:20:02 x4 kernel: [<ffffffff8103aad5>] ? do_notify_resume+0x55/0x80
Mar  2 09:20:02 x4 kernel: [<ffffffff81698a92>] ? system_call_fastpath+0x12/0x17
Mar  2 09:20:02 x4 kernel: ---[ end trace de951903f2a71b04 ]---
Mar  2 09:20:02 x4 kernel: ------------[ cut here ]------------
Mar  2 09:20:02 x4 kernel: WARNING: CPU: 0 PID: 14596 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
Mar  2 09:20:02 x4 kernel: CPU: 0 PID: 14596 Comm: rm Tainted: G        W       4.0.0-rc1-00151-ga38ecbbd0be0-dirty #110
Mar  2 09:20:02 x4 kernel: Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Mar  2 09:20:02 x4 kernel: 0000000000000000 ffffffff8199e119 ffffffff8169214e 0000000000000000
Mar  2 09:20:02 x4 kernel: ffffffff8106c4f2 0000000000000000 ffff8801095b8910 ffff880216a6d000
Mar  2 09:20:02 x4 kernel: ffff88007060beb8 ffff8801095b8910 ffffffff8121a332 ffff88019db09000
Mar  2 09:20:02 x4 kernel: Call Trace:
Mar  2 09:20:02 x4 kernel: [<ffffffff8169214e>] ? dump_stack+0x40/0x50
Mar  2 09:20:02 x4 kernel: [<ffffffff8106c4f2>] ? warn_slowpath_common+0x72/0xc0
Mar  2 09:20:02 x4 kernel: [<ffffffff8121a332>] ? btrfs_destroy_inode+0x1f2/0x2a0
Mar  2 09:20:02 x4 kernel: [<ffffffff8111e9e7>] ? do_unlinkat+0x127/0x300
Mar  2 09:20:02 x4 kernel: [<ffffffff81082dd4>] ? task_work_run+0xb4/0x100
Mar  2 09:20:02 x4 kernel: [<ffffffff8103aad5>] ? do_notify_resume+0x55/0x80
Mar  2 09:20:02 x4 kernel: [<ffffffff81698a92>] ? system_call_fastpath+0x12/0x17
Mar  2 09:20:02 x4 kernel: ---[ end trace de951903f2a71b05 ]---
Mar  2 09:20:02 x4 kernel: ------------[ cut here ]------------
Mar  2 09:20:02 x4 kernel: WARNING: CPU: 0 PID: 14596 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
Mar  2 09:20:02 x4 kernel: CPU: 0 PID: 14596 Comm: rm Tainted: G        W       4.0.0-rc1-00151-ga38ecbbd0be0-dirty #110
Mar  2 09:20:02 x4 kernel: Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Mar  2 09:20:02 x4 kernel: 0000000000000000 ffffffff8199e119 ffffffff8169214e 0000000000000000
Mar  2 09:20:02 x4 kernel: ffffffff8106c4f2 0000000000000000 ffff88007fda01b0 ffff880216a6d000
Mar  2 09:20:02 x4 kernel: ffff88007060beb8 ffff88007fda01b0 ffffffff8121a3b8 ffff88019db09000
Mar  2 09:20:02 x4 kernel: Call Trace:
Mar  2 09:20:02 x4 kernel: [<ffffffff8169214e>] ? dump_stack+0x40/0x50
Mar  2 09:20:02 x4 kernel: [<ffffffff8106c4f2>] ? warn_slowpath_common+0x72/0xc0
Mar  2 09:20:02 x4 kernel: [<ffffffff8121a3b8>] ? btrfs_destroy_inode+0x278/0x2a0
Mar  2 09:20:02 x4 kernel: [<ffffffff8111e9e7>] ? do_unlinkat+0x127/0x300
Mar  2 09:20:02 x4 kernel: [<ffffffff81082dd4>] ? task_work_run+0xb4/0x100
Mar  2 09:20:02 x4 kernel: [<ffffffff8103aad5>] ? do_notify_resume+0x55/0x80
Mar  2 09:20:02 x4 kernel: [<ffffffff81698a92>] ? system_call_fastpath+0x12/0x17
Mar  2 09:20:02 x4 kernel: ---[ end trace de951903f2a71b06 ]---
Mar  2 09:20:02 x4 kernel: ------------[ cut here ]------------
Mar  2 09:20:02 x4 kernel: WARNING: CPU: 0 PID: 14596 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
Mar  2 09:20:02 x4 kernel: CPU: 0 PID: 14596 Comm: rm Tainted: G        W       4.0.0-rc1-00151-ga38ecbbd0be0-dirty #110
Mar  2 09:20:02 x4 kernel: Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Mar  2 09:20:02 x4 kernel: 0000000000000000 ffffffff8199e119 ffffffff8169214e 0000000000000000
Mar  2 09:20:02 x4 kernel: ffffffff8106c4f2 0000000000000000 ffff88007fda01b0 ffff880216a6d000
Mar  2 09:20:02 x4 kernel: ffff88007060beb8 ffff88007fda01b0 ffffffff8121a332 ffff88019db09000
Mar  2 09:20:02 x4 kernel: Call Trace:
Mar  2 09:20:02 x4 kernel: [<ffffffff8169214e>] ? dump_stack+0x40/0x50
Mar  2 09:20:02 x4 kernel: [<ffffffff8106c4f2>] ? warn_slowpath_common+0x72/0xc0
Mar  2 09:20:02 x4 kernel: [<ffffffff8121a332>] ? btrfs_destroy_inode+0x1f2/0x2a0
Mar  2 09:20:02 x4 kernel: [<ffffffff8111e9e7>] ? do_unlinkat+0x127/0x300
Mar  2 09:20:02 x4 kernel: [<ffffffff81082dd4>] ? task_work_run+0xb4/0x100
Mar  2 09:20:02 x4 kernel: [<ffffffff8103aad5>] ? do_notify_resume+0x55/0x80
Mar  2 09:20:02 x4 kernel: [<ffffffff81698a92>] ? system_call_fastpath+0x12/0x17
Mar  2 09:20:02 x4 kernel: ---[ end trace de951903f2a71b07 ]---

-- 
Markus
