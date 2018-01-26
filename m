Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55394 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753020AbeAZKCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:02:32 -0500
Subject: Re: [PATCH 10/15] btrfs-progs: check: clear
 I_ERR_FILE_EXTENT_DISCOUNT after repair
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-11-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <566bcb02-9e2a-f73e-b5e7-e5c73cd2cff1@gmx.com>
Date: Fri, 26 Jan 2018 18:02:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-11-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mFFcg4MJ9rJYQvYIe3PtSgES3ovJpHS4F"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mFFcg4MJ9rJYQvYIe3PtSgES3ovJpHS4F
Content-Type: multipart/mixed; boundary="fCczTGZPojElwk1Ehcxs0noIRrycUC1PN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <566bcb02-9e2a-f73e-b5e7-e5c73cd2cff1@gmx.com>
Subject: Re: [PATCH 10/15] btrfs-progs: check: clear
 I_ERR_FILE_EXTENT_DISCOUNT after repair
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-11-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-11-suy.fnst@cn.fujitsu.com>

--fCczTGZPojElwk1Ehcxs0noIRrycUC1PN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> Original check forgets to clear bit I_ERR_FILE_EXTENT_DISCOUNT
> in rec->errors after repair.
>=20
> So just do it.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And a test case for this would help us to avoid further regression.

Thanks,
Qu

> ---
>  cmds-check.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index ae0a9e146399..d8d9a3227c06 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -3978,6 +3978,7 @@ static int repair_inode_discount_extent(struct bt=
rfs_trans_handle *trans,
>  		if (ret < 0)
>  			goto out;
>  	}
> +	rec->errors &=3D ~I_ERR_FILE_EXTENT_DISCOUNT;
>  	printf("Fixed discount file extents for inode: %llu in root: %llu\n",=

>  	       rec->ino, root->objectid);
>  out:
>=20


--fCczTGZPojElwk1Ehcxs0noIRrycUC1PN--

--mFFcg4MJ9rJYQvYIe3PtSgES3ovJpHS4F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq/LEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjSTgf/U1SFVbSVaiMNChLt93AR7gMr
LOguhHqzGk2VM50ymWBTeCCoA6XB2IkGvhFcMMlbpNuwmC4M/aK9eufOWt61BBTn
SstBFXhynpzcFbRnxvt2rcsqefeIcl9Saps96oprqWwBYK6hBPLzdoRN+IU3AqyC
74r/gPTZF9hqlazBHNoWuol3Kc8ebsNLoFGmaF8a8cu4YTuoCyZWCcz54BqGRiV7
jatS+J4CsKWIYXDOsgQZONllvPs131Nt4/B3OFvlMtSSzSL6cwujbP8NCQ4eSnhy
Y7sFJdFmQ8tre14edl7TAwLeRuwMuel7DU7MVdkxNsVGFOzwcDusOzgMsvrMgg==
=58RN
-----END PGP SIGNATURE-----

--mFFcg4MJ9rJYQvYIe3PtSgES3ovJpHS4F--
