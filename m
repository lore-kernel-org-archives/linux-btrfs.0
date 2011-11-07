From: Chris Mason <chris.mason@oracle.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:305
Date: Mon, 7 Nov 2011 11:06:56 -0500
Message-ID: <20111107160656.GD4265@shiny>
References: <4EB1ED83.8010301@jp.fujitsu.com>
 <20111103111927.GJ18900@shiny>
 <4EB32738.1010407@jp.fujitsu.com>
 <4EB79188.4090708@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB79188.4090708@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2011 at 05:06:32PM +0900, Tsutomu Itoh wrote:
> Hi, Chris,
> 
> (2011/11/04 8:43), Tsutomu Itoh wrote:
> > (2011/11/03 20:19), Chris Mason wrote:
> >> On Thu, Nov 03, 2011 at 10:25:23AM +0900, Tsutomu Itoh wrote:
> >>> In integration-scrub branch, following warning messages were displayed by
> >>> running xfstests.
> >>>
> >>> # btrfs fi sh /dev/sdd4
> >>> Label: none  uuid: 8f28d85c-e37c-4c1b-adef-2627ca59be78
> >>>         Total devices 2 FS bytes used 31.49MB
> >>>         devid    1 size 9.31GB used 9.31GB path /dev/sdd4
> >>>         devid    2 size 15.01GB used 9.29GB path /dev/sdc1
> >>>
> >>> Btrfs Btrfs v0.19
> >>> # mount
> >>> ...
> >>> /dev/sdd4 on /test7 type btrfs (rw,compress=lzo)
> >>> #
> >>>
> >>> Thanks,
> >>> Tsutomu
> >>>
> >>> ====================================================================================
> >>>
> >>> Nov  3 09:55:18 luna kernel: [  939.732044] device fsid 8f28d85c-e37c-4c1b-adef-2627ca59be78 devid 1 transid 20510 /dev/sdd4
> >>> Nov  3 09:55:18 luna kernel: [  939.732533] btrfs: use lzo compression
> >>> Nov  3 09:55:18 luna kernel: [  939.732536] btrfs: disk space caching is enabled
> >>> Nov  3 09:55:18 luna kernel: [  939.898190] ------------[ cut here ]------------
> >>> Nov  3 09:55:18 luna kernel: [  939.898223] WARNING: at fs/btrfs/free-space-cache.c:305 io_ctl_map_page+0x29/0x76 [btrfs]()
> >>> Nov  3 09:55:18 luna kernel: [  939.898227] Hardware name: PRIMERGY
> >>> Nov  3 09:55:18 luna kernel: [  939.898229] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
> >>> Nov  3 09:55:18 luna kernel: [  939.898291] Pid: 13337, comm: dd Not tainted 3.1.0integ-sc+ #1
> >>> Nov  3 09:55:18 luna kernel: [  939.898294] Call Trace:
> >>> Nov  3 09:55:18 luna kernel: [  939.898303]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
> >>> Nov  3 09:55:18 luna kernel: [  939.898308]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
> >>> Nov  3 09:55:18 luna kernel: [  939.898328]  [<ffffffffa0477507>] io_ctl_map_page+0x29/0x76 [btrfs]
> >>> Nov  3 09:55:18 luna kernel: [  939.898349]  [<ffffffffa0477733>] io_ctl_check_crc+0x62/0xdd [btrfs]
> >>
> >> Looks like io_ctl_read_bitmap will call io_ctl_check_crc with a mapped
> >> page mapped.  Any chance you're able to reproduce this?
> > 
> > Yes.
> > However, because the panic that David reported occurs, I cannot reproduce
> > this problem though I executed xfstests again.
> 
> In for-linus branch, I was able to reproduce this problem.
> The message log is attached to this mail.


Great, the traces clearly show io_ctl_read_bitmap is leaving a page
mapped and that io_ctl_check_crc is trying to map it again.

Josef, looks like io_ctl_read_bitmap needs to always unmap?

[ trace below ]

-chris

> 
> Thanks,
> Tsutomu

> Nov  7 15:16:28 luna kernel: [ 3010.347454] device fsid 9880be7d-1b7f-4233-b14d-c6bc37d3d26c devid 1 transid 7775 /dev/sdd4
> Nov  7 15:16:28 luna kernel: [ 3010.347954] btrfs: disk space caching is enabled
> Nov  7 15:16:28 luna kernel: [ 3010.398732] ------------[ cut here ]------------
> Nov  7 15:16:28 luna kernel: [ 3010.398768] WARNING: at fs/btrfs/free-space-cache.c:305 io_ctl_map_page+0x29/0x76 [btrfs]()
> Nov  7 15:16:28 luna kernel: [ 3010.398772] Hardware name: PRIMERGY            
> Nov  7 15:16:28 luna kernel: [ 3010.398774] Modules linked in: nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
> Nov  7 15:16:28 luna kernel: [ 3010.398834] Pid: 11742, comm: mkdir Not tainted 3.1.0mod+ #1
> Nov  7 15:16:28 luna kernel: [ 3010.398837] Call Trace:
> Nov  7 15:16:28 luna kernel: [ 3010.398846]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
> Nov  7 15:16:28 luna kernel: [ 3010.398851]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
> Nov  7 15:16:28 luna kernel: [ 3010.398872]  [<ffffffffa03035b0>] io_ctl_map_page+0x29/0x76 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.398893]  [<ffffffffa0303790>] io_ctl_check_crc+0x62/0xd0 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.398899]  [<ffffffff811cb564>] ? rb_insert_color+0x68/0xe5
> Nov  7 15:16:28 luna kernel: [ 3010.398919]  [<ffffffffa0303832>] io_ctl_read_bitmap+0x34/0x61 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.398941]  [<ffffffffa0303202>] ? link_free_space+0x3f/0x54 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.398961]  [<ffffffffa030528c>] __load_free_space_cache+0x2f1/0x35a [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.398967]  [<ffffffff8112d21d>] ? igrab+0x1d/0x44
> Nov  7 15:16:28 luna kernel: [ 3010.398988]  [<ffffffffa030548e>] load_free_space_cache+0xca/0x168 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399004]  [<ffffffffa02c7507>] cache_block_group+0xa3/0x1f2 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399034]  [<ffffffffa02cabf4>] find_free_extent+0x478/0xa48 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399041]  [<ffffffff81014ea2>] ? read_tsc+0x9/0x1b
> Nov  7 15:16:28 luna kernel: [ 3010.399049]  [<ffffffff810d35bc>] ? __lock_page+0x6d/0x6d
> Nov  7 15:16:28 luna kernel: [ 3010.399068]  [<ffffffffa02cb279>] btrfs_reserve_extent+0xb5/0x1c4 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399076]  [<ffffffff810675a2>] ? autoremove_wake_function+0x3d/0x3d
> Nov  7 15:16:28 luna kernel: [ 3010.399095]  [<ffffffffa02cb508>] btrfs_alloc_free_block+0x180/0x2a8 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399111]  [<ffffffffa02bd3b2>] __btrfs_cow_block+0x11d/0x3ba [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399136]  [<ffffffffa02ec297>] ? map_private_extent_buffer+0xa8/0xe8 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399153]  [<ffffffffa02bdb36>] btrfs_cow_block+0x108/0x152 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399170]  [<ffffffffa02bf855>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399187]  [<ffffffffa02bceb4>] ? btrfs_free_path+0x2a/0x2f [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399204]  [<ffffffffa02c088d>] btrfs_insert_empty_items+0x6a/0xbc [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399228]  [<ffffffffa02da665>] btrfs_new_inode+0x160/0x36d [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399250]  [<ffffffffa02d6f00>] ? start_transaction+0x200/0x24d [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399273]  [<ffffffffa02ddf30>] btrfs_mkdir+0xbd/0x1ab [btrfs]
> Nov  7 15:16:28 luna kernel: [ 3010.399281]  [<ffffffff81123f61>] vfs_mkdir+0x5f/0x9b
> Nov  7 15:16:28 luna kernel: [ 3010.399287]  [<ffffffff811262c6>] sys_mkdirat+0x6b/0xaa
> Nov  7 15:16:28 luna kernel: [ 3010.399294]  [<ffffffff8112631d>] sys_mkdir+0x18/0x1a
> Nov  7 15:16:28 luna kernel: [ 3010.399301]  [<ffffffff813af4c2>] system_call_fastpath+0x16/0x1b
> Nov  7 15:16:28 luna kernel: [ 3010.399306] ---[ end trace 3f7da847bea10c5d ]---
> Nov  7 15:16:28 luna kernel: [ 3010.399327] btrfs: csum mismatch on free space cache
> Nov  7 15:16:28 luna kernel: [ 3010.399585] btrfs: failed to load free space cache for block group 29360128
