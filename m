From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: [DEBUG PATCH] for anybody who gets a panic due to ENOSPC
Date: Wed, 19 Nov 2008 11:45:35 -0500
Message-ID: <20081119164535.GA22904@tux64-01>
References: <4922214A.5090904@cs.drexel.edu> <20081118163007.GA1425@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081118163007.GA1425@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry it took so long to reply it took awhile to run this test. It
didn't cause a kernel panic for about 8 hours. df says only 623M of the
available 7539M are used. Anyway this is with the latest checkin by Chris Mason with the patch you sent me.

Also since you said you cann't reproduce this I thought it might be
helpful to know the environment I'm doing testing on. I have been
running bonnie++ on xubuntu 8.10 fully updated on vmware 6.5. No vmware
tools are instead except for the mouse and video xorg drivers which come by
default with ubuntu. I have two 8G prealloced virtual drives. The first
one is where the xubuntu install is using ext2 for /boot and / and has a
512M swap partition. The second one is where I do all of the btrfs testing. 
I have it partitioned because I was experimenting with booting with btrfs 
as root so the partition btrfs is on has 7539M. The VM has 512M of RAM
dedicated to it and is using one core of my Intel Core 2 Duo T7500
running at 2.2GHz.

Lee

...
[ 7133.346381] block_group 5167120384 didn't have what we needed. 790429696 total, 383414272 used, 407011328 pinned, 4096 reserved. Dumping free space
[ 7133.346385] 0 blocks of free space at or bigger than bytes is
[ 7133.346388] block_group 5957550080 didn't have what we needed. 790429696 total, 1011712 used, 789413888 pinned, 4096 reserved. Dumping free space
[ 7133.346391] 0 blocks of free space at or bigger than bytes is
[ 7133.346394] block_group 6747979776 didn't have what we needed. 752943104 total, 125444096 used, 627499008 pinned, 0 reserved. Dumping free space
[ 7133.346397] 0 blocks of free space at or bigger than bytes is
[ 7133.346400] we were searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
[ 7133.346403] allocation failed flags 1, wanted 4096
[ 7133.346405] space_info has 1064009728 free, is full
[ 7133.346408] block group 12582912 has 8388608 bytes, 516096 used 7872512 pinned 0 reserved
[ 7133.346410] 0 blocks of free space at or bigger than bytes is
[ 7133.346413] block group 424542208 has 790429696 bytes, 2105344 used 788324352 pinned 0 reserved
[ 7133.346416] offset=1214971904, bytes=274759680
[ 7133.346417] 1 blocks of free space at or bigger than bytes is
[ 7133.346420] block group 1214971904 has 790429696 bytes, 3964928 used 511705088 pinned 0 reserved
[ 7133.346423] 0 blocks of free space at or bigger than bytes is
[ 7133.346425] block group 2005401600 has 790429696 bytes, 1490944 used 788938752 pinned 0 reserved
[ 7133.346428] offset=2795831296, bytes=789250048
[ 7133.346430] 1 blocks of free space at or bigger than bytes is
[ 7133.346432] block group 2795831296 has 790429696 bytes, 1179648 used 0 pinned 0 reserved
[ 7133.346435] 0 blocks of free space at or bigger than bytes is
[ 7133.346438] block group 3586260992 has 790429696 bytes, 1392640 used 789037056 pinned 0 reserved
[ 7133.346440] 0 blocks of free space at or bigger than bytes is
[ 7133.346443] block group 4376690688 has 790429696 bytes, 128237568 used 662192128 pinned 0 reserved
[ 7133.346445] 0 blocks of free space at or bigger than bytes is
[ 7133.346448] block group 5167120384 has 790429696 bytes, 383414272 used 407011328 pinned 4096 reserved
[ 7133.346451] 0 blocks of free space at or bigger than bytes is
[ 7133.346453] block group 5957550080 has 790429696 bytes, 1011712 used 789413888 pinned 4096 reserved
[ 7133.346456] 0 blocks of free space at or bigger than bytes is
[ 7133.346458] block group 6747979776 has 752943104 bytes, 125444096 used 627499008 pinned 0 reserved
[ 7133.346461] 0 blocks of free space at or bigger than bytes is
[ 7133.346490] ------------[ cut here ]------------
[ 7133.346493] kernel BUG at /home/ltrager/btrfs/btrfs-unstable-standalone/extent-tree.c:3101!
[ 7133.346499] invalid opcode: 0000 [#309] SMP 
[ 7133.346502] Modules linked in: btrfs zlib_deflate libcrc32c ipv6 af_packet bridge stp rfcomm bnep sco l2cap bluetooth ppdev cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot battery iptable_filter ip_tables x_tables lp evdev psmouse serio_raw pcspkr snd_ens1371 gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc parport_pc parport i2c_piix4 i2c_core container ac intel_agp button shpchp pci_hotplug agpgart ext2 mbcache sr_mod cdrom sd_mod crc_t10dif pata_acpi sg ata_piix uhci_hcd ehci_hcd usbcore ata_generic pcnet32 mii mptspi mptscsih mptbase scsi_transport_s
 pi libata scsi_mod dock thermal processor fan fbcon tileblit font bitblit softcursor fuse
[ 7133.346570] 
[ 7133.346573] Pid: 6575, comm: bonnie++ Tainted: G      D   (2.6.27-7-generic #1)
[ 7133.346576] EIP: 0060:[<e0d3944a>] EFLAGS: 00210257 CPU: 0
[ 7133.346591] EIP is at __btrfs_reserve_extent+0x36a/0x420 [btrfs]
[ 7133.346594] EAX: ddce128c EBX: ddce3cc0 ECX: ffffffff EDX: 00000001
[ 7133.346597] ESI: ddce3cec EDI: ddce1280 EBP: d779da78 ESP: d779da04
[ 7133.346599]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 7133.346602] Process bonnie++ (pid: 6575, ti=d779c000 task=de6e57f0 task.ti=d779c000)
[ 7133.346605] Stack: e0d78f44 92360000 00000001 2ce10000 00000000 077a2000 00000000 2566e000 
[ 7133.346612]        00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000001 
[ 7133.346618]        00000000 00000000 00000000 00000000 00001000 00000000 ded19050 dd046000 
[ 7133.346625] Call Trace:
[ 7133.346629]  [<e0d39577>] ? btrfs_reserve_extent+0x77/0xb0 [btrfs]
[ 7133.346645]  [<e0d473a7>] ? cow_file_range+0x227/0x4d0 [btrfs]
[ 7133.346661]  [<e0d60df9>] ? lock_delalloc_pages+0xd9/0x180 [btrfs]
[ 7133.346676]  [<e0d614ec>] ? lock_extent+0x5c/0xd0 [btrfs]
[ 7133.346690]  [<e0d4c100>] ? run_delalloc_range+0x390/0x400 [btrfs]
[ 7133.346706]  [<e0d646a5>] ? __extent_writepage+0x4a5/0xb30 [btrfs]
[ 7133.346747]  [<c019339e>] ? page_address+0xe/0xe0
[ 7133.346754]  [<c019339e>] ? page_address+0xe/0xe0
[ 7133.346758]  [<c011fd28>] ? kmap_atomic_prot+0x48/0x100
[ 7133.346764]  [<c0250d2d>] ? radix_tree_gang_lookup_tag_slot+0x9d/0xc0
[ 7133.346770]  [<c018409d>] ? find_get_pages_tag+0x3d/0x130
[ 7133.346775]  [<c019d0ce>] ? page_mkclean+0xe/0xb0
[ 7133.346780]  [<c01917f6>] ? __dec_zone_state+0x16/0x90
[ 7133.346786]  [<e0d6104d>] ? extent_write_cache_pages+0x1ad/0x2f0 [btrfs]
[ 7133.346802]  [<e0d46840>] ? btrfs_writepages+0x0/0x30 [btrfs]
[ 7133.346819]  [<e0d611c6>] ? extent_writepages+0x36/0x60 [btrfs]
[ 7133.346834]  [<e0d64200>] ? __extent_writepage+0x0/0xb30 [btrfs]
[ 7133.346849]  [<e0d4c900>] ? btrfs_get_extent+0x0/0xad0 [btrfs]
[ 7133.346866]  [<e0d46864>] ? btrfs_writepages+0x24/0x30 [btrfs]
[ 7133.346881]  [<c018c4a3>] ? do_writepages+0x33/0x60
[ 7133.346886]  [<c01d25dc>] ? __sync_single_inode+0x5c/0x250
[ 7133.346891]  [<c01d281a>] ? __writeback_single_inode+0x4a/0x160
[ 7133.346895]  [<c024febc>] ? prop_fraction_single+0x3c/0x70
[ 7133.346900]  [<c01d2ccc>] ? generic_sync_sb_inodes+0x27c/0x3b0
[ 7133.346905]  [<c01d306d>] ? writeback_inodes+0x4d/0xe0
[ 7133.346909]  [<c018bd18>] ? balance_dirty_pages+0x238/0x340
[ 7133.346914]  [<c018be84>] ? balance_dirty_pages_ratelimited_nr+0x64/0x70
[ 7133.346919]  [<e0d51a8d>] ? btrfs_file_write+0x3dd/0x6a0 [btrfs]
[ 7133.346936]  [<c02353be>] ? apparmor_file_permission+0x1e/0x40
[ 7133.346942]  [<c01b1fad>] ? rw_verify_area+0x4d/0xc0
[ 7133.346947]  [<c01b1ac2>] ? fsnotify_modify+0x72/0x80
[ 7133.346951]  [<c01b24c0>] ? vfs_write+0xa0/0x110
[ 7133.346955]  [<e0d516b0>] ? btrfs_file_write+0x0/0x6a0 [btrfs]
[ 7133.346972]  [<c01b2602>] ? sys_write+0x42/0x70
[ 7133.346976]  [<c0103f7b>] ? sysenter_do_call+0x12/0x2f
[ 7133.346981]  =======================
[ 7133.346983] Code: 2f 64 df 8d 4b 4c 89 c8 89 4d f0 e8 01 45 64 df 8b 7b 40 8b 07 0f 18 00 90 83 c3 40 39 fb 89 5d ec 75 33 8b 45 f0 e8 c6 25 41 df <0f> 0b eb fe 66 90 8b 90 c4 18 00 00 8b 88 ac 18 00 00 8b b0 c0 
[ 7133.347025] EIP: [<e0d3944a>] __btrfs_reserve_extent+0x36a/0x420 [btrfs] SS:ESP 0068:d779da04
[ 7133.347042] ---[ end trace 97493f65cf117b85 ]---
