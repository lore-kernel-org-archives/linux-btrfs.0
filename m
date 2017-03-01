Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65110 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751150AbdCASPA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 13:15:00 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MfzEP-1cv2q81zUb-00NSk8 for
 <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 19:14:13 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Wed, 01 Mar 2017 19:14:07 +0100
Message-ID: <14737660.8idzxVKBRv@thetick>
In-Reply-To: <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <1975016.KbFk7ASZDg@thetick> <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3014045.9Ep928PJtd"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3014045.9Ep928PJtd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 01 March 2017 17:32:35 Qu Wenruo wrote:
> At 03/01/2017 04:23 PM, Marc Joliet wrote:
> > On Tuesday 28 February 2017 23:14:54 Marc Joliet wrote:
> >> I think I'm at that point now myself, unless anybody has any other=
 ideas.
> >=20
> > For example, could the --init-extent-tree option to btrfs-check hel=
p,
> > given
> > that I needed to pass -w to btrfs-image?

(First off, thanks for taking the time to respond!)

> --init-extent-tree should be avoided normally, unless you're 100% sur=
e
> about only extent tree is corrupted, and you have enough faith that
> --init-extent-tree can finish.
>=20
> Or it will mostly make things worse.

OK, that's why I asked :) .

> Before trying any RW btrfs check operations, did you run btrfs check =
on
> the image?

If by image you mean the device in question, not since the last time (s=
ee my=20
previous messages).  Or can I really run btrfs check on the image?  In =
any=20
case, I started btrfs-check on the device itself.

> And btrfs check --mode=3Dlowmem is also recommended as in some rare c=
ase,
> low mem mode can detect bug which original mode doesn't.

I did see differences in output the last time around (again, see my pre=
vious=20
messages in this thread), so I'll run with lowmem.  It won't be done un=
til=20
tomorrow, though.

> (And it also helps us to enhance lowmem mode)

OK

> > Also, the image is complete, so I only need to find somewhere where=
 I can
> > upload a 9.4 GB file.
>=20
> Is it a compressed dump? Dumped with btrfs-image -c9?

It was created with:

btrfs-image -s -w /dev/sdb2 - | xz -9 --stdout > ./btrfs_backup_drive_2=
.img.xz

(Mainly because I felt more comfortable using a separate compression ut=
ility,=20
not for any rational reason.  Although if you really meant "image" abov=
e, I=20
have the feeling I'll regret this decision.)

> If so, such large one won't help much unless there is some developer
> really interested in inspecting the image.

When I started without compression, it was something like 46 GB, after =
only=20
1-2 hours, so I expect the uncompressed size to be... very large :-/ .

> Thanks,
> Qu
>=20
> > Greetings
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart3014045.9Ep928PJtd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYtw9vAAoJEL/Q5oYsiHj0vQUP/0wWcua4B6UXNXrh4RBiG7Qa
U1l4WitQMCwAo7qBPVPp+GBEDwZbTYmOvBYKaVhoaL1wtCArQ2RN9EU171tmj2v3
wc+IpU3VYJTpngj+ug0JD2BoEjVIUm/gP1hL9oibhceaj3NoN2ZRD/ffDJgKNIv2
LNSyXGiokpY4VBFoP7wuCxaKmcyY7KsHVe7CWSxSDtosHjx5SlBNOpd+yWTLjwyF
gob2HWLosGtWV8pmqm47AbHG2azT9cAD6eEblxU2S1of4aQrVcDZHBtssCWovg1d
RPdSsh3bOORD18fhHWs1CJtchfpHj3JlRrPHPc8ETekUijLlhIOPngUkoK7qiMYj
8J1u+SKo2PLyUhycGwCyMbB3bJl9Mp2iwbAWumdLwulXYl7G7vzLPXA7xhogTnFU
/TqfWbfNwoQuDsCHGCM6HoOLp+sQWioj3+XjU/QJ+ZFVHlfkufvXmNMqW5XXqtnL
6sNtiavwnwUn0mmW5PGqxiDFnpXS3pun0XcKlrAhtzp0NhCdz4iH6hVsLkEB6rbb
3qCGAyjpca1LI8oa+mj2s7bVmFHAgZ/hypr6vomCvj/yD/6bQUp2f/NGwXqUmeNS
BHTP/oU8h60UHzXlz/PeGPXD2VzVPN0fmH26Y7LvJbbdA14pLnvr5K4vIkTZazd/
zSdTopQ5aFYaJEa/SH4J
=0RFU
-----END PGP SIGNATURE-----

--nextPart3014045.9Ep928PJtd--

