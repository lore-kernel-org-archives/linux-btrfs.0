Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33649 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbcG3HlZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 03:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <F9437FCA-585E-43EC-B004-72A300AC3FD6@suse.com>
References: <CADxRZqx-NJNpkA2hWeEuw_uMBB=oajUmTgMizdd2g5Ti9Cn1GQ@mail.gmail.com>
 <CAL3q7H5s_h4x6_=cUY+5VL6vG_riF9j9MuPxH032QmBFa6WU-g@mail.gmail.com>
 <CADxRZqw27A4TaYbzWLODXko3+yn=bMBEcKdsv89Jm9eqYAHEOA@mail.gmail.com> <F9437FCA-585E-43EC-B004-72A300AC3FD6@suse.com>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Sat, 30 Jul 2016 10:41:23 +0300
Message-ID: <CADxRZqxV4NYJWofpkFNrYSQonpuUAw-A3W-8U7BK3v=tAe1Q2g@mail.gmail.com>
Subject: Re: btrfs on sparc64 results in kernel stack trace in 1 minute test
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 30, 2016 at 12:52 AM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On Jul 29, 2016, at 5:11 PM, Anatoly Pugachev <matorola@gmail.com> wrote:
>> and in logs:
>>
>> Jul 30 00:05:48 nvg5120 kernel: BTRFS info (device loop0): inode
>> 227514 still on the orphan list
>> Jul 30 00:06:01 nvg5120 kernel: ------------[ cut here ]------------
>> Jul 30 00:06:01 nvg5120 kernel: WARNING: CPU: 36 PID: 3110 at
>> fs/btrfs/inode.c:3215 btrfs_orphan_commit_root+0x188/0x1a0 [btrfs]
>> Jul 30 00:06:02 nvg5120 kernel: Modules linked in: loop btrfs
>> zlib_deflate sg e1000e ptp pps_core n2_crypto(+) flash sha256_generic
>> des_generic n2_rng rng_core sunrpc autofs4 ext4 crc16 jbd2 mbcache
>> raid10 raid456 libcrc32c crc32c_generic async_raid6_recov async_memcpy
>> async_pq raid6_pq async_xor xor async_tx raid0 multipath linear dm_mod
>> raid1 md_mod sd_mod mptsas scsi_transport_sas mptscsih scsi_mod
>> mptbase
>> Jul 30 00:06:02 nvg5120 kernel: CPU: 36 PID: 3110 Comm:
>> btrfs-transacti Tainted: G      D         4.7.0+ #51
>> Jul 30 00:06:02 nvg5120 kernel: Call Trace:
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000000463e44] __warn+0xa4/0xc0
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a2ae48]
>> btrfs_orphan_commit_root+0x188/0x1a0 [btrfs]
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a214c0]
>> commit_fs_roots+0xa0/0x180 [btrfs]
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a242d0]
>> btrfs_commit_transaction+0x4b0/0xd00 [btrfs]
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a1cc30]
>> transaction_kthread+0xf0/0x1c0 [btrfs]
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000000480ff0] kthread+0xb0/0xe0
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000000406044] ret_from_fork+0x1c/0x2c
>> Jul 30 00:06:02 nvg5120 kernel:  [0000000000000000]           (null)
>> Jul 30 00:06:02 nvg5120 kernel: ---[ end trace ee8374e54a090229 ]---
>>
> This is tainted D, which means there's an Oops above this in the log.  Can you provide that?


Jeff,

it is another kernel OOPS, which i need to investigate:

Jul 29 21:25:35 nvg5120 kernel: e1000e 0000:09:00.1 enp9s0f1: renamed from eth3
Jul 29 21:25:35 nvg5120 systemd-udevd[1488]: worker [1654] terminated
by signal 9 (Killed)
Jul 29 21:25:35 nvg5120 systemd-udevd[1488]: worker [1654] failed
while handling '/devices/root/f0283a50/f028681c'
Jul 29 21:25:36 nvg5120 systemd[1]: Found device ST914602SSUN146G 1.
Jul 29 21:25:40 nvg5120 kernel: e1000e 0000:08:00.1 enp8s0f1: renamed from eth1
Jul 29 21:25:40 nvg5120 kernel: n2_crypto: md5 alg registration failed
Jul 29 21:25:40 nvg5120 kernel: n2cp f028681c:
/virtual-devices@100/n2cp@7: Unable to register algorithms.
Jul 29 21:25:40 nvg5120 kernel: sha1_sparc64: sparc64 sha1 opcode not available.
Jul 29 21:25:40 nvg5120 kernel: n2cp: probe of f028681c failed with error -22
Jul 29 21:25:40 nvg5120 kernel: n2_crypto: Found NCP at
/virtual-devices@100/ncp@6
Jul 29 21:25:40 nvg5120 kernel: n2_crypto: Registered NCS HVAPI version 2.0
Jul 29 21:25:40 nvg5120 kernel: Kernel unaligned access at TPC[577b68]
kmem_cache_alloc+0xa8/0x1a0
Jul 29 21:25:40 nvg5120 kernel: Unable to handle kernel paging request
in mna handler
Jul 29 21:25:40 nvg5120 kernel:  at virtual address 6b6aeb6f69f2cb6b
Jul 29 21:25:41 nvg5120 kernel: current->{active_,}mm->context =
00000000000007a2
Jul 29 21:25:41 nvg5120 kernel: current->{active_,}mm->pgd = ffff8003e9c72000
Jul 29 21:25:41 nvg5120 kernel:               \|/ ____ \|/
                                              "@'/ .. \`@"
                                              /_| \__/ |_\
                                                 \__U_/
Jul 29 21:25:41 nvg5120 kernel: systemd-udevd(1654): Oops [#1]
Jul 29 21:25:41 nvg5120 kernel: CPU: 56 PID: 1654 Comm: systemd-udevd
Not tainted 4.7.0+ #51
Jul 29 21:25:41 nvg5120 kernel: task: ffff8003ecf90a20 ti:
ffff8003edcd4000 task.ti: ffff8003edcd4000
Jul 29 21:25:41 nvg5120 kernel: TSTATE: 0000004411e01605 TPC:
0000000000577b68 TNPC: 0000000000577b6c Y: 00000000    Not tainted
Jul 29 21:25:41 nvg5120 kernel: TPC: <kmem_cache_alloc+0xa8/0x1a0>
Jul 29 21:25:41 nvg5120 kernel: g0: 0000000000000000 g1:
6b6b6b6b6b6b6b6b g2: 0000000000000000 g3: 0000000000000000
Jul 29 21:25:41 nvg5120 kernel: g4: ffff8003ecf90a20 g5:
ffff8003fe876000 g6: ffff8003edcd4000 g7: 000000000000cee0
Jul 29 21:25:41 nvg5120 kernel: o0: 0000000000000000 o1:
0000000003ffffff o2: 0000000000000000 o3: ffff8003eee883c0
Jul 29 21:25:41 nvg5120 kernel: o4: 0000000000000080 o5:
0000000000000011 sp: ffff8003edcd6b51 ret_pc: 0000000000577b34
Jul 29 21:25:41 nvg5120 kernel: RPC: <kmem_cache_alloc+0x74/0x1a0>
Jul 29 21:25:41 nvg5120 kernel: l0: ffff8003ffa28040 l1:
ffff8003ffa28030 l2: 000000000000d5c0 l3: 00000000009f4800
Jul 29 21:25:41 nvg5120 kernel: l4: 0000000000000000 l5:
00000000009f4c00 l6: 0000000000ab2968 l7: 0000000000ab296a
Jul 29 21:25:41 nvg5120 kernel: i0: ffff8003f1dad580 i1:
00000000024080c0 i2: 00000000106230e8 i3: 0000000000000000
Jul 29 21:25:41 nvg5120 kernel: i4: 0000000010621d90 i5:
00000000024080c0 i6: ffff8003edcd6c01 i7: 0000000010621d90
Jul 29 21:25:41 nvg5120 kernel: I7: <spu_mdesc_scan+0x470/0x4c0 [n2_crypto]>
Jul 29 21:25:41 nvg5120 kernel: Call Trace:
Jul 29 21:25:41 nvg5120 kernel:  [0000000010621d90]
spu_mdesc_scan+0x470/0x4c0 [n2_crypto]
Jul 29 21:25:41 nvg5120 kernel:  [00000000106220d4]
n2_mau_probe+0x134/0x1e0 [n2_crypto]
Jul 29 21:25:41 nvg5120 kernel:  [0000000000734bec] platform_drv_probe+0x2c/0xa0
Jul 29 21:25:41 nvg5120 kernel:  [0000000000732a20]
driver_probe_device+0x1e0/0x400
Jul 29 21:25:41 nvg5120 kernel:  [0000000000732d18] __driver_attach+0xd8/0x120
Jul 29 21:25:41 nvg5120 kernel:  [000000000073077c] bus_for_each_dev+0x3c/0xa0
Jul 29 21:25:41 nvg5120 kernel:  [0000000000731bd4] bus_add_driver+0x114/0x280
Jul 29 21:25:41 nvg5120 kernel:  [0000000000733608] driver_register+0xa8/0x100
Jul 29 21:25:41 nvg5120 kernel:  [0000000000734ea8]
__platform_register_drivers+0x88/0x160
Jul 29 21:25:41 nvg5120 kernel:  [0000000000426d00] do_one_initcall+0x80/0x160
Jul 29 21:25:41 nvg5120 kernel:  [00000000005228e8] do_init_module+0x4c/0x1c4
Jul 29 21:25:41 nvg5120 kernel:  [00000000004d9ffc] load_module+0x1efc/0x24e0
Jul 29 21:25:41 nvg5120 kernel:  [00000000004da828] SyS_finit_module+0xc8/0x100
Jul 29 21:25:41 nvg5120 kernel:  [00000000004061f4]
linux_sparc_syscall+0x34/0x44
Jul 29 21:25:41 nvg5120 kernel: Disabling lock debugging due to kernel taint
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000010621d90]:
spu_mdesc_scan+0x470/0x4c0 [n2_crypto]
Jul 29 21:25:41 nvg5120 kernel: Caller[00000000106220d4]:
n2_mau_probe+0x134/0x1e0 [n2_crypto]
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000734bec]:
platform_drv_probe+0x2c/0xa0
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000732a20]:
driver_probe_device+0x1e0/0x400
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000732d18]:
__driver_attach+0xd8/0x120
Jul 29 21:25:41 nvg5120 kernel: Caller[000000000073077c]:
bus_for_each_dev+0x3c/0xa0
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000731bd4]:
bus_add_driver+0x114/0x280
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000733608]:
driver_register+0xa8/0x100
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000734ea8]:
__platform_register_drivers+0x88/0x160
Jul 29 21:25:41 nvg5120 kernel: Caller[0000000000426d00]:
do_one_initcall+0x80/0x160
Jul 29 21:25:41 nvg5120 kernel: Caller[00000000005228e8]:
do_init_module+0x4c/0x1c4
Jul 29 21:25:41 nvg5120 kernel: Caller[00000000004d9ffc]:
load_module+0x1efc/0x24e0
Jul 29 21:25:41 nvg5120 kernel: Caller[00000000004da828]:
SyS_finit_module+0xc8/0x100
Jul 29 21:25:41 nvg5120 kernel: Caller[00000000004061f4]:
linux_sparc_syscall+0x34/0x44
Jul 29 21:25:41 nvg5120 kernel: Caller[ffff800100382290]: 0xffff800100382290
Jul 29 21:25:41 nvg5120 kernel: Instruction DUMP: 7ffac059  90122120
91d02005 <c4004005> 80a0a000  0240000f  ba004005  8400bfff  86102001
Jul 29 21:25:41 nvg5120 kernel: sha256_sparc64: sparc64 sha256 opcode
not available.
Jul 29 21:25:41 nvg5120 kernel: e1000e 0000:09:00.0 enp9s0f0: renamed from eth2

it is only appeared after I have enabled debugging on my kernel.
Difference in kernel configs, which does not have it and OOPS kernel,
i believe, i'm not sure yet, is in the following options:

 CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_INFO_DWARF4=y
+CONFIG_READABLE_ASM=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_SPINLOCK=y

so, I'm going to try to find which exact option triggers it. And maybe
someone with a better knowledge of kernel internals can spot away what
is wrong.

Thanks.
