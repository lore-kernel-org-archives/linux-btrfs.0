From: Josef Bacik <josef@redhat.com>
Subject: Re: Filesystem corrupt after renaming snapshots.
Date: Thu, 18 Aug 2011 14:54:36 -0400
Message-ID: <20110818185436.GA28234@dhcp231-156.rdu.redhat.com>
References: <20110810203859.2e545ed1a3bee50207fb622f@ihug.co.nz> <20110818175346.GD16820@ds.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: josef@redhat.com, linux-btrfs@vger.kernel.org,
	Ralph Loader <suckfish@ihug.co.nz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110818175346.GD16820@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 18, 2011 at 07:53:46PM +0200, David Sterba wrote:
> Hi,
> 
> On Wed, Aug 10, 2011 at 08:38:59PM +1200, Ralph Loader wrote:
> > Hi,
> > 
> > Recently I suffered from a badly corrupted btrfs filesystem.
> > 
> > I had several snapshots in /snap that I moved into / (using /bin/mv).
> > After that, attempting to access the ls the snapshot resulted in the
> > ls process hanging.  There were syslog messages:
> > 
> > Aug  7 20:56:42 i kernel: [  111.882816] ------------[ cut here ]------------
> > Aug  7 20:56:42 i kernel: [  111.882896] WARNING: at fs/btrfs/inode.c:2408 btrfs_orphan_cleanup+0x1bf/0x2c0 [btrfs]()
> > Aug  7 20:56:42 i kernel: [  111.882903] Hardware name: GA-MA790GP-DS4H
> > Aug  7 20:56:42 i kernel: [  111.882907] Modules linked in: fuse ipt_MASQUERADE xt_state nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ppdev parport_pc lp parport bnep bluetooth k8temp it87 cpufreq_ondemand hwmon_vid powernow_k8 freq_table mperf arc4 rt73usb crc_itu_t rt2x00usb rt2x00lib mac80211 cfg80211 rfkill ftdi_sio snd_hda_codec_hdmi uvcvideo snd_hda_codec_realtek snd_hda_intel videodev snd_hda_codec snd_seq snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device media snd_pcm snd_timer snd soundcore v4l2_compat_ioctl32 sp5100_tco e100 snd_
 page_alloc i2c_piix4 k10temp edac_core edac_mce_amd r8169 shpchp mii serio_raw virtio_net kvm_amd kvm btrfs zlib_deflate libcrc32c pata_acpi ata_generic pata_atiixp wmi radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
> > Aug  7 20:56:42 i kernel: unloaded: scsi_wait_scan]
> > Aug  7 20:56:42 i kernel: [  111.883125] Pid: 1552, comm: ls Not tainted 2.6.40-4.fc15.x86_64 #1
> > Aug  7 20:56:42 i kernel: [  111.883135] Call Trace:
> 
> I've probably hit the same problem, though not apparent fs corruption
> happened. The partition is used as TEST_DIR for xfstests or fs_mark or
> ..., ie. the one not mkfs'ed and the files just pile. Until the free
> space goes out someday, which happened, and I can now reliably trigger
> the same warning in fs/btrfs/inode.c with some non-mainline patches.
> 
> This means chris' (for-linus) and josef's (for-chris) branches on top of
> linus-rc2 . On bare linus-rc2 the warning does not show.
> 
> 
> Following traces are from xfstests/083:
> 
> Initially, there is a bunch of
> 
> [  479.487424] Could not get space for a delete, will truncate on mount
>

Yeah I need to fix how we reserve space for truncates, this is working out worse
than I planned.
 
> and traces:
> 
> [  480.148082] ------------[ cut here ]------------
> [  480.153233] WARNING: at fs/btrfs/extent-tree.c:3885 btrfs_free_block_groups+0x2ac/0x320 [btrfs]()
> [  480.162656] Hardware name: Santa Rosa platform
> [  480.162660] Modules linked in: aoe btrfs
> [  480.162668] Pid: 5600, comm: umount Tainted: G        W 3.1.0-rc2-default+ #109
> [  480.162672] Call Trace:
> [  480.162683]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
> [  480.162689]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
> [  480.162708]  [<ffffffffa001f11c>] btrfs_free_block_groups+0x2ac/0x320 [btrfs]
> [  480.162729]  [<ffffffffa002aa99>] close_ctree+0x1e9/0x390 [btrfs]
> [  480.162736]  [<ffffffff811ae2cf>] ? dispose_list+0x4f/0x60
> [  480.162750]  [<ffffffffa000289d>] btrfs_put_super+0x1d/0x30 [btrfs]
> [  480.162757]  [<ffffffff811948c2>] generic_shutdown_super+0x62/0xe0
> [  480.162763]  [<ffffffff811949d6>] kill_anon_super+0x16/0x30
> [  480.162768]  [<ffffffff81195842>] ? deactivate_super+0x42/0x70
> [  480.162774]  [<ffffffff81194da5>] deactivate_locked_super+0x45/0x80
> [  480.162779]  [<ffffffff8119584a>] deactivate_super+0x4a/0x70
> [  480.162785]  [<ffffffff811b2d92>] mntput_no_expire+0xa2/0xf0
> [  480.162791]  [<ffffffff811b3aff>] sys_umount+0x6f/0x390
> [  480.162798]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b
> 
> [  480.162823] WARNING: at fs/btrfs/extent-tree.c:3886 btrfs_free_block_groups+0x31a/0x320 [btrfs]()
> [  480.162826] Hardware name: Santa Rosa platform
> [  480.162829] Modules linked in: aoe btrfs
> [  480.162836] Pid: 5600, comm: umount Tainted: G        W 3.1.0-rc2-default+ #109
> [  480.162839] Call Trace:
> [  480.162844]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
> [  480.162851]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
> [  480.162869]  [<ffffffffa001f18a>] btrfs_free_block_groups+0x31a/0x320 [btrfs]
> [  480.162889]  [<ffffffffa002aa99>] close_ctree+0x1e9/0x390 [btrfs]
> [  480.162895]  [<ffffffff811ae2cf>] ? dispose_list+0x4f/0x60
> [  480.162909]  [<ffffffffa000289d>] btrfs_put_super+0x1d/0x30 [btrfs]
> [  480.162915]  [<ffffffff811948c2>] generic_shutdown_super+0x62/0xe0
> [  480.162921]  [<ffffffff811949d6>] kill_anon_super+0x16/0x30
> [  480.162926]  [<ffffffff81195842>] ? deactivate_super+0x42/0x70
> [  480.162932]  [<ffffffff81194da5>] deactivate_locked_super+0x45/0x80
> [  480.162937]  [<ffffffff8119584a>] deactivate_super+0x4a/0x70
> [  480.162943]  [<ffffffff811b2d92>] mntput_no_expire+0xa2/0xf0
> [  480.162948]  [<ffffffff811b3aff>] sys_umount+0x6f/0x390
> [  480.162954]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b
> 
> 
> 3882 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
> 3883 {
> 3884         block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);
> 
> 3885         WARN_ON(fs_info->delalloc_block_rsv.size > 0);
> 3886         WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
> 
> 3887         WARN_ON(fs_info->trans_block_rsv.size > 0);
> 3888         WARN_ON(fs_info->trans_block_rsv.reserved > 0);
> 3889         WARN_ON(fs_info->chunk_block_rsv.size > 0);
> 3890         WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
> 3891 }
> 
> [  480.162978] WARNING: at fs/btrfs/extent-tree.c:6979 btrfs_free_block_groups+0x23b/0x320 [btrfs]()
> [  480.162982] Hardware name: Santa Rosa platform
> [  480.162984] Modules linked in: aoe btrfs
> [  480.162991] Pid: 5600, comm: umount Tainted: G        W   3.1.0-rc2-default+ #109
> [  480.162994] Call Trace:
> [  480.162999]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
> [  480.163004]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
> [  480.163022]  [<ffffffffa001f0ab>] btrfs_free_block_groups+0x23b/0x320 [btrfs]
> [  480.163043]  [<ffffffffa002aa99>] close_ctree+0x1e9/0x390 [btrfs]
> [  480.163048]  [<ffffffff811ae2cf>] ? dispose_list+0x4f/0x60
> [  480.163062]  [<ffffffffa000289d>] btrfs_put_super+0x1d/0x30 [btrfs]
> [  480.163068]  [<ffffffff811948c2>] generic_shutdown_super+0x62/0xe0
> [  480.163074]  [<ffffffff811949d6>] kill_anon_super+0x16/0x30
> [  480.163080]  [<ffffffff81195842>] ? deactivate_super+0x42/0x70
> [  480.163085]  [<ffffffff81194da5>] deactivate_locked_super+0x45/0x80
> [  480.163090]  [<ffffffff8119584a>] deactivate_super+0x4a/0x70
> [  480.163096]  [<ffffffff811b2d92>] mntput_no_expire+0xa2/0xf0
> [  480.163101]  [<ffffffff811b3aff>] sys_umount+0x6f/0x390
> [  480.163107]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b
> 
> 6972         while(!list_empty(&info->space_info)) {
> 6973                 space_info = list_entry(info->space_info.next,
> 6974                                         struct btrfs_space_info,
> 6975                                         list);
> 6976                 if (space_info->bytes_pinned > 0 ||
> 6977                     space_info->bytes_reserved > 0 ||
> 6978                     space_info->bytes_may_use > 0) {
> 6979                         WARN_ON(1);
> 6980                         dump_space_info(space_info, 0, 0);
> 6981                 }
> 6982                 list_del(&space_info->list);
> 6983                 kfree(space_info);
> 6984         }
> 
> dumped_space info:
> 
> [  480.163117] space_info 5 has 7184384 free, is full
> [  480.163121] space_info total=100663296, used=93413376, pinned=0, reserved=0, may_use=688128, readonly=65536
> 
> then according to the log, device is unmounted and then mounted again:
> 
> 
> [  603.456344] inode: i_nlink 1, mode 41471 ino 1086
> [  603.456346] ------------[ cut here ]------------
> [  603.456357] WARNING: at fs/btrfs/inode.c:2331 btrfs_orphan_cleanup+0x338/0x3b0 [btrfs]()
> [  603.456359] Hardware name: Santa Rosa platform
> [  603.456361] Modules linked in: aoe btrfs
> [  603.456364] Pid: 5609, comm: mount Tainted: G        W 3.1.0-rc2-default+ #109
> [  603.456366] Call Trace:
> [  603.456369]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
> [  603.456372]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
> [  603.456384]  [<ffffffffa0039588>] btrfs_orphan_cleanup+0x338/0x3b0 [btrfs]
> [  603.456396]  [<ffffffffa002c131>] open_ctree+0x14f1/0x17c0 [btrfs]
> [  603.456400]  [<ffffffff81201154>] ? disk_name+0x64/0xc0
> [  603.456408]  [<ffffffffa000583d>] btrfs_mount+0x4ed/0x640 [btrfs]
> [  603.456411]  [<ffffffff811b1881>] ? alloc_vfsmnt+0xa1/0x1b0
> [  603.456415]  [<ffffffff811961e0>] mount_fs+0x20/0xe0
> [  603.456418]  [<ffffffff811b1c03>] vfs_kern_mount+0x63/0xd0
> [  603.456421]  [<ffffffff811b2e64>] do_kern_mount+0x54/0x110
> [  603.456424]  [<ffffffff811b48dc>] do_mount+0x43c/0x7a0
> [  603.456428]  [<ffffffff811605bb>] ? strndup_user+0x5b/0x80
> [  603.456431]  [<ffffffff811b5038>] sys_mount+0x98/0xf0
> [  603.456435]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b
> [  603.456439] ---[ end trace 2d829307a763b904 ]---
> [  603.456298] BTRFS: inode 1086 still on the orphan list
> 
> <same btrfs_orphan_cleanup traces again and again>
> 
> 2328                 /* if we have links, this was a truncate, lets do that */
> 2329                 if (inode->i_nlink) {
> 2330                         if (!S_ISREG(inode->i_mode)) {
> 2331                                 WARN_ON(1);
> 2332                                 iput(inode);
> 2333                                 continue;
> 2334                         }
> 
> i've added a printk to print inode number of links and i_mode, seen in before
> the warning, ie:
> 
> [  603.456344] inode: i_nlink 1, mode 41471 ino 1086
> 
> mode = 41471 = 0xA1FF
> 
> deciphering from S_Ixxx macros, the mode value is masked with 0xF000, which
> gives 0xA == S_IFLNK .
> 
> So, it seems that the the file in question is a "slow" symlink, ie. it needs
> extra blocks to store the path. There are many such files left in a
> fsstress directory, dangling symlinks with 500+ bytes long path.
> 
> This proably results from a missed case where only S_ISREG is
> considered, while S_ISLNK should be handled as well. Also, there were
> warnings from block reservations, so these "slow" symlink block
> calculations may be incorrect too. (my speculations)
> 

Well we do not allow symlinks to be larger than what would fit inline, and 500
bytes is well within the allowed size.  But we should handle links as well since
they will need to have the inline extent removed.  Thanks,

Josef
