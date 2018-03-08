Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33333 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966071AbeCHFdb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 00:33:31 -0500
Subject: Re: [PATCH 06/20] btrfs-progs: qgroups: add pathname to show output
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-7-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bfc620df-a02e-f57a-8526-67797547db59@gmx.com>
Date: Thu, 8 Mar 2018 13:33:19 +0800
MIME-Version: 1.0
In-Reply-To: <20180308024047.10104-7-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tcUO6Oo32j59vUevDVTRKjIL0cdZ4LCSQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tcUO6Oo32j59vUevDVTRKjIL0cdZ4LCSQ
Content-Type: multipart/mixed; boundary="RiWdclPjxZc08Ox7V7PffteW8sEby7oXZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <bfc620df-a02e-f57a-8526-67797547db59@gmx.com>
Subject: Re: [PATCH 06/20] btrfs-progs: qgroups: add pathname to show output
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-7-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-7-jeffm@suse.com>

--RiWdclPjxZc08Ox7V7PffteW8sEby7oXZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 10:40, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> The btrfs qgroup show command currently only exports qgroup IDs,
> forcing the user to resolve which subvolume each corresponds to.
>=20
> This patch adds pathname resolution to qgroup show so that when
> the -P option is used, the last column contains the pathname of
> the root of the subvolume it describes.  In the case of nested
> qgroups, it will show the number of member qgroups or the paths
> of the members if the -v option is used.
>=20
> Pathname can also be used as a sort parameter.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Except one nitpick inlined below.

[snip]
>  	}
> +	if (bq->pathname)
> +		free((void *)bq->pathname);

What about just free(bq->pathname);?

Is this (void *) used to get around the const prefix?

Thanks,
Qu

>  	free(bq);
>  }
> =20
> @@ -1107,7 +1228,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  				info =3D (struct btrfs_qgroup_info_item *)
>  				       (args.buf + off);
> =20
> -				ret =3D update_qgroup_info(qgroup_lookup,
> +				ret =3D update_qgroup_info(fd, qgroup_lookup,
>  							 qgroupid, info);
>  				break;
>  			case BTRFS_QGROUP_LIMIT_KEY:
> @@ -1115,7 +1236,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  				limit =3D (struct btrfs_qgroup_limit_item *)
>  					(args.buf + off);
> =20
> -				ret =3D update_qgroup_limit(qgroup_lookup,
> +				ret =3D update_qgroup_limit(fd, qgroup_lookup,
>  							  qgroupid, limit);
>  				break;
>  			case BTRFS_QGROUP_RELATION_KEY:
> @@ -1159,7 +1280,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  	return ret;
>  }
> =20
> -static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
> +static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, boo=
l verbose)
>  {
> =20
>  	struct rb_node *n;
> @@ -1170,14 +1291,15 @@ static void print_all_qgroups(struct qgroup_loo=
kup *qgroup_lookup)
>  	n =3D rb_first(&qgroup_lookup->root);
>  	while (n) {
>  		entry =3D rb_entry(n, struct btrfs_qgroup, sort_node);
> -		print_single_qgroup_table(entry);
> +		print_single_qgroup_table(entry, verbose);
>  		n =3D rb_next(n);
>  	}
>  }
> =20
>  int btrfs_show_qgroups(int fd,
>  		       struct btrfs_qgroup_filter_set *filter_set,
> -		       struct btrfs_qgroup_comparer_set *comp_set)
> +		       struct btrfs_qgroup_comparer_set *comp_set,
> +		       bool verbose)
>  {
> =20
>  	struct qgroup_lookup qgroup_lookup;
> @@ -1189,7 +1311,7 @@ int btrfs_show_qgroups(int fd,
>  		return ret;
>  	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
>  				  filter_set, comp_set);
> -	print_all_qgroups(&sort_tree);
> +	print_all_qgroups(&sort_tree, verbose);
> =20
>  	__free_all_qgroups(&qgroup_lookup);
>  	return ret;
> diff --git a/qgroup.h b/qgroup.h
> index 875fbdf3..f7ab7de5 100644
> --- a/qgroup.h
> +++ b/qgroup.h
> @@ -59,11 +59,13 @@ enum btrfs_qgroup_column_enum {
>  	BTRFS_QGROUP_MAX_EXCL,
>  	BTRFS_QGROUP_PARENT,
>  	BTRFS_QGROUP_CHILD,
> +	BTRFS_QGROUP_PATHNAME,
>  	BTRFS_QGROUP_ALL,
>  };
> =20
>  enum btrfs_qgroup_comp_enum {
>  	BTRFS_QGROUP_COMP_QGROUPID,
> +	BTRFS_QGROUP_COMP_PATHNAME,
>  	BTRFS_QGROUP_COMP_RFER,
>  	BTRFS_QGROUP_COMP_EXCL,
>  	BTRFS_QGROUP_COMP_MAX_RFER,
> @@ -80,7 +82,7 @@ enum btrfs_qgroup_filter_enum {
>  int btrfs_qgroup_parse_sort_string(const char *opt_arg,
>  				struct btrfs_qgroup_comparer_set **comps);
>  int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
> -		       struct btrfs_qgroup_comparer_set *);
> +		       struct btrfs_qgroup_comparer_set *, bool verbose);
>  void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum col=
umn);
>  void btrfs_qgroup_setup_units(unsigned unit_mode);
>  struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
> diff --git a/utils.c b/utils.c
> index e9cb3a82..7b7f87f1 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2556,15 +2556,9 @@ out:
>  	return ret;
>  }
> =20
> -int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_r=
i, u64 r_id)
> +int get_subvol_info_by_rootid_fd(int fd, struct root_info *get_ri, u64=
 r_id)
>  {
> -	int fd;
>  	int ret;
> -	DIR *dirstream =3D NULL;
> -
> -	fd =3D btrfs_open_dir(mnt, &dirstream, 1);
> -	if (fd < 0)
> -		return -EINVAL;
> =20
>  	memset(get_ri, 0, sizeof(*get_ri));
>  	get_ri->root_id =3D r_id;
> @@ -2574,6 +2568,21 @@ int get_subvol_info_by_rootid(const char *mnt, s=
truct root_info *get_ri, u64 r_i
>  	else
>  		ret =3D btrfs_get_subvol(fd, get_ri);
> =20
> +	return ret;
> +}
> +
> +int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_r=
i,
> +			      u64 r_id)
> +{
> +	int fd;
> +	int ret;
> +	DIR *dirstream =3D NULL;
> +
> +	fd =3D btrfs_open_dir(mnt, &dirstream, 1);
> +	if (fd < 0)
> +		return -EINVAL;
> +
> +	ret =3D get_subvol_info_by_rootid_fd(fd, get_ri, r_id);
>  	if (ret)
>  		error("can't find rootid '%llu' on '%s': %d", r_id, mnt, ret);
> =20
> diff --git a/utils.h b/utils.h
> index b871c9ff..722d3c48 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -154,6 +154,8 @@ int test_isdir(const char *path);
> =20
>  const char *subvol_strip_mountpoint(const char *mnt, const char *full_=
path);
>  int get_subvol_info(const char *fullpath, struct root_info *get_ri);
> +int get_subvol_info_by_rootid_fd(int fd, struct root_info *get_ri,
> +				 u64 rootid_arg);
>  int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_r=
i,
>  							u64 rootid_arg);
>  int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri,=

>=20


--RiWdclPjxZc08Ox7V7PffteW8sEby7oXZ--

--tcUO6Oo32j59vUevDVTRKjIL0cdZ4LCSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqgyx8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg/BAf8Cxt5OK40uQE+LHzI/nC1/YLn
bJC7ZvFTOEZ/AHOOdLpwpxdEXF4PyQHop7QTwO+TFnf1sdXzmHznfOWK3cuU4PZi
Zpkcds/aFdT8xcgh4+JlgBgOyQhfdiofHsZ1J7/92YRuUqvydRULy5kTXCSqv+Pj
0MfiiwnHhpU+3OGi0P1q57Z26rkopHdQukbekuYOQziLeS3CwxVseHYXWUoCie5g
ApD4KAJVbd2JibOkvJ1Fi2vCZ2NRXofYKKLjavPuU6H3Ito11685F+3TV8ygke7O
CWjqxBYKddw5K47hmvEdDgoqAAMSdxmEba5JCe3Tqnohp+vlcjsQ45GJUjI0LA==
=9UUK
-----END PGP SIGNATURE-----

--tcUO6Oo32j59vUevDVTRKjIL0cdZ4LCSQ--
