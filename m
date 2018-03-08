Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59221 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935278AbeCHINi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 03:13:38 -0500
Subject: Re: [PATCH v2 1/3] btrfs-progs: check/lowmem: Fix the incorrect error
 message of check_extent_data_item
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b96bc384-c98f-0351-7c0e-8e7326c92f00@gmx.com>
Date: Thu, 8 Mar 2018 16:13:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="12uwHKPqU0zASyMDZGNuImWXGXUFU5oNf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--12uwHKPqU0zASyMDZGNuImWXGXUFU5oNf
Content-Type: multipart/mixed; boundary="rOAXTxVriZkNPnB4VHaVKdiElwm8up6AV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <b96bc384-c98f-0351-7c0e-8e7326c92f00@gmx.com>
Subject: Re: [PATCH v2 1/3] btrfs-progs: check/lowmem: Fix the incorrect error
 message of check_extent_data_item
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>

--rOAXTxVriZkNPnB4VHaVKdiElwm8up6AV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8828=E6=97=A5 18:13, Lu Fengqi wrote:
> Instead of the disk_bytenr and disk_num_bytes of the extent_item which =
the
> file extent references, we should output the objectid and offset of the=

> file extent. And the leaf may be shared by the file trees, we should pr=
int
> the objectid of the root and the owner of the leaf.
>=20
> Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check d=
ata backref in extent tree")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
> V2: Output the objectid of the root and the owner of the leaf.
>=20
>  check/mode-lowmem.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 62bcf3d2e126..f37b1b2c1571 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2631,9 +2631,9 @@ static int check_extent_data_item(struct btrfs_ro=
ot *root,
> =20
>  	if (!(extent_flags & BTRFS_EXTENT_FLAG_DATA)) {
>  		error(
> -		    "extent[%llu %llu] backref type mismatch, wanted bit: %llx",
> -		    disk_bytenr, disk_num_bytes,
> -		    BTRFS_EXTENT_FLAG_DATA);
> +"file extent[%llu %llu] root %llu owner %llu backref type mismatch, wa=
nted bit: %llx",
> +			fi_key.objectid, fi_key.offset, root->objectid, owner,

Indeed this is much easier to identify the problem.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> +			BTRFS_EXTENT_FLAG_DATA);
>  		err |=3D BACKREF_MISMATCH;
>  	}
> =20
> @@ -2722,8 +2722,9 @@ out:
>  		err |=3D BACKREF_MISSING;
>  	btrfs_release_path(&path);
>  	if (err & BACKREF_MISSING) {
> -		error("data extent[%llu %llu] backref lost",
> -		      disk_bytenr, disk_num_bytes);
> +		error(
> +		"file extent[%llu %llu] root %llu owner %llu backref lost",
> +			fi_key.objectid, fi_key.offset, root->objectid, owner);
>  	}
>  	return err;
>  }
>=20


--rOAXTxVriZkNPnB4VHaVKdiElwm8up6AV--

--12uwHKPqU0zASyMDZGNuImWXGXUFU5oNf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqg8KcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjsTAf+LYO41XObL7MOuyAE0stu1MM7
A0o3w7l+KkRYjqe3bUY03oqCFw5Ck5PqlWWkwl/K9sfV5X5vSr6/0tY81V/8VujC
WBfgxFoWUSHa9E9E9y8rrcQPdyuqjzFJKjJJGswEDFjLRuFaWRAyxwJR/728eiDr
zDxfxsvqh3PBT4c+H8SH0CxnH0mYaqp7qVlwTj/EQ4Tk3DuReIBIGw7CCTTBGTpY
GE0J4WzHlv+waNSLSa3HSum4BYM8TAjKog2RI0onpXIaLMTAd1Ffm2Y0ttH0Evt9
vL19Ldjs9OO75wwNKEIBnBvTiscnt/OK9HBKHhgmK1bFPYom7ypho7lFcV5ZEw==
=43fh
-----END PGP SIGNATURE-----

--12uwHKPqU0zASyMDZGNuImWXGXUFU5oNf--
