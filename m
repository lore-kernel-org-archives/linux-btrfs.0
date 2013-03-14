Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3CNWAC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 18:00:02 -0400
Date: Thu, 14 Mar 2013 14:59:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: WARNING: at fs/btrfs/extent_map.c:77 free_extent_map
Message-ID: <20130314215951.GA5310@blackbox.djwong.org>
References: <20130311223404.5f9c3f51@fem.tu-ilmenau.de>
 <20130312013934.GB31527@liubo.jp.oracle.com>
 <20130312103209.71307e9e@fem.tu-ilmenau.de>
 <20130312094110.GD31527@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130312094110.GD31527@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 05:41:13PM +0800, Liu Bo wrote:
> On Tue, Mar 12, 2013 at 10:32:09AM +0100, Johannes Hirte wrote:
> > On Tue, 12 Mar 2013 09:39:35 +0800
> > Liu Bo <bo.li.liu@oracle.com> wrote:
> > 
> > > Hi Johannes,
> > > 
> > > Could you please tell us what mount options you're with?
> > > 
> > > thanks,
> > > liubo
> > 
> > The Filesystem has six subvolumes, so mount options are:
> > 
> > noatime,inode_cache,autodefrag,subvolid=...
> > 
> 
> hmm, autodefrag + fsync.
> 
> > for each subvol.
> > 
> > I was able to reproduce it and getting a full backtrace
> > with netconsole:
> 
> Does it reproduce reliable?  Maybe you can show me how to so that I can do it
> on my box.

I get the same error message (followed by stuck CPU errors) with my repeat
rewrite tester program, with whatever the default mount options are:
http://djwong.org/docs/wac.c

# mkfs.btrfs /dev/sda

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sda
	nodesize 4096 leafsize 4096 sectorsize 4096 size 300.00MB
Btrfs Btrfs v0.19
# mount /dev/sda /mnt
# ./wac -l 65536 -n32 -m32 -f -r /mnt/somefile

3.9.0-rc2 and a boring SATA SSD.

[10995.415429] ------------[ cut here ]------------
[10995.417259] WARNING: at /storage/home/djwong/cdev/work/linux-mcsum/fs/btrfs/extent_map.c:77 free_extent_map+0x79/0x90 [btrfs]()
[10995.421335] Hardware name: 2349E51
[10995.422461] Modules linked in: btrfs scsi_debug nfsv4 sch_fq_codel eeprom crc32_pclmul nfsd auth_rpcgss exportfs af_packet ata_piix raid6_pq xor zlib_deflate libcrc32c [last unloaded: btrfs]
[10995.429721] Pid: 1787, comm: wac Not tainted 3.9.0-rc2-mcsum #1
[10995.431361] Call Trace:
[10995.432361]  [<ffffffff8105311f>] warn_slowpath_common+0x7f/0xc0
[10995.434143]  [<ffffffff8105317a>] warn_slowpath_null+0x1a/0x20
[10995.436285]  [<ffffffffa0092309>] free_extent_map+0x79/0x90 [btrfs]
[10995.438020]  [<ffffffffa008f92c>] btrfs_drop_extent_cache+0x3bc/0x470 [btrfs]
[10995.440074]  [<ffffffffa0084444>] __cow_file_range+0xf4/0x4a0 [btrfs]
[10995.441925]  [<ffffffffa007b64a>] ? join_transaction.isra.30+0x11a/0x3b0 [btrfs]
[10995.444103]  [<ffffffffa009bd31>] ? free_extent_buffer+0x61/0xc0 [btrfs]
[10995.445372]  [<ffffffffa0084c1c>] run_delalloc_nocow+0x42c/0xad0 [btrfs]
[10995.446977]  [<ffffffffa0096b37>] ? free_extent_state+0x57/0x100 [btrfs]
[10995.448376]  [<ffffffffa008570c>] run_delalloc_range+0x36c/0x370 [btrfs]
[10995.449898]  [<ffffffffa009aa9d>] __extent_writepage+0x63d/0x7a0 [btrfs]
[10995.451460]  [<ffffffff81036f09>] ? flush_tlb_page+0x59/0xf0
[10995.452593]  [<ffffffff8113ca56>] ? __page_check_address+0xd6/0x170
[10995.453927]  [<ffffffffa009ae82>] extent_write_cache_pages.isra.32.constprop.46+0x282/0x3e0 [btrfs]
[10995.455833]  [<ffffffffa009b22e>] extent_writepages+0x4e/0x70 [btrfs]
[10995.457077]  [<ffffffffa0081830>] ? can_nocow_odirect+0x2b0/0x2b0 [btrfs]
[10995.458397]  [<ffffffff810315ea>] ? __do_page_fault+0x22a/0x4d0
[10995.459528]  [<ffffffffa007eed8>] btrfs_writepages+0x28/0x30 [btrfs]
[10995.460759]  [<ffffffff81115b50>] do_writepages+0x20/0x40
[10995.461841]  [<ffffffff8110bc91>] __filemap_fdatawrite_range+0x51/0x60
[10995.463063]  [<ffffffff8110cb23>] filemap_fdatawrite_range+0x13/0x20
[10995.464280]  [<ffffffffa008d920>] btrfs_sync_file+0x60/0x2e0 [btrfs]
[10995.465631]  [<ffffffff8118f85b>] vfs_fsync+0x2b/0x40
[10995.467271]  [<ffffffff8113c593>] sys_msync+0x143/0x1d0
[10995.468367]  [<ffffffff8157ad5d>] system_call_fastpath+0x1a/0x1f
[10995.469563] ---[ end trace 627eca2f51036d33 ]---
[10995.474453] ------------[ cut here ]------------

--D
> 
> thanks,
> liubo
> 
> > 
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15870, comm: bogofilter Not tainted 3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8108ef08>] ? find_get_pages_contig+0x100/0x115
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacc5 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15870, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8108ef08>] ? find_get_pages_contig+0x100/0x115
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacc6 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacc7 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacc8 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacc9 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacca ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716baccb ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716baccc ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec---[ end trace a3b02a44716bacce ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716baccf ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15887, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8108eddd>] ? find_get_pages_tag+0xfa/0x125
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacdc ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacde ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8108ef08>] ? find_get_pages_contig+0x100/0x115
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacdf ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  acer_wmi k10tempPid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ------------[ cut here ]------------
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Call Trace:
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacf5 ]---
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacf6 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> > ---[ end trace a3b02a44716bacf7 ]---
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> > ---[ end trace a3b02a44716bacf9 ]---
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> > ---[ end trace a3b02a44716bacfa ]---
> > Hardware name: EasyNote TK81
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81486bfa>] ? _raw_read_unlock+0x1e/0x2a
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacfb ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff8116139b>] ? free_extent_state+0x12/0x21
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff81164836>] ? extent_writepages+0x49/0x60
> >  [<ffffffff8108fc58>] ? __filemap_fdatawrite_range+0x4d/0x52
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8115bc57>] ? btrfs_drop_extent_cache+0x363/0x39f
> >  [<ffffffff81152db4>] ? __cow_file_range+0x175/0x3c1
> >  [<ffffffff8114d9f7>] ? start_transaction+0x2d8/0x3e8
> >  [<ffffffff811538f7>] ? run_delalloc_range+0x9d/0x33b
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff8116451d>] ? extent_write_cache_pages.isra.29.constprop.47+0x14a/0x255
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810c85ff>] ? vfs_write+0xaf/0xf8
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacfd ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:77 free_extent_map+0x64/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8115dcff>] ? free_extent_map+0x64/0x76
> >  [<ffffffff8114bb02>] ? join_transaction.isra.34+0x30f/0x31a
> >  [<ffffffff8115383e>] ? cow_file_range+0xa9/0xc5
> >  [<ffffffff81163fa3>] ? __extent_writepage+0x1a8/0x5d8
> >  [<ffffffff811635ae>] ? end_extent_writepage+0x5d/0x5d
> >  [<ffffffff81150146>] ? btrfs_update_inode_item+0xde/0xde
> >  [<ffffffff8115a192>] ? btrfs_sync_file+0x48/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:76 free_extent_map+0x43/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcde>] ? free_extent_map+0x43/0x76
> >  [<ffffffff81179f6a>] ? btrfs_log_inode+0x5d9/0x72e
> >  [<ffffffff8114eabc>] ? btrfs_submit_bio_hook+0xae/0x14f
> >  [<ffffffff8117afc0>] ? btrfs_log_inode_parent+0x1cf/0x2ea
> >  [<ffffffff8117b110>] ? btrfs_log_dentry_safe+0x35/0x4e
> >  [<ffffffff8115a2a5>] ? btrfs_sync_file+0x15b/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bacff ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:74 free_extent_map+0x21/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcbc>] ? free_extent_map+0x21/0x76
> >  [<ffffffff81179f6a>] ? btrfs_log_inode+0x5d9/0x72e
> >  [<ffffffff8114eabc>] ? btrfs_submit_bio_hook+0xae/0x14f
> >  [<ffffffff8117afc0>] ? btrfs_log_inode_parent+0x1cf/0x2ea
> >  [<ffffffff8117b110>] ? btrfs_log_dentry_safe+0x35/0x4e
> >  [<ffffffff8115a2a5>] ? btrfs_sync_file+0x15b/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bad00 ]---
> > INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=60002 jiffies, g=144241, c=144240, q=6)
> > INFO: Stall ended before state dump start
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:76 free_extent_map+0x43/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcde>] ? free_extent_map+0x43/0x76
> >  [<ffffffff81179f6a>] ? btrfs_log_inode+0x5d9/0x72e
> >  [<ffffffff8114eabc>] ? btrfs_submit_bio_hook+0xae/0x14f
> >  [<ffffffff8117afc0>] ? btrfs_log_inode_parent+0x1cf/0x2ea
> >  [<ffffffff8117b110>] ? btrfs_log_dentry_safe+0x35/0x4e
> >  [<ffffffff8115a2a5>] ? btrfs_sync_file+0x15b/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bad01 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:74 free_extent_map+0x21/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=240007 jiffies, g=144241, c=144240, q=6)
> > INFO: Stall ended before state dump start
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:76 free_extent_map+0x43/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > Pid: 15893, comm: bogofilter Tainted: G        W    3.9.0-rc2-00112-g7c6baa3 #294
> > Call Trace:
> >  [<ffffffff8102abc2>] ? warn_slowpath_common+0x76/0x8c
> >  [<ffffffff8115dcde>] ? free_extent_map+0x43/0x76
> >  [<ffffffff81179f6a>] ? btrfs_log_inode+0x5d9/0x72e
> >  [<ffffffff8114eabc>] ? btrfs_submit_bio_hook+0xae/0x14f
> >  [<ffffffff8117afc0>] ? btrfs_log_inode_parent+0x1cf/0x2ea
> >  [<ffffffff8117b110>] ? btrfs_log_dentry_safe+0x35/0x4e
> >  [<ffffffff8115a2a5>] ? btrfs_sync_file+0x15b/0x203
> >  [<ffffffff810e783b>] ? do_fsync+0x2b/0x50
> >  [<ffffffff810e7a42>] ? sys_fdatasync+0xb/0xf
> >  [<ffffffff814877d2>] ? system_call_fastpath+0x16/0x1b
> > ---[ end trace a3b02a44716bad03 ]---
> > ------------[ cut here ]------------
> > WARNING: at fs/btrfs/extent_map.c:74 free_extent_map+0x21/0x76()
> > Hardware name: EasyNote TK81
> > Modules linked in: netconsole configfs nfsd exportfs auth_rpcgss nfs_acl fuse nfs lockd sunrpc snd_hda_codec_hdmi ath9k sr_mod snd_hda_codec_realtek acpi_cpufreq broadcom tg3 acer_wmi k10temp mperf ath9k_common ath9k_hw ath snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cdrom snd_page_alloc snd_timer snd wmi soundcore i2c_piix4 ohci_hcd
> > SysRq : Emergency Sync
> > SysRq : Emergency Remount R/O
> > SysRq : Resetting
> > ACPI MEMORY or I/O RESET_REG.
> > 
> > 
> > regards,
> >   Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
