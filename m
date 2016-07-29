Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:32018 "EHLO
	cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbcG2Skb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 14:40:31 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: osandov@osandov.com
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: memory overflow or undeflow in free space tree / space_info?
Message-ID: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
Date: Fri, 29 Jul 2016 20:40:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

i'm seeing btrfs no space messages frequently on big filesystems (> 30TB).

In all cases i'm getting a trace like this one a space_info warning.
(since commit [1]). Could someone please be so kind and help me
debugging / fixing this bug? I'm using space_cache=v2 on all those systems.

------------[ cut here ]------------
WARNING: CPU: 5 PID: 26421 at fs/btrfs/extent-tree.c:5710
btrfs_free_block_groups+0x35a/0x400 [btrfs]()
Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 mpt3sas
raid_class scsi_transport_sas xt_multiport iptable_filter ip_tables
x_tables 8021q garp bonding coretemp loop i40e(O) vxlan ip6_udp_tunnel
usbhid udp_tunnel sb_edac ehci_pci edac_core ehci_hcd i2c_i801 i2c_core
usbcore shpchp usb_common ipmi_si ipmi_msghandler button btrfs dm_mod
raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx
xor raid6_pq md_mod ixgbe mdio sg sd_mod ahci ptp libahci megaraid_sas
pps_core
CPU: 5 PID: 26421 Comm: umount Tainted: G        W  O    4.4.15+43-ph #1
Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c 02/18/2015
 0000000000000000 ffff880ae8b47cd8 ffffffffbd3c712f 0000000000000000
 ffffffffc03ec603 ffff880ae8b47d18 ffffffffbd0837e7 00000047a0000000
 0000000000000000 ffff8806016a1400 ffff8808881d2088 ffff8808881d2000
Call Trace:
 [<ffffffffbd3c712f>] dump_stack+0x63/0x84
 [<ffffffffbd0837e7>] warn_slowpath_common+0x97/0xe0
 [<ffffffffbd08384a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffc034a17a>] btrfs_free_block_groups+0x35a/0x400 [btrfs]
 [<ffffffffc035ba4b>] close_ctree+0x15b/0x330 [btrfs]
 [<ffffffffc03291f9>] btrfs_put_super+0x19/0x20 [btrfs]
 [<ffffffffbd1cd33f>] generic_shutdown_super+0x6f/0x100
 [<ffffffffbd1cd866>] kill_anon_super+0x16/0x30
 [<ffffffffc032f96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
 [<ffffffffbd1cda31>] deactivate_locked_super+0x51/0x90
 [<ffffffffbd1ce42e>] deactivate_super+0x4e/0x70
 [<ffffffffbd1e9373>] cleanup_mnt+0x43/0x90
 [<ffffffffbd1e9412>] __cleanup_mnt+0x12/0x20
 [<ffffffffbd09ef8e>] task_work_run+0x7e/0xa0
 [<ffffffffbd07e550>] exit_to_usermode_loop+0x66/0x95
 [<ffffffffbd002a56>] syscall_return_slowpath+0xa6/0xf0
 [<ffffffffbd6b6f4c>] int_ret_from_sys_call+0x25/0x8f
---[ end trace bd985b05cc90617f ]---
------------[ cut here ]------------
WARNING: CPU: 5 PID: 26421 at fs/btrfs/extent-tree.c:5711
btrfs_free_block_groups+0x3f4/0x400 [btrfs]()
Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 mpt3sas
raid_class scsi_transport_sas xt_multiport iptable_filter ip_tables
x_tables 8021q garp bonding coretemp loop i40e(O) vxlan ip6_udp_tunnel
usbhid udp_tunnel sb_edac ehci_pci edac_core ehci_hcd i2c_i801 i2c_core
usbcore shpchp usb_common ipmi_si ipmi_msghandler button btrfs dm_mod
raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx
xor raid6_pq md_mod ixgbe mdio sg sd_mod ahci ptp libahci megaraid_sas
pps_core
CPU: 5 PID: 26421 Comm: umount Tainted: G        W  O    4.4.15+43-ph #1
Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c 02/18/2015
 0000000000000000 ffff880ae8b47cd8 ffffffffbd3c712f 0000000000000000
 ffffffffc03ec603 ffff880ae8b47d18 ffffffffbd0837e7 00000047a0000000
 0000000000000000 ffff8806016a1400 ffff8808881d2088 ffff8808881d2000
Call Trace:
 [<ffffffffbd3c712f>] dump_stack+0x63/0x84
 [<ffffffffbd0837e7>] warn_slowpath_common+0x97/0xe0
 [<ffffffffbd08384a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffc034a214>] btrfs_free_block_groups+0x3f4/0x400 [btrfs]
 [<ffffffffc035ba4b>] close_ctree+0x15b/0x330 [btrfs]
 [<ffffffffc03291f9>] btrfs_put_super+0x19/0x20 [btrfs]
 [<ffffffffbd1cd33f>] generic_shutdown_super+0x6f/0x100
 [<ffffffffbd1cd866>] kill_anon_super+0x16/0x30
 [<ffffffffc032f96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
 [<ffffffffbd1cda31>] deactivate_locked_super+0x51/0x90
 [<ffffffffbd1ce42e>] deactivate_super+0x4e/0x70
 [<ffffffffbd1e9373>] cleanup_mnt+0x43/0x90
 [<ffffffffbd1e9412>] __cleanup_mnt+0x12/0x20
 [<ffffffffbd09ef8e>] task_work_run+0x7e/0xa0
 [<ffffffffbd07e550>] exit_to_usermode_loop+0x66/0x95
 [<ffffffffbd002a56>] syscall_return_slowpath+0xa6/0xf0
 [<ffffffffbd6b6f4c>] int_ret_from_sys_call+0x25/0x8f
---[ end trace bd985b05cc906180 ]---
------------[ cut here ]------------
WARNING: CPU: 5 PID: 26421 at fs/btrfs/extent-tree.c:9990
btrfs_free_block_groups+0x2a4/0x400 [btrfs]()
Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 mpt3sas
raid_class scsi_transport_sas xt_multiport iptable_filter ip_tables
x_tables 8021q garp bonding coretemp loop i40e(O) vxlan ip6_udp_tunnel
usbhid udp_tunnel sb_edac ehci_pci edac_core ehci_hcd i2c_i801 i2c_core
usbcore shpchp usb_common ipmi_si ipmi_msghandler button btrfs dm_mod
raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx
xor raid6_pq md_mod ixgbe mdio sg sd_mod ahci ptp libahci megaraid_sas
pps_core
CPU: 5 PID: 26421 Comm: umount Tainted: G        W  O    4.4.15+43-ph #1
Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c 02/18/2015
 0000000000000000 ffff880ae8b47cd8 ffffffffbd3c712f 0000000000000000
 ffffffffc03ec603 ffff880ae8b47d18 ffffffffbd0837e7 ffff880c6aaa4528
 0000000000000038 0000000000000000 ffff8802fe8d8c88 ffff8808881d2000
Call Trace:
 [<ffffffffbd3c712f>] dump_stack+0x63/0x84
 [<ffffffffbd0837e7>] warn_slowpath_common+0x97/0xe0
 [<ffffffffbd08384a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffc034a0c4>] btrfs_free_block_groups+0x2a4/0x400 [btrfs]
 [<ffffffffc035ba4b>] close_ctree+0x15b/0x330 [btrfs]
 [<ffffffffc03291f9>] btrfs_put_super+0x19/0x20 [btrfs]
 [<ffffffffbd1cd33f>] generic_shutdown_super+0x6f/0x100
 [<ffffffffbd1cd866>] kill_anon_super+0x16/0x30
 [<ffffffffc032f96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
 [<ffffffffbd1cda31>] deactivate_locked_super+0x51/0x90
 [<ffffffffbd1ce42e>] deactivate_super+0x4e/0x70
 [<ffffffffbd1e9373>] cleanup_mnt+0x43/0x90
 [<ffffffffbd1e9412>] __cleanup_mnt+0x12/0x20
 [<ffffffffbd09ef8e>] task_work_run+0x7e/0xa0
 [<ffffffffbd07e550>] exit_to_usermode_loop+0x66/0x95
 [<ffffffffbd002a56>] syscall_return_slowpath+0xa6/0xf0
 [<ffffffffbd6b6f4c>] int_ret_from_sys_call+0x25/0x8f
---[ end trace bd985b05cc906181 ]---
BTRFS: space_info 4 has 18446743491956604928 free, is not full
BTRFS: space_info total=307627032576, used=206629289984, pinned=0,
reserved=0, may_use=682750558208, readonly=131072

Greets,
Stefan

[1]
https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git/commit/?h=for-next&id=d555b6c380c644af63dbdaa7cc14bba041a4e4dd
