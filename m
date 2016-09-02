Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:43154 "EHLO mail.crc.id.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751497AbcIBCFx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 22:05:53 -0400
Received: from dhcp-10-1-1-187.lan.crc.id.au (2407-e400-b000-201-2851-3955-4a5d-b314-cpe.spintel.net.au [IPv6:2407:e400:b000:201:2851:3955:4a5d:b314])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by mail.crc.id.au (Postfix) with ESMTPSA id C232F3A02AC
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2016 11:59:12 +1000 (AEST)
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Warn user for minimal RAID5/6
 devices setup
To: linux-btrfs@vger.kernel.org
References: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <8dc214ad-1ebf-c380-95b7-bdc36bcc9c31@crc.id.au>
Date: Fri, 2 Sep 2016 11:59:07 +1000
MIME-Version: 1.0
In-Reply-To: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L1CCRctDh7T90pbeUSaGScdfssVthVoXQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L1CCRctDh7T90pbeUSaGScdfssVthVoXQ
Content-Type: multipart/mixed; boundary="7NtBNafxaf8ODulNFrivgmW7Mjs09oWwR"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <8dc214ad-1ebf-c380-95b7-bdc36bcc9c31@crc.id.au>
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Warn user for minimal RAID5/6
 devices setup
References: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>

--7NtBNafxaf8ODulNFrivgmW7Mjs09oWwR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Is it worthwhile adding a note that RAID5 / RAID6 may very well eat your
data at this stage?

On 02/09/16 11:41, Qu Wenruo wrote:
> For RAID5, 2 devices setup is just RAID1 with more overhead.
> For RAID6, 3 devices setup is RAID1 with 3 copies, not what most user
> want.
>=20
> So warn user at mkfs time for such case, and add explain in man pages.
>=20
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  Documentation/mkfs.btrfs.asciidoc | 15 +++++++++++----
>  utils.c                           | 10 ++++++++--
>  2 files changed, 19 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btr=
fs.asciidoc
> index 98fe694..846c08f 100644
> --- a/Documentation/mkfs.btrfs.asciidoc
> +++ b/Documentation/mkfs.btrfs.asciidoc
> @@ -263,18 +263,25 @@ There are the following block group types availab=
le:
>  .2+^.<h| Profile   3+^.^h| Redundancy           .2+^.<h| Min/max devic=
es
>        ^.^h| Copies   ^.^h| Parity     ^.<h| Striping
>  | single  | 1            |                |            | 1/any
> -| DUP     | 2 / 1 device |                |            | 1/any ^(see n=
ote)^
> +| DUP     | 2 / 1 device |                |            | 1/any ^(see n=
ote1)^
>  | RAID0   |              |                | 1 to N     | 2/any
>  | RAID1   | 2            |                |            | 2/any
>  | RAID10  | 2            |                | 1 to N     | 4/any
> -| RAID5   | 1            | 1              | 2 to N - 1 | 2/any
> -| RAID6   | 1            | 2              | 3 to N - 2 | 3/any
> +| RAID5   | 1            | 1              | 2 to N - 1 | 2/any ^(see n=
ote2)^
> +| RAID6   | 1            | 2              | 3 to N - 2 | 3/any ^(see n=
ote3)^
>  |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -'Note:' DUP may exist on more than 1 device if it starts on a single d=
evice and
> +'Note1:' DUP may exist on more than 1 device if it starts on a single =
device and
>  another one is added. Since version 4.5.1, *mkfs.btrfs* will let you c=
reate DUP
>  on multiple devices.
> =20
> +'Note2:' It's not recommended to use 2 devices RAID5. In that case,
> +parity stripe will contains the same data of data stripe, making RAID5=
 degraded
> +to RAID1 with more overhead.
> +
> +'Note3:' It's also not recommended to use 3 devices RAID6, unless one =
wants to
> +get 3 copies RAID1, which btrfs doesn't provide yet.
> +
>  DUP PROFILES ON A SINGLE DEVICE
>  -------------------------------
> =20
> diff --git a/utils.c b/utils.c
> index 82f3376..1d6879a 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -3314,6 +3314,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u=
64 data_profile,
>  	u64 dev_cnt, int mixed, int ssd)
>  {
>  	u64 allowed =3D 0;
> +	u64 profile =3D metadata_profile | data_profile;
> =20
>  	switch (dev_cnt) {
>  	default:
> @@ -3328,8 +3329,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u=
64 data_profile,
>  		allowed |=3D BTRFS_BLOCK_GROUP_DUP;
>  	}
> =20
> -	if (dev_cnt > 1 &&
> -	    ((metadata_profile | data_profile) & BTRFS_BLOCK_GROUP_DUP)) {
> +	if (dev_cnt > 1 && profile & BTRFS_BLOCK_GROUP_DUP) {
>  		warning("DUP is not recommended on filesystem with multiple devices"=
);
>  	}
>  	if (metadata_profile & ~allowed) {
> @@ -3349,6 +3349,12 @@ int test_num_disk_vs_raid(u64 metadata_profile, =
u64 data_profile,
>  		return 1;
>  	}
> =20
> +	if (dev_cnt =3D=3D 3 && profile & BTRFS_BLOCK_GROUP_RAID6) {
> +		warning("RAID6 is not recommended on filesystem with 3 devices only"=
);
> +	}
> +	if (dev_cnt =3D=3D 2 && profile & BTRFS_BLOCK_GROUP_RAID5) {
> +		warning("RAID5 is not recommended on filesystem with 2 devices only"=
);
> +	}
>  	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd,
>  		   "DUP may not actually lead to 2 copies on the device, see manual =
page");
> =20
>=20

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--7NtBNafxaf8ODulNFrivgmW7Mjs09oWwR--

--L1CCRctDh7T90pbeUSaGScdfssVthVoXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXyNzvAAoJEEGvNdV6fTHcEfUQAKDALmptkCyCdKTfMYLAxxWU
AvzO37L5CaWIiK8srrcUkmZxNSHwluR0o1BTxOSGkUdaldMwwc9L47dHpUVbWFXp
xQ97e5ay17nGIZ7RjCMeBZOdsC92/arrB5y4JSMFypVBJcunsNy+pZm/6Y45M/NZ
L1T0cWn9mIr3Hh0KLJt1PW4tDNGelEIF3my5dG+coc5BnHd7Avqy1UgHyK0yNnOr
m7So2hb2RSYdPyvM0x3pFXntPeu1e6yMbQ6/n/d2H0fHWnZoZGM3kEy92VYeNlMN
A2AtPzQmy55/k1pEDv92s+Mw0upDozt4NNAJmG9IsXSIyhVu6UygHS4LkTuxeY+n
WHkDm+6X3R/aZ3FRvSvHnt0/6B2BA9ZAikozWX6ibpHXiKe4itDkawVe+xlK/vBy
uAd30hvIekzdrSt8zlhclpMbxvzTiE360nSxb9254DVpEx5Y8H9CcqGeDgN/3gwc
okJ+WzRXgEOmFxG6PB8k1rwdQYRxjHaKmkKK0RJW/N7Th6UTdf22xbnwnTP/5p62
bOXc3ecxMEbjLTWZZEIN0tGjSf+KXjrjo3nngslpTtzFZ1T4eC1pDGQJf9zlUH1W
NYLB1h+OJhQ8VthANJ39YespT7iGTKM2gsnoboYOuVdusvTOX2KqwPo419mHlkM5
SErq22tzh65WHIECuGu0
=Pj3F
-----END PGP SIGNATURE-----

--L1CCRctDh7T90pbeUSaGScdfssVthVoXQ--
