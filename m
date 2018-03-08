Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39163 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966172AbeCHFep (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 00:34:45 -0500
Subject: Re: [PATCH 07/20] btrfs-progs: qgroups: introduce and use info and
 limit structures
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-8-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <359c45b7-e183-9fa8-3ee2-27d30a93b1c3@gmx.com>
Date: Thu, 8 Mar 2018 13:34:36 +0800
MIME-Version: 1.0
In-Reply-To: <20180308024047.10104-8-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ykoUfGhXyuEDSXCIdV1ycA8SEw4oZOS7p"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ykoUfGhXyuEDSXCIdV1ycA8SEw4oZOS7p
Content-Type: multipart/mixed; boundary="kcOMCmpXevFk4IiFnNlCFpnmzg02o7SLe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <359c45b7-e183-9fa8-3ee2-27d30a93b1c3@gmx.com>
Subject: Re: [PATCH 07/20] btrfs-progs: qgroups: introduce and use info and
 limit structures
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-8-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-8-jeffm@suse.com>

--kcOMCmpXevFk4IiFnNlCFpnmzg02o7SLe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 10:40, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> We use structures to pass the info and limit from the kernel as items
> but store the individual values separately in btrfs_qgroup.  We already=

> have a btrfs_qgroup_limit structure that's used for setting the limit.
>=20
> This patch introduces a btrfs_qgroup_info structure and uses that and
> btrfs_qgroup_limit in btrfs_qgroup.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  qgroup.c | 82 ++++++++++++++++++++++++++++++++++----------------------=
--------
>  qgroup.h |  8 +++++++
>  2 files changed, 52 insertions(+), 38 deletions(-)
>=20
> diff --git a/qgroup.c b/qgroup.c
> index 5600da99..57815718 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -46,20 +46,12 @@ struct btrfs_qgroup {
>  	/*
>  	 * info_item
>  	 */
> -	u64 generation;
> -	u64 rfer;	/*referenced*/
> -	u64 rfer_cmpr;	/*referenced compressed*/
> -	u64 excl;	/*exclusive*/
> -	u64 excl_cmpr;	/*exclusive compressed*/
> +	struct btrfs_qgroup_info info;
> =20
>  	/*
>  	 *limit_item
>  	 */
> -	u64 flags;	/*which limits are set*/
> -	u64 max_rfer;
> -	u64 max_excl;
> -	u64 rsv_rfer;
> -	u64 rsv_excl;
> +	struct btrfs_qgroup_limit limit;
> =20
>  	/*qgroups this group is member of*/
>  	struct list_head qgroups;
> @@ -260,6 +252,11 @@ void print_pathname_column(struct btrfs_qgroup *qg=
roup, bool verbose)
>  		fputs("<missing>", stdout);
>  }
> =20
> +static int print_u64(u64 value, int unit_mode, int max_len)
> +{
> +	return printf("%*s", max_len, pretty_size_mode(value, unit_mode));
> +}
> +
>  static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>  				enum btrfs_qgroup_column_enum column,
>  				bool verbose)
> @@ -279,24 +276,26 @@ static void print_qgroup_column(struct btrfs_qgro=
up *qgroup,
>  		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
>  		break;
>  	case BTRFS_QGROUP_RFER:
> -		len =3D printf("%*s", max_len, pretty_size_mode(qgroup->rfer, unit_m=
ode));
> +		len =3D print_u64(qgroup->info.referenced, unit_mode, max_len);
>  		break;
>  	case BTRFS_QGROUP_EXCL:
> -		len =3D printf("%*s", max_len, pretty_size_mode(qgroup->excl, unit_m=
ode));
> +		len =3D print_u64(qgroup->info.exclusive, unit_mode, max_len);
>  		break;
>  	case BTRFS_QGROUP_PARENT:
>  		len =3D print_parent_column(qgroup);
>  		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
>  		break;
>  	case BTRFS_QGROUP_MAX_RFER:
> -		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
> -			len =3D printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, u=
nit_mode));
> +		if (qgroup->limit.flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
> +			len =3D print_u64(qgroup->limit.max_referenced,
> +					unit_mode, max_len);
>  		else
>  			len =3D printf("%*s", max_len, "none");
>  		break;
>  	case BTRFS_QGROUP_MAX_EXCL:
> -		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
> -			len =3D printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, u=
nit_mode));
> +		if (qgroup->limit.flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
> +			len =3D print_u64(qgroup->limit.max_exclusive,
> +					unit_mode, max_len);
>  		else
>  			len =3D printf("%*s", max_len, "none");
>  		break;
> @@ -439,9 +438,9 @@ static int comp_entry_with_rfer(struct btrfs_qgroup=
 *entry1,
>  {
>  	int ret;
> =20
> -	if (entry1->rfer > entry2->rfer)
> +	if (entry1->info.referenced > entry2->info.referenced)
>  		ret =3D 1;
> -	else if (entry1->rfer < entry2->rfer)
> +	else if (entry1->info.referenced < entry2->info.referenced)
>  		ret =3D -1;
>  	else
>  		ret =3D 0;
> @@ -455,9 +454,9 @@ static int comp_entry_with_excl(struct btrfs_qgroup=
 *entry1,
>  {
>  	int ret;
> =20
> -	if (entry1->excl > entry2->excl)
> +	if (entry1->info.exclusive > entry2->info.exclusive)
>  		ret =3D 1;
> -	else if (entry1->excl < entry2->excl)
> +	else if (entry1->info.exclusive < entry2->info.exclusive)
>  		ret =3D -1;
>  	else
>  		ret =3D 0;
> @@ -471,9 +470,9 @@ static int comp_entry_with_max_rfer(struct btrfs_qg=
roup *entry1,
>  {
>  	int ret;
> =20
> -	if (entry1->max_rfer > entry2->max_rfer)
> +	if (entry1->limit.max_referenced > entry2->limit.max_referenced)
>  		ret =3D 1;
> -	else if (entry1->max_rfer < entry2->max_rfer)
> +	else if (entry1->limit.max_referenced < entry2->limit.max_referenced)=

>  		ret =3D -1;
>  	else
>  		ret =3D 0;
> @@ -487,9 +486,9 @@ static int comp_entry_with_max_excl(struct btrfs_qg=
roup *entry1,
>  {
>  	int ret;
> =20
> -	if (entry1->max_excl > entry2->max_excl)
> +	if (entry1->limit.max_exclusive > entry2->limit.max_exclusive)
>  		ret =3D 1;
> -	else if (entry1->max_excl < entry2->max_excl)
> +	else if (entry1->limit.max_exclusive < entry2->limit.max_exclusive)
>  		ret =3D -1;
>  	else
>  		ret =3D 0;
> @@ -747,11 +746,13 @@ static int update_qgroup_info(int fd, struct qgro=
up_lookup *qgroup_lookup,
>  	if (IS_ERR_OR_NULL(bq))
>  		return PTR_ERR(bq);
> =20
> -	bq->generation =3D btrfs_stack_qgroup_info_generation(info);
> -	bq->rfer =3D btrfs_stack_qgroup_info_referenced(info);
> -	bq->rfer_cmpr =3D btrfs_stack_qgroup_info_referenced_compressed(info)=
;
> -	bq->excl =3D btrfs_stack_qgroup_info_exclusive(info);
> -	bq->excl_cmpr =3D btrfs_stack_qgroup_info_exclusive_compressed(info);=

> +	bq->info.generation =3D btrfs_stack_qgroup_info_generation(info);
> +	bq->info.referenced =3D btrfs_stack_qgroup_info_referenced(info);
> +	bq->info.referenced_compressed =3D
> +			btrfs_stack_qgroup_info_referenced_compressed(info);
> +	bq->info.exclusive =3D btrfs_stack_qgroup_info_exclusive(info);
> +	bq->info.exclusive_compressed =3D
> +			btrfs_stack_qgroup_info_exclusive_compressed(info);
> =20
>  	return 0;
>  }
> @@ -766,11 +767,14 @@ static int update_qgroup_limit(int fd, struct qgr=
oup_lookup *qgroup_lookup,
>  	if (IS_ERR_OR_NULL(bq))
>  		return PTR_ERR(bq);
> =20
> -	bq->flags =3D btrfs_stack_qgroup_limit_flags(limit);
> -	bq->max_rfer =3D btrfs_stack_qgroup_limit_max_referenced(limit);
> -	bq->max_excl =3D btrfs_stack_qgroup_limit_max_exclusive(limit);
> -	bq->rsv_rfer =3D btrfs_stack_qgroup_limit_rsv_referenced(limit);
> -	bq->rsv_excl =3D btrfs_stack_qgroup_limit_rsv_exclusive(limit);
> +	bq->limit.flags =3D btrfs_stack_qgroup_limit_flags(limit);
> +	bq->limit.max_referenced =3D
> +			btrfs_stack_qgroup_limit_max_referenced(limit);
> +	bq->limit.max_exclusive =3D
> +			btrfs_stack_qgroup_limit_max_exclusive(limit);
> +	bq->limit.rsv_referenced =3D
> +			btrfs_stack_qgroup_limit_rsv_referenced(limit);
> +	bq->limit.rsv_exclusive =3D btrfs_stack_qgroup_limit_rsv_exclusive(li=
mit);
> =20
>  	return 0;
>  }
> @@ -1063,22 +1067,24 @@ static void __update_columns_max_len(struct btr=
fs_qgroup *bq,
>  			btrfs_qgroup_columns[column].max_len =3D len;
>  		break;
>  	case BTRFS_QGROUP_RFER:
> -		len =3D strlen(pretty_size_mode(bq->rfer, unit_mode));
> +		len =3D strlen(pretty_size_mode(bq->info.referenced, unit_mode));
>  		if (btrfs_qgroup_columns[column].max_len < len)
>  			btrfs_qgroup_columns[column].max_len =3D len;
>  		break;
>  	case BTRFS_QGROUP_EXCL:
> -		len =3D strlen(pretty_size_mode(bq->excl, unit_mode));
> +		len =3D strlen(pretty_size_mode(bq->info.exclusive, unit_mode));
>  		if (btrfs_qgroup_columns[column].max_len < len)
>  			btrfs_qgroup_columns[column].max_len =3D len;
>  		break;
>  	case BTRFS_QGROUP_MAX_RFER:
> -		len =3D strlen(pretty_size_mode(bq->max_rfer, unit_mode));
> +		len =3D strlen(pretty_size_mode(bq->limit.max_referenced,
> +			     unit_mode));
>  		if (btrfs_qgroup_columns[column].max_len < len)
>  			btrfs_qgroup_columns[column].max_len =3D len;
>  		break;
>  	case BTRFS_QGROUP_MAX_EXCL:
> -		len =3D strlen(pretty_size_mode(bq->max_excl, unit_mode));
> +		len =3D strlen(pretty_size_mode(bq->limit.max_exclusive,
> +			     unit_mode));
>  		if (btrfs_qgroup_columns[column].max_len < len)
>  			btrfs_qgroup_columns[column].max_len =3D len;
>  		break;
> diff --git a/qgroup.h b/qgroup.h
> index f7ab7de5..5e71349c 100644
> --- a/qgroup.h
> +++ b/qgroup.h
> @@ -79,6 +79,14 @@ enum btrfs_qgroup_filter_enum {
>  	BTRFS_QGROUP_FILTER_MAX,
>  };
> =20
> +struct btrfs_qgroup_info {
> +	u64 generation;
> +	u64 referenced;
> +	u64 referenced_compressed;
> +	u64 exclusive;
> +	u64 exclusive_compressed;
> +};
> +
>  int btrfs_qgroup_parse_sort_string(const char *opt_arg,
>  				struct btrfs_qgroup_comparer_set **comps);
>  int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
>=20


--kcOMCmpXevFk4IiFnNlCFpnmzg02o7SLe--

--ykoUfGhXyuEDSXCIdV1ycA8SEw4oZOS7p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqgy2wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjtEgf9GhcU6vTTn0z53iJAsTFQ7AMs
ltSP8C42EphaA/wy3w1daLNLTvGi00vwKYyBXPNeO3SZgjNkpExuO2s9hniUZxKs
4FZzTIY0HzX72HmBlY1D7m9GjBSvBeTjB+TChsLhrQ46TitmDn9SGFGvR8fZVCZU
aWGLZBy685JIYRiPppn7J6W4JllFppLVSYeHV2t2kp8ahnWSHBHbeJbRtAzjw/Vw
9snPJBzq66rznWNdGYJhltS00xGQQV7xCxovpq564A0zdcaUPuv+Q4I3nNa8LDia
sxjBTbL7wq+bj0Msxd5Oi2DyuSgsqrkah7vN2dckKJm5tHTdQc2eT/03gNligA==
=CSvr
-----END PGP SIGNATURE-----

--ykoUfGhXyuEDSXCIdV1ycA8SEw4oZOS7p--
