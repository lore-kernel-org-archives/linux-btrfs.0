Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47284 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2HAFlL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 01:41:11 -0400
Received: by wgbdr13 with SMTP id dr13so6565769wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 22:41:09 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Aug 2012 13:41:09 +0800
Message-ID: <CAMVG2ssA3sm20nzuwGMsFTr1F4EzhsTy5CkHyCw-z=tptC-_SA@mail.gmail.com>
Subject: btrfs_search_slot failure...
From: Daniel J Blueman <daniel@quora.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With Chris's current for-linus branch against 3.5.0, while doing I/O
and defrag/balance/scrub for a short time, I see btrfs_search_slot
fail to find the key, leaving it's loop and returning one, tripping
this assertion [1].

Let me know if interested for more testing/details/debug.

Thanks,
  Daniel

--- [1]

kernel BUG at fs/btrfs/relocation.c:3222!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 1
Modules linked in: brd netconsole dm_crypt dm_mod coretemp kvm_intel
kvm uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops microcode iwlwifi binfmt_misc btrfs i915 cfbcopyarea
cfbimgblt cfbfillrect video [last unloaded: netconsole]

Pid: 7040, comm: btrfs Tainted: G        W    3.5.0-debug+ #4 Dell
Inc. Latitude E5420/006X7M
RIP: 0010:[<ffffffffa00fb327>]  [<ffffffffa00fb327>]
__add_tree_block.part.54+0xe7/0xf0 [btrfs]
RSP: 0018:ffff88021bbb9ad8  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff880209bec2d0 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88021bbb9b48 R08: ffff88021bbb9a94 R09: ffff88021bbb99f0
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021257e800
R13: ffff88021bbb9c40 R14: 0000000015e78000 R15: 0000000000001000
FS:  00007ff71964f740(0000) GS:ffff88022ec80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f20850da000 CR3: 000000021bdfe000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 7040, threadinfo ffff88021bbb8000, task ffff8802146e9f10)
Stack:
 0000000015e78000 0000000015e78000 ffff88021bbb9b48 8000ffffa00d1c18
 00a80000000015e7 ff00000000000010 ffff88021bbb9bb8 0000000000000000
 ffff88021bbb9b78 0000000015e78000 ffff88021257e800 0000000000001000
Call Trace:
 [<ffffffffa00fb39d>] __add_tree_block+0x6d/0xb0 [btrfs]
 [<ffffffffa00fba93>] add_data_references+0xf3/0x290 [btrfs]
 [<ffffffffa00fdebd>] relocate_block_group+0x3bd/0x560 [btrfs]
 [<ffffffffa00fe224>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
 [<ffffffffa00da31a>] btrfs_relocate_chunk.isra.55+0x4a/0x240 [btrfs]
 [<ffffffffa00d4f32>] ? free_extent_buffer+0x32/0x90 [btrfs]
 [<ffffffffa00dd78c>] __btrfs_balance+0x2fc/0x3f0 [btrfs]
 [<ffffffffa00ddb73>] btrfs_balance+0x2f3/0x4d0 [btrfs]
 [<ffffffffa00e4080>] btrfs_ioctl_balance+0x130/0x430 [btrfs]
 [<ffffffffa00e80b8>] btrfs_ioctl+0x428/0x8e0 [btrfs]
 [<ffffffff810f5baa>] ? do_brk+0x22a/0x320
 [<ffffffff8112f3d7>] do_vfs_ioctl+0x87/0x340
 [<ffffffff8122eb04>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8112f6da>] sys_ioctl+0x4a/0x80
 [<ffffffff815f6a22>] system_call_fastpath+0x16/0x1b
Code: f9 ff 8b 45 98 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0
4c 8b 7d f8 c9 c3 66 0f 1f 84 00 00 00 00 00 b8 f4 ff ff ff eb da <0f>
0b 0f 1f 80 00 00 00 00 55 89 d0 45 31 c9 48 89 e5 41 56 41
RIP  [<ffffffffa00fb327>] __add_tree_block.part.54+0xe7/0xf0 [btrfs]
 RSP <ffff88021bbb9ad8>
-- 
Daniel J Blueman
