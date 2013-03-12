Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3CLBlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 21:41:19 -0400
Date: Tue, 12 Mar 2013 09:39:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: at fs/btrfs/extent_map.c:77 free_extent_map
Message-ID: <20130312013934.GB31527@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20130311223404.5f9c3f51@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130311223404.5f9c3f51@fem.tu-ilmenau.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 10:34:04PM +0100, Johannes Hirte wrote:
> Since the updates for linux-3.9 I've had three or four times a system
> freeze and only a reset (Magic SysRq) helped. After the reboot I found
> a bunch of this in syslog:
> 
> Mar 11 21:56:09 localhost kernel: ------------[ cut here ]------------
> Mar 11 21:56:09 localhost kernel: WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> Mar 11 21:56:09 localhost kernel: Hardware name: EasyNote TK81
> Mar 11 21:56:09 localhost kernel: Modules linked in: nfsv4 nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel ath9k snd_hda_codec ath9k_common ath9k_hw acer_wmi snd_hwdep snd_pcm ath sr_mod wmi broadcom snd_page_alloc snd_timer cdrom tg3 k10temp snd acpi_cpufreq ohci_hcd soundcore i2c_piix4 mperf
> Mar 11 21:56:09 localhost kernel: Pid: 11260, comm: bogofilter Tainted: G        W    3.9.0-rc2 #293
> Mar 11 21:56:09 localhost kernel: Call Trace:
> Mar 11 21:56:09 localhost kernel: [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> Mar 11 21:56:09 localhost kernel: [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> Mar 11 21:56:09 localhost kernel: [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> Mar 11 21:56:09 localhost kernel: [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> Mar 11 21:56:09 localhost kernel: [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> Mar 11 21:56:09 localhost kernel: [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> Mar 11 21:56:09 localhost kernel: [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> Mar 11 21:56:09 localhost kernel: [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> Mar 11 21:56:09 localhost kernel: [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> Mar 11 21:56:09 localhost kernel: [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> Mar 11 21:56:09 localhost kernel: [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> Mar 11 21:56:09 localhost kernel: [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> Mar 11 21:56:09 localhost kernel: [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> Mar 11 21:56:09 localhost kernel: [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> Mar 11 21:56:09 localhost kernel: [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> Mar 11 21:56:09 localhost kernel: [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> Mar 11 21:56:09 localhost kernel: [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> Mar 11 21:56:09 localhost kernel: [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> Mar 11 21:56:09 localhost kernel: [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> Mar 11 21:56:09 localhost kernel: [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> Mar 11 21:56:09 localhost kernel: ---[ end trace 3eaea449d8d56f92 ]---
> 
> As far as I remeber, it happend when fetching emails with claws. But
> it's not a reliable testcase. 

Hi Johannes,

Could you please tell us what mount options you're with?

thanks,
liubo

> 
> Another trace from the first time I found it in the logs. But here the
> system didn't hang:
> 
> Mar  4 14:28:35 localhost kernel: ------------[ cut here ]------------
> Mar  4 14:28:35 localhost kernel: WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> Mar  4 14:28:35 localhost kernel: Hardware name: EasyNote TK81
> Mar  4 14:28:35 localhost kernel: Modules linked in: nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel ath9k snd_hda_codec ath9k_common snd_hwdep snd_pcm broadcom ath9k_hw snd_page_alloc ath sr_mod snd_timer acer_wmi snd cdrom wmi tg3 ohci_hcd soundcore k10temp edac_core acpi_cpufreq i2c_piix4 mperf
> Mar  4 14:28:35 localhost kernel: Pid: 1574, comm: flush-btrfs-1 Not tainted 3.9.0-rc1 #289
> Mar  4 14:28:35 localhost kernel: Call Trace:
> Mar  4 14:28:35 localhost kernel: [<ffffffff8102ab92>] ? warn_slowpath_common+0x76/0x8c
> Mar  4 14:28:35 localhost kernel: [<ffffffff8115dc7b>] ? free_extent_map+0x64/0x76
> Mar  4 14:28:35 localhost kernel: [<ffffffff8115bbd3>] ? btrfs_drop_extent_cache+0x363/0x39f
> Mar  4 14:28:35 localhost kernel: [<ffffffff81152d2d>] ? __cow_file_range+0x175/0x3c1
> Mar  4 14:28:36 localhost kernel: [<ffffffff81487830>] ? _raw_spin_unlock+0x1c/0x28
> Mar  4 14:28:36 localhost kernel: [<ffffffff81160de3>] ? release_extent_buffer.isra.25+0x90/0x97
> Mar  4 14:28:36 localhost kernel: [<ffffffff81153673>] ? run_delalloc_nocow+0x6fa/0x795
> Mar  4 14:28:36 localhost kernel: [<ffffffff81153837>] ? run_delalloc_range+0x64/0x33b
> Mar  4 14:28:36 localhost kernel: [<ffffffff81161317>] ? free_extent_state+0x12/0x21
> Mar  4 14:28:36 localhost kernel: [<ffffffff81163f1f>] ? __extent_writepage+0x1a8/0x5d8
> Mar  4 14:28:36 localhost kernel: [<ffffffff8116352a>] ? end_extent_writepage+0x5d/0x5d
> Mar  4 14:28:36 localhost kernel: [<ffffffff811d4b69>] ? cpumask_any_but+0x25/0x34
> Mar  4 14:28:36 localhost kernel: [<ffffffff810a5259>] ? vma_interval_tree_subtree_search+0x33/0x55
> Mar  4 14:28:36 localhost kernel: [<ffffffff810b07b8>] ? page_mkclean+0x107/0x119
> Mar  4 14:28:36 localhost kernel: [<ffffffff81164499>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> Mar  4 14:28:36 localhost kernel: [<ffffffff8114eae1>] ? btrfs_submit_bio_hook+0x14f/0x14f
> Mar  4 14:28:36 localhost kernel: [<ffffffff811647b2>] ? extent_writepages+0x49/0x60
> Mar  4 14:28:36 localhost kernel: [<ffffffff811500ca>] ? btrfs_update_inode_item+0xde/0xde
> Mar  4 14:28:36 localhost kernel: [<ffffffff81487830>] ? _raw_spin_unlock+0x1c/0x28
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e3b86>] ? __writeback_single_inode+0x37/0xd6
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4810>] ? writeback_sb_inodes+0x1b8/0x2d3
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4994>] ? __writeback_inodes_wb+0x69/0xab
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4ad0>] ? wb_writeback+0xfa/0x193
> Mar  4 14:28:36 localhost kernel: [<ffffffff810345e3>] ? lock_timer_base.isra.29+0x22/0x46
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4da4>] ? wb_do_writeback+0x10a/0x163
> Mar  4 14:28:36 localhost kernel: [<ffffffff810344d2>] ? __internal_add_timer+0xb5/0xb5
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4e62>] ? bdi_writeback_thread+0x65/0x116
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4dfd>] ? wb_do_writeback+0x163/0x163
> Mar  4 14:28:36 localhost kernel: [<ffffffff810e4dfd>] ? wb_do_writeback+0x163/0x163
> Mar  4 14:28:36 localhost kernel: [<ffffffff81041293>] ? kthread+0x81/0x89
> Mar  4 14:28:36 localhost kernel: [<ffffffff81040000>] ? get_pid+0x8/0xc
> Mar  4 14:28:36 localhost kernel: [<ffffffff81041212>] ? __kthread_parkme+0x5b/0x5b
> Mar  4 14:28:36 localhost kernel: [<ffffffff814883ac>] ? ret_from_fork+0x7c/0xb0
> Mar  4 14:28:36 localhost kernel: [<ffffffff81041212>] ? __kthread_parkme+0x5b/0x5b
> Mar  4 14:28:36 localhost kernel: ---[ end trace be472b1297cf60cb ]---
> Mar  4 14:28:36 localhost kernel: ------------[ cut here ]------------
> 
> regards,
>   Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
