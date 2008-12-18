From: Kay Sievers <kay.sievers@vrfy.org>
Subject: BUG at fs/buffer.c:2925! when mounted USB-disk is disconnected
Date: Thu, 18 Dec 2008 04:15:38 +0100
Message-ID: <1229570138.3007.8.camel@nga>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I see the following when disconnecting a USB-stick containing a
mounted 2-partitions btrfs volume, and I try to umount it later.

I reproduced it 3 times, always after a fresh reboot. The box
is unstable after that, modules can not be unloaded, other fs's
can not be unmounted.

Thanks,
Kay


usb 1-2: USB disconnect, address 4
...
lost page write due to I/O error on sdb2
end_request: I/O error, dev sdb, sector 131072
lost page write due to I/O error on sdb2
lost page write due to I/O error on sdb1
end_request: I/O error, dev sdb, sector 131072
lost page write due to I/O error on sdb1
------------[ cut here ]------------
kernel BUG at fs/buffer.c:2925!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/rfkill/rfkill0/state
CPU 0 
Modules linked in: usb_storage btrfs zlib_inflate zlib_deflate crc32c libcrc32c ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd acpi_cpufreq fuse dm_crypt loop dm_mod rtc_cmos rtc_core rtc_lib uinput usbhid hid pcmcia arc4 thinkpad_acpi ecb hwmon snd_hda_intel backlight yenta_socket iwl3945 snd_pcm uhci_hcd snd_timer rfkill snd soundcore thermal mac80211 ehci_hcd pcspkr snd_page_alloc rsrc_nonstatic led_class battery ac evdev usbcore pcmcia_core nvram button cfg80211 e1000e sg intel_agp processor
Pid: 2994, comm: umount Not tainted 2.6.28-rc8-00057-g1bda712 #33
RIP: 0010:[<ffffffff802daf18>]  [<ffffffff802daf18>] submit_bh+0x128/0x130
RSP: 0018:ffff880061685c38  EFLAGS: 00010246
RAX: 0000000000000028 RBX: ffff880063eb0160 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffff880063eb0160 RDI: 0000000000000001
RBP: ffff880061685c58 R08: 0000000000000003 R09: 0000000000001000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000003 R15: ffff880061688f43
FS:  00007f71833eb6f0(0000) GS:ffffffff8069e7c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f91e27de010 CR3: 000000006fac0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 2994, threadinfo ffff880061684000, task ffff880061519140)
Stack:
 0000000000000000 ffff880063eb0160 0000000000000000 ffff880078957918
 ffff880061685cb8 ffffffffa03366bd ffff880063ed0038 ffff880061688f63
 0000000161685cb8 0000000000000001 0000000c00000001 ffff880078957918
Call Trace:
 [<ffffffffa03366bd>] write_dev_supers+0x20d/0x340 [btrfs]
 [<ffffffffa0336a08>] write_all_supers+0x218/0x260 [btrfs]
 [<ffffffffa0336a5e>] write_ctree_super+0xe/0x10 [btrfs]
 [<ffffffffa033a72f>] btrfs_commit_transaction+0x5ff/0x7e0 [btrfs]
 [<ffffffff80255d10>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff804da049>] ? mutex_unlock+0x9/0x10
 [<ffffffffa03198ad>] btrfs_sync_fs+0x5d/0x90 [btrfs]
 [<ffffffff802b9792>] __fsync_super+0x52/0x80
 [<ffffffff802b97d1>] fsync_super+0x11/0x30
 [<ffffffff802b9ac2>] generic_shutdown_super+0x22/0x100
 [<ffffffff802b9c01>] kill_anon_super+0x11/0x50
 [<ffffffff802b9cc6>] deactivate_super+0x56/0x80
 [<ffffffff802d0559>] mntput_no_expire+0xd9/0x150
 [<ffffffff802d092f>] sys_umount+0x5f/0x3c0
 [<ffffffff804db189>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8020c3bb>] system_call_fastpath+0x16/0x1b
Code: e8 7e 3f 00 00 f7 d3 48 83 c4 08 83 e3 a1 89 d8 5b 41 5c 41 5d c9 c3 0f 0b eb fe 0f 1f 84 00 00 00 00 00 0f 0b eb fe 0f 1f 40 00 <0f> 0b eb fe 0f 1f 40 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 83 
RIP  [<ffffffff802daf18>] submit_bh+0x128/0x130
 RSP <ffff880061685c38>
---[ end trace 941b43e9d76fb177 ]---


