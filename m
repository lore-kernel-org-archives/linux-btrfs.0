Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:44817 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeCGGfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 01:35:06 -0500
Subject: Re: [PATCH 8/8] btrfs-progs: qgroups: export qgroups usage
 information as JSON
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-9-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2250ef0b-13a2-1a8f-cd19-ea69adf27e7b@gmx.com>
Date: Wed, 7 Mar 2018 14:34:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-9-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2XtTaHcrAusOeXWKL1eYPfDTWHEttnewC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2XtTaHcrAusOeXWKL1eYPfDTWHEttnewC
Content-Type: multipart/mixed; boundary="FfEJzzC4Jc5omKoDQEIW8VcPV8jt9DQf4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <2250ef0b-13a2-1a8f-cd19-ea69adf27e7b@gmx.com>
Subject: Re: [PATCH 8/8] btrfs-progs: qgroups: export qgroups usage
 information as JSON
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-9-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-9-jeffm@suse.com>

--FfEJzzC4Jc5omKoDQEIW8VcPV8jt9DQf4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> One of the common requests I receive is for 'df' like facilities
> for subvolume usage.  Really, the request is for monitoring tools to be=

> able to understand when subvolumes may be approaching quota in the same=

> manner traditional file systems approach ENOSPC.
>=20
> This patch allows us to export the qgroups data in a machine-readable
> format so that monitoring tools can parse it easily.
>=20
> There are two modes since JSON can technically handle 64-bit numbers
> but JavaScript proper cannot.  show -j enables JSON mode using 64-bit
> integers directly.  --json-compat presents 64-bit numbers as an array
> of two 32-bit numbers (high followed by low).
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  Documentation/btrfs-qgroup.asciidoc |   4 +
>  Makefile.inc.in                     |   4 +-
>  cmds-qgroup.c                       |  36 +++++-
>  configure.ac                        |   6 +
>  qgroup.c                            | 211 ++++++++++++++++++++++++++++=
++++++++
>  qgroup.h                            |   3 +
>  6 files changed, 258 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-=
qgroup.asciidoc
> index 360b3269..22a9c2a7 100644
> --- a/Documentation/btrfs-qgroup.asciidoc
> +++ b/Documentation/btrfs-qgroup.asciidoc
> @@ -105,6 +105,10 @@ list all qgroups which impact the given path(inclu=
de ancestral qgroups)
>  list all qgroups which impact the given path(exclude ancestral qgroups=
)
>  -v::::
>  Be more verbose.  Print pathnames of member qgroups when nested.
> +-j::::
> +If enabled, export qgroup usage information in JSON format.  This impl=
ies --raw.
> +--json-compat::::
> +By default, JSON output contains full 64-bit integers, which may be in=
compatible with some JSON parsers.  This option exports those values as a=
n array of 32-bit numbers in [high, low] format.
>  --raw::::
>  raw numbers in bytes, without the 'B' suffix.
>  --human-readable::::
> diff --git a/Makefile.inc.in b/Makefile.inc.in
> index 56271903..68bddbed 100644
> --- a/Makefile.inc.in
> +++ b/Makefile.inc.in
> @@ -18,9 +18,9 @@ BTRFSRESTORE_ZSTD =3D @BTRFSRESTORE_ZSTD@
>  SUBST_CFLAGS =3D @CFLAGS@
>  SUBST_LDFLAGS =3D @LDFLAGS@
> =20
> -LIBS_BASE =3D @UUID_LIBS@ @BLKID_LIBS@ -L. -pthread
> +LIBS_BASE =3D @UUID_LIBS@ @BLKID_LIBS@ @JSON_LIBS@ -L. -pthread
>  LIBS_COMP =3D @ZLIB_LIBS@ @LZO2_LIBS@ @ZSTD_LIBS@
> -STATIC_LIBS_BASE =3D @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ -L. -pthre=
ad
> +STATIC_LIBS_BASE =3D @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ @JSON_LIBS=
_STATIC@ -L. -pthread
>  STATIC_LIBS_COMP =3D @ZLIB_LIBS_STATIC@ @LZO2_LIBS_STATIC@ @ZSTD_LIBS_=
STATIC@
> =20
>  prefix ?=3D @prefix@
> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
> index 94cd0fd3..eee15ef1 100644
> --- a/cmds-qgroup.c
> +++ b/cmds-qgroup.c
> @@ -282,6 +282,10 @@ static const char * const cmd_qgroup_show_usage[] =
=3D {
>  	"               (excluding ancestral qgroups)",
>  	"-P             print first-level qgroups using pathname",
>  	"-v             verbose, prints all nested subvolumes",
> +#ifdef HAVE_JSON
> +	"-j             export in JSON format",
> +	"--json-compat  export in JSON compatibility mode",
> +#endif
>  	HELPINFO_UNITS_LONG,
>  	"--sort=3Dqgroupid,rfer,excl,max_rfer,max_excl,pathname",
>  	"               list qgroups sorted by specified items",
> @@ -302,6 +306,8 @@ static int cmd_qgroup_show(int argc, char **argv)
>  	unsigned unit_mode;
>  	int sync =3D 0;
>  	bool verbose =3D false;
> +	bool export_json =3D false;
> +	bool compat_json =3D false;
> =20
>  	struct btrfs_qgroup_comparer_set *comparer_set;
>  	struct btrfs_qgroup_filter_set *filter_set;
> @@ -314,16 +320,26 @@ static int cmd_qgroup_show(int argc, char **argv)=

>  		int c;
>  		enum {
>  			GETOPT_VAL_SORT =3D 256,
> -			GETOPT_VAL_SYNC
> +			GETOPT_VAL_SYNC,
> +			GETOPT_VAL_JSCOMPAT,
>  		};
>  		static const struct option long_options[] =3D {
>  			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
>  			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
>  			{"verbose", no_argument, NULL, 'v'},
> +#ifdef HAVE_JSON
> +			{"json-compat", no_argument, NULL, GETOPT_VAL_JSCOMPAT},
> +#endif
>  			{ NULL, 0, NULL, 0 }
>  		};
> -
> -		c =3D getopt_long(argc, argv, "pPcreFfv", long_options, NULL);
> +		const char getopt_chars[] =3D {
> +			'p', 'P', 'c', 'r', 'e', 'F', 'f', 'v',
> +#ifdef HAVE_JSON
> +			'j',
> +#endif
> +			'\0' };
> +
> +		c =3D getopt_long(argc, argv, getopt_chars, long_options, NULL);
>  		if (c < 0)
>  			break;
>  		switch (c) {
> @@ -353,6 +369,14 @@ static int cmd_qgroup_show(int argc, char **argv)
>  		case 'f':
>  			filter_flag |=3D 0x2;
>  			break;
> +#ifdef HAVE_JSON
> +		case GETOPT_VAL_JSCOMPAT:
> +			compat_json =3D true;
> +		case 'j':
> +			unit_mode =3D UNITS_RAW;
> +			export_json =3D true;
> +			break;
> +#endif
>  		case GETOPT_VAL_SORT:
>  			ret =3D btrfs_qgroup_parse_sort_string(optarg,
>  							     &comparer_set);
> @@ -405,7 +429,11 @@ static int cmd_qgroup_show(int argc, char **argv)
>  					BTRFS_QGROUP_FILTER_PARENT,
>  					qgroupid);
>  	}
> -	ret =3D btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
> +	if (export_json)
> +		ret =3D btrfs_export_qgroups_json(fd, filter_set, comparer_set,
> +						compat_json);
> +	else
> +		ret =3D btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
>  	close_file_or_dir(fd, dirstream);
>  	free(filter_set);
>  	free(comparer_set);
> diff --git a/configure.ac b/configure.ac
> index 56d17c3a..6aec672a 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -197,6 +197,12 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
>  PKG_CHECK_MODULES(ZLIB, [zlib])
>  PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
> =20
> +PKG_CHECK_MODULES(JSON, [json-c], [

Json-c is quite common and also used by cryptsetup, so pretty good
library choice.

> +	AC_DEFINE(HAVE_JSON, [1], [Have JSON]),
> +	PKG_STATIC(JSON_LIBS_STATIC, [json-c], [
> +		AC_DEFINE(HAVE_JSON_STATIC, [1], [Have JSON static])], [true])
> +	], [true])
> +
>  AC_ARG_ENABLE([zstd],
>  	AS_HELP_STRING([--disable-zstd], [build without zstd support]),
>  	[], [enable_zstd=3Dyes]
> diff --git a/qgroup.c b/qgroup.c
> index 2d0a6947..f632a45c 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -16,12 +16,16 @@
>   * Boston, MA 021110-1307, USA.
>   */
> =20
> +#include "version.h"
>  #include "qgroup.h"
>  #include <sys/ioctl.h>
>  #include "ctree.h"
>  #include "ioctl.h"
>  #include "utils.h"
>  #include <errno.h>
> +#ifdef HAVE_JSON
> +#include <json-c/json.h>
> +#endif
> =20
>  #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
>  #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
> @@ -1346,6 +1350,213 @@ int btrfs_show_qgroups(int fd,
>  	return ret;
>  }
> =20
> +#ifdef HAVE_JSON
> +static void format_qgroupid(char *buf, size_t size, u64 qgroupid)
> +{
> +	int ret;
> +
> +	ret =3D snprintf(buf, size, "%llu/%llu",
> +		       btrfs_qgroup_level(qgroupid),
> +		       btrfs_qgroup_subvid(qgroupid));
> +	ASSERT(ret < sizeof(buf));

This is designed to catch truncated snprintf(), right?
This can be addressed by setting up the @buf properly.
(See below)

And in fact, due to that super magic number, we won't hit this ASSERT()
anyway.

> +}
> +
> +static json_object *export_one_u64(u64 value, bool compat)
> +{
> +	json_object *array, *tmp;
> +
> +	if (!compat)
> +		return json_object_new_int64(value);
> +
> +	array =3D json_object_new_array();
> +	if (!array)
> +		return NULL;
> +
> +	tmp =3D json_object_new_int(value >> 32);
> +	if (!tmp)
> +		goto failure;
> +	json_object_array_add(array, tmp);
> +
> +	tmp =3D json_object_new_int(value & 0xffffffff);
> +	if (!tmp)
> +		goto failure;
> +	json_object_array_add(array, tmp);
> +
> +	return array;
> +failure:
> +	json_object_put(array);
> +	return NULL;
> +}
> +
> +static bool export_one_qgroup(json_object *container,
> +			     const struct btrfs_qgroup *qgroup, bool compat)
> +{
> +	json_object *obj =3D json_object_new_object();
> +	json_object *tmp;
> +	char buf[42];

Answer to the ultimate question of life, the universe, and everything. :)=


Although according to the format level/subvolid, it should be
count_digits(MAX_U16) + 1 + count_digits(MAX_U48) + 1. (1 for '/' and 1
for '\n')

Could be defined as a macro as:
#define QGROUP_FORMAT_BUF_LEN (count_digits(1ULL<<16) + 1 + \
                               count_digits(1ULL<<48) + 1)

BTW, the result is just 22.

Despite that looks good.

Thanks,
Qu

> +
> +	format_qgroupid(buf, sizeof(buf), qgroup->qgroupid);
> +	tmp =3D json_object_new_string(buf);
> +	if (!tmp)
> +		return false;
> +	json_object_object_add(obj, "qgroupid", tmp);
> +
> +	tmp =3D export_one_u64(qgroup->qgroupid, compat);
> +	if (!tmp)
> +		goto failure;
> +	json_object_object_add(obj, "qgroupid_raw", tmp);> +
> +	tmp =3D export_one_u64(qgroup->info.generation, compat);
> +	if (!tmp)
> +		goto failure;
> +	json_object_object_add(obj, "generation", tmp);
> +
> +	tmp =3D export_one_u64(qgroup->info.referenced, compat);
> +	if (!tmp)
> +		goto failure;
> +	json_object_object_add(obj, "referenced_bytes", tmp);
> +
> +	tmp =3D export_one_u64(qgroup->info.exclusive, compat);
> +	if (!tmp)
> +		goto failure;
> +	json_object_object_add(obj, "exclusive_bytes", tmp);
> +
> +	tmp =3D export_one_u64(qgroup->limit.max_referenced, compat);
> +	if (!tmp)
> +		goto failure;
> +	json_object_object_add(obj, "referenced_limit_bytes", tmp);
> +
> +	tmp =3D export_one_u64(qgroup->limit.max_exclusive, compat);
> +	if (!tmp)
> +		goto failure;
> +	json_object_object_add(obj, "exclusive_limit_bytes", tmp);
> +
> +	if (btrfs_qgroup_level(qgroup->qgroupid) =3D=3D 0) {
> +		tmp =3D json_object_new_string(qgroup->pathname);
> +		if (!tmp)
> +			goto failure;
> +		json_object_object_add(obj, "pathname", tmp);
> +	} else {
> +		json_object *array =3D json_object_new_array();
> +		struct btrfs_qgroup_list *list =3D NULL;
> +		if (!array)
> +			goto failure;
> +		json_object_object_add(obj, "members", array);
> +
> +		list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
> +			struct btrfs_qgroup *member =3D list->qgroup;
> +			char buf2[42];
> +
> +			format_qgroupid(buf2, sizeof(buf2), member->qgroupid);
> +			tmp =3D json_object_new_string(buf2);
> +			if (!tmp)
> +				goto failure;
> +
> +			json_object_array_add(array, tmp);
> +		}
> +	}
> +
> +	json_object_object_add(container, buf, obj);
> +	return true;
> +failure:
> +	json_object_put(obj);
> +	return false;
> +}
> +
> +#define BTRFS_JSON_WARNING \
> +"This data contains 64-bit values that are incompatible with Javascrip=
t. Export in compatibility mode using --json-compat."
> +
> +static void export_all_qgroups(const struct qgroup_lookup *qgroup_look=
up,
> +			       bool compat)
> +{
> +
> +	struct rb_node *n;
> +	const char *json;
> +	json_object *container, *dict, *obj;
> +	struct btrfs_qgroup *entry;
> +
> +	container =3D json_object_new_object();
> +	if (!container)
> +		goto failure_msg;
> +
> +	obj =3D json_object_new_string(BTRFS_BUILD_VERSION);
> +	if (!obj)
> +		goto failure;
> +	json_object_object_add(container, "exporter", obj);
> +
> +	if (!compat) {
> +		obj =3D json_object_new_string(BTRFS_JSON_WARNING);
> +		if (!obj)
> +			goto failure;
> +		json_object_object_add(container, "compatibility-warning", obj);
> +
> +		obj =3D json_object_new_string("64-bit");
> +		if (!obj)
> +			goto failure;
> +		json_object_object_add(container, "u64-format", obj);
> +	} else {
> +		obj =3D json_object_new_string("array");
> +		if (!obj)
> +			goto failure;
> +		json_object_object_add(container, "u64-format", obj);
> +	}
> +
> +	dict =3D json_object_new_object();
> +	if (!dict)
> +		goto failure;
> +	json_object_object_add(container, "qgroup_data", dict);
> +
> +	n =3D rb_first(&qgroup_lookup->root);
> +	while (n) {
> +		entry =3D rb_entry(n, struct btrfs_qgroup, sort_node);
> +		if (!export_one_qgroup(dict, entry, compat))
> +			goto failure;
> +		n =3D rb_next(n);
> +	}
> +
> +	json =3D json_object_to_json_string(container);
> +	if (!json)
> +		goto failure;
> +
> +	puts(json);
> +
> +	/* clean up container */
> +	json_object_put(container);
> +	return;
> +
> +failure:
> +	json_object_put(container);
> +failure_msg:
> +	error("Failed to create JSON object.");
> +}
> +#endif
> +
> +int btrfs_export_qgroups_json(int fd,
> +			      struct btrfs_qgroup_filter_set *filter_set,
> +			      struct btrfs_qgroup_comparer_set *comp_set,
> +			      bool compat)
> +{
> +
> +#ifdef HAVE_JSON
> +	struct qgroup_lookup qgroup_lookup;
> +	struct qgroup_lookup sort_tree;
> +	int ret =3D 0;
> +
> +	ret =3D qgroups_search_all(fd, &qgroup_lookup);
> +	if (ret)
> +		return ret;
> +	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
> +				  filter_set, comp_set);
> +	export_all_qgroups(&sort_tree, compat);
> +
> +	__free_all_qgroups(&qgroup_lookup);
> +
> +	return ret;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  int btrfs_qgroup_parse_sort_string(const char *opt_arg,
>  				   struct btrfs_qgroup_comparer_set **comps)
>  {
> diff --git a/qgroup.h b/qgroup.h
> index 688f92b2..2883727b 100644
> --- a/qgroup.h
> +++ b/qgroup.h
> @@ -97,6 +97,9 @@ int btrfs_qgroup_parse_sort_string(const char *opt_ar=
g,
>  				struct btrfs_qgroup_comparer_set **comps);
>  int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
>  		       struct btrfs_qgroup_comparer_set *, bool verbose);
> +int btrfs_export_qgroups_json(int fd, struct btrfs_qgroup_filter_set *=
,
> +			      struct btrfs_qgroup_comparer_set *,
> +			      bool compat);
>  void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum col=
umn);
>  void btrfs_qgroup_setup_units(unsigned unit_mode);
>  struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
>=20


--FfEJzzC4Jc5omKoDQEIW8VcPV8jt9DQf4--

--2XtTaHcrAusOeXWKL1eYPfDTWHEttnewC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqfiA8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qikbAgAgMM3eXVhoHf/cJR90Z6CU2yB
1QcN4PkBq/O5zG9Fn+sQcmFVTMZH7jjJCZDVl+iZ5AFBDywFZlKGbPTXO3EPJ0T7
v7Q0ddSapJjFtmr0v14Ql2irGuFmnF+LCtKufIkVYIcFh8ejru0lyWHEJyXiuYgB
q02iHXVdDgC4WBBZxWFDyx5fwjURpy9S/V3qRD6iV5gT5ihA2YWWf/k56LSLADVe
040lrVSxlvw7VKoXBCizJS7ZR8+9YM3psbVdJ5dEQ8I2RvKvX9n1rLlQzYYbtCd3
TAAiQsDXTOFOi9yyrXkMb9XHaUdSQzrgRvxKqZ9cENaKGXsvLkH0UFdmhNsfzg==
=gPdl
-----END PGP SIGNATURE-----

--2XtTaHcrAusOeXWKL1eYPfDTWHEttnewC--
