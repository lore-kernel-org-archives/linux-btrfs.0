Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3BBOvI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 09:51:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, arnd@linaro.org
Subject: Oops when mounting btrfs partition
Date: Sat, 02 Feb 2013 15:51:03 +0100
Message-ID: <4028366.UQxPtEU6If@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As mentioned on Google+, I have a partition that I can no longer mount
normally, containing a lot of my personal data and all backups from
my laptop.

I found now that I am still able to mount it using the 'nospace_cache'
option, but it takes a couple of minutes and I get "INFO: task
btrfs-transacti:1698 blocked for more than 120 seconds." messages
reporting the thread to be stuck in

[<ffffffff816c671d>] wait_for_completion+0x1d/0x20
[<ffffffffa01d9b76>] btrfs_wait_and_free_delalloc_work+0x16/0x30 [btrfs]
[<ffffffffa01e1590>] btrfs_run_ordered_operations+0x290/0x2f0 [btrfs]
[<ffffffffa01ca7af>] btrfs_commit_transaction+0x5f/0xab0 [btrfs]
[<ffffffffa01c3cfd>] transaction_kthread+0x1bd/0x240 [btrfs]
[ 2040.620221]  [<ffffffff8107d290>] kthread+0xc0/0xd0

but that seems harmless otherwise. The system seems slow but usable after
this, but I have seen a corrupt "akonadi" database after that, so I'm
still suspicious and will try to rescue the data and reformat the
partition before I do any real work on this again.

Looking back at the log I actually found multiple errors. There was
a btrfs checksum error a couple of weeks ago, but fsck did not find
anything, so I blamed that on a spurious RAM error.
This is the earliest WARNING I found in the logs I still have:

Jan 14 19:18:42 localhost kernel: [1060055.746373] btrfs csum failed ino 15619835 off 454656 csum 2755731641 private 864823192
Jan 14 19:18:42 localhost kernel: [1060055.746381] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 17, gen 0
...
Jan 21 16:35:40 localhost kernel: [1655047.701147] parent transid verify failed on 17006399488 wanted 54700 found 54764
Jan 21 16:35:40 localhost kernel: [1655047.752517] parent transid verify failed on 17006399488 wanted 54700 found 54764
Jan 21 16:35:40 localhost kernel: [1655047.752692] btrfs read error corrected: ino 1 off 17006399488 (dev /dev/sdb1 sector 64689288)
Jan 21 16:35:40 localhost kernel: [1655047.752704] btrfs: run_one_delayed_ref returned -5
Jan 21 16:35:40 localhost kernel: [1655047.752706] ------------[ cut here ]------------
Jan 21 16:35:40 localhost kernel: [1655047.752746] WARNING: at /build/buildd/linux-3.5.0/fs/btrfs/super.c:221 __btrfs_abort_transaction+0xad/0xc0 [btrfs]()
Jan 21 16:35:40 localhost kernel: [1655047.752747] Hardware name: P5Q-EM
Jan 21 16:35:40 localhost kernel: [1655047.752748] btrfs: Transaction aborted
Jan 21 16:35:40 localhost kernel: [1655047.752750] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 bnep rfcomm parport_pc ppdev bluetooth lp parport binfmt_misc dm_crypt coretemp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek microcode snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi serio_raw snd_seq_midi_event lpc_ich snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc asus_atk0110 mac_hid btrfs zlib_deflate libcrc32c hid_generic i915 firewire_ohci drm_kms_helper firewire_core crc_itu_t r8169 drm i2c_algo_bit video pata_marvell usbhid hid usb_storage
Jan 21 16:35:40 localhost kernel: [1655047.752789] Pid: 7652, comm: btrfs-endio-wri Tainted: G        W    3.5.0-7-generic #7-Ubuntu
Jan 21 16:35:40 localhost kernel: [1655047.752791] Call Trace:
Jan 21 16:35:40 localhost kernel: [1655047.752800]  [<ffffffff81051c0f>] warn_slowpath_common+0x7f/0xc0
Jan 21 16:35:40 localhost kernel: [1655047.752803]  [<ffffffff81051d06>] warn_slowpath_fmt+0x46/0x50
Jan 21 16:35:40 localhost kernel: [1655047.752814]  [<ffffffffa016ed6d>] __btrfs_abort_transaction+0xad/0xc0 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752826]  [<ffffffffa0183d24>] btrfs_run_delayed_refs+0x3f4/0x440 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752840]  [<ffffffffa01b62a9>] ? merge_state+0xd9/0x150 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752845]  [<ffffffff8168035e>] ? _raw_spin_lock+0xe/0x20
Jan 21 16:35:40 localhost kernel: [1655047.752856]  [<ffffffffa017dce1>] ? block_rsv_release_bytes+0x131/0x190 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752869]  [<ffffffffa019571f>] __btrfs_end_transaction+0x9f/0x350 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752882]  [<ffffffffa0195a45>] btrfs_end_transaction+0x15/0x20 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752895]  [<ffffffffa019b74d>] btrfs_finish_ordered_io+0x17d/0x410 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752907]  [<ffffffffa019b9f5>] finish_ordered_fn+0x15/0x20 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752921]  [<ffffffffa01c688f>] worker_loop+0x15f/0x5a0 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752923]  [<ffffffff8167ed2f>] ? __schedule+0x3cf/0x7c0
Jan 21 16:35:40 localhost kernel: [1655047.752937]  [<ffffffffa01c6730>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
Jan 21 16:35:40 localhost kernel: [1655047.752941]  [<ffffffff81076203>] kthread+0x93/0xa0
Jan 21 16:35:40 localhost kernel: [1655047.752943]  [<ffffffff816898e4>] kernel_thread_helper+0x4/0x10
Jan 21 16:35:40 localhost kernel: [1655047.752946]  [<ffffffff81076170>] ? flush_kthread_worker+0x80/0x80
Jan 21 16:35:40 localhost kernel: [1655047.752948]  [<ffffffff816898e0>] ? gs_change+0x13/0x13
Jan 21 16:35:40 localhost kernel: [1655047.752950] ---[ end trace 5ec1dfeeeee1fd2d ]---
Jan 21 16:35:40 localhost kernel: [1655047.752952] BTRFS error (device sdb1) in btrfs_run_delayed_refs:2455: IO failure
Jan 21 16:35:40 localhost kernel: [1655047.752955] btrfs is forced readonly
...
Jan 23 16:41:41 localhost kernel: [1828208.048292] ------------[ cut here ]------------
Jan 23 16:41:41 localhost kernel: [1828208.048344] WARNING: at /build/buildd/linux-3.5.0/fs/btrfs/inode.c:6992 btrfs_destroy_inode+0x2db/0x320 [btrfs]()
Jan 23 16:41:41 localhost kernel: [1828208.048346] Hardware name: P5Q-EM
Jan 23 16:41:41 localhost kernel: [1828208.048347] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 bnep rfcomm parport_pc ppdev bluetooth lp parport
 binfmt_misc dm_crypt coretemp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek microcode snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi serio_raw sn
d_seq_midi_event lpc_ich snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc asus_atk0110 mac_hid btrfs zlib_deflate libcrc32c hid_generic i915 firewire_ohci drm_kms_hel
per firewire_core crc_itu_t r8169 drm i2c_algo_bit video pata_marvell usbhid hid usb_storage
Jan 23 16:41:41 localhost kernel: [1828208.048386] Pid: 37, comm: kswapd0 Tainted: G        W    3.5.0-7-generic #7-Ubuntu
Jan 23 16:41:41 localhost kernel: [1828208.048387] Call Trace:
Jan 23 16:41:41 localhost kernel: [1828208.048397]  [<ffffffff81051c0f>] warn_slowpath_common+0x7f/0xc0
Jan 23 16:41:41 localhost kernel: [1828208.048400]  [<ffffffff81051c6a>] warn_slowpath_null+0x1a/0x20
Jan 23 16:41:41 localhost kernel: [1828208.048413]  [<ffffffffa01a31bb>] btrfs_destroy_inode+0x2db/0x320 [btrfs]
Jan 23 16:41:41 localhost kernel: [1828208.048419]  [<ffffffff8119c32c>] destroy_inode+0x3c/0x70
Jan 23 16:41:41 localhost kernel: [1828208.048421]  [<ffffffff8119c483>] evict+0x123/0x1b0
Jan 23 16:41:41 localhost kernel: [1828208.048424]  [<ffffffff8119ca91>] dispose_list+0x41/0x50
Jan 23 16:41:41 localhost kernel: [1828208.048426]  [<ffffffff8119d3bd>] prune_icache_sb+0x17d/0x350
Jan 23 16:41:41 localhost kernel: [1828208.048430]  [<ffffffff81184fcb>] prune_super+0x15b/0x1b0
Jan 23 16:41:41 localhost kernel: [1828208.048434]  [<ffffffff811338d9>] shrink_slab+0x149/0x2d0
Jan 23 16:41:41 localhost kernel: [1828208.048439]  [<ffffffff8117876c>] ? mem_cgroup_iter+0xdc/0x1f0
Jan 23 16:41:41 localhost kernel: [1828208.048442]  [<ffffffff81136e79>] balance_pgdat+0x5c9/0x760
Jan 23 16:41:41 localhost kernel: [1828208.048445]  [<ffffffff8113717a>] kswapd+0x16a/0x3c0
Jan 23 16:41:41 localhost kernel: [1828208.048450]  [<ffffffff81076750>] ? finish_wait+0x80/0x80
Jan 23 16:41:41 localhost kernel: [1828208.048452]  [<ffffffff81137010>] ? balance_pgdat+0x760/0x760
Jan 23 16:41:41 localhost kernel: [1828208.048454]  [<ffffffff81076203>] kthread+0x93/0xa0
Jan 23 16:41:41 localhost kernel: [1828208.048458]  [<ffffffff816898e4>] kernel_thread_helper+0x4/0x10
Jan 23 16:41:41 localhost kernel: [1828208.048461]  [<ffffffff81076170>] ? flush_kthread_worker+0x80/0x80
Jan 23 16:41:41 localhost kernel: [1828208.048463]  [<ffffffff816898e0>] ? gs_change+0x13/0x13
Jan 23 16:41:41 localhost kernel: [1828208.048464] ---[ end trace 5ec1dfeeeee1fd2e ]---

After this, I updated the kernel, rebooted and did a btrfsck that automatically
corrected a small number of errors, and I got this, presumably before the fsck,
but I'm not sure about that:

Jan 24 11:26:42 localhost kernel: [    9.272856] btrfs: unlinked 12 orphans
Jan 24 11:26:42 localhost kernel: [    9.276291] device fsid 1bc63831-a7ad-4197-99b0-8aa60a5dc74b devid 1 transid 59949 /dev/sdb1
Jan 24 11:26:42 localhost kernel: [    9.276752] btrfs: disk space caching is enabled
Jan 24 11:26:42 localhost kernel: [    9.408634] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 17, gen 0
Jan 24 11:26:42 localhost kernel: [   14.777130] ------------[ cut here ]------------
Jan 24 11:26:42 localhost kernel: [   14.777141] WARNING: at /build/buildd/linux-3.8.0/fs/inode.c:337 inc_nlink+0x2e/0x40()
Jan 24 11:26:42 localhost kernel: [   14.777143] Hardware name: P5Q-EM
Jan 24 11:26:42 localhost kernel: [   14.777145] Modules linked in: dm_crypt(F) coretemp kvm_intel kvm microcode(F) snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_
codec snd_hwdep(F) snd_pcm(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F) asus_atk0110 snd_seq_device(F) snd_timer(F) snd(F) mac_hid serio_ra
w(F) lpc_ich soundcore(F) btrfs(F) zlib_deflate(F) libcrc32c(F) hid_generic firewire_ohci firewire_core crc_itu_t(F) i915 usb_storage(F) r8169 usbhid hid video(F) i2c_algo_bit drm
_kms_helper pata_marvell drm
Jan 24 11:26:42 localhost kernel: [   14.777183] Pid: 844, comm: mount Tainted: GF            3.8.0-1-generic #5-Ubuntu
Jan 24 11:26:42 localhost kernel: [   14.777185] Call Trace:
Jan 24 11:26:42 localhost kernel: [   14.777191]  [<ffffffff8105878f>] warn_slowpath_common+0x7f/0xc0
Jan 24 11:26:42 localhost kernel: [   14.777194]  [<ffffffff810587ea>] warn_slowpath_null+0x1a/0x20
Jan 24 11:26:42 localhost kernel: [   14.777197]  [<ffffffff811abc3e>] inc_nlink+0x2e/0x40
Jan 24 11:26:42 localhost kernel: [   14.777225]  [<ffffffffa01ff730>] link_to_fixup_dir+0xc0/0xf0 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777237]  [<ffffffffa02034b5>] replay_one_buffer+0x1d5/0x350 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777249]  [<ffffffffa01e9987>] ? alloc_extent_buffer+0x97/0x400 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777261]  [<ffffffffa01ff1e2>] walk_down_log_tree+0x212/0x400 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777273]  [<ffffffffa01ff46d>] walk_log_tree+0x9d/0x1f0 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777284]  [<ffffffffa01c7f15>] ? btrfs_read_fs_root_no_name+0x1d5/0x310 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777296]  [<ffffffffa0205415>] btrfs_recover_log_trees+0x215/0x390 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777308]  [<ffffffffa02032e0>] ? fixup_inode_link_counts+0x150/0x150 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777319]  [<ffffffffa01ca958>] open_ctree+0x1718/0x1da0 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777324]  [<ffffffff813303e1>] ? disk_name+0x61/0xc0
Jan 24 11:26:42 localhost kernel: [   14.777333]  [<ffffffffa01a3a84>] btrfs_mount+0x614/0x750 [btrfs]
Jan 24 11:26:42 localhost kernel: [   14.777337]  [<ffffffff81197273>] mount_fs+0x43/0x1b0
Jan 24 11:26:42 localhost kernel: [   14.777339]  [<ffffffff811b1a87>] ? alloc_vfsmnt+0xd7/0x1b0
Jan 24 11:26:42 localhost kernel: [   14.777342]  [<ffffffff811b1c14>] vfs_kern_mount+0x74/0x110
Jan 24 11:26:42 localhost kernel: [   14.777345]  [<ffffffff811b3f66>] do_mount+0x216/0xa80
Jan 24 11:26:42 localhost kernel: [   14.777348]  [<ffffffff81149c0b>] ? strndup_user+0x5b/0x80
Jan 24 11:26:42 localhost kernel: [   14.777351]  [<ffffffff811b485e>] sys_mount+0x8e/0xe0
Jan 24 11:26:42 localhost kernel: [   14.777355]  [<ffffffff816cfd1d>] system_call_fastpath+0x1a/0x1f
Jan 24 11:26:42 localhost kernel: [   14.777356] ---[ end trace da079e2b4c0faaa4 ]---
Jan 24 11:26:42 localhost kernel: [   36.994720] btrfs: unlinked 3 orphans
Jan 24 11:26:42 localhost kernel: [   36.994723] btrfs: truncated 8 orphans

I rebooted again since, for an unrelated reason, and yesterday when I tried to do
a backup to this partition using 'rsync --link-dest=...', I got another error:

Feb  1 19:30:07 localhost kernel: [323892.988411] parent transid verify failed on 17006399488 wanted 54700 found 54764
Feb  1 19:30:07 localhost kernel: [323893.003761] parent transid verify failed on 17006399488 wanted 54700 found 54764
Feb  1 19:30:07 localhost kernel: [323893.003767] btrfs: run_one_delayed_ref returned -5
Feb  1 19:30:07 localhost kernel: [323893.003769] ------------[ cut here ]------------
Feb  1 19:30:07 localhost kernel: [323893.003795] WARNING: at /build/buildd/linux-3.8.0/fs/btrfs/super.c:256 __btrfs_abort_transaction+0xdf/0x100 [btrfs]()
Feb  1 19:30:07 localhost kernel: [323893.003797] Hardware name: P5Q-EM
Feb  1 19:30:07 localhost kernel: [323893.003798] btrfs: Transaction aborted
Feb  1 19:30:07 localhost kernel: [323893.003800] Modules linked in: ufs(F) qnx4 hfsplus hfs minix ntfs msdos(F) jfs xfs(F) reiserfs ext2(F) sch_fq_codel(F) rfcomm bnep bluetooth parport_pc(F) ppdev(F) lp(F) parport(F) binfmt_misc(F) dm_crypt(F) coretemp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek microcode(F) snd_hda_intel snd_hda_codec snd_hwdep(F) snd_pcm(F) snd_page_alloc(F) serio_raw(F) snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F) asus_atk0110 snd_seq_device(F) snd_timer(F) snd(F) mac_hid lpc_ich soundcore(F) btrfs(F) zlib_deflate(F) libcrc32c(F) hid_generic firewire_ohci firewire_core crc_itu_t(F) i915 usbhid hid video(F) i2c_algo_bit drm_kms_helper drm r8169 usb_storage(F) pata_marvell
Feb  1 19:30:07 localhost kernel: [323893.003861] Pid: 19005, comm: btrfs-endio-wri Tainted: GF            3.8.0-1-generic #5-Ubuntu
Feb  1 19:30:07 localhost kernel: [323893.003862] Call Trace:
Feb  1 19:30:07 localhost kernel: [323893.003869]  [<ffffffff8105878f>] warn_slowpath_common+0x7f/0xc0
Feb  1 19:30:07 localhost kernel: [323893.003872]  [<ffffffff8105888c>] warn_slowpath_fmt+0x4c/0x50
Feb  1 19:30:07 localhost kernel: [323893.003882]  [<ffffffffa01a1f1f>] __btrfs_abort_transaction+0xdf/0x100 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003893]  [<ffffffffa01baf82>] btrfs_run_delayed_refs+0x252/0x2f0 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003905]  [<ffffffffa01cb32e>] __btrfs_end_transaction+0xee/0x3f0 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003917]  [<ffffffffa01cb680>] btrfs_end_transaction+0x10/0x20 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003929]  [<ffffffffa01d3e0d>] btrfs_finish_ordered_io+0x10d/0x3f0 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003941]  [<ffffffffa01d4105>] finish_ordered_fn+0x15/0x20 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003953]  [<ffffffffa01f4abf>] worker_loop+0x16f/0x5c0 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003958]  [<ffffffff816c5d83>] ? __schedule+0x3d3/0x7b0
Feb  1 19:30:07 localhost kernel: [323893.003971]  [<ffffffffa01f4950>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
Feb  1 19:30:07 localhost kernel: [323893.003974]  [<ffffffff8107d1a0>] kthread+0xc0/0xd0
Feb  1 19:30:07 localhost kernel: [323893.003976]  [<ffffffff8107d0e0>] ? kthread_create_on_node+0x120/0x120
Feb  1 19:30:07 localhost kernel: [323893.003979]  [<ffffffff816cfc6c>] ret_from_fork+0x7c/0xb0
Feb  1 19:30:07 localhost kernel: [323893.003981]  [<ffffffff8107d0e0>] ? kthread_create_on_node+0x120/0x120
Feb  1 19:30:07 localhost kernel: [323893.003983] ---[ end trace 2cc0be2fd0537d06 ]---
Feb  1 19:30:07 localhost kernel: [323893.003985] BTRFS error (device sdb1) in btrfs_run_delayed_refs:2504: IO failure
Feb  1 19:30:07 localhost kernel: [323893.003987] btrfs is forced readonly
Feb  1 19:30:08 localhost kernel: [323894.045539] ------------[ cut here ]------------
Feb  1 19:30:08 localhost kernel: [323894.045573] WARNING: at /build/buildd/linux-3.8.0/fs/btrfs/delayed-ref.c:397 btrfs_find_ref_cluster+0x159/0x170 [btrfs]()
Feb  1 19:30:08 localhost kernel: [323894.045575] Hardware name: P5Q-EM
Feb  1 19:30:08 localhost kernel: [323894.045576] Modules linked in: ufs(F) qnx4 hfsplus hfs minix ntfs msdos(F) jfs xfs(F) reiserfs ext2(F) sch_fq_codel(F) rfcomm bnep bluetooth parport_pc(F) ppdev(F) lp(F) parport(F) binfmt_misc(F) dm_crypt(F) coretemp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek microcode(F) snd_hda_intel snd_hda_codec snd_hwdep(F) snd_pcm(F) snd_page_alloc(F) serio_raw(F) snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F) asus_atk0110 snd_seq_device(F) snd_timer(F) snd(F) mac_hid lpc_ich soundcore(F) btrfs(F) zlib_deflate(F) libcrc32c(F) hid_generic firewire_ohci firewire_core crc_itu_t(F) i915 usbhid hid video(F) i2c_algo_bit drm_kms_helper drm r8169 usb_storage(F) pata_marvell
Feb  1 19:30:08 localhost kernel: [323894.045623] Pid: 855, comm: btrfs-transacti Tainted: GF       W    3.8.0-1-generic #5-Ubuntu
Feb  1 19:30:08 localhost kernel: [323894.045625] Call Trace:
Feb  1 19:30:08 localhost kernel: [323894.045633]  [<ffffffff8105878f>] warn_slowpath_common+0x7f/0xc0
Feb  1 19:30:08 localhost kernel: [323894.045636]  [<ffffffff810587ea>] warn_slowpath_null+0x1a/0x20
Feb  1 19:30:08 localhost kernel: [323894.045652]  [<ffffffffa020b909>] btrfs_find_ref_cluster+0x159/0x170 [btrfs]
Feb  1 19:30:08 localhost kernel: [323894.045667]  [<ffffffffa01bae65>] btrfs_run_delayed_refs+0x135/0x2f0 [btrfs]
Feb  1 19:30:08 localhost kernel: [323894.045682]  [<ffffffffa01cacbb>] btrfs_commit_transaction+0x53b/0xa80 [btrfs]
Feb  1 19:30:08 localhost kernel: [323894.045686]  [<ffffffff8107dae0>] ? finish_wait+0x80/0x80
Feb  1 19:30:08 localhost kernel: [323894.045701]  [<ffffffffa01c3d2d>] transaction_kthread+0x1bd/0x240 [btrfs]
Feb  1 19:30:08 localhost kernel: [323894.045716]  [<ffffffffa01c3b70>] ? write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Feb  1 19:30:08 localhost kernel: [323894.045719]  [<ffffffff8107d1a0>] kthread+0xc0/0xd0
Feb  1 19:30:08 localhost kernel: [323894.045722]  [<ffffffff8107d0e0>] ? kthread_create_on_node+0x120/0x120
Feb  1 19:30:08 localhost kernel: [323894.045727]  [<ffffffff816cfc6c>] ret_from_fork+0x7c/0xb0
Feb  1 19:30:08 localhost kernel: [323894.045730]  [<ffffffff8107d0e0>] ? kthread_create_on_node+0x120/0x120
Feb  1 19:30:08 localhost kernel: [323894.045732] ---[ end trace 2cc0be2fd0537d07 ]---
(the last WARN repeats 8 times)

Directly after rebooting, things got even worse and during mount, I got this one:
Feb  1 22:57:37 localhost kernel: [ 8561.599062] ------------[ cut here ]------------
Feb  1 22:57:37 localhost kernel: [ 8561.599482] Kernel BUG at ffffffffa01fdcf7 [verbose debug info unavailable]
Feb  1 22:57:37 localhost kernel: [ 8561.599900] invalid opcode: 0000 [#1] SMP 
Feb  1 22:57:37 localhost kernel: [ 8561.600318] Modules linked in: rfcomm bnep bluetooth parport_pc(F) ppdev(F) lp(F) parport(F) binfmt_misc(F) dm_crypt(F) coretemp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep(F) microcode(F) snd_pcm(F) snd_page_alloc(F) serio_raw(F) snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) asus_atk0110 snd_seq(F) snd_seq_device(F) snd_timer(F) mac_hid snd(F) lpc_ich soundcore(F) btrfs(F) zlib_deflate(F) libcrc32c(F) hid_generic firewire_ohci firewire_core crc_itu_t(F) r8169 i915 pata_marvell video(F) i2c_algo_bit usbhid drm_kms_helper hid drm usb_storage(F)
Feb  1 22:57:37 localhost kernel: [ 8561.602220] CPU 2 
Feb  1 22:57:37 localhost kernel: [ 8561.602232] Pid: 1581, comm: mount Tainted: GF            3.8.0-3-generic #7-Ubuntu System manufacturer P5Q-EM/P5Q-EM
Feb  1 22:57:37 localhost kernel: [ 8561.602956] RIP: 0010:[<ffffffffa01fdcf7>]  [<ffffffffa01fdcf7>] remove_from_bitmap+0x1b7/0x1c0 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956] RSP: 0018:ffff8803098fb7a8  EFLAGS: 00010287
Feb  1 22:57:37 localhost kernel: [ 8561.602956] RAX: 000000d608563000 RBX: ffff88031aa86980 RCX: ffff88031d244ca4
Feb  1 22:57:37 localhost kernel: [ 8561.602956] RDX: 0000000000004000 RSI: 0000000000008000 RDI: 00000000000016c0
Feb  1 22:57:37 localhost kernel: [ 8561.602956] RBP: ffff8803098fb7f0 R08: ffff88030e551d28 R09: 0000000000006940
Feb  1 22:57:37 localhost kernel: [ 8561.602956] R10: ffffea000c761f00 R11: ffffffffa01a9f24 R12: ffff88031d244c80
Feb  1 22:57:37 localhost kernel: [ 8561.602956] R13: ffff8803098fb810 R14: ffff8803098fb808 R15: 000000d609c00000
Feb  1 22:57:37 localhost kernel: [ 8561.602956] FS:  00007f47c8517840(0000) GS:ffff88032fd00000(0000) knlGS:0000000000000000
Feb  1 22:57:37 localhost kernel: [ 8561.602956] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  1 22:57:37 localhost kernel: [ 8561.602956] CR2: 00007f42ab672000 CR3: 00000001c265f000 CR4: 00000000000407e0
Feb  1 22:57:37 localhost kernel: [ 8561.602956] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  1 22:57:37 localhost kernel: [ 8561.602956] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  1 22:57:37 localhost kernel: [ 8561.602956] Process mount (pid: 1581, threadinfo ffff8803098fa000, task ffff880309a4ae80)
Feb  1 22:57:37 localhost kernel: [ 8561.602956] Stack:
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  0000000000000000 ffff88031d244ca4 000000d608567000 0000000000004000
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  ffff88031d244c80 ffff88031d244ca4 0000000000000000 ffff88031ca0bf00
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  ffff88031d37f000 ffff8803098fb840 ffffffffa01ff633 ffffffff8107dbd0
Feb  1 22:57:37 localhost kernel: [ 8561.602956] Call Trace:
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01ff633>] btrfs_remove_free_space+0x53/0x280 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff8107dbd0>] ? finish_wait+0x80/0x80
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01b1e97>] btrfs_alloc_logged_file_extent+0x1b7/0x1d0 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01f9bd0>] replay_one_extent+0x620/0x690 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01fa92b>] replay_one_buffer+0x2ab/0x350 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01e0b77>] ? alloc_extent_buffer+0x97/0x400 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01f64f2>] walk_down_log_tree+0x212/0x400 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01f677d>] walk_log_tree+0x9d/0x1f0 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01beee3>] ? btrfs_read_fs_root_no_name+0x1d3/0x310 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01fc7b5>] btrfs_recover_log_trees+0x215/0x390 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01fa680>] ? fixup_inode_link_counts+0x150/0x150 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa01c192c>] open_ctree+0x171c/0x1da0 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff81330621>] ? disk_name+0x61/0xc0
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffffa019aa83>] btrfs_mount+0x613/0x750 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff811974f3>] mount_fs+0x43/0x1b0
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff811b1ce7>] ? alloc_vfsmnt+0xd7/0x1b0
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff811b1e74>] vfs_kern_mount+0x74/0x110
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff811b41c6>] do_mount+0x216/0xa80
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff81149ecb>] ? strndup_user+0x5b/0x80
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff811b4abe>] sys_mount+0x8e/0xe0
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  [<ffffffff816cff9d>] system_call_fastpath+0x1a/0x1f
Feb  1 22:57:37 localhost kernel: [ 8561.602956] Code: 0f 1f 40 00 31 c0 48 83 7b 20 00 75 e4 48 89 de 4c 89 e7 89 45 b8 e8 39 fb ff ff 8b 45 b8 eb d1 0f 1f 40 00 b8 ea ff ff ff eb c6 <0f> 0b 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 57 41 
Feb  1 22:57:37 localhost kernel: [ 8561.602956] RIP  [<ffffffffa01fdcf7>] remove_from_bitmap+0x1b7/0x1c0 [btrfs]
Feb  1 22:57:37 localhost kernel: [ 8561.602956]  RSP <ffff8803098fb7a8>
Feb  1 22:57:37 localhost kernel: [ 8561.654125] ---[ end trace 4d75f03018b9a5de ]---
Feb  1 23:00:29 localhost kernel: [ 8733.375198] device fsid b30ba997-8203-4b38-a1bf-1a83b4c75535 devid 1 transid 8596 /dev/sda2
Feb  1 23:00:29 localhost kernel: [ 8733.375594] btrfs: disk space caching is enabled
Feb  1 23:00:29 localhost kernel: [ 8733.391288] Btrfs detected SSD devices, enabling SSD mode
Feb  1 23:05:59 localhost kernel: [ 9063.847816] device fsid 1bc63831-a7ad-4197-99b0-8aa60a5dc74b devid 1 transid 71415 /dev/sdb1

I tried again with the older 3.5 kernel and got the same message (BUG_ON in
remove_from_bitmap),  but I can't find that in the log now.

Some more background on what else happened on this machine:

I created the file system on a couple of months ago after getting a
bigger hard drive. I have not run any kernels I patched myself on
it as far as I can remember, but always used Ubuntu kernels. The
kernel I was running while the corruption happened was based
on 3.8-rc4, see https://launchpad.net/ubuntu/+source/linux/3.8.0-1.5.

The files that were accessed then were old backups with multiple hardlinks
as well as reflinks shared with other backups, presumably creating
lots of additional new files and hardlinks.

$ sudo btrfs filesystem show /dev/sdb1
Label: none  uuid: 1bc63831-a7ad-4197-99b0-8aa60a5dc74b
        Total devices 1 FS bytes used 865.76GB
        devid    1 size 1.50TB used 1.11TB path /dev/sdb1
Btrfs Btrfs v0.19

I have not tried again to mount the file system without the 'nospace_cache'
option after it started working with that option.

If it helps to debug further, I can install patched kernels on
the system or provide a login shell, after I have copied the
data elsewhere.

	Arnd
