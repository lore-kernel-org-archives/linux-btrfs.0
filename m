Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2GFBBm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 21:01:42 -0400
Message-ID: <4FF63B53.8020300@cn.fujitsu.com>
Date: Fri, 06 Jul 2012 09:11:47 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Oops on mounting (presumably damaged) btrfs filesystem
References: <20120705195243.GA11787@elliptictech.com>
In-Reply-To: <20120705195243.GA11787@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/2012 03:52 AM, Nick Bowler wrote:

> Hi folks,
> 
> I got bored while running the Debian installer (installing to btrfs)
> so I hard-reset the machine during install.  The filesystem presumably
> suffered due to the reset, but I'm now getting oopses on attempts to
> mount it again.  I get dropped back to the shell after the first
> attempt, attempting to mount it again appears to hang forever.
> 
> All of this was with Linus' git as of yesterday (July 4th, 2012).  Oops
> output is appended.  The crash seems to be reproducible, so I can
> probably test things on the image I'm creating of it now.
> 


Hi Nick,

Thanks a lot for the bug report!

This one has been fixed in the latest btrfs upstream.

FYI, the patch refers to
http://www.spinics.net/lists/linux-btrfs/msg17475.html

thanks,
liubo


>   btrfs: bdev /dev/mmcblk0p2 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
>   Btrfs detected SSD devices, enabling SSD mode
>   ------------[ cut here ]------------
>   kernel BUG at /scratch_space/linux/fs/btrfs/inode.c:3758!
>   Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
>   Modules linked in:
>   CPU: 0    Not tainted  (3.5.0-rc5-00017-g3fbd764 #89)
>   PC is at btrfs_evict_inode+0xcc/0x324
>   LR is at btrfs_lookup_first_ordered_extent+0x6c/0xdc
>   pc : [<c019c6b4>]    lr : [<c01b465c>]    psr: 60000013
>   sp : ef18dc70  ip : 00000000  fp : ef342200
>   r10: eec6b150  r9 : ef35e800  r8 : 00001000
>   r7 : 00001000  r6 : ffffffff  r5 : eec6b150  r4 : ef37cc00
>   r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 00000000
>   Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>   Control: 18c5387d  Table: 2f36c059  DAC: 00000015
>   Process exe (pid: 36, stack limit = 0xef18c2e8)
>   Stack: (0xef18dc70 to 0xef18e000)
>   dc60:                                     ffffffff ffffffff ef1ed4c0 c0035fc8
>   dc80: ef18dc80 eec6b150 c03d2218 ffffffff ffffffff eec1c428 ef35e800 eec6b150
>   dca0: ef342200 c00a12d8 00000000 eec18738 ef37cc00 c01d29d8 00000001 00000001
>   dcc0: eec186c8 fff986d0 ffffffff 9930ffff 00000015 f9000000 ffffffff 30ffffff
>   dce0: 00001599 00000000 eec18738 eec18738 ef35e000 ef35c000 00000000 eec1c428
>   dd00: ef35e400 c01d5bd0 00000000 00000000 00000077 00000000 00000000 00000000
>   dd20: 00000000 00000002 ef37cc00 eec1c428 c01d4690 fffffffa ffffffff ffffff84
>   dd40: ffffffff fffffaff ffffffff 010084ff 00000000 01000000 00000000 ff840000
>   dd60: ffffffff faffffff ffffffff 84ffffff 00000100 00000000 ef342200 ef35e400
>   dd80: 00001000 ef35c000 ef358000 ef344000 ef35c3cc c018fae4 00001000 ef35c000
>   dda0: 00000077 00000000 00000076 00000000 08fcd000 00000000 ef3280c0 ef344400
>   ddc0: ef344800 ef35c1a8 00001000 ef35e800 ef35c2bc ef35c2ec ef35c40c ef35c44c
>   dde0: ef35c5cc ef35c60c ef35c68c ef35c48c ef35c4cc ef35c50c ef35c54c ef35c58c
>   de00: ef35c6cc ef35c64c 00001000 00001000 ef35c304 ef35c0ac 00000003 c0749f50
>   de20: 10008000 c0220ffc ef18de8c 00000009 00000000 00000000 c0749f50 ef342200
>   de40: ef35c000 00000001 00000000 ef35c000 00000003 c0749f50 10008000 c016763c
>   de60: eec0c050 ef18dec8 ef18c000 c0096938 ef18de88 ef18dea3 00000000 00000000
>   de80: ef0f1240 00000000 00000000 62636d6d 70306b6c ef180032 c076a368 0000000e
>   dea0: ef006840 00000000 ef18c000 c0219e04 ef18dec8 ef0101b8 00000000 c0088824
>   dec0: c076b414 ef3280c0 c076a368 ef0f1240 0000000f ef00fec0 c0749f50 00008000
>   dee0: 00000000 c0749f50 ef18c000 ef31c1c0 001803b9 c008e1e4 c0749f50 00008000
>   df00: ef00fec0 ef0f1240 00008000 c00a47c8 c0749f50 ef31c1c0 00000000 ef0f1240
>   df20: 00008000 c00a4870 00000020 ef0f1240 00008000 00008000 00000000 c00a6454
>   df40: ef00fb10 eec101a0 00000000 0000000f beadffbe c0071184 ef12c000 beadffbe
>   df60: 00008000 00000000 c000d8a4 ef18c000 00000000 c00a6560 00000000 ef1ed4c0
>   df80: c001f224 ef31c1c0 ef0f1240 00000000 00000000 00000000 00000000 beadffbe
>   dfa0: 00000015 c000d700 00000000 00000000 beadffbe beadffcd 001971e0 00008000
>   dfc0: 00000000 00000000 beadffbe 00000015 beadffcd 00000000 001971e0 001803b9
>   dfe0: 001964e0 beadfb08 0007263c 0000b960 60000010 beadffbe 00000100 00000000
>   [<c019c6b4>] (btrfs_evict_inode+0xcc/0x324) from [<c00a12d8>] (evict+0xc0/0x1a0)
>   [<c00a12d8>] (evict+0xc0/0x1a0) from [<c01d29d8>] (fixup_inode_link_counts+0x210/0x24c)
>   [<c01d29d8>] (fixup_inode_link_counts+0x210/0x24c) from [<c01d5bd0>] (btrfs_recover_log_trees+0x3b4/0x53c)
>   [<c01d5bd0>] (btrfs_recover_log_trees+0x3b4/0x53c) from [<c018fae4>] (open_ctree+0x12d8/0x1628)
>   [<c018fae4>] (open_ctree+0x12d8/0x1628) from [<c016763c>] (btrfs_mount+0x448/0x8cc)
>   [<c016763c>] (btrfs_mount+0x448/0x8cc) from [<c008e1e4>] (mount_fs+0x10/0xb0)
>   [<c008e1e4>] (mount_fs+0x10/0xb0) from [<c00a47c8>] (vfs_kern_mount+0x4c/0xc0)
>   [<c00a47c8>] (vfs_kern_mount+0x4c/0xc0) from [<c00a4870>] (do_kern_mount+0x34/0xd0)
>   [<c00a4870>] (do_kern_mount+0x34/0xd0) from [<c00a6454>] (do_mount+0x634/0x6b4)
>   [<c00a6454>] (do_mount+0x634/0x6b4) from [<c00a6560>] (sys_mount+0x84/0xc4)
>   [<c00a6560>] (sys_mount+0x84/0xc4) from [<c000d700>] (ret_fast_syscall+0x0/0x30)
>   Code: 0a000003 e5153068 e3130020 1a000090 (e7f001f2) 
>   ---[ end trace 17a5b691ca137350 ]---
> 
> Let me know if you need any more info,


