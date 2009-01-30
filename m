From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Subject: report, kernel BUG at fs/btrfs/extent-tree.c:3106
Date: Fri, 30 Jan 2009 14:35:28 +0900
Message-ID: <20090130143528.2069bf78.ytakahashi@miraclelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I create many files on btrfs of 16GB partition.
may 13,000,000 files.
I get this report.

I think about the following fix.
When there is not space, return of ENOSPC.
Or add lock in free extents.

Best regards,
-- 


kernel: btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
kernel: btrfs allocation failed flags 36, wanted 4096
kernel: space_info has 65536 free, is full
kernel: block group 29360128 has 1073741824 bytes, 1034362880 used 39313408 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 2176843776 has 859111424 bytes, 826671104 used 32440320 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 3035955200 has 859111424 bytes, 821129216 used 37982208 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 3895066624 has 859111424 bytes, 831062016 used 28049408 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 4754178048 has 859111424 bytes, 839311360 used 19800064 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 5613289472 has 859111424 bytes, 840081408 used 19030016 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: ------------[ cut here ]------------
kernel: invalid opcode: 0000 [#1] SMP
kernel: last sysfs file: /sys/class/bdi/7:7/power/wakeup
kernel: block group 6472400896 has 859111424 bytes, 841170944 used 17940480 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 7331512320 has 859111424 bytes, 840855552 used 18255872 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: block group 8190623744 has 859111424 bytes, 850055168 used 9056256 pinned 0 reserved
kernel: 0 blocks of free space at or bigger than bytes is
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/btrfs/extent-tree.c:3106!
kernel: invalid opcode: 0000 [#1] SMP
kernel: last sysfs file: /sys/class/bdi/7:7/power/wakeup
kernel: CPU 2
kernel: Modules linked in: loop btrfs zlib_deflate vfat fat ipv6 cpufreq_powersave firewire_ohci firewire_core crc_itu_t dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbshc button battery acpi_memhotplug ac ehci_hcd ohci_hcd k8temp hwmon amd_rng i2c_amd8111 i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc tg3 libphy floppy ide_cd_mod cdrom ext3 jbd sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod [last unloaded: x_tables]
kernel: Pid: 6258, comm: mkfbmt Tainted: G   M       2.6.29-rc3 #1
kernel: RIP: 0010:[<ffffffffa0455ed0>]  [<ffffffffa0455ed0>] __btrfs_reserve_extent+0x28c/0x2a1 [btrfs]
kernel: RSP: 0018:ffff8801191651a8  EFLAGS: 00010246
kernel: RAX: ffff88012ed3fb28 RBX: ffff880019d19180 RCX: 00000000ffffffff
kernel: RDX: 0000000000007575 RSI: 0000000000000246 RDI: ffff88012ed3fb24
kernel: RBP: ffff880119165218 R08: 00000000ffffffff R09: 0000000000000000
kernel: R10: ffffffff8087b6a0 R11: ffff8801191650a8 R12: ffff88012ed3fb08
kernel: R13: ffff88012ed3fac0 R14: 0000000000001000 R15: ffff8800b758bdb8
kernel: FS:  00007f4b4040e6e0(0000) GS:ffff88012ec7a5c0(0000) knlGS:00000000f7f6b6c0
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 00000000004bc540 CR3: 000000010026e000 CR4: 00000000000006e0
kernel: Stack:
kernel:  ffff880100000024 00000002176b8000 00000001c0000000 0000000000000000
kernel:  0000000000001000 ffff8801191652b8 ffff880123cbb800 0000000000000002
kernel: Call Trace:
kernel:  [<ffffffffa0456401>] btrfs_alloc_extent+0x47/0x9f [btrfs]
kernel:  [<ffffffffa04565a3>] btrfs_alloc_free_block+0x5c/0x86 [btrfs]
kernel:  [<ffffffffa0448269>] __btrfs_cow_block+0x1f9/0x84e [btrfs]
kernel:  [<ffffffffa0479ce8>] ? test_range_bit+0x49/0xe2 [btrfs]
kernel:  [<ffffffffa0448abc>] btrfs_cow_block+0x1fe/0x20d [btrfs]
kernel:  [<ffffffffa044e431>] btrfs_search_slot+0x355/0x805 [btrfs]
kernel:  [<ffffffffa0478ab3>] ? free_extent_state+0x6d/0x72 [btrfs]
kernel:  [<ffffffffa045166c>] lookup_extent_backref+0x3d/0xe2 [btrfs]
kernel:  [<ffffffffa0447bf4>] ? btrfs_release_path+0x47/0x5f [btrfs]
kernel:  [<ffffffffa0453b3e>] free_extents+0xc8/0x705 [btrfs]
kernel:  [<ffffffffa0478ab3>] ? free_extent_state+0x6d/0x72 [btrfs]
kernel:  [<ffffffffa04790e5>] ? clear_extent_bit+0x1c0/0x1f2 [btrfs]
kernel:  [<ffffffffa045441c>] del_pending_extents+0x2a1/0x2e5 [btrfs]
kernel:  [<ffffffffa0454dda>] __btrfs_inc_extent_ref+0x1cb/0x1e4 [btrfs]
kernel:  [<ffffffffa0474a77>] ? btrfs_key_blockptr+0xbd/0xcb [btrfs]
kernel:  [<ffffffffa0452c0e>] btrfs_inc_ref+0x36e/0x3e4 [btrfs]
kernel:  [<ffffffffa0454c0f>] ? __btrfs_inc_extent_ref+0x0/0x1e4 [btrfs]
kernel:  [<ffffffffa047d822>] ? copy_extent_buffer+0x124/0x154 [btrfs]
kernel:  [<ffffffffa04484bc>] __btrfs_cow_block+0x44c/0x84e [btrfs]
kernel:  [<ffffffffa047d3fb>] ? map_extent_buffer+0x92/0xd8 [btrfs]
kernel:  [<ffffffffa0448abc>] btrfs_cow_block+0x1fe/0x20d [btrfs]
kernel:  [<ffffffffa044e431>] btrfs_search_slot+0x355/0x805 [btrfs]
kernel:  [<ffffffffa0449173>] ? generic_bin_search+0x1a6/0x1bd [btrfs]
kernel:  [<ffffffffa0485127>] ? btrfs_tree_unlock+0xd/0x11 [btrfs]
kernel:  [<ffffffffa044e95e>] btrfs_insert_empty_items+0x7d/0x4bd [btrfs]
kernel:  [<ffffffffa044e8b1>] ? btrfs_search_slot+0x7d5/0x805 [btrfs]
kernel:  [<ffffffff8033494a>] ? chksum_update+0x10/0x18
kernel:  [<ffffffff8033121a>] ? crypto_shash_update+0x7f/0x9b
kernel:  [<ffffffff80331227>] ? crypto_shash_update+0x8c/0x9b
kernel:  [<ffffffffa045ca1c>] insert_with_overflow+0x34/0x101 [btrfs]
kernel:  [<ffffffffa045cb85>] btrfs_insert_dir_item+0x9c/0x286 [btrfs]
kernel:  [<ffffffffa0447c2f>] ? btrfs_free_path+0x23/0x28 [btrfs]
kernel:  [<ffffffffa0469708>] btrfs_add_link+0x76/0xf4 [btrfs]
kernel:  [<ffffffffa04697bb>] btrfs_add_nondir+0x35/0x5b [btrfs]
kernel:  [<ffffffffa0469acc>] btrfs_create+0x121/0x1e9 [btrfs]
kernel:  [<ffffffff802b0a2c>] vfs_create+0xdb/0x14a
kernel:  [<ffffffff802b0f1b>] do_filp_open+0x242/0x805
kernel:  [<ffffffff80250bb2>] ? enqueue_hrtimer+0x68/0x75
kernel:  [<ffffffff802bbb80>] ? mntput_no_expire+0x22/0x12b
kernel:  [<ffffffff8034d02c>] ? __strncpy_from_user+0x18/0x42
kernel:  [<ffffffff802bac8f>] ? alloc_fd+0x64/0xff
kernel:  [<ffffffff802a750d>] do_sys_open+0x51/0xd2
kernel:  [<ffffffff802a75a9>] sys_open+0x1b/0x1d
kernel:  [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
kernel: Code: 48 ff ff ff e8 86 6f de df 4c 89 f6 48 89 df e8 95 53 03 00 41 fe 84 24 74 ff ff ff 4d 8b 24 24 eb 96 49 8d 7d 60 e8 1a b4 df df <0f> 0b eb fe 48 83 c4 48 89 c8 5b 41 5c 41 5d 41 5e 41 5f c9 c3
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process mkfbmt (pid: 6258, threadinfo ffff880119164000, task ffff88012ce70fa0)
kernel: Stack:
kernel:  00000001c0000000 ffff8801191652b8 0000000000000000 0000000000000000
kernel:  ffff880100000024 00000002176b8000 00000001c0000000 0000000000000000
kernel:  0000000000001000 ffff8801191652b8 ffff880123cbb800 0000000000000002
kernel: Call Trace:
kernel:  [<ffffffffa0456401>] btrfs_alloc_extent+0x47/0x9f [btrfs]
kernel:  [<ffffffffa04565a3>] btrfs_alloc_free_block+0x5c/0x86 [btrfs]
kernel:  [<ffffffffa0448269>] __btrfs_cow_block+0x1f9/0x84e [btrfs]
kernel:  [<ffffffffa0479ce8>] ? test_range_bit+0x49/0xe2 [btrfs]
kernel:  [<ffffffffa0448abc>] btrfs_cow_block+0x1fe/0x20d [btrfs]
kernel:  [<ffffffffa044e431>] btrfs_search_slot+0x355/0x805 [btrfs]
kernel:  [<ffffffffa0478ab3>] ? free_extent_state+0x6d/0x72 [btrfs]
kernel:  [<ffffffffa045166c>] lookup_extent_backref+0x3d/0xe2 [btrfs]
kernel:  [<ffffffffa0447bf4>] ? btrfs_release_path+0x47/0x5f [btrfs]
kernel:  [<ffffffffa0453b3e>] free_extents+0xc8/0x705 [btrfs]
kernel:  [<ffffffffa0478ab3>] ? free_extent_state+0x6d/0x72 [btrfs]
kernel:  [<ffffffffa04790e5>] ? clear_extent_bit+0x1c0/0x1f2 [btrfs]
kernel:  [<ffffffffa045441c>] del_pending_extents+0x2a1/0x2e5 [btrfs]
kernel:  [<ffffffffa0454dda>] __btrfs_inc_extent_ref+0x1cb/0x1e4 [btrfs]
kernel:  [<ffffffffa0474a77>] ? btrfs_key_blockptr+0xbd/0xcb [btrfs]
kernel:  [<ffffffffa0452c0e>] btrfs_inc_ref+0x36e/0x3e4 [btrfs]
kernel:  [<ffffffffa0454c0f>] ? __btrfs_inc_extent_ref+0x0/0x1e4 [btrfs]
kernel:  [<ffffffffa047d822>] ? copy_extent_buffer+0x124/0x154 [btrfs]
kernel:  [<ffffffffa04484bc>] __btrfs_cow_block+0x44c/0x84e [btrfs]
kernel:  [<ffffffffa047d3fb>] ? map_extent_buffer+0x92/0xd8 [btrfs]
kernel:  [<ffffffffa0448abc>] btrfs_cow_block+0x1fe/0x20d [btrfs]
kernel:  [<ffffffffa044e431>] btrfs_search_slot+0x355/0x805 [btrfs]
kernel:  [<ffffffffa0449173>] ? generic_bin_search+0x1a6/0x1bd [btrfs]
kernel:  [<ffffffffa0485127>] ? btrfs_tree_unlock+0xd/0x11 [btrfs]
kernel:  [<ffffffffa044e95e>] btrfs_insert_empty_items+0x7d/0x4bd [btrfs]
kernel:  [<ffffffffa044e8b1>] ? btrfs_search_slot+0x7d5/0x805 [btrfs]
kernel:  [<ffffffff8033494a>] ? chksum_update+0x10/0x18
kernel:  [<ffffffff8033121a>] ? crypto_shash_update+0x7f/0x9b
kernel:  [<ffffffff80331227>] ? crypto_shash_update+0x8c/0x9b
kernel:  [<ffffffffa045ca1c>] insert_with_overflow+0x34/0x101 [btrfs]
kernel:  [<ffffffffa045cb85>] btrfs_insert_dir_item+0x9c/0x286 [btrfs]
kernel:  [<ffffffffa0447c2f>] ? btrfs_free_path+0x23/0x28 [btrfs]
kernel:  [<ffffffffa0469708>] btrfs_add_link+0x76/0xf4 [btrfs]
kernel:  [<ffffffffa04697bb>] btrfs_add_nondir+0x35/0x5b [btrfs]
kernel:  [<ffffffffa0469acc>] btrfs_create+0x121/0x1e9 [btrfs]
kernel:  [<ffffffff802b0a2c>] vfs_create+0xdb/0x14a
kernel:  [<ffffffff802b0f1b>] do_filp_open+0x242/0x805
kernel:  [<ffffffff80250bb2>] ? enqueue_hrtimer+0x68/0x75
kernel:  [<ffffffff802bbb80>] ? mntput_no_expire+0x22/0x12b
kernel:  [<ffffffff8034d02c>] ? __strncpy_from_user+0x18/0x42
kernel:  [<ffffffff802bac8f>] ? alloc_fd+0x64/0xff
kernel:  [<ffffffff802a750d>] do_sys_open+0x51/0xd2
kernel:  [<ffffffff802a75a9>] sys_open+0x1b/0x1d
kernel:  [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
kernel: Code: 48 ff ff ff e8 86 6f de df 4c 89 f6 48 89 df e8 95 53 03 00 41 fe 84 24 74 ff ff ff 4d 8b 24 24 eb 96 49 8d 7d 60 e8 1a b4 df df <0f> 0b eb fe 48 83 c4 48 89 c8 5b 41 5c 41 5d 41 5e 41 5f c9 c3
kernel: RIP  [<ffffffffa0455ed0>] __btrfs_reserve_extent+0x28c/0x2a1 [btrfs]
kernel:  RSP <ffff8801191651a8>
kernel: ---[ end trace 8ed7045dcebac288 ]---


# btrfs-show /dev/sda2
failed to read /dev/hdc
Label: none  uuid: 4f60b320-c71f-4508-a715-xxxxxxxxxxxx
        Total devices 1 FS bytes used 7.19GB
        devid    1 size 16.00GB used 15.84GB path /dev/sda2

# btrfsck /dev/sda2
found 7719591936 bytes used err is 0
total csum bytes: 4264
total tree bytes: 7715225600
btree space waste bytes: 679367157
file data blocks allocated: 6463488
 referenced 4362240
Btrfs Btrfs v0.18
