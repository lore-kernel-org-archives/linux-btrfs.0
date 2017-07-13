Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35971 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751176AbdGMNZ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 09:25:57 -0400
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170713041642.27125-1-anand.jain@oracle.com>
From: Jeffrey Mahoney <jeffm@suse.com>
Message-ID: <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
Date: Thu, 13 Jul 2017 09:25:49 -0400
MIME-Version: 1.0
In-Reply-To: <20170713041642.27125-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xlxxqI1I6qww3iV2X8jUeq6xKted8Uc2J"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xlxxqI1I6qww3iV2X8jUeq6xKted8Uc2J
Content-Type: multipart/mixed; boundary="3eClxgWWuXcJIGI3V1H3NUn3PiGlw3Vjr";
 protected-headers="v1"
From: Jeffrey Mahoney <jeffm@suse.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
References: <20170713041642.27125-1-anand.jain@oracle.com>
In-Reply-To: <20170713041642.27125-1-anand.jain@oracle.com>

--3eClxgWWuXcJIGI3V1H3NUn3PiGlw3Vjr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/17 12:16 AM, Anand Jain wrote:
> As users generally organize the subvols and snapshots based on the subv=
ol
> directory hierarchy. So providing an ability to sort them by topid woul=
d
> help. Thanks.

What is a topid?  I needed to look at the code to discover this and it's
not even documented as part of the root_info structure.  Users are going
to have no idea what this means.

-Jeff


> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-list.c     | 18 ++++++++++++++++++
>  btrfs-list.h     |  1 +
>  cmds-subvolume.c |  8 ++++----
>  3 files changed, 23 insertions(+), 4 deletions(-)
>=20
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 92a537f425f3..733e22bc2524 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -188,11 +188,28 @@ static int comp_entry_with_path(struct root_info =
*entry1,
>  	return is_descending ? -ret : ret;
>  }
> =20
> +static int comp_entry_with_topid(struct root_info *entry1,
> +				struct root_info *entry2,
> +				int is_descending)
> +{
> +	int ret;
> +
> +	if (entry1->top_id > entry2->top_id)
> +		ret =3D 1;
> +	else if (entry1->top_id < entry2->top_id)
> +		ret =3D -1;
> +	else
> +		ret =3D 0;
> +
> +	return is_descending ? -ret : ret;
> +}
> +
>  static btrfs_list_comp_func all_comp_funcs[] =3D {
>  	[BTRFS_LIST_COMP_ROOTID]	=3D comp_entry_with_rootid,
>  	[BTRFS_LIST_COMP_OGEN]		=3D comp_entry_with_ogen,
>  	[BTRFS_LIST_COMP_GEN]		=3D comp_entry_with_gen,
>  	[BTRFS_LIST_COMP_PATH]		=3D comp_entry_with_path,
> +	[BTRFS_LIST_COMP_TOPID]		=3D comp_entry_with_topid,
>  };
> =20
>  static char *all_sort_items[] =3D {
> @@ -200,6 +217,7 @@ static char *all_sort_items[] =3D {
>  	[BTRFS_LIST_COMP_OGEN]		=3D "ogen",
>  	[BTRFS_LIST_COMP_GEN]		=3D "gen",
>  	[BTRFS_LIST_COMP_PATH]		=3D "path",
> +	[BTRFS_LIST_COMP_TOPID]		=3D "topid",
>  	[BTRFS_LIST_COMP_MAX]		=3D NULL,
>  };
> =20
> diff --git a/btrfs-list.h b/btrfs-list.h
> index 6e5fc7784fb1..9a3869a452a8 100644
> --- a/btrfs-list.h
> +++ b/btrfs-list.h
> @@ -152,6 +152,7 @@ enum btrfs_list_comp_enum {
>  	BTRFS_LIST_COMP_OGEN,
>  	BTRFS_LIST_COMP_GEN,
>  	BTRFS_LIST_COMP_PATH,
> +	BTRFS_LIST_COMP_TOPID,
>  	BTRFS_LIST_COMP_MAX,
>  };
> =20
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index de5e0da0ff48..17b680d26e86 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -416,10 +416,10 @@ static const char * const cmd_subvol_list_usage[]=
 =3D {
>  	"-C [+|-]value",
>  	"             filter the subvolumes by ogeneration",
>  	"             (+value: >=3D value; -value: <=3D value; value: =3D val=
ue)",
> -	"--sort=3Dgen,ogen,rootid,path",
> -	"             list the subvolume in order of gen, ogen, rootid or pat=
h",
> -	"             you also can add '+' or '-' in front of each items.",
> -	"             (+:ascending, -:descending, ascending default)",
> +	"--sort=3Dgen,ogen,rootid,path,topid",
> +	"             list the subvolumes in order of gen, ogen, rootid, path=
",
> +	"             or topid. You also can add '+' or '-' in front of each"=
,
> +	"             items. (+:ascending, -:descending, ascending default)",=

>  	NULL,
>  };
> =20
>=20


--=20
Jeff Mahoney
SUSE Labs


--3eClxgWWuXcJIGI3V1H3NUn3PiGlw3Vjr--

--xlxxqI1I6qww3iV2X8jUeq6xKted8Uc2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWWd04R57S2MheeWyAQi5CA//ZXxzyz+JDJvo7yI3vuB6XPlZvtoz3bc8
YD9DAq7IvdKFc7jXLyYGVWIGF0ExMXN4cGkMjASCKo0VTe/x62ZMxE2uHE3Xjt60
epWooS/vvcozX51Wrg/56GP9UIV8hjeAGBFx/XfVB7Ystj9IkH9UXdBw3HMiWMOL
sruBfFpIrRwf7vEA2uXMVOnunpvlzKTiDsio4aQB0n/vnXUvX4tqNAAMpbPT8UbX
YqxDKT2KCV1YVwdxBmB5Eboj/XVFwbKrVPVe/MUmhsuTs8yOcdbmkZLLBuKrhxsj
RGhUPTrFbqi81yarJDCaz8sq69wjn2mXTUcEKWk0hk150ApgT7CmqNTrkNMH+ja5
ArOBgwxNCVAMf4XzoPQZRwduGGXBVQ61r1R8p8NAV7pBbn7ifjSmwPic3wpdJT7q
NGubTHGRXuzEabASA0eTEw0N+RPqomD0NjOK8KFfdd4yWJslabdl8jvZO/RzOtVh
ys7inSTNm2rX7+qtSWAXDc+APRy5VGVFf9cfvkVsVKAmZhkMJTBPLHi94VMCeZkV
rJzVcAXsKelN/pxjE9HIW+Bg7uqLhk1bsQSqE5GfIQxSgS6LsZgyojqwp25yHQ6L
VCgdIoLZnbseOPAaFb4mxoE6nuX1VV8HWY2KmtLiy4Cn5XlEjfFRJnDoqTHlVmtT
42M3PFn8U30=
=Ft3n
-----END PGP SIGNATURE-----

--xlxxqI1I6qww3iV2X8jUeq6xKted8Uc2J--
