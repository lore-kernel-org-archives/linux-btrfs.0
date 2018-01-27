Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57717 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbeA0EtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 23:49:23 -0500
Subject: Re: [PATCH] btrfs: print error if primary super block write fails
To: Howard McLauchlan <hmclauchlan@fb.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>
References: <20180126224709.23139-1-hmclauchlan@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <75705b9e-0b20-5f95-b519-093b91c01f13@gmx.com>
Date: Sat, 27 Jan 2018 12:49:12 +0800
MIME-Version: 1.0
In-Reply-To: <20180126224709.23139-1-hmclauchlan@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JlkG98Omac6ZRGE8QiU2LvXFpPcR0tS9Y"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JlkG98Omac6ZRGE8QiU2LvXFpPcR0tS9Y
Content-Type: multipart/mixed; boundary="3xMj5PJhrdpo2Vtd3IFVhUaC0LCyDL20Q";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Howard McLauchlan <hmclauchlan@fb.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@osandov.com>,
 Josef Bacik <jbacik@fb.com>
Message-ID: <75705b9e-0b20-5f95-b519-093b91c01f13@gmx.com>
Subject: Re: [PATCH] btrfs: print error if primary super block write fails
References: <20180126224709.23139-1-hmclauchlan@fb.com>
In-Reply-To: <20180126224709.23139-1-hmclauchlan@fb.com>

--3xMj5PJhrdpo2Vtd3IFVhUaC0LCyDL20Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8827=E6=97=A5 06:47, Howard McLauchlan wrote:
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
> ---
>  fs/btrfs/disk-io.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5da18ebc9222..8f96e1e4c613 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3293,11 +3293,13 @@ static int write_dev_supers(struct btrfs_device=
 *device,
>   * Return number of errors when buffer head is not found or not marked=
 up to
>   * date.
>   */
> -static int wait_dev_supers(struct btrfs_device *device, int max_mirror=
s)
> +static int wait_dev_supers(struct btrfs_fs_info *fs_info,

fs_info can be fetch from device->fs_info.

> +			   struct btrfs_device *device, int max_mirrors)
>  {
>  	struct buffer_head *bh;
>  	int i;
>  	int errors =3D 0;
> +	bool primary_failed =3D false;
>  	u64 bytenr;
> =20
>  	if (max_mirrors =3D=3D 0)
> @@ -3314,11 +3316,14 @@ static int wait_dev_supers(struct btrfs_device =
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
> @@ -3327,6 +3332,12 @@ static int wait_dev_supers(struct btrfs_device *=
device, int max_mirrors)
>  		brelse(bh);
>  	}
> =20
> +	/* log error, force error return */
> +	if (primary_failed) {
> +		btrfs_err(fs_info, "error encountered writing primary super block");=


It would be better if device id can also be outputted.

Otherwise it looks good.

Thanks,
Qu

> +		return -1;
> +	}
> +
>  	return errors < i ? 0 : -1;
>  }
> =20
> @@ -3557,7 +3568,7 @@ int write_all_supers(struct btrfs_fs_info *fs_inf=
o, int max_mirrors)
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
> =20
> -		ret =3D wait_dev_supers(dev, max_mirrors);
> +		ret =3D wait_dev_supers(fs_info, dev, max_mirrors);
>  		if (ret)
>  			total_errors++;
>  	}
>=20


--3xMj5PJhrdpo2Vtd3IFVhUaC0LCyDL20Q--

--JlkG98Omac6ZRGE8QiU2LvXFpPcR0tS9Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpsBMgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiDfgf/ejv1H/afvCVKPIrCqqTxcvJc
CkHe8pV6+GYJtdIg67awLtlt70OBkIL3gV/wCyeBpFp8jNTpYHU+rlW8nYqyWpx9
cRGIKG4MdNZp9Tiu62RZNAxMvN93g5PnmyDE8lUWXV6VN1x5mLdvbEZs7Fmz647j
VQCNhBUQUChIwXH85TNd327Mu4t/zTgvAoTi4e3oxtnzd7T+qUG4PUl3WAxGsv84
p1ULIdYAnGzI/0Ahlazw+udLzWukr+W4IfshTB/PM7hh455vkdPvO3e3hN1N1II6
92Yk3yuGc4pUJXi0iziMi5vodFu6ZRq5qymvVMsH9LnlzRmw39mhmTDGfD/ajA==
=RFpV
-----END PGP SIGNATURE-----

--JlkG98Omac6ZRGE8QiU2LvXFpPcR0tS9Y--
