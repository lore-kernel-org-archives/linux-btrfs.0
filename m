From: Matteo Frigo <athena@fftw.org>
Subject: linux-2.6.29: BUG at fs/btrfs/extent-tree.c:3433
Date: Thu, 26 Mar 2009 19:30:46 -0400
Message-ID: <87tz5fc15l.fsf_-_@fftw.org>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site> <Pine.LNX.4.64.0903261650260.31773@usbsys.site> <Pine.LNX.4.64.0903261716270.1976@usbsys.site> <20090326143936.GE27476@kernel.dk> <1238078881.5676.14.camel@think.oraclecorp.com> <20090326154320.GF27476@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following series of commands reliably causes a kernel BUG
with linux-2.6.29:

   lvcreate -L 10G -n x0 test
   lvcreate -L 10G -n x1 test
   lvcreate -L 10G -n x2 test
   mkfs.btrfs -m raid1 -d raid1 /dev/mapper/test-x[01]
   mount /dev/mapper/test-x0 /mnt
   umount /mnt
   lvremove test/x1
   mount -o degraded /dev/mapper/test-x0 /mnt
   btrfs-vol -a /dev/mapper/test-x2 /mnt

The dmesg log is attached.

Thanks for your work on btrfs.

Regards,
Matteo Frigo


[  137.894985] btrfs: allowing degraded mounts
[  138.175419] btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
[  138.176529] btrfs allocation failed flags 18, wanted 4096
[  138.177203] space_info has 8384512 free, is not full
[  138.177206] space_info total=8388608, pinned=0, delalloc=0, may_use=0, used=4096
[  138.177209] block group 20971520 has 8388608 bytes, 4096 used 0 pinned 0 reserved
[  138.177212] 1 blocks of free space at or bigger than bytes is
[  138.177247] ------------[ cut here ]------------
[  138.177865] kernel BUG at fs/btrfs/extent-tree.c:3433!
[  138.178514] invalid opcode: 0000 [#1] SMP 
[  138.179305] last sysfs file: /sys/block/dm-3/removable
[  138.179943] CPU 0 
[  138.180514] Modules linked in: btrfs zlib_deflate zlib_inflate crc32c libcrc32c ipv6 nfs lockd nfs_acl auth_rpcgss sunrpc loop virtio_console virtio_balloon snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr psmouse serio_raw i2c_piix4 i2c_core parport_pc parport button joydev evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod usbhid hid ide_gd_mod ata_generic ide_pci_generic ata_piix libata scsi_mod floppy virtio_pci virtio_ring virtio e1000 uhci_hcd ehci_hcd piix ide_core thermal processor fan thermal_sys
[  138.180514] Pid: 2444, comm: btrfs-vol Not tainted 2.6.29 #1 
[  138.180514] RIP: 0010:[<ffffffffa03800c3>]  [<ffffffffa03800c3>] __btrfs_reserve_extent+0x290/0x2a5 [btrfs]
[  138.180514] RSP: 0018:ffff88001cce58a8  EFLAGS: 00010246
[  138.180514] RAX: ffff88001d975a38 RBX: ffff88001c41beec RCX: ffffffff8047ad6c
[  138.180514] RDX: 00000000ffffffff RSI: 0000000000000246 RDI: 0000000000000246
[  138.180514] RBP: ffff88001d975960 R08: ffff88001cce540d R09: 0000000000000000
[  138.180514] R10: 000000000000000a R11: 0000000000018600 R12: 0000000000001000
[  138.180514] R13: ffff88001d975a30 R14: ffff88001d975a18 R15: ffff88001c488000
[  138.180514] FS:  00007f63aa2ce740(0000) GS:ffffffff806d4000(0000) knlGS:0000000000000000
[  138.180514] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  138.180514] CR2: 00007f63a9c44d60 CR3: 000000001c497000 CR4: 00000000000006e0
[  138.180514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.180514] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  138.180514] Process btrfs-vol (pid: 2444, threadinfo ffff88001cce4000, task ffff88001d946cf0)
[  138.180514] Stack:
[  138.180514]  0000000000000000 ffff88001cce59b8 0000000000000000 0000000000000000
[  138.180514]  ffff880000000012 ffff88001c06ebc8 0000000000000000 0000000000000000
[  138.180514]  0000000000000000 ffff88001cce59b8 ffff88001c432000 0000000000000003
[  138.180514] Call Trace:
[  138.180514]  [<ffffffffa03818f9>] ? btrfs_alloc_extent+0x4a/0xa2 [btrfs]
[  138.180514]  [<ffffffffa03819ba>] ? btrfs_alloc_free_block+0x69/0x96 [btrfs]
[  138.180514]  [<ffffffff803a3de6>] ? extract_buf+0x7e/0xf2
[  138.180514]  [<ffffffffa0374380>] ? __btrfs_cow_block+0x1ed/0x885 [btrfs]
[  138.180514]  [<ffffffff803a3804>] ? mix_pool_bytes_extract+0x57/0x14a
[  138.180514]  [<ffffffffa037518d>] ? btrfs_cow_block+0x1e7/0x1f6 [btrfs]
[  138.180514]  [<ffffffffa037992c>] ? btrfs_search_slot+0x35e/0x99c [btrfs]
[  138.180514]  [<ffffffffa037a4e1>] ? btrfs_insert_empty_items+0x7f/0x4a3 [btrfs]
[  138.180514]  [<ffffffffa03ab039>] ? btrfs_add_device+0x7a/0x1b9 [btrfs]
[  138.180514]  [<ffffffff8047ae12>] ? _spin_lock+0x5/0x7
[  138.180514]  [<ffffffffa03ac201>] ? btrfs_init_new_device+0x719/0x908 [btrfs]
[  138.180514]  [<ffffffff8028f06f>] ? generic_file_aio_write_nolock+0x33/0x7f
[  138.180514]  [<ffffffffa03ae689>] ? btrfs_ioctl+0x607/0x7f6 [btrfs]
[  138.180514]  [<ffffffff80257062>] ? autoremove_wake_function+0x0/0x2e
[  138.180514]  [<ffffffff802a458e>] ? free_pgtables+0x9c/0xbe
[  138.180514]  [<ffffffff802c90aa>] ? vfs_ioctl+0x21/0x6c
[  138.180514]  [<ffffffff802c952e>] ? do_vfs_ioctl+0x439/0x472
[  138.180514]  [<ffffffff802bdad7>] ? vfs_write+0x121/0x156
[  138.180514]  [<ffffffff802c95b8>] ? sys_ioctl+0x51/0x70
[  138.180514]  [<ffffffff8021102a>] ? system_call_fastpath+0x16/0x1b
[  138.180514] Code: 8b 85 b8 00 00 00 48 8d a8 48 ff ff ff 48 8b 85 b8 00 00 00 0f 18 08 48 8d 85 b8 00 00 00 49 39 c6 75 9a 4c 89 ef e8 87 9e ed df <0f> 0b eb fe 48 83 c4 48 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
[  138.180514] RIP  [<ffffffffa03800c3>] __btrfs_reserve_extent+0x290/0x2a5 [btrfs]
[  138.180514]  RSP <ffff88001cce58a8>
[  138.232118] ---[ end trace 12da8dfd82a051da ]---

