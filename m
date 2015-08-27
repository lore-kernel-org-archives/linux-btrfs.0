Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:29844 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbH0G3f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 02:29:35 -0400
Subject: Re: btrfs no space BTRFS: block rsv returned -28
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <55DEACEC.2010807@profihost.ag>
Cc: linux-fsdevel@vger.kernel.org, jbacik@fb.com, cmason@fb.com
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <55DEAE4D.901@profihost.ag>
Date: Thu, 27 Aug 2015 08:29:33 +0200
MIME-Version: 1.0
In-Reply-To: <55DEACEC.2010807@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

umount shows in dmesg:
[296257.035209] BTRFS: space_info 4 has 28507439104 free, is not full
[296257.035212] BTRFS: space_info total=135291469824, used=106783965184,
pinned=0, reserved=0, may_use=1737547415552, readonly=65536

If i umount and remount the fs is working fine again. Disk space cache
is disabled.

Stefan

Am 27.08.2015 um 08:23 schrieb Stefan Priebe - Profihost AG:
> Hi,
> 
> today i had again the no space situation while having the device mounted
> with: enospc_debug
> 
> # btrfs filesystem df /vmbackup/
> Data, single: total=18.54TiB, used=17.94TiB
> System, DUP: total=32.00MiB, used=2.83MiB
> Metadata, DUP: total=126.00GiB, used=99.45GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> [180587.839969] use_block_rsv: 25370 callbacks suppressed
> [180587.839975] ------------[ cut here ]------------
> [180587.840009] WARNING: CPU: 8 PID: 22807 at
> fs/btrfs/extent-tree.c:7539 btrfs_alloc_tree_block+0x431/0x4c0 [btrfs]()
> [180587.840012] BTRFS: block rsv returned -28
> [180587.840014] Modules linked in: dm_mod netconsole ipt_REJECT
> nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables
> cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
> bonding ext2 usbhid coretemp loop ehci_pci sb_edac ehci_hcd edac_core
> i2c_i801 usbcore i2c_core shpchp usb_common ipmi_si ipmi_msghandler
> button btrfs lzo_compress raid0 raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod aacraid
> ahci i40e(O) libahci ixgbe vxlan ip6_udp_tunnel mdio udp_tunnel ptp pps_core
> [180587.840073] CPU: 8 PID: 22807 Comm: kworker/u66:19 Tainted: G
>  W  O    4.1.6+19-ph #1
> [180587.840076] Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c
> 02/18/2015
> [180587.840099] Workqueue: btrfs-endio-write btrfs_endio_write_helper
> [btrfs]
> [180587.840115]  ffffffffc04593f3 ffff880fe6c4f848 ffffffff9f633a26
> 0000000000000000
> [180587.840125]  ffff880fe6c4f898 ffff880fe6c4f888 ffffffff9f07dd17
> 0000000000000000
> [180587.840128]  ffff88105b732148 0000000000000000 ffff88085bc95800
> 0000000000004000
> [180587.840132] Call Trace:
> [180587.840148]  [<ffffffff9f633a26>] dump_stack+0x45/0x57
> [180587.840161]  [<ffffffff9f07dd17>] warn_slowpath_common+0x97/0xe0
> [180587.840168]  [<ffffffff9f07de16>] warn_slowpath_fmt+0x46/0x50
> [180587.840185]  [<ffffffffc03c1611>] btrfs_alloc_tree_block+0x431/0x4c0
> [btrfs]
> [180587.840200]  [<ffffffffc03cb340>] ?
> verify_parent_transid+0x200/0x200 [btrfs]
> [180587.840221]  [<ffffffffc03f87d9>] ? read_extent_buffer+0xb9/0x120
> [btrfs]
> [180587.840232]  [<ffffffffc03ab2fc>] __btrfs_cow_block+0x11c/0x540 [btrfs]
> [180587.840248]  [<ffffffffc03cec25>] ? btrfs_buffer_uptodate+0x65/0x80
> [btrfs]
> [180587.840259]  [<ffffffffc03ab8ea>] btrfs_cow_block+0x12a/0x1c0 [btrfs]
> [180587.840270]  [<ffffffffc03af800>] btrfs_search_slot+0x1d0/0xa10 [btrfs]
> [180587.840295]  [<ffffffffc03c77d9>] btrfs_lookup_csum+0x69/0x180 [btrfs]
> [180587.840314]  [<ffffffffc03c8c2c>] btrfs_csum_file_blocks+0xcc/0x6e0
> [btrfs]
> [180587.840325]  [<ffffffffc03aa84a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
> [180587.840341]  [<ffffffffc03d835d>] ?
> insert_reserved_file_extent.constprop.68+0xbd/0x310 [btrfs]
> [180587.840362]  [<ffffffffc03d6bcd>]
> add_pending_csums.isra.39+0x4d/0x70 [btrfs]
> [180587.840382]  [<ffffffffc03de5b6>]
> btrfs_finish_ordered_io+0x2e6/0x5e0 [btrfs]
> [180587.840398]  [<ffffffffc03b4e63>] ? get_alloc_profile+0xc3/0x1f0 [btrfs]
> [180587.840418]  [<ffffffffc03de8c5>] finish_ordered_fn+0x15/0x20 [btrfs]
> [180587.840443]  [<ffffffffc0405d02>] normal_work_helper+0xc2/0x2a0 [btrfs]
> [180587.840464]  [<ffffffffc0406072>] btrfs_endio_write_helper+0x12/0x20
> [btrfs]
> [180587.840473]  [<ffffffff9f09563f>] process_one_work+0x14f/0x410
> [180587.840476]  [<ffffffff9f095a59>] worker_thread+0x119/0x510
> [180587.840480]  [<ffffffff9f6359b1>] ? __schedule+0x4f1/0x99f
> [180587.840489]  [<ffffffff9f095940>] ? process_scheduled_works+0x40/0x40
> [180587.840494]  [<ffffffff9f09c1a9>] kthread+0xc9/0xe0
> [180587.840499]  [<ffffffff9f09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
> [180587.840509]  [<ffffffff9f63a562>] ret_from_fork+0x42/0x70
> [180587.840513]  [<ffffffff9f09c0e0>] ? kthread_create_on_node+0x1a0/0x1a0
> [180587.840516] ---[ end trace 35a5e6cf972ae9a0 ]---
> [180766.073218] use_block_rsv: 20 callbacks suppressed
> [180766.073223] ------------[ cut here ]------------
> 
> Stefan
> 
