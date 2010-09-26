From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3017!
Date: Sun, 26 Sep 2010 13:25:51 +0300
Message-ID: <AANLkTi=MFLT37cPTKe_SdYpNJsDvm5s7iYLKo+OF0=Sa@mail.gmail.com>
References: <AANLkTi=5uu+3_shYv9UGoJr7BQafBjZu48f8=_QNUCod@mail.gmail.com>
	<AANLkTimOAKdHv5mpzH6kw-8_BvyViK_94EAXVPbWH-QG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimOAKdHv5mpzH6kw-8_BvyViK_94EAXVPbWH-QG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This time kernel is  2.6.36-rc5-00151-g32163f4
no reverted commits no openafs module and
hopefully  enough debug information....

There are multiple warning:

---[ end trace bbbba72eccec168b ]---
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:87 __mark_inode_dirty+0x1da/0x220()
Hardware name: Ultra20 M2
Dirtiable inode bdi default !=3D sb bdi btrfs
Modules linked in: dm_mod tun bitrev crc32 kvm_amd kvm cn cfq_iosched
blk_cgroup sr_mod cdrom ata_generic radeon ttm d
rm_kms_helper drm snd_hda_codec_realtek firmware_class usbhid usbkbd
pata_acpi radeonfb fb fbdev fb_ddc snd_hda_intel
firewire_ohci backlight snd_hda_codec firewire_core rtc_cmos ehci_hcd
ohci_hcd atkbd i2c_algo_bit rtc_core cfbcopyarea
 usbcore i2c_nforce2 rtc_lib crc_itu_t cfbimgblt snd_pcm i2c_core
pata_amd sym53c8xx cfbfillrect serio_raw processor o
hci1394 ieee1394 container thermal sg scsi_transport_spi snd_timer
pcspkr evdev thermal_sys 8250_pnp tpm_tis snd 8250
k8temp serial_core tpm button soundcore tpm_bios snd_page_alloc
nls_base forcedeth hwmon unix btrfs libcrc32c crc32c c
rypto_hash crypto_algapi zlib_deflate raid1 md_mod sata_nv libata
sd_mod scsi_mod
Pid: 2300, comm: touch Tainted: G        W   2.6.36-rc5-00151-g32163f4 =
#2
Call Trace:
 [<ffffffff810421fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810422d1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffffa0156416>] ? btrfs_dirty_inode+0x76/0x110 [btrfs]
 [<ffffffff810ff2ea>] __mark_inode_dirty+0x1da/0x220
 [<ffffffffa015aed0>] btrfs_setattr+0x80/0x2a0 [btrfs]
 [<ffffffff810f59b1>] notify_change+0x111/0x2f0
 [<ffffffff81103770>] utimes_common+0xd0/0x1a0
 [<ffffffff811038d0>] do_utimes+0x90/0xf0
 [<ffffffff81103a51>] sys_utimensat+0x31/0xb0
 [<ffffffff8129b45f>] ? page_fault+0x1f/0x30
 [<ffffffff810023eb>] system_call_fastpath+0x16/0x1b
---[ end trace bbbba72eccec168c ]---
------------[ cut here ]------------


And oops right after using kvm cache=3Dnone


mapping failed logical 223936823296 bio len 28672 len 16384
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3017!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/usb2/2-10/speed
CPU 0
Modules linked in: vhost_net macvtap macvlan option usb_wwan usbserial
usb_storage ipv6 af_packet bridge stp llc dm_mo
d tun bitrev crc32 kvm_amd kvm cn cfq_iosched blk_cgroup sr_mod cdrom
ata_generic radeon ttm drm_kms_helper drm snd_hd
a_codec_realtek firmware_class usbhid usbkbd pata_acpi radeonfb fb
fbdev fb_ddc snd_hda_intel firewire_ohci backlight
snd_hda_codec firewire_core rtc_cmos ehci_hcd ohci_hcd atkbd
i2c_algo_bit rtc_core cfbcopyarea usbcore i2c_nforce2 rtc
_lib crc_itu_t cfbimgblt snd_pcm i2c_core pata_amd sym53c8xx
cfbfillrect serio_raw processor ohci1394 ieee1394 contain
er thermal sg scsi_transport_spi snd_timer pcspkr evdev thermal_sys
8250_pnp tpm_tis snd 8250 k8temp serial_core tpm b
utton soundcore tpm_bios snd_page_alloc nls_base forcedeth hwmon unix
btrfs libcrc32c crc32c crypto_hash crypto_algapi
 zlib_deflate raid1 md_mod sata_nv libata sd_mod scsi_mod

Pid: 4371, comm: qemu-system-x86 Tainted: G        W
2.6.36-rc5-00151-g32163f4 #2 Ultra20 M2/Ultra20 M2
RIP: 0010:[<ffffffffa0175a7e>]  [<ffffffffa0175a7e>]
btrfs_map_bio+0x1fe/0x210 [btrfs]
RSP: 0018:ffff8800d14a9918  EFLAGS: 00010292
RAX: 0000000000000042 RBX: 0000000000000000 RCX: 0000000000007fff
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff816d4eb4
RBP: ffff8800d14a9978 R08: 000000000002413f R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000003423acc000
R13: 0000000000007000 R14: 0000000000000001 R15: ffff8800e2113000
=46S:  00007f76494b2710(0000) GS:ffff880001800000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000505060 CR3: 00000000e2053000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu-system-x86 (pid: 4371, threadinfo ffff8800d14a8000, task
ffff880103f40d60)
Stack:
 fffffffffffffff6 00003423acb00080 ffff880110517000 0000000100000000
<0> ffff8800e38cd940 0000000000004000 ffff8800e38cd900 ffff8800e2113000
<0> ffff8800e38cd900 ffff8800e7a61e88 ffff880110517000 0000000000000000
Call Trace:
 [<ffffffffa015411c>] btrfs_submit_direct+0x12c/0x270 [btrfs]
 [<ffffffff8110cfac>] dio_bio_submit+0x6c/0xc0
 [<ffffffff8110d033>] dio_send_cur_page+0x33/0xc0
 [<ffffffff8110d120>] submit_page_section+0x60/0x160
 [<ffffffff8110d8b6>] __blockdev_direct_IO+0x506/0xaf0
 [<ffffffffa016b071>] ? btrfs_lookup_ordered_range+0x31/0x2c0 [btrfs]
 [<ffffffffa0153ea9>] btrfs_direct_IO+0x249/0x390 [btrfs]
 [<ffffffffa0157440>] ? btrfs_get_blocks_direct+0x0/0x490 [btrfs]
 [<ffffffffa0153ff0>] ? btrfs_submit_direct+0x0/0x270 [btrfs]
 [<ffffffffa01569b2>] ? btrfs_writepages+0x22/0x30 [btrfs]
 [<ffffffff8109af53>] generic_file_aio_read+0x693/0x700
 [<ffffffff8106ba00>] ? futex_wait+0x200/0x330
 [<ffffffff8109a8c0>] ? generic_file_aio_read+0x0/0x700
 [<ffffffff810dec0b>] do_sync_readv_writev+0xcb/0x110
 [<ffffffff810dea6e>] ? rw_copy_check_uvector+0xae/0x130
 [<ffffffff810df31f>] do_readv_writev+0xcf/0x1e0
 [<ffffffff81052b0b>] ? group_send_sig_info+0x3b/0x50
 [<ffffffff81052b5a>] ? kill_pid_info+0x3a/0x60
 [<ffffffff810df62b>] vfs_readv+0x3b/0x60
 [<ffffffff810df6ea>] sys_preadv+0x9a/0xb0
 [<ffffffff81047ade>] ? sys_gettimeofday+0x4e/0xb0
 [<ffffffff810023eb>] system_call_fastpath+0x16/0x1b
Code: c8 f5 e0 eb 8f 83 7e 64 00 0f 1f 40 00 0f 85 48 ff ff ff 0f 0b
eb fe 4c 89 ea 4c 89 e6 48 c7 c7 18 57 19 a0 31 c
0 e8 e3 29 12 e1 <0f> 0b eb fe 0f 0b eb fe 66 2e 0f 1f 84 00 00 00 00
00 55 48 89
RIP  [<ffffffffa0175a7e>] btrfs_map_bio+0x1fe/0x210 [btrfs]
 RSP <ffff8800d14a9918>
---[ end trace bbbba72eccec1699 ]---


-Markus




2010/9/25 J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com>:
> For your information, I guess this OOPS is useless without frame poin=
ters /
> debugging information.
>
> On Sat, Sep 25, 2010 at 3:26 PM, Markus Suvanto <markus.suvanto@gmail=
=2Ecom>
> wrote:
>>
>> Hi
>>
>> I get following oops when try to use kvm cache=3Dnone
>>
>> qemu-system-x86_64 ... -drive file=3Dimage.raw,cache=3Dnone,if=3Dvir=
tio,boot=3Don
>>
>>
>>
>> mapping failed logical 223936823296 bio len 28672 len 16384
>> ------------[ cut here ]------------
>> kernel BUG at fs/btrfs/volumes.c:3017!
>> invalid opcode: 0000 [#1] SMP
>> last sysfs file: /sys/kernel/mm/ksm/pages_shared
>> CPU 1
>> Modules linked in: vhost_net macvtap macvlan libafs(P) ipv6 af_packe=
t
>> bridge stp llc dm_mod
>> tun bitrev crc32 kvm_amd kvm cn cfq_iosched blk_cgroup ata_generic
>> sr_mod cdrom snd_hda_code
>> c_realtek usbhid usbkbd radeon ttm drm_kms_helper drm firmware_class
>> option usb_wwan usbseri
>> al usb_storage pata_acpi radeonfb snd_hda_intel fb snd_hda_codec fbd=
ev
>> firewire_ohci firewir
>> e_core fb_ddc crc_itu_t atkbd backlight snd_pcm sym53c8xx serio_raw
>> rtc_cmos rtc_core evdev
>> ohci_hcd ehci_hcd ohci1394 i2c_algo_bit scsi_transport_spi pata_amd =
sg
>> rtc_lib pcspkr therma
>> l snd_timer i2c_nforce2 usbcore cfbcopyarea snd ieee1394 cfbimgblt
>> processor cfbfillrect the
>> rmal_sys forcedeth soundcore container 8250_pnp tpm_tis k8temp 8250
>> i2c_core snd_page_alloc
>> tpm nls_base serial_core tpm_bios button hwmon unix btrfs libcrc32c
>> crc32c crypto_hash crypt
>> o_algapi zlib_deflate raid1 md_mod sata_nv libata sd_mod scsi_mod
>>
>> Pid: 18081, comm: qemu-system-x86 Tainted: P =C2=A0 M =C2=A0 =C2=A0W
>> 2.6.36-rc5-00087-gd7e7d7e #1 Ultra20
>> =C2=A0M2/Ultra20 M2
>> RIP: 0010:[<ffffffffa014050e>] =C2=A0[<ffffffffa014050e>] 0xffffffff=
a014050e
>> RSP: 0018:ffff8800b18d3998 =C2=A0EFLAGS: 00010296
>> RAX: 0000000000000042 RBX: 0000000000000000 RCX: 0000000000007fff
>> RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff813ffe54
>> RBP: ffff880110fcc3c0 R08: 000000000001d5f5 R09: 0000000000000000
>> R10: 0000000000000000 R11: 000000000000000d R12: 0000003423acc000
>> R13: 0000000000007000 R14: 0000000000000001 R15: 0000000000000001
>> FS: =C2=A000007f58cc83a710(0000) GS:ffff880001700000(0000)
>> knlGS:0000000000000000
>> CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000505060 CR3: 000000010ca4f000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process qemu-system-x86 (pid: 18081, threadinfo ffff8800b18d2000, ta=
sk
>> ffff8801131471b0)
>> Stack:
>> =C2=A0ffff88010f1edd00 ffff88010f1edd30 ffff880108af1000 00003423acb=
00080
>> <0> ffff88002702a240 0000000000004000 ffff88010c994000 ffff880110fcc=
3c0
>> <0> ffff88002702a5c0 ffff88010f1ede88 ffff880108af1000 0000000000000=
000
>> Call Trace:
>> =C2=A0[<ffffffffa011e1e9>] ? 0xffffffffa011e1e9
>> =C2=A0[<ffffffff811031a9>] ? 0xffffffff811031a9
>> =C2=A0[<ffffffff8110322b>] ? 0xffffffff8110322b
>> =C2=A0[<ffffffff81103311>] ? 0xffffffff81103311
>> =C2=A0[<ffffffff81103abf>] ? 0xffffffff81103abf
>> =C2=A0[<ffffffffa013a81a>] ? 0xffffffffa013a81a
>> =C2=A0[<ffffffffa011df85>] ? 0xffffffffa011df85
>> =C2=A0[<ffffffffa0121570>] ? 0xffffffffa0121570
>> =C2=A0[<ffffffffa011e0c0>] ? 0xffffffffa011e0c0
>> =C2=A0[<ffffffffa0120ce0>] ? 0xffffffffa0120ce0
>> =C2=A0[<ffffffff8109319d>] ? 0xffffffff8109319d
>> =C2=A0[<ffffffff81092b60>] ? 0xffffffff81092b60
>> =C2=A0[<ffffffff810d5d69>] ? 0xffffffff810d5d69
>> =C2=A0[<ffffffff8106711b>] ? 0xffffffff8106711b
>> =C2=A0[<ffffffff81068dd3>] ? 0xffffffff81068dd3
>> =C2=A0[<ffffffff810d5baf>] ? 0xffffffff810d5baf
>> =C2=A0[<ffffffff810d644f>] ? 0xffffffff810d644f
>> =C2=A0[<ffffffff8104eb08>] ? 0xffffffff8104eb08
>> =C2=A0[<ffffffff8104ed84>] ? 0xffffffff8104ed84
>> =C2=A0[<ffffffff810d6843>] ? 0xffffffff810d6843
>> =C2=A0[<ffffffff810023eb>] ? 0xffffffff810023eb
>> Code: 20 e8 a7 90 f8 e0 eb 87 83 7e 64 00 90 0f 85 45 ff ff ff 0f 0b
>> eb fe 4c 89 ea 4c 89 e6
>> =C2=A048 c7 c7 38 fd 15 a0 31 c0 e8 72 65 14 e1 <0f> 0b eb fe 0f 0b =
eb fe
>> 66 2e 0f 1f 84 00 00 00
>> =C2=A000 00 41 54 55
>> RIP =C2=A0[<ffffffffa014050e>] 0xffffffffa014050e
>> =C2=A0RSP <ffff8800b18d3998>
>> ---[ end trace 33dc5bb4824a0127 ]---
>>
>> Kernel is 2.6.36-rc5-00087-gd7e7d7e
>>
>> -Markus Suvanto
>>
>>
>>
>> commit d7e7d7eb1c61772662d17f6636e48a87baf7eb56
>> Author: root <root@masu.station.com>
>> Date: =C2=A0 Fri Sep 24 19:09:17 2010 +0300
>>
>> =C2=A0 =C2=A0Revert "bdi: Fix warnings in __mark_inode_dirty for /de=
v/zero and
>> friends"
>>
>> =C2=A0 =C2=A0This reverts commit 692ebd17c2905313fff3c504c249c6a0faa=
d16ec.
>>
>> commit a850ea30374ebed32a0724742601861853fde869
>> Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Date: =C2=A0 Fri Sep 10 13:23:06 2010 +0900
>>
>> =C2=A0 =C2=A0hugetlb, rmap: add BUG_ON(!PageLocked) in hugetlb_add_a=
non_rmap()
>>
>> =C2=A0 =C2=A0Confirming page lock is held in hugetlb_add_anon_rmap()=
 may be useful
>> =C2=A0 =C2=A0to detect possible future problems.
>>
>> =C2=A0 =C2=A0Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.c=
om>
>> =C2=A0 =C2=A0Acked-by: Rik van Riel <riel@redhat.com>
>> =C2=A0 =C2=A0Acked-by: Andrea Arcangeli <aarcange@redhat.com>
>> =C2=A0 =C2=A0Signed-off-by: Linus Torvalds <torvalds@linux-foundatio=
n.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
