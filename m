From: libor.klepac@bcom.cz
Subject: unable to mount with "parent transid verify failed on 140554240
 wanted 166764 found 166765"
Date: Mon, 13 Jun 2011 23:52:23 +0200
Message-ID: <53919e9fc9d2f0a5cf9e896393c78b2d@bcom.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Hi,
 i have had crash again today (running 2.6.39-2 from debian) - another 
 from i reported yesterday

 Jun 13 22:44:29 libor-fnb kernel: [132545.450965] ------------[ cut 
 here ]------------
 Jun 13 22:44:29 libor-fnb kernel: [132545.451009] kernel BUG at 
 /build/buildd-linux-2.6_2.6.39-2-amd64-kuqdRa/linux-2.6-2.6.39/debian/build/source_amd64_none/fs/btrfs/inode.
 c:780!
 Jun 13 22:44:29 libor-fnb kernel: [132545.451092] invalid opcode: 0000 
 [#1] SMP
 Jun 13 22:44:29 libor-fnb kernel: [132545.451127] last sysfs file: 
 /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
 Jun 13 22:44:29 libor-fnb kernel: [132545.451179] CPU 0
 Jun 13 22:44:29 libor-fnb kernel: [132545.451194] Modules linked in: 
 xfs md4 hmac cifs nls_utf8 nls_cp437 vfat fat uas tun usb_storage 
 vmnet(O) parport_pc vmblock(O) vsock(O
 ) vmci(O) vmmon(O) cryptd aes_x86_64 aes_generic acpi_cpufreq mperf 
 cpufreq_conservative cpufreq_userspace cpufreq_stats cpufreq_powersave 
 ppdev lp parport bnep rfcomm autof
 s4 binfmt_misc uinput ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core 
 ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse 
 microcode nfsd nfs lockd fscache aut
 h_rpcgss nfs_acl sunrpc btusb bluetooth ext2 usbhid hid dm_round_robin 
 dm_multipath scsi_dh coretemp loop firewire_sbp2 firewire_core crc_itu_t 
 uvcvideo videodev media v4l2_
 compat_ioctl32 raid1 md_mod joydev snd_hda_codec_realtek snd_hda_intel 
 snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi 
 arc4 snd_rawmidi ecb snd_seq_mi
 di_event snd_seq iwlagn option usb_wwan usbserial mac80211 dell_wmi 
 sparse_keymap snd_timer cfg80211 snd_seq_device uhci_hcd dell_laptop tg3 
 rfkill snd psmouse dcdba
 Jun 13 22:44:29 libor-fnb kernel: s ehci_hcd i2c_i801 serio_raw 
 soundcore pcspkr libphy snd_page_alloc usbcore evdev battery wmi ac 
 power_supply processor ext4 mbcache jbd2
 crc16 dm_mod btrfs zlib_deflate crc32c libcrc32c i915 sd_mod crc_t10dif 
 drm_kms_helper drm ahci libahci i2c_algo_bit libata i2c_core thermal 
 scsi_mod video button thermal_sy
 s [last unloaded: parport_pc]
 Jun 13 22:44:29 libor-fnb kernel: [132545.452421]
 Jun 13 22:44:29 libor-fnb kernel: [132545.452436] Pid: 1002, comm: 
 btrfs-transacti Tainted: G           O 2.6.39-2-amd64 #1 Dell Inc. 
 Latitude 13                     /067KDW
 Jun 13 22:44:29 libor-fnb kernel: [132545.452524] RIP: 
 0010:[<ffffffffa0174483>]  [<ffffffffa0174483>] 
 cow_file_range+0x57/0x31c [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.452615] RSP: 
 0018:ffff88011971f620  EFLAGS: 00010246
 Jun 13 22:44:29 libor-fnb kernel: [132545.452652] RAX: ffff8801185a0000 
 RBX: ffff8801191b1800 RCX: 000000000000ffff
 Jun 13 22:44:29 libor-fnb kernel: [132545.452700] RDX: ffff880107964450 
 RSI: ffffea00001671b0 RDI: ffff8801079645c8
 Jun 13 22:44:29 libor-fnb kernel: [132545.452748] RBP: 0000000000000000 
 R08: ffff88011971f96c R09: ffff88011971f950
 Jun 13 22:44:29 libor-fnb kernel: [132545.452797] R10: ffffffffffffffff 
 R11: 0000000000000000 R12: ffff8801079645c8
 Jun 13 22:44:29 libor-fnb kernel: [132545.452845] R13: ffff88011971f950 
 R14: ffff880107964430 R15: 0000000000010000
 Jun 13 22:44:29 libor-fnb kernel: [132545.452893] FS:  
 0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
 Jun 13 22:44:29 libor-fnb kernel: [132545.452946] CS:  0010 DS: 0000 
 ES: 0000 CR0: 000000008005003b
 Jun 13 22:44:29 libor-fnb kernel: [132545.452987] CR2: 00007f4eb3708000 
 CR3: 0000000001603000 CR4: 00000000000406f0
 Jun 13 22:44:29 libor-fnb kernel: [132545.453035] DR0: 0000000000000000 
 DR1: 0000000000000000 DR2: 0000000000000000
 Jun 13 22:44:29 libor-fnb kernel: [132545.453083] DR3: 0000000000000000 
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Jun 13 22:44:29 libor-fnb kernel: [132545.453133] Process 
 btrfs-transacti (pid: 1002, threadinfo ffff88011971e000, task 
 ffff880119180080)
 Jun 13 22:44:29 libor-fnb kernel: [132545.453191] Stack:
 Jun 13 22:44:29 libor-fnb kernel: [132545.453207]  ffff880000000000 
 00000000000008f8 0000000000000004 0000000f1d6c9fff
 Jun 13 22:44:29 libor-fnb kernel: [132545.453271]  ffff88011971f6c0 
 0000000f1d6ca000 000000000000ffff 00000000000000a0
 Jun 13 22:44:29 libor-fnb kernel: [132545.453335]  ffffffff00001000 
 ffff88011971f96c ffff880107964450 ffffea00001671b0
 Jun 13 22:44:29 libor-fnb kernel: [132545.453398] Call Trace:
 Jun 13 22:44:29 libor-fnb kernel: [132545.453444]  [<ffffffffa0174cda>] 
 ? run_delalloc_nocow+0x592/0x5e7 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453513]  [<ffffffffa0174da0>] 
 ? run_delalloc_range+0x71/0x32c [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453579]  [<ffffffffa018d2f5>] 
 ? find_lock_delalloc_range+0x19c/0x1be [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453648]  [<ffffffffa018d502>] 
 ? __extent_writepage+0x1eb/0x621 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453697]  [<ffffffff810b5ac8>] 
 ? find_get_pages_tag+0x69/0xdd
 Jun 13 22:44:29 libor-fnb kernel: [132545.453759]  [<ffffffffa018de22>] 
 ? T.1113+0x139/0x234 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453818]  [<ffffffffa018e00d>] 
 ? extent_writepages+0x40/0x57 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453886]  [<ffffffffa0175c46>] 
 ? uncompress_inline+0x125/0x125 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.453934]  [<ffffffff810b634e>] 
 ? __filemap_fdatawrite_range+0x48/0x4d
 Jun 13 22:44:29 libor-fnb kernel: [132545.453980]  [<ffffffff810b6867>] 
 ? filemap_write_and_wait+0x17/0x32
 Jun 13 22:44:29 libor-fnb kernel: [132545.454040]  [<ffffffffa019f08a>] 
 ? btrfs_write_out_cache+0x74d/0x96f [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454109]  [<ffffffffa0164f88>] 
 ? btrfs_run_delayed_refs+0xf4/0x16c [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454176]  [<ffffffffa01653d2>] 
 ? btrfs_write_dirty_block_groups+0x3d2/0x446 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454249]  [<ffffffffa016f622>] 
 ? commit_cowonly_roots+0xd8/0x19d [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454319]  [<ffffffffa017019b>] 
 ? btrfs_commit_transaction+0x378/0x676 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454372]  [<ffffffff8105f351>] 
 ? wake_up_bit+0x20/0x20
 Jun 13 22:44:29 libor-fnb kernel: [132545.454431]  [<ffffffffa01708cc>] 
 ? start_transaction+0x209/0x238 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454499]  [<ffffffffa016b5dd>] 
 ? transaction_kthread+0x178/0x232 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454566]  [<ffffffffa016b465>] 
 ? btrfs_bio_wq_end_io+0x62/0x62 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454635]  [<ffffffffa016b465>] 
 ? btrfs_bio_wq_end_io+0x62/0x62 [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.454875]  [<ffffffff8105ef05>] 
 ? kthread+0x7a/0x82
 Jun 13 22:44:29 libor-fnb kernel: [132545.454875]  [<ffffffff81339ee4>] 
 ? kernel_thread_helper+0x4/0x10
 Jun 13 22:44:29 libor-fnb kernel: [132545.454875]  [<ffffffff8105ee8b>] 
 ? kthread_worker_fn+0x147/0x147
 Jun 13 22:44:29 libor-fnb kernel: [132545.454875]  [<ffffffff81339ee0>] 
 ? gs_change+0x13/0x13
 Jun 13 22:44:29 libor-fnb kernel: [132545.464888] Code: 4c 24 30 4c 89 
 44 24 48 48 8b 9f 68 fe ff ff 8b 83 a0 02 00 00 48 89 54 24 50 89 44 24 
 40 48 8b 83 28 01 00 00 48 3b
 58 28 75 04 <0f> 0b eb fe be 01 00 00 00 48 89 df e8 8b c4 ff ff 48 3d 
 00 f0
 Jun 13 22:44:29 libor-fnb kernel: [132545.464888] RIP  
 [<ffffffffa0174483>] cow_file_range+0x57/0x31c [btrfs]
 Jun 13 22:44:29 libor-fnb kernel: [132545.464888]  RSP 
 <ffff88011971f620>
 Jun 13 22:44:29 libor-fnb kernel: [132545.591802] ---[ end trace 
 818ba76a36556366 ]---


 my filesystem doesn't want to mount. running btrfsck produces

 ./btrfsck /dev/md0
 parent transid verify failed on 140554240 wanted 166764 found 166765
 parent transid verify failed on 140554240 wanted 166764 found 166765
 parent transid verify failed on 140554240 wanted 166764 found 166765
 Segmentation fault

 ./btrfsck -s 1 /dev/md0
 using SB copy 1, bytenr 67108864
 parent transid verify failed on 140554240 wanted 166764 found 166765
 parent transid verify failed on 140554240 wanted 166764 found 166765
 parent transid verify failed on 140554240 wanted 166764 found 166765
 Segmentation fault

 ./btrfsck -s 2 /dev/md0
 using SB copy 2, bytenr 274877906944
 No valid Btrfs found on /dev/md0

 I have compiled btrfsck from 
 git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git

 Is there anything i can do?

 With regards
 Libor

 (sorry for formating, i'm using webmail, because i don't have /home 
 partition now)
