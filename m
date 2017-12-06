Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61266 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbdLFHLa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 02:11:30 -0500
Subject: Re: [PATCH] Btrfs: disable FUA if mounted with nobarrier
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
References: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <43e85c2d-8e79-f0f7-6aca-e281ad3c0672@gmx.com>
Date: Wed, 6 Dec 2017 15:11:16 +0800
MIME-Version: 1.0
In-Reply-To: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ogjo7n8s53NoomfmjdLoleBXdPUTIxSbX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ogjo7n8s53NoomfmjdLoleBXdPUTIxSbX
Content-Type: multipart/mixed; boundary="KfLpKjKJ81nlXSlEOGnpFUscxwuxUfToM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Message-ID: <43e85c2d-8e79-f0f7-6aca-e281ad3c0672@gmx.com>
Subject: Re: [PATCH] Btrfs: disable FUA if mounted with nobarrier
References: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>
In-Reply-To: <bf59f09eff9232dcb5872aab4c975a776232b6ac.1512543205.git.osandov@fb.com>

--KfLpKjKJ81nlXSlEOGnpFUscxwuxUfToM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 14:54, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>=20
> I was seeing disk flushes still happening when I mounted a Btrfs
> filesystem with nobarrier for testing. This is because we use FUA to
> write out the first super block, and on devices without FUA support, th=
e
> block layer translates FUA to a flush. Even on devices supporting true
> FUA, using FUA when we asked for no barriers is surprising.
>=20
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/disk-io.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 10a2a579cc7f..a8ecccfc36de 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3231,6 +3231,7 @@ static int write_dev_supers(struct btrfs_device *=
device,
>  	int errors =3D 0;
>  	u32 crc;
>  	u64 bytenr;
> +	int op_flags;
> =20
>  	if (max_mirrors =3D=3D 0)
>  		max_mirrors =3D BTRFS_SUPER_MIRROR_MAX;
> @@ -3273,13 +3274,10 @@ static int write_dev_supers(struct btrfs_device=
 *device,
>  		 * we fua the first super.  The others we allow
>  		 * to go down lazy.
>  		 */
> -		if (i =3D=3D 0) {
> -			ret =3D btrfsic_submit_bh(REQ_OP_WRITE,
> -				REQ_SYNC | REQ_FUA | REQ_META | REQ_PRIO, bh);
> -		} else {
> -			ret =3D btrfsic_submit_bh(REQ_OP_WRITE,
> -				REQ_SYNC | REQ_META | REQ_PRIO, bh);
> -		}
> +		op_flags =3D REQ_SYNC | REQ_META | REQ_PRIO;
> +		if (i =3D=3D 0 && !btrfs_test_opt(device->fs_info, NOBARRIER))
> +			op_flags |=3D REQ_FUA;
> +		ret =3D btrfsic_submit_bh(REQ_OP_WRITE, op_flags, bh);
>  		if (ret)
>  			errors++;
>  	}
>=20


--KfLpKjKJ81nlXSlEOGnpFUscxwuxUfToM--

--ogjo7n8s53NoomfmjdLoleBXdPUTIxSbX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlonmBQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg0Sgf+K5w0aIQjJcnSGfQ9IkeT3CMq
EMfsLje2pOqgKjDJXWXDPS+tAQi9OMMllienHRWA1oQSAgb7bQe4Y1+3k3pytVkm
0wHJOJ9q56q2jGnChsYbeJxQ1GoIkvo4Dl0gUBLRwDOXvW+5d89bceEtB/28nBs5
zu0ZSgGuDgQ/XrMajw4sJMeyzAqCIL8hLG771CZHzN4hAaEIbrnCLD/gsjiTrfam
6FAUHF0/whdog1tHzD4KhrFbrxp3mNjYqWh0tfMs5WQpHpsYo1ooItI9EWa7ht78
2PpIPswEZZovClBr6su0CMkmM7sFiW3tDvKI/tH2b4eJt1BvQtIeXm+BkcaNfA==
=oSx5
-----END PGP SIGNATURE-----

--ogjo7n8s53NoomfmjdLoleBXdPUTIxSbX--
