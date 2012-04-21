From: Thomas Weber <thomas.weber.linux@googlemail.com>
Subject: bug?
Date: Sat, 21 Apr 2012 14:53:55 +0200
Message-ID: <4F92ADE3.3010403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

today my laptop crashed with the following output. Installed is
Archlinux with btrfs on a SSD.
Is it btrfs related?

Thanks,
Thomas


Apr 21 13:01:01 localhost anacron[3307]: Anacron started on 2012-04-21
Apr 21 13:01:01 localhost anacron[3307]: Will run job `cron.daily' in 48
min.
Apr 21 13:01:01 localhost anacron[3307]: Jobs will be executed sequentially
Apr 21 13:21:01 localhost -- MARK --
Apr 21 13:41:01 localhost -- MARK --
Apr 21 13:49:01 localhost anacron[3307]: Job `cron.daily' started
Apr 21 13:49:14 localhost kernel: [23420.297861] general protection
fault: 0000 [#1] PREEMPT SMP
Apr 21 13:49:14 localhost kernel: [23420.297976] CPU 1
Apr 21 13:49:14 localhost kernel: [23420.298007] Modules linked in:
nls_cp437 vfat fat usb_storage uas aes_x86_64 cryptd aes_generic fuse
ext4 jbd2 mbcache crc16 joydev arc4 dell_wmi sparse_keymap i915
snd_hda_codec_idt iwl3945 dell_laptop dcdbas iwl_legacy mac80211
snd_hda_intel i2c_algo_bit snd_hda_codec drm_kms_helper evdev snd_hwdep
snd_pcm drm serio_raw psmouse pcspkr tg3 snd_page_alloc cfg80211
snd_timer i2c_i801 iTCO_wdt iTCO_vendor_support snd i2c_core libphy
rfkill soundcore intel_agp intel_gtt wmi thermal button battery video
processor ac btrfs crc32c libcrc32c zlib_deflate sr_mod cdrom sd_mod
pata_acpi ata_generic ata_piix libata scsi_mod ehci_hcd uhci_hcd usbcore
usb_common
Apr 21 13:49:14 localhost kernel: [23420.299233]
Apr 21 13:49:14 localhost kernel: [23420.299262] Pid: 11172, comm:
updatedb Not tainted 3.2.11-1-ARCH #1 Dell Inc. Latitude
D530                   /0HP728
Apr 21 13:49:14 localhost kernel: [23420.299410] RIP:
0010:[<ffffffffa0180ddd>]  [<ffffffffa0180ddd>] btrfs_getattr+0x3d/0x90
[btrfs]
Apr 21 13:49:14 localhost kernel: [23420.299560] RSP:
0018:ffff880077765e38  EFLAGS: 00010206
Apr 21 13:49:14 localhost kernel: [23420.299630] RAX: 41d700000000fffe
RBX: ffff8800bf6c1550 RCX: 000000000000000c
Apr 21 13:49:14 localhost kernel: [23420.299717] RDX: ffff880077765f00
RSI: ffff880077765f00 RDI: ffff8800bf6c1550
Apr 21 13:49:14 localhost kernel: [23420.299804] RBP: ffff880077765e58
R08: ffffffff81173373 R09: ffff8800ba43bcf8
Apr 21 13:49:14 localhost kernel: [23420.299891] R10: ffff8800ba43bcc0
R11: 0000000000000005 R12: ffff880077765f00
Apr 21 13:49:14 localhost kernel: [23420.299978] R13: 0000000000001000
R14: ffff880077765f00 R15: 0000000001e54c50
Apr 21 13:49:14 localhost kernel: [23420.300067] FS: 
00007f3e42b8f700(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
Apr 21 13:49:14 localhost kernel: [23420.300168] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Apr 21 13:49:14 localhost kernel: [23420.300240] CR2: 0000000001e71ffc
CR3: 0000000058685000 CR4: 00000000000006e0
Apr 21 13:49:14 localhost kernel: [23420.300327] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Apr 21 13:49:14 localhost kernel: [23420.300414] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 21 13:49:14 localhost kernel: [23420.300502] Process updatedb (pid:
11172, threadinfo ffff880077764000, task ffff88008a8023a0)
Apr 21 13:49:14 localhost kernel: [23420.300603] Stack:
Apr 21 13:49:14 localhost kernel: [23420.300635]  ffff880077765f68
ffff8800ba43bcc0 ffff88011707bd00 ffff8800bf6c1550
Apr 21 13:49:14 localhost kernel: [23420.300753]  ffff880077765e98
ffffffff8116c51e ffff880077765f00 0000000001e38319
Apr 21 13:49:14 localhost kernel: [23420.300869]  ffff880077765f00
0000000001e38319 00007fffd821ca18 0000000000000000
Apr 21 13:49:14 localhost kernel: [23420.300985] Call Trace:
Apr 21 13:49:14 localhost kernel: [23420.301001]  [<ffffffff8116c51e>]
vfs_getattr+0x4e/0x80
Apr 21 13:49:14 localhost kernel: [23420.301001]  [<ffffffff8116c59e>]
vfs_fstatat+0x4e/0x70
Apr 21 13:49:14 localhost kernel: [23420.301001]  [<ffffffff8116c5de>]
vfs_lstat+0x1e/0x20
Apr 21 13:49:14 localhost kernel: [23420.301001]  [<ffffffff8116c77a>]
sys_newlstat+0x1a/0x40
Apr 21 13:49:14 localhost kernel: [23420.301001]  [<ffffffff8145ddc2>]
system_call_fastpath+0x16/0x1b
Apr 21 13:49:14 localhost kernel: [23420.301001] Code: 6d f8 66 66 66 66
90 48 8b 5e 30 48 89 d6 49 89 d4 48 8b 43 28 48 89 df 44 8b 68 18 e8 5d
b2 fe e0 48 8b 83 60 fe ff ff 48 89 df <8b> 80 00 04 00 00 49 c7 44 24
58 00 10 00 00 41 89 44 24 08 e8
Apr 21 13:49:14 localhost kernel: [23420.301001] RIP 
[<ffffffffa0180ddd>] btrfs_getattr+0x3d/0x90 [btrfs]
Apr 21 13:49:14 localhost kernel: [23420.301001]  RSP <ffff880077765e38>
Apr 21 13:49:14 localhost anacron[3307]: Job `cron.daily' terminated
(exit status: 1) (mailing output)
Apr 21 13:49:14 localhost anacron[3307]: Can't find sendmail at
/usr/sbin/sendmail, not mailing output
Apr 21 13:49:14 localhost anacron[3307]: Normal exit (1 job run)
Apr 21 13:49:14 localhost kernel: [23420.365362] ---[ end trace
27dae2a049083cf1 ]---

