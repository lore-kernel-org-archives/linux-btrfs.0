From: David Sterba <dsterba@suse.cz>
Subject: Re: Filesystem corrupt after renaming snapshots.
Date: Thu, 18 Aug 2011 19:53:46 +0200
Message-ID: <20110818175346.GD16820@ds.suse.cz>
References: <20110810203859.2e545ed1a3bee50207fb622f@ihug.co.nz>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Ralph Loader <suckfish@ihug.co.nz>
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110810203859.2e545ed1a3bee50207fb622f@ihug.co.nz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Aug 10, 2011 at 08:38:59PM +1200, Ralph Loader wrote:
> Hi,
> 
> Recently I suffered from a badly corrupted btrfs filesystem.
> 
> I had several snapshots in /snap that I moved into / (using /bin/mv).
> After that, attempting to access the ls the snapshot resulted in the
> ls process hanging.  There were syslog messages:
> 
> Aug  7 20:56:42 i kernel: [  111.882816] ------------[ cut here ]------------
> Aug  7 20:56:42 i kernel: [  111.882896] WARNING: at fs/btrfs/inode.c:2408 btrfs_orphan_cleanup+0x1bf/0x2c0 [btrfs]()
> Aug  7 20:56:42 i kernel: [  111.882903] Hardware name: GA-MA790GP-DS4H
> Aug  7 20:56:42 i kernel: [  111.882907] Modules linked in: fuse ipt_MASQUERADE xt_state nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ppdev parport_pc lp parport bnep bluetooth k8temp it87 cpufreq_ondemand hwmon_vid powernow_k8 freq_table mperf arc4 rt73usb crc_itu_t rt2x00usb rt2x00lib mac80211 cfg80211 rfkill ftdi_sio snd_hda_codec_hdmi uvcvideo snd_hda_codec_realtek snd_hda_intel videodev snd_hda_codec snd_seq snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device media snd_pcm snd_timer snd soundcore v4l2_compat_ioctl32 sp5100_tco e100 snd_pa
 ge_alloc i2c_piix4 k10temp edac_core edac_mce_amd r8169 shpchp mii serio_raw virtio_net kvm_amd kvm btrfs zlib_deflate libcrc32c pata_acpi ata_generic pata_atiixp wmi radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
> Aug  7 20:56:42 i kernel: unloaded: scsi_wait_scan]
> Aug  7 20:56:42 i kernel: [  111.883125] Pid: 1552, comm: ls Not tainted 2.6.40-4.fc15.x86_64 #1
> Aug  7 20:56:42 i kernel: [  111.883135] Call Trace:

I've probably hit the same problem, though not apparent fs corruption
happened. The partition is used as TEST_DIR for xfstests or fs_mark or
..., ie. the one not mkfs'ed and the files just pile. Until the free
space goes out someday, which happened, and I can now reliably trigger
the same warning in fs/btrfs/inode.c with some non-mainline patches.

This means chris' (for-linus) and josef's (for-chris) branches on top of
linus-rc2 . On bare linus-rc2 the warning does not show.


Following traces are from xfstests/083:

Initially, there is a bunch of

[  479.487424] Could not get space for a delete, will truncate on mount

and traces:

[  480.148082] ------------[ cut here ]------------
[  480.153233] WARNING: at fs/btrfs/extent-tree.c:3885 btrfs_free_block_groups+0x2ac/0x320 [btrfs]()
[  480.162656] Hardware name: Santa Rosa platform
[  480.162660] Modules linked in: aoe btrfs
[  480.162668] Pid: 5600, comm: umount Tainted: G        W 3.1.0-rc2-default+ #109
[  480.162672] Call Trace:
[  480.162683]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
[  480.162689]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
[  480.162708]  [<ffffffffa001f11c>] btrfs_free_block_groups+0x2ac/0x320 [btrfs]
[  480.162729]  [<ffffffffa002aa99>] close_ctree+0x1e9/0x390 [btrfs]
[  480.162736]  [<ffffffff811ae2cf>] ? dispose_list+0x4f/0x60
[  480.162750]  [<ffffffffa000289d>] btrfs_put_super+0x1d/0x30 [btrfs]
[  480.162757]  [<ffffffff811948c2>] generic_shutdown_super+0x62/0xe0
[  480.162763]  [<ffffffff811949d6>] kill_anon_super+0x16/0x30
[  480.162768]  [<ffffffff81195842>] ? deactivate_super+0x42/0x70
[  480.162774]  [<ffffffff81194da5>] deactivate_locked_super+0x45/0x80
[  480.162779]  [<ffffffff8119584a>] deactivate_super+0x4a/0x70
[  480.162785]  [<ffffffff811b2d92>] mntput_no_expire+0xa2/0xf0
[  480.162791]  [<ffffffff811b3aff>] sys_umount+0x6f/0x390
[  480.162798]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b

[  480.162823] WARNING: at fs/btrfs/extent-tree.c:3886 btrfs_free_block_groups+0x31a/0x320 [btrfs]()
[  480.162826] Hardware name: Santa Rosa platform
[  480.162829] Modules linked in: aoe btrfs
[  480.162836] Pid: 5600, comm: umount Tainted: G        W 3.1.0-rc2-default+ #109
[  480.162839] Call Trace:
[  480.162844]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
[  480.162851]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
[  480.162869]  [<ffffffffa001f18a>] btrfs_free_block_groups+0x31a/0x320 [btrfs]
[  480.162889]  [<ffffffffa002aa99>] close_ctree+0x1e9/0x390 [btrfs]
[  480.162895]  [<ffffffff811ae2cf>] ? dispose_list+0x4f/0x60
[  480.162909]  [<ffffffffa000289d>] btrfs_put_super+0x1d/0x30 [btrfs]
[  480.162915]  [<ffffffff811948c2>] generic_shutdown_super+0x62/0xe0
[  480.162921]  [<ffffffff811949d6>] kill_anon_super+0x16/0x30
[  480.162926]  [<ffffffff81195842>] ? deactivate_super+0x42/0x70
[  480.162932]  [<ffffffff81194da5>] deactivate_locked_super+0x45/0x80
[  480.162937]  [<ffffffff8119584a>] deactivate_super+0x4a/0x70
[  480.162943]  [<ffffffff811b2d92>] mntput_no_expire+0xa2/0xf0
[  480.162948]  [<ffffffff811b3aff>] sys_umount+0x6f/0x390
[  480.162954]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b


3882 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
3883 {
3884         block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);

3885         WARN_ON(fs_info->delalloc_block_rsv.size > 0);
3886         WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);

3887         WARN_ON(fs_info->trans_block_rsv.size > 0);
3888         WARN_ON(fs_info->trans_block_rsv.reserved > 0);
3889         WARN_ON(fs_info->chunk_block_rsv.size > 0);
3890         WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
3891 }

[  480.162978] WARNING: at fs/btrfs/extent-tree.c:6979 btrfs_free_block_groups+0x23b/0x320 [btrfs]()
[  480.162982] Hardware name: Santa Rosa platform
[  480.162984] Modules linked in: aoe btrfs
[  480.162991] Pid: 5600, comm: umount Tainted: G        W   3.1.0-rc2-default+ #109
[  480.162994] Call Trace:
[  480.162999]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
[  480.163004]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
[  480.163022]  [<ffffffffa001f0ab>] btrfs_free_block_groups+0x23b/0x320 [btrfs]
[  480.163043]  [<ffffffffa002aa99>] close_ctree+0x1e9/0x390 [btrfs]
[  480.163048]  [<ffffffff811ae2cf>] ? dispose_list+0x4f/0x60
[  480.163062]  [<ffffffffa000289d>] btrfs_put_super+0x1d/0x30 [btrfs]
[  480.163068]  [<ffffffff811948c2>] generic_shutdown_super+0x62/0xe0
[  480.163074]  [<ffffffff811949d6>] kill_anon_super+0x16/0x30
[  480.163080]  [<ffffffff81195842>] ? deactivate_super+0x42/0x70
[  480.163085]  [<ffffffff81194da5>] deactivate_locked_super+0x45/0x80
[  480.163090]  [<ffffffff8119584a>] deactivate_super+0x4a/0x70
[  480.163096]  [<ffffffff811b2d92>] mntput_no_expire+0xa2/0xf0
[  480.163101]  [<ffffffff811b3aff>] sys_umount+0x6f/0x390
[  480.163107]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b

6972         while(!list_empty(&info->space_info)) {
6973                 space_info = list_entry(info->space_info.next,
6974                                         struct btrfs_space_info,
6975                                         list);
6976                 if (space_info->bytes_pinned > 0 ||
6977                     space_info->bytes_reserved > 0 ||
6978                     space_info->bytes_may_use > 0) {
6979                         WARN_ON(1);
6980                         dump_space_info(space_info, 0, 0);
6981                 }
6982                 list_del(&space_info->list);
6983                 kfree(space_info);
6984         }

dumped_space info:

[  480.163117] space_info 5 has 7184384 free, is full
[  480.163121] space_info total=100663296, used=93413376, pinned=0, reserved=0, may_use=688128, readonly=65536

then according to the log, device is unmounted and then mounted again:


[  603.456344] inode: i_nlink 1, mode 41471 ino 1086
[  603.456346] ------------[ cut here ]------------
[  603.456357] WARNING: at fs/btrfs/inode.c:2331 btrfs_orphan_cleanup+0x338/0x3b0 [btrfs]()
[  603.456359] Hardware name: Santa Rosa platform
[  603.456361] Modules linked in: aoe btrfs
[  603.456364] Pid: 5609, comm: mount Tainted: G        W 3.1.0-rc2-default+ #109
[  603.456366] Call Trace:
[  603.456369]  [<ffffffff8109e37f>] warn_slowpath_common+0x7f/0xc0
[  603.456372]  [<ffffffff8109e3da>] warn_slowpath_null+0x1a/0x20
[  603.456384]  [<ffffffffa0039588>] btrfs_orphan_cleanup+0x338/0x3b0 [btrfs]
[  603.456396]  [<ffffffffa002c131>] open_ctree+0x14f1/0x17c0 [btrfs]
[  603.456400]  [<ffffffff81201154>] ? disk_name+0x64/0xc0
[  603.456408]  [<ffffffffa000583d>] btrfs_mount+0x4ed/0x640 [btrfs]
[  603.456411]  [<ffffffff811b1881>] ? alloc_vfsmnt+0xa1/0x1b0
[  603.456415]  [<ffffffff811961e0>] mount_fs+0x20/0xe0
[  603.456418]  [<ffffffff811b1c03>] vfs_kern_mount+0x63/0xd0
[  603.456421]  [<ffffffff811b2e64>] do_kern_mount+0x54/0x110
[  603.456424]  [<ffffffff811b48dc>] do_mount+0x43c/0x7a0
[  603.456428]  [<ffffffff811605bb>] ? strndup_user+0x5b/0x80
[  603.456431]  [<ffffffff811b5038>] sys_mount+0x98/0xf0
[  603.456435]  [<ffffffff81b97682>] system_call_fastpath+0x16/0x1b
[  603.456439] ---[ end trace 2d829307a763b904 ]---
[  603.456298] BTRFS: inode 1086 still on the orphan list

<same btrfs_orphan_cleanup traces again and again>

2328                 /* if we have links, this was a truncate, lets do that */
2329                 if (inode->i_nlink) {
2330                         if (!S_ISREG(inode->i_mode)) {
2331                                 WARN_ON(1);
2332                                 iput(inode);
2333                                 continue;
2334                         }

i've added a printk to print inode number of links and i_mode, seen in before
the warning, ie:

[  603.456344] inode: i_nlink 1, mode 41471 ino 1086

mode = 41471 = 0xA1FF

deciphering from S_Ixxx macros, the mode value is masked with 0xF000, which
gives 0xA == S_IFLNK .

So, it seems that the the file in question is a "slow" symlink, ie. it needs
extra blocks to store the path. There are many such files left in a
fsstress directory, dangling symlinks with 500+ bytes long path.

This proably results from a missed case where only S_ISREG is
considered, while S_ISLNK should be handled as well. Also, there were
warnings from block reservations, so these "slow" symlink block
calculations may be incorrect too. (my speculations)

I'll leave the partition untouched for testing, as I'm not sure I can
recreate the same conditions again. (Ralf offered image of his fs too)

david




> Aug  7 20:56:42 i kernel: [  111.883158]  [<ffffffff81054c8e>] warn_slowpath_common+0x83/0x9b
> Aug  7 20:56:42 i kernel: [  111.883182]  [<ffffffff81054cc0>] warn_slowpath_null+0x1a/0x1c
> Aug  7 20:56:42 i kernel: [  111.883246]  [<ffffffffa016aa55>] btrfs_orphan_cleanup+0x1bf/0x2c0 [btrfs]
> Aug  7 20:56:42 i kernel: [  111.883311]  [<ffffffffa016aeac>] btrfs_lookup_dentry+0x356/0x38d [btrfs]
> Aug  7 20:56:42 i kernel: [  111.883375]  [<ffffffffa016aef6>] btrfs_lookup+0x13/0x2a [btrfs]
> Aug  7 20:56:42 i kernel: [  111.883398]  [<ffffffff8112f6ef>] d_alloc_and_lookup+0x45/0x6b
> Aug  7 20:56:42 i kernel: [  111.883419]  [<ffffffff81130aab>] walk_component+0x206/0x3a9
> Aug  7 20:56:42 i kernel: [  111.883439]  [<ffffffff8113114e>] lookup_last+0x3b/0x3d
> Aug  7 20:56:42 i kernel: [  111.883458]  [<ffffffff811311d2>] path_lookupat+0x82/0x2af
> Aug  7 20:56:42 i kernel: [  111.883480]  [<ffffffff81041325>] ? should_resched+0xe/0x2d
> Aug  7 20:56:42 i kernel: [  111.883503]  [<ffffffff814b5abc>] ? _cond_resched+0xe/0x22
> Aug  7 20:56:42 i kernel: [  111.883524]  [<ffffffff812401a1>] ? might_fault+0x21/0x23
> Aug  7 20:56:42 i kernel: [  111.883545]  [<ffffffff8113cc96>] ? mntget+0x1c/0x22
> Aug  7 20:56:42 i kernel: [  111.883563]  [<ffffffff81132256>] do_path_lookup+0x28/0x97
> Aug  7 20:56:42 i kernel: [  111.883581]  [<ffffffff81132682>] user_path_at+0x59/0x96
> Aug  7 20:56:42 i kernel: [  111.883601]  [<ffffffff8112feb2>] ? putname+0x34/0x36
> Aug  7 20:56:42 i kernel: [  111.883618]  [<ffffffff81132690>] ? user_path_at+0x67/0x96
> Aug  7 20:56:42 i kernel: [  111.883639]  [<ffffffff8112a659>] vfs_fstatat+0x44/0x6e
> Aug  7 20:56:42 i kernel: [  111.883659]  [<ffffffff8112a6a1>] vfs_lstat+0x1e/0x20
> Aug  7 20:56:42 i kernel: [  111.883677]  [<ffffffff8112a7f0>] sys_newlstat+0x1a/0x33
> Aug  7 20:56:42 i kernel: [  111.883696]  [<ffffffff8113df1d>] ? mntput+0x26/0x28
> Aug  7 20:56:42 i kernel: [  111.883713]  [<ffffffff8112f5e8>] ? path_put+0x20/0x24
> Aug  7 20:56:42 i kernel: [  111.883732]  [<ffffffff81141743>] ? sys_getxattr+0x57/0x66
> Aug  7 20:56:42 i kernel: [  111.883752]  [<ffffffff814bd7c2>] system_call_fastpath+0x16/0x1b
> Aug  7 20:56:42 i kernel: [  111.883769] ---[ end trace d134844123cba413 ]---
> Aug  7 20:56:42 i kernel: [  111.883803] ------------[ cut here ]------------
> 
> 
> That was repeated a number of times, and then large volumes of apparent garbage in syslog:
> 
> Aug  7 20:56:42 i kernel: [  111.888566]  [<ffffffffa016aex38d [3/0x2alookup+0x45compokup_lokupad_resnd_res ? mig? mntgath_looku user_ putnamser_pa] vfs vfs
> _] sysd>] ? path_puttr+0x57stem_call_fastpath+0x16/0x1b
> Aug  7 20:56:42 i kernel: [  111.888737] ---[ end trace d134844123cba41c ]887pha4>[111dwae: P-D887es  ipe ncon23 conptpprof_nf_nnf_ nfnf_trarc ck_tp contp i
> ptnatf_nonnk_i4 n_dev4 porpart bp both itreqnd vidnowfree mb c_t  ma021ll d_hdecdeoa_csndl vhdadecseqb_adiodepsnd snseqa ssndr sdcompaoctsp500_0 sallc_pix40
> tere e_a9 s seirto_nvm_md ib_efl32cacp radeo<4>omm: ls Tainted: G        W  Call mmon+0x83/0x9b
> Aug  7 20:56:42 i kernel: [  11c
> Aug  7 20:56:42 i kernel: [  111.888876]  [<ffffffffa016aa55>fs]
> Aug  7 20:56:42 i kernel: [  111.888889]  [<ffffffffa016aeax38d [3/0x2alookup+0xcompokup_lokupad_resnd_re ? mig? mntgeath_lookup+ user_ putname+ser_pat] vfs
>  vfs_l] sysd>] ? path_ptr+0x5stem_call_fastpath+0x16/0x1b
> Aug  7 20:56:42 i kernel: [  111.888949] ---[ end trace d134844123cba41d ]-889pha4>[111dwae: P-D889es  ipe ncon23 conptpprof_nf_nnf_ nfnf_trarc ck_tp contp 
> iptnatf_nonnk_i4 n_dev4 porpart bp both itreqnd vidnowfree mb c_t  ma021ll d_hdecdeoa_csndl vhdadecseqb_adiodepsnd snseqa ssndr sdcompaoctsp500_0 sallc_pix4
> 0tere e_a9 s seirto_nvm_md ib_efl32cacp radeo<4>omm: ls Tainted: G        W    Call Tmmon+0x83/0x9b
> Aug  7 20:56:42 i kernel: [  111c
> 
> 
> I have a 480MB btrfs-image of the corrupted filesystem that I can upload somewhere if it is wanted.  (I only have 1mbps upstream, so would take a while...)
> 
> The corruption occurred while running Fedora kernel-3.0.0-3.fc16.x86_64, but attempting to access the filesystem with other kernel versions also resulted in ls hanging and syslog spew.
> 
> Cheers,
> Ralph.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
