From: Ralph Loader <suckfish@ihug.co.nz>
Subject: Ooops mounting non existant subvolume.
Date: Sat, 23 Oct 2010 10:42:56 +1300
Message-ID: <20101023104256.4a256f6d.suckfish@ihug.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

If I attempt to mount a non-existant subvolume, e.g.,

mount -o subvol=1 /dev/sda6 /mnt

then I get an an oops (see end of message).

/dev/sda6 is my root filesystem, 'btrfs sub list /' gives

ID 331 top level 5 path snap/rawhide
ID 341 top level 5 path snap/20101014
ID 342 top level 5 path snap/20101016
ID 343 top level 5 path snap/20101020

subvol 343 is set as the default subvolume.

Cheers,
Ralph.

PS.  What I'm actually trying to achieve is get back to the original subvolume I had before I did a 'btrfs subvol set-default', is there any way of doing that?



[  463.981331] device label btr_root devid 1 transid 208372 /dev/sda6
[  475.254561] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d0
[  475.254574] IP: [<ffffffff8113ab35>] bio_get_nr_vecs+0x10/0x3a
[  475.254591] PGD 205cff067 PUD 205d02067 PMD 0 
[  475.254602] Oops: 0000 [#1] SMP 
[  475.254609] last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host3/target3:0:0/3:0:0:0/block/sda/sda5/stat
[  475.254618] CPU 3 
[  475.254621] Modules linked in: k8temp it87 hwmon_vid ipv6 cpufreq_ondemand powernow_k8 freq_table mperf kvm_amd kvm uinput arc4 ecb snd_hda_codec_atihdmi rt73usb r8169 ipheth snd_hda_codec_realtek crc_itu_t snd_usb_audio snd_hda_intel snd_hda_codec serio_raw rt2x00usb wmi rt2x00lib shpchp e100 snd_seq snd_pcm uvcvideo videodev snd_hwdep v4l1_compat v4l2_compat_ioctl32 snd_timer mii mac80211 snd_usbmidi_lib snd_rawmidi snd_seq_device snd microcode soundcore edac_core edac_mce_amd cfg80211 k10temp i2c_piix4 snd_page_alloc rfkill btrfs zlib_deflate libcrc32c pata_acpi ata_generic pata_atiixp radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[  475.254724] 
[  475.254733] Pid: 418, comm: btrfs-transacti Not tainted 2.6.35.6-43.fc14.x86_64 #1 GA-MA790GP-DS4H/GA-MA790GP-DS4H
[  475.254741] RIP: 0010:[<ffffffff8113ab35>]  [<ffffffff8113ab35>] bio_get_nr_vecs+0x10/0x3a
[  475.254754] RSP: 0018:ffff88021b54fa60  EFLAGS: 00010246
[  475.254760] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000100
[  475.254766] RDX: ffffea00071cd9a8 RSI: ffff88021bac4030 RDI: ffff8802278296c0
[  475.254773] RBP: ffff88021b54fa60 R08: 0000000000001000 R09: 0000000000000000
[  475.254779] R10: ffff8802278296c0 R11: ffff88021b54fcbc R12: 0000000000001000
[  475.254786] R13: ffff88021b54fc30 R14: 0000000000000000 R15: 000000000705ad10
[  475.254794] FS:  00007f6c0c59f980(0000) GS:ffff880002180000(0000) knlGS:00000000f4c7eb70
[  475.254801] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  475.254807] CR2: 00000000000002d0 CR3: 0000000205ca7000 CR4: 00000000000006e0
[  475.254813] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  475.254820] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  475.254827] Process btrfs-transacti (pid: 418, threadinfo ffff88021b54e000, task ffff88021b1e1740)
[  475.254833] Stack:
[  475.254836]  ffff88021b54fad0 ffffffffa01482d0 ffffea00071cd9a8 ffff88021bac42a0
[  475.254846] <0> ffff88021bac4030 00000441810da44c 0000000000000000 ffffea00071cd9a8
[  475.254856] <0> ffff88021b54fad0 ffffea00071cd9a8 0000000e0b5a2000 ffff88021bac4030
[  475.254868] Call Trace:
[  475.254920]  [<ffffffffa01482d0>] submit_extent_page.clone.16+0xfc/0x1bd [btrfs]
[  475.254966]  [<ffffffffa014acc2>] __extent_writepage+0x507/0x55f [btrfs]
[  475.255009]  [<ffffffffa0148f9c>] ? end_bio_extent_writepage+0x0/0x15f [btrfs]
[  475.255052]  [<ffffffffa014b092>] extent_write_full_page+0x88/0xb7 [btrfs]
[  475.255087]  [<ffffffffa012a89d>] ? btree_get_extent+0x0/0x181 [btrfs]
[  475.255097]  [<ffffffff810e6c2e>] ? dec_zone_page_state+0x0/0x36
[  475.255132]  [<ffffffffa012c57b>] btree_writepage+0x4f/0xef [btrfs]
[  475.255141]  [<ffffffff810da628>] write_one_page+0x77/0xbb
[  475.255181]  [<ffffffffa01563f1>] ? btrfs_wake_function+0x0/0x15 [btrfs]
[  475.255219]  [<ffffffffa012f814>] btrfs_write_marked_extents+0xe2/0x11e [btrfs]
[  475.255256]  [<ffffffffa012f982>] btrfs_write_and_wait_marked_extents+0x1e/0x41 [btrfs]
[  475.255292]  [<ffffffffa012f9ec>] btrfs_write_and_wait_transaction+0x47/0x49 [btrfs]
[  475.255329]  [<ffffffffa012ffad>] btrfs_commit_transaction+0x4ef/0x5e6 [btrfs]
[  475.255339]  [<ffffffff810663c3>] ? autoremove_wake_function+0x0/0x39
[  475.255373]  [<ffffffffa012b268>] transaction_kthread+0x170/0x225 [btrfs]
[  475.255380]  [<ffffffffa012b0f8>] ? transaction_kthread+0x0/0x225 [btrfs]
[  475.255380]  [<ffffffff81065f29>] kthread+0x7f/0x87
[  475.255380]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
[  475.255380]  [<ffffffff81065eaa>] ? kthread+0x0/0x87
[  475.255380]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
[  475.255380] Code: c9 c3 55 48 89 e5 0f 1f 44 00 00 f0 ff 0f 0f 94 c0 84 c0 c9 0f 95 c0 0f b6 c0 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 87 98 00 00 00 <48> 8b 88 d0 02 00 00 8b 81 8c 04 00 00 0f b7 91 b2 04 00 00 c9 
[  475.255380] RIP  [<ffffffff8113ab35>] bio_get_nr_vecs+0x10/0x3a
[  475.255380]  RSP <ffff88021b54fa60>
[  475.255380] CR2: 00000000000002d0
[  475.255564] ---[ end trace 9116819b3f146cc9 ]---
