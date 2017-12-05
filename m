Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62959 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752730AbdLEJWh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:22:37 -0500
Subject: Re: [PATCH 5/7] btrfs-progs: Document logic of btrfs_read_dev_super
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-6-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4ab64089-7336-4831-1092-ebd147e9d865@gmx.com>
Date: Tue, 5 Dec 2017 17:21:57 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-6-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rocW8WEf5nhgtmNi8gTBf188CfTOMfWpk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rocW8WEf5nhgtmNi8gTBf188CfTOMfWpk
Content-Type: multipart/mixed; boundary="pTkv2SVGw8mat0KJEbNxBTvH0De1bViFO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <4ab64089-7336-4831-1092-ebd147e9d865@gmx.com>
Subject: Re: [PATCH 5/7] btrfs-progs: Document logic of btrfs_read_dev_super
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-6-git-send-email-nborisov@suse.com>

--pTkv2SVGw8mat0KJEbNxBTvH0De1bViFO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  disk-io.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/disk-io.c b/disk-io.c
> index 3d8785d5bb37..40077d4919c6 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1419,6 +1419,23 @@ static int check_super(struct btrfs_super_block =
*sb, unsigned sbflags)
>  	return -EIO;
>  }
> =20
> +/*
> + * btrfs_read_dev_super - read a valid superblock from a block device
> + * @fd:		file descrioptor of the device
> + * @sb:		buffer where the superblock is going to be read in
> + * @sb_bytenr:  offset of the particular superblock copie we want
> + * @sbflags:	flags controlling how the superblock is read.
> + *
> + * This function is used by various btrfs comands to obtain a valid su=
perblock.
> + *
> + * It's mode of operation is controlled by the @sb_bytenr and @sbdflag=
s
> + * parameters. If SBREAD_RECOVER flag is set and @sb_bytenr is
> + * BTRFS_SUPER_INFO_OFFSET then the function reads all 3 superblock co=
pies and
> + * returns the newest one. If SBREAD_RECOVER is not set then only a si=
ngle
> + * copy is read, which one is decided by @sb_bytenr. If @sb_bytenr !=3D=

> + * BTRFS_SUPER_INFO_OFFSET then the sbflags is effectively ignored and=
 only a
> + * single copy is read.

Although the logic is not as straightforward, it's still acceptable and
the comment does makes it clearer.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> + */
>  int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_=
bytenr,
>  			 unsigned sbflags)
>  {
>=20


--pTkv2SVGw8mat0KJEbNxBTvH0De1bViFO--

--rocW8WEf5nhgtmNi8gTBf188CfTOMfWpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomZTUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhirQgAkVLKSAsBNx2atz6NczQjelNJ
Tz2u9z6MkKMD7L17TXQB8vijxVFSRcHVuA2c7CaWin6nv87qe4aXTLGNUBldYGeP
Zf5VwfmvLsE0tZ21ZarybSuMF1C4WNR6NM7JSN87VXB6lsRGrnyb24eudFcUdH0J
8Sno35W6RsNViHNkse7n51ARX8ax6C1XtSPV8Qb7Pcqyjt/6K6UeVjVy7CC+8O37
ODWYFlDr5x2B0+9eW5GIKEDvHTZNk4xNsjAr2o+uHi4YIQt5hE/G0JYYxBo1dEBT
jCMD+aWelNsw4latRHVc9gXr0kWJmxIDpYT2k9llF+yy4BmLnYcVbMSoI7y5IQ==
=9RBK
-----END PGP SIGNATURE-----

--rocW8WEf5nhgtmNi8gTBf188CfTOMfWpk--
