From: Ralph Loader <suckfish@ihug.co.nz>
Subject: Locking backtrace
Date: Fri, 24 Dec 2010 20:43:41 +1300
Message-ID: <20101224204341.56fcec53.suckfish@ihug.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The following two stacktraces appeared in my syslog (are they of any use?).

The "possible recursive locking" occured around the end of untaring a 4gig tar ball.

I think the other one occurred during a 'yum upgrade'.

Cheers,
Ralph.


Dec 24 20:26:01 i kernel: [113505.458570] 
Dec 24 20:26:01 i kernel: [113505.458574] =============================================
Dec 24 20:26:01 i kernel: [113505.458584] [ INFO: possible recursive locking detected ]
Dec 24 20:26:01 i kernel: [113505.458592] 2.6.37-0.rc7.git0.1.fc15.x86_64 #1
Dec 24 20:26:01 i kernel: [113505.458599] ---------------------------------------------
Dec 24 20:26:01 i kernel: [113505.458606] firefox/4852 is trying to acquire lock:
Dec 24 20:26:01 i kernel: [113505.458613]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0161b89>] btrfs_try_spin_lock+0x2a/0x89 [btrfs]
Dec 24 20:26:01 i kernel: [113505.458680] 
Dec 24 20:26:01 i kernel: [113505.458683] but task is already holding lock:
Dec 24 20:26:01 i kernel: [113505.458689]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0161b56>] btrfs_clear_lock_blocking+0x22/0x2b [btrfs]
Dec 24 20:26:01 i kernel: [113505.458746] 
Dec 24 20:26:01 i kernel: [113505.458748] other info that might help us debug this:
Dec 24 20:26:01 i kernel: [113505.458755] 2 locks held by firefox/4852:
Dec 24 20:26:01 i kernel: [113505.458760]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff8113eee3>] do_last+0x1db/0x5bb
Dec 24 20:26:01 i kernel: [113505.458783]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0161b56>] btrfs_clear_lock_blocking+0x22/0x2b [btrfs]
Dec 24 20:26:01 i kernel: [113505.458839] 
Dec 24 20:26:01 i kernel: [113505.458841] stack backtrace:
Dec 24 20:26:01 i kernel: [113505.458849] Pid: 4852, comm: firefox Tainted: G        W   2.6.37-0.rc7.git0.1.fc15.x86_64 #1
Dec 24 20:26:01 i kernel: [113505.458856] Call Trace:
Dec 24 20:26:01 i kernel: [113505.458869]  [<ffffffff81082a4b>] __lock_acquire+0x945/0xd65
Dec 24 20:26:01 i kernel: [113505.458882]  [<ffffffff8101161c>] ? sched_clock+0x9/0xd
Dec 24 20:26:01 i kernel: [113505.458895]  [<ffffffff8107516d>] ? sched_clock_local+0x12/0x75
Dec 24 20:26:01 i kernel: [113505.458944]  [<ffffffffa0161b56>] ? btrfs_clear_lock_blocking+0x22/0x2b [btrfs]
Dec 24 20:26:01 i kernel: [113505.458994]  [<ffffffffa0161b89>] ? btrfs_try_spin_lock+0x2a/0x89 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459005]  [<ffffffff8108333a>] lock_acquire+0xc8/0xf3
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa0161b89>] ? btrfs_try_spin_lock+0x2a/0x89 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff814b491b>] _raw_spin_lock+0x36/0x69
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa0161b89>] ? btrfs_try_spin_lock+0x2a/0x89 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa0161b89>] btrfs_try_spin_lock+0x2a/0x89 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa0124388>] btrfs_search_slot+0x3e5/0x51e [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa0133715>] btrfs_lookup_inode+0x2f/0x92 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa0141b18>] btrfs_iget+0xb9/0x415 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa01421ce>] btrfs_lookup_dentry+0xff/0x3c6 [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff81083266>] ? lock_release+0x198/0x1a4
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffffa01424ab>] btrfs_lookup+0x16/0x2e [btrfs]
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8113c798>] d_alloc_and_lookup+0x4c/0x74
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8113c9a7>] __lookup_hash+0x8d/0x96
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8113c9c9>] lookup_hash+0x19/0x1b
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8113eeeb>] do_last+0x1e3/0x5bb
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff81257a5d>] ? __raw_spin_lock_init+0x31/0x50
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8113f4ec>] do_filp_open+0x229/0x5d9
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff81011611>] ? native_sched_clock+0x35/0x37
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8107533e>] ? local_clock+0x36/0x4d
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff81083266>] ? lock_release+0x198/0x1a4
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff81149a48>] ? alloc_fd+0x181/0x193
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff81132765>] do_sys_open+0x60/0xf6
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff814b468d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8113281b>] sys_open+0x20/0x22
Dec 24 20:26:01 i kernel: [113505.459012]  [<ffffffff8100ac82>] system_call_fastpath+0x16/0x1b




Dec 24 17:05:34 i kernel: [101478.939852] btrfs: unlinked 54 orphans
Dec 24 17:05:36 i kernel: [101480.382989] btrfs: unlinked 1 orphans
Dec 24 17:07:07 i kernel: [101572.158254] ------------[ cut here ]------------
Dec 24 17:07:07 i kernel: [101572.158263] WARNING: at kernel/lockdep.c:678 look_up_lock_class+0x9b/0xc4()
Dec 24 17:07:07 i kernel: [101572.158266] Hardware name: GA-MA790GP-DS4H
Dec 24 17:07:07 i kernel: [101572.158267] Modules linked in: ipt_MASQUERADE nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_tftp nf_connt
rack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat tcp_diag inet_diag sco bnep l2cap k8temp bluetooth it87 hwmon_vid cpufreq_ondemand 
powernow_k8 freq_table mperf snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_usb_audio snd_hda_codec arc4 ecb snd_usbmidi_lib snd_hwdep snd_seq e100 rt73usb crc_itu_t rt2x00usb rt2x00li
b snd_rawmidi uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 r8169 mac80211 snd_seq_device snd_pcm mii snd_timer i2c_piix4 snd edac_core cfg80211 rfkill snd_page_alloc edac_mce_amd shpchp serio
_raw microcode soundcore wmi k10temp kvm_amd kvm uinput ipv6 btrfs zlib_deflate libcrc32c pata_acpi ata_generic pata_atiixp radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi
_wait_scan]
Dec 24 17:07:07 i kernel: [101572.158326] Pid: 379, comm: btrfs-cleaner Not tainted 2.6.37-0.rc7.git0.1.fc15.x86_64 #1
Dec 24 17:07:07 i kernel: [101572.158328] Call Trace:
Dec 24 17:07:07 i kernel: [101572.158334]  [<ffffffff810533dc>] warn_slowpath_common+0x85/0x9d
Dec 24 17:07:07 i kernel: [101572.158338]  [<ffffffff8105340e>] warn_slowpath_null+0x1a/0x1c
Dec 24 17:07:07 i kernel: [101572.158341]  [<ffffffff8107fb86>] look_up_lock_class+0x9b/0xc4
Dec 24 17:07:07 i kernel: [101572.158344]  [<ffffffff8107fff7>] register_lock_class+0x1e/0x2e2
Dec 24 17:07:07 i kernel: [101572.158348]  [<ffffffff81011269>] ? paravirt_read_tsc+0x9/0xd
Dec 24 17:07:07 i kernel: [101572.158350]  [<ffffffff81011611>] ? native_sched_clock+0x35/0x37
Dec 24 17:07:07 i kernel: [101572.158353]  [<ffffffff8101161c>] ? sched_clock+0x9/0xd
Dec 24 17:07:07 i kernel: [101572.158356]  [<ffffffff810821ee>] __lock_acquire+0xe8/0xd65
Dec 24 17:07:07 i kernel: [101572.158359]  [<ffffffff81011269>] ? paravirt_read_tsc+0x9/0xd
Dec 24 17:07:07 i kernel: [101572.158361]  [<ffffffff81011269>] ? paravirt_read_tsc+0x9/0xd
Dec 24 17:07:07 i kernel: [101572.158363]  [<ffffffff81011611>] ? native_sched_clock+0x35/0x37
Dec 24 17:07:07 i kernel: [101572.158383]  [<ffffffffa0161c41>] ? btrfs_tree_lock+0x59/0xb8 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158386]  [<ffffffff8108333a>] lock_acquire+0xc8/0xf3
Dec 24 17:07:07 i kernel: [101572.158400]  [<ffffffffa0161c41>] ? btrfs_tree_lock+0x59/0xb8 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158404]  [<ffffffff8107533e>] ? local_clock+0x36/0x4d
Dec 24 17:07:07 i kernel: [101572.158408]  [<ffffffff814b491b>] _raw_spin_lock+0x36/0x69
Dec 24 17:07:07 i kernel: [101572.158421]  [<ffffffffa0161c41>] ? btrfs_tree_lock+0x59/0xb8 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158434]  [<ffffffffa0161c41>] btrfs_tree_lock+0x59/0xb8 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158447]  [<ffffffffa0161afe>] ? btrfs_wake_function+0x0/0x15 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158458]  [<ffffffffa012c461>] do_walk_down+0x103/0x39e [btrfs]
Dec 24 17:07:07 i kernel: [101572.158461]  [<ffffffff8107533e>] ? local_clock+0x36/0x4d
Dec 24 17:07:07 i kernel: [101572.158464]  [<ffffffff81083266>] ? lock_release+0x198/0x1a4
Dec 24 17:07:07 i kernel: [101572.158474]  [<ffffffffa012c784>] walk_down_tree+0x88/0xb2 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158485]  [<ffffffffa012e84e>] btrfs_drop_snapshot+0x2ae/0x456 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158488]  [<ffffffff814b388d>] ? __mutex_unlock_slowpath+0x11d/0x125
Dec 24 17:07:07 i kernel: [101572.158500]  [<ffffffffa0139fa3>] btrfs_clean_old_snapshots+0x10e/0x12b [btrfs]
Dec 24 17:07:07 i kernel: [101572.158511]  [<ffffffffa01345c0>] ? cleaner_kthread+0xd8/0x164 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158522]  [<ffffffffa01345d4>] cleaner_kthread+0xec/0x164 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158533]  [<ffffffffa01344e8>] ? cleaner_kthread+0x0/0x164 [btrfs]
Dec 24 17:07:07 i kernel: [101572.158537]  [<ffffffff8106f256>] kthread+0xa0/0xa8
Dec 24 17:07:07 i kernel: [101572.158540]  [<ffffffff81083759>] ? trace_hardirqs_on_caller+0x10b/0x12f
Dec 24 17:07:07 i kernel: [101572.158543]  [<ffffffff8100bb24>] kernel_thread_helper+0x4/0x10
Dec 24 17:07:07 i kernel: [101572.158546]  [<ffffffff814b5690>] ? restore_args+0x0/0x30
Dec 24 17:07:07 i kernel: [101572.158549]  [<ffffffff8106f1b6>] ? kthread+0x0/0xa8
Dec 24 17:07:07 i kernel: [101572.158552]  [<ffffffff8100bb20>] ? kernel_thread_helper+0x0/0x10
Dec 24 17:07:07 i kernel: [101572.158554] ---[ end trace c0cc2fba262037cf ]---
