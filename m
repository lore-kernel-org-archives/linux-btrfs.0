Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53784 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753249AbeAaAjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 19:39:43 -0500
Subject: Re: [PATCH v2] btrfs: print error if primary super block write fails
To: Howard McLauchlan <hmclauchlan@fb.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>
References: <20180130223349.5808-1-hmclauchlan@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1861909f-521d-6dc2-5cee-bc6c681279e4@gmx.com>
Date: Wed, 31 Jan 2018 08:39:31 +0800
MIME-Version: 1.0
In-Reply-To: <20180130223349.5808-1-hmclauchlan@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xEoKZri8IGeFARYxAYTqVnU23hAn8Jtud"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xEoKZri8IGeFARYxAYTqVnU23hAn8Jtud
Content-Type: multipart/mixed; boundary="tzQFSNlbU9FiSak98KyGYNOLujqehELBd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Howard McLauchlan <hmclauchlan@fb.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@osandov.com>,
 Josef Bacik <jbacik@fb.com>
Message-ID: <1861909f-521d-6dc2-5cee-bc6c681279e4@gmx.com>
Subject: Re: [PATCH v2] btrfs: print error if primary super block write fails
References: <20180130223349.5808-1-hmclauchlan@fb.com>
In-Reply-To: <20180130223349.5808-1-hmclauchlan@fb.com>

--tzQFSNlbU9FiSak98KyGYNOLujqehELBd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8831=E6=97=A5 06:33, Howard McLauchlan wrote:
> Presently, failing a primary super block write but succeeding in at
> least one super block write in general will appear to users as if
> nothing important went wrong. However, upon unmounting and re-mounting,=

> the file system will be in a rolled back state. This was discovered
> with a BCC program that uses bpf_override_return() to fail super block
> writes.
>=20
> This patch outputs an error clarifying that the primary super block
> write has failed, so users can expect potentially erroneous behaviour.
> It also forces wait_dev_supers() to return an error to its caller if
> the primary super block write fails.
>=20
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> V2: Added devid to output, removed unnecessary fs_info parameter
>=20
>  fs/btrfs/disk-io.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5da18ebc9222..6d98f2f21d5f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3298,6 +3298,7 @@ static int wait_dev_supers(struct btrfs_device *d=
evice, int max_mirrors)
>  	struct buffer_head *bh;
>  	int i;
>  	int errors =3D 0;
> +	bool primary_failed =3D false;
>  	u64 bytenr;
> =20
>  	if (max_mirrors =3D=3D 0)
> @@ -3314,11 +3315,14 @@ static int wait_dev_supers(struct btrfs_device =
*device, int max_mirrors)
>  				      BTRFS_SUPER_INFO_SIZE);
>  		if (!bh) {
>  			errors++;
> +			primary_failed =3D (i =3D=3D 0) || primary_failed;
>  			continue;
>  		}
>  		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh))
> +		if (!buffer_uptodate(bh)) {
>  			errors++;
> +			primary_failed =3D (i =3D=3D 0) || primary_failed;
> +		}
> =20
>  		/* drop our reference */
>  		brelse(bh);
> @@ -3327,6 +3331,13 @@ static int wait_dev_supers(struct btrfs_device *=
device, int max_mirrors)
>  		brelse(bh);
>  	}
> =20
> +	/* log error, force error return */
> +	if (primary_failed) {
> +		btrfs_err(device->fs_info, "error writing primary super block to dev=
ice %llu",
> +			  device->devid);
> +		return -1;
> +	}
> +
>  	return errors < i ? 0 : -1;
>  }
> =20
>=20


--tzQFSNlbU9FiSak98KyGYNOLujqehELBd--

--xEoKZri8IGeFARYxAYTqVnU23hAn8Jtud
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpxEEMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg3fgf/ZdDr3DVzbET+a4B2ZoV8J+w4
SV2xz2/gjgcN+b4A9y9e3DbTV0G+C2qSWGtkQMuuolpOhLTLoVqa37d1w82Fz3Vd
lNpFvsDF3skGzwKC951kGASXoGKIbSB6ZEGHKr0Oy2yn/uyADmsDmMjOkF8Xtrq8
wkmIhaYQ94ekhYX3EdO5jlZ7YwRU0Hf8L1TxoXhY/qyVv+DNwmd/as0qOLvNMeOo
YDY9iDVBg6h1FdJvaS5LtjFOKg6AhcftyiQdmIGPMkhfeFN8RrIDe6d+Uf4DEEDc
Okld+Xy2tSpaneA9fMoh88IrBgsJa+lfHBhH256i7A9yCrvVW1Dtp5Za6UODWQ==
=2a9p
-----END PGP SIGNATURE-----

--xEoKZri8IGeFARYxAYTqVnU23hAn8Jtud--
