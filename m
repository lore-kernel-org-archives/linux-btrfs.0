From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Fri, 8 Jul 2011 16:41:23 +0100
Message-ID: <20110708154123.GA17886@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310137241-sup-8158@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-08 11:06:08 -0400, Chris Mason:
[...]
> So the invalidate opcode in btrfs-fixup-0 is the big problem.  We're
> either failing to write because we weren't able to allocate memory (and
> not dealing with it properly) or there is a bigger problem.
> 
> Does the btrfs-fixup-0 oops come before or after the ooms?

Hi Chris, thanks for looking into this.

It comes long before. Hours before there's any problem. So it
seems unrelated.

> Please send along any oops output during the run.  Only the first
> (earliest) oops matters.

There's always only  one in between two reboots. I've sent two
already, but here they  are:

Jul  1 18:25:57  ------------[ cut here ]------------
Jul  1 18:25:57  kernel BUG at /media/data/mattems/src/linux-2.6-3.0.0~rc5/debian/build/source_amd64_none/fs/btrfs/inode.c:1583!
Jul  1 18:25:57  invalid opcode: 0000 [#1] SMP
Jul  1 18:25:57  CPU 1
Jul  1 18:25:57  Modules linked in: sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt fuse snd_pcm psmouse tpm_tis tpm i2c_i801 snd_timer snd soundcore snd_page_alloc i3200_edac tpm_bios serio_raw evdev pcspkr processor button thermal_sys i2c_core container edac_core sg sr_mod cdrom ext4 mbcache jbd2 crc16 dm_mod nbd btrfs zlib_deflate crc32c libcrc32c ums_cypress usb_storage sd_mod crc_t10dif uas uhci_hcd ahci libahci libata ehci_hcd e1000e scsi_mod usbcore [last unloaded: scsi_wait_scan]
Jul  1 18:25:57 
Jul  1 18:25:57  Pid: 747, comm: btrfs-fixup-0 Not tainted 3.0.0-rc5-amd64 #1 empty empty/Tyan Tank GT20 B5211
Jul  1 18:25:57  RIP: 0010:[<ffffffffa014b0f4>]  [<ffffffffa014b0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
Jul  1 18:25:57  RSP: 0018:ffff8801483ffde0  EFLAGS: 00010246
Jul  1 18:25:57  RAX: 0000000000000000 RBX: ffffea000496a430 RCX: ffffffffffffffff
Jul  1 18:25:57  RDX: 0000000000000000 RSI: 0000000006849000 RDI: ffff880071c1fcb8
Jul  1 18:25:57  RBP: 0000000006849000 R08: 0000000000000008 R09: ffff8801483ffd98
Jul  1 18:25:57  R10: dead000000200200 R11: dead000000100100 R12: ffff880071c1fd90
Jul  1 18:25:57  R13: 0000000000000000 R14: ffff8801483ffdf8 R15: 0000000006849fff
Jul  1 18:25:57  FS:  0000000000000000(0000) GS:ffff88014fd00000(0000) knlGS:0000000000000000
Jul  1 18:25:57  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul  1 18:25:57  CR2: 00000000f7596000 CR3: 000000013def9000 CR4: 00000000000006e0
Jul  1 18:25:57  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  1 18:25:57  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  1 18:25:57  Process btrfs-fixup-0 (pid: 747, threadinfo ffff8801483fe000, task ffff88014672efa0)
Jul  1 18:25:57  Stack:
Jul  1 18:25:57   ffff880071c1fc28 ffff8800c70165c0 ffffffffffffffff ffff88011e61ca28
Jul  1 18:25:57   0000000000000000 ffff880146ef41c0 ffff880146ef4210 ffff880146ef41d8
Jul  1 18:25:57   ffff880146ef41c8 ffff880146ef4200 ffff880146ef41e8 ffffffffa01669fa
Jul  1 18:25:57  Call Trace:
Jul  1 18:25:57   [<ffffffffa01669fa>] ? worker_loop+0x186/0x4a1 [btrfs]
Jul  1 18:25:57   [<ffffffff813369ca>] ? schedule+0x5ed/0x61a
Jul  1 18:25:57   [<ffffffffa0166874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
Jul  1 18:25:57   [<ffffffffa0166874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
Jul  1 18:25:57   [<ffffffff8105faed>] ? kthread+0x7a/0x82
Jul  1 18:25:57   [<ffffffff8133e524>] ? kernel_thread_helper+0x4/0x10
Jul  1 18:25:57   [<ffffffff8105fa73>] ? kthread_worker_fn+0x147/0x147
Jul  1 18:25:57   [<ffffffff8133e520>] ? gs_change+0x13/0x13
Jul  1 18:25:57  Code: 41 b8 50 00 00 00 4c 89 f1 e8 d5 3b 01 00 48 89 df e8 fb ac f6 e0 ba 01 00 00 00 4c 89 ee 4c 89 e7 e8 ce 05 01 00 e9 4e ff ff ff <0f> 0b eb fe 48 8b 3c 24 41 b8 50 00 00 00 4c 89 f1 4c 89 fa 48
Jul  1 18:25:57  RIP  [<ffffffffa014b0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
Jul  1 18:25:57   RSP <ffff8801483ffde0>
Jul  1 18:25:57  ---[ end trace 9744d33381de3d04 ]---

Jul  4 12:50:51  ------------[ cut here ]------------
Jul  4 12:50:51  kernel BUG at /media/data/mattems/src/linux-2.6-3.0.0~rc5/debian/build/source_amd64_none/fs/btrfs/inode.c:1583!
Jul  4 12:50:51  invalid opcode: 0000 [#1] SMP
Jul  4 12:50:51  CPU 0
Jul  4 12:50:51  Modules linked in: lm85 dme1737 hwmon_vid coretemp ipmi_si ipmi_msghandler sha256_generic cryptd aes_x86_64 aes_generic cbc fuse dm_crypt snd_pcm snd_timer snd sg soundcore i3200_edac snd_page_alloc sr_mod processor tpm_tis i2c_i801 pl2303 pcspkr thermal_sys i2c_core tpm edac_core tpm_bios cdrom usbserial container evdev psmouse button serio_raw ext4 mbcache jbd2 crc16 dm_mod nbd btrfs zlib_deflate crc32c libcrc32c ums_cypress sd_mod crc_t10dif usb_storage uas uhci_hcd ahci libahci ehci_hcd libata e1000e usbcore scsi_mod [last unloaded: i2c_dev]
Jul  4 12:50:51 
Jul  4 12:50:51  Pid: 764, comm: btrfs-fixup-0 Not tainted 3.0.0-rc5-amd64 #1 empty empty/Tyan Tank GT20 B5211
Jul  4 12:50:51  RIP: 0010:[<ffffffffa00820f4>]  [<ffffffffa00820f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
Jul  4 12:50:51  RSP: 0018:ffff880147ffdde0  EFLAGS: 00010246
Jul  4 12:50:51  RAX: 0000000000000000 RBX: ffffea0004648098 RCX: ffffffffffffffff
Jul  4 12:50:51  RDX: 0000000000000000 RSI: 0000000005854000 RDI: ffff8800073f18d0
Jul  4 12:50:51  RBP: 0000000005854000 R08: 0000000000000008 R09: ffff880147ffdd98
Jul  4 12:50:51  R10: dead000000200200 R11: dead000000100100 R12: ffff8800073f19a8
Jul  4 12:50:51  R13: 0000000000000000 R14: ffff880147ffddf8 R15: 0000000005854fff
Jul  4 12:50:51  FS:  0000000000000000(0000) GS:ffff88014fc00000(0000) knlGS:0000000000000000
Jul  4 12:50:51  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul  4 12:50:51  CR2: 00000000f75c6000 CR3: 000000014780f000 CR4: 00000000000006f0
Jul  4 12:50:51  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  4 12:50:51  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  4 12:50:51  Process btrfs-fixup-0 (pid: 764, threadinfo ffff880147ffc000, task ffff880145d962c0)
Jul  4 12:50:51  Stack:
Jul  4 12:50:51   ffff8800073f1840 ffff8800040b9ec0 ffffffffffffffff ffff8800c45ef5a8
Jul  4 12:50:51   0000000000000000 ffff880147c13440 ffff880147c13490 ffff880147c13458
Jul  4 12:50:51   ffff880147c13448 ffff880147c13480 ffff880147c13468 ffffffffa009d9fa
Jul  4 12:50:51  Call Trace:
Jul  4 12:50:51   [<ffffffffa009d9fa>] ? worker_loop+0x186/0x4a1 [btrfs]
Jul  4 12:50:51   [<ffffffff813369ca>] ? schedule+0x5ed/0x61a
Jul  4 12:50:51   [<ffffffffa009d874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
Jul  4 12:50:51   [<ffffffffa009d874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
Jul  4 12:50:51   [<ffffffff8105faed>] ? kthread+0x7a/0x82
Jul  4 12:50:51   [<ffffffff8133e524>] ? kernel_thread_helper+0x4/0x10
Jul  4 12:50:51   [<ffffffff8105fa73>] ? kthread_worker_fn+0x147/0x147
Jul  4 12:50:51   [<ffffffff8133e520>] ? gs_change+0x13/0x13
Jul  4 12:50:51  Code: 41 b8 50 00 00 00 4c 89 f1 e8 d5 3b 01 00 48 89 df e8 fb 3c 03 e1 ba 01 00 00 00 4c 89 ee 4c 89 e7 e8 ce 05 01 00 e9 4e ff ff ff <0f> 0b eb fe 48 8b 3c 24 41 b8 50 00 00 00 4c 89 f1 4c 89 fa 48
Jul  4 12:50:51  RIP  [<ffffffffa00820f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
Jul  4 12:50:51   RSP <ffff880147ffdde0>
Jul  4 12:50:51  ---[ end trace 3b143d6e02d6e847 ]---

Jul  7 12:48:54  ------------[ cut here ]------------
Jul  7 12:48:55  kernel BUG at /media/data/mattems/src/linux-2.6-3.0.0~rc6/debian/build/source_amd64_none/fs/btrfs/inode.c:1583!
Jul  7 12:48:55  invalid opcode: 0000 [#1] SMP
Jul  7 12:48:55  CPU 0
Jul  7 12:48:55  Modules linked in: sha256_generic cryptd aes_x86_64 aes_generic cbc fuse lm85 dme1737 hwmon_vid coretemp ipmi_si ipmi_msghandler dm_crypt snd_pcm snd_timer snd soundcore i2c_i801 i2c_core psmouse snd_page_alloc tpm_tis tpm tpm_bios pcspkr i3200_edac pl2303 processor button serio_raw evdev edac_core container usbserial thermal_sys ext4 mbcache jbd2 crc16 dm_mod nbd btrfs zlib_deflate crc32c libcrc32c sg sr_mod cdrom ums_cypress sd_mod crc_t10dif usb_storage uas uhci_hcd ahci libahci libata ehci_hcd e1000e scsi_mod usbcore [last unloaded: scsi_wait_scan]
Jul  7 12:48:55 
Jul  7 12:48:55  Pid: 800, comm: btrfs-fixup-0 Not tainted 3.0.0-rc6-amd64 #1 empty empty/Tyan Tank GT20 B5211
Jul  7 12:48:55  RIP: 0010:[<ffffffffa00bf0f4>]  [<ffffffffa00bf0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
Jul  7 12:48:55  RSP: 0018:ffff880147ce1de0  EFLAGS: 00010246
Jul  7 12:48:55  RAX: 0000000000000000 RBX: ffffea00047058e8 RCX: ffffffffffffffff
Jul  7 12:48:55  RDX: 0000000000000000 RSI: 0000000003393000 RDI: ffff880020086100
Jul  7 12:48:55  RBP: 0000000003393000 R08: 0000000000000008 R09: ffff880147ce1d98
Jul  7 12:48:55  R10: dead000000200200 R11: dead000000100100 R12: ffff8800200861d8
Jul  7 12:48:55  R13: 0000000000000000 R14: ffff880147ce1df8 R15: 0000000003393fff
Jul  7 12:48:55  FS:  0000000000000000(0000) GS:ffff88014fc00000(0000) knlGS:0000000000000000
Jul  7 12:48:55  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul  7 12:48:55  CR2: 00000000f7594000 CR3: 0000000145b0b000 CR4: 00000000000006f0
Jul  7 12:48:55  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  7 12:48:55  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  7 12:48:55  Process btrfs-fixup-0 (pid: 800, threadinfo ffff880147ce0000, task ffff880147ca6f20)
Jul  7 12:48:55  Stack:
Jul  7 12:48:55   ffff880020086070 ffff88013e0be6c0 ffffffffffffffff ffff88004e72bb28
Jul  7 12:48:55   0000000000000000 ffff880146a001c0 ffff880146a00210 ffff880146a001d8
Jul  7 12:48:55   ffff880146a001c8 ffff880146a00200 ffff880146a001e8 ffffffffa00da9fa
Jul  7 12:48:55  Call Trace:
Jul  7 12:48:55   [<ffffffffa00da9fa>] ? worker_loop+0x186/0x4a1 [btrfs]
Jul  7 12:48:55   [<ffffffff81336a3a>] ? schedule+0x5ed/0x61a
Jul  7 12:48:55   [<ffffffffa00da874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
Jul  7 12:48:55   [<ffffffffa00da874>] ? btrfs_queue_worker+0x24a/0x24a [btrfs]
Jul  7 12:48:55   [<ffffffff8105fb2d>] ? kthread+0x7a/0x82
Jul  7 12:48:55   [<ffffffff8133e564>] ? kernel_thread_helper+0x4/0x10
Jul  7 12:48:55   [<ffffffff8105fab3>] ? kthread_worker_fn+0x147/0x147
Jul  7 12:48:55   [<ffffffff8133e560>] ? gs_change+0x13/0x13
Jul  7 12:48:55  Code: 41 b8 50 00 00 00 4c 89 f1 e8 d5 3b 01 00 48 89 df e8 3b 6d ff e0 ba 01 00 00 00 4c 89 ee 4c 89 e7 e8 ce 05 01 00 e9 4e ff ff ff <0f> 0b eb fe 48 8b 3c 24 41 b8 50 00 00 00 4c 89 f1 4c 89 fa 48
Jul  7 12:48:55  RIP  [<ffffffffa00bf0f4>] btrfs_writepage_fixup_worker+0xdb/0x120 [btrfs]
Jul  7 12:48:55   RSP <ffff880147ce1de0>
Jul  7 12:48:55  ---[ end trace 2c2801fb34de9335 ]---

> I would do two things.  First, I'd turn off compress_force.  There's no
> explicit reason for this, it just seems like the mostly likely place for
> a bug.
[...]

On the target FS you mean? I can try that on next week if I can
manage to get hold of another big enough hard drive.

Note that last time I was trying to reclaim the used memory (see
my earlier message), I was able to unmount the target FS (which
didn't free any memory) but not the source one. And sysrq-t for
umount showed:

 umount          D ffff880145ebe770     0 24079   1290 0x00000004
  ffff880145ebe770 0000000000000086 0000000000000000 ffffffff8160b020
  0000000000012840 ffff880123bc7fd8 ffff880123bc7fd8 0000000000012840
  ffff880145ebe770 ffff880123bc6010 00007fffac84f4a8 0000000100000000
 Call Trace:
  [<ffffffff81337d50>] ? rwsem_down_failed_common+0xda/0x10e
  [<ffffffff811aca63>] ? call_rwsem_down_write_failed+0x13/0x20
  [<ffffffff813376c7>] ? down_write+0x25/0x27
  [<ffffffff810ff6eb>] ? deactivate_super+0x30/0x3d
  [<ffffffff81114135>] ? sys_umount+0x2ea/0x315
  [<ffffffff8133d412>] ? system_call_fastpath+0x16/0x1b

I've resumed the rsync now, got another invalid opcode, and
memory usage is going up again, but like last time, the rsync is
likely to end before it causes a crash.

-- 
Stephane
