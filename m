From: Erik Jensen <eriksjunk@rkjnsn.net>
Subject: Can't remove missing drive (kernel BUG)
Date: Sun, 17 Oct 2010 03:20:20 -0700
Message-ID: <AANLkTin5oTWmWyp3EeRRU-CUDSjG-9JpaEK57AVK23J4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have an six-drive array I use for television recordings (4 2TB and 2 1.5TB).

Yesterday, I had one of the 1.5TBs die on me, so I did a "mount -o
degraded /dev/sdb /mnt/media" followed by a "btrfs-vol -r missing
/mnt/media", but the latter command almost immediately generated a
kernel BUG message, and then hung.  This happened on both 2.6.34 and
2.6.35 kernels.  The relevant dmesg output is below.  I'm fine with
recompiling the kernel, if there is a setting you'd like me to enable
to get more information.  Also, the array was fairly full (about 76%),
so I don't know if that might be contributing.

Thank you.

device label Media devid 2 transid 160727 /dev/sdb
btrfs: allowing degraded mounts
warning devid 5 missing
btrfs: relocating block group 15629440516096 flags 17
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3037!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:06:00.0/boot_vga
CPU 1
Modules linked in: ipv6 xt_tcpudp iptable_filter ipt_addrtype xt_dscp
xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE
xt_mark xt_connmark nf_conntrack ip_tables x_tables snd_pcm_oss
snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
btrfs zlib_deflate crc32c libcrc32c ir_kbd_i2c cx88_dvb
cx88_vp3054_i2c s5h1411 xc5000 s5h1409 tuner cx23885 firmware_class
cx88_alsa arc4 ecb cx8800 cx8802 cx88xx cx2341x ath9k ath9k_common
ftdi_sio ath9k_hw usbserial v4l2_common videodev videobuf_dvb dvb_core
r8169 ath usblp i2c_i801 v4l2_compat_ioctl32 pcspkr mii firewire_ohci
firewire_core evdev i2c_algo_bit mac80211 tveeprom videobuf_dma_sg
cfg80211 videobuf_core rfkill btcx_risc snd_hda_codec_realtek
led_class snd_hda_intel i2c_core button snd_hda_codec snd_hwdep
snd_pcm snd_timer snd soundcore snd_page_alloc fuse reiserfs
scsi_wait_scan uhci_hcd usb_storage ehci_hcd sr_mod cdrom sg
sata_sil24

Pid: 9011, comm: flush-btrfs-2 Not tainted 2.6.35-gentoo-r8 #2
Burbank/KT829AV-ABA d4999t-2
RIP: 0010:[<ffffffffa02ce6fc>]  [<ffffffffa02ce6fc>] 0xffffffffa02ce6fc
RSP: 0018:ffff88019d4f3930  EFLAGS: 00010246
RAX: 0000000000000030 RBX: ffff88019e4862c0 RCX: 0000000000010000
RDX: ffff8801ae7d99c0 RSI: ffff8801ab22ea00 RDI: 0000000000000000
RBP: ffff8801acde4800 R08: ffff88019d47b680 R09: 0000000040000000
R10: ffff8801a5b6cab0 R11: ffff8801ae7d99c0 R12: ffff88019d47b680
R13: 0000000000000002 R14: 0000000000000000 R15: 00000006eda1a000
FS:  0000000000000000(0000) GS:ffff880001680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f4d55a0b000 CR3: 00000001a3879000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-btrfs-2 (pid: 9011, threadinfo ffff88019d4f2000, task
ffff8801a38d9890)
Stack:
 0000000100001000 0000000100000000 ffff8801ae7d99c0 0000000000010000
<0> 0000000000000000 ffff88019e4862c0 0000000000000000 ffff88019d4f3c60
<0> 00000006eda1a080 0000000000010fff 0000000000000000 ffffffffa02c7ec4
Call Trace:
 [<ffffffffa02c7ec4>] ? 0xffffffffa02c7ec4
 [<ffffffffa02c8004>] ? 0xffffffffa02c8004
 [<ffffffffa02c9fcb>] ? 0xffffffffa02c9fcb
 [<ffffffffa02cbf60>] ? 0xffffffffa02cbf60
 [<ffffffffa02c9fcb>] ? 0xffffffffa02c9fcb
 [<ffffffffa02cc3dd>] ? 0xffffffffa02cc3dd
 [<ffffffffa02cc5c8>] ? 0xffffffffa02cc5c8
 [<ffffffffa02b4b89>] ? 0xffffffffa02b4b89
 [<ffffffff810b5356>] ? 0xffffffff810b5356
 [<ffffffff810b58bc>] ? 0xffffffff810b58bc
 [<ffffffff810b607b>] ? 0xffffffff810b607b
 [<ffffffff810b621a>] ? 0xffffffff810b621a
 [<ffffffff810b62d9>] ? 0xffffffff810b62d9
 [<ffffffff81037a29>] ? 0xffffffff81037a29
 [<ffffffff810b6415>] ? 0xffffffff810b6415
 [<ffffffff810409f7>] ? 0xffffffff810409f7
 [<ffffffff81084f74>] ? 0xffffffff81084f74
 [<ffffffff81084fd7>] ? 0xffffffff81084fd7
 [<ffffffff81084f74>] ? 0xffffffff81084f74
 [<ffffffff810406e1>] ? 0xffffffff810406e1
 [<ffffffff81002c54>] ? 0xffffffff81002c54
 [<ffffffff8104066c>] ? 0xffffffff8104066c
 [<ffffffff81002c50>] ? 0xffffffff81002c50
Code: c0 03 48 c1 e0 04 48 01 c2 48 8b 52 08 48 c1 ea 09 49 89 14 24
48 8b 54 24 10 83 7c 24 04 01 48 8b 34 10 75 0a 83 7e 64 00 75 04 <0f>
0b eb fe 48 85 f6 74 34 48 8b 46 70 48 85 c0 74 2b 49 89 44
RIP  [<ffffffffa02ce6fc>] 0xffffffffa02ce6fc
 RSP <ffff88019d4f3930>
---[ end trace be039cec4b98333b ]---
btrfs: found 645 extents
