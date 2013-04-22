Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35822 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab3DVTbA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 15:31:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UUMRz-00058x-5T
	for linux-btrfs@vger.kernel.org; Mon, 22 Apr 2013 21:30:55 +0200
Received: from 88-104-247-93.dynamic.dsl.as9105.com ([88.104.247.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 21:30:55 +0200
Received: from mark by 88-104-247-93.dynamic.dsl.as9105.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 21:30:55 +0200
To: linux-btrfs@vger.kernel.org
From: Mark Ridley <mark@backupsystems.co.uk>
Subject: 3.8.8 fc18 kernel crash when editing a file
Date: Mon, 22 Apr 2013 19:30:43 +0000 (UTC)
Message-ID: <loom.20130422T212837-865@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel: [13453.678952] ------------[ cut here ]------------
kernel: [13453
.679136] kernel BUG at fs/btrfs/file.c:861!
kernel: [13453.679380] invalid
 opcode: 0000 [#1] SMP
kernel: [13453.679612] Modules linked in: coretemp 
shpchp ppdev vmw_balloon i2c_piix4 microcode vmxnet3 parport_pc parport btr
fs zlib_deflate libcrc32c vmwgfx ttm drm vmw_pvscsi i2c_core
kernel: [1345
3.680251] CPU 0
kernel: [13453.680439] Pid: 11307, comm: btrfs-endio-wri N
ot tainted 3.8.8-202.fc18.x86_64 #1 VMware, Inc. VMware Virtual Platform/44
0BX Desktop Reference Platform
kernel: [13453.680949] RIP: 0010:[<ffffffff
a00e728d>]  [<ffffffffa00e728d>] __btrfs_drop_extents+0xb9d/0xbc0 [btrfs]

kernel: [13453.681440] RSP: 0018:ffff88010e657b58  EFLAGS: 00010297
kernel
: [13453.681687] RAX: 0000000000000010 RBX: ffff8802ce925428 RCX: 000000000
0000001
kernel: [13453.681940] RDX: 0000000000000000 RSI: 0000000000000c73
 RDI: ffff8802ce925428
kernel: [13453.682043] RBP: ffff88010e657c68 R08: 0
000000000000001 R09: ffff88010e657b08
kernel: [13453.682145] R10: 00000023
08979000 R11: 00000000ffffffff R12: ffff880100f7ad80
kernel: [13453.682247
] R13: 0000000000000c46 R14: 0000002308974000 R15: 0000002308974000
kernel
: [13453.682377] FS:  0000000000000000(0000) GS:ffff8803bfc00000(0000) knlG
S:0000000000000000
kernel: [13453.682498] CS:  0010 DS: 0000 ES: 0000 CR0:
 000000008005003bApr 22 17:26:57 bk577 kernel: [13453.683089] CR2: 00007fff
f1d900d8 CR3: 0000000383e9b000 CR4: 00000000000007f0
kernel: [13453.683906
] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel
: [13453.684640] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000
0000400
kernel: [13453.685454] Process btrfs-endio-wri (pid: 11307, thread
info ffff88010e656000, task ffff8803a83cc620)
kernel: [13453.686793] Stack
:
kernel: [13453.687439]  0000000000004b66 0000002308954000 00000000000000
00 0000000000000400
kernel: [13453.688160]  ffff880100000000 0000002300000
001 000000000000112e ffffffff8101b8e3
kernel: [13453.688885]  000000000001
5000 0000000f01010082 0000000000000000 ffff8803a97c8000
kernel: [13453.689
640] Call Trace:
kernel: [13453.690319]  [<ffffffff8101b8e3>] ? native_sch
ed_clock+0x13/0x80
kernel: [13453.691220]  [<ffffffffa00ec40e>] ? alloc_ex
tent_state+0x2e/0xc0 [btrfs]
kernel: [13453.692107]  [<ffffffffa00aee8a>] 
? btrfs_alloc_path+0x1a/0x20 [btrfs]
kernel: [13453.692981]  [<ffffffffa00
e7d2b>] btrfs_drop_extents+0x6b/0xa0 [btrfs]
kernel: [13453.693562]  [<fff
fffffa00d81ab>] insert_reserved_file_extent.constprop.58+0x7b/0x2c0 [btrfs]

kernel: [13453.696394]  [<ffffffffa00d56b5>] ? start_transaction+0x95/0x4
60 [btrfs]
kernel: [13453.697236]  [<ffffffffa00de004>] btrfs_finish_order
ed_io+0x364/0x3f0 [btrfs]
kernel: [13453.697935]  [<ffffffffa00de0a5>] fin
ish_ordered_fn+0x15/0x20 [btrfs]
kernel: [13453.698595]  [<ffffffffa00fee5
6>] worker_loop+0x136/0x580 [btrfs]
kernel: [13453.699264]  [<ffffffffa00f
ed20>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
kernel: [13453.699893]  [<
ffffffff81081f30>] kthread+0xc0/0xd0
kernel: [13453.700517]  [<ffffffff810
10000>] ? perf_trace_xen_cpu_write_gdt_entry+0xa0/0x100
kernel: [13453.701
116]  [<ffffffff81081e70>] ? kthread_create_on_node+0x120/0x120
kernel: [1
3453.701717]  [<ffffffff8165baac>] ret_from_fork+0x7c/0xb0
kernel: [13453.
702293]  [<ffffffff81081e70>] ? kthread_create_on_node+0x120/0x120
kernel:
 [13453.702857] Code: 85 7c ff ff ff 00 00 00 00 4d 89 d6 e9 76 fa ff ff 4d
 89 d5 c7 85 64 ff ff ff 01 00 00 00 e9 21 fc ff ff 0f 0b 0f 0b 0f 0b 0f 0b
 <0f> 0b 0f 0b 0f 0b 45 85 c0 75 02 0f 0b 48 8d 55 ae 45 31 f6 48
kernel: 
[13453.704595] RIP  [<ffffffffa00e728d>] __btrfs_drop_extents+0xb9d/0xbc0 [
btrfs]
kernel: [13453.705176]  RSP <ffff88010e657b58>
kernel: [13453.7074
60] ---[ end trace 730a8ff23116a46b ]-

