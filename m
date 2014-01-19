Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:53469 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaASPtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 10:49:51 -0500
Received: by mail-qa0-f44.google.com with SMTP id w5so4803807qac.17
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 07:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140119140913.501c73e8@virtall.com>
References: <20140119140913.501c73e8@virtall.com>
Date: Sun, 19 Jan 2014 23:49:51 +0800
Message-ID: <CAP9B-Qn1PChub2fbwL6Mv6mDt_h3jjYs8r+h28Z3=hOHzdwB=A@mail.gmail.com>
Subject: Re: WARNING at fs/btrfs/backref.c:936 find_parent_nodes+0x378/0x5d2
From: Shilong Wang <wangshilong1991@gmail.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Tomasz,

This seems a new bug, did you run balance and defragment concurrently for
triggering the following warning?

Thanks,
Wang
2014/1/19 Tomasz Chmielewski <tch@virtall.com>:
> Just had a few of these with 3.13.0-rc8:
>
> [262162.560701] ------------[ cut here ]------------
> [262162.560764] WARNING: CPU: 0 PID: 22705 at fs/btrfs/backref.c:936 find_parent_nodes+0x378/0x5d2 [btrfs]()
> [262162.560872] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr ehci_pci ehci_hcd button lpc_ich mfd_core i2c_i801 i2c_core video acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
> [262162.562685] CPU: 0 PID: 22705 Comm: btrfs-endio-wri Not tainted 3.13.0-rc8 #2
> [262162.562796] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [262162.562911]  0000000000000009 ffff88009e911a78 ffffffff813898b7 0000000000000006
> [262162.563028]  0000000000000000 ffff88009e911ab8 ffffffff810370a9 0100000000000846
> [262162.563143]  ffffffffa02b7a6f ffff8807e7248090 ffff8807f2d5e000 ffff88009e911b40
> [262162.563259] Call Trace:
> [262162.563319]  [<ffffffff813898b7>] dump_stack+0x46/0x58
> [262162.563382]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
> [262162.563458]  [<ffffffffa02b7a6f>] ? find_parent_nodes+0x378/0x5d2 [btrfs]
> [262162.563522]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
> [262162.563595]  [<ffffffffa02b7a6f>] find_parent_nodes+0x378/0x5d2 [btrfs]
> [262162.563671]  [<ffffffffa02b84dc>] iterate_extent_inodes+0xc9/0x1d6 [btrfs]
> [262162.563748]  [<ffffffffa0270981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
> [262162.563824]  [<ffffffffa0270981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
> [262162.563899]  [<ffffffffa02b8668>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
> [262162.564022]  [<ffffffffa0270919>] record_extent_backrefs+0x5b/0xc3 [btrfs]
> [262162.564098]  [<ffffffffa0278f67>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
> [262162.564221]  [<ffffffffa0279074>] finish_ordered_fn+0x10/0x12 [btrfs]
> [262162.564296]  [<ffffffffa02940d9>] worker_loop+0x15e/0x495 [btrfs]
> [262162.564371]  [<ffffffffa0293f7b>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
> [262162.564437]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> [262162.564499]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [262162.564563]  [<ffffffff8138e6fc>] ret_from_fork+0x7c/0xb0
> [262162.564626]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [262162.564689] ---[ end trace 50ae39e01ebd7394 ]---
> [262162.564753] ------------[ cut here ]------------
> [262162.564825] WARNING: CPU: 0 PID: 22705 at fs/btrfs/backref.c:936 find_parent_nodes+0x378/0x5d2 [btrfs]()
> [262162.564939] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr ehci_pci ehci_hcd button lpc_ich mfd_core i2c_i801 i2c_core video acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
> [262162.565348] CPU: 0 PID: 22705 Comm: btrfs-endio-wri Tainted: G        W    3.13.0-rc8 #2
> [262162.565461] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [262162.565575]  0000000000000009 ffff88009e911a78 ffffffff813898b7 0000000000000006
> [262162.565689]  0000000000000000 ffff88009e911ab8 ffffffff810370a9 ffff8807f33be200
> [262162.565804]  ffffffffa02b7a6f ffff8807e7248090 ffff8807f2d5e000 ffff88009e911b40
> [262162.565920] Call Trace:
> [262162.565975]  [<ffffffff813898b7>] dump_stack+0x46/0x58
> [262162.566037]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
> [262162.566109]  [<ffffffffa02b7a6f>] ? find_parent_nodes+0x378/0x5d2 [btrfs]
> [262162.566174]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
> [262162.566247]  [<ffffffffa02b7a6f>] find_parent_nodes+0x378/0x5d2 [btrfs]
> [262162.566321]  [<ffffffffa02b84dc>] iterate_extent_inodes+0xc9/0x1d6 [btrfs]
> [262162.566396]  [<ffffffffa0270981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
> [262162.566469]  [<ffffffffa0270981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
> [262162.566544]  [<ffffffffa02b8668>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
> [262162.566667]  [<ffffffffa0270919>] record_extent_backrefs+0x5b/0xc3 [btrfs]
> [262162.566742]  [<ffffffffa0278f67>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
> [262162.566866]  [<ffffffffa0279074>] finish_ordered_fn+0x10/0x12 [btrfs]
> [262162.566941]  [<ffffffffa02940d9>] worker_loop+0x15e/0x495 [btrfs]
> [262162.567015]  [<ffffffffa0293f7b>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
> [262162.567080]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> [262162.567141]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [262162.567205]  [<ffffffff8138e6fc>] ret_from_fork+0x7c/0xb0
> [262162.567267]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [262162.567330] ---[ end trace 50ae39e01ebd7395 ]---
>
>
> --
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
