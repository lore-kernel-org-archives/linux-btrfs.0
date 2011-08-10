From: Ralph Loader <suckfish@ihug.co.nz>
Subject: Filesystem corrupt after renaming snapshots.
Date: Wed, 10 Aug 2011 20:38:59 +1200
Message-ID: <20110810203859.2e545ed1a3bee50207fb622f@ihug.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Recently I suffered from a badly corrupted btrfs filesystem.

I had several snapshots in /snap that I moved into / (using /bin/mv).  After that, attempting to access the ls the snapshot resulted in the ls process hanging.  There were syslog messages:

Aug  7 20:56:42 i kernel: [  111.882816] ------------[ cut here ]------------
Aug  7 20:56:42 i kernel: [  111.882896] WARNING: at fs/btrfs/inode.c:2408 btrfs_orphan_cleanup+0x1bf/0x2c0 [btrfs]()
Aug  7 20:56:42 i kernel: [  111.882903] Hardware name: GA-MA790GP-DS4H
Aug  7 20:56:42 i kernel: [  111.882907] Modules linked in: fuse ipt_MASQUERADE xt_state nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ppdev parport_pc lp parport bnep bluetooth k8temp it87 cpufreq_ondemand hwmon_vid powernow_k8 freq_table mperf arc4 rt73usb crc_itu_t rt2x00usb rt2x00lib mac80211 cfg80211 rfkill ftdi_sio snd_hda_codec_hdmi uvcvideo snd_hda_codec_realtek snd_hda_intel videodev snd_hda_codec snd_seq snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device media snd_pcm snd_timer snd soundcore v4l2_compat_ioctl32 sp5100_tco e100 snd_page
 _alloc i2c_piix4 k10temp edac_core edac_mce_amd r8169 shpchp mii serio_raw virtio_net kvm_amd kvm btrfs zlib_deflate libcrc32c pata_acpi ata_generic pata_atiixp wmi radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
Aug  7 20:56:42 i kernel: unloaded: scsi_wait_scan]
Aug  7 20:56:42 i kernel: [  111.883125] Pid: 1552, comm: ls Not tainted 2.6.40-4.fc15.x86_64 #1
Aug  7 20:56:42 i kernel: [  111.883135] Call Trace:
Aug  7 20:56:42 i kernel: [  111.883158]  [<ffffffff81054c8e>] warn_slowpath_common+0x83/0x9b
Aug  7 20:56:42 i kernel: [  111.883182]  [<ffffffff81054cc0>] warn_slowpath_null+0x1a/0x1c
Aug  7 20:56:42 i kernel: [  111.883246]  [<ffffffffa016aa55>] btrfs_orphan_cleanup+0x1bf/0x2c0 [btrfs]
Aug  7 20:56:42 i kernel: [  111.883311]  [<ffffffffa016aeac>] btrfs_lookup_dentry+0x356/0x38d [btrfs]
Aug  7 20:56:42 i kernel: [  111.883375]  [<ffffffffa016aef6>] btrfs_lookup+0x13/0x2a [btrfs]
Aug  7 20:56:42 i kernel: [  111.883398]  [<ffffffff8112f6ef>] d_alloc_and_lookup+0x45/0x6b
Aug  7 20:56:42 i kernel: [  111.883419]  [<ffffffff81130aab>] walk_component+0x206/0x3a9
Aug  7 20:56:42 i kernel: [  111.883439]  [<ffffffff8113114e>] lookup_last+0x3b/0x3d
Aug  7 20:56:42 i kernel: [  111.883458]  [<ffffffff811311d2>] path_lookupat+0x82/0x2af
Aug  7 20:56:42 i kernel: [  111.883480]  [<ffffffff81041325>] ? should_resched+0xe/0x2d
Aug  7 20:56:42 i kernel: [  111.883503]  [<ffffffff814b5abc>] ? _cond_resched+0xe/0x22
Aug  7 20:56:42 i kernel: [  111.883524]  [<ffffffff812401a1>] ? might_fault+0x21/0x23
Aug  7 20:56:42 i kernel: [  111.883545]  [<ffffffff8113cc96>] ? mntget+0x1c/0x22
Aug  7 20:56:42 i kernel: [  111.883563]  [<ffffffff81132256>] do_path_lookup+0x28/0x97
Aug  7 20:56:42 i kernel: [  111.883581]  [<ffffffff81132682>] user_path_at+0x59/0x96
Aug  7 20:56:42 i kernel: [  111.883601]  [<ffffffff8112feb2>] ? putname+0x34/0x36
Aug  7 20:56:42 i kernel: [  111.883618]  [<ffffffff81132690>] ? user_path_at+0x67/0x96
Aug  7 20:56:42 i kernel: [  111.883639]  [<ffffffff8112a659>] vfs_fstatat+0x44/0x6e
Aug  7 20:56:42 i kernel: [  111.883659]  [<ffffffff8112a6a1>] vfs_lstat+0x1e/0x20
Aug  7 20:56:42 i kernel: [  111.883677]  [<ffffffff8112a7f0>] sys_newlstat+0x1a/0x33
Aug  7 20:56:42 i kernel: [  111.883696]  [<ffffffff8113df1d>] ? mntput+0x26/0x28
Aug  7 20:56:42 i kernel: [  111.883713]  [<ffffffff8112f5e8>] ? path_put+0x20/0x24
Aug  7 20:56:42 i kernel: [  111.883732]  [<ffffffff81141743>] ? sys_getxattr+0x57/0x66
Aug  7 20:56:42 i kernel: [  111.883752]  [<ffffffff814bd7c2>] system_call_fastpath+0x16/0x1b
Aug  7 20:56:42 i kernel: [  111.883769] ---[ end trace d134844123cba413 ]---
Aug  7 20:56:42 i kernel: [  111.883803] ------------[ cut here ]------------


That was repeated a number of times, and then large volumes of apparent garbage in syslog:

Aug  7 20:56:42 i kernel: [  111.888566]  [<ffffffffa016aex38d [3/0x2alookup+0x45compokup_lokupad_resnd_res ? mig? mntgath_looku user_ putnamser_pa] vfs vfs
_] sysd>] ? path_puttr+0x57stem_call_fastpath+0x16/0x1b
Aug  7 20:56:42 i kernel: [  111.888737] ---[ end trace d134844123cba41c ]887pha4>[111dwae: P-D887es  ipe ncon23 conptpprof_nf_nnf_ nfnf_trarc ck_tp contp i
ptnatf_nonnk_i4 n_dev4 porpart bp both itreqnd vidnowfree mb c_t  ma021ll d_hdecdeoa_csndl vhdadecseqb_adiodepsnd snseqa ssndr sdcompaoctsp500_0 sallc_pix40
tere e_a9 s seirto_nvm_md ib_efl32cacp radeo<4>omm: ls Tainted: G        W  Call mmon+0x83/0x9b
Aug  7 20:56:42 i kernel: [  11c
Aug  7 20:56:42 i kernel: [  111.888876]  [<ffffffffa016aa55>fs]
Aug  7 20:56:42 i kernel: [  111.888889]  [<ffffffffa016aeax38d [3/0x2alookup+0xcompokup_lokupad_resnd_re ? mig? mntgeath_lookup+ user_ putname+ser_pat] vfs
 vfs_l] sysd>] ? path_ptr+0x5stem_call_fastpath+0x16/0x1b
Aug  7 20:56:42 i kernel: [  111.888949] ---[ end trace d134844123cba41d ]-889pha4>[111dwae: P-D889es  ipe ncon23 conptpprof_nf_nnf_ nfnf_trarc ck_tp contp 
iptnatf_nonnk_i4 n_dev4 porpart bp both itreqnd vidnowfree mb c_t  ma021ll d_hdecdeoa_csndl vhdadecseqb_adiodepsnd snseqa ssndr sdcompaoctsp500_0 sallc_pix4
0tere e_a9 s seirto_nvm_md ib_efl32cacp radeo<4>omm: ls Tainted: G        W    Call Tmmon+0x83/0x9b
Aug  7 20:56:42 i kernel: [  111c


I have a 480MB btrfs-image of the corrupted filesystem that I can upload somewhere if it is wanted.  (I only have 1mbps upstream, so would take a while...)

The corruption occurred while running Fedora kernel-3.0.0-3.fc16.x86_64, but attempting to access the filesystem with other kernel versions also resulted in ls hanging and syslog spew.

Cheers,
Ralph.
