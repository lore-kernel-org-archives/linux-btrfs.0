Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52025 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753567AbeFJB5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Jun 2018 21:57:04 -0400
Subject: Re: corrupt leaf; unaligned key offset for csum item
To: Simon Kaiser <simon.kaiser@kit.edu>, linux-btrfs@vger.kernel.org
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
Date: Sun, 10 Jun 2018 09:56:47 +0800
MIME-Version: 1.0
In-Reply-To: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cdbeVPOlHgctqXXoxrmkMkFHpHFwUwCBa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cdbeVPOlHgctqXXoxrmkMkFHpHFwUwCBa
Content-Type: multipart/mixed; boundary="nIo1jUAZAkgELOPxlBd41QLHKMQddp3H3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Simon Kaiser <simon.kaiser@kit.edu>, linux-btrfs@vger.kernel.org
Message-ID: <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
Subject: Re: corrupt leaf; unaligned key offset for csum item
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
In-Reply-To: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>

--nIo1jUAZAkgELOPxlBd41QLHKMQddp3H3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8809=E6=97=A5 20:22, Simon Kaiser wrote:
> Hi all,
>=20
> I'm having trouble with my btrfs volume on a Samsung SSD 840 pro.  On
> startup I immediately get the error
>=20
> BTRFS critical (device sda5): corrupt leaf: root=3D1 block=3D7326357913=
6
> slot=3D105, unaligned key offset for csum item, have 1271496708 should =
be
> aligned to 4096

Tree-checker detects something.

And indeed the bytenr is not even aligned to 512.
So definitely a corruption.

>=20
> I used to make regular backups, but slacked off recently.  Fixing the
> filesystem isn't essential in any way, but would save me quite some tim=
e
> on config tinkering and weeding out vacation photos.  The second of
> which I don't enjoy at all...
>=20
> On similar issues faulty RAM seemed to be the most prominent cause.  I
> added a third memory module quite recently which could have caused this=
,
> but I couldn't run memtest long enough yet to verify.

Indeed, the corrupted bytenr is 0x4bc98004.
Looks pretty like a bit flip in the 3rd lowest bit.

It can be fixed by manually patching the corrupted leaf to get rid of
the bitflip.
I could provide a special branch of btrfs-progs to fix it easily.

But before that, it's better to do a scrub to see if there is other
similar problems, so I could fix them all.

Thanks,
Qu

>=20
> Here's the trimmed dmesg output (full output at
> https://pastebin.com/7XF9i09K)
>=20
> [    4.062748] BTRFS critical (device sda5): corrupt leaf: root=3D1 blo=
ck=3D73263579136 slot=3D105, unaligned key offset for csum item, have 127=
1496708 should be aligned to 4096
> [    4.063806] BTRFS info (device sda5): no csum found for inode 781071=
0 start 0
> [    4.064260] BTRFS warning (device sda5): csum failed root 257 ino 78=
10710 off 109201939968 csum 0x5307fa6f expected csum 0x00000000 mirror 1
> [    4.075834] BTRFS info (device sdb3): use lzo compression, level 0
> [    4.075836] BTRFS info (device sdb3): enabling auto defrag
> [    4.075837] BTRFS info (device sdb3): disk space caching is enabled
>=20
> `brfs inspect-internal dump-tree -b 73263579136 /dev/sda5` (trimmed,
> full output at https://pastebin.com/dqBJ3b6D)
>=20
> btrfs-progs v4.16.1
> leaf 73263579136 items 194 free space 4089 generation 530006 owner CSUM=
_TREE
> leaf 73263579136 flags 0x1(WRITTEN) backref revision 1
> fs uuid 95b4974b-a798-44b3-99aa-a4eef990aeeb
> chunk uuid 9c8f46c3-ba51-4175-857c-8041543fa813
> 	item 0 key (EXTENT_CSUM EXTENT_CSUM 1268850688) itemoff 16263 itemsize=
 20
> 		range start 1268850688 end 1268871168 length 20480
> 	item 1 key (EXTENT_CSUM EXTENT_CSUM 1268871168) itemoff 16259 itemsize=
 4
> 		range start 1268871168 end 1268875264 length 4096
> 	item 2 key (EXTENT_CSUM EXTENT_CSUM 1268875264) itemoff 16255 itemsize=
 4
> 		range start 1268875264 end 1268879360 length 4096
> 	item 3 key (EXTENT_CSUM EXTENT_CSUM 1268879360) itemoff 16239 itemsize=
 16
> 		range start 1268879360 end 1268895744 length 16384
> 	item 4 key (EXTENT_CSUM EXTENT_CSUM 1268895744) itemoff 16235 itemsize=
 4
> 		range start 1268895744 end 1268899840 length 4096
> 	item 5 key (EXTENT_CSUM EXTENT_CSUM 1268899840) itemoff 16223 itemsize=
 12
> 		range start 1268899840 end 1268912128 length 12288
> [...]
> 	item 100 key (EXTENT_CSUM EXTENT_CSUM 1271410688) itemoff 13827 itemsi=
ze 8
> 		range start 1271410688 end 1271418880 length 8192
> 	item 101 key (EXTENT_CSUM EXTENT_CSUM 1271418880) itemoff 13811 itemsi=
ze 16
> 		range start 1271418880 end 1271435264 length 16384
> 	item 102 key (EXTENT_CSUM EXTENT_CSUM 1271435264) itemoff 13807 itemsi=
ze 4
> 		range start 1271435264 end 1271439360 length 4096
> 	item 103 key (EXTENT_CSUM EXTENT_CSUM 1271439360) itemoff 13771 itemsi=
ze 36
> 		range start 1271439360 end 1271476224 length 36864
> 	item 104 key (EXTENT_CSUM EXTENT_CSUM 1271488512) itemoff 13763 itemsi=
ze 8
> 		range start 1271488512 end 1271496704 length 8192
> 	item 105 key (EXTENT_CSUM EXTENT_CSUM 1271496708) itemoff 13403 itemsi=
ze 360
> 		range start 1271496708 end 1271865348 length 368640
> 	item 106 key (EXTENT_CSUM EXTENT_CSUM 1271873536) itemoff 13399 itemsi=
ze 4
> 		range start 1271873536 end 1271877632 length 4096
> 	item 107 key (EXTENT_CSUM EXTENT_CSUM 1271877632) itemoff 13379 itemsi=
ze 20
> 		range start 1271877632 end 1271898112 length 20480
> 	item 108 key (EXTENT_CSUM EXTENT_CSUM 1271898112) itemoff 13375 itemsi=
ze 4
> 		range start 1271898112 end 1271902208 length 4096
> 	item 109 key (EXTENT_CSUM EXTENT_CSUM 1271918592) itemoff 13363 itemsi=
ze 12
> 		range start 1271918592 end 1271930880 length 12288
> 	item 110 key (EXTENT_CSUM EXTENT_CSUM 1271930880) itemoff 13351 itemsi=
ze 12
> 		range start 1271930880 end 1271943168 length 12288
> [...]
>=20
> `uname -a`
>=20
> Linux hostname 4.16.12-1-ARCH #1 SMP PREEMPT Fri May 25 23:30:31 UTC 20=
18 x86_64 GNU/Linux
>=20
> `btrfs fi show`
>=20
> Label: 'arch'  uuid: 95b4974b-a798-44b3-99aa-a4eef990aeeb
> 	Total devices 1 FS bytes used 78.10GiB
> 	devid    1 size 100.00GiB used 94.05GiB path /dev/sda5
>=20
> `btrfs fi df`
>=20
> Data, single: total=3D90.01GiB, used=3D76.32GiB
> System, single: total=3D32.00MiB, used=3D16.00KiB
> Metadata, single: total=3D4.01GiB, used=3D1.78GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> Is there any chance this can be fixed?  Your help would be greatly
> apperciated!
>=20
> Yours,
> Simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--nIo1jUAZAkgELOPxlBd41QLHKMQddp3H3--

--cdbeVPOlHgctqXXoxrmkMkFHpHFwUwCBa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlschWAACgkQwj2R86El
/qiwNAf/QnhPIoYtDzJvDtE/4nsSk6Ouu++j2Aopcluh8nxatFSes/c41rykk/Zx
7pOdkFVMP5DFfmXyoFkqldrEyuiPNEAb6nOXn1LohV1HeSjLRaHb2C9+RcOhnD4L
WypweeazASO153ZV7cEYC6mLNlhy48ty6fUysr40lttgOdj4Mgs24SAcnxTpI7oK
dI5vUyK+HH5Nr6aYzlnxhaPSDrwf4aZ2bpGosJZ3yK1ZZ80/ZJ+12SzXadcxdMgh
L15z/e50JZOlZYEaXZeG0PtiCpUC/xJJtnLh/rsOpKAmSrjBa5WblWSOoz/0HY44
aWU2Nxm0sfOJHd/QiDyoXuJ+GSC6/Q==
=WCPA
-----END PGP SIGNATURE-----

--cdbeVPOlHgctqXXoxrmkMkFHpHFwUwCBa--
