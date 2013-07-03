Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3GCGqm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 02:46:42 -0400
Date: Wed, 3 Jul 2013 14:46:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz Chmielewski <tch@wpkg.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: at fs/btrfs/backref.c:903 find_parent_nodes+0x616/0x815
 [btrfs]()
Message-ID: <20130703064632.GB15921@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20130703113709.13d0a3cd@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130703113709.13d0a3cd@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 03, 2013 at 11:37:09AM +0900, Tomasz Chmielewski wrote:
> I've upgraded to linux 3.10 and enabled extended inode refs and skinny
> metadata extent refs with these commands:
> 
>  btrfstune -r /dev/sdc1
>  btrfstune -x /dev/sdc1
> 
> Since then, I have "WARNING: at fs/btrfs/backref.c:903
> find_parent_nodes+0x616/0x815 [btrfs]()" showing up like crazy:
> 
> # grep -c "WARNING: at fs/btrfs/backref.c:903" syslog
> 181819
> 
> That's after just a few hours of uptime.
> 
> I guess that's not expected?
> 
> 
> Some examples:
> 
> Jul  2 21:42:59 bkp010 kernel: [  668.547147] ------------[ cut here ]------------
> Jul  2 21:42:59 bkp010 kernel: [  668.547268] WARNING: at fs/btrfs/backref.c:903 find_parent_nodes+0x616/0x815 [btrfs]()
> Jul  2 21:42:59 bkp010 kernel: [  668.547414] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop acpi_cpufreq mperf freq_table intel_powerclamp kvm_intel kvm crc32_pclmul microcode ehci_pci ehci_hcd i2c_i801 pcspkr button video i2c_core lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
> Jul  2 21:42:59 bkp010 kernel: [  668.549804] CPU: 1 PID: 7806 Comm: master Not tainted 3.10.0 #1
> Jul  2 21:42:59 bkp010 kernel: [  668.549899] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> Jul  2 21:42:59 bkp010 kernel: [  668.550047]  ffffffffa0761cd8 ffff8807ebb25b08 ffffffff81371348 ffff8807ebb25b48
> Jul  2 21:42:59 bkp010 kernel: [  668.550331]  ffffffff8102eaa3 0000000000001000 0000000000000000 ffff8807ef57e360
> Jul  2 21:42:59 bkp010 kernel: [  668.550615]  ffff8807ebb25bf0 ffff8807e88131e0 ffff8807f33ac000 ffff8807ebb25b58
> Jul  2 21:42:59 bkp010 kernel: [  668.550899] Call Trace:
> Jul  2 21:42:59 bkp010 kernel: [  668.550994]  [<ffffffff81371348>] dump_stack+0x19/0x1b
> Jul  2 21:42:59 bkp010 kernel: [  668.551090]  [<ffffffff8102eaa3>] warn_slowpath_common+0x62/0x7b
> Jul  2 21:42:59 bkp010 kernel: [  668.551185]  [<ffffffff8102ead1>] warn_slowpath_null+0x15/0x17
> Jul  2 21:42:59 bkp010 kernel: [  668.551295]  [<ffffffffa074e1d7>] find_parent_nodes+0x616/0x815 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.551407]  [<ffffffffa0718dc7>] ? btrfs_get_token_32+0x79/0xc7 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.551517]  [<ffffffffa074e452>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.551625]  [<ffffffffa06ec9a9>] ? setup_items_for_insert+0x332/0x352 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.551786]  [<ffffffffa07513e9>] btrfs_qgroup_account_ref+0x10c/0x44f [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.551948]  [<ffffffffa06f316f>] btrfs_delayed_refs_qgroup_accounting+0xab/0xdf [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.552106]  [<ffffffffa0706896>] __btrfs_end_transaction+0x49/0x281 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.552214]  [<ffffffffa0706af9>] btrfs_end_transaction+0xb/0xd [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.552321]  [<ffffffffa07097f5>] __unlink_end_trans+0x5e/0x63 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.552428]  [<ffffffffa070e69f>] btrfs_unlink+0x86/0xa0 [btrfs]
> Jul  2 21:42:59 bkp010 kernel: [  668.552526]  [<ffffffff810ef004>] vfs_unlink+0x6f/0xdc
> Jul  2 21:42:59 bkp010 kernel: [  668.552621]  [<ffffffff810ef15e>] do_unlinkat+0xed/0x199
> Jul  2 21:42:59 bkp010 kernel: [  668.552717]  [<ffffffff812c274e>] ? sock_alloc_file+0xc2/0x116
> Jul  2 21:42:59 bkp010 kernel: [  668.552819]  [<ffffffff810fa429>] ? __fd_install+0x1c/0x44
> Jul  2 21:42:59 bkp010 kernel: [  668.552926]  [<ffffffff810fa471>] ? fd_install+0x20/0x22
> Jul  2 21:42:59 bkp010 kernel: [  668.553033]  [<ffffffff810f0f14>] SyS_unlink+0x11/0x13
> Jul  2 21:42:59 bkp010 kernel: [  668.553129]  [<ffffffff81375812>] system_call_fastpath+0x16/0x1b
> Jul  2 21:42:59 bkp010 kernel: [  668.553236] ---[ end trace 5bc755b97545ce9b ]---
> 
> Jul  2 21:43:27 bkp010 kernel: [  696.770152] ------------[ cut here ]------------
> Jul  2 21:43:27 bkp010 kernel: [  696.770264] WARNING: at fs/btrfs/backref.c:903 find_parent_nodes+0x616/0x815 [btrfs]()
> Jul  2 21:43:27 bkp010 kernel: [  696.770424] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop acpi_cpufreq mperf freq_table intel_powerclamp kvm_intel kvm crc32_pclmul microcode ehci_pci ehci_hcd i2c_i801 pcspkr button video i2c_core lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
> Jul  2 21:43:27 bkp010 kernel: [  696.773645] CPU: 0 PID: 7863 Comm: btrfs-endio-wri Tainted: G        W    3.10.0 #1
> Jul  2 21:43:27 bkp010 kernel: [  696.773926] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> Jul  2 21:43:27 bkp010 kernel: [  696.774141]  ffffffffa0761cd8 ffff8807eb111a48 ffffffff81371348 ffff8807eb111a88
> Jul  2 21:43:27 bkp010 kernel: [  696.774576]  ffffffff8102eaa3 0000000000001000 0000000000000000 ffff8807ff24c6c0
> Jul  2 21:43:27 bkp010 kernel: [  696.774929]  ffff8807eb111b30 ffff8807e7402a80 ffff8807f33ac000 ffff8807eb111a98
> Jul  2 21:43:27 bkp010 kernel: [  696.775250] Call Trace:
> Jul  2 21:43:27 bkp010 kernel: [  696.775381]  [<ffffffff81371348>] dump_stack+0x19/0x1b
> Jul  2 21:43:27 bkp010 kernel: [  696.775515]  [<ffffffff8102eaa3>] warn_slowpath_common+0x62/0x7b
> Jul  2 21:43:27 bkp010 kernel: [  696.775664]  [<ffffffff8102ead1>] warn_slowpath_null+0x15/0x17
> Jul  2 21:43:27 bkp010 kernel: [  696.775795]  [<ffffffffa074e1d7>] find_parent_nodes+0x616/0x815 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.775946]  [<ffffffffa074e452>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.776084]  [<ffffffffa074fac4>] ? qgroup_account_ref_step1+0xea/0x102 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.776285]  [<ffffffffa07513e9>] btrfs_qgroup_account_ref+0x10c/0x44f [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.776486]  [<ffffffffa06f316f>] btrfs_delayed_refs_qgroup_accounting+0xab/0xdf [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.776702]  [<ffffffffa0706896>] __btrfs_end_transaction+0x49/0x281 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.776832]  [<ffffffffa06f4514>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.776945]  [<ffffffffa0706af9>] btrfs_end_transaction+0xb/0xd [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.777056]  [<ffffffffa0711224>] btrfs_finish_ordered_io+0x683/0x84e [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.777177]  [<ffffffff810a3683>] ? mempool_free_slab+0x12/0x14
> Jul  2 21:43:27 bkp010 kernel: [  696.777304]  [<ffffffff810a3717>] ? mempool_free+0x72/0x7a
> Jul  2 21:43:27 bkp010 kernel: [  696.777449]  [<ffffffffa073c357>] ? end_compressed_bio_write+0xc0/0xc8 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.777648]  [<ffffffffa07113ff>] finish_ordered_fn+0x10/0x12 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.777787]  [<ffffffffa072ab5c>] worker_loop+0x15e/0x48e [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.777917]  [<ffffffffa072a9fe>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.778046]  [<ffffffff81048ab2>] kthread+0xb5/0xbd
> Jul  2 21:43:27 bkp010 kernel: [  696.778172]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
> Jul  2 21:43:27 bkp010 kernel: [  696.778294]  [<ffffffff8137576c>] ret_from_fork+0x7c/0xb0
> Jul  2 21:43:27 bkp010 kernel: [  696.778401]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
> Jul  2 21:43:27 bkp010 kernel: [  696.779920] ---[ end trace 5bc755b97545ce9c ]---
> 
> Jul  2 21:43:27 bkp010 kernel: [  696.780031] ------------[ cut here ]------------
> Jul  2 21:43:27 bkp010 kernel: [  696.780136] WARNING: at fs/btrfs/backref.c:903 find_parent_nodes+0x616/0x815 [btrfs]()
> Jul  2 21:43:27 bkp010 kernel: [  696.780282] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop acpi_cpufreq mperf freq_table intel_powerclamp kvm_intel kvm crc32_pclmul microcode ehci_pci ehci_hcd i2c_i801 pcspkr button video i2c_core lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
> Jul  2 21:43:27 bkp010 kernel: [  696.782624] CPU: 0 PID: 7863 Comm: btrfs-endio-wri Tainted: G        W    3.10.0 #1
> Jul  2 21:43:27 bkp010 kernel: [  696.782769] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> Jul  2 21:43:27 bkp010 kernel: [  696.782917]  ffffffffa0761cd8 ffff8807eb111a48 ffffffff81371348 ffff8807eb111a88
> Jul  2 21:43:27 bkp010 kernel: [  696.783200]  ffffffff8102eaa3 0000000000001000 0000000000000000 ffff8807ff24c6c0
> Jul  2 21:43:27 bkp010 kernel: [  696.783484]  ffff8807eb111b30 ffff8807e7402a80 ffff8807f33ac000 ffff8807eb111a98
> Jul  2 21:43:27 bkp010 kernel: [  696.783767] Call Trace:
> Jul  2 21:43:27 bkp010 kernel: [  696.783858]  [<ffffffff81371348>] dump_stack+0x19/0x1b
> Jul  2 21:43:27 bkp010 kernel: [  696.783953]  [<ffffffff8102eaa3>] warn_slowpath_common+0x62/0x7b
> Jul  2 21:43:27 bkp010 kernel: [  696.784049]  [<ffffffff8102ead1>] warn_slowpath_null+0x15/0x17
> Jul  2 21:43:27 bkp010 kernel: [  696.784154]  [<ffffffffa074e1d7>] find_parent_nodes+0x616/0x815 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.784262]  [<ffffffffa074e452>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.784369]  [<ffffffffa074fac4>] ? qgroup_account_ref_step1+0xea/0x102 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.784525]  [<ffffffffa07513e9>] btrfs_qgroup_account_ref+0x10c/0x44f [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.784679]  [<ffffffffa06f316f>] btrfs_delayed_refs_qgroup_accounting+0xab/0xdf [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.784837]  [<ffffffffa0706896>] __btrfs_end_transaction+0x49/0x281 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.784943]  [<ffffffffa06f4514>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785050]  [<ffffffffa0706af9>] btrfs_end_transaction+0xb/0xd [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785158]  [<ffffffffa0711224>] btrfs_finish_ordered_io+0x683/0x84e [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785256]  [<ffffffff810a3683>] ? mempool_free_slab+0x12/0x14
> Jul  2 21:43:27 bkp010 kernel: [  696.785351]  [<ffffffff810a3717>] ? mempool_free+0x72/0x7a
> Jul  2 21:43:27 bkp010 kernel: [  696.785458]  [<ffffffffa073c357>] ? end_compressed_bio_write+0xc0/0xc8 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785637]  [<ffffffffa07113ff>] finish_ordered_fn+0x10/0x12 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785744]  [<ffffffffa072ab5c>] worker_loop+0x15e/0x48e [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785850]  [<ffffffffa072a9fe>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
> Jul  2 21:43:27 bkp010 kernel: [  696.785947]  [<ffffffff81048ab2>] kthread+0xb5/0xbd
> Jul  2 21:43:27 bkp010 kernel: [  696.786042]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
> Jul  2 21:43:27 bkp010 kernel: [  696.786140]  [<ffffffff8137576c>] ret_from_fork+0x7c/0xb0
> Jul  2 21:43:27 bkp010 kernel: [  696.786234]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
> Jul  2 21:43:27 bkp010 kernel: [  696.786331] ---[ end trace 5bc755b97545ce9d ]---

- Btrfs: make backref walking code handle skinny metadata
https://patchwork.kernel.org/patch/2800271/

This patch seems to address the WARNING.

- liubo
