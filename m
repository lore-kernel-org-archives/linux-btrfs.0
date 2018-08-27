Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:41903 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbeH0IcD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 04:32:03 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-btrfs@vger.kernel.org
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
Date: Mon, 27 Aug 2018 12:46:47 +0800
MIME-Version: 1.0
In-Reply-To: <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k5ngF6Q8cGpJStAGM67rSQIFaCWq3yZlO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k5ngF6Q8cGpJStAGM67rSQIFaCWq3yZlO
Content-Type: multipart/mixed; boundary="PZbJwaSayTTD4TMufjCG3fyojwTljnC4R";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-btrfs@vger.kernel.org
Message-ID: <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
Subject: Re: Scrub aborts due to corrupt leaf
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
In-Reply-To: <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>

--PZbJwaSayTTD4TMufjCG3fyojwTljnC4R
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/27 =E4=B8=8A=E5=8D=8810:32, Larkin Lowrey wrote:
> On 8/26/2018 8:16 PM, Qu Wenruo wrote:
>> Corrupted tree block bytenr matches with the number reported by kernel=
=2E
>> You could provide the tree block dump for bytenr 7687860535296, and
>> maybe we could find out what's going wrong and fix it manually.
>>
>> # btrfs ins dump-tree -b 7687860535296 <device>
>=20
> Thank you for your reply.
>=20
> # btrfs ins dump-tree -b 7687860535296 /dev/Cached/Backups
> btrfs-progs v4.15.1
> leaf free space ret -2002721201, leaf data size 16283, used 2002737484
> nritems 319
> leaf 7687860535296 items 319 free space -2002721201 generation 2862 own=
er 7
> leaf 7687860535296 flags 0x1(WRITTEN) backref revision 1
> fs uuid acff5096-1128-4b24-a15e-4ba04261edc3
> chunk uuid 0d2fdb5d-00c0-41b3-b2ed-39a5e3bf98aa
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 0 key (1844674407365084=
7734 EXTENT_CSUM 8487178285056)
> itemoff 13211 itemsize 3072
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 range start 8487178285056 end 8487181430784 length 314=
5728
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 1 key (1844674407365088=
0502 EXTENT_CSUM 8487174090752)
> itemoff 10139 itemsize 3072
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 range start 8487174090752 end 8487177236480 length 314=
5728
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 2 key (1844674407365091=
3270 EXTENT_CSUM 8487167782912)
> itemoff 3251 itemsize 6888
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 range start 8487167782912 end 8487174836224 length 705=
3312
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 3 key (1844674407365101=
1574 EXTENT_CSUM 8487166103552)
> itemoff 187 itemsize 3064
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 range start 8487166103552 end 8487169241088 length 313=
7536
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 4 key (58523648 UNKNOWN=
=2E0 4115587072) itemoff 0 itemsize 0

Starts from this item, the leaf is definitely corrupted.

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 5 key (58523648 UNKNOWN=
=2E0 4115058688) itemoff 0 itemsize 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 6 key (58392576 UNKNOWN=
=2E0 4115050496) itemoff 0 itemsize 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 7 key (58392576 UNKNOWN=
=2E0 9160800976331685888) itemoff
> 1325803612 itemsize 1549669347
[snip]
> Segmentation fault (core dumped)
>=20
> Can I simply rebuild the csum tree (btrfs check --init-csum-tree)? The
> entire contents of the fs are back-up files that are hashed so I can
> verify that the files are correct.

Yes, I just forgot we have the --init-csum-tree option.

You could try that way, at least from previous check run, there is no
other serious corruption.

>=20
>> Please note that this corruption could be caused by bad ram or some ol=
d
>> kernel bug.
>> It's recommend to run a memtest if possible.
>=20
> The system uses ECC memory and edac-util has not reported any errors.
> However, I will run a memtest anyway.

So it should not be the memory problem.

BTW, what's the current generation of the fs?

# btrfs inspect dump-super <device> | grep generation

The corrupted leaf has generation 2862, I'm not sure how recent did the
corruption happen.

Thanks,
Qu

>=20
> Thank you,
>=20
> --Larkin


--PZbJwaSayTTD4TMufjCG3fyojwTljnC4R--

--k5ngF6Q8cGpJStAGM67rSQIFaCWq3yZlO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluDgjgACgkQwj2R86El
/qgCowf+Lj/vNVou14NGU3h+xbsKcDAwpngazlS2HXET5bH4iN14ngPhIyWuvT0e
og+R1tYI8DNymJ2rRtSqePU2GlM/u701F+rG1HqKY6fvH+Hp2ybbXYQ3IXrMSH1l
Tlzvl1gyugrZzNxc/xHvQ56p36bC+JDed7LluJW5X2+WYyAEV60SLMwM7/poM6PD
DgRZ6s/ZS5NHQVu2GW9WtMp2ydpuVoilH4NgF5/Jfb2C+65nOyZvGBnHrwDNmN0q
htJxKkQN5muEuvTEcYJV9lExrZ7JH00wh/6TEsgDrcFbo0xM5StynzMwgzg288aj
PKFPSyJosaEbVZ7v1I6MWTb1/r5jCA==
=VMsd
-----END PGP SIGNATURE-----

--k5ngF6Q8cGpJStAGM67rSQIFaCWq3yZlO--
