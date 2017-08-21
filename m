Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753849AbdHUNIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:08:09 -0400
Subject: Re: [PATCH 4/5] btrfs: Use common error handling code in
 update_ref_path()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <7083c299-4803-68c8-ae57-c0e74f5d9229@users.sourceforge.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <dcd64dfb-944a-2a81-b4a2-8d7ce71d811b@suse.com>
Date: Mon, 21 Aug 2017 09:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <7083c299-4803-68c8-ae57-c0e74f5d9229@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ISRg5qHDHSbMMOXpcEfDFXjR1vG55WL2t"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ISRg5qHDHSbMMOXpcEfDFXjR1vG55WL2t
Content-Type: multipart/mixed; boundary="CCeFG82lP011QfJ145loMChPc2GqtjIVj";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
 linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Message-ID: <dcd64dfb-944a-2a81-b4a2-8d7ce71d811b@suse.com>
Subject: Re: [PATCH 4/5] btrfs: Use common error handling code in
 update_ref_path()
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <7083c299-4803-68c8-ae57-c0e74f5d9229@users.sourceforge.net>
In-Reply-To: <7083c299-4803-68c8-ae57-c0e74f5d9229@users.sourceforge.net>

--CCeFG82lP011QfJ145loMChPc2GqtjIVj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/17 8:41 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 21 Aug 2017 13:34:29 +0200
>=20
> Add a jump target so that a bit of exception handling can be better reu=
sed
> in this function.
>=20
> This issue was detected by using the Coccinelle software.

Adding a jump label in the middle of a conditional for "common" error
handling makes the code more difficult to understand.

-Jeff

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/btrfs/send.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 59fb1ed6ca20..a96edc91a101 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3697,12 +3697,12 @@ static int update_ref_path(struct send_ctx *sct=
x, struct recorded_ref *ref)
>  		return -ENOMEM;
> =20
>  	ret =3D get_cur_path(sctx, ref->dir, ref->dir_gen, new_path);
> -	if (ret < 0) {
> -		fs_path_free(new_path);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto free_path;
> +
>  	ret =3D fs_path_add(new_path, ref->name, ref->name_len);
>  	if (ret < 0) {
> +free_path:
>  		fs_path_free(new_path);
>  		return ret;
>  	}
>=20


--=20
Jeff Mahoney
SUSE Labs


--CCeFG82lP011QfJ145loMChPc2GqtjIVj--

--ISRg5qHDHSbMMOXpcEfDFXjR1vG55WL2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWZrbNB57S2MheeWyAQjkvRAAl3Sf+Q10aWnxD6tdYBkKjDWBQB93mSQx
xdOaJGZuXLF9UpJ+9F8rX3aUEsPxpC1q6xggpdCz/OjRCtQvHpolScuCMQXaQxEx
4WLxd0pvdd/dnBThUvHsBw8Z+gTNSdavA4wmw3YYcSFS+BnKHKavxPBqWGKY6MX1
2TcW+4iOvYxV0vDZxfuLCgJvsEWikZralobrId/cBDFf10XSCriljWX4iZdd/CHW
vKbyygO61eCLd3yPIfeS3xEFioqmxwZrLdjB5BZ+5WLTFmKNxv5TpIAIbKYiWAQ5
rFM9yu7F6O8xzpIo4f1o6fRz1gY1J3fwgvVrC7zG1hYSLjnJfBMvWtmuG+GRQ5K6
TyZsHY6MtPMc3fVFtuSFYuDnfUshKnwqcIiJ7p11fv7QWr2SDIhekKAfwwPSlWe7
m55/A+mTqjyEmh9nSK+aAdzlYcqO7OIwKors4XtzRUmcMV0isvvM1zaMv2B5lMr6
Vttol4bFL73t55jNbMCX/3X22JLBYd1pmukkKH/+X+3zKrLxDr4JGh0PpKL24NRm
elLS+A1b3v3E8YTucDorawVCDdlE6nDvxF8LWDD9QuuQekCOZEpOWmXNkpXLskZE
AfeGfowj1zxTGLjKiemGZZuCFmuD0x5TlkJRMhNJbjkJOp0dzATD4h6ml9yMg++i
2pb5LmL3n8E=
=3BUL
-----END PGP SIGNATURE-----

--ISRg5qHDHSbMMOXpcEfDFXjR1vG55WL2t--
