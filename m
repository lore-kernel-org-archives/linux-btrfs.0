Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:44537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750959AbeCGF6w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 00:58:52 -0500
Subject: Re: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-7-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1e0bf346-bef4-c4e5-4054-9cbedb3fd36a@gmx.com>
Date: Wed, 7 Mar 2018 13:58:41 +0800
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-7-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N1SvcvbNJYGNW0lOAQBODNOnYIelWqfSt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N1SvcvbNJYGNW0lOAQBODNOnYIelWqfSt
Content-Type: multipart/mixed; boundary="r7GGkGVIGuxpB4nGwmtmc8MIPfZk0aXns";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <1e0bf346-bef4-c4e5-4054-9cbedb3fd36a@gmx.com>
Subject: Re: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-7-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-7-jeffm@suse.com>

--r7GGkGVIGuxpB4nGwmtmc8MIPfZk0aXns
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> The only mechanism we have in the progs for searching qgroups is to loa=
d
> all of them and filter the results.  This works for qgroup show but
> to add quota information to 'btrfs subvoluem show' it's pretty wasteful=
=2E
>=20
> This patch splits out setting up the search and performing the search s=
o
> we can search for a single qgroupid more easily.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  qgroup.c | 98 +++++++++++++++++++++++++++++++++++++++++++++-----------=
--------
>  qgroup.h |  7 +++++
>  2 files changed, 77 insertions(+), 28 deletions(-)
>=20
> diff --git a/qgroup.c b/qgroup.c
> index b1be3311..2d0a6947 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -1146,11 +1146,11 @@ static inline void print_status_flag_warning(u6=
4 flags)
>  		warning("qgroup data inconsistent, rescan recommended");
>  }
> =20
> -static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_looku=
p)
> +static int __qgroups_search(int fd, struct btrfs_ioctl_search_args *ar=
gs,
> +			    struct qgroup_lookup *qgroup_lookup)
>  {
>  	int ret;
> -	struct btrfs_ioctl_search_args args;
> -	struct btrfs_ioctl_search_key *sk =3D &args.key;
> +	struct btrfs_ioctl_search_key *sk =3D &args->key;
>  	struct btrfs_ioctl_search_header *sh;
>  	unsigned long off =3D 0;
>  	unsigned int i;
> @@ -1161,30 +1161,12 @@ static int __qgroups_search(int fd, struct qgro=
up_lookup *qgroup_lookup)
>  	u64 qgroupid;
>  	u64 qgroupid1;
> =20
> -	memset(&args, 0, sizeof(args));
> -
> -	sk->tree_id =3D BTRFS_QUOTA_TREE_OBJECTID;
> -	sk->max_type =3D BTRFS_QGROUP_RELATION_KEY;
> -	sk->min_type =3D BTRFS_QGROUP_STATUS_KEY;
> -	sk->max_objectid =3D (u64)-1;
> -	sk->max_offset =3D (u64)-1;
> -	sk->max_transid =3D (u64)-1;
> -	sk->nr_items =3D 4096;
> -
>  	qgroup_lookup_init(qgroup_lookup);
> =20
>  	while (1) {
> -		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> +		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, args);
>  		if (ret < 0) {
> -			if (errno =3D=3D ENOENT) {
> -				error("can't list qgroups: quotas not enabled");
> -				ret =3D -ENOTTY;
> -			} else {
> -				error("can't list qgroups: %s",
> -				       strerror(errno));
> -				ret =3D -errno;
> -			}
> -
> +			ret =3D -errno;
>  			break;
>  		}
> =20
> @@ -1198,14 +1180,14 @@ static int __qgroups_search(int fd, struct qgro=
up_lookup *qgroup_lookup)
>  		 * read the root_ref item it contains
>  		 */
>  		for (i =3D 0; i < sk->nr_items; i++) {
> -			sh =3D (struct btrfs_ioctl_search_header *)(args.buf +
> +			sh =3D (struct btrfs_ioctl_search_header *)(args->buf +
>  								  off);
>  			off +=3D sizeof(*sh);
> =20
>  			switch (btrfs_search_header_type(sh)) {
>  			case BTRFS_QGROUP_STATUS_KEY:
>  				si =3D (struct btrfs_qgroup_status_item *)
> -				     (args.buf + off);
> +				     (args->buf + off);
>  				flags =3D btrfs_stack_qgroup_status_flags(si);
> =20
>  				print_status_flag_warning(flags);
> @@ -1213,7 +1195,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  			case BTRFS_QGROUP_INFO_KEY:
>  				qgroupid =3D btrfs_search_header_offset(sh);
>  				info =3D (struct btrfs_qgroup_info_item *)
> -				       (args.buf + off);
> +				       (args->buf + off);
> =20
>  				ret =3D update_qgroup_info(fd, qgroup_lookup,
>  							 qgroupid, info);
> @@ -1221,7 +1203,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  			case BTRFS_QGROUP_LIMIT_KEY:
>  				qgroupid =3D btrfs_search_header_offset(sh);
>  				limit =3D (struct btrfs_qgroup_limit_item *)
> -					(args.buf + off);
> +					(args->buf + off);
> =20
>  				ret =3D update_qgroup_limit(fd, qgroup_lookup,
>  							  qgroupid, limit);
> @@ -1267,6 +1249,66 @@ static int __qgroups_search(int fd, struct qgrou=
p_lookup *qgroup_lookup)
>  	return ret;
>  }
> =20
> +static int qgroups_search_all(int fd, struct qgroup_lookup *qgroup_loo=
kup)
> +{
> +	struct btrfs_ioctl_search_args args =3D {
> +		.key =3D {
> +			.tree_id =3D BTRFS_QUOTA_TREE_OBJECTID,
> +			.max_type =3D BTRFS_QGROUP_RELATION_KEY,
> +			.min_type =3D BTRFS_QGROUP_STATUS_KEY,
> +			.max_objectid =3D (u64)-1,
> +			.max_offset =3D (u64)-1,
> +			.max_transid =3D (u64)-1,
> +			.nr_items =3D 4096,
> +		},
> +	};
> +	int ret;
> +
> +	ret =3D __qgroups_search(fd, &args, qgroup_lookup);
> +	if (ret =3D=3D -ENOTTY)
> +		error("can't list qgroups: quotas not enabled");
> +	else if (ret < 0)
> +		error("can't list qgroups: %s", strerror(-ret));
> +	return ret;
> +}
> +
> +int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_stats=
 *stats)
> +{
> +	struct btrfs_ioctl_search_args args =3D {
> +		.key =3D {
> +			.tree_id =3D BTRFS_QUOTA_TREE_OBJECTID,
> +			.min_type =3D BTRFS_QGROUP_INFO_KEY,
> +			.max_type =3D BTRFS_QGROUP_LIMIT_KEY,
> +			.max_objectid =3D 0,
> +			.max_offset =3D qgroupid,
> +			.max_transid =3D (u64)-1,
> +			.nr_items =3D 4096, /* should be 2, i think */

2 is not correct in fact.

As QGROUP_INFO is smaller than QGROUP_LIMIT, to get a slice of all what
we need, we need to include all other unrelated items.

One example will be:
	item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
	item 2 key (0 QGROUP_INFO 0/257) itemoff 16171 itemsize 40
	item 3 key (0 QGROUP_INFO 1/1) itemoff 16131 itemsize 40
	item 4 key (0 QGROUP_LIMIT 0/5) itemoff 16091 itemsize 40
	item 5 key (0 QGROUP_LIMIT 0/257) itemoff 16051 itemsize 40
	item 6 key (0 QGROUP_LIMIT 1/1) itemoff 16011 itemsize 40

To query qgroup info about 0/257, above setup will get the following slic=
e:
	item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
	item 2 key (0 QGROUP_INFO 0/257) itemoff 16171 itemsize 40
	item 3 key (0 QGROUP_INFO 1/1) itemoff 16131 itemsize 40
	item 4 key (0 QGROUP_LIMIT 0/5) itemoff 16091 itemsize 40
	item 5 key (0 QGROUP_LIMIT 0/257) itemoff 16051 itemsize 40
So we still need that large @nr_items.

Despite this comment it looks good.

Thanks,
Qu

> +		},
> +	};
> +	struct qgroup_lookup qgroup_lookup;
> +	struct btrfs_qgroup *qgroup;
> +	struct rb_node *n;
> +	int ret;
> +
> +	ret =3D __qgroups_search(fd, &args, &qgroup_lookup);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D -ENODATA;
> +	n =3D rb_first(&qgroup_lookup.root);
> +	if (n) {
> +		qgroup =3D rb_entry(n, struct btrfs_qgroup, rb_node);
> +		stats->qgroupid =3D qgroup->qgroupid;
> +		stats->info =3D qgroup->info;
> +		stats->limit =3D qgroup->limit;
> +
> +		ret =3D 0;
> +	}
> +
> +	__free_all_qgroups(&qgroup_lookup);
> +	return ret;
> +}
> +
>  static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, boo=
l verbose)
>  {
> =20
> @@ -1293,7 +1335,7 @@ int btrfs_show_qgroups(int fd,
>  	struct qgroup_lookup sort_tree;
>  	int ret;
> =20
> -	ret =3D __qgroups_search(fd, &qgroup_lookup);
> +	ret =3D qgroups_search_all(fd, &qgroup_lookup);
>  	if (ret)
>  		return ret;
>  	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
> diff --git a/qgroup.h b/qgroup.h
> index 5e71349c..688f92b2 100644
> --- a/qgroup.h
> +++ b/qgroup.h
> @@ -87,6 +87,12 @@ struct btrfs_qgroup_info {
>  	u64 exclusive_compressed;
>  };
> =20
> +struct btrfs_qgroup_stats {
> +	u64 qgroupid;
> +	struct btrfs_qgroup_info info;
> +	struct btrfs_qgroup_limit limit;
> +};
> +
>  int btrfs_qgroup_parse_sort_string(const char *opt_arg,
>  				struct btrfs_qgroup_comparer_set **comps);
>  int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
> @@ -105,4 +111,5 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_in=
herit **inherit, char *arg);
>  int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, cha=
r *arg,
>  			    int type);
> =20
> +int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_stats=
 *stats);
>  #endif
>=20


--r7GGkGVIGuxpB4nGwmtmc8MIPfZk0aXns--

--N1SvcvbNJYGNW0lOAQBODNOnYIelWqfSt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqff5EXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhOzgf7ByGHRsSVJGo52BBliLQ3wE7F
1x0GEAoJpdyPwuvUMCyCJ8oan0fVoPJ31bqzIjEstvy+zrz7Oqq8EKqbP1G45EUK
L5rI4wFMkwR5Pga/2zkFlI5Pi0+Uxk1VE8BzW2IGKVOOluyoqML/o8AwcV8MeVMx
XsNaethC+TtqW01DRaQ6QyKJmGMm3UMsBnpkv0AETymlwDKMkIG+EEKZEbiKCBoc
cl7z1SBVRuho10HybFtUqa5GKNHIkU6AdJanflTX2nHAssrgItUsxZEbTc4Ot2x2
iO+OR9B57FBtbSCb2pP+OkvqJZVxwXhbfmYlVtE8M06FRUGnpo4htAA9yCgxTw==
=Gjll
-----END PGP SIGNATURE-----

--N1SvcvbNJYGNW0lOAQBODNOnYIelWqfSt--
