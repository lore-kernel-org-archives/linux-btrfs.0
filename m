Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34870 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaAMHHM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 02:07:12 -0500
Message-ID: <52D3905E.9090606@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 15:06:06 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/inode.c:1593! with 3.13.0-rc7
References: <20140112234702.63f4750a@virtall.com>
In-Reply-To: <20140112234702.63f4750a@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/13/2014 06:47 AM, Tomasz Chmielewski wrote:

Hello Tomasz,

Chris recently sent a patch that addressed a race condition with
loading inode, i think it might be related to your first dmesg warning.

Chris' patch url can be seen:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30332.html

Thanks,
Wang
> Just had this on a btrfs filesystem running 3.13-rc7.
>
> The filesystem was working fine till now and was passing balance and
> scrub properly without any issues a couple of days ago:
>
> [273059.042280] ------------[ cut here ]------------
> [273059.042369] WARNING: CPU: 6 PID: 20754 at fs/btrfs/inode.c:4721 inode_tree_add+0xc2/0x13f [btrfs]()
> [273059.042484] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop lpc_ich mfd_core i2c_i801 i2c_core pcspkr button video ehci_pci ehci_hcd acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
> [273059.042901] CPU: 6 PID: 20754 Comm: btrfs-endio-wri Tainted: G        W    3.13.0-rc7 #1
> [273059.043014] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [273059.043129]  0000000000000009 ffff8807a7959b18 ffffffff81389887 0000000000000006
> [273059.043245]  0000000000000000 ffff8807a7959b58 ffffffff810370a9 ffff8801b0d21040
> [273059.043360]  ffffffffa027d623 ffff880637209968 ffff88020a8bde88 ffff880667c1b800
> [273059.043476] Call Trace:
> [273059.043536]  [<ffffffff81389887>] dump_stack+0x46/0x58
> [273059.043599]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
> [273059.043674]  [<ffffffffa027d623>] ? inode_tree_add+0xc2/0x13f [btrfs]
> [273059.043738]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
> [273059.043810]  [<ffffffffa027d623>] inode_tree_add+0xc2/0x13f [btrfs]
> [273059.043885]  [<ffffffffa02840cb>] btrfs_iget+0x46c/0x4b6 [btrfs]
> [273059.043958]  [<ffffffffa028421a>] relink_extent_backref+0x105/0x6cf [btrfs]
> [273059.044032]  [<ffffffffa0284fa1>] btrfs_finish_ordered_io+0x7bd/0x877 [btrfs]
> [273059.044155]  [<ffffffffa028506b>] finish_ordered_fn+0x10/0x12 [btrfs]
> [273059.044232]  [<ffffffffa02a00d1>] worker_loop+0x15e/0x495 [btrfs]
> [273059.044307]  [<ffffffffa029ff73>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
> [273059.044372]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> [273059.044434]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [273059.044498]  [<ffffffff8138e6bc>] ret_from_fork+0x7c/0xb0
> [273059.044560]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [273059.044624] ---[ end trace 714ee71af93c5bba ]---
> [366782.707007] ------------[ cut here ]------------
>
