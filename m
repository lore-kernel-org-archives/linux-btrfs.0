From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: [3.0.0rc5] invalid opcode
Date: Fri, 1 Jul 2011 18:44:36 +0100
Message-ID: <20110701174436.GA8352@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just got one of those:

[ 8203.192107] ------------[ cut here ]------------
[ 8203.192146] kernel BUG at /media/data/mattems/src/linux-2.6-3.0.0~rc5/debian/build/source_amd64_none/fs/btrfs/inode.c:1583!
[ 8203.192210] invalid opcode: 0000 [#1] SMP
[ 8203.192246] CPU 1
[ 8203.192256] Modules linked in: sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt fuse snd_pcm psmouse tpm_tis tpm i2c_i801 snd_timer snd soundcore snd_page_alloc i3200_edac tpm_bios serio_raw evdev pcspkr processor button thermal_sys i2c_core container edac_core sg sr_mod cdrom ext4 mbcache jbd2 crc16 dm_mod nbd btrfs zlib_deflate crc32c libcrc32c ums_cypress usb_storage sd_mod crc_t10dif uas uhci_hcd ahci libahci libata ehci_hcd e1000e scsi_mod usbcore [last unloaded: scsi_wait_scan]
[ 8203.192603]
[ 8203.192630] Pid: 747, comm: btrfs-fixup-0 Not tainted 3.0.0-rc5-amd64 #1 empty empty/Tyan Tank GT20 B5211
[ 8203.192697] RIP: 0010:[<ffffffffa014b0f4>]  [<ffffffffa014b0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
[ 8203.192781] RSP: 0018:ffff8801483ffde0  EFLAGS: 00010246
[ 8203.192816] RAX: 0000000000000000 RBX: ffffea000496a430 RCX: ffffffffffffffff
[ 8203.192855] RDX: 0000000000000000 RSI: 0000000006849000 RDI: ffff880071c1fcb8
[ 8203.192893] RBP: 0000000006849000 R08: 0000000000000008 R09: ffff8801483ffd98
[ 8203.192932] R10: dead000000200200 R11: dead000000100100 R12: ffff880071c1fd90
[ 8203.192971] R13: 0000000000000000 R14: ffff8801483ffdf8 R15: 0000000006849fff
[ 8203.193010] FS:  0000000000000000(0000) GS:ffff88014fd00000(0000) knlGS:0000000000000000
[ 8203.193067] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8203.193103] CR2: 00000000f7596000 CR3: 000000013def9000 CR4: 00000000000006e0
[ 8203.193141] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8203.193180] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8203.193219] Process btrfs-fixup-0 (pid: 747, threadinfo ffff8801483fe000, task ffff88014672efa0)
[ 8203.193277] Stack:
[ 8203.193304]  ffff880071c1fc28 ffff8800c70165c0 ffffffffffffffff ffff88011e61ca28
[ 8203.193371]  0000000000000000 ffff880146ef41c0 ffff880146ef4210 ffff880146ef41d8
[ 8203.193434]  ffff880146ef41c8 ffff880146ef4200 ffff880146ef41e8 ffffffffa01669fa
[ 8203.193497] Call Trace:
[ 8203.193538]  [<ffffffffa01669fa>] ? worker_loop+0x186/0x4a1 [btrfs]
[ 8203.193579]  [<ffffffff813369ca>] ? schedule+0x5ed/0x61a
[ 8203.193624]  [<ffffffffa0166874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
[ 8203.193673]  [<ffffffffa0166874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
[ 8203.193714]  [<ffffffff8105faed>] ? kthread+0x7a/0x82
[ 8203.193750]  [<ffffffff8133e524>] ? kernel_thread_helper+0x4/0x10
[ 8203.193788]  [<ffffffff8105fa73>] ? kthread_worker_fn+0x147/0x147
[ 8203.193825]  [<ffffffff8133e520>] ? gs_change+0x13/0x13
[ 8203.193859] Code: 41 b8 50 00 00 00 4c 89 f1 e8 d5 3b 01 00 48 89 df e8 fb ac f6 e0 ba 01 00 00 00 4c 89 ee 4c 89 e7 e8 ce 05 01 00 e9 4e ff ff ff <0f> 0b eb fe 48 8b 3c 24 41 b8 50 00 00 00 4c 89 f1 4c 89 fa 48
[ 8203.194087] RIP  [<ffffffffa014b0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
[ 8203.194160]  RSP <ffff8801483ffde0>
[ 8203.194907] ---[ end trace 9744d33381de3d04 ]---

Should I be worried?

Cheers,
Stephane
