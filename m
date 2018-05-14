Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbeENCIp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 May 2018 22:08:45 -0400
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
Date: Mon, 14 May 2018 10:08:38 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BIj6b8oBMYKQW3lbiD2LDiA8BozRuYXS0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BIj6b8oBMYKQW3lbiD2LDiA8BozRuYXS0
Content-Type: multipart/mixed; boundary="m4dRdXcITnzMPE1p6LV4itWbA2JocsTF6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
In-Reply-To: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>

--m4dRdXcITnzMPE1p6LV4itWbA2JocsTF6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8812=E6=97=A5 13:08, james harvey wrote:
> 100% reproducible, booting from disk, or even Arch installation ISO.
> Kernel 4.16.7.  btrfs-progs v4.16.
>=20
> Reading one of two journalctl files causes a kernel oops.  Initially
> ran into it from "journalctl --list-boots", but cat'ing the file does
> it too.  I believe this shows there's compressed data that is invalid,
> but its btrfs checksum is invalid.  I've cat'ed every file on the
> disk, and luckily have the problems narrowed down to only these 2
> files in /var/log/journal.
>=20
> This volume has always been mounted with lzo compression.
>=20
> scrub has never found anything, and have ran it since the oops.
>=20
> Found a user a few years ago who also ran into this, without
> resolution, at:
> https://www.spinics.net/lists/linux-btrfs/msg52218.html
>=20
> 1. Cat'ing a (non-essential) file shouldn't be able to bring down the s=
ystem.
>=20
> 2. If this is infact invalid compressed data, there should be a way to
> check for that.  Btrfs check and scrub pass.

Btrfs check ensure no obvious metadata corruption and all its cross
reference should be OK.
(Unless we find new bugs in btrfs check)

And scrub ensure all tree blocks and data extent with csum matches their
csum.

>=20
> Hardware is fine.  Passes memtest86+ in SMP mode.  Works fine on all
> other files.
>=20
>=20
>=20
> [  381.869940] BUG: unable to handle kernel paging request at 000000000=
0390e50
> [  381.870881] BTRFS: decompress failed
> [  381.891775] IP: rebalance_domains+0x8a/0x2c0

The interesting part here is, btrfs is not showing up the call trace,
not even lzo code.
(Despite of the "decompress failed" message).
Maybe some corrupted data is screwing up some random kernel memory?

Would you please get the inode number of that corrupted files, and throw
it through btrfs-debug-tree?

# btrfs-debug-tree -t <subvol_id> <device> | grep -A 50 \(<INO>

This is the preferred method as it would provide all the details we
need. But since it could contain sensitive info like filename, please
double check before posting it.

Or fiemap of that file could also help:

# xfs_io -c "fiemap -v" <corrupted_file>

This is completely safe, but I'm not 100% sure about if the info is enoug=
h.

Thanks,
Qu

> [  381.891776] PGD 0 P4D 0
> [  381.891780] Oops: 0000 [#1] PREEMPT SMP PTI
> [  381.891782] Modules linked in:
> [  381.891784] BTRFS: decompress failed
> [  381.891784]  8021q mrp wl(PO) btrfs dm_thin_pool ast
> [  381.891788] BTRFS: decompress failed
> [  381.891789]  dm_persistent_data dm_bio_prison dm_bufio libcrc32c
> i2c_algo_bit crc32c_generic intel_rapl ttm sb_edac zstd_compress
> drm_kms_helper xor x86_pkg_temp_thermal intel_powerclamp drm raid6_pq
> raid1 agpgart coretemp md_mod cfg80211 syscopyarea sysfillrect
> kvm_intel dm_mod sysimgblt kvm fb_sys_fops joydev irqbypass rfkill
> iTCO_wdt iTCO_vendor_support crct10dif_pclmul ghash_clmulni_intel
> ipmi_ssif rtc_cmos ipmi_si intel_cstate mei_me ipmi_devintf
> intel_uncore ipmi_msghandler shpchp pcspkr mousedev input_leds
> led_class psmouse intel_rapl_perf lpc_ich mei i2c_i801 evdev mac_hid
> ip_tables x_tables overlay squashfs zstd_decompress xxhash loop isofs
> sr_mod cdrom sd_mod
> [  381.891835] BTRFS: decompress failed
> [  381.891835]  hid_generic usbhid hid uas usb_storage
> [  381.891838] BTRFS: decompress failed
> [  381.891838]  serio_raw atkbd libps2 crc32_pclmul
> [  381.891840] BTRFS: decompress failed
> [  381.891841]  crc32c_intel isci ahci aesni_intel
> [  381.891843] BTRFS: decompress failed
> [  381.891843]  aes_x86_64 libsas libahci crypto_simd
> [  381.891845] BTRFS: decompress failed
> [  381.891845]  ehci_pci ehci_hcd cryptd glue_helper
> [  381.891847] BTRFS: decompress failed
> [  381.891847]  libata scsi_transport_sas e1000e mlx4_core usbcore ptp
> pps_core scsi_mod usb_common devlink wmi i8042 serio
> [  381.891855] CPU: 11 PID: 0 Comm: swapper/11 Tainted: P           O
>    4.16.7-1-ARCH #1
> [  381.891856] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./EP2C602, BIOS P1.80 12/09/2013
> [  381.891858] RIP: 0010:rebalance_domains+0x8a/0x2c0
> [  381.891859] RSP: 0018:ffff8e6c5f2c3f08 EFLAGS: 00010206
> [  381.891860] RAX: 0000000000000000 RBX: 0000000000390de8 RCX: 0000000=
000000005
> [  381.891861] RDX: 0000000100005ff2 RSI: 000000000000024d RDI: 0000001=
333333340
> [  381.891862] RBP: 0000000100005ff4 R08: 0000000000000000 R09: 0000000=
000000001
> [  381.891863] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000=
000000001
> [  381.891863] R13: 0000000000000000 R14: 0000000000000001 R15: 00bd780=
1f8e8a9c8
> [  381.891865] FS:  0000000000000000(0000) GS:ffff8e6c5f2c0000(0000)
> knlGS:0000000000000000
> [  381.891865] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  381.891866] CR2: 0000000000390e50 CR3: 0000000e6100a004 CR4: 0000000=
0000606e0
> [  381.891867] Call Trace:
> [  381.891870]  <IRQ>
> [  381.891875]  __do_softirq+0xf1/0x2e0
> [  381.891880]  irq_exit+0xc9/0xe0
> [  381.903429] BTRFS: decompress failed
> [  381.916574]  smp_apic_timer_interrupt+0x73/0x160
> [  381.916576]  apic_timer_interrupt+0xf/0x20
> [  381.916578]  </IRQ>
> [  381.916581] RIP: 0010:cpuidle_enter_state+0xb6/0x2e0
> [  381.916582] RSP: 0018:ffff939f863fbea8 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffff12
> [  381.916583] RAX: ffff8e6c5f2c0000 RBX: 00000058e9388d6f RCX: 0000000=
00000001f
> [  381.916584] RDX: 00000058e9388d6f RSI: ffffffff96e70d54 RDI: fffffff=
f96e70fb2
> [  381.916585] RBP: ffff8e6c5f2ebe00 R08: 000002044b2e9556 R09: 0000000=
00000337b
> [  381.916585] R10: 000000000000471b R11: ffff8e6c5f2e07c4 R12: 0000000=
000000003
> [  381.916586] R13: ffffffff970ae338 R14: 00000058e9215560 R15: 0000000=
000000000
> [  381.916591]  ? cpuidle_enter_state+0x94/0x2e0
> [  381.916593]  do_idle+0x193/0x1b0
> [  381.916595]  cpu_startup_entry+0x6f/0x80
> [  381.916599]  start_secondary+0x1a5/0x200
> [  381.916602]  secondary_startup_64+0xa5/0xb0
> [  381.916603] Code: 46 00 00 48 03 04 d5 40 f4
> [  381.924842] BTRFS: decompress failed
> [  381.937936] ee 96 48 8b 98 c0 09 00 00 48 85 db 0f 84 32 02 00 00
> 45 31 ff 45 31 f6 45 31 e4 48 8b 15 e6 aa f4 00 <48> 8b 43 68 48 39 53
> 70 79 2e 48 89 c2 41 be 01 00 00 00 48 c1
> [  381.937956] RIP: rebalance_domains+0x8a/0x2c0 RSP: ffff8e6c5f2c3f08
> [  381.937957] CR2: 0000000000390e50
> [  381.937976] ---[ end trace 5c92a4d96e28b9b3 ]---
> [  381.937977] BUG: unable to handle kernel paging request at 000000000=
0395370
> [  381.937982] IP: load_balance+0x71e/0x9b0
> [  381.937982] PGD 0 P4D 0
> [  381.937985] Oops: 0000 [#2] PREEMPT SMP PTI
> [  381.937986] Modules linked in: 8021q mrp wl(PO) btrfs dm_thin_pool
> ast dm_persistent_data dm_bio_prison dm_bufio libcrc32c i2c_algo_bit
> crc32c_generic intel_rapl ttm sb_edac zstd_compress drm_kms_helper xor
> x86_pkg_temp_thermal intel_powerclamp drm raid6_pq raid1 agpgart
> coretemp md_mod cfg80211 syscopyarea sysfillrect kvm_intel dm_mod
> sysimgblt kvm fb_sys_fops joydev irqbypass rfkill iTCO_wdt
> iTCO_vendor_support crct10dif_pclmul ghash_clmulni_intel ipmi_ssif
> rtc_cmos ipmi_si intel_cstate mei_me ipmi_devintf intel_uncore
> ipmi_msghandler shpchp pcspkr mousedev input_leds led_class psmouse
> intel_rapl_perf lpc_ich mei i2c_i801 evdev mac_hid ip_tables x_tables
> overlay squashfs zstd_decompress xxhash loop isofs sr_mod cdrom sd_mod
> hid_generic usbhid hid uas usb_storage serio_raw atkbd libps2
> crc32_pclmul
> [  381.938018]  crc32c_intel isci ahci aesni_intel aes_x86_64 libsas
> libahci crypto_simd ehci_pci ehci_hcd cryptd glue_helper libata
> scsi_transport_sas e1000e mlx4_core usbcore ptp pps_core scsi_mod
> usb_common devlink wmi i8042 serio
> [  381.938029] CPU: 10 PID: 0 Comm: swapper/10 Tainted: P      D    O
>    4.16.7-1-ARCH #1
> [  381.938030] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./EP2C602, BIOS P1.80 12/09/2013
> [  381.938032] RIP: 0010:load_balance+0x71e/0x9b0
> [  381.938033] RSP: 0018:ffff8e6c5f283e18 EFLAGS: 00010286
> [  381.938034] RAX: 0000000000395360 RBX: ffff8e6c5b0e6a20 RCX: 0000000=
000000000
> [  381.938035] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000=
000000012
> [  381.938035] RBP: 000000000000000a R08: 0000000000000005 R09: 0000000=
000000001
> [  381.938036] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000=
000000001
> [  381.938037] R13: 0000000000000000 R14: ffff8e6c5b10e600 R15: 0000000=
00000000a
> [  381.938038] FS:  0000000000000000(0000) GS:ffff8e6c5f280000(0000)
> knlGS:0000000000000000
> [  381.938039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  381.938040] CR2: 0000000000395370 CR3: 0000000e6100a004 CR4: 0000000=
0000606e0
> [  381.938041] Call Trace:
> [  381.938042]  <IRQ>
> [  381.938045]  ? core_get_scaling+0x10/0x10
> [  381.938046]  ? intel_pstate_update_pstate+0x2c/0x30
> [  381.938049]  rebalance_domains+0x194/0x2c0
> [  381.938052]  __do_softirq+0xf1/0x2e0
> [  381.938054]  irq_exit+0xc9/0xe0
> [  381.938056]  smp_apic_timer_interrupt+0x73/0x160
> [  381.938058]  apic_timer_interrupt+0xf/0x20
> [  381.938059]  </IRQ>
> [  381.938061] RIP: 0010:cpuidle_enter_state+0xb6/0x2e0
> [  381.938061] RSP: 0018:ffff939f863f3ea8 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffff12
> [  381.938063] RAX: ffff8e6c5f280000 RBX: 00000058ea69b446 RCX: 0000000=
00000001f
> [  381.938064] RDX: 00000058ea69b446 RSI: ffffffff96e70d54 RDI: fffffff=
f96e70fb2
> [  381.938065] RBP: ffff8e6c5f2abe00 R08: 000002044ea385d2 R09: 0000000=
000000ef6
> [  381.938065] R10: 0000000000001d66 R11: ffff8e6c5f2a07c4 R12: 0000000=
000000005
> [  381.938066] R13: ffffffff970ae3f8 R14: 00000058e9f06f07 R15: 0000000=
000000000
> [  381.938069]  ? cpuidle_enter_state+0x94/0x2e0
> [  381.938071]  do_idle+0x193/0x1b0
> [  381.938073]  cpu_startup_entry+0x6f/0x80
> [  381.938075]  start_secondary+0x1a5/0x200
> [  381.938077]  secondary_startup_64+0xa5/0xb0
> [  381.938078] Code: 8c 00 00 00 8b 44 24 5c 48 0f a3 02 0f 82 08 fa
> ff ff 48 8b 44 24 30 c7 00 00 00 00 00 48 8b 44 24 28 48 85 c0 74 16
> 48 8b 40 10 <48> 8b 40 10 8b 50 20 85 d2 74 07 c7 40 20 00 00 00 00 66
> 66 66
> [  381.938104] RIP: load_balance+0x71e/0x9b0 RSP: ffff8e6c5f283e18
> [  381.938105] CR2: 0000000000395370
> [  381.938112] ---[ end trace 5c92a4d96e28b9b4 ]---
> [  381.976894] BUG: unable to handle kernel paging request at 000000000=
0390030
> [  381.976915] IP: load_balance+0x71e/0x9b0
> [  381.976916] PGD 0 P4D 0
> [  381.976918] Oops: 0000 [#3] PREEMPT SMP PTI
> [  381.976919] Modules linked in: 8021q mrp wl(PO) btrfs dm_thin_pool
> ast dm_persistent_data dm_bio_prison dm_bufio libcrc32c i2c_algo_bit
> crc32c_generic intel_rapl ttm sb_edac zstd_compress drm_kms_helper xor
> x86_pkg_temp_thermal intel_powerclamp drm raid6_pq raid1 agpgart
> coretemp md_mod cfg80211 syscopyarea sysfillrect kvm_intel dm_mod
> sysimgblt kvm fb_sys_fops joydev irqbypass rfkill iTCO_wdt
> iTCO_vendor_support crct10dif_pclmul ghash_clmulni_intel ipmi_ssif
> rtc_cmos ipmi_si intel_cstate mei_me ipmi_devintf intel_uncore
> ipmi_msghandler shpchp pcspkr mousedev input_leds led_class psmouse
> intel_rapl_perf lpc_ich mei i2c_i801 evdev mac_hid ip_tables x_tables
> overlay squashfs zstd_decompress xxhash loop isofs sr_mod cdrom sd_mod
> hid_generic usbhid hid uas usb_storage serio_raw atkbd libps2
> crc32_pclmul
> [  381.976950]  crc32c_intel isci ahci aesni_intel aes_x86_64 libsas
> libahci crypto_simd ehci_pci ehci_hcd cryptd glue_helper libata
> scsi_transport_sas e1000e mlx4_core usbcore ptp pps_core scsi_mod
> usb_common devlink wmi i8042 serio
> [  381.976961] CPU: 30 PID: 0 Comm: swapper/30 Tainted: P      D    O
>    4.16.7-1-ARCH #1
> [  381.976961] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./EP2C602, BIOS P1.80 12/09/2013
> [  381.976963] RIP: 0010:load_balance+0x71e/0x9b0
> [  381.976964] RSP: 0018:ffff8e6c5f583e18 EFLAGS: 00010286
> [  381.976965] RAX: 0000000000390020 RBX: ffff8e6c5b0e68a0 RCX: 0000000=
000000000
> [  381.976966] RDX: ffff8e6c5f3a1880 RSI: ffff8e6c5f596480 RDI: 0000000=
00000000e
> [  381.976967] RBP: 000000000000000e R08: 000000000000000e R09: 0000000=
0ff00ff00
> [  381.976968] R10: 0000000000000004 R11: 0000000000000005 R12: 0000000=
000000001
> [  381.976969] R13: 0000000000000000 R14: ffff8e6c5b10dc00 R15: 0000000=
00000001e
> [  381.976970] FS:  0000000000000000(0000) GS:ffff8e6c5f580000(0000)
> knlGS:0000000000000000
> [  381.976971] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  381.976972] CR2: 0000000000390030 CR3: 0000000e6100a001 CR4: 0000000=
0000606e0
> [  381.976972] Call Trace:
> [  381.976974]  <IRQ>
> [  381.976976]  ? core_get_scaling+0x10/0x10
> [  381.976977]  ? intel_pstate_update_pstate+0x2c/0x30
> [  381.976980]  rebalance_domains+0x194/0x2c0
> [  381.976982]  __do_softirq+0xf1/0x2e0
> [  381.976985]  irq_exit+0xc9/0xe0
> [  381.976987]  smp_apic_timer_interrupt+0x73/0x160
> [  381.976988]  apic_timer_interrupt+0xf/0x20
> [  381.976989]  </IRQ>
> [  381.976991] RIP: 0010:cpuidle_enter_state+0xb6/0x2e0
> [  381.976992] RSP: 0018:ffff939f86493ea8 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffff12
> [  381.976993] RAX: ffff8e6c5f580000 RBX: 00000058ef8f8464 RCX: 0000000=
00000001f
> [  381.976994] RDX: 00000058ef8f8464 RSI: ffffffff96e70d54 RDI: fffffff=
f96e70fb2
> [  381.976995] RBP: ffff8e6c5f5abe00 R08: 000002045d912d7c R09: 0000000=
000000048
> [  381.976996] R10: 0000000000000bc1 R11: ffff8e6c5f5a07c4 R12: 0000000=
000000005
> [  381.976996] R13: ffffffff970ae3f8 R14: 00000058eb0bfe53 R15: 0000000=
000000000
> [  381.976999]  ? cpuidle_enter_state+0x94/0x2e0
> [  381.977001]  do_idle+0x193/0x1b0
> [  381.977003]  cpu_startup_entry+0x6f/0x80
> [  381.977004]  start_secondary+0x1a5/0x200
> [  381.977006]  secondary_startup_64+0xa5/0xb0
> [  381.977008] Code: 8c 00 00 00 8b 44 24 5c 48 0f a3 02 0f 82 08 fa
> ff ff 48 8b 44 24 30 c7 00 00 00 00 00 48 8b 44 24 28 48 85 c0 74 16
> 48 8b 40 10 <48> 8b 40 10 8b 50 20 85 d2 74 07 c7 40 20 00 00 00 00 66
> 66 66
> [  381.977034] RIP: load_balance+0x71e/0x9b0 RSP: ffff8e6c5f583e18
> [  381.977035] CR2: 0000000000390030
> [  381.977050] ---[ end trace 5c92a4d96e28b9b5 ]---
> [  382.051694] Kernel panic - not syncing: Fatal exception in interrupt=

> [  383.119561] Shutting down cpus with NMI
> [  385.335677] Kernel Offset: 0x15000000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  385.490613] ---[ end Kernel panic - not syncing: Fatal exception in =
interrupt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--m4dRdXcITnzMPE1p6LV4itWbA2JocsTF6--

--BIj6b8oBMYKQW3lbiD2LDiA8BozRuYXS0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr476YACgkQwj2R86El
/qi6xAf/UwWpHHA6nn9Ix/cM9BGpvuw+I+mYV+MGnYYBtW3NnvqMFHMzVtwqMFCK
VN0tKpwSEPtmFbFiPMAme/K4fRCJ/ZIJEhX+CesvoA7TdVEZcA/0Uo2roTpsTpMc
qWuS0SmZohgGnRU4+kjle2omJGrMMwm17ojs4FTIPcMpdk8jLX5d2RyBzxv8a/m7
L5mBVpkGTmArlJ66mfk4q4O2uzJBvjyRlqF/Yo6ayK4izaJe98p3FpseP3udwm0N
+ZKiSBAMIbnZEXH8r2vg3vecKaOkQwZPKGtcjYMClk9mBaklJrHunP+/zts1uxl0
S/vRIBQrX948E68zQApGtdMdB+tOaw==
=Wbqz
-----END PGP SIGNATURE-----

--BIj6b8oBMYKQW3lbiD2LDiA8BozRuYXS0--
