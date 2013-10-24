Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:36317 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab3JXIlr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 04:41:47 -0400
Date: Thu, 24 Oct 2013 17:41:34 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131024174134.2e1f334d@virtall.com>
In-Reply-To: <20131024145415.668b5ede@virtall.com>
References: <20131021122123.43b3aa50@virtall.com>
	<20131021151032.708cc7d2@virtall.com>
	<20131021125317.GK1032@twin.jikos.cz>
	<20131022025025.169941de@virtall.com>
	<20131022154619.GW1032@twin.jikos.cz>
	<20131023010411.42d30c97@virtall.com>
	<20131022162019.GY1032@twin.jikos.cz>
	<20131023132844.2a206238@virtall.com>
	<20131024145415.668b5ede@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 24 Oct 2013 14:54:15 +0900
Tomasz Chmielewski <tch@virtall.com> wrote:

> On Wed, 23 Oct 2013 13:28:44 +0900
> Tomasz Chmielewski <tch@virtall.com> wrote:
> 
> OK, putting high load aside - it finished, with no errors:
> 
> # btrfs scrub status /mnt/lxc1
> scrub status for 8d08ad6d-4543-4fe5-8b1b-640dc1423d41
>         scrub started at Wed Oct 23 04:19:55 2013 and finished after
> 68479 seconds total bytes scrubbed: 3.50TB with 0 errors

And right some time after using it again - no "unable to find logical" this time, and didn't "hang" (yet?).


[102428.040859] ------------[ cut here ]------------
[102428.040939] WARNING: CPU: 4 PID: 26530 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[102428.041055] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 i2c_core lpc_ich mfd_core pcspkr acpi_cpufreq freq_table ehci_pci button video ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci r8169 mii libata scsi_mod
[102428.041474] CPU: 4 PID: 26530 Comm: btrfs-endio-wri Not tainted 3.12.0-rc6 #1
[102428.041585] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[102428.041699]  0000000000000009 ffff8801fa1d37e8 ffffffff8138145b 0000000000000006
[102428.041816]  0000000000000000 ffff8801fa1d3828 ffffffff810366a9 0000023be09b3000
[102428.041930]  ffffffffa0236e23 ffff8807eb8b9360 ffff88060beb1800 ffff8804e36e9040
[102428.042046] Call Trace:
[102428.042106]  [<ffffffff8138145b>] dump_stack+0x46/0x58
[102428.042169]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[102428.042240]  [<ffffffffa0236e23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[102428.042353]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[102428.042423]  [<ffffffffa0236e23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[102428.042503]  [<ffffffffa029a6e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[102428.042631]  [<ffffffffa026bdf3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[102428.042708]  [<ffffffffa029b0dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[102428.042784]  [<ffffffffa029b40b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[102428.042858]  [<ffffffffa029e562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[102428.042981]  [<ffffffffa029e41f>] ? btrfs_qgroup_record_ref+0x2d/0x67 [btrfs]
[102428.043103]  [<ffffffffa023e805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[102428.043229]  [<ffffffffa0252475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[102428.043303]  [<ffffffffa025270c>] btrfs_end_transaction+0xb/0xd [btrfs]
[102428.043379]  [<ffffffffa025b95d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[102428.043455]  [<ffffffffa025c185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[102428.043569]  [<ffffffff810e316a>] ? kmem_cache_free+0x164/0x17a
[102428.043633]  [<ffffffff810ae673>] ? mempool_free_slab+0x12/0x14
[102428.043705]  [<ffffffffa025c296>] finish_ordered_fn+0x10/0x12 [btrfs]
[102428.043781]  [<ffffffffa0277322>] worker_loop+0x15e/0x494 [btrfs]
[102428.043855]  [<ffffffffa02771c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[102428.043921]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[102428.043982]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[102428.044046]  [<ffffffff813861fc>] ret_from_fork+0x7c/0xb0
[102428.044109]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[102428.044193] ---[ end trace d0bf6f5b2d22f3d8 ]---
[102428.044269] ------------[ cut here ]------------
[102428.044344] WARNING: CPU: 4 PID: 26530 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[102428.044466] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 i2c_core lpc_ich mfd_core pcspkr acpi_cpufreq freq_table ehci_pci button video ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci r8169 mii libata scsi_mod
[102428.044881] CPU: 4 PID: 26530 Comm: btrfs-endio-wri Tainted: G        W    3.12.0-rc6 #1
[102428.044994] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[102428.045109]  0000000000000009 ffff8801fa1d3758 ffffffff8138145b 0000000000000006
[102428.045225]  0000000000000000 ffff8801fa1d3798 ffffffff810366a9 0000023be09b3000
[102428.045340]  ffffffffa0236e23 ffff8807eb8b9360 ffff88060beb1800 ffff8804e36e9040
[102428.045455] Call Trace:
[102428.045513]  [<ffffffff8138145b>] dump_stack+0x46/0x58
[102428.045574]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[102428.045644]  [<ffffffffa0236e23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[102428.045757]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[102428.045826]  [<ffffffffa0236e23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[102428.045891]  [<ffffffff8109b72e>] ? call_rcu_sched+0x12/0x14
[102428.045967]  [<ffffffffa026bd01>] ? alloc_extent_buffer+0x2dc/0x30f [btrfs]
[102428.046038]  [<ffffffffa0239053>] btrfs_next_old_leaf+0xc9/0x3a6 [btrfs]
[102428.046115]  [<ffffffffa029a92a>] __resolve_indirect_refs+0x351/0x481 [btrfs]
[102428.046240]  [<ffffffffa026bdf3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[102428.046315]  [<ffffffffa029b0dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[102428.046389]  [<ffffffffa029b40b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[102428.046464]  [<ffffffffa029e562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[102428.046586]  [<ffffffffa029e41f>] ? btrfs_qgroup_record_ref+0x2d/0x67 [btrfs]
[102428.046707]  [<ffffffffa023e805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[102428.046832]  [<ffffffffa0252475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[102428.046906]  [<ffffffffa025270c>] btrfs_end_transaction+0xb/0xd [btrfs]
[102428.046981]  [<ffffffffa025b95d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[102428.047055]  [<ffffffffa025c185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[102428.047168]  [<ffffffff810e316a>] ? kmem_cache_free+0x164/0x17a
[102428.047230]  [<ffffffff810ae673>] ? mempool_free_slab+0x12/0x14
[102428.047303]  [<ffffffffa025c296>] finish_ordered_fn+0x10/0x12 [btrfs]
[102428.047378]  [<ffffffffa0277322>] worker_loop+0x15e/0x494 [btrfs]
[102428.047451]  [<ffffffffa02771c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[102428.047516]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[102428.047577]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[102428.047642]  [<ffffffff813861fc>] ret_from_fork+0x7c/0xb0
[102428.047703]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[102428.047767] ---[ end trace d0bf6f5b2d22f3d9 ]---


-- 
Tomasz Chmielewski
http://wpkg.org

