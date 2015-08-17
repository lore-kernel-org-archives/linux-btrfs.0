Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:53041 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbHQFQr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 01:16:47 -0400
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: 4.1.5: WARNING: CPU: 3 PID: 4756 at fs/btrfs/extent-tree.c:7539
 btrfs_alloc_tree_block
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: fdmanana@suse.com, mfasheh@suse.de
Message-ID: <55D16E3C.4070604@profihost.ag>
Date: Mon, 17 Aug 2015 07:16:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

this is from vanilla 4.1.5:
[29948.701309] ------------[ cut here ]------------
[29948.756302] WARNING: CPU: 3 PID: 4756 at fs/btrfs/extent-tree.c:7539 
btrfs_alloc_tree_block+0x431/0x4c0 [btrfs]()
[29948.814644] BTRFS: block rsv returned -28
[29948.814647] Modules linked in: dm_mod netconsole ipt_REJECT 
nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables 
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative 
bonding ext2 coretemp loop usbhid ehci_pci i2c_i801 ipmi_si ehci_hcd 
i2c_core usbcore shpchp usb_common ipmi_msghandler sb_edac edac_core 
button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod i40e(O) 
ixgbe(O) vxlan ip6_udp_tunnel udp_tunnel ahci ptp aacraid libahci pps_core
[29949.135847] CPU: 3 PID: 4756 Comm: kworker/u65:6 Tainted: G        W 
  O    4.1.5+13-ph #1
[29949.203042] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 
02/18/2015
[29949.270647] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[29949.338876]  ffffffffa02783f3 ffff88068086f6c8 ffffffff8162dd56 
0000000000000001
[29949.408478]  ffff88068086f718 ffff88068086f708 ffffffff8107dcb7 
0000000000000001
[29949.476737]  ffff880856b5e120 0000000000000001 ffff881056dc8000 
0000000000004000
[29949.545175] Call Trace:
[29949.613042]  [<ffffffff8162dd56>] dump_stack+0x45/0x57
[29949.680804]  [<ffffffff8107dcb7>] warn_slowpath_common+0x97/0xe0
[29949.748815]  [<ffffffff8107ddb6>] warn_slowpath_fmt+0x46/0x50
[29949.816784]  [<ffffffffa01e0611>] btrfs_alloc_tree_block+0x431/0x4c0 
[btrfs]
[29949.884522]  [<ffffffffa02177d9>] ? read_extent_buffer+0xb9/0x120 [btrfs]
[29949.952906]  [<ffffffffa01ca2fc>] __btrfs_cow_block+0x11c/0x540 [btrfs]
[29950.021243]  [<ffffffffa01edc25>] ? btrfs_buffer_uptodate+0x65/0x80 
[btrfs]
[29950.089058]  [<ffffffffa01ca8ea>] btrfs_cow_block+0x12a/0x1c0 [btrfs]
[29950.157936]  [<ffffffffa01ce800>] btrfs_search_slot+0x1d0/0xa10 [btrfs]
[29950.225553]  [<ffffffffa01d5032>] 
lookup_inline_extent_backref+0x122/0x5e0 [btrfs]
[29950.294614]  [<ffffffffa01ee0e5>] ? btrfs_mark_buffer_dirty+0x95/0xd0 
[btrfs]
[29950.362736]  [<ffffffffa01d80dd>] __btrfs_free_extent+0x14d/0xc00 [btrfs]
[29950.431597]  [<ffffffff8162be43>] ? __slab_free+0x102/0x200
[29950.500015]  [<ffffffffa01df210>] 
__btrfs_run_delayed_refs+0x3f0/0x1270 [btrfs]
[29950.570184]  [<ffffffff810b84b6>] ? enqueue_task_fair+0x3d6/0x6e0
[29950.639537]  [<ffffffffa01e2434>] btrfs_run_delayed_refs+0x74/0x280 
[btrfs]
[29950.710433]  [<ffffffffa01e28e7>] delayed_ref_async_start+0x37/0x90 
[btrfs]
[29950.780266]  [<ffffffffa0224d02>] normal_work_helper+0xc2/0x2a0 [btrfs]
[29950.850726]  [<ffffffffa0225112>] btrfs_extent_refs_helper+0x12/0x20 
[btrfs]
[29950.920587]  [<ffffffff810955af>] process_one_work+0x14f/0x410
[29950.990719]  [<ffffffff810959c9>] worker_thread+0x119/0x510
[29951.058965]  [<ffffffff8162fc21>] ? __schedule+0x4f1/0x99f
[29951.126978]  [<ffffffff810958b0>] ? process_scheduled_works+0x40/0x40
[29951.194704]  [<ffffffff8109c119>] kthread+0xc9/0xe0
[29951.262578]  [<ffffffff8109c050>] ? kthread_create_on_node+0x1a0/0x1a0
[29951.331304]  [<ffffffff816347e2>] ret_from_fork+0x42/0x70
[29951.399950]  [<ffffffff8109c050>] ? kthread_create_on_node+0x1a0/0x1a0
[29951.467320] ---[ end trace 487b9b7d8b3ac3b6 ]---

Stefan
