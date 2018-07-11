Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59813 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbeGKFVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 01:21:36 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: check: enhanced progress indicator
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>,
        linux-btrfs@vger.kernel.org
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
 <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3b66b23f-1998-e7f1-24f9-cdc8cab51c7d@gmx.com>
Date: Wed, 11 Jul 2018 13:18:55 +0800
MIME-Version: 1.0
In-Reply-To: <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IW8Dlg1QcOhWUw5tSBz2nWkeBtm2JNpzn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IW8Dlg1QcOhWUw5tSBz2nWkeBtm2JNpzn
Content-Type: multipart/mixed; boundary="jMOPSAotAjc2xo5kc9wPDdh1jT1p96txe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>,
 linux-btrfs@vger.kernel.org
Message-ID: <3b66b23f-1998-e7f1-24f9-cdc8cab51c7d@gmx.com>
Subject: Re: [PATCH 2/2] btrfs-progs: check: enhanced progress indicator
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
 <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>
In-Reply-To: <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>

--jMOPSAotAjc2xo5kc9wPDdh1jT1p96txe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8805=E6=97=A5 03:20, St=C3=A9phane Lesimple wrot=
e:
> We reuse the task_position enum and task_ctx struct of the original pro=
gress
> indicator, adding more values and fields for our needs.
>=20
> Then add hooks in all steps of the check to properly record progress.
>=20
> Signed-off-by: St=C3=A9phane Lesimple <stephane_btrfs@lesimple.fr>

Looks pretty good.

Just some small nitpicks related to code style.

> ---
>  check/main.c        | 176 ++++++++++++++++++++++++++++++++++----------=
--------
>  check/mode-common.h |  20 ++++++
>  check/mode-lowmem.c |   1 +
>  convert/main.c      |   2 +-
>  qgroup-verify.c     |   7 +++
>  qgroup-verify.h     |   2 +
>  task-utils.c        |   8 ++-
>  task-utils.h        |   3 +-
>  8 files changed, 154 insertions(+), 65 deletions(-)
>=20
> diff --git a/check/main.c b/check/main.c
> index 3190b5d..bb3ebea 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -25,6 +25,7 @@
>  #include <unistd.h>
>  #include <getopt.h>
>  #include <uuid/uuid.h>
> +#include <time.h>
>  #include "ctree.h"
>  #include "volumes.h"
>  #include "repair.h"
> @@ -47,20 +48,6 @@
>  #include "check/mode-original.h"
>  #include "check/mode-lowmem.h"
> =20
> -enum task_position {
> -	TASK_EXTENTS,
> -	TASK_FREE_SPACE,
> -	TASK_FS_ROOTS,
> -	TASK_NOTHING, /* have to be the last element */
> -};
> -
> -struct task_ctx {
> -	int progress_enabled;
> -	enum task_position tp;
> -
> -	struct task_info *info;
> -};
> -
>  u64 bytes_used =3D 0;
>  u64 total_csum_bytes =3D 0;
>  u64 total_btree_bytes =3D 0;
> @@ -72,6 +59,7 @@ u64 data_bytes_referenced =3D 0;
>  LIST_HEAD(duplicate_extents);
>  LIST_HEAD(delete_items);
>  int no_holes =3D 0;
> +static int is_free_space_tree =3D 0;
>  int init_extent_tree =3D 0;
>  int check_data_csum =3D 0;
>  struct btrfs_fs_info *global_info;
> @@ -173,28 +161,48 @@ static int compare_extent_backref(struct rb_node =
*node1, struct rb_node *node2)
>  		return compare_tree_backref(node1, node2);
>  }
> =20
> +static void print_status_check_line(void *p)
> +{
> +	struct task_ctx *priv =3D p;
> +	char *task_position_string[] =3D {
> +		"[1/7] checking root items                     ",
> +		"[2/7] checking extents                        ",
> +		is_free_space_tree ?
> +			"[3/7] checking free space tree                ":

The extra intent makes it a little hard to align the output.

What about using something like below to format the string?
"[%d/%d] %-20s"

And this makes it more flex since lowmem and original mode has different
progress number (lowmem doesn't need to check root refs separately).


> +			"[3/7] checking free space cache               ",
> +		"[4/7] checking fs roots                       ",
> +		check_data_csum ?
> +			"[5/7] checking csums against data             ":
> +			"[5/7] checking csums (without verifying data) ",
> +		"[6/7] checking root refs                      ",
> +		"[7/7] checking quota groups                   ",
> +	};
> +
> +	time_t elapsed =3D time(NULL) - priv->start_time;
> +	int hours   =3D elapsed / 3600;
> +	elapsed    -=3D hours   * 3600;

It's not common in btrfs-progs to mix declaration and code.

Thanks,
Qu

> +	int minutes =3D elapsed / 60;
> +	elapsed    -=3D minutes * 60;
> +	int seconds =3D elapsed;
> +	printf("%s (%d:%02d:%02d elapsed", task_position_string[priv->tp], ho=
urs, minutes, seconds);
> +	if (priv->item_count > 0)
> +		printf(", %llu items checked)\r", priv->item_count);
> +	else
> +		printf(")\r");
> +	fflush(stdout);
> +}
> =20
>  static void *print_status_check(void *p)
>  {
>  	struct task_ctx *priv =3D p;
> -	const char work_indicator[] =3D { '.', 'o', 'O', 'o' };
> -	uint32_t count =3D 0;
> -	static char *task_position_string[] =3D {
> -		"checking extents",
> -		"checking free space cache",
> -		"checking fs roots",
> -	};
> =20
> -	task_period_start(priv->info, 1000 /* 1s */);
> +	task_period_start(priv->info, 50);
> =20
>  	if (priv->tp =3D=3D TASK_NOTHING)
>  		return NULL;
> =20
>  	while (1) {
> -		printf("%s [%c]\r", task_position_string[priv->tp],
> -				work_indicator[count % 4]);
> -		count++;
> -		fflush(stdout);
> +		print_status_check_line(p);
>  		task_period_wait(priv->info);
>  	}
>  	return NULL;
> @@ -202,6 +210,7 @@ static void *print_status_check(void *p)
> =20
>  static int print_status_return(void *p)
>  {
> +	print_status_check_line(p);
>  	printf("\n");
>  	fflush(stdout);
> =20
> @@ -2942,6 +2951,7 @@ static int check_root_refs(struct btrfs_root *roo=
t,
>  		loop =3D 0;
>  		cache =3D search_cache_extent(root_cache, 0);
>  		while (1) {
> +			ctx.item_count++;
>  			if (!cache)
>  				break;
>  			rec =3D container_of(cache, struct root_record, cache);
> @@ -3263,6 +3273,7 @@ static int check_fs_root(struct btrfs_root *root,=

>  	}
> =20
>  	while (1) {
> +		ctx.item_count++;
>  		wret =3D walk_down_tree(root, &path, wc, &level, &nrefs);
>  		if (wret < 0)
>  			ret =3D wret;
> @@ -3340,11 +3351,6 @@ static int check_fs_roots(struct btrfs_fs_info *=
fs_info,
>  	int ret;
>  	int err =3D 0;
> =20
> -	if (ctx.progress_enabled) {
> -		ctx.tp =3D TASK_FS_ROOTS;
> -		task_start(ctx.info);
> -	}
> -
>  	/*
>  	 * Just in case we made any changes to the extent tree that weren't
>  	 * reflected into the free space cache yet.
> @@ -3421,8 +3427,6 @@ out:
>  	if (!cache_tree_empty(&wc.shared))
>  		fprintf(stderr, "warning line %d\n", __LINE__);
> =20
> -	task_stop(ctx.info);
> -
>  	return err;
>  }
> =20
> @@ -3491,8 +3495,6 @@ static int do_check_fs_roots(struct btrfs_fs_info=
 *fs_info,
>  {
>  	int ret;
> =20
> -	if (!ctx.progress_enabled)
> -		fprintf(stderr, "checking fs roots\n");
>  	if (check_mode =3D=3D CHECK_MODE_LOWMEM)
>  		ret =3D check_fs_roots_lowmem(fs_info);
>  	else
> @@ -5329,12 +5331,8 @@ static int check_space_cache(struct btrfs_root *=
root)
>  		return 0;
>  	}
> =20
> -	if (ctx.progress_enabled) {
> -		ctx.tp =3D TASK_FREE_SPACE;
> -		task_start(ctx.info);
> -	}
> -
>  	while (1) {
> +		ctx.item_count++;
>  		cache =3D btrfs_lookup_first_block_group(root->fs_info, start);
>  		if (!cache)
>  			break;
> @@ -5383,8 +5381,6 @@ static int check_space_cache(struct btrfs_root *r=
oot)
>  		}
>  	}
> =20
> -	task_stop(ctx.info);
> -
>  	return error ? -EINVAL : 0;
>  }
> =20
> @@ -5654,6 +5650,7 @@ static int check_csums(struct btrfs_root *root)
>  	}
> =20
>  	while (1) {
> +		ctx.item_count++;
>  		if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[0])) {
>  			ret =3D btrfs_next_leaf(root, &path);
>  			if (ret < 0) {
> @@ -8047,6 +8044,7 @@ static int deal_root_from_list(struct list_head *=
list,
>  		 * can maximize readahead.
>  		 */
>  		while (1) {
> +			ctx.item_count++;
>  			ret =3D run_next_block(root, bits, bits_nr, &last,
>  					     pending, seen, reada, nodes,
>  					     extent_cache, chunk_cache,
> @@ -8134,11 +8132,6 @@ static int check_chunks_and_extents(struct btrfs=
_fs_info *fs_info)
>  		exit(1);
>  	}
> =20
> -	if (ctx.progress_enabled) {
> -		ctx.tp =3D TASK_EXTENTS;
> -		task_start(ctx.info);
> -	}
> -
>  again:
>  	root1 =3D fs_info->tree_root;
>  	level =3D btrfs_header_level(root1->node);
> @@ -8248,7 +8241,6 @@ again:
>  		ret =3D err;
> =20
>  out:
> -	task_stop(ctx.info);
>  	if (repair) {
>  		free_corrupt_blocks_tree(fs_info->corrupt_blocks);
>  		extent_io_tree_cleanup(&excluded_extents);
> @@ -8290,8 +8282,6 @@ static int do_check_chunks_and_extents(struct btr=
fs_fs_info *fs_info)
>  {
>  	int ret;
> =20
> -	if (!ctx.progress_enabled)
> -		fprintf(stderr, "checking extents\n");
>  	if (check_mode =3D=3D CHECK_MODE_LOWMEM)
>  		ret =3D check_chunks_and_extents_lowmem(fs_info);
>  	else
> @@ -9021,6 +9011,7 @@ static int build_roots_info_cache(struct btrfs_fs=
_info *info)
>  		struct cache_extent *entry;
>  		struct root_item_info *rii;
> =20
> +		ctx.item_count++;
>  		if (slot >=3D btrfs_header_nritems(leaf)) {
>  			ret =3D btrfs_next_leaf(info->extent_root, &path);
>  			if (ret < 0) {
> @@ -9559,6 +9550,8 @@ int cmd_check(int argc, char **argv)
>  	if (repair && check_mode =3D=3D CHECK_MODE_LOWMEM)
>  		warning("low-memory mode repair support is only partial");
> =20
> +	printf("Opening filesystem to check...\n");
> +
>  	radix_tree_init();
>  	cache_tree_init(&root_cache);
> =20
> @@ -9732,7 +9725,14 @@ int cmd_check(int argc, char **argv)
>  	}
> =20
>  	if (!init_extent_tree) {
> +		if (!ctx.progress_enabled)
> +			fprintf(stderr, "[1/7] checking root items\n");
> +		else {
> +			ctx.tp =3D TASK_ROOT_ITEMS;
> +			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +		}
>  		ret =3D repair_root_items(info);
> +		task_stop(ctx.info);
>  		if (ret < 0) {
>  			err =3D !!ret;
>  			error("failed to repair root items: %s", strerror(-ret));
> @@ -9752,8 +9752,18 @@ int cmd_check(int argc, char **argv)
>  			goto close_out;
>  		}
>  	}
> +	else {
> +		fprintf(stderr, "[1/7] checking root items... skipped\n");
> +	}
> =20
> +	if (!ctx.progress_enabled)
> +		fprintf(stderr, "[2/7] checking extents\n");
> +	else {
> +		ctx.tp =3D TASK_EXTENTS;
> +		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +	}
>  	ret =3D do_check_chunks_and_extents(info);
> +	task_stop(ctx.info);
>  	err |=3D !!ret;
>  	if (ret)
>  		error(
> @@ -9762,16 +9772,24 @@ int cmd_check(int argc, char **argv)
>  	/* Only re-check super size after we checked and repaired the fs */
>  	err |=3D !is_super_size_valid(info);
> =20
> +	is_free_space_tree =3D btrfs_fs_compat_ro(info, FREE_SPACE_TREE);
> +
>  	if (!ctx.progress_enabled) {
> -		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
> -			fprintf(stderr, "checking free space tree\n");
> +		if (is_free_space_tree)
> +			fprintf(stderr, "[3/7] checking free space tree\n");
>  		else
> -			fprintf(stderr, "checking free space cache\n");
> +			fprintf(stderr, "[3/7] checking free space cache\n");
>  	}
> +	else {
> +		ctx.tp =3D TASK_FREE_SPACE;
> +		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +	}
> +
>  	ret =3D check_space_cache(root);
> +	task_stop(ctx.info);
>  	err |=3D !!ret;
>  	if (ret) {
> -		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
> +		if (is_free_space_tree)
>  			error("errors found in free space tree");
>  		else
>  			error("errors found in free space cache");
> @@ -9785,19 +9803,34 @@ int cmd_check(int argc, char **argv)
>  	 * ignore it when this happens.
>  	 */
>  	no_holes =3D btrfs_fs_incompat(root->fs_info, NO_HOLES);
> +	if (!ctx.progress_enabled)
> +		fprintf(stderr, "[4/7] checking fs roots\n");
> +	else {
> +		ctx.tp =3D TASK_FS_ROOTS;
> +		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +	}
> +
>  	ret =3D do_check_fs_roots(info, &root_cache);
> +	task_stop(ctx.info);
>  	err |=3D !!ret;
>  	if (ret) {
>  		error("errors found in fs roots");
>  		goto out;
>  	}
> =20
> -	if (check_data_csum)
> -		fprintf(stderr, "checking csums against data\n");
> -	else
> -		fprintf(stderr,
> -			"checking only csum items (without verifying data)\n");
> +	if (!ctx.progress_enabled) {
> +		if (check_data_csum)
> +			fprintf(stderr, "[5/7] checking csums against data\n");
> +		else
> +			fprintf(stderr, "[5/7] checking only csums items (without verifying=
 data)\n");
> +	}
> +	else {
> +		ctx.tp =3D TASK_CSUMS;
> +		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +	}
> +
>  	ret =3D check_csums(root);
> +	task_stop(ctx.info);
>  	/*
>  	 * Data csum error is not fatal, and it may indicate more serious
>  	 * corruption, continue checking.
> @@ -9806,16 +9839,26 @@ int cmd_check(int argc, char **argv)
>  		error("errors found in csum tree");
>  	err |=3D !!ret;
> =20
> -	fprintf(stderr, "checking root refs\n");
>  	/* For low memory mode, check_fs_roots_v2 handles root refs */
> -	if (check_mode !=3D CHECK_MODE_LOWMEM) {
> +        if (check_mode !=3D CHECK_MODE_LOWMEM) {
> +		if (!ctx.progress_enabled)
> +			fprintf(stderr, "[6/7] checking root refs\n");
> +		else {
> +			ctx.tp =3D TASK_ROOT_REFS;
> +			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +		}
> +
>  		ret =3D check_root_refs(root, &root_cache);
> +		task_stop(ctx.info);
>  		err |=3D !!ret;
>  		if (ret) {
>  			error("errors found in root refs");
>  			goto out;
>  		}
>  	}
> +	else {
> +		fprintf(stderr, "[6/7] checking root refs done with fs roots in lowm=
em mode, skipping\n");
> +	}
> =20
>  	while (repair && !list_empty(&root->fs_info->recow_ebs)) {
>  		struct extent_buffer *eb;
> @@ -9844,8 +9887,15 @@ int cmd_check(int argc, char **argv)
>  	}
> =20
>  	if (info->quota_enabled) {
> -		fprintf(stderr, "checking quota groups\n");
> +		if (!ctx.progress_enabled)
> +			fprintf(stderr, "[7/7] checking quota groups\n");
> +		else {
> +			ctx.tp =3D TASK_QGROUPS;
> +			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
> +			qgroup_set_item_count_ptr(&ctx.item_count);
> +		}
>  		ret =3D qgroup_verify_all(info);
> +		task_stop(ctx.info);
>  		err |=3D !!ret;
>  		if (ret) {
>  			error("failed to check quota groups");
> @@ -9861,6 +9911,8 @@ int cmd_check(int argc, char **argv)
>  			err |=3D qgroup_report_ret;
>  		ret =3D 0;
>  	}
> +	else
> +		fprintf(stderr, "[7/7] checking quota groups skipped (not enabled on=
 this FS)\n");
> =20
>  	if (!list_empty(&root->fs_info->recow_ebs)) {
>  		error("transid errors in file system");
> diff --git a/check/mode-common.h b/check/mode-common.h
> index a474857..a11fa3d 100644
> --- a/check/mode-common.h
> +++ b/check/mode-common.h
> @@ -38,6 +38,26 @@ struct node_refs {
>  	int full_backref[BTRFS_MAX_LEVEL];
>  };
> =20
> +enum task_position {
> +	TASK_ROOT_ITEMS,
> +	TASK_EXTENTS,
> +	TASK_FREE_SPACE,
> +	TASK_FS_ROOTS,
> +	TASK_CSUMS,
> +	TASK_ROOT_REFS,
> +	TASK_QGROUPS,
> +	TASK_NOTHING, /* have to be the last element */
> +};
> +
> +struct task_ctx {
> +	int progress_enabled;
> +	enum task_position tp;
> +	time_t start_time;
> +	u64 item_count;
> +
> +	struct task_info *info;
> +};
> +
>  extern u64 bytes_used;
>  extern u64 total_csum_bytes;
>  extern u64 total_btree_bytes;
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 66da453..f849e85 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -4719,6 +4719,7 @@ static int check_btrfs_root(struct btrfs_root *ro=
ot, int check_all)
>  	}
> =20
>  	while (1) {
> +		ctx.item_count++;
>  		ret =3D walk_down_tree(root, &path, &level, &nrefs, check_all);
> =20
>  		if (ret > 0)
> diff --git a/convert/main.c b/convert/main.c
> index 7077fcb..3736a14 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1182,7 +1182,7 @@ static int do_convert(const char *devname, u32 co=
nvert_flags, u32 nodesize,
>  	if (progress) {
>  		ctx.info =3D task_init(print_copied_inodes, after_copied_inodes,
>  				     &ctx);
> -		task_start(ctx.info);
> +		task_start(ctx.info, NULL, NULL);
>  	}
>  	ret =3D copy_inodes(&cctx, root, convert_flags, &ctx);
>  	if (ret) {
> diff --git a/qgroup-verify.c b/qgroup-verify.c
> index e2332be..afaabf8 100644
> --- a/qgroup-verify.c
> +++ b/qgroup-verify.c
> @@ -34,6 +34,12 @@
> =20
>  #include "qgroup-verify.h"
> =20
> +u64 *qgroup_item_count;
> +void qgroup_set_item_count_ptr(u64 *item_count_ptr)
> +{
> +	qgroup_item_count =3D item_count_ptr;
> +}
> +
>  /*#define QGROUP_VERIFY_DEBUG*/
>  static unsigned long tot_extents_scanned =3D 0;
> =20
> @@ -735,6 +741,7 @@ static int travel_tree(struct btrfs_fs_info *info, =
struct btrfs_root *root,
>  	 */
>  	nr =3D btrfs_header_nritems(eb);
>  	for (i =3D 0; i < nr; i++) {
> +		(*qgroup_item_count)++;
>  		new_bytenr =3D btrfs_node_blockptr(eb, i);
>  		new_num_bytes =3D info->nodesize;
> =20
> diff --git a/qgroup-verify.h b/qgroup-verify.h
> index 14d36bb..20e9370 100644
> --- a/qgroup-verify.h
> +++ b/qgroup-verify.h
> @@ -30,4 +30,6 @@ int print_extent_state(struct btrfs_fs_info *info, u6=
4 subvol);
> =20
>  void free_qgroup_counts(void);
> =20
> +void qgroup_set_item_count_ptr(u64 *item_count_ptr);
> +
>  #endif
> diff --git a/task-utils.c b/task-utils.c
> index 284cbb3..a9bee8f 100644
> --- a/task-utils.c
> +++ b/task-utils.c
> @@ -19,6 +19,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> +#include <time.h>
> =20
>  #include "task-utils.h"
> =20
> @@ -37,7 +38,7 @@ struct task_info *task_init(void *(*threadfn)(void *)=
, int (*postfn)(void *),
>  	return info;
>  }
> =20
> -int task_start(struct task_info *info)
> +int task_start(struct task_info *info, time_t *start_time, u64 *item_c=
ount)
>  {
>  	int ret;
> =20
> @@ -47,6 +48,11 @@ int task_start(struct task_info *info)
>  	if (!info->threadfn)
>  		return -1;
> =20
> +	if (start_time)
> +		*start_time =3D time(NULL);
> +	if (item_count)
> +		*item_count =3D 0;
> +
>  	ret =3D pthread_create(&info->id, NULL, info->threadfn,
>  			     info->private_data);
> =20
> diff --git a/task-utils.h b/task-utils.h
> index 91d5a64..fa9839b 100644
> --- a/task-utils.h
> +++ b/task-utils.h
> @@ -18,6 +18,7 @@
>  #define __TASK_UTILS_H__
> =20
>  #include <pthread.h>
> +#include "kerncompat.h"
> =20
>  struct periodic_info {
>  	int timer_fd;
> @@ -35,7 +36,7 @@ struct task_info {
>  /* task life cycle */
>  struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(v=
oid *),
>  			    void *thread_private);
> -int task_start(struct task_info *info);
> +int task_start(struct task_info *info, time_t *start_time, u64 *item_c=
ount);
>  void task_stop(struct task_info *info);
>  void task_deinit(struct task_info *info);
> =20
>=20


--jMOPSAotAjc2xo5kc9wPDdh1jT1p96txe--

--IW8Dlg1QcOhWUw5tSBz2nWkeBtm2JNpzn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltFkz8ACgkQwj2R86El
/qgrKwf8CNG7mRNYrrfHSse5WJFz260zBhAkSIdN6wTxj/u+FJ7fJO8XwHAqvmHM
cDc3HAaljl0uGT+sIgB4RF6/S1B7ljoQP1Jxb/Wtr2A89FlevJsGdihgN+kOJii3
bfw+9E79LBZB2OwT+W4tBIG+QgAJkmaHfsvXlS14+G22wNxtNQFXsAVFceIyBCCZ
Cv/DZGXwbIBdymXQKWIAF9IyCeYpRu96V8RgEe2kKg0LKpFJhfguHHDN3e1pdxFR
CpAZWfSBtAjd2zaYNxXN8/BmwCW1RFdBh9o8JDpimds684LRG8wgMbBC4TXh/lrN
dM9HUT6qRcGf7yAc0trNBAIHxN08HA==
=FNCC
-----END PGP SIGNATURE-----

--IW8Dlg1QcOhWUw5tSBz2nWkeBtm2JNpzn--
