From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: kernel BUG at fs/btrfs/volumes.c:3017!
Date: Sat, 25 Sep 2010 22:26:56 +0300
Message-ID: <AANLkTi=5uu+3_shYv9UGoJr7BQafBjZu48f8=_QNUCod@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I get following oops when try to use kvm cache=none

qemu-system-x86_64 ... -drive file=image.raw,cache=none,if=virtio,boot=on



mapping failed logical 223936823296 bio len 28672 len 16384
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3017!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/kernel/mm/ksm/pages_shared
CPU 1
Modules linked in: vhost_net macvtap macvlan libafs(P) ipv6 af_packet
bridge stp llc dm_mod
tun bitrev crc32 kvm_amd kvm cn cfq_iosched blk_cgroup ata_generic
sr_mod cdrom snd_hda_code
c_realtek usbhid usbkbd radeon ttm drm_kms_helper drm firmware_class
option usb_wwan usbseri
al usb_storage pata_acpi radeonfb snd_hda_intel fb snd_hda_codec fbdev
firewire_ohci firewir
e_core fb_ddc crc_itu_t atkbd backlight snd_pcm sym53c8xx serio_raw
rtc_cmos rtc_core evdev
ohci_hcd ehci_hcd ohci1394 i2c_algo_bit scsi_transport_spi pata_amd sg
rtc_lib pcspkr therma
l snd_timer i2c_nforce2 usbcore cfbcopyarea snd ieee1394 cfbimgblt
processor cfbfillrect the
rmal_sys forcedeth soundcore container 8250_pnp tpm_tis k8temp 8250
i2c_core snd_page_alloc
tpm nls_base serial_core tpm_bios button hwmon unix btrfs libcrc32c
crc32c crypto_hash crypt
o_algapi zlib_deflate raid1 md_mod sata_nv libata sd_mod scsi_mod

Pid: 18081, comm: qemu-system-x86 Tainted: P   M    W
2.6.36-rc5-00087-gd7e7d7e #1 Ultra20
 M2/Ultra20 M2
RIP: 0010:[<ffffffffa014050e>]  [<ffffffffa014050e>] 0xffffffffa014050e
RSP: 0018:ffff8800b18d3998  EFLAGS: 00010296
RAX: 0000000000000042 RBX: 0000000000000000 RCX: 0000000000007fff
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff813ffe54
RBP: ffff880110fcc3c0 R08: 000000000001d5f5 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000000000d R12: 0000003423acc000
R13: 0000000000007000 R14: 0000000000000001 R15: 0000000000000001
FS:  00007f58cc83a710(0000) GS:ffff880001700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000505060 CR3: 000000010ca4f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu-system-x86 (pid: 18081, threadinfo ffff8800b18d2000, task
ffff8801131471b0)
Stack:
 ffff88010f1edd00 ffff88010f1edd30 ffff880108af1000 00003423acb00080
<0> ffff88002702a240 0000000000004000 ffff88010c994000 ffff880110fcc3c0
<0> ffff88002702a5c0 ffff88010f1ede88 ffff880108af1000 0000000000000000
Call Trace:
 [<ffffffffa011e1e9>] ? 0xffffffffa011e1e9
 [<ffffffff811031a9>] ? 0xffffffff811031a9
 [<ffffffff8110322b>] ? 0xffffffff8110322b
 [<ffffffff81103311>] ? 0xffffffff81103311
 [<ffffffff81103abf>] ? 0xffffffff81103abf
 [<ffffffffa013a81a>] ? 0xffffffffa013a81a
 [<ffffffffa011df85>] ? 0xffffffffa011df85
 [<ffffffffa0121570>] ? 0xffffffffa0121570
 [<ffffffffa011e0c0>] ? 0xffffffffa011e0c0
 [<ffffffffa0120ce0>] ? 0xffffffffa0120ce0
 [<ffffffff8109319d>] ? 0xffffffff8109319d
 [<ffffffff81092b60>] ? 0xffffffff81092b60
 [<ffffffff810d5d69>] ? 0xffffffff810d5d69
 [<ffffffff8106711b>] ? 0xffffffff8106711b
 [<ffffffff81068dd3>] ? 0xffffffff81068dd3
 [<ffffffff810d5baf>] ? 0xffffffff810d5baf
 [<ffffffff810d644f>] ? 0xffffffff810d644f
 [<ffffffff8104eb08>] ? 0xffffffff8104eb08
 [<ffffffff8104ed84>] ? 0xffffffff8104ed84
 [<ffffffff810d6843>] ? 0xffffffff810d6843
 [<ffffffff810023eb>] ? 0xffffffff810023eb
Code: 20 e8 a7 90 f8 e0 eb 87 83 7e 64 00 90 0f 85 45 ff ff ff 0f 0b
eb fe 4c 89 ea 4c 89 e6
 48 c7 c7 38 fd 15 a0 31 c0 e8 72 65 14 e1 <0f> 0b eb fe 0f 0b eb fe
66 2e 0f 1f 84 00 00 00
 00 00 41 54 55
RIP  [<ffffffffa014050e>] 0xffffffffa014050e
 RSP <ffff8800b18d3998>
---[ end trace 33dc5bb4824a0127 ]---

Kernel is 2.6.36-rc5-00087-gd7e7d7e

-Markus Suvanto



commit d7e7d7eb1c61772662d17f6636e48a87baf7eb56
Author: root <root@masu.station.com>
Date:   Fri Sep 24 19:09:17 2010 +0300

    Revert "bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends"

    This reverts commit 692ebd17c2905313fff3c504c249c6a0faad16ec.

commit a850ea30374ebed32a0724742601861853fde869
Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date:   Fri Sep 10 13:23:06 2010 +0900

    hugetlb, rmap: add BUG_ON(!PageLocked) in hugetlb_add_anon_rmap()

    Confirming page lock is held in hugetlb_add_anon_rmap() may be useful
    to detect possible future problems.

    Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    Acked-by: Rik van Riel <riel@redhat.com>
    Acked-by: Andrea Arcangeli <aarcange@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
