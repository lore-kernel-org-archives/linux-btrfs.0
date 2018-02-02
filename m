Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:40651 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751579AbeBBBkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 20:40:36 -0500
Subject: Re: btrfs - kernel warning
To: Patrik Ostrihon <patrik.ostrihon@gmail.com>, linux-btrfs@vger.kernel.org
References: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a95b4757-c63a-3566-e6ed-9065240a6f1d@gmx.com>
Date: Fri, 2 Feb 2018 09:40:30 +0800
MIME-Version: 1.0
In-Reply-To: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tcjokA2M9zd51cv3VkepgVwJ55soioik6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tcjokA2M9zd51cv3VkepgVwJ55soioik6
Content-Type: multipart/mixed; boundary="e6EnVLbvE9mdWA9x6UBHi0gzOV9j17axF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Patrik Ostrihon <patrik.ostrihon@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <a95b4757-c63a-3566-e6ed-9065240a6f1d@gmx.com>
Subject: Re: btrfs - kernel warning
References: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
In-Reply-To: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>

--e6EnVLbvE9mdWA9x6UBHi0gzOV9j17axF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8802=E6=97=A5 05:06, Patrik Ostrihon wrote:
> Hi,
>=20
> Today I saw warning in dmesg output. But I don't know what it means.
> Could you help me please? Is it something dangerous for my dato on
> this filesystem?
>=20
> Thanks
>=20
> pa3k
>=20
> root@merkur:~# uname -a
>=20
> Linux merkur 4.14.8-041408-generic #201712200555 SMP Wed Dec 20
> 10:57:38 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>=20
> root@merkur:~# btrfs --version
> Btrfs v3.12
>=20
> root@merkur:~# btrfs fi show
>=20
> Label: none  uuid: 96f60fa9-c20e-4a13-82b1-9074dd942eab
>         Total devices 2 FS bytes used 2.43TiB
>         devid    1 size 8.19TiB used 2.45TiB path /dev/sdc2
>         devid    2 size 8.19TiB used 2.45TiB path /dev/sdd2
>=20
> Label: none  uuid: 2da0261b-143a-4814-aacb-de46373aebe9
>         Total devices 2 FS bytes used 203.11GiB
>         devid    1 size 930.00GiB used 206.03GiB path /dev/sdc1
>         devid    2 size 930.00GiB used 206.01GiB path /dev/sdd1
>=20
> Btrfs v3.12
>=20
>=20
> root@merkur:~# btrfs fi df /usr/local/data
>=20
> Data, RAID1: total=3D2.44TiB, used=3D2.43TiB
> Data, single: total=3D8.00MiB, used=3D0.00
> System, RAID1: total=3D8.00MiB, used=3D368.00KiB
> System, single: total=3D4.00MiB, used=3D0.00
> Metadata, RAID1: total=3D5.00GiB, used=3D3.33GiB
> Metadata, single: total=3D8.00MiB, used=3D0.00
> unknown, single: total=3D512.00MiB, used=3D0.00
> root@merkur:~# btrfs fi df /usr/local/data/hts
> Data, RAID1: total=3D205.00GiB, used=3D202.90GiB
> Data, single: total=3D8.00MiB, used=3D0.00
> System, RAID1: total=3D8.00MiB, used=3D48.00KiB
> System, single: total=3D4.00MiB, used=3D0.00
> Metadata, RAID1: total=3D1.00GiB, used=3D213.25MiB
> Metadata, single: total=3D8.00MiB, used=3D0.00
> unknown, single: total=3D211.78MiB, used=3D0.00
>=20
>=20
> [ 4084.704514] ------------[ cut here ]------------
> [ 4084.704561] WARNING: CPU: 3 PID: 1865 at
> /home/kernel/COD/linux/fs/btrfs/ctree.h:1564

This normally means your device size is not aligned to 4K.

It's normal if your fs has some age as old mkfs.btrfs doesn't align
device size.

And recently kernel makes the device size alignment check more restrict,
so it will cause such warning.


Fortunately btrfs-progs provides offline tool to fix it.
You could use "btrfs rescue fix-device-size <device>" to easily fix it.
And since it's an offline tool, you need to umount your fs first.

Thanks,
Qu

> btrfs_update_device+0x1be/0x1d0 [btrfs]
> [ 4084.704562] Modules linked in: snd_hda_codec_hdmi
> snd_hda_codec_realtek snd_hda_codec_generic gpio_ich intel_powerclamp
> coretemp mxl5xx i915 kvm_intel kvm video drm_kms_helper ftdi_sio drm
> usbserial joydev irqbypass input_leds intel_cstate snd_hda_intel
> snd_hda_codec snd_hda_core ddbridge snd_hwdep i2c_algo_bit snd_pcm
> snd_timer fb_sys_fops syscopyarea snd cxd2099(C) sysfillrect soundcore
> sysimgblt dvb_core lpc_ich mei_me nuvoton_cir mei mac_hid rc_core
> shpchp 8021q garp mrp stp llc lp parport btrfs zstd_compress raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> hid_generic e1000e usbhid uas ptp raid6_pq usb_storage hid libcrc32c
> pps_core pata_acpi raid1 raid0 multipath linear
> [ 4084.704598] CPU: 3 PID: 1865 Comm: btrfs-cleaner Tainted: G
> C      4.14.8-041408-generic #201712200555
> [ 4084.704598] Hardware name:                  /DH57JG, BIOS
> JGIBX10J.86A.0663.2011.1019.0408 10/19/2011
> [ 4084.704599] task: ffff9803b17f8000 task.stack: ffffa6f2822f0000
> [ 4084.704616] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
> [ 4084.704617] RSP: 0018:ffffa6f2822f3d40 EFLAGS: 00010206
> [ 4084.704618] RAX: 0000000000000fff RBX: ffff9803b38bf9a0 RCX: 0000082=
fffff6e00
> [ 4084.704619] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff980=
397b574c8
> [ 4084.704619] RBP: ffffa6f2822f3d88 R08: ffffa6f2822f3cf0 R09: ffffa6f=
2822f3cf8
> [ 4084.704620] R10: 0000000000001000 R11: 0000000000003000 R12: ffff980=
375d41000
> [ 4084.704621] R13: 0000000000000000 R14: 0000000000003f3c R15: ffff980=
397b574c8
> [ 4084.704622] FS:  0000000000000000(0000) GS:ffff9803b72c0000(0000)
> knlGS:0000000000000000
> [ 4084.704623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4084.704624] CR2: 00007f883404d000 CR3: 000000001fa09003 CR4: 0000000=
0000206e0
> [ 4084.704625] Call Trace:
> [ 4084.704644]  btrfs_remove_chunk+0x365/0x870 [btrfs]
> [ 4084.704658]  btrfs_delete_unused_bgs+0x320/0x3c0 [btrfs]
> [ 4084.704672]  cleaner_kthread+0x159/0x170 [btrfs]
> [ 4084.704676]  kthread+0x125/0x140
> [ 4084.704689]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
> [ 4084.704691]  ? kthread_create_on_node+0x70/0x70
> [ 4084.704694]  ret_from_fork+0x25/0x30
> [ 4084.704695] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 1a
> 20 ff ff 4c 89 ff e8 82 ea fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
> d0 fe ff ff <0f> ff eb b6 e8 c9 15 9e de 66 0f 1f 84 00 00 00 00 00 66
> 66 66
> [ 4084.704717] ---[ end trace 4a9fc911d4199609 ]---
> [ 4084.705475] ------------[ cut here ]------------
> [ 4084.705516] WARNING: CPU: 2 PID: 1865 at
> /home/kernel/COD/linux/fs/btrfs/ctree.h:1564
> btrfs_update_device+0x1be/0x1d0 [btrfs]
> [ 4084.705517] Modules linked in: snd_hda_codec_hdmi
> snd_hda_codec_realtek snd_hda_codec_generic gpio_ich intel_powerclamp
> coretemp mxl5xx i915 kvm_intel kvm video drm_kms_helper ftdi_sio drm
> usbserial joydev irqbypass input_leds intel_cstate snd_hda_intel
> snd_hda_codec snd_hda_core ddbridge snd_hwdep i2c_algo_bit snd_pcm
> snd_timer fb_sys_fops syscopyarea snd cxd2099(C) sysfillrect soundcore
> sysimgblt dvb_core lpc_ich mei_me nuvoton_cir mei mac_hid rc_core
> shpchp 8021q garp mrp stp llc lp parport btrfs zstd_compress raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> hid_generic e1000e usbhid uas ptp raid6_pq usb_storage hid libcrc32c
> pps_core pata_acpi raid1 raid0 multipath linear
> [ 4084.705573] CPU: 2 PID: 1865 Comm: btrfs-cleaner Tainted: G
> WC      4.14.8-041408-generic #201712200555
> [ 4084.705574] Hardware name:                  /DH57JG, BIOS
> JGIBX10J.86A.0663.2011.1019.0408 10/19/2011
> [ 4084.705576] task: ffff9803b17f8000 task.stack: ffffa6f2822f0000
> [ 4084.705611] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
> [ 4084.705613] RSP: 0018:ffffa6f2822f3d40 EFLAGS: 00010206
> [ 4084.705616] RAX: 0000000000000fff RBX: ffff9803b1787000 RCX: 0000082=
fffff6e00
> [ 4084.705617] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff980=
397b574c8
> [ 4084.705619] RBP: ffffa6f2822f3d88 R08: ffffa6f2822f3cf0 R09: ffffa6f=
2822f3cf8
> [ 4084.705620] R10: 0000000000001000 R11: 0000000000003000 R12: ffff980=
375d41000
> [ 4084.705622] R13: 0000000000000000 R14: 0000000000003f3c R15: ffff980=
397b574c8
> [ 4084.705624] FS:  0000000000000000(0000) GS:ffff9803b7280000(0000)
> knlGS:0000000000000000
> [ 4084.705626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4084.705628] CR2: 00007f8834051000 CR3: 000000001fa09006 CR4: 0000000=
0000206e0
> [ 4084.705629] Call Trace:
> [ 4084.705667]  btrfs_remove_chunk+0x365/0x870 [btrfs]
> [ 4084.705698]  btrfs_delete_unused_bgs+0x320/0x3c0 [btrfs]
> [ 4084.705729]  cleaner_kthread+0x159/0x170 [btrfs]
> [ 4084.705732]  kthread+0x125/0x140
> [ 4084.705762]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
> [ 4084.705765]  ? kthread_create_on_node+0x70/0x70
> [ 4084.705768]  ret_from_fork+0x25/0x30
> [ 4084.705771] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 1a
> 20 ff ff 4c 89 ff e8 82 ea fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
> d0 fe ff ff <0f> ff eb b6 e8 c9 15 9e de 66 0f 1f 84 00 00 00 00 00 66
> 66 66
> [ 4084.705819] ---[ end trace 4a9fc911d419960a ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--e6EnVLbvE9mdWA9x6UBHi0gzOV9j17axF--

--tcjokA2M9zd51cv3VkepgVwJ55soioik6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpzwY4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjDsQf/eulhObGVjGScqegdM2EiL+Xp
2Es8uc9oVlurOLPrAeBFi/8mCkWB2uFyIoykB/eMONCD9X4ng5zxG53FdX0CWm+m
Mpykdga37u2zHh90zb78xEg2BT+2LIZPruFF/MGLj23D9MSywI7DMo6Yl8UFjrDo
Hp2aeAqiRFNE2h5r/U6SxWOWoOUPGh0jlDZZFUdv2X7pK38RiGNwM7difLPKVXf1
x/de7afFNhZhZd4vlUYsBwpKHp6EiPsAs0+LntSZIrDuEIt6sgkIi+HN2rAaUzdj
/eQzELrDW6xQE0rCYFm2mC+08TZEHEWs7AzKCI4rilKarGHRP1wERbrC5VZ+iQ==
=McR1
-----END PGP SIGNATURE-----

--tcjokA2M9zd51cv3VkepgVwJ55soioik6--
