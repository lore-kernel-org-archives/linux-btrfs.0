From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: kernel BUG at fs/btrfs/delayed-inode.c:1693!
Date: Tue, 26 Jul 2011 10:51:24 +0300
Message-ID: <CAA_Wi2K7w9mwGS3LO-eEydZ3R6fSeQWOSoNz6dNMkO4w8DohsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is what I get  if I use command:
bcp file file_copy
I can reproduce this every time when using bcp command.

Filesystem is under lvm:
/dev/mapper/vg_md1-btrfs on /mnt/btrfs type btrfs (rw,noatime,subvol=.)

This filesystem is created using linux-3.0 and
mkfs.btrfs, part of Btrfs v0.19-1-g4f89b6e-dirty

Ok, I don't have any kernel debug stuff there but maybe you can
reproduce this....

-Markus



------------[ cut here ]------------
kernel BUG at fs/btrfs/delayed-inode.c:1693!
invalid opcode: 0000 [#1] SMP
CPU 2
Modules linked in: af_packet libafs(P) snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nfsd lockd sun
rpc exportfs bridge ipv6 stp llc rc_dib0700_rc5 mt2060 btrfs
zlib_deflate cryptomgr aead crc32c libcrc32c crypto_hash crypto_algapi
dvb_usb_dib0700 dib7000p dib0090 dib7000m dib0070 dvb_usb
ir_lirc_codec lirc_dev dib8000 ir_sony_decoder ir_jvc_decoder dvb_core
ir_
rc6_decoder ir_rc5_decoder ir_nec_decoder dib3000mc rc_core
dibx000_common usb_storage uas vhost_net macvtap macvlan tun bitrev
kvm_
amd kvm snd_usb_audio snd_hwdep snd_usbmidi_lib cfq_iosched blk_cgroup
snd_rawmidi snd_seq_device cn mousedev usbmouse usbhid ata_ge
neric pata_acpi radeon snd_hda_codec_hdmi snd_hda_codec_via ttm
drm_kms_helper snd_hda_intel tpm_tis processor snd_hda_codec thermal
_sys sg pata_atiixp drm snd_pcm 8250_pnp tpm snd_timer sr_mod
i2c_piix4 firmware_class tpm_bios firewire_ohci firewire_core floppy a
sus_atk0110 8250 cdrom ohci_hcd backlight snd k10temp evdev
i2c_algo_bit uhci_hcd atkbd ehci_hcd hwmon cfbcopyarea cfbimgblt
soundco
re serio_raw button i2c_core snd_page_alloc usbcore rtc serial_core
cfbfillrect wmi crc_itu_t atl1e pcspkr unix ext4 crc16 jbd2 dm_m
od raid1 md_mod ahci libahci libata sd_mod crc_t10dif scsi_mod fbcon
font crc32 bitblit softcursor tileblit fb fbdev

Pid: 19814, comm: bcp Tainted: P            3.0.0 #7 System
manufacturer System Product Name/M4A78T-E
RIP: 0010:[<ffffffffa04efc50>]  [<ffffffffa04efc50>] 0xffffffffa04efc50
RSP: 0018:ffff8800a70cbc08  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: ffff880102981b00 RCX: 0000000000000000
RDX: 0000000000017000 RSI: 0000000000018000 RDI: ffff88020dc641d0
RBP: ffff880102981b48 R08: ffffe8ffffd01470 R09: 0000000000000174
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800a223d520
R13: ffff88017ffec090 R14: ffff88020d6c3800 R15: 0000000000018000
FS:  00007f38bf898700(0000) GS:ffff88021fd00000(0000) knlGS:00000000f741e6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001a211b8 CR3: 00000000af509000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bcp (pid: 19814, threadinfo ffff8800a70ca000, task ffff88016da0dda0)
Stack:
 ffff8800a70cbc30 ffff8800a223d520 ffff88017ffec090 ffff8800a223d520
 ffff88021edf91b0 0000000000000000 ffff8800a223d388 ffffffffa04aeb1f
 0000000000000045 ffffffffa04a065b 0000000000000053 ffff8800d80e9600
Call Trace:
 [<ffffffffa04aeb1f>] ? 0xffffffffa04aeb1f
 [<ffffffffa04a065b>] ? 0xffffffffa04a065b
 [<ffffffffa04d6718>] ? 0xffffffffa04d6718
 [<ffffffffa04d86cb>] ? 0xffffffffa04d86cb
 [<ffffffff810eb807>] ? 0xffffffff810eb807
 [<ffffffff810f73cc>] ? 0xffffffff810f73cc
 [<ffffffff810ebb7e>] ? 0xffffffff810ebb7e
 [<ffffffff810f78c9>] ? 0xffffffff810f78c9
 [<ffffffff812c2b7b>] ? 0xffffffff812c2b7b
Code: 08 01 00 00 41 29 c7 45 03 be 00 03 00 00 47 8d 3c 7f 4c 89 fa
e8 d1 f7 f9 ff 85 c0 75 0d 4c 89 7b 08 e9 3e ff ff ff 0f 1f 40
00 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 28 48
RIP  [<ffffffffa04efc50>] 0xffffffffa04efc50
 RSP <ffff8800a70cbc08>
---[ end trace 9accb228bee0d473 ]---
