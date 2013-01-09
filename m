Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f182.google.com ([209.85.161.182]:51288 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab3AIRF5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 12:05:57 -0500
Received: by mail-gg0-f182.google.com with SMTP id e5so365525ggh.41
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2013 09:05:56 -0800 (PST)
Date: Wed, 9 Jan 2013 14:59:25 -0200
From: Renato Zannon <renato.riccieri@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/inode.c:881 (3.6.11-1-ARCH)
Message-ID: <20130109165925.GB2285@zannon-ultrabook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

My laptop was under normal load when I was thrown to the TTY with a
stack trace (pasted at the end of the message).

After a reboot, everything was ok, I haven't noticed anything unusual.

About my setup:

I have a single 128GB SSD, with 3 partitions, 2 of them (my / and /home) be=
ing
btrfs, with zlib compression enabled. I've never had any other devices
attached, and never touched the 'advanced' features of btrfs.

The machine is fairly new (between 2 and 3 weeks), and were created
using the latest (non-testing) Arch Linux kernel from back then.

I run fstrim on a daily cron job, and have autodefrag enabled.

=46rom my very limited knowledge, that's all the relevant information I
have. If there's anything else I can do I would be glad to help.

[ 3850.907821] ------------[ cut here ]------------
[ 3850.907905] kernel BUG at fs/btrfs/inode.c:881!
[ 3850.907970] invalid opcode: 0000 [#1] PREEMPT SMP=20
[ 3850.908052] Modules linked in: fuse btusb bluetooth zram(C) uvcvideo vid=
eobuf2_vmalloc videobuf2_memops videobuf2_core videodev media snd_hda_codec=
_hdmi snd_hda_codec_realtek joydev ext4 crc16 jbd2 mbcache coretemp kvm_int=
el kvm ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic ablk_helper c=
ryptd arc4 iwldvm mac80211 iTCO_wdt iTCO_vendor_support samsung_laptop evde=
v microcode iwlwifi pcspkr psmouse serio_raw snd_hda_intel snd_hda_codec sn=
d_hwdep i915 i2c_i801 lpc_ich snd_pcm cfg80211 r8169 snd_page_alloc mii snd=
_timer rfkill snd soundcore intel_agp intel_gtt mei drm_kms_helper drm i2c_=
algo_bit i2c_core battery video wmi acpi_cpufreq mperf fan ac thermal butto=
n processor btrfs libcrc32c zlib_deflate sd_mod ahci crc32c_intel libahci x=
hci_hcd libata scsi_mod ehci_hcd usbcore usb_common
[ 3850.909356] CPU 1=20
[ 3850.909393] Pid: 1133, comm: flush-btrfs-2 Tainted: G         C   3.6.11=
-1-ARCH #1 SAMSUNG ELECTRONICS CO., LTD. 900X3B/900X4B/900X3B/900X4B
[ 3850.909557] RIP: 0010:[<ffffffffa0144ee5>]  [<ffffffffa0144ee5>] cow_fil=
e_range+0x495/0x4d0 [btrfs]
[ 3850.909712] RSP: 0018:ffff88010a6e56a0  EFLAGS: 00010286
[ 3850.909783] RAX: ffff880105b5c000 RBX: ffff88010a6e5a18 RCX: 00000000008=
e6fff
[ 3850.909876] RDX: ffff88010a506000 RSI: ffff88010a506000 RDI: ffff8801177=
9e088
[ 3850.909970] RBP: ffff88010a6e5760 R08: ffff88010a6e5a04 R09: ffff88010a6=
e5a18
[ 3850.910063] R10: ffffffffffff1fff R11: 0000000000000001 R12: fffffffffff=
f2000
[ 3850.910155] R13: 00000000008f5000 R14: 0000000000001000 R15: ffff88005b1=
6a600
[ 3850.910250] FS:  0000000000000000(0000) GS:ffff88011f240000(0000) knlGS:=
0000000000000000
[ 3850.910355] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3850.910431] CR2: 00007fe8587a6008 CR3: 000000000180c000 CR4: 00000000000=
407e0
[ 3850.910523] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 3850.910617] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 3850.910711] Process flush-btrfs-2 (pid: 1133, threadinfo ffff88010a6e400=
0, task ffff880037a6a850)
[ 3850.910823] Stack:
[ 3850.910856]  0000000000000000 ffff88009b0ba0a0 0000000000000282 ffff8801=
081ca000
[ 3850.911042]  00000000008e6fff ffff88005b16a448 ffff88010a6e5710 ffffea00=
040b8e00
[ 3850.911220]  ffff88011779e088 ffff88010a506000 ffff88011757b990 ffff8801=
0a6e5a04
[ 3850.911336] Call Trace:
[ 3850.911412]  [<ffffffffa0158ef7>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 3850.911538]  [<ffffffffa01455ed>] run_delalloc_nocow+0x6cd/0xa50 [btrfs]
[ 3850.911651]  [<ffffffffa0145cc4>] run_delalloc_range+0x354/0x3a0 [btrfs]
[ 3850.911765]  [<ffffffffa0157941>] __extent_writepage+0x341/0x7c0 [btrfs]
[ 3850.911875]  [<ffffffffa0156b30>] ? end_extent_writepage+0x70/0x70 [btrf=
s]
[ 3850.911988]  [<ffffffffa01580ca>] extent_write_cache_pages.isra.26.const=
prop.43+0x30a/0x410 [btrfs]
[ 3850.912126]  [<ffffffffa0158426>] extent_writepages+0x46/0x60 [btrfs]
[ 3850.912260]  [<ffffffffa0141400>] ? btrfs_writepage+0x70/0x70 [btrfs]
[ 3850.912369]  [<ffffffffa0140608>] btrfs_writepages+0x28/0x30 [btrfs]
[ 3850.912460]  [<ffffffff81128a01>] do_writepages+0x21/0x50
[ 3850.912538]  [<ffffffff811a90bb>] __writeback_single_inode.isra.31+0x3b/=
0x190
[ 3850.912637]  [<ffffffff8107a1be>] ? wake_up_bit+0x2e/0x40
[ 3850.912713]  [<ffffffff811a989a>] writeback_sb_inodes+0x2ba/0x4a0
[ 3850.912798]  [<ffffffff811a9b1f>] __writeback_inodes_wb+0x9f/0xd0
[ 3850.912882]  [<ffffffff811a9e63>] wb_writeback+0x313/0x340
[ 3850.912960]  [<ffffffff811aa978>] wb_do_writeback+0x258/0x260
[ 3850.913040]  [<ffffffff811aaa13>] bdi_writeback_thread+0x93/0x2d0
[ 3850.913124]  [<ffffffff811aa980>] ? wb_do_writeback+0x260/0x260
[ 3850.913205]  [<ffffffff81079a73>] kthread+0x93/0xa0
[ 3850.913278]  [<ffffffff8149b704>] kernel_thread_helper+0x4/0x10
[ 3850.913361]  [<ffffffff810799e0>] ? kthread_freezable_should_stop+0x70/0=
x70
[ 3850.913456]  [<ffffffff8149b700>] ? gs_change+0x13/0x13
[ 3850.913524] Code: ff ff ff 48 8b 45 98 49 81 c2 00 10 00 00 49 c1 ea 0c =
4c 01 13 c7 00 01 00 00 00 e9 df fe ff ff 49 8b 57 40 e9 4d ff ff ff 0f 0b =
<0f> 0b 0f 0b 48 8b b5 68 ff ff ff 4c 8b 85 78 ff ff ff 41 b9 3f=20
[ 3850.914058] RIP  [<ffffffffa0144ee5>] cow_file_range+0x495/0x4d0 [btrfs]
[ 3850.914173]  RSP <ffff88010a6e56a0>
[ 3850.951718] ---[ end trace 480e17a8f51ef3a3 ]---

--
@renato_bill
Renato Zannon

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQ7aHtAAoJEGwmivZ159YuVQoH/3+HJBuRnUGU4rjGnDDH0Vho
dFzjsV8il03c0NwWa0YeRfrRlViv/L4R4gZXGiKptPtlDNWyLlXF/afh/VMquY3L
ryqT0Zy5AkFlLbx3DdNGiLssqlKaCpQD67YWFuJ9na/k43fJiOUTmuYoUvOuLYZG
R+xMpT4w6q/vGmYbX7lrJhygBaGrrcADAnAFeDXEVf98Gd9xlp6v6SzlO4KHdlg3
wznA90ua+M1/VEnoNe3qJ3o1Ux+QUdCu77QSqi+I3MncEv5ZBTBMuMrTWtQXL3Kn
rPx7R7zcN0yl+LR7zFRF0vQv0EogX9tlnKGpBKY9uOVBmLjRdUHOgd0yyBAdJNM=
=2S6c
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
