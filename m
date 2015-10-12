Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:25254 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbJLHAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 03:00:52 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: btrfs goes readonly + No space left on 4.3
Message-ID: <561B5AA6.7040704@profihost.ag>
Date: Mon, 12 Oct 2015 09:00:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while trying to write to my volume btrfs gets readonly:

btrfs fi show /vmbackup/
Label: none  uuid: f4afaac2-c587-4ff7-87b1-19e6a483215f
         Total devices 1 FS bytes used 35.56TiB
         devid    1 size 50.93TiB used 35.72TiB path 
/dev/mapper/stripe0-vmbackup

btrfs-progs v4.1.2

btrfs fi df /vmbackup/
Data, single: total=35.40TiB, used=35.40TiB
System, DUP: total=8.00MiB, used=3.75MiB
Metadata, DUP: total=162.00GiB, used=160.72GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

This is 4.1.10 with all btrfs patches up to 4.3-rc3

[ 6230.406369] ------------[ cut here ]------------
[ 6230.411594] BTRFS warning (device dm-0): 
btrfs_finish_ordered_io:2840: Aborting unused transaction(No space left).
[ 6230.463718] BTRFS warning (device dm-0): 
btrfs_finish_ordered_io:2840: Aborting unused transaction(No space left).
[ 6230.466681] BTRFS warning (device dm-0): 
btrfs_finish_ordered_io:2840: Aborting unused transaction(No space left).
[ 6230.475887] BTRFS warning (device dm-0): 
btrfs_finish_ordered_io:2840: Aborting unused transaction(No space left).
[ 6230.505852] BTRFS warning (device dm-0): 
btrfs_finish_ordered_io:2840: Aborting unused transaction(No space left).
[ 6230.525233] BTRFS warning (device dm-0): 
btrfs_finish_ordered_io:2840: Aborting unused transaction(No space left).
[ 6230.851050] WARNING: CPU: 8 PID: 8230 at fs/btrfs/extent-tree.c:6356 
__btrfs_free_extent.isra.83+0x2cc/0xce0 [btrfs]()
[ 6230.911727] BTRFS: Transaction aborted (error -28)
[ 6230.911729] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 
xt_multiport iptable_filter ip_tables x_tables bonding ext2 coretemp 
loop usbhid ehci_pci ehci_hcd sb_edac i2c_i801 ipmi_si usbcore edac_core 
i2c_core shpchp usb_common ipmi_msghandler button btrfs lzo_compress 
dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq raid1 md_mod i40e(O) ixgbe vxlan ip6_udp_tunnel 
mdio udp_tunnel sg sd_mod ahci ptp aacraid libahci pps_core
[ 6231.175922] CPU: 8 PID: 8230 Comm: btrfs-transacti Tainted: G 
    O    4.1.10 #1
[ 6231.243585] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 
02/18/2015
[ 6231.311584]  ffffffffc0433895 ffff88085a8db9b8 ffffffff8a639186 
0000000000000001
[ 6231.380600]  ffff88085a8dba08 ffff88085a8db9f8 ffffffff8a07fd57 
ffff880800000850
[ 6231.449888]  ffff880311fef2d0 00001fcbf2450000 0000000000000000 
0000000000000000
[ 6231.519402] Call Trace:
[ 6231.586837]  [<ffffffff8a639186>] dump_stack+0x45/0x57
[ 6231.654260]  [<ffffffff8a07fd57>] warn_slowpath_common+0x97/0xe0
[ 6231.721958]  [<ffffffff8a07fe56>] warn_slowpath_fmt+0x46/0x50
[ 6231.789246]  [<ffffffffc038fbdc>] 
__btrfs_free_extent.isra.83+0x2cc/0xce0 [btrfs]
[ 6231.857732]  [<ffffffffc038aa68>] ? 
block_group_cache_tree_search+0x98/0xf0 [btrfs]
[ 6231.926972]  [<ffffffffc03f7b8c>] ? find_ref_head+0x6c/0x90 [btrfs]
[ 6231.995254]  [<ffffffffc03946a0>] 
__btrfs_run_delayed_refs+0x730/0x11a0 [btrfs]
[ 6232.062995]  [<ffffffffc039a06f>] btrfs_run_delayed_refs+0x7f/0x290 
[btrfs]
[ 6232.130929]  [<ffffffffc039a383>] 
btrfs_write_dirty_block_groups+0x103/0x2a0 [btrfs]
[ 6232.199577]  [<ffffffffc04259c1>] commit_cowonly_roots+0x225/0x2cf 
[btrfs]
[ 6232.268690]  [<ffffffffc03ac498>] 
btrfs_commit_transaction+0x538/0xa90 [btrfs]
[ 6232.338554]  [<ffffffffc03a9b95>] transaction_kthread+0x1c5/0x240 [btrfs]
[ 6232.407982]  [<ffffffffc03a99d0>] ? open_ctree+0x2390/0x2390 [btrfs]
[ 6232.476521]  [<ffffffff8a09e1e9>] kthread+0xc9/0xe0
[ 6232.544430]  [<ffffffff8a09e120>] ? kthread_create_on_node+0x1a0/0x1a0
[ 6232.612249]  [<ffffffff8a63fda2>] ret_from_fork+0x42/0x70
[ 6232.680322]  [<ffffffff8a09e120>] ? kthread_create_on_node+0x1a0/0x1a0
[ 6232.748832] ---[ end trace 4977add5c48cdc47 ]---
[ 6232.816367] BTRFS: error (device dm-0) in __btrfs_free_extent:6356: 
errno=-28 No space left
[ 6232.885109] BTRFS info (device dm-0): forced readonly
[ 6232.953994] BTRFS: error (device dm-0) in 
btrfs_run_delayed_refs:2854: errno=-28 No space left
[ 6233.027127] BTRFS warning (device dm-0): Skipping commit of aborted 
transaction.
[ 6233.098974] BTRFS: error (device dm-0) in cleanup_transaction:1726: 
errno=-28 No space left

Stefan
