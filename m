Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60113 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751377AbeA0Efi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 23:35:38 -0500
Subject: Re: [PATCH 01/26] btrfs-progs: get rid of undocumented qgroup
 inheritance options
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
References: <cover.1516991902.git.osandov@fb.com>
 <fca7091998d0aff6e7e4118c09dfa3bce80469d0.1516991902.git.osandov@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <31722545-adc5-c02c-702d-3eb4a4966d1a@gmx.com>
Date: Sat, 27 Jan 2018 12:35:26 +0800
MIME-Version: 1.0
In-Reply-To: <fca7091998d0aff6e7e4118c09dfa3bce80469d0.1516991902.git.osandov@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tIDAYHhcd2LqoId4qqlcXRXb5KEk2gXWd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tIDAYHhcd2LqoId4qqlcXRXb5KEk2gXWd
Content-Type: multipart/mixed; boundary="Bb5RYrOyz4PpSamNdMKHCVCknVJv8sglU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Message-ID: <31722545-adc5-c02c-702d-3eb4a4966d1a@gmx.com>
Subject: Re: [PATCH 01/26] btrfs-progs: get rid of undocumented qgroup
 inheritance options
References: <cover.1516991902.git.osandov@fb.com>
 <fca7091998d0aff6e7e4118c09dfa3bce80469d0.1516991902.git.osandov@fb.com>
In-Reply-To: <fca7091998d0aff6e7e4118c09dfa3bce80469d0.1516991902.git.osandov@fb.com>

--Bb5RYrOyz4PpSamNdMKHCVCknVJv8sglU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8827=E6=97=A5 02:40, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>=20
> The -c option to subvol create and the -c and -x options to subvol
> snapshot have never been documented (and -x doesn't actually work
> because it's not in the getopt option string). The functionality is
> dubious and the kernel interface is being removed, so get rid of these.=

>=20

Similar patch is already submitted.

https://patchwork.kernel.org/patch/10125007/

Thanks,
Qu

> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  cmds-subvolume.c | 25 ++-----------------------
>  qgroup.c         | 42 ------------------------------------------
>  qgroup.h         |  2 --
>  3 files changed, 2 insertions(+), 67 deletions(-)
>=20
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index dc626a64..f8e34bc8 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -129,18 +129,11 @@ static int cmd_subvol_create(int argc, char **arg=
v)
>  	DIR	*dirstream =3D NULL;
> =20
>  	while (1) {
> -		int c =3D getopt(argc, argv, "c:i:");
> +		int c =3D getopt(argc, argv, "i:");
>  		if (c < 0)
>  			break;
> =20
>  		switch (c) {
> -		case 'c':
> -			res =3D qgroup_inherit_add_copy(&inherit, optarg, 0);
> -			if (res) {
> -				retval =3D res;
> -				goto out;
> -			}
> -			break;
>  		case 'i':
>  			res =3D qgroup_inherit_add_group(&inherit, optarg);
>  			if (res) {
> @@ -665,18 +658,11 @@ static int cmd_subvol_snapshot(int argc, char **a=
rgv)
> =20
>  	memset(&args, 0, sizeof(args));
>  	while (1) {
> -		int c =3D getopt(argc, argv, "c:i:r");
> +		int c =3D getopt(argc, argv, "i:r");
>  		if (c < 0)
>  			break;
> =20
>  		switch (c) {
> -		case 'c':
> -			res =3D qgroup_inherit_add_copy(&inherit, optarg, 0);
> -			if (res) {
> -				retval =3D res;
> -				goto out;
> -			}
> -			break;
>  		case 'i':
>  			res =3D qgroup_inherit_add_group(&inherit, optarg);
>  			if (res) {
> @@ -687,13 +673,6 @@ static int cmd_subvol_snapshot(int argc, char **ar=
gv)
>  		case 'r':
>  			readonly =3D 1;
>  			break;
> -		case 'x':
> -			res =3D qgroup_inherit_add_copy(&inherit, optarg, 1);
> -			if (res) {
> -				retval =3D res;
> -				goto out;
> -			}
> -			break;
>  		default:
>  			usage(cmd_subvol_snapshot_usage);
>  		}
> diff --git a/qgroup.c b/qgroup.c
> index 156825fd..e9158a26 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -1310,45 +1310,3 @@ int qgroup_inherit_add_group(struct btrfs_qgroup=
_inherit **inherit, char *arg)
> =20
>  	return 0;
>  }
> -
> -int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, cha=
r *arg,
> -			    int type)
> -{
> -	int ret;
> -	u64 qgroup_src;
> -	u64 qgroup_dst;
> -	char *p;
> -	int pos =3D 0;
> -
> -	p =3D strchr(arg, ':');
> -	if (!p) {
> -bad:
> -		error("invalid copy specification, missing separator :");
> -		return -EINVAL;
> -	}
> -	*p =3D 0;
> -	qgroup_src =3D parse_qgroupid(arg);
> -	qgroup_dst =3D parse_qgroupid(p + 1);
> -	*p =3D ':';
> -
> -	if (!qgroup_src || !qgroup_dst)
> -		goto bad;
> -
> -	if (*inherit)
> -		pos =3D (*inherit)->num_qgroups +
> -		      (*inherit)->num_ref_copies * 2 * type;
> -
> -	ret =3D qgroup_inherit_realloc(inherit, 2, pos);
> -	if (ret)
> -		return ret;
> -
> -	(*inherit)->qgroups[pos++] =3D qgroup_src;
> -	(*inherit)->qgroups[pos++] =3D qgroup_dst;
> -
> -	if (!type)
> -		++(*inherit)->num_ref_copies;
> -	else
> -		++(*inherit)->num_excl_copies;
> -
> -	return 0;
> -}
> diff --git a/qgroup.h b/qgroup.h
> index 875fbdf3..bb6610d7 100644
> --- a/qgroup.h
> +++ b/qgroup.h
> @@ -92,7 +92,5 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_c=
omparer_set **comp_set,
>  				int is_descending);
>  int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
>  int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, ch=
ar *arg);
> -int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, cha=
r *arg,
> -			    int type);
> =20
>  #endif
>=20


--Bb5RYrOyz4PpSamNdMKHCVCknVJv8sglU--

--tIDAYHhcd2LqoId4qqlcXRXb5KEk2gXWd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpsAY8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhzAwgAkDiaAxVZ8ZmSgRExdNeVTb9i
wfqM+1SvPwRAWXnzxeND6/Qj53cKX3v7F+37j5V3cmZjPdy8YfVsCOtOAyCvuS6S
bzK4ijlFCHZpFaEffsbkMtaBnTQs15fpStXPX6Vjo84BcayVkCQQ4+xDVPQ9TMv7
as41h7KIwZpyj/B+svWAURWUOYCfpMZ4DTEVRGSUz48t1Byj+XiEF173gCXvW8lS
bgLSZXWxr+WfYpyIP0aybQB/HcNbJ7QokTprv1MffmiZV+SWwoKTqFl1C/Dhp8B1
AW1g979Js9R0hoEtAikxB+xYU+c1xg4tIbjVyL3rZjzJlL03ViqzqU9QbjEY1Q==
=YLiF
-----END PGP SIGNATURE-----

--tIDAYHhcd2LqoId4qqlcXRXb5KEk2gXWd--
