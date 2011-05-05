From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Thu, 5 May 2011 17:44:36 +0300
Message-ID: <20110505174436.63e9e2cf@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MBBV3qHgJ+6IyuahsHw9RZX"; protocol="application/pgp-signature"
Cc: liubo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9ECAF5.50108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/MBBV3qHgJ+6IyuahsHw9RZX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Apr 2011 16:44:37 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

>=20
> When a btrfs disk is created by mixed data & metadata option, it will hav=
e no
> pure data or pure metadata space info.
>=20
> In btrfs's for-linus branch, commit 78b1ea13838039cd88afdd62519b40b344d6c=
920
> (Btrfs: fix OOPS of empty filesystem after balance) initializes space inf=
os at
> the very beginning.  The problem is this initialization does not take the=
 mixed
> case into account, which will cause btrfs will easily get into ENOSPC in =
mixed
> case.
>=20
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Hi Chris!

I confirm it fixes OOpses for me.
Some clarification of what happened down the thread with me in order to con=
vince
this patch actually makes things better.

1. The initial OOps reported by me was a result of using bad mkfs (not inte=
resting,
    but generated a lot of noise here)

2. Then I've patched mkfs properly (used tmp branch), reformatted my partit=
ions and
    caught -ENOSPC on 'rm -rf /var/tmp/' (vanilla kernel), added debugging =
info and have come to the
    conclusion: this patch helps in this situation, as free space was compl=
etely miscomputed
    (it's a regression since 2.6.38). I've applied it and things _mostly_ (=
see 3.) solved (--mixed
    ~4G lzo filesystem) for me

3. Then I've caught more -ENOSPC oopses, which occured to be a bug in mkfs =
for which Arne posted
    a fix today, see his email:
        [PATCH] btrfs progs: fix extra metadata chunk allocation in --mixed=
 case

    Arne's mkfs patch (or btrfs fi balance workaround) fixed rest of OOpses=
 for me.

So, my thoughts:
    - this patch is quite critical for --mixed filesystems
    - it (or it's equivalent) should be considered for pulling-in to .39 ke=
rnel (ideally), as it's a regression since 2.6.38

Thanks!

> ---
>  fs/btrfs/extent-tree.c |   37 ++++++++++++++++++++++++++-----------
>  1 files changed, 26 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f619c3c..1b47ae4 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8781,23 +8781,38 @@ out:
>  int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_space_info *space_info;
> +	struct btrfs_super_block *disk_super;
> +	u64 features;
> +	u64 flags;
> +	int mixed =3D 0;
>  	int ret;
> =20
> -	ret =3D update_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM, 0, 0,
> -								 &space_info);
> -	if (ret)
> -		return ret;
> +	disk_super =3D &fs_info->super_copy;
> +	if (!btrfs_super_root(disk_super))
> +		return 1;
> =20
> -	ret =3D update_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA, 0, 0,
> -								 &space_info);
> -	if (ret)
> -		return ret;
> +	features =3D btrfs_super_incompat_flags(disk_super);
> +	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> +		mixed =3D 1;
> =20
> -	ret =3D update_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA, 0, 0,
> -								 &space_info);
> +	flags =3D BTRFS_BLOCK_GROUP_SYSTEM;
> +	ret =3D update_space_info(fs_info, flags, 0, 0, &space_info);
>  	if (ret)
> -		return ret;
> +		goto out;
> =20
> +	if (mixed) {
> +		flags =3D BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA;
> +		ret =3D update_space_info(fs_info, flags, 0, 0, &space_info);
> +	} else {
> +		flags =3D BTRFS_BLOCK_GROUP_METADATA;
> +		ret =3D update_space_info(fs_info, flags, 0, 0, &space_info);
> +		if (ret)
> +			goto out;
> +
> +		flags =3D BTRFS_BLOCK_GROUP_DATA;
> +		ret =3D update_space_info(fs_info, flags, 0, 0, &space_info);
> +	}
> +out:
>  	return ret;
>  }
> =20
> --=20
> 1.6.5.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20

  Sergei

--Sig_/MBBV3qHgJ+6IyuahsHw9RZX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3Ct9gACgkQcaHudmEf86pThgCbB9jIhhSOkp6jfV+987O1yXM6
aB4AnA4lIWdp5LxB11w+GTym32qsXBQ+
=bb8G
-----END PGP SIGNATURE-----

--Sig_/MBBV3qHgJ+6IyuahsHw9RZX--
