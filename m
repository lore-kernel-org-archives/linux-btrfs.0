Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36370 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbcGPMPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 08:15:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 64A7E202C1
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Jul 2016 08:15:54 -0400 (EDT)
Received: from [192.168.1.129] (unknown [2.235.201.237])
	by mail.messagingengine.com (Postfix) with ESMTPA id DC5D8F29FF
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Jul 2016 08:15:53 -0400 (EDT)
From: Francesco Turco <fturco@fastmail.fm>
Subject: Kernel bug detected in journalctl
To: linux-btrfs@vger.kernel.org
Message-ID: <1f4ea2f9-a565-7e31-2da0-e6cca5bb5ea9@fastmail.fm>
Date: Sat, 16 Jul 2016 14:15:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I discovered error messages in my systemd log after my computer froze a
couple of times.

This is the relevant part from journalctl:

Jul 16 12:24:01 desktop kernel: BTRFS error (device dm-3): err add
delayed dir index item(index: 71778) into the deletion tree of the
delayed node(root id: 5, inode id: 1050941, errno: -17)
Jul 16 12:24:01 desktop kernel: ------------[ cut here ]------------
Jul 16 12:24:01 desktop kernel: kernel BUG at fs/btrfs/delayed-inode.c:1579!
Jul 16 12:24:01 desktop kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Jul 16 12:24:01 desktop kernel: Modules linked in: fuse mei_wdt coretemp
gpio_ich iTCO_wdt iTCO_vendor_support nouveau ppdev psmouse serio_raw
mxm_wmi wmi video ttm drm_kms_helper evdev drm syscopyarea input_leds
mousedev sysfillrect sysimgblt kvm_intel fb_sys_fops i2c_algo_bit kvm
irqbypass led_class pcspkr mac_hid i2c_i801 acpi_cpufreq
snd_hda_codec_hdmi lpc_ich tpm_tis tpm parport_pc parport e1000e fjes
snd_hda_codec_realtek snd_hda_codec_generic ptp snd_hda_intel
snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd soundcore
shpchp pps_core mei_me mei intel_agp intel_gtt processor button
sch_fq_codel ip_tables x_tables xts gf128mul algif_skcipher af_alg
dm_crypt dm_mod hid_generic usbhid hid uas usb_storage crc32c_generic
btrfs xor ata_generic pata_acpi raid6_pq atkbd libps2 uhci_hcd
firewire_ohci firewire_core
Jul 16 12:24:01 desktop kernel:  crc_itu_t pata_marvell ehci_pci
ehci_hcd usbcore usb_common i8042 serio ext4 crc16 jbd2 mbcache sd_mod
ahci libahci libata scsi_mod
Jul 16 12:24:01 desktop kernel: CPU: 1 PID: 12815 Comm: QThread Not
tainted 4.6.3-gnu-1 #1
Jul 16 12:24:01 desktop kernel: Hardware name:                  /DQ35JO,
BIOS JOQ3510J.86A.1143.2010.1209.0048 12/09/2010
Jul 16 12:24:01 desktop kernel: task: ffff880196010000 ti:
ffff880069dec000 task.ti: ffff880069dec000
Jul 16 12:24:01 desktop kernel: RIP: 0010:[<ffffffffa0329cb5>]
[<ffffffffa0329cb5>] btrfs_delete_delayed_dir_index+0x1f5/0x200 [btrfs]
Jul 16 12:24:01 desktop kernel: RSP: 0018:ffff880069defd38  EFLAGS: 00010246
Jul 16 12:24:01 desktop kernel: RAX: 0000000000000000 RBX:
ffff880067139560 RCX: 0000000000000000
Jul 16 12:24:01 desktop kernel: RDX: 0000000000000000 RSI:
ffff88022bc8db98 RDI: ffff88022bc8db98
Jul 16 12:24:01 desktop kernel: RBP: ffff880069defd88 R08:
0000000000000389 R09: 0000000000000005
Jul 16 12:24:01 desktop kernel: R10: 0000000000000000 R11:
ffffffff81a746ad R12: ffff8800671395a8
Jul 16 12:24:01 desktop kernel: R13: ffff88021dbd4000 R14:
0000000000011862 R15: ffff8801980e3f80
Jul 16 12:24:01 desktop kernel: FS:  00007f71abfff700(0000)
GS:ffff88022bc80000(0000) knlGS:0000000000000000
Jul 16 12:24:01 desktop kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jul 16 12:24:01 desktop kernel: CR2: 00007f95cc000000 CR3:
000000006a078000 CR4: 00000000000406e0
Jul 16 12:24:01 desktop kernel: Stack:
Jul 16 12:24:01 desktop kernel:  ffff880221a23be0 3dff8800b692da78
6000000000001009 0000000000011862
Jul 16 12:24:01 desktop kernel:  000000001f383142 ffff88006715ba38
ffff8800b692da78 00000000002c3a16
Jul 16 12:24:01 desktop kernel:  000000000010093d ffff880067206070
ffff880069defe10 ffffffffa02d6f81
Jul 16 12:24:01 desktop kernel: Call Trace:
Jul 16 12:24:01 desktop kernel:  [<ffffffffa02d6f81>]
__btrfs_unlink_inode+0x1b1/0x470 [btrfs]
Jul 16 12:24:01 desktop kernel:  [<ffffffffa02daa0c>]
btrfs_unlink_inode+0x1c/0x40 [btrfs]
Jul 16 12:24:01 desktop kernel:  [<ffffffffa02daa9b>]
btrfs_unlink+0x6b/0xc0 [btrfs]
Jul 16 12:24:01 desktop kernel:  [<ffffffff81200297>] vfs_unlink+0x117/0x1a0
Jul 16 12:24:01 desktop kernel:  [<ffffffff8120549c>]
do_unlinkat+0x27c/0x2f0
Jul 16 12:24:01 desktop kernel:  [<ffffffff81205cc6>] SyS_unlink+0x16/0x20
Jul 16 12:24:01 desktop kernel:  [<ffffffff815c51f2>]
entry_SYSCALL_64_fastpath+0x1a/0xa4
Jul 16 12:24:01 desktop kernel: Code: ff ff 0f 0b 48 8b 53 10 49 8b bd
f0 01 00 00 41 89 c1 4c 8b 03 48 c7 c6 50 cc 35 a0 48 8b 8a 48 03 00 00
4c 89 f2 e8 1b 56 f7 ff <0f> 0b e8 14 e7 d4 e0 0f 1f 40 00 66 66 66 66
90 55 48 89 e5 53
Jul 16 12:24:01 desktop kernel: RIP  [<ffffffffa0329cb5>]
btrfs_delete_delayed_dir_index+0x1f5/0x200 [btrfs]
Jul 16 12:24:01 desktop kernel:  RSP <ffff880069defd38>
Jul 16 12:24:01 desktop kernel: ---[ end trace 86b4a59cf9b82060 ]---

I checked my btrfs partitions with "btrfs check" and fortunately they
seem OK.

Device dm-3 is my home partition.

# btrfs filesystem show /home
Label: none  uuid: f5392b4f-5d1c-4c7d-89e6-0324c2860a73
	Total devices 1 FS bytes used 219.82GiB
	devid    1 size 400.00GiB used 228.06GiB path /dev/mapper/Desktop-home

I'm using linux 4.6.3 and btrfs-progs 4.6.1 on a Parabola
GNU/Linux-libre system. Please notice that I formatted my btrfs
partitions with a live usb that may have slightly different (older)
package versions.

Please tell me if you need other details.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
