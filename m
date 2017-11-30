Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752355AbdK3GsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 01:48:17 -0500
Subject: Re: [PATCH v2 1/3] btrfs-progs: fi defrag: clean up duplicate code if
 find errors
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55a02117-a35c-3a5f-e8d7-23a0a1be0dfd@gmx.com>
Date: Thu, 30 Nov 2017 14:47:59 +0800
MIME-Version: 1.0
In-Reply-To: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1nm8JUGhGoLD9QsPImlfhLko9iGXShimb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1nm8JUGhGoLD9QsPImlfhLko9iGXShimb
Content-Type: multipart/mixed; boundary="B0Fh1X9J9OatA7Ebq40VbItpAr9u8JG3b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <55a02117-a35c-3a5f-e8d7-23a0a1be0dfd@gmx.com>
Subject: Re: [PATCH v2 1/3] btrfs-progs: fi defrag: clean up duplicate code if
 find errors
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>

--B0Fh1X9J9OatA7Ebq40VbItpAr9u8JG3b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 17:14, Su Yue wrote:
> In function cmd_filesystem_defrag(), lines of code for error handling
> are duplicate and hard to expand in further.
>=20
> Create a jump label for errors.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
> Changelog:
> v2:	Record -errno to return value if open() and fstat() failed.
> 	Move change "do no exit if defrag range ioctl is unsupported"
> 	to another patch.
> 	Suggested by David.
> ---
>  cmds-filesystem.c | 44 ++++++++++++++++++++++++--------------------
>  1 file changed, 24 insertions(+), 20 deletions(-)
>=20
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 7728430f16a1..17d399d58adf 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -1029,23 +1029,22 @@ static int cmd_filesystem_defrag(int argc, char=
 **argv)
>  		if (fd < 0) {
>  			error("cannot open %s: %s", argv[i],
>  					strerror(errno));
> -			defrag_global_errors++;
> -			close_file_or_dir(fd, dirstream);
> -			continue;
> +			ret =3D -errno;
> +			goto next;
>  		}
> -		if (fstat(fd, &st)) {
> +
> +		ret =3D fstat(fd, &st);
> +		if (ret) {
>  			error("failed to stat %s: %s",
>  					argv[i], strerror(errno));
> -			defrag_global_errors++;
> -			close_file_or_dir(fd, dirstream);
> -			continue;
> +			ret =3D -errno;
> +			goto next;
>  		}
>  		if (!(S_ISDIR(st.st_mode) || S_ISREG(st.st_mode))) {
>  			error("%s is not a directory or a regular file",
>  					argv[i]);
> -			defrag_global_errors++;
> -			close_file_or_dir(fd, dirstream);
> -			continue;
> +			ret =3D -EINVAL;
> +			goto next;

Here, unlike the ftw callback, which ignore non-regular file, here we
count them as error.

So if there is some especial file in dir (use "example_dir" as an
example), then
# btrfs fi defrag -r example_dir
will return no error.

While
# btrfs fi defrag -r example_dir/*
Will return error.

IIRC such inconsistent behavior is a bigger problem, and reusing the
defrag_callback() will not only makes the behavior consistent, but also
simplify the loop.

Thanks,
Qu


>  		}
>  		if (recursive && S_ISDIR(st.st_mode)) {
>  			ret =3D nftw(argv[i], defrag_callback, 10,
> @@ -1060,20 +1059,25 @@ static int cmd_filesystem_defrag(int argc, char=
 **argv)
>  			ret =3D ioctl(fd, BTRFS_IOC_DEFRAG_RANGE,
>  					&defrag_global_range);
>  			defrag_err =3D errno;
> -		}
> -		close_file_or_dir(fd, dirstream);
> -		if (ret && defrag_err =3D=3D ENOTTY) {
> -			error(
> +			if (ret && defrag_err =3D=3D ENOTTY) {
> +				error(
>  "defrag range ioctl not supported in this kernel version, 2.6.33 and n=
ewer is required");
> -			defrag_global_errors++;
> -			break;
> +				defrag_global_errors++;
> +				close_file_or_dir(fd, dirstream);
> +				break;
> +			}
> +			if (ret) {
> +				error("defrag failed on %s: %s", argv[i],
> +				      strerror(defrag_err));
> +				goto next;
> +			}
>  		}
> -		if (ret) {
> -			error("defrag failed on %s: %s", argv[i],
> -					strerror(defrag_err));
> +next:
> +		if (ret)
>  			defrag_global_errors++;
> -		}
> +		close_file_or_dir(fd, dirstream);
>  	}
> +
>  	if (defrag_global_errors)
>  		fprintf(stderr, "total %d failures\n", defrag_global_errors);
> =20
>=20


--B0Fh1X9J9OatA7Ebq40VbItpAr9u8JG3b--

--1nm8JUGhGoLD9QsPImlfhLko9iGXShimb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofqaAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiz/wf/Ut6EZNpJpIchjtnbrEEbFJo/
e2vneOKr/kvKB/0vxUXfnXrXD/ARKmswAGlWsvvTpNPrLOwl6aX1jw8LOWeokQqE
h/iVac0csyQiuRdhQKzUeDyv7X0MXyk3l3LUtnjGsidLd2eY6u0cHe+3c7rxE+3X
fMr4zrznO3Rfxu0stiBsDMNwJ1Fl4dFCD54QEaZEHaO39bXZ+zQJr5Pskk2BtPw6
MBuzMn/bqwpj1CmHb8Hg36qtk9NAiEfMcunV2mvK+Xbwc60zaunld1EzzDs9BjPN
OvKdWmAPzSF9cYfV7PAl2E2yz5aGI7O7n8v1AIIXFUNh79rGzZfJ1nu04Q9l6g==
=cWzn
-----END PGP SIGNATURE-----

--1nm8JUGhGoLD9QsPImlfhLko9iGXShimb--
