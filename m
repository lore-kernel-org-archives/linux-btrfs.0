Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:52879 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750747AbcIMHbN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 03:31:13 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: ENOSPACE linux 4.8-rc6 BTRFS: space_info 4 has 18446743524878843904
 free, is not full
Message-ID: <836570fd-0942-5aa1-b290-f72f5b261439@profihost.ag>
Date: Tue, 13 Sep 2016 09:31:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is vanilla linux 4.8-rc6 and i still have ENOSPC issues with btrfs
- caused by wrong space_tree entries.

[ 9736.921995] ------------[ cut here ]------------
[ 9736.923342] WARNING: CPU: 1 PID: 23942 at fs/btrfs/extent-tree.c:5734
btrfs_free_block_groups+0x35e/0x440 [btrfs]
[ 9736.926229] Modules linked in: netconsole xt_multiport iptable_filter
ip_tables x_tables 8021q garp bonding sb_edac edac_core
x86_pkg_temp_thermal coretemp kvm_intel kvm ipmi_si irqbypass i2c_i801
crc32_pclmul i2c_smbus shpchp ghash_clmulni_intel ipmi_msghandler button
loop btrfs dm_mod raid10 raid0 multipath linear raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
raid1 md_mod sg sd_mod usbhid xhci_pci igb ehci_pci i2c_algo_bit
xhci_hcd ehci_hcd i40e i2c_core ahci usbcore ptp usb_common libahci
aacraid pps_core
[ 9736.941228] CPU: 1 PID: 23942 Comm: umount Not tainted 4.8.0-rc6 #6
[ 9736.943497] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0
12/17/2015
[ 9736.945561]  0000000000000000 ffff8a571d3d3cf8 ffffffffa33de0b3
0000000000000000
[ 9736.947720]  0000000000000000 ffff8a571d3d3d38 ffffffffa3084e01
00001666a30e2499
[ 9736.949880]  0000000000000000 ffff8a577b216088 ffff8a577b216000
ffff8a577aa17200
[ 9736.952043] Call Trace:
[ 9736.952711]  [<ffffffffa33de0b3>] dump_stack+0x63/0x90
[ 9736.954139]  [<ffffffffa3084e01>] __warn+0xd1/0xf0
[ 9736.955466]  [<ffffffffa3084eed>] warn_slowpath_null+0x1d/0x20
[ 9737.022831]  [<ffffffffc04222ae>] btrfs_free_block_groups+0x35e/0x440
[btrfs]
[ 9737.091125]  [<ffffffffc043412d>] close_ctree+0x15d/0x340 [btrfs]
[ 9737.159547]  [<ffffffffc0405749>] btrfs_put_super+0x19/0x20 [btrfs]
[ 9737.227648]  [<ffffffffa31e411f>] generic_shutdown_super+0x6f/0x100
[ 9737.295227]  [<ffffffffa31e41c2>] kill_anon_super+0x12/0x20
[ 9737.362199]  [<ffffffffc04064d6>] btrfs_kill_super+0x16/0xa0 [btrfs]
[ 9737.428716]  [<ffffffffa31e3b63>] deactivate_locked_super+0x43/0x70
[ 9737.494608]  [<ffffffffa31e3bec>] deactivate_super+0x5c/0x60
[ 9737.559338]  [<ffffffffa320096f>] cleanup_mnt+0x3f/0x90
[ 9737.623414]  [<ffffffffa3200a02>] __cleanup_mnt+0x12/0x20
[ 9737.687439]  [<ffffffffa30a1d3e>] task_work_run+0x7e/0xa0
[ 9737.750376]  [<ffffffffa3002630>] exit_to_usermode_loop+0xb0/0xc0
[ 9737.813436]  [<ffffffffa3002c29>] do_syscall_64+0x189/0x1f0
[ 9737.875948]  [<ffffffffa36de4e1>] entry_SYSCALL64_slow_path+0x25/0x25
[ 9737.938449] ---[ end trace 767418320c59f391 ]---
[ 9738.000649] ------------[ cut here ]------------
[ 9738.062721] WARNING: CPU: 1 PID: 23942 at fs/btrfs/extent-tree.c:5735
btrfs_free_block_groups+0x37d/0x440 [btrfs]
[ 9738.128037] Modules linked in: netconsole xt_multiport iptable_filter
ip_tables x_tables 8021q garp bonding sb_edac edac_core
x86_pkg_temp_thermal coretemp kvm_intel kvm ipmi_si irqbypass i2c_i801
crc32_pclmul i2c_smbus shpchp ghash_clmulni_intel ipmi_msghandler button
loop btrfs dm_mod raid10 raid0 multipath linear raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
raid1 md_mod sg sd_mod usbhid xhci_pci igb ehci_pci i2c_algo_bit
xhci_hcd ehci_hcd i40e i2c_core ahci usbcore ptp usb_common libahci
aacraid pps_core
[ 9738.487487] CPU: 1 PID: 23942 Comm: umount Tainted: G        W
4.8.0-rc6 #6
[ 9738.564325] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0
12/17/2015
[ 9738.641240]  0000000000000000 ffff8a571d3d3cf8 ffffffffa33de0b3
0000000000000000
[ 9738.719075]  0000000000000000 ffff8a571d3d3d38 ffffffffa3084e01
00001667a30e2499
[ 9738.796597]  0000000000000000 ffff8a577b216088 ffff8a577b216000
ffff8a577aa17200
[ 9738.874120] Call Trace:
[ 9738.950936]  [<ffffffffa33de0b3>] dump_stack+0x63/0x90
[ 9739.028733]  [<ffffffffa3084e01>] __warn+0xd1/0xf0
[ 9739.106261]  [<ffffffffa3084eed>] warn_slowpath_null+0x1d/0x20
[ 9739.184672]  [<ffffffffc04222cd>] btrfs_free_block_groups+0x37d/0x440
[btrfs]
[ 9739.263666]  [<ffffffffc043412d>] close_ctree+0x15d/0x340 [btrfs]
[ 9739.341059]  [<ffffffffc0405749>] btrfs_put_super+0x19/0x20 [btrfs]
[ 9739.416799]  [<ffffffffa31e411f>] generic_shutdown_super+0x6f/0x100
[ 9739.490619]  [<ffffffffa31e41c2>] kill_anon_super+0x12/0x20
[ 9739.562240]  [<ffffffffc04064d6>] btrfs_kill_super+0x16/0xa0 [btrfs]
[ 9739.632301]  [<ffffffffa31e3b63>] deactivate_locked_super+0x43/0x70
[ 9739.700692]  [<ffffffffa31e3bec>] deactivate_super+0x5c/0x60
[ 9739.767536]  [<ffffffffa320096f>] cleanup_mnt+0x3f/0x90
[ 9739.833250]  [<ffffffffa3200a02>] __cleanup_mnt+0x12/0x20
[ 9739.898076]  [<ffffffffa30a1d3e>] task_work_run+0x7e/0xa0
[ 9739.962977]  [<ffffffffa3002630>] exit_to_usermode_loop+0xb0/0xc0
[ 9740.028080]  [<ffffffffa3002c29>] do_syscall_64+0x189/0x1f0
[ 9740.092352]  [<ffffffffa36de4e1>] entry_SYSCALL64_slow_path+0x25/0x25
[ 9740.156898] ---[ end trace 767418320c59f392 ]---
[ 9740.221712] ------------[ cut here ]------------
[ 9740.286589] WARNING: CPU: 1 PID: 23942 at
fs/btrfs/extent-tree.c:10062 btrfs_free_block_groups+0x2a9/0x440 [btrfs]
[ 9740.354299] Modules linked in: netconsole xt_multiport iptable_filter
ip_tables x_tables 8021q garp bonding sb_edac edac_core
x86_pkg_temp_thermal coretemp kvm_intel kvm ipmi_si irqbypass i2c_i801
crc32_pclmul i2c_smbus shpchp ghash_clmulni_intel ipmi_msghandler button
loop btrfs dm_mod raid10 raid0 multipath linear raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
raid1 md_mod sg sd_mod usbhid xhci_pci igb ehci_pci i2c_algo_bit
xhci_hcd ehci_hcd i40e i2c_core ahci usbcore ptp usb_common libahci
aacraid pps_core
[ 9740.720097] CPU: 1 PID: 23942 Comm: umount Tainted: G        W
4.8.0-rc6 #6
[ 9740.797412] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0
12/17/2015
[ 9740.875649]  0000000000000000 ffff8a571d3d3cf8 ffffffffa33de0b3
0000000000000000
[ 9740.954888]  0000000000000000 ffff8a571d3d3d38 ffffffffa3084e01
0000274ea33e06ec
[ 9741.033960]  ffff8a577aa15a00 ffff8a577aa15a88 ffff8a577b216000
ffff8a577aa169f8
[ 9741.113772] Call Trace:
[ 9741.192888]  [<ffffffffa33de0b3>] dump_stack+0x63/0x90
[ 9741.272918]  [<ffffffffa3084e01>] __warn+0xd1/0xf0
[ 9741.352483]  [<ffffffffa3084eed>] warn_slowpath_null+0x1d/0x20
[ 9741.431727]  [<ffffffffc04221f9>] btrfs_free_block_groups+0x2a9/0x440
[btrfs]
[ 9741.511753]  [<ffffffffc043412d>] close_ctree+0x15d/0x340 [btrfs]
[ 9741.590130]  [<ffffffffc0405749>] btrfs_put_super+0x19/0x20 [btrfs]
[ 9741.666770]  [<ffffffffa31e411f>] generic_shutdown_super+0x6f/0x100
[ 9741.741494]  [<ffffffffa31e41c2>] kill_anon_super+0x12/0x20
[ 9741.814069]  [<ffffffffc04064d6>] btrfs_kill_super+0x16/0xa0 [btrfs]
[ 9741.885088]  [<ffffffffa31e3b63>] deactivate_locked_super+0x43/0x70
[ 9741.954383]  [<ffffffffa31e3bec>] deactivate_super+0x5c/0x60
[ 9742.022136]  [<ffffffffa320096f>] cleanup_mnt+0x3f/0x90
[ 9742.088460]  [<ffffffffa3200a02>] __cleanup_mnt+0x12/0x20
[ 9742.153831]  [<ffffffffa30a1d3e>] task_work_run+0x7e/0xa0
[ 9742.219249]  [<ffffffffa3002630>] exit_to_usermode_loop+0xb0/0xc0
[ 9742.284862]  [<ffffffffa3002c29>] do_syscall_64+0x189/0x1f0
[ 9742.349544]  [<ffffffffa36de4e1>] entry_SYSCALL64_slow_path+0x25/0x25
[ 9742.414465] ---[ end trace 767418320c59f393 ]---
[ 9742.479603] BTRFS: space_info 4 has 18446743524878843904 free, is not
full
[ 9742.546006] BTRFS: space_info total=72477573120, used=63510200320,
pinned=0, reserved=0, may_use=557798080512, readonly=0
[ 9742.643303] BTRFS info (device dm-0): force zlib compression
[ 9742.711670] BTRFS info (device dm-0): using free space tree
[ 9742.779568] BTRFS info (device dm-0): has skinny extents

Stefan
