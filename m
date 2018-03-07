Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:40243 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbeCGFqH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 00:46:07 -0500
Subject: Re: [PATCH 4/8] btrfs-progs: qgroups: add pathname to show output
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-5-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <59988490-c594-f505-70af-00361b69d025@gmx.com>
Date: Wed, 7 Mar 2018 13:45:53 +0800
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-5-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UdvD6y9qW0BEnzLQPzvBYkHkbU8FQolvG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UdvD6y9qW0BEnzLQPzvBYkHkbU8FQolvG
Content-Type: multipart/mixed; boundary="CWqh5Gjb17UZ34sbUBosPfzixZEhPhjDP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <59988490-c594-f505-70af-00361b69d025@gmx.com>
Subject: Re: [PATCH 4/8] btrfs-progs: qgroups: add pathname to show output
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-5-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-5-jeffm@suse.com>

--CWqh5Gjb17UZ34sbUBosPfzixZEhPhjDP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
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
> ---
>  Documentation/btrfs-qgroup.asciidoc |   4 +
>  cmds-qgroup.c                       |  17 ++++-
>  kerncompat.h                        |   1 +
>  qgroup.c                            | 142 ++++++++++++++++++++++++++++=
++++----
>  qgroup.h                            |   4 +-
>  utils.c                             |  22 ++++--
>  utils.h                             |   2 +
>  7 files changed, 166 insertions(+), 26 deletions(-)
>=20
> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-=
qgroup.asciidoc
> index 3108457c..360b3269 100644
> --- a/Documentation/btrfs-qgroup.asciidoc
> +++ b/Documentation/btrfs-qgroup.asciidoc
> @@ -97,10 +97,14 @@ print child qgroup id.
>  print limit of referenced size of qgroup.
>  -e::::
>  print limit of exclusive size of qgroup.
> +-P::::
> +print pathname to the root of the subvolume managed by qgroup.  For ne=
sted qgroups, the number of members will be printed unless -v is specifie=
d.
>  -F::::
>  list all qgroups which impact the given path(include ancestral qgroups=
)
>  -f::::
>  list all qgroups which impact the given path(exclude ancestral qgroups=
)
> +-v::::
> +Be more verbose.  Print pathnames of member qgroups when nested.
>  --raw::::
>  raw numbers in bytes, without the 'B' suffix.
>  --human-readable::::
> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
> index 48686436..94cd0fd3 100644
> --- a/cmds-qgroup.c
> +++ b/cmds-qgroup.c
> @@ -280,8 +280,10 @@ static const char * const cmd_qgroup_show_usage[] =
=3D {
>  	"               (including ancestral qgroups)",
>  	"-f             list all qgroups which impact the given path",
>  	"               (excluding ancestral qgroups)",
> +	"-P             print first-level qgroups using pathname",
> +	"-v             verbose, prints all nested subvolumes",

Did you mean the subvolume paths of all children qgroups?

>  	HELPINFO_UNITS_LONG,
> -	"--sort=3Dqgroupid,rfer,excl,max_rfer,max_excl",
> +	"--sort=3Dqgroupid,rfer,excl,max_rfer,max_excl,pathname",
>  	"               list qgroups sorted by specified items",
>  	"               you can use '+' or '-' in front of each item.",
>  	"               (+:ascending, -:descending, ascending default)",
> @@ -299,6 +301,7 @@ static int cmd_qgroup_show(int argc, char **argv)
>  	int filter_flag =3D 0;
>  	unsigned unit_mode;
>  	int sync =3D 0;
> +	bool verbose =3D false;
> =20
>  	struct btrfs_qgroup_comparer_set *comparer_set;
>  	struct btrfs_qgroup_filter_set *filter_set;
> @@ -316,10 +319,11 @@ static int cmd_qgroup_show(int argc, char **argv)=

>  		static const struct option long_options[] =3D {
>  			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
>  			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
> +			{"verbose", no_argument, NULL, 'v'},
>  			{ NULL, 0, NULL, 0 }
>  		};
> =20
> -		c =3D getopt_long(argc, argv, "pcreFf", long_options, NULL);
> +		c =3D getopt_long(argc, argv, "pPcreFfv", long_options, NULL);
>  		if (c < 0)
>  			break;
>  		switch (c) {
> @@ -327,6 +331,10 @@ static int cmd_qgroup_show(int argc, char **argv)
>  			btrfs_qgroup_setup_print_column(
>  				BTRFS_QGROUP_PARENT);
>  			break;
> +		case 'P':
> +			btrfs_qgroup_setup_print_column(
> +				BTRFS_QGROUP_PATHNAME);
> +			break;
>  		case 'c':
>  			btrfs_qgroup_setup_print_column(
>  				BTRFS_QGROUP_CHILD);
> @@ -354,6 +362,9 @@ static int cmd_qgroup_show(int argc, char **argv)
>  		case GETOPT_VAL_SYNC:
>  			sync =3D 1;
>  			break;
> +		case 'v':
> +			verbose =3D true;
> +			break;
>  		default:
>  			usage(cmd_qgroup_show_usage);
>  		}
> @@ -394,7 +405,7 @@ static int cmd_qgroup_show(int argc, char **argv)
>  					BTRFS_QGROUP_FILTER_PARENT,
>  					qgroupid);
>  	}
> -	ret =3D btrfs_show_qgroups(fd, filter_set, comparer_set);
> +	ret =3D btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
>  	close_file_or_dir(fd, dirstream);
>  	free(filter_set);
>  	free(comparer_set);
> diff --git a/kerncompat.h b/kerncompat.h
> index fa96715f..f97495ee 100644
> --- a/kerncompat.h
> +++ b/kerncompat.h
> @@ -29,6 +29,7 @@
>  #include <stddef.h>
>  #include <linux/types.h>
>  #include <stdint.h>
> +#include <stdbool.h>
> =20
>  #include <features.h>
> =20
> diff --git a/qgroup.c b/qgroup.c
> index 67bc0738..83918134 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -40,6 +40,9 @@ struct btrfs_qgroup {
>  	struct rb_node all_parent_node;
>  	u64 qgroupid;
> =20
> +	/* NULL for qgroups with level > 0 */
> +	const char *pathname;
> +
>  	/*
>  	 * info_item
>  	 */
> @@ -133,6 +136,13 @@ static struct {
>  		.unit_mode	=3D 0,
>  		.max_len	=3D 5,
>  	},
> +	{
> +		.name		=3D "pathname",
> +		.column_name	=3D "pathname",
> +		.need_print	=3D 0,
> +		.unit_mode	=3D 0,
> +		.max_len	=3D 10,
> +	},
>  	{
>  		.name		=3D NULL,
>  		.column_name	=3D NULL,
> @@ -210,8 +220,42 @@ static void print_qgroup_column_add_blank(enum btr=
fs_qgroup_column_enum column,
>  		printf(" ");
>  }
> =20
> +void print_pathname_column(struct btrfs_qgroup *qgroup, bool verbose)
> +{
> +	struct btrfs_qgroup_list *list =3D NULL;
> +
> +	fputs("  ", stdout);
> +	if (btrfs_qgroup_level(qgroup->qgroupid) > 0) {
> +		int count =3D 0;

Newline after declaration please.

And declaration in if() {} block doesn't pass checkpath IIRC.

> +		list_for_each_entry(list, &qgroup->qgroups,
> +				    next_qgroup) {
> +			if (verbose) {
> +				struct btrfs_qgroup *member =3D list->qgroup;

Same coding style problem here.

> +				u64 level =3D btrfs_qgroup_level(member->qgroupid);
> +				u64 sid =3D btrfs_qgroup_subvid(member->qgroupid);
> +				if (count)
> +					fputs(" ", stdout);
> +				if (btrfs_qgroup_level(member->qgroupid) =3D=3D 0)
> +					fputs(member->pathname, stdout);

What about checking member->pathname before outputting?
As it could be missing.

> +				else
> +					printf("%llu/%llu", level, sid);
> +			}
> +			count++;
> +		}
> +		if (!count)
> +			fputs("<empty>", stdout);
> +		else if (!verbose)
> +			printf("<%u member qgroup%c>", count,
> +			       count !=3D 1 ? 's' : '\0');
> +	} else if (qgroup->pathname)
> +		fputs(qgroup->pathname, stdout);
> +	else
> +		fputs("<missing>", stdout);
> +}
> +
>  static void print_qgroup_column(struct btrfs_qgroup *qgroup,
> -				enum btrfs_qgroup_column_enum column)
> +				enum btrfs_qgroup_column_enum column,
> +				bool verbose)
>  {
>  	int len;
>  	int unit_mode =3D btrfs_qgroup_columns[column].unit_mode;
> @@ -253,19 +297,22 @@ static void print_qgroup_column(struct btrfs_qgro=
up *qgroup,
>  		len =3D print_child_column(qgroup);
>  		print_qgroup_column_add_blank(BTRFS_QGROUP_CHILD, len);
>  		break;
> +	case BTRFS_QGROUP_PATHNAME:
> +		print_pathname_column(qgroup, verbose);
> +		break;
>  	default:
>  		break;
>  	}
>  }
> =20
> -static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
> +static void print_single_qgroup_table(struct btrfs_qgroup *qgroup, boo=
l verbose)
>  {
>  	int i;
> =20
>  	for (i =3D 0; i < BTRFS_QGROUP_ALL; i++) {
>  		if (!btrfs_qgroup_columns[i].need_print)
>  			continue;
> -		print_qgroup_column(qgroup, i);
> +		print_qgroup_column(qgroup, i, verbose);
> =20
>  		if (i !=3D BTRFS_QGROUP_ALL - 1)
>  			printf(" ");
> @@ -338,6 +385,47 @@ static int comp_entry_with_qgroupid(struct btrfs_q=
group *entry1,
>  	return is_descending ? -ret : ret;
>  }
> =20
> +/* Sorts first-level qgroups by pathname and nested qgroups by qgroupi=
d */
> +static int comp_entry_with_pathname(struct btrfs_qgroup *entry1,
> +				    struct btrfs_qgroup *entry2,
> +				    int is_descending)
> +{
> +	int ret =3D 0;
> +	const char *p1 =3D entry1->pathname;
> +	const char *p2 =3D entry2->pathname;
> +
> +	u64 level1 =3D btrfs_qgroup_level(entry1->qgroupid);
> +	u64 level2 =3D btrfs_qgroup_level(entry2->qgroupid);
> +
> +	if (level1 !=3D level2) {
> +		if (entry1->qgroupid > entry2->qgroupid)
> +			ret =3D 1;
> +		else if (entry1->qgroupid < entry2->qgroupid)
> +			ret =3D -1;
> +	}
> +
> +	if (ret)
> +		goto out;
> +
> +	while (*p1 && *p2) {
> +		if (*p1 !=3D *p2)
> +			break;
> +		p1++;
> +		p2++;
> +	}
> +
> +	if (*p1 =3D=3D '/')
> +		ret =3D 1;
> +	else if (*p2 =3D=3D '/')
> +	      ret =3D -1;
> +	else if (*p1 > *p2)
> +	      ret =3D 1;
> +	else if (*p1 < *p2)
> +		ret =3D -1;
> +out:
> +	return is_descending ? -ret : ret;
> +}
> +
>  static int comp_entry_with_rfer(struct btrfs_qgroup *entry1,
>  				struct btrfs_qgroup *entry2,
>  				int is_descending)
> @@ -404,6 +492,7 @@ static int comp_entry_with_max_excl(struct btrfs_qg=
roup *entry1,
> =20
>  static btrfs_qgroup_comp_func all_comp_funcs[] =3D {
>  	[BTRFS_QGROUP_COMP_QGROUPID]	=3D comp_entry_with_qgroupid,
> +	[BTRFS_QGROUP_COMP_PATHNAME]	=3D comp_entry_with_pathname,
>  	[BTRFS_QGROUP_COMP_RFER]	=3D comp_entry_with_rfer,
>  	[BTRFS_QGROUP_COMP_EXCL]	=3D comp_entry_with_excl,
>  	[BTRFS_QGROUP_COMP_MAX_RFER]	=3D comp_entry_with_max_rfer,
> @@ -412,6 +501,7 @@ static btrfs_qgroup_comp_func all_comp_funcs[] =3D =
{
> =20
>  static char *all_sort_items[] =3D {
>  	[BTRFS_QGROUP_COMP_QGROUPID]	=3D "qgroupid",
> +	[BTRFS_QGROUP_COMP_PATHNAME]	=3D "pathname",
>  	[BTRFS_QGROUP_COMP_RFER]	=3D "rfer",
>  	[BTRFS_QGROUP_COMP_EXCL]	=3D "excl",
>  	[BTRFS_QGROUP_COMP_MAX_RFER]	=3D "max_rfer",
> @@ -578,6 +668,25 @@ static struct btrfs_qgroup *qgroup_tree_search(str=
uct qgroup_lookup *root_tree,
>  	return NULL;
>  }
> =20
> +static const char *qgroup_pathname(int fd, u64 qgroupid)
> +{
> +	struct root_info root_info;
> +	int ret;
> +	char *pathname;
> +
> +	ret =3D get_subvol_info_by_rootid_fd(fd, &root_info, qgroupid);
> +	if (ret)
> +		return NULL;
> +
> +	ret =3D asprintf(&pathname, "%s%s",
> +		       root_info.full_path[0] =3D=3D '/' ? "" : "/",
> +		       root_info.full_path);
> +	if (ret < 0)
> +		return NULL;
> +
> +	return pathname;
> +}
> +
>  /*
>   * Lookup or insert btrfs_qgroup into qgroup_lookup.
>   *
> @@ -588,7 +697,7 @@ static struct btrfs_qgroup *qgroup_tree_search(stru=
ct qgroup_lookup *root_tree,
>   * Return the pointer to the btrfs_qgroup if found or if inserted succ=
essfully.
>   * Return ERR_PTR if any error occurred.
>   */
> -static struct btrfs_qgroup *get_or_add_qgroup(
> +static struct btrfs_qgroup *get_or_add_qgroup(int fd,
>  		struct qgroup_lookup *qgroup_lookup, u64 qgroupid)
>  {
>  	struct btrfs_qgroup *bq;
> @@ -608,6 +717,8 @@ static struct btrfs_qgroup *get_or_add_qgroup(
>  	INIT_LIST_HEAD(&bq->qgroups);
>  	INIT_LIST_HEAD(&bq->members);
> =20
> +	bq->pathname =3D qgroup_pathname(fd, qgroupid);
> +

Here qgroup_pathname() will allocate memory, but no one is freeing this
memory.

The cleaner should be in __free_btrfs_qgroup() but there is no
modification to that function.

Thanks,
Qu

>  	ret =3D qgroup_tree_insert(qgroup_lookup, bq);
>  	if (ret) {
>  		error("failed to insert %llu into tree: %s",
> @@ -619,12 +730,12 @@ static struct btrfs_qgroup *get_or_add_qgroup(
>  	return bq;
>  }
> =20
> -static int update_qgroup_info(struct qgroup_lookup *qgroup_lookup, u64=
 qgroupid,
> -			      struct btrfs_qgroup_info_item *info)
> +static int update_qgroup_info(int fd, struct qgroup_lookup *qgroup_loo=
kup,
> +			      u64 qgroupid, struct btrfs_qgroup_info_item *info)
>  {
>  	struct btrfs_qgroup *bq;
> =20
> -	bq =3D get_or_add_qgroup(qgroup_lookup, qgroupid);
> +	bq =3D get_or_add_qgroup(fd, qgroup_lookup, qgroupid);
>  	if (IS_ERR_OR_NULL(bq))
>  		return PTR_ERR(bq);
> =20
> @@ -637,13 +748,13 @@ static int update_qgroup_info(struct qgroup_looku=
p *qgroup_lookup, u64 qgroupid,
>  	return 0;
>  }
> =20
> -static int update_qgroup_limit(struct qgroup_lookup *qgroup_lookup,
> +static int update_qgroup_limit(int fd, struct qgroup_lookup *qgroup_lo=
okup,
>  			       u64 qgroupid,
>  			       struct btrfs_qgroup_limit_item *limit)
>  {
>  	struct btrfs_qgroup *bq;
> =20
> -	bq =3D get_or_add_qgroup(qgroup_lookup, qgroupid);
> +	bq =3D get_or_add_qgroup(fd, qgroup_lookup, qgroupid);
>  	if (IS_ERR_OR_NULL(bq))
>  		return PTR_ERR(bq);
> =20
> @@ -1107,7 +1218,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  				info =3D (struct btrfs_qgroup_info_item *)
>  				       (args.buf + off);
> =20
> -				ret =3D update_qgroup_info(qgroup_lookup,
> +				ret =3D update_qgroup_info(fd, qgroup_lookup,
>  							 qgroupid, info);
>  				break;
>  			case BTRFS_QGROUP_LIMIT_KEY:
> @@ -1115,7 +1226,7 @@ static int __qgroups_search(int fd, struct qgroup=
_lookup *qgroup_lookup)
>  				limit =3D (struct btrfs_qgroup_limit_item *)
>  					(args.buf + off);
> =20
> -				ret =3D update_qgroup_limit(qgroup_lookup,
> +				ret =3D update_qgroup_limit(fd, qgroup_lookup,
>  							  qgroupid, limit);
>  				break;
>  			case BTRFS_QGROUP_RELATION_KEY:
> @@ -1159,7 +1270,7 @@ static int __qgroups_search(int fd, struct qgroup=
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
> @@ -1170,14 +1281,15 @@ static void print_all_qgroups(struct qgroup_loo=
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
> @@ -1189,7 +1301,7 @@ int btrfs_show_qgroups(int fd,
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
> index e9cb3a82..68202142 100644
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
> @@ -2574,6 +2568,20 @@ int get_subvol_info_by_rootid(const char *mnt, s=
truct root_info *get_ri, u64 r_i
>  	else
>  		ret =3D btrfs_get_subvol(fd, get_ri);
> =20
> +	return ret;
> +}
> +
> +int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_r=
i, u64 r_id)
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


--CWqh5Gjb17UZ34sbUBosPfzixZEhPhjDP--

--UdvD6y9qW0BEnzLQPzvBYkHkbU8FQolvG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqffJEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgdVQgAmTiZ8UeFlubHnd7AcpPu4uat
gRbNktRqCksOLIAkzVZdIfqby8a+29YkSGddrc7PouBDD8WZRoUtQ8G+pCm0UhgY
S3S2zyZArNzYJuVm4fTZKljB5viyhI4HRRKYQipOIHGZOV7xd+6Q1IeSA/N388Da
CAu+i70IBAMr1iMS1qrblNF9iaosBFgeQ2117/n9Cmt4ASHPq3b90k+R8YURj/p3
N3i1/FasNZuAv23DKFzQEkIdt0cwMeLm9X6JGHrNn6IFYDGrKtYU34+XHHh52nsP
myTfVqOyxewsIKJAkPUc2gTBvOWwOW0G6UIoJU59XTtO6mJV++c/gscHY7jhdA==
=P9QO
-----END PGP SIGNATURE-----

--UdvD6y9qW0BEnzLQPzvBYkHkbU8FQolvG--
