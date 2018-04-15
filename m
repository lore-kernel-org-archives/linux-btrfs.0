Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:47801 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751065AbeDOJPV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 05:15:21 -0400
Subject: Re: remounted ro during operation, unmountable since
To: Timo Nentwig <btrfs@nentwig.biz>, linux-btrfs@vger.kernel.org
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
 <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
 <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
 <a8395ede-5d31-8551-17b7-4bfec384ba48@nentwig.biz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <da8815b7-3cd1-0be4-0cbf-54f850fed44c@gmx.com>
Date: Sun, 15 Apr 2018 17:15:14 +0800
MIME-Version: 1.0
In-Reply-To: <a8395ede-5d31-8551-17b7-4bfec384ba48@nentwig.biz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OfTq23JTQHogPYOccZ3Lqh1z3WVpv2Xmc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OfTq23JTQHogPYOccZ3Lqh1z3WVpv2Xmc
Content-Type: multipart/mixed; boundary="ASA1uX3a12jHyRG4sdLj2IJnbians80M0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Timo Nentwig <btrfs@nentwig.biz>, linux-btrfs@vger.kernel.org
Message-ID: <da8815b7-3cd1-0be4-0cbf-54f850fed44c@gmx.com>
Subject: Re: remounted ro during operation, unmountable since
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
 <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
 <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
 <a8395ede-5d31-8551-17b7-4bfec384ba48@nentwig.biz>
In-Reply-To: <a8395ede-5d31-8551-17b7-4bfec384ba48@nentwig.biz>

--ASA1uX3a12jHyRG4sdLj2IJnbians80M0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8815=E6=97=A5 16:39, Timo Nentwig wrote:
> On 04/14/2018 03:45 PM, Timo Nentwig wrote:
>> On 04/14/2018 11:42 AM, Qu Wenruo wrote:
>>> And the work load when the RO happens is also helpful.
>>> (Well, the dmesg of RO happens would be the best though)
>> I had a glance at dmesg but don't remember anything specific (think
>> the usual "---- [cut here] ---" + dump of registers, but I'm not even
>> sure about that). Sorry.=20
>=20
> *cough* look, what I just found :)
>=20
[snip]
> [Sun Apr=C2=A0 8 09:40:45 2018] CPU: 4 PID: 64370 Comm: kworker/u256:87=

> Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0 O=C2=A0=C2=
=A0=C2=A0=C2=A0 4.15.15-1-ARCH #1
> [Sun Apr=C2=A0 8 09:40:45 2018] Hardware name: System manufacturer Syst=
em
> Product Name/ROG ZENITH EXTREME, BIOS 0902 12/21/2017

ROG, no wonder you're OCing.

> [Sun Apr=C2=A0 8 09:40:45 2018] Workqueue: btrfs-extent-refs
> btrfs_extent_refs_helper [btrfs]
> [Sun Apr=C2=A0 8 09:40:45 2018] RIP: 0010:btrfs_run_delayed_refs+0x167/=
0x1b0
> [btrfs]
> [Sun Apr=C2=A0 8 09:40:45 2018] RSP: 0018:ffffa085e34d3dd8 EFLAGS: 0001=
0282
> [Sun Apr=C2=A0 8 09:40:45 2018] RAX: 0000000000000000 RBX: ffff96b4f02a=
b9c8
> RCX: 0000000000000001
> [Sun Apr=C2=A0 8 09:40:45 2018] RDX: 0000000080000001 RSI: ffffffffa1e4=
7fcf
> RDI: 00000000ffffffff
> [Sun Apr=C2=A0 8 09:40:45 2018] RBP: ffff96b925140000 R08: 000000000000=
0001
> R09: 0000000000000a02
> [Sun Apr=C2=A0 8 09:40:45 2018] R10: 0000000000000005 R11: 000000000000=
0000
> R12: ffff96b915a5ec00
> [Sun Apr=C2=A0 8 09:40:45 2018] R13: 0000000000000000 R14: ffff96b4e187=
c600
> R15: ffff96b92c411400
> [Sun Apr=C2=A0 8 09:40:45 2018] FS:=C2=A0 0000000000000000(0000)
> GS:ffff96b92cb00000(0000) knlGS:0000000000000000
> [Sun Apr=C2=A0 8 09:40:45 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> [Sun Apr=C2=A0 8 09:40:45 2018] CR2: 00007f2c661a96f0 CR3: 0000000f48fc=
c000
> CR4: 00000000003406e0
> [Sun Apr=C2=A0 8 09:40:45 2018] Call Trace:
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 delayed_ref_async_start+0x8d/0xa0=
 [btrfs]
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 normal_work_helper+0x39/0x370 [bt=
rfs]
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 process_one_work+0x1ce/0x410
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 worker_thread+0x2b/0x3d0
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 ? process_one_work+0x410/0x410
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 kthread+0x113/0x130
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 ? kthread_create_on_node+0x70/0x7=
0
> [Sun Apr=C2=A0 8 09:40:45 2018]=C2=A0 ret_from_fork+0x22/0x40
> [Sun Apr=C2=A0 8 09:40:45 2018] Code: a0 82 d8 e0 eb 90 48 8b 53 60 f0 =
0f ba
> aa 50 12 00 00 02 72 1b 83 f8 fb 74 37 89 c6 48 c7 c7 c8 28 53 c0 89 04=

> 24 e8 c9 fa be e0 <0f> 0b 8b 04 24 89 c1 ba 04 0c 00 00 48 c7 c6 00 b9
> 52 c0 48 89
> [Sun Apr=C2=A0 8 09:40:45 2018] ---[ end trace 6ad220910a160dd3 ]---
> [Sun Apr=C2=A0 8 09:40:45 2018] BTRFS: error (device sda2) in
> btrfs_run_delayed_refs:3076: errno=3D-17 Object already exists

According to the code, it's just transaction abort.
I'd say it's just extent tree code hit something unexpected, maybe it's
caused by the offending tree blocks.

Not much useful info compared to debug tree grep.

Thanks,
Qu

> [Sun Apr=C2=A0 8 09:40:45 2018] BTRFS info (device sda2): forced readon=
ly
> [Sun Apr=C2=A0 8 09:40:45 2018] BTRFS error (device sda2): pending csum=
s is
> 331776
>=20
>=20
> [Tue Apr 10 05:23:22 2018] hid-generic 0003:1E71:170E.0009:
> hiddev0,hidraw0: USB HID v1.10 Device [NZXT.-Inc. NZXT USB Device] on
> usb-0000:01:00.0-9/input0
> [Tue Apr 10 06:19:31 2018] ------------[ cut here ]------------
> [Tue Apr 10 06:19:31 2018] BTRFS: Transaction aborted (error -17)
> [Tue Apr 10 06:19:31 2018] WARNING: CPU: 18 PID: 541 at
> fs/btrfs/extent-tree.c:3076 btrfs_run_delayed_refs+0x167/0x1b0 [btrfs]
> [Tue Apr 10 06:19:31 2018] Modules linked in: cmac md4 nls_utf8 cifs cc=
m
> dns_resolver fscache lz4 lz4_compress zram rfcomm bnep xt_tcpudp
> iptable_filter hwmon_vid msr arc4 ext4 mbcache jbd2 fscrypto btusb
> edac_mce_amd btrtl btbcm btintel ath10k_pci kvm bluetooth ath10k_core
> mousedev ecdh_generic ath irqbypass crc16 input_leds crct10dif_pclmul
> mac80211 snd_hda_codec_realtek crc32_pclmul ghash_clmulni_intel
> snd_hda_codec_generic snd_hda_codec_hdmi pcbc eeepc_wmi wil6210
> aesni_intel igb asus_wmi snd_hda_intel aes_x86_64 sparse_keymap
> led_class crypto_simd snd_hda_codec cfg80211 glue_helper ptp wmi_bmof
> cryptd snd_hda_core pps_core mxm_wmi dca snd_hwdep sp5100_tco ccp rfkil=
l
> snd_pcm pcspkr atlantic i2c_piix4 rng_core k10temp rtc_cmos evdev shpch=
p
> gpio_amdpt wmi pinctrl_amd mac_hid acpi_cpufreq vboxnetflt(O) vboxnetad=
p(O)
> [Tue Apr 10 06:19:31 2018]=C2=A0 vboxpci(O) vboxdrv(O) snd_seq_dummy
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_timer snd
> soundcore cuse fuse cpufreq_powersave cpufreq_ondemand crypto_user
> ip_tables x_tables sd_mod hid_apple uas usb_storage hid_saitek
> hid_generic usbhid hid ahci xhci_pci libahci xhci_hcd libata usbcore
> scsi_mod usb_common crc32c_generic crc32c_intel btrfs xor
> zstd_decompress zstd_compress xxhash raid6_pq amdgpu chash i2c_algo_bit=

> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm
> agpgart
> [Tue Apr 10 06:19:31 2018] CPU: 18 PID: 541 Comm: btrfs-transacti
> Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0 O=C2=A0=C2=
=A0=C2=A0=C2=A0 4.15.15-1-ARCH #1
> [Tue Apr 10 06:19:31 2018] Hardware name: System manufacturer System
> Product Name/ROG ZENITH EXTREME, BIOS 0902 12/21/2017
> [Tue Apr 10 06:19:31 2018] RIP: 0010:btrfs_run_delayed_refs+0x167/0x1b0=

> [btrfs]
> [Tue Apr 10 06:19:31 2018] RSP: 0018:ffff9171107efe10 EFLAGS: 00010286
> [Tue Apr 10 06:19:31 2018] RAX: 0000000000000000 RBX: ffff8a653d7790e0
> RCX: 0000000000000001
> [Tue Apr 10 06:19:31 2018] RDX: 0000000080000001 RSI: ffffffff99e47fcf
> RDI: 00000000ffffffff
> [Tue Apr 10 06:19:31 2018] RBP: ffff8a6af5142000 R08: 0000000000000001
> R09: 00000000000009a2
> [Tue Apr 10 06:19:31 2018] R10: 0000000000000007 R11: 0000000000000000
> R12: ffff8a69c2c87c00
> [Tue Apr 10 06:19:31 2018] R13: ffff8a6af5142d40 R14: 00000000001a0a2e
> R15: 0000000000000516
> [Tue Apr 10 06:19:31 2018] FS:=C2=A0 0000000000000000(0000)
> GS:ffff8a6afce80000(0000) knlGS:0000000000000000
> [Tue Apr 10 06:19:31 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> [Tue Apr 10 06:19:31 2018] CR2: 000004a8de3b4000 CR3: 00000008b721a000
> CR4: 00000000003406e0
> [Tue Apr 10 06:19:31 2018] Call Trace:
> [Tue Apr 10 06:19:31 2018]=C2=A0 btrfs_commit_transaction+0x46/0x930 [b=
trfs]
> [Tue Apr 10 06:19:31 2018]=C2=A0 ? start_transaction+0x9e/0x420 [btrfs]=

> [Tue Apr 10 06:19:31 2018]=C2=A0 transaction_kthread+0x17b/0x1a0 [btrfs=
]
> [Tue Apr 10 06:19:31 2018]=C2=A0 ? btrfs_cleanup_transaction+0x570/0x57=
0 [btrfs]
> [Tue Apr 10 06:19:31 2018]=C2=A0 kthread+0x113/0x130
> [Tue Apr 10 06:19:31 2018]=C2=A0 ? kthread_create_on_node+0x70/0x70
> [Tue Apr 10 06:19:31 2018]=C2=A0 ret_from_fork+0x22/0x40
> [Tue Apr 10 06:19:31 2018] Code: a0 c2 bf d8 eb 90 48 8b 53 60 f0 0f ba=

> aa 50 12 00 00 02 72 1b 83 f8 fb 74 37 89 c6 48 c7 c7 c8 e8 6b c0 89 04=

> 24 e8 c9 3a a6 d8 <0f> 0b 8b 04 24 89 c1 ba 04 0c 00 00 48 c7 c6 00 79
> 6b c0 48 89
> [Tue Apr 10 06:19:31 2018] ---[ end trace 2b729472a1f5e06c ]---
> [Tue Apr 10 06:19:31 2018] BTRFS: error (device sda2) in
> btrfs_run_delayed_refs:3076: errno=3D-17 Object already exists
> [Tue Apr 10 06:19:31 2018] BTRFS info (device sda2): forced readonly
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--ASA1uX3a12jHyRG4sdLj2IJnbians80M0--

--OfTq23JTQHogPYOccZ3Lqh1z3WVpv2Xmc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrTGCIACgkQwj2R86El
/qhASwf9ENsSxBSEXp1uV95m0XMLxJ3u/vWqrXRqVfCgiOY2Vde35Yzqqairg19R
UCIxPxhzkem0u7nflO3vRd9EUQ49z7Wx+TVsv2vVqZ+5hC+xa4ysToXqX9fDjecZ
bHyak2/Q9ZZnxp2x3EPq4ey12ZXEAg1qcfjUIRqFhOG8uLd4QkDA1EGyw7QvdWKs
s+nvk9AEA0KVJZBqLGN/Ad36Zy2TT+XPH1COGp7M7oJSxBE9V8XtLGtN+POltJWw
WQDRXMvgO+VvJU6xelEYQQ5JwCiQ6EzGuR4rX3rU0rcGwqRNjawCp8dnskiTcrS4
iR/IDguCCbB1dtp+uZGb9rlJfKmCRA==
=Zc5r
-----END PGP SIGNATURE-----

--OfTq23JTQHogPYOccZ3Lqh1z3WVpv2Xmc--
