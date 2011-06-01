From: David Sterba <dave@jikos.cz>
Subject: Re: btrfs hang on brd
Date: Wed, 1 Jun 2011 10:54:40 +0200
Message-ID: <20110601085439.GD12709@twin.jikos.cz>
References: <4DE492B0.9020302@linux.intel.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Adrian Hunter <adrian.hunter@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE492B0.9020302@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2011 at 10:03:12AM +0300, Adrian Hunter wrote:
> Hi
> 
> I seem to be able to get btrfs reproducibly to
> produce warnings and finally hang when running
> a stress test on a ramdisk.
> 
> Testing was done using the "integration-test"
> branch of btrfs-unstable.  Note that I also tested
> v2.6.39 and "integration-test" took much longer to
> hang i.e. it is an improvement
> 
> The test script and stack dumps are below.
> 
> Is this a valid test?
> 
> Is it worth me investigating these?

I've tried to reproduce myself, but the fsstress utility (taken from
latest LTP suite) crashes sometimes and I cannot take it as a proper
reproduction. Can you point me to the exact version you used?

(But no warning or hang observed, on top of 3.0-rc1 + cmason/for-linus)

> Test
> ----
> 
> #!/bin/sh
> 
> sudo modprobe brd rd_size=262144

this is minimal size possible, 256MB

> 
> sudo umount /mnt/test/ 2> /dev/null
> 
> echo 'mkfs.btrfs /dev/ram0'
> 
> sudo mkfs.btrfs /dev/ram0
> 
> sudo mkdir -p /mnt/test
> 
> echo 'mount -t btrfs /dev/ram0 /mnt/test'
> 
> sudo mount -t btrfs /dev/ram0 /mnt/test
> 
> sudo mkdir -p /mnt/test/test
> 
> sudo chown $USER /mnt/test/test
> sudo chgrp $USER /mnt/test/test
> 
> sudo umount /mnt/test
> 
> full=0
> i=0
> while true; do
> 	sudo mount -t btrfs /dev/ram0 /mnt/test
> 
> 	if df | grep ram0 | grep 100% > /dev/null; then
> 		full=`expr $full \+ 1`
> 		if test $full -gt 6;then
> 			rm -rf /mnt/test/test/*
> 			full=0
> 		fi
> 	else
> 		full=0
> 	fi
> 
> 	fsstress -c -r -d /mnt/test/test -p 3 -n 1000 -l 10
> 
> 	sudo umount /mnt/test
> 
> 	i=`expr $i \+ 1`
> 	echo $i
> done
> 
> 
> 
> Stack dumps for warnings
> ------------------------
> 
> 
> [ 7481.520750] WARNING: at fs/btrfs/extent-tree.c:5648

5644         ret = block_rsv_use_bytes(block_rsv, blocksize);
5645         if (!ret)
5646                 return block_rsv;
5647         if (ret) {

5648                 WARN_ON(1);

5649                 ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
5650                                              0);

and block_rsv_use_bytes() returns nonzero in case of ENOSPC.

> [ 7481.521176] WARNING: at fs/btrfs/extent-tree.c:5648 btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
> [ 7481.521178] Hardware name: XPS 8300
> [ 7481.521180] Modules linked in: tcp_lp tun btrfs zlib_deflate
> libcrc32c brd fuse cpufreq_ondemand acpi_cpufreq freq_table mperf
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
> ip6_tables ipv6 uinput snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec broadcom tg3 snd_hwdep snd_seq
> snd_seq_device snd_pcm joydev pcspkr iTCO_wdt iTCO_vendor_support
> dcdbas serio_raw i2c_i801 snd_timer snd microcode soundcore
> snd_page_alloc usb_storage i915 drm_kms_helper drm i2c_algo_bit
> i2c_core video [last unloaded: scsi_wait_scan]
> [ 7481.521237] Pid: 3980, comm: btrfs-endio-wri Tainted: G        W
> 2.6.39-integration-test-20110526-01+ #2
> [ 7481.521240] Call Trace:
> [ 7481.521245]  [<ffffffff8104df7a>] warn_slowpath_common+0x85/0x9d
> [ 7481.521250]  [<ffffffff8104dfac>] warn_slowpath_null+0x1a/0x1c
> [ 7481.521288]  [<ffffffffa02dfca8>] btrfs_alloc_free_block+0x14e/0x357 [btrfs]
> [ 7481.521303]  [<ffffffffa030a073>] ? map_private_extent_buffer+0xb1/0xd5 [btrfs]
> [ 7481.521313]  [<ffffffffa02d2987>] __btrfs_cow_block+0x102/0x31e [btrfs]
> [ 7481.521322]  [<ffffffffa02d1300>] ? btrfs_set_item_key+0x3/0x20 [btrfs]
> [ 7481.521341]  [<ffffffffa02d2ca7>] btrfs_cow_block+0x104/0x14d [btrfs]
> [ 7481.521353]  [<ffffffffa02d5a87>] btrfs_search_slot+0x162/0x502 [btrfs]
> [ 7481.521378]  [<ffffffffa02e3e66>] btrfs_lookup_file_extent+0x3c/0x3e [btrfs]
> [ 7481.521388]  [<ffffffffa02d2124>] ? btrfs_alloc_path+0x1a/0x2b [btrfs]
> [ 7481.521405]  [<ffffffffa02f9319>] btrfs_drop_extents+0x10e/0x731 [btrfs]
> [ 7481.521410]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [ 7481.521415]  [<ffffffff81474da6>] ? _cond_resched+0xe/0x22
> [ 7481.521420]  [<ffffffff8110d58c>] ? slab_pre_alloc_hook.clone.32+0x2d/0x31
> [ 7481.521426]  [<ffffffff8110e0c7>] ? kmem_cache_alloc+0x29/0xf7
> [ 7481.521441]  [<ffffffffa02f09fa>] insert_reserved_file_extent.clone.34+0x70/0x1fc [btrfs]
> [ 7481.521470]  [<ffffffffa03071c9>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
> [ 7481.521496]  [<ffffffffa02f362c>] btrfs_endio_direct_write+0x171/0x29a [btrfs]
> [ 7481.521511]  [<ffffffffa02e6afc>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
> [ 7481.521516]  [<ffffffff81141934>] bio_endio+0x2d/0x2f
> [ 7481.521539]  [<ffffffffa02e6b07>] end_workqueue_fn+0x101/0x10e [btrfs]
> [ 7481.521565]  [<ffffffffa0310951>] worker_loop+0x193/0x4ca [btrfs]
> [ 7481.521581]  [<ffffffffa03107be>] ? btrfs_queue_worker+0x214/0x214 [btrfs]
> [ 7481.521586]  [<ffffffff81068dce>] kthread+0x82/0x8a
> [ 7481.521591]  [<ffffffff8147db64>] kernel_thread_helper+0x4/0x10
> [ 7481.521596]  [<ffffffff81068d4c>] ? kthread_worker_fn+0x14b/0x14b
> [ 7481.521601]  [<ffffffff8147db60>] ? gs_change+0x13/0x13
> [ 7481.521604] ---[ end trace abb147a5624a0a25 ]---
> [ 7481.521639] ------------[ cut here ]------------
> 

> Stack dumps for  more warnings
> ------------------------------
> 
> [21983.399906] WARNING: at fs/btrfs/extent-tree.c:3832

3829 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
3830 {
3831         block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);

3832         WARN_ON(fs_info->delalloc_block_rsv.size > 0);

3833         WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);

in release_global_block_rsv(block_rsv, NULL, num_bytes = (u64)-1):

3543         if (num_bytes == (u64)-1)
3544                 num_bytes = block_rsv->size;
3545         block_rsv->size -= num_bytes;

now block_rsv->size is 0, right? but why did the warn trigger after return from
the call, there is no other assignment in this function. another thread?
possible.

3546         if (block_rsv->reserved >= block_rsv->size) {
3547                 num_bytes = block_rsv->reserved - block_rsv->size;
3548                 block_rsv->reserved = block_rsv->size;

reserved is now 0, but changed later in the func

3549                 block_rsv->full = 1;
3550         } else {
3551                 num_bytes = 0;
3552         }


> btrfs_free_block_groups+0x13a/0x228 [btrfs]()
> [21983.399910] Hardware name: XPS 8300
> [21983.399912] Modules linked in: tcp_lp tun btrfs zlib_deflate
> libcrc32c brd fuse cpufreq_ondemand acpi_cpufreq freq_table mperf
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
> ip6_tables ipv6 uinput snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec broadcom tg3 snd_hwdep snd_seq
> snd_seq_device snd_pcm joydev pcspkr iTCO_wdt iTCO_vendor_support
> dcdbas serio_raw i2c_i801 snd_timer snd microcode soundcore
> snd_page_alloc usb_storage i915 drm_kms_helper drm i2c_algo_bit
> i2c_core video [last unloaded: scsi_wait_scan]
> [21983.399958] Pid: 31847, comm: umount Tainted: G        W
> 2.6.39-integration-test-20110526-01+ #2
> [21983.399961] Call Trace:
> [21983.399969]  [<ffffffff8104df7a>] warn_slowpath_common+0x85/0x9d
> [21983.399975]  [<ffffffff8104dfac>] warn_slowpath_null+0x1a/0x1c
> [21983.399989]  [<ffffffffa02e0a2b>]
> btrfs_free_block_groups+0x13a/0x228 [btrfs]
> [21983.400006]  [<ffffffffa02e975a>] close_ctree+0x1b2/0x35e [btrfs]
> [21983.400011]  [<ffffffff8112eebb>] ? evict+0x10c/0x115
> [21983.400016]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [21983.400021]  [<ffffffff8103ccb6>] ? should_resched+0xe/0x2e
> [21983.400025]  [<ffffffff81474da6>] ? _cond_resched+0xe/0x22
> [21983.400029]  [<ffffffff814759b1>] ? down_write+0x29/0x49
> [21983.400039]  [<ffffffffa02cfa1e>] btrfs_put_super+0x1d/0x2c [btrfs]
> [21983.400044]  [<ffffffff8111c9d4>] generic_shutdown_super+0x74/0xe9
> [21983.400048]  [<ffffffff8111cac9>] kill_anon_super+0x16/0x50
> [21983.400052]  [<ffffffff8111ccfc>] deactivate_locked_super+0x26/0x4b
> [21983.400056]  [<ffffffff8111d4ee>] deactivate_super+0x3a/0x3f
> [21983.400061]  [<ffffffff81132732>] mntput_no_expire+0xd0/0xd5
> [21983.400065]  [<ffffffff811333b8>] sys_umount+0x2dc/0x30a
> [21983.400069]  [<ffffffff8112399e>] ? path_put+0x22/0x27
> [21983.400074]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> [21983.400077] ---[ end trace abb147a5624a0a2a ]---
> [21983.400079] ------------[ cut here ]------------
> [21983.400092] WARNING: at fs/btrfs/extent-tree.c:3833
> btrfs_free_block_groups+0x155/0x228 [btrfs]()

->reserved field of block_rsv

> [21983.400095] Hardware name: XPS 8300
> [21983.400097] Modules linked in: tcp_lp tun btrfs zlib_deflate
> libcrc32c brd fuse cpufreq_ondemand acpi_cpufreq freq_table mperf
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
> ip6_tables ipv6 uinput snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec broadcom tg3 snd_hwdep snd_seq
> snd_seq_device snd_pcm joydev pcspkr iTCO_wdt iTCO_vendor_support
> dcdbas serio_raw i2c_i801 snd_timer snd microcode soundcore
> snd_page_alloc usb_storage i915 drm_kms_helper drm i2c_algo_bit
> i2c_core video [last unloaded: scsi_wait_scan]
> [21983.400136] Pid: 31847, comm: umount Tainted: G        W
> 2.6.39-integration-test-20110526-01+ #2
> [21983.400139] Call Trace:
> [21983.400143]  [<ffffffff8104df7a>] warn_slowpath_common+0x85/0x9d
> [21983.400148]  [<ffffffff8104dfac>] warn_slowpath_null+0x1a/0x1c
> [21983.400160]  [<ffffffffa02e0a46>]
> btrfs_free_block_groups+0x155/0x228 [btrfs]
> [21983.400176]  [<ffffffffa02e975a>] close_ctree+0x1b2/0x35e [btrfs]
> [21983.400179]  [<ffffffff8112eebb>] ? evict+0x10c/0x115
> [21983.400184]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [21983.400188]  [<ffffffff8103ccb6>] ? should_resched+0xe/0x2e
> [21983.400191]  [<ffffffff81474da6>] ? _cond_resched+0xe/0x22
> [21983.400195]  [<ffffffff814759b1>] ? down_write+0x29/0x49
> [21983.400204]  [<ffffffffa02cfa1e>] btrfs_put_super+0x1d/0x2c [btrfs]
> [21983.400209]  [<ffffffff8111c9d4>] generic_shutdown_super+0x74/0xe9
> [21983.400213]  [<ffffffff8111cac9>] kill_anon_super+0x16/0x50
> [21983.400216]  [<ffffffff8111ccfc>] deactivate_locked_super+0x26/0x4b
> [21983.400220]  [<ffffffff8111d4ee>] deactivate_super+0x3a/0x3f
> [21983.400225]  [<ffffffff81132732>] mntput_no_expire+0xd0/0xd5
> [21983.400229]  [<ffffffff811333b8>] sys_umount+0x2dc/0x30a
> [21983.400232]  [<ffffffff8112399e>] ? path_put+0x22/0x27
> [21983.400237]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> [21983.400240] ---[ end trace abb147a5624a0a2b ]---
> [21983.400242] ------------[ cut here ]------------
> [21983.400254] WARNING: at fs/btrfs/extent-tree.c:6846

6844                 if (space_info->bytes_pinned > 0 ||
6845                     space_info->bytes_reserved > 0) {
6846                         WARN_ON(1);
6847                         dump_space_info(space_info, 0, 0);
6848                 }


> btrfs_free_block_groups+0x1e6/0x228 [btrfs]()
> [21983.400257] Hardware name: XPS 8300
> [21983.400259] Modules linked in: tcp_lp tun btrfs zlib_deflate
> libcrc32c brd fuse cpufreq_ondemand acpi_cpufreq freq_table mperf
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
> ip6_tables ipv6 uinput snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec broadcom tg3 snd_hwdep snd_seq
> snd_seq_device snd_pcm joydev pcspkr iTCO_wdt iTCO_vendor_support
> dcdbas serio_raw i2c_i801 snd_timer snd microcode soundcore
> snd_page_alloc usb_storage i915 drm_kms_helper drm i2c_algo_bit
> i2c_core video [last unloaded: scsi_wait_scan]
> [21983.400298] Pid: 31847, comm: umount Tainted: G        W
> 2.6.39-integration-test-20110526-01+ #2
> [21983.400300] Call Trace:
> [21983.400305]  [<ffffffff8104df7a>] warn_slowpath_common+0x85/0x9d
> [21983.400317]  [<ffffffffa02e0af5>] ?
> btrfs_free_block_groups+0x204/0x228 [btrfs]
> [21983.400322]  [<ffffffff8104dfac>] warn_slowpath_null+0x1a/0x1c
> [21983.400334]  [<ffffffffa02e0ad7>]
> btrfs_free_block_groups+0x1e6/0x228 [btrfs]
> [21983.400349]  [<ffffffffa02e975a>] close_ctree+0x1b2/0x35e [btrfs]
> [21983.400352]  [<ffffffff8112eebb>] ? evict+0x10c/0x115
> [21983.400356]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [21983.400360]  [<ffffffff8103ccb6>] ? should_resched+0xe/0x2e
> [21983.400364]  [<ffffffff81474da6>] ? _cond_resched+0xe/0x22
> [21983.400367]  [<ffffffff814759b1>] ? down_write+0x29/0x49
> [21983.400377]  [<ffffffffa02cfa1e>] btrfs_put_super+0x1d/0x2c [btrfs]
> [21983.400381]  [<ffffffff8111c9d4>] generic_shutdown_super+0x74/0xe9
> [21983.400385]  [<ffffffff8111cac9>] kill_anon_super+0x16/0x50
> [21983.400389]  [<ffffffff8111ccfc>] deactivate_locked_super+0x26/0x4b
> [21983.400392]  [<ffffffff8111d4ee>] deactivate_super+0x3a/0x3f
> [21983.400397]  [<ffffffff81132732>] mntput_no_expire+0xd0/0xd5
> [21983.400401]  [<ffffffff811333b8>] sys_umount+0x2dc/0x30a
> [21983.400404]  [<ffffffff8112399e>] ? path_put+0x22/0x27
> [21983.400409]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> [21983.400412] ---[ end trace abb147a5624a0a2c ]---
> 
> 
> 
> Stack dumps for the hang
> ------------------------

the hang seems serious, it's stuck at fs shutdown under an ENOSPC condition
when several operations are in progress, see the stacks for more (background writeback,
sync, mkdir, readdir).

I didn't go further in pre-analysis, obviously the traces have one in common:
block reserves and ENOSPC.


david

> [73934.130640] SysRq : Show Blocked State
> [73934.130644]   task                        PC stack   pid father
> [73934.130676] btrfs-transacti D ffff8801a4a0b440     0  6769      2
> 0x00000080
> [73934.130679]  ffff88011f78bd60 0000000000000046 0000000000000000
> ffff880100000001
> [73934.130682]  0000000000013a80 0000000000013a80 0000000000013a80
> ffff8801a21a0000
> [73934.130684]  0000000000013a80 ffff88011f78bfd8 0000000000013a80
> 0000000000013a80
> [73934.130687] Call Trace:
> [73934.130692]  [<ffffffff8106953e>] ? prepare_to_wait+0x6c/0x79
> [73934.130704]  [<ffffffffa02eb098>]
> wait_for_commit.clone.14+0x90/0xd5 [btrfs]
> [73934.130706]  [<ffffffff810692ab>] ? wake_up_bit+0x2a/0x2a
> [73934.130714]  [<ffffffffa02ebf1c>]
> btrfs_commit_transaction+0x102/0x693 [btrfs]
> [73934.130721]  [<ffffffffa02eb816>] ?
> join_transaction.clone.20+0x17b/0x186 [btrfs]
> [73934.130723]  [<ffffffff810692ab>] ? wake_up_bit+0x2a/0x2a
> [73934.130730]  [<ffffffffa02e6772>] transaction_kthread+0x17a/0x22f [btrfs]
> [73934.130736]  [<ffffffffa02e65f8>] ? btrfs_congested_fn+0x8c/0x8c [btrfs]
> [73934.130738]  [<ffffffff81068dce>] kthread+0x82/0x8a
> [73934.130742]  [<ffffffff8147db64>] kernel_thread_helper+0x4/0x10
> [73934.130743]  [<ffffffff81068d4c>] ? kthread_worker_fn+0x14b/0x14b
> [73934.130745]  [<ffffffff8147db60>] ? gs_change+0x13/0x13
> [73934.130747] flush-btrfs-630 D 00000001046677f8     0  6778      2
> 0x00000080
> [73934.130749]  ffff88012031fb10 0000000000000046 ffff88012031fa70
> ffff880100000000
> [73934.130751]  0000000000013a80 0000000000013a80 0000000000013a80
> ffff8801a5c68000
> [73934.130754]  0000000000013a80 ffff88012031ffd8 0000000000013a80
> 0000000000013a80
> [73934.130756] Call Trace:
> [73934.130759]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
> [73934.130761]  [<ffffffff8107b6c2>] ? arch_local_irq_save+0x18/0x1e
> [73934.130763]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> [73934.130765]  [<ffffffff8106953e>] ? prepare_to_wait+0x6c/0x79
> [73934.130771]  [<ffffffffa02ec0dd>]
> btrfs_commit_transaction+0x2c3/0x693 [btrfs]
> [73934.130773]  [<ffffffff810692ab>] ? wake_up_bit+0x2a/0x2a
> [73934.130781]  [<ffffffffa02f58ba>] btrfs_write_inode+0xa0/0xa9 [btrfs]
> [73934.130784]  [<ffffffff81138d78>] writeback_single_inode+0x125/0x1bf
> [73934.130786]  [<ffffffff81139055>] writeback_sb_inodes+0xce/0x160
> [73934.130788]  [<ffffffff81139d68>] wb_writeback+0x257/0x3a7
> [73934.130790]  [<ffffffff81139f40>] wb_do_writeback+0x88/0x1a0
> [73934.130792]  [<ffffffff8105b0a1>] ? run_timer_softirq+0x298/0x298
> [73934.130794]  [<ffffffff8113a0e3>] bdi_writeback_thread+0x8b/0x20c
> [73934.130796]  [<ffffffff8113a058>] ? wb_do_writeback+0x1a0/0x1a0
> [73934.130798]  [<ffffffff81068dce>] kthread+0x82/0x8a
> [73934.130800]  [<ffffffff8147db64>] kernel_thread_helper+0x4/0x10
> [73934.130802]  [<ffffffff81068d4c>] ? kthread_worker_fn+0x14b/0x14b
> [73934.130804]  [<ffffffff8147db60>] ? gs_change+0x13/0x13
> [73934.130805] fsstress        D 0000000102eb08dd     0  6808      1
> 0x00000084
> [73934.130807]  ffff88011d941d48 0000000000000086 0000000000000000
> 0000000000000400
> [73934.130809]  0000000000013a80 0000000000013a80 0000000000013a80
> ffff88018c3f5c40
> [73934.130812]  0000000000013a80 ffff88011d941fd8 0000000000013a80
> 0000000000013a80
> [73934.130814] Call Trace:
> [73934.130816]  [<ffffffff8103dadf>] ? resched_task+0x48/0x72
> [73934.130818]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
> [73934.130820]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> [73934.130822]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [73934.130824]  [<ffffffff81474e67>] wait_for_common+0xad/0x102
> [73934.130826]  [<ffffffff81046df8>] ? try_to_wake_up+0x226/0x226
> [73934.130828]  [<ffffffff81053dbc>] ? local_bh_enable_ip+0xe/0x10
> [73934.130830]  [<ffffffff8113cf5c>] ? __sync_filesystem+0x7a/0x7a
> [73934.130832]  [<ffffffff81474f74>] wait_for_completion+0x1d/0x1f
> [73934.130834]  [<ffffffff81139717>] sync_inodes_sb+0x91/0x187
> [73934.130835]  [<ffffffff8113cf5c>] ? __sync_filesystem+0x7a/0x7a
> [73934.130837]  [<ffffffff8113cf29>] __sync_filesystem+0x47/0x7a
> [73934.130839]  [<ffffffff8113cf72>] sync_one_sb+0x16/0x18
> [73934.130841]  [<ffffffff8111d632>] iterate_supers+0x6d/0xc4
> [73934.130843]  [<ffffffff8113cea7>] sync_filesystems+0x20/0x22
> [73934.130845]  [<ffffffff8113cfe5>] sys_sync+0x21/0x33
> [73934.130847]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> [73934.130848] fsstress        D 0000000102eb08dd     0  6809      1
> 0x00000084
> [73934.130850]  ffff88011f07fa58 0000000000000082 ffff88010b9bf058
> 0000000100000001
> [73934.130853]  0000000000013a80 0000000000013a80 0000000000013a80
> ffff88018c3f2e20
> [73934.130855]  0000000000013a80 ffff88011f07ffd8 0000000000013a80
> 0000000000013a80
> [73934.130857] Call Trace:
> [73934.130859]  [<ffffffff811ea828>] ? avc_has_perm_flags+0x6c/0x81
> [73934.130861]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
> [73934.130863]  [<ffffffff81476256>] ? _raw_spin_lock+0xe/0x10
> [73934.130865]  [<ffffffff8103e624>] ? task_rq_lock+0x40/0x72
> [73934.130867]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> [73934.130869]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [73934.130870]  [<ffffffff81474e67>] wait_for_common+0xad/0x102
> [73934.130872]  [<ffffffff81046df8>] ? try_to_wake_up+0x226/0x226
> [73934.130874]  [<ffffffff81053dbc>] ? local_bh_enable_ip+0xe/0x10
> [73934.130876]  [<ffffffff81474f74>] wait_for_completion+0x1d/0x1f
> [73934.130877]  [<ffffffff811395bd>] writeback_inodes_sb_nr+0x76/0x7d
> [73934.130880]  [<ffffffff81139670>]
> writeback_inodes_sb_nr_if_idle+0x41/0x57
> [73934.130885]  [<ffffffffa02d9ec4>]
> shrink_delalloc.clone.46+0xb2/0x155 [btrfs]
> [73934.130888]  [<ffffffff811f560f>] ? sidtab_context_to_sid+0x5a/0x12c
> [73934.130893]  [<ffffffffa02da060>]
> reserve_metadata_bytes.clone.47+0xf9/0x1b3 [btrfs]
> [73934.130899]  [<ffffffffa02dcc09>] btrfs_block_rsv_add+0x2c/0x4f [btrfs]
> [73934.130901]  [<ffffffff8103ccb6>] ? should_resched+0xe/0x2e
> [73934.130907]  [<ffffffffa02dce32>]
> btrfs_trans_reserve_metadata+0x4f/0x74 [btrfs]
> [73934.130914]  [<ffffffffa02ec899>] start_transaction+0x190/0x24f [btrfs]
> [73934.130921]  [<ffffffffa02ecc7b>]
> btrfs_start_transaction+0x13/0x15 [btrfs]
> [73934.130928]  [<ffffffffa02f6e04>] btrfs_mkdir+0x46/0x1e5 [btrfs]
> [73934.130931]  [<ffffffff8112520a>] vfs_mkdir+0x63/0x9f
> [73934.130933]  [<ffffffff81127373>] sys_mkdirat+0x96/0xe7
> [73934.130934]  [<ffffffff8112399e>] ? path_put+0x22/0x27
> [73934.130937]  [<ffffffff810988fb>] ? audit_syscall_entry+0x11c/0x148
> [73934.130938]  [<ffffffff811273dc>] sys_mkdir+0x18/0x1a
> [73934.130940]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> [73934.130942] updatedb        D 0000000102f9f23b     0  7525   7519
> 0x00000080
> [73934.130944]  ffff88011ee61e28 0000000000000086 ffff88011ee61f28
> ffff880100000000
> [73934.130946]  0000000000013a80 0000000000013a80 0000000000013a80
> ffff8801a5ccae20
> [73934.130949]  0000000000013a80 ffff88011ee61fd8 0000000000013a80
> 0000000000013a80
> [73934.130951] Call Trace:
> [73934.130953]  [<ffffffff81475660>] __mutex_lock_common.clone.5+0x12f/0x196
> [73934.130955]  [<ffffffff81129280>] ? filldir64+0xd5/0xd5
> [73934.130957]  [<ffffffff814756ef>]
> __mutex_lock_killable_slowpath+0x13/0x15
> [73934.130960]  [<ffffffff8106bd38>] __mutex_fastpath_lock_retval+0x18/0x1a
> [73934.130961]  [<ffffffff81475471>] mutex_lock_killable+0x38/0x54
> [73934.130963]  [<ffffffff81129460>] vfs_readdir+0x56/0xac
> [73934.130965]  [<ffffffff8112959f>] sys_getdents+0x81/0xd1
> [73934.130967]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> [73934.130970] sync            D 0000000104667813     0  8162   1930
> 0x00000080
> [73934.130972]  ffff880190491d48 0000000000000082 0000000000000000
> 0000000000000000
> [73934.130974]  0000000000013a80 0000000000013a80 0000000000013a80
> ffff88015abe0000
> [73934.130976]  0000000000013a80 ffff880190491fd8 0000000000013a80
> 0000000000013a80
> [73934.130978] Call Trace:
> [73934.130980]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
> [73934.130982]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> [73934.130984]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
> [73934.130985]  [<ffffffff81474e67>] wait_for_common+0xad/0x102
> [73934.130987]  [<ffffffff81046df8>] ? try_to_wake_up+0x226/0x226
> [73934.130989]  [<ffffffff81053dbc>] ? local_bh_enable_ip+0xe/0x10
> [73934.130991]  [<ffffffff8113cf5c>] ? __sync_filesystem+0x7a/0x7a
> [73934.130993]  [<ffffffff81474f74>] wait_for_completion+0x1d/0x1f
> [73934.130994]  [<ffffffff811395bd>] writeback_inodes_sb_nr+0x76/0x7d
> [73934.130996]  [<ffffffff811395e6>] writeback_inodes_sb+0x22/0x24
> [73934.130998]  [<ffffffff8113cf33>] __sync_filesystem+0x51/0x7a
> [73934.131000]  [<ffffffff8113cf72>] sync_one_sb+0x16/0x18
> [73934.131002]  [<ffffffff8111d632>] iterate_supers+0x6d/0xc4
> [73934.131004]  [<ffffffff8113cea7>] sync_filesystems+0x20/0x22
> [73934.131005]  [<ffffffff8113cfdb>] sys_sync+0x17/0x33
> [73934.131007]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
