From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: status of raid10 reliability
Date: Thu, 17 Nov 2011 17:09:25 +0000 (UTC)
Message-ID: <slrnjcafu5.fao.stephane.chazelas@spam.is.invalid>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

Before setting up a new RAID10 btrfs array with 6 drives, I
wanted to check how good it behaved in case of disk failure.
I've not been too impressed. Is RAID10 btrfs support only
meant for reading performance improvement?

My test method was:

Use the device-mapper to have devices mapped (linear) to loop
devices

zsh syntax:

# l=({1..4})
# mv /dev/loop$^l .
# truncate -s1T $l
# s=$(blockdev --getsize /dev/loop1)
# for f ($l) losetup loop$f $f
# for f ($l) echo 0 $s linear loop$f 0 | dmsetup create hd$f
# mkfs.btrfs -m raid10 -d raid10 /dev/mapper/hd$^l
# d=(device=/dev/mapper/hd$^l)
# mount -o ${(j:,:)d} /dev/mapper/hd1 /mnt/3

Then write some data, and then use DM's error target to simulate
a failing drive (all I/O ends up in error):

# dmsetup suspend hd3; echo 0 $s error | dmsetup reload hd3; dmsetup resume hd3

Then write some more data. The FS doesn't become degraded
automatically. If I restore the drive:

# echo 0 $s linear loop3 0 | dmsetup create hd3

More funny things occur of course as btrfs doesn't seem to have
registered it being broken.

If I do a scrub with the failing drive, it "BUGs ON":

[13960.286464] ------------[ cut here ]------------
[13960.286484] kernel BUG at /home/blank/debian/kernel/release/linux-2.6/linux-2.6-3.1.0/debian/build/source_amd64_none/fs/btrfs/volumes.c:2891!
[13960.286496] invalid opcode: 0000 [#1] SMP
[13960.286507] CPU 0
[13960.286510] Modules linked in: vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ip6table_filter ip6_tables ebtable_nat acpi_cpufreq mperf ebtables cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parport rfcomm bnep binfmt_misc uinput deflate ctr twofish_generic twofish_x86_64 twofish_common camellia serpent blowfish cast5 des_generic cbc xcbc rmd160 sha512_generic sha256_generic sha1_generic hmac crypto_null af_key fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dm_crypt coretemp loop kvm_intel kvm uvcvideo bcm5974 videodev media v4l2_compat_ioctl32 cryptd snd_hda_code
 c_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm aes_x86_64 aes_generic snd_seq_midi ecb btusb bluetooth rfkill snd_rawmidi nouveau ttm snd_seq_midi_event drm_kms_helper snd_seq drm i2c_algo_bit mxm_wmi snd_timer wmi snd_seq_device joydev video battery snd ac apple_bl power_supply soundcore snd_page_alloc applesmc pcspkr input_polldev i2c_i801 i2c_core evdev button processor thermal_sys ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod nbd dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom crc_t10dif hid_apple usbhid hid ata_generic uhci_hcd firewire_ohci sata_sil24 ata_piix firewire_core crc_itu_t libata sky2 ehc
 i_hcd scsi_mod usbcore [last unloaded: scsi_wait_scan]
[13960.287012]
[13960.287016] Pid: 12681, comm: btrfs-scrub-0 Tainted: G        W  O 3.1.0-1-amd64 #1 Apple Inc. MacBookPro4,1/Mac-F42C86C8
[13960.287037] RIP: 0010:[<ffffffffa020fc8a>]  [<ffffffffa020fc8a>] __btrfs_map_block+0xfd/0x629 [btrfs]
[13960.287061] RSP: 0018:ffff880078c87cb0  EFLAGS: 00010282
[13960.287067] RAX: 0000000000000042 RBX: ffff880078c87d68 RCX: 00000000000054ee
[13960.287076] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000246
[13960.287085] RBP: ffff8800378f6380 R08: 0000000000000002 R09: 00000000fffffffe
[13960.287093] R10: 0000000000000001 R11: ffff88007e395c90 R12: 0000000000000000
[13960.287102] R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000001
[13960.287114] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[13960.287126] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[13960.287136] CR2: 00000000f76990a0 CR3: 0000000104319000 CR4: 00000000000006f0
[13960.287147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[13960.287159] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[13960.287169] Process btrfs-scrub-0 (pid: 12681, threadinfo ffff880078c86000, task ffff880021698280)
[13960.287184] Stack:
[13960.287189]  0000000000000000 ffff880100000001 0000004000000000 ffff88008a1f40f8
[13960.287207]  ffff88008a1f4100 ffff880078c87d60 0000000000000001 0000000000000001
[13960.287223]  ffff880078c87cf0 ffff880109671000 ffff880123416400 0000000000000000
[13960.287242] Call Trace:
[13960.287259]  [<ffffffffa022aa1f>] ? scrub_recheck_error+0x105/0x29b [btrfs]
[13960.287280]  [<ffffffffa022ac2a>] ? scrub_checksum+0x75/0x372 [btrfs]
[13960.287288]  [<ffffffff810394c7>] ? check_preempt_wakeup+0x122/0x18b
[13960.287297]  [<ffffffff81036e0c>] ? set_next_entity+0x32/0x52
[13960.287304]  [<ffffffff8100d031>] ? load_gs_index+0x7/0xa
[13960.287312]  [<ffffffff8100d6a8>] ? __switch_to+0x15a/0x20e
[13960.287331]  [<ffffffffa02141f1>] ? worker_loop+0x16a/0x45d [btrfs]
[13960.287341]  [<ffffffff8132bcd4>] ? __schedule+0x5ac/0x5c3
[13960.287360]  [<ffffffffa0214087>] ? btrfs_queue_worker+0x25b/0x25b [btrfs]
[13960.287371]  [<ffffffff8105e5f5>] ? kthread+0x76/0x7e
[13960.287379]  [<ffffffff81334134>] ? kernel_thread_helper+0x4/0x10
[13960.287388]  [<ffffffff8105e57f>] ? kthread_worker_fn+0x139/0x139
[13960.287395]  [<ffffffff81334130>] ? gs_change+0x13/0x13
[13960.287403] Code: 7c 24 20 48 89 04 24 e8 29 ea ff ff 48 8b 0c 24 48 85 c9 75 18 48 8b 13 48 8b 74 24 10 48 c7 c7 0c 63 23 a0 31 c0 e8 a8 6f 11 e1 <0f> 0b 48 8b 41 18 48 3b 44 24 10 77 0f 4c 8b 49 20 49 8d 14 01
[13960.287595] RIP  [<ffffffffa020fc8a>] __btrfs_map_block+0xfd/0x629 [btrfs]
[13960.287618]  RSP <ffff880078c87cb0>
[13960.305670] ---[ end trace 99b51efe6d872029 ]---

In which way has btrfs raid10 been tested? For reliability,
should we stick with md raid for now, or btrfs raid0 on md
raid1?


How would one go about replacing a failing drive without
unmounting the FS?

Other things I've seen in dmesg:

[11859.945412] btrfs_readpage_end_io_hook: 9614 callbacks suppressed
[11859.945417] btrfs csum failed ino 257 off 0 csum 2566472073 private 397849880
[11859.945451] btrfs csum failed ino 257 off 4096 csum 2566472073 private 2631731436
[11859.945481] btrfs csum failed ino 257 off 8192 csum 2566472073 private 2640556530
[11859.945513] btrfs csum failed ino 257 off 12288 csum 2566472073 private 27602266
[11859.945544] btrfs csum failed ino 257 off 16384 csum 2566472073 private 321745155
[11859.945570] btrfs csum failed ino 257 off 8192 csum 2566472073 private 2640556530
[11859.945574] btrfs csum failed ino 257 off 20480 csum 2566472073 private 1458484598
[11859.945605] btrfs csum failed ino 257 off 12288 csum 2566472073 private 27602266
[11859.945611] btrfs csum failed ino 257 off 24576 csum 2566472073 private 2602336016
[11859.945642] btrfs csum failed ino 257 off 28672 csum 2566472073 private 1915815056
[11882.115754] btrfs_readpage_end_io_hook: 23 callbacks suppressed
[11882.115757] btrfs csum failed ino 257 off 12288 csum 2566472073 private 27602266
[11882.115775] btrfs csum failed ino 257 off 16384 csum 2566472073 private 321745155
[11882.115790] btrfs csum failed ino 257 off 20480 csum 2566472073 private 1458484598
[11882.115806] btrfs csum failed ino 257 off 24576 csum 2566472073 private 2602336016
[11882.115823] btrfs csum failed ino 257 off 28672 csum 2566472073 private 1915815056
[11882.115839] btrfs csum failed ino 257 off 32768 csum 2566472073 private 1866379989
[11882.115854] btrfs csum failed ino 257 off 36864 csum 2566472073 private 2312891658
[11882.115869] btrfs csum failed ino 257 off 40960 csum 2566472073 private 3982095500
[11882.115912] btrfs csum failed ino 257 off 0 csum 2566472073 private 397849880
[11882.115933] btrfs csum failed ino 257 off 4096 csum 2566472073 private 2631731436
[...]
[13769.913828] Buffer I/O error on device dm-8, logical block 268435440
[13769.913835] Buffer I/O error on device dm-8, logical block 268435440
[13769.913843] Buffer I/O error on device dm-8, logical block 268435454
[13769.913847] Buffer I/O error on device dm-8, logical block 268435454
[13769.913854] Buffer I/O error on device dm-8, logical block 0
[13769.913858] Buffer I/O error on device dm-8, logical block 0
[13769.913865] Buffer I/O error on device dm-8, logical block 1
[13769.913871] Buffer I/O error on device dm-8, logical block 268435455
[13769.913966] Buffer I/O error on device dm-8, logical block 268435455
[13769.913971] Buffer I/O error on device dm-8, logical block 268435455
[13792.465869] btrfs_end_buffer_write_sync: 2 callbacks suppressed
[13792.465873] lost page write due to I/O error on dm-8
[13792.465891] lost page write due to I/O error on dm-8
[13792.465908] lost page write due to I/O error on dm-8
[13801.762573] btrfs: unable to go below four devices on raid10
[13883.465898] ioctl32(btrfs:12629): Unknown cmd fd(3) cmd(5000940b){t:ffffff94;sz:4096} arg(ffc4d1cc) on /home/stephane/install/cvs/btrfs-progs-unstable-mason
[13960.286090] scrub_fixup: 138 callbacks suppressed
[13960.286093] btrfs: unable to fixup at 65536
[13960.286135] ------------[ cut here ]------------
[13960.286195] WARNING: at /home/blank/debian/kernel/release/linux-2.6/linux-2.6-3.1.0/debian/build/source_amd64_none/fs/btrfs/scrub.c:236 scrub_fixup_check+0xab/0xc1 [btrfs]()
[13960.286198] Hardware name: MacBookPro4,1
[13960.286199] Modules linked in: vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ip6table_filter ip6_tables ebtable_nat acpi_cpufreq mperf ebtables cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parport rfcomm bnep binfmt_misc uinput deflate ctr twofish_generic twofish_x86_64 twofish_common camellia serpent blowfish cast5 des_generic cbc xcbc rmd160 sha512_generic sha256_generic sha1_generic hmac crypto_null af_key fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dm_crypt coretemp loop kvm_intel kvm uvcvideo bcm5974 videodev media v4l2_compat_ioctl32 cryptd snd_hda_code
 c_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm aes_x86_64 aes_generic snd_seq_midi ecb btusb bluetooth rfkill snd_rawmidi nouveau ttm snd_seq_midi_event drm_kms_helper snd_seq drm i2c_algo_bit mxm_wmi snd_timer wmi snd_seq_device joydev video battery snd ac apple_bl power_supply soundcore snd_page_alloc applesmc pcspkr input_polldev i2c_i801 i2c_core evdev button processor thermal_sys ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod nbd dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom crc_t10dif hid_apple usbhid hid ata_generic uhci_hcd firewire_ohci sata_sil24 ata_piix firewire_core crc_itu_t libata sky2 ehc
 i_hcd scsi_mod usbcore [last unloaded: scsi_wait_scan]
[13960.286299] Pid: 12681, comm: btrfs-scrub-0 Tainted: G           O 3.1.0-1-amd64 #1
[13960.286302] Call Trace:
[13960.286310]  [<ffffffff81045795>] ? warn_slowpath_common+0x78/0x8c
[13960.286323]  [<ffffffffa022a904>] ? scrub_fixup_check+0xab/0xc1 [btrfs]
[13960.286337]  [<ffffffffa022aaca>] ? scrub_recheck_error+0x1b0/0x29b [btrfs]
[13960.286350]  [<ffffffffa022ac2a>] ? scrub_checksum+0x75/0x372 [btrfs]
[13960.286354]  [<ffffffff810394c7>] ? check_preempt_wakeup+0x122/0x18b
[13960.286357]  [<ffffffff81036e0c>] ? set_next_entity+0x32/0x52
[13960.286362]  [<ffffffff8100d031>] ? load_gs_index+0x7/0xa
[13960.286365]  [<ffffffff8100d6a8>] ? __switch_to+0x15a/0x20e
[13960.286379]  [<ffffffffa02141f1>] ? worker_loop+0x16a/0x45d [btrfs]
[13960.286384]  [<ffffffff8132bcd4>] ? __schedule+0x5ac/0x5c3
[13960.286399]  [<ffffffffa0214087>] ? btrfs_queue_worker+0x25b/0x25b [btrfs]
[13960.286403]  [<ffffffff8105e5f5>] ? kthread+0x76/0x7e
[13960.286408]  [<ffffffff81334134>] ? kernel_thread_helper+0x4/0x10
[13960.286411]  [<ffffffff8105e57f>] ? kthread_worker_fn+0x139/0x139
[13960.286414]  [<ffffffff81334130>] ? gs_change+0x13/0x13
[13960.286416] ---[ end trace 99b51efe6d872028 ]---
[13960.286418] btrfs: unable to fixup at 67108864
[13960.286425] unable to find logical 274877906944 len 4096

regards,
Stephane

