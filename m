Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64668 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2F0Dqp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 23:46:45 -0400
Received: by vbbff1 with SMTP id ff1so422388vbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 20:46:44 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 13:16:44 +0930
Message-ID: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
Subject: WARNING: at fs/btrfs/free-space-cache.c:1887 after hard shutdown.
From: Jordan Windsor <jordanw2@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
My computer locked up and I had to press the reset button.
Ever since then I can't mount the btrfs filesystem, here's the output:

[   37.645583] ------------[ cut here ]------------
[   37.645598] WARNING: at fs/btrfs/free-space-cache.c:1887
btrfs_remove_free_space+0x329/0x350 [btrfs]()
[   37.645600] Modules linked in: btrfs zlib_deflate libcrc32c ext4
jbd2 mbcache crc16 snd_hda_codec_realtek rc_dib0700_rc5 mt2266
dvb_usb_dib0700 dib3000mc dib8000 dib0070 dib7000m dib7000p
dibx000_common dib0090 dvb_usb dvb_core rc_core microcode joydev
usb_storage uas coretemp acpi_cpufreq mperf ppdev nvidia(PO) 8139too
8139cp mii iTCO_wdt i2c_i801 i2c_core iTCO_vendor_support serio_raw
i7core_edac edac_core evdev pcspkr processor parport_pc parport
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
snd soundcore button reiserfs aes_x86_64 cryptd aes_generic xts
gf128mul dm_crypt dm_mod usbhid hid sr_mod sd_mod cdrom pata_jmicron
pata_acpi uhci_hcd ata_piix ata_generic ahci libahci libata ehci_hcd
crc32c_intel usbcore scsi_mod usb_common floppy
[   37.645651] Pid: 304, comm: mount Tainted: P           O 3.4.4-2-ck #1
[   37.645653] Call Trace:
[   37.645659]  [<ffffffff810515cf>] warn_slowpath_common+0x7f/0xc0
[   37.645662]  [<ffffffff8105162a>] warn_slowpath_null+0x1a/0x20
[   37.645670]  [<ffffffffa0f4a159>] btrfs_remove_free_space+0x329/0x350 [btrfs]
[   37.645674]  [<ffffffff81073bb0>] ? abort_exclusive_wait+0xb0/0xb0
[   37.645682]  [<ffffffffa0efaa6f>]
btrfs_alloc_logged_file_extent+0x1bf/0x1e0 [btrfs]
[   37.645688]  [<ffffffffa0ee7bfa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   37.645697]  [<ffffffffa0f44c5e>] replay_one_extent+0x5be/0x620 [btrfs]
[   37.645701]  [<ffffffff81179f55>] ? iput+0x105/0x210
[   37.645710]  [<ffffffffa0f4549b>] replay_one_buffer+0x27b/0x350 [btrfs]
[   37.645719]  [<ffffffffa0f302bd>] ? alloc_extent_buffer+0x9d/0x5c0 [btrfs]
[   37.645728]  [<ffffffffa0f42d92>] walk_down_log_tree+0x202/0x3c0 [btrfs]
[   37.645736]  [<ffffffffa0f42fed>] walk_log_tree+0x9d/0x1f0 [btrfs]
[   37.645745]  [<ffffffffa0f46f4b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[   37.645754]  [<ffffffffa0f45220>] ? replay_one_dir_item+0xe0/0xe0 [btrfs]
[   37.645763]  [<ffffffffa0f0883d>] open_ctree+0x14ed/0x1ac0 [btrfs]
[   37.645767]  [<ffffffff8121e101>] ? disk_name+0x61/0xc0
[   37.645773]  [<ffffffffa0ee5836>] btrfs_mount+0x5b6/0x6a0 [btrfs]
[   37.645776]  [<ffffffff8113f400>] ? alloc_pages_current+0xb0/0x120
[   37.645780]  [<ffffffff81163533>] mount_fs+0x43/0x1b0
[   37.645783]  [<ffffffff8117d740>] vfs_kern_mount+0x70/0x100
[   37.645786]  [<ffffffff8117dc64>] do_kern_mount+0x54/0x110
[   37.645788]  [<ffffffff8117f55a>] do_mount+0x26a/0x850
[   37.645791]  [<ffffffff81101e1e>] ? __get_free_pages+0xe/0x50
[   37.645794]  [<ffffffff8117f15a>] ? copy_mount_options+0x3a/0x180
[   37.645797]  [<ffffffff8117fc7d>] sys_mount+0x8d/0xe0
[   37.645801]  [<ffffffff814626e9>] system_call_fastpath+0x16/0x1b
[   37.645802] ---[ end trace 98bf42a1cdef3f88 ]---
[   37.645812] ------------[ cut here ]------------
[   37.646716] kernel BUG at fs/btrfs/extent-tree.c:6107!
[   37.647722] invalid opcode: 0000 [#1] PREEMPT SMP
[   37.648763] CPU 1
[   37.649156] Modules linked in: btrfs zlib_deflate libcrc32c ext4
jbd2 mbcache crc16 snd_hda_codec_realtek rc_dib0700_rc5 mt2266
dvb_usb_dib0700 dib3000mc dib8000 dib0070 dib7000m dib7000p
dibx000_common dib0090 dvb_usb dvb_core rc_core microcode joydev
usb_storage uas coretemp acpi_cpufreq mperf ppdev nvidia(PO) 8139too
8139cp mii iTCO_wdt i2c_i801 i2c_core iTCO_vendor_support serio_raw
i7core_edac edac_core evdev pcspkr processor parport_pc parport
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
snd soundcore button reiserfs aes_x86_64 cryptd aes_generic xts
gf128mul dm_crypt dm_mod usbhid hid sr_mod sd_mod cdrom pata_jmicron
pata_acpi uhci_hcd ata_piix ata_generic ahci libahci libata ehci_hcd
crc32c_intel usbcore scsi_mod usb_common floppy
[   37.665300]
[   37.665591] Pid: 304, comm: mount Tainted: P        W  O 3.4.4-2-ck #1
[   37.666973] RIP: 0010:[<ffffffffa0efaa77>]  [<ffffffffa0efaa77>]
btrfs_alloc_logged_file_extent+0x1c7/0x1e0 [btrfs]
[   37.669058] RSP: 0018:ffff880118649748  EFLAGS: 00010282
[   37.670098] RAX: 00000000ffffffea RBX: ffff88010ff1a000 RCX: 000000000000000e
[   37.671495] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff88010fef6840
[   37.672892] RBP: ffff8801186497c8 R08: 0000000000000000 R09: 0000000000000000
[   37.674289] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880118649883
[   37.675687] R13: 0000000000000000 R14: 00000019cf4be000 R15: ffff88010fc95800
[   37.731396] FS:  00007fb10edfb740(0000) GS:ffff88011fc40000(0000)
knlGS:0000000000000000
[   37.788242] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.788243] CR2: 00007f5b18c9c15c CR3: 0000000110a7d000 CR4: 00000000000007e0
[   37.788245] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   37.788247] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   37.788249] Process mount (pid: 304, threadinfo ffff880118648000,
task ffff880118a8d620)
[   37.788250] Stack:
[   37.788251]  0000000000000001 0000000000015000 ffff880118649778
ffffffffa0ee7bfa
[   37.788253]  000000002ee71000 000000000013ffbd 0000000000000005
ffff8801149dc000
[   37.788256]  0000000000015000 00ff880114ac62f0 a800000019cf4be0
ffff88010fc95800
[   37.788258] Call Trace:
[   37.788264]  [<ffffffffa0ee7bfa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   37.788272]  [<ffffffffa0f44c5e>] replay_one_extent+0x5be/0x620 [btrfs]
[   37.788275]  [<ffffffff81179f55>] ? iput+0x105/0x210
[   37.788283]  [<ffffffffa0f4549b>] replay_one_buffer+0x27b/0x350 [btrfs]
[   37.788292]  [<ffffffffa0f302bd>] ? alloc_extent_buffer+0x9d/0x5c0 [btrfs]
[   37.788300]  [<ffffffffa0f42d92>] walk_down_log_tree+0x202/0x3c0 [btrfs]
[   37.788309]  [<ffffffffa0f42fed>] walk_log_tree+0x9d/0x1f0 [btrfs]
[   37.788317]  [<ffffffffa0f46f4b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[   37.788326]  [<ffffffffa0f45220>] ? replay_one_dir_item+0xe0/0xe0 [btrfs]
[   37.788334]  [<ffffffffa0f0883d>] open_ctree+0x14ed/0x1ac0 [btrfs]
[   37.788338]  [<ffffffff8121e101>] ? disk_name+0x61/0xc0
[   37.788343]  [<ffffffffa0ee5836>] btrfs_mount+0x5b6/0x6a0 [btrfs]
[   37.788346]  [<ffffffff8113f400>] ? alloc_pages_current+0xb0/0x120
[   37.788348]  [<ffffffff81163533>] mount_fs+0x43/0x1b0
[   37.788351]  [<ffffffff8117d740>] vfs_kern_mount+0x70/0x100
[   37.788353]  [<ffffffff8117dc64>] do_kern_mount+0x54/0x110
[   37.788355]  [<ffffffff8117f55a>] do_mount+0x26a/0x850
[   37.788358]  [<ffffffff81101e1e>] ? __get_free_pages+0xe/0x50
[   37.788360]  [<ffffffff8117f15a>] ? copy_mount_options+0x3a/0x180
[   37.788362]  [<ffffffff8117fc7d>] sys_mount+0x8d/0xe0
[   37.788365]  [<ffffffff814626e9>] system_call_fastpath+0x16/0x1b
[   37.788366] Code: 0b 0f 1f 00 48 8d bb 80 00 00 00 e8 24 63 ff ff
85 c0 74 1d 48 8b 55 c0 4c 89 f6 48 89 df e8 c1 f3 04 00 85 c0 0f 84
29 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 66 2e 0f 1f
84 00
[   37.788382] RIP  [<ffffffffa0efaa77>]
btrfs_alloc_logged_file_extent+0x1c7/0x1e0 [btrfs]
[   37.788389]  RSP <ffff880118649748>
[   37.788468] ---[ end trace 98bf42a1cdef3f89 ]---
[   38.955216] Adding 6143996k swap on /dev/sda4.  Priority:-1
extents:1 across:6143996k
[   41.323339] 8139too 0000:03:03.0: eth0: link up, 100Mbps,
full-duplex, lpa 0x45E1
[   51.993170] eth0: no IPv6 routers present
[   60.972748] NVRM: Your system is not currently configured to drive
a VGA console
[   60.972755] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
[   60.972760] NVRM: requires the use of a text-mode VGA console. Use
of other console
[   60.972764] NVRM: drivers including, but not limited to, vesafb,
may result in
[   60.972767] NVRM: corruption and stability problems, and is not supported.
[   63.862595] fuse init (API version 7.18)
[   69.223888] EXT4-fs (sda1): re-mounted. Opts: commit=0

Thanks.
