Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:50065 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcBMGuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 01:50:50 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: enospc while having a lot of free space with kernel 4.4
Message-ID: <56BED257.5080107@profihost.ag>
Date: Sat, 13 Feb 2016 07:51:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while running 4.4 i got the following enospc error today:

[813092.863118] BTRFS info (device dm-0): 9 enospc errors during balance
[813124.251578] ------------[ cut here ]------------
[813124.317337] WARNING: CPU: 16 PID: 12647 at 
fs/btrfs/extent-tree.c:5627 btrfs_free_block_groups+0x36d/0x410 [btrfs]()
[813124.385893] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 
xt_multiport iptable_filter ip_tables x_tables 8021q garp bonding 
coretemp loop usbhid ehci_pci sb_edac ehci_hcd i2c_i801 usbcore ipmi_si 
shpchp i2c_core edac_core usb_common ipmi_msghandler button btrfs 
lzo_compress dm_mod raid456 async_raid6_recov async_memcpy async_pq 
async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod i40e(O) ixgbe 
vxlan ip6_udp_tunnel mdio udp_tunnel aacraid ahci ptp libahci pps_core
[813124.671896] CPU: 16 PID: 12647 Comm: umount Tainted: G           O 
   4.4.1+75-ph #1
[813124.743694] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 
02/18/2015
[813124.815763]  ffffffffc05cecb8 ffff8800449d3d18 ffffffff9f69c6eb 
0000000000000001
[813124.887992]  0000000000000000 ffff8800449d3d58 ffffffff9f080d67 
ffff880800000000
[813124.959366]  0000000000000000 ffff88084e4c5e00 ffff88105a8c0088 
ffff88105a8c0000
[813125.030580] Call Trace:
[813125.101337]  [<ffffffff9f69c6eb>] dump_stack+0x45/0x57
[813125.173135]  [<ffffffff9f080d67>] warn_slowpath_common+0x97/0xe0
[813125.244389]  [<ffffffff9f080dca>] warn_slowpath_null+0x1a/0x20
[813125.314609]  [<ffffffffc052cc8d>] 
btrfs_free_block_groups+0x36d/0x410 [btrfs]
[813125.384885]  [<ffffffffc053e8e1>] close_ctree+0x161/0x350 [btrfs]
[813125.454695]  [<ffffffffc050c019>] btrfs_put_super+0x19/0x20 [btrfs]
[813125.524065]  [<ffffffff9f1c6cfa>] generic_shutdown_super+0x6a/0xf0
[813125.593058]  [<ffffffff9f1c6e16>] kill_anon_super+0x16/0x30
[813125.661281]  [<ffffffffc0511aba>] btrfs_kill_super+0x1a/0xb0 [btrfs]
[813125.729378]  [<ffffffff9f1c6159>] deactivate_locked_super+0x59/0x90
[813125.797076]  [<ffffffff9f1c710e>] deactivate_super+0x4e/0x70
[813125.863845]  [<ffffffff9f1e2913>] cleanup_mnt+0x43/0x90
[813125.929791]  [<ffffffff9f1e29b2>] __cleanup_mnt+0x12/0x20
[813125.995128]  [<ffffffff9f09d5ff>] task_work_run+0xbf/0x100
[813126.059577]  [<ffffffff9f003bf8>] do_notify_resume+0x88/0xa0
[813126.123466]  [<ffffffff9f6a317c>] int_signal+0x12/0x17
[813126.185458] ---[ end trace 7b55f76aa5441be3 ]---
[813126.245655] ------------[ cut here ]------------
[813126.305121] WARNING: CPU: 16 PID: 12647 at 
fs/btrfs/extent-tree.c:5628 btrfs_free_block_groups+0x407/0x410 [btrfs]()
[813126.367555] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 
xt_multiport iptable_filter ip_tables x_tables 8021q garp bonding 
coretemp loop usbhid ehci_pci sb_edac ehci_hcd i2c_i801 usbcore ipmi_si 
shpchp i2c_core edac_core usb_common ipmi_msghandler button btrfs 
lzo_compress dm_mod raid456 async_raid6_recov async_memcpy async_pq 
async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod i40e(O) ixgbe 
vxlan ip6_udp_tunnel mdio udp_tunnel aacraid ahci ptp libahci pps_core
[813126.632661] CPU: 16 PID: 12647 Comm: umount Tainted: G        W  O 
   4.4.1+75-ph #1
[813126.702226] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 
02/18/2015
[813126.773125]  ffffffffc05cecb8 ffff8800449d3d18 ffffffff9f69c6eb 
0000000000000001
[813126.845191]  0000000000000000 ffff8800449d3d58 ffffffff9f080d67 
ffff880800000000
[813126.917417]  0000000000000000 ffff88084e4c5e00 ffff88105a8c0088 
ffff88105a8c0000
[813126.990057] Call Trace:
[813127.062505]  [<ffffffff9f69c6eb>] dump_stack+0x45/0x57
[813127.136193]  [<ffffffff9f080d67>] warn_slowpath_common+0x97/0xe0
[813127.210406]  [<ffffffff9f080dca>] warn_slowpath_null+0x1a/0x20
[813127.284850]  [<ffffffffc052cd27>] 
btrfs_free_block_groups+0x407/0x410 [btrfs]
[813127.360570]  [<ffffffffc053e8e1>] close_ctree+0x161/0x350 [btrfs]
[813127.436444]  [<ffffffffc050c019>] btrfs_put_super+0x19/0x20 [btrfs]
[813127.511948]  [<ffffffff9f1c6cfa>] generic_shutdown_super+0x6a/0xf0
[813127.587045]  [<ffffffff9f1c6e16>] kill_anon_super+0x16/0x30
[813127.660265]  [<ffffffffc0511aba>] btrfs_kill_super+0x1a/0xb0 [btrfs]
[813127.731996]  [<ffffffff9f1c6159>] deactivate_locked_super+0x59/0x90
[813127.801914]  [<ffffffff9f1c710e>] deactivate_super+0x4e/0x70
[813127.869476]  [<ffffffff9f1e2913>] cleanup_mnt+0x43/0x90
[813127.934710]  [<ffffffff9f1e29b2>] __cleanup_mnt+0x12/0x20
[813127.998514]  [<ffffffff9f09d5ff>] task_work_run+0xbf/0x100
[813128.061162]  [<ffffffff9f003bf8>] do_notify_resume+0x88/0xa0
[813128.122896]  [<ffffffff9f6a317c>] int_signal+0x12/0x17
[813128.184543] ---[ end trace 7b55f76aa5441be4 ]---
[813128.246432] ------------[ cut here ]------------
[813128.307442] WARNING: CPU: 16 PID: 12647 at 
fs/btrfs/extent-tree.c:9879 btrfs_free_block_groups+0x2b1/0x410 [btrfs]()
[813128.371548] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 
xt_multiport iptable_filter ip_tables x_tables 8021q garp bonding 
coretemp loop usbhid ehci_pci sb_edac ehci_hcd i2c_i801 usbcore ipmi_si 
shpchp i2c_core edac_core usb_common ipmi_msghandler button btrfs 
lzo_compress dm_mod raid456 async_raid6_recov async_memcpy async_pq 
async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod i40e(O) ixgbe 
vxlan ip6_udp_tunnel mdio udp_tunnel aacraid ahci ptp libahci pps_core
[813128.649013] CPU: 16 PID: 12647 Comm: umount Tainted: G        W  O 
   4.4.1+75-ph #1
[813128.721306] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 
02/18/2015
[813128.794174]  ffffffffc05cecb8 ffff8800449d3d18 ffffffff9f69c6eb 
0000000000000001
[813128.867996]  0000000000000000 ffff8800449d3d58 ffffffff9f080d67 
ffff88084ddee690
[813128.941742]  0000000000000038 0000000000000000 ffff88084e4c6288 
ffff88105a8c0000
[813129.015372] Call Trace:
[813129.088536]  [<ffffffff9f69c6eb>] dump_stack+0x45/0x57
[813129.162742]  [<ffffffff9f080d67>] warn_slowpath_common+0x97/0xe0
[813129.237499]  [<ffffffff9f080dca>] warn_slowpath_null+0x1a/0x20
[813129.312061]  [<ffffffffc052cbd1>] 
btrfs_free_block_groups+0x2b1/0x410 [btrfs]
[813129.387429]  [<ffffffffc053e8e1>] close_ctree+0x161/0x350 [btrfs]
[813129.462881]  [<ffffffffc050c019>] btrfs_put_super+0x19/0x20 [btrfs]
[813129.538262]  [<ffffffff9f1c6cfa>] generic_shutdown_super+0x6a/0xf0
[813129.613885]  [<ffffffff9f1c6e16>] kill_anon_super+0x16/0x30
[813129.687827]  [<ffffffffc0511aba>] btrfs_kill_super+0x1a/0xb0 [btrfs]
[813129.760152]  [<ffffffff9f1c6159>] deactivate_locked_super+0x59/0x90
[813129.830660]  [<ffffffff9f1c710e>] deactivate_super+0x4e/0x70
[813129.898771]  [<ffffffff9f1e2913>] cleanup_mnt+0x43/0x90
[813129.964646]  [<ffffffff9f1e29b2>] __cleanup_mnt+0x12/0x20
[813130.029038]  [<ffffffff9f09d5ff>] task_work_run+0xbf/0x100
[813130.092378]  [<ffffffff9f003bf8>] do_notify_resume+0x88/0xa0
[813130.154806]  [<ffffffff9f6a317c>] int_signal+0x12/0x17
[813130.217147] ---[ end trace 7b55f76aa5441be5 ]---
[813130.279745] BTRFS: space_info 4 has 81955274752 free, is not full
[813130.342422] BTRFS: space_info total=293668388864, used=211713048576, 
pinned=0, reserved=0, may_use=928933888000, readonly=65536

Stefan
