Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57920 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3DVNZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:25:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UUGju-0004gF-SE
	for linux-btrfs@vger.kernel.org; Mon, 22 Apr 2013 15:25:02 +0200
Received: from 88-104-247-93.dynamic.dsl.as9105.com ([88.104.247.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 15:25:02 +0200
Received: from mark by 88-104-247-93.dynamic.dsl.as9105.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 15:25:02 +0200
To: linux-btrfs@vger.kernel.org
From: Mark Ridley <mark@backupsystems.co.uk>
Subject: BTRFS 3.8.7 Kernel Crash =?utf-8?b?UmVwb3J04oCP?=
Date: Mon, 22 Apr 2013 13:19:41 +0000 (UTC)
Message-ID: <loom.20130422T151604-250@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been having a kernel crash since kernel 3.3.2 and hoped it had been fixed 
by the time 3.8.7 
(FC18) but no joy.

I take backups of large image files (around 100GB) and btrfs snapshot them.

If I then use rsync --inplace to update the images, I get a btrfs stack trace 
and btrfs hangs:

This happens every night.

Here is the stack trace:

Any idea what is causing this?

Thanks,

Mark
Apr 22 13:29:29 bkserver kernel: [66320.561671] ------------[ cut here ]----
--------
Apr 22 13:29:29 bkserver kernel: [66320.561818] kernel BUG at fs/btrfs/
ctree.c:2952!
Apr 22 13:29:29 bkserver kernel: [66320.561906] invalid opcode: 0000 
[#1] SMP
Apr 22 13:29:29 bkserver kernel: [66320.562212] Modules linked in:
 ppdev parport_pc vmxnet3
 
coretemp vmw_balloon parport shpchp i2c_piix4 microcode btrfs 
zlib_deflate libcrc32c
 vmwgfx ttm 
drm vmw_pvscsi i2c_core
Apr 22 13:29:29 bkserver kernel: [66320.562538] CPU 6Apr 22 
13:29:29 bkserver kernel: 
[66320.562605] Pid: 30965, comm: btrfs-endio-wri Not tainted 
3.8.7-201.fc18.x86_64 #1 VMware, 
Inc. VMware Virtual Platform/440BX Desktop Reference Platform
Apr 22 13:29:29 bkserver kernel: [66320.562820] RIP: 0010:[<ffffffffa00bd5c1>]  
[<ffffffffa00bd5c1>] btrfs_set_item_key_safe+0x141/0x150 [btrfs]Apr 22 13:29:29
 bkserver kernel: 
[66320.563046] RSP: 0018:ffff88014763dae8  EFLAGS: 00010286
Apr 22 13:29:29 bkserver kernel: [66320.563147] RAX: 00000000ffffffff RBX:
 000000000000001a 
RCX: 0000000ce75ee000
Apr 22 13:29:29 bkserver kernel: [66320.563258] RDX: 00000000ffffffff RSI:
 ffff88014763dc16 RDI: 
ffff88014763dac7
Apr 22 13:29:29 bkserver kernel: [66320.563372] RBP: ffff88014763db48 R08: 
0000000000004b58 
R09: 00000ce75e80006c
Apr 22 13:29:29 bkserver kernel: [66320.563475] R10: 6c0000000000004b R11: 
0000000ce75e8000 R12: ffff88014763db07
Apr 22 13:29:29 bkserver kernel: [66320.563586] R13: ffff880101d151b0 R14: 
ffff88014763dc16 
R15: ffff8800afb69d90
Apr 22 13:29:29 bkserver kernel: [66320.563729] FS:  
0000000000000000(0000) 
GS:ffff8803bfd80000(0000) knlGS:0000000000000000
Apr 22 13:29:29 bkserver kernel: [66320.563842] CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Apr 22 13:29:29 bkserver kernel: [66320.563931] CR2: 0000000000440be0 
CR3: 
00000003ab6ab000 CR4: 00000000000007e0
Apr 22 13:29:29 bkserver kernel: [66320.564051] DR0: 0000000000000000
 DR1: 
0000000000000000 DR2: 0000000000000000

Apr 22 13:29:29 bkserver kernel: [66320.564185] DR3: 0000000000000000
 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Apr 22 13:29:29 bkserver kernel: [66320.564298] Process btrfs-endio-wri 
(pid: 30965, threadinfo 
ffff88014763c000, task ffff8803ab79aec0)
Apr 22 13:29:29 bkserver kernel: [66320.564455] Stack:
Apr 22 13:29:29 bkserver kernel: [66320.564558]  ffff88014763db48 
ffff8800066a9800 
ffff880131387000 5800000000000000
Apr 22 13:29:29 bkserver kernel: [66320.564662]  6c0000000000004b 
0000000ce75e8000 
ffff880100000000 ffff8800afb69d90
Apr 22 13:29:29 bkserver kernel: [66320.564755]  ffff880101d151b0 
0000000000000a69 
0000000000000000 0000000ce75d8000
Apr 22 13:29:29 bkserver kernel: [66320.564865] Call Trace:
Apr 22 13:29:29 bkserver kernel: [66320.564948]  [<ffffffffa00f1b50>] 
__btrfs_drop_extents+0x460/0xbc0 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.565048]  [<ffffffffa00cbe46>] ? 
run_clustered_refs+0x256/0xb50 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.565143]  [<ffffffffa00f740e>] ? 
alloc_extent_state+0x2e/0xc0 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.565300]  [<ffffffffa00f2d2b>] 
btrfs_drop_extents+0x6b/0xa0 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.565406]  [<ffffffffa00e31ab>] 
insert_reserved_file_extent.constprop.58+0x7b/0x2c0 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.566955]  [<ffffffffa00e06b5>] ? 
start_transaction+0x95/0x460 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.567792]  [<ffffffffa00e9004>] 
btrfs_finish_ordered_io+0x364/0x3f0 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.568534]  [<ffffffffa00e90a5>] 
finish_ordered_fn+0x15/0x20 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.569362]  [<ffffffffa0109e56>] 
worker_loop+0x136/0x580 
[btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.570101]  [<ffffffffa0109d20>] ? 
btrfs_queue_worker+0x300/0x300 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.570858]  [<ffffffff81081f40>]
 kthread+0xc0/0xd0
Apr 22 13:29:29 bkserver kernel: [66320.571561]  [<ffffffff81088f30>] ? 
set_security_override_from_ctx+0x50/0x50
Apr 22 13:29:29 bkserver kernel: [66320.572263]  [<ffffffff81010000>] ? 
perf_trace_xen_cpu_write_gdt_entry+0xa0/0x100
Apr 22 13:29:29 bkserver kernel: [66320.572924]  [<ffffffff81081e80>] ? 
kthread_create_on_node+0x120/0x120
Apr 22 13:29:29 bkserver kernel: [66320.573588]  [<ffffffff8165baac>] 
ret_from_fork+0x7c/0xb0
Apr 22 13:29:29 bkserver kernel: [66320.574225]  [<ffffffff81081e80>] ? 
kthread_create_on_node+0x120/0x120
Apr 22 13:29:29 bkserver kernel: [66320.574883] Code: 00 00 4c 89 e6 4c 
89 ff 48 98 48 8d 04 80 
48 8d 54 80 65 e8 02 0c 04 00 4c 89 f6 4c 89 e7 e8 07 f2 ff ff 85 c0 0f 
8f 5e ff ff ff <0f> 0b 0f 0b 
66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55
Apr 22 13:29:29 bkserver kernel: [66320.576813] RIP  [<ffffffffa00bd5c1>] 
btrfs_set_item_key_safe+0x141/0x150 [btrfs]
Apr 22 13:29:29 bkserver kernel: [66320.577476]  RSP <ffff88014763dae8>
Apr 22 13:29:29 bkserver kernel: [66320.579362] ---
[ end trace 0ae203d38f3d2f34 ]---

