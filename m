Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:38507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725735AbeHFIZh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 04:25:37 -0400
Subject: Re: [RFC PATCH] btrfs: Remove 'objectid' member from struct
 btrfs_root
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533531264.git.misono.tomohiro@jp.fujitsu.com>
 <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1188cc84-3116-e7e6-ae80-00b6bf4a424d@gmx.com>
Date: Mon, 6 Aug 2018 14:17:54 +0800
MIME-Version: 1.0
In-Reply-To: <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LKpQ551bfamvs6NF58dgWluo0qDdU2Hni"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LKpQ551bfamvs6NF58dgWluo0qDdU2Hni
Content-Type: multipart/mixed; boundary="w21alpumil6s1ELmlJiRLXb0tsuO05vdZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1188cc84-3116-e7e6-ae80-00b6bf4a424d@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Remove 'objectid' member from struct
 btrfs_root
References: <cover.1533531264.git.misono.tomohiro@jp.fujitsu.com>
 <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
In-Reply-To: <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>

--w21alpumil6s1ELmlJiRLXb0tsuO05vdZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8806=E6=97=A5 13:25, Misono Tomohiro wrote:
> There are two members in struct btrfs_root which indicate root's
> objectid: ->objectid and ->root_key.objectid.
>=20
> They are both set to the same value in __setup_root():
>   static void __setup_root(struct btrfs_root *root,
>                            struct btrfs_fs_info *fs_info,
>                            u64 objectid)
>   {
>     ...
>     root->objectid =3D objectid;
>     ...
>     root->root_key.objectid =3D objecitd;
>     ...
>   }
> and not changed to other value after initialization.
>=20
> grep in btrfs directory shows both are used in many places:
>   $ grep -rI "root->root_key.objectid" | wc -l
>   133
>   $ grep -rI "root->objectid" | wc -l
>   55
>  (4.17, inc. some noise)
>=20
> It is confusing to have two similar variable names and it seems
> that there is no rule about which should be used in a certain case.
>=20
> Since ->root_key itself is needed for tree reloc tree, let's remove
> 'objecitd' member and unify code to use ->root_key.objectid in all plac=
es.

It's a pretty nice move, just a small nitpick about __setup_root()
inlined later.
(And a personal crazy idea no need to address)

>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Feel free to add my tag:
Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
> Although being fundamentally independent, this is based on the
> patch: https://patchwork.kernel.org/patch/10556485/
> since it also touches root->objectid.
>=20
>  fs/btrfs/backref.c           |  5 +++--
>  fs/btrfs/btrfs_inode.h       |  8 ++++----
>  fs/btrfs/ctree.c             |  2 +-
>  fs/btrfs/ctree.h             |  1 -
>  fs/btrfs/delayed-inode.c     |  5 +++--
>  fs/btrfs/disk-io.c           |  5 ++---
>  fs/btrfs/export.c            |  4 ++--
>  fs/btrfs/inode.c             |  2 +-
>  fs/btrfs/ioctl.c             |  2 +-
>  fs/btrfs/qgroup.c            | 23 ++++++++++++-----------
>  fs/btrfs/ref-verify.c        |  8 ++++----
>  fs/btrfs/relocation.c        |  3 ++-
>  fs/btrfs/send.c              | 16 ++++++++--------
>  fs/btrfs/super.c             |  6 ++++--
>  fs/btrfs/transaction.c       |  4 ++--
>  include/trace/events/btrfs.h | 15 ++++++++-------
>  16 files changed, 57 insertions(+), 52 deletions(-)

> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 318be7864072..5be7c2bc45c0 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1202,7 +1202,6 @@ struct btrfs_root {
>  	int last_log_commit;
>  	pid_t log_start_pid;
> =20
> -	u64 objectid;

Off topic crazy idea here.

I think it is a little crazy, but it should save a lot of objectid
related modification:

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 118346aceea9..e6d70f2309a3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1166,7 +1166,10 @@ struct btrfs_root {

        unsigned long state;
        struct btrfs_root_item root_item;
-       struct btrfs_key root_key;
+       union {
+               struct btrfs_key root_key;
+               u64 objectid;
+       };
        struct btrfs_fs_info *fs_info;
        struct extent_io_tree dirty_log_pages;

@@ -1198,7 +1201,6 @@ struct btrfs_root {
        int last_log_commit;
        pid_t log_start_pid;

-       u64 objectid;
        u64 last_trans;

        u32 type;

I'm not sure if this is a really crazy idea or a dirty hack to reduce
some modification.
Anyway, I'm completely fine with current patch.

>  	u64 last_trans;
> =20
>  	u32 type;
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index f51b509f2d9b..07187e4ab600 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1462,7 +1462,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_t=
rans_handle *trans,
>  	if (unlikely(ret)) {
>  		btrfs_err(trans->fs_info,
>  			  "err add delayed dir index item(name: %.*s) into the insertion tr=
ee of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
> -			  name_len, name, delayed_node->root->objectid,
> +			  name_len, name, delayed_node->root->root_key.objectid,
>  			  delayed_node->inode_id, ret);
>  		BUG();
>  	}
> @@ -1533,7 +1533,8 @@ int btrfs_delete_delayed_dir_index(struct btrfs_t=
rans_handle *trans,
>  	if (unlikely(ret)) {
>  		btrfs_err(trans->fs_info,
>  			  "err add delayed dir index item(index: %llu) into the deletion tr=
ee of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
> -			  index, node->root->objectid, node->inode_id, ret);
> +			  index, node->root->root_key.objectid,
> +			  node->inode_id, ret);
>  		BUG();
>  	}
>  	mutex_unlock(&node->mutex);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 468365dd3b59..3fe87f67869b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -125,8 +125,8 @@ struct async_submit_bio {
>   * Different roots are used for different purposes and may nest inside=
 each
>   * other and they require separate keysets.  As lockdep keys should be=

>   * static, assign keysets according to the purpose of the root as indi=
cated
> - * by btrfs_root->objectid.  This ensures that all special purpose roo=
ts
> - * have separate keysets.
> + * by btrfs_root->root_key.objectid.  This ensures that all special pu=
rpose
> + * roots have separate keysets.
>   *
>   * Lock-nesting across peer nodes is always done with the immediate pa=
rent
>   * node locked thus preventing deadlock.  As lockdep doesn't know this=
, use
> @@ -1148,7 +1148,6 @@ static void __setup_root(struct btrfs_root *root,=
 struct btrfs_fs_info *fs_info,

Since objectid is not really used and root->root_key can be set later by
btrfs_create_tree() or alloc_log_tree().

What about either removing @objectid parameter or replace it with @root_k=
ey?

Thanks,
Qu

>  	root->state =3D 0;
>  	root->orphan_cleanup_state =3D 0;
> =20
> -	root->objectid =3D objectid;
>  	root->last_trans =3D 0;
>  	root->highest_objectid =3D 0;
>  	root->nr_delalloc_inodes =3D 0;
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index 1f3755b3a37a..ddf28ecf17f9 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -33,7 +33,7 @@ static int btrfs_encode_fh(struct inode *inode, u32 *=
fh, int *max_len,
>  	type =3D FILEID_BTRFS_WITHOUT_PARENT;
> =20
>  	fid->objectid =3D btrfs_ino(BTRFS_I(inode));
> -	fid->root_objectid =3D BTRFS_I(inode)->root->objectid;
> +	fid->root_objectid =3D BTRFS_I(inode)->root->root_key.objectid;
>  	fid->gen =3D inode->i_generation;
> =20
>  	if (parent) {
> @@ -41,7 +41,7 @@ static int btrfs_encode_fh(struct inode *inode, u32 *=
fh, int *max_len,
> =20
>  		fid->parent_objectid =3D BTRFS_I(parent)->location.objectid;
>  		fid->parent_gen =3D parent->i_generation;
> -		parent_root_id =3D BTRFS_I(parent)->root->objectid;
> +		parent_root_id =3D BTRFS_I(parent)->root->root_key.objectid;
> =20
>  		if (parent_root_id !=3D fid->root_objectid) {
>  			fid->parent_root_objectid =3D parent_root_id;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3f51ddc18f98..78111d972af8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6613,7 +6613,7 @@ static int btrfs_link(struct dentry *old_dentry, =
struct inode *dir,
>  	int drop_inode =3D 0;
> =20
>  	/* do not allow sys_link's with other subvols of the same device */
> -	if (root->objectid !=3D BTRFS_I(inode)->root->objectid)
> +	if (root->root_key.objectid !=3D BTRFS_I(inode)->root->root_key.objec=
tid)
>  		return -EXDEV;
> =20
>  	if (inode->i_nlink >=3D BTRFS_LINK_MAX)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6eaadddaca9f..8ab30c62df36 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4363,7 +4363,7 @@ static long btrfs_ioctl_default_subvol(struct fil=
e *file, void __user *argp)
>  		ret =3D PTR_ERR(new_root);
>  		goto out;
>  	}
> -	if (!is_fstree(new_root->objectid)) {
> +	if (!is_fstree(new_root->root_key.objectid)) {
>  		ret =3D -ENOENT;
>  		goto out;
>  	}
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 2ba29f0609d9..16a9771b13fe 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3004,7 +3004,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode=
,
>  	int ret;
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags) ||
> -	    !is_fstree(root->objectid) || len =3D=3D 0)
> +	    !is_fstree(root->root_key.objectid) || len =3D=3D 0)
>  		return 0;
> =20
>  	/* @reserved parameter is mandatory for qgroup */
> @@ -3090,7 +3090,7 @@ static int qgroup_free_reserved_data(struct inode=
 *inode,
>  			goto out;
>  		freed +=3D changeset.bytes_changed;
>  	}
> -	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed,
> +	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid, fre=
ed,
>  				  BTRFS_QGROUP_RSV_DATA);
>  	ret =3D freed;
>  out:
> @@ -3122,7 +3122,7 @@ static int __btrfs_qgroup_release_data(struct ino=
de *inode,
>  					changeset.bytes_changed, trace_op);
>  	if (free)
>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
> -				BTRFS_I(inode)->root->objectid,
> +				BTRFS_I(inode)->root->root_key.objectid,
>  				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
>  	ret =3D changeset.bytes_changed;
>  out:
> @@ -3215,7 +3215,7 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root=
 *root, int num_bytes,
>  	int ret;
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
> -	    !is_fstree(root->objectid) || num_bytes =3D=3D 0)
> +	    !is_fstree(root->root_key.objectid) || num_bytes =3D=3D 0)
>  		return 0;
> =20
>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
> @@ -3240,13 +3240,13 @@ void btrfs_qgroup_free_meta_all_pertrans(struct=
 btrfs_root *root)
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
> -	    !is_fstree(root->objectid))
> +	    !is_fstree(root->root_key.objectid))
>  		return;
> =20
>  	/* TODO: Update trace point to handle such free */
>  	trace_qgroup_meta_free_all_pertrans(root);
>  	/* Special value -1 means to free all reserved space */
> -	btrfs_qgroup_free_refroot(fs_info, root->objectid, (u64)-1,
> +	btrfs_qgroup_free_refroot(fs_info, root->root_key.objectid, (u64)-1,
>  				  BTRFS_QGROUP_RSV_META_PERTRANS);
>  }
> =20
> @@ -3256,7 +3256,7 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *=
root, int num_bytes,
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
> -	    !is_fstree(root->objectid))
> +	    !is_fstree(root->root_key.objectid))
>  		return;
> =20
>  	/*
> @@ -3267,7 +3267,8 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *=
root, int num_bytes,
>  	num_bytes =3D sub_root_meta_rsv(root, num_bytes, type);
>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
>  	trace_qgroup_meta_reserve(root, type, -(s64)num_bytes);
> -	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
> +	btrfs_qgroup_free_refroot(fs_info, root->root_key.objectid,
> +				  num_bytes, type);
>  }
> =20
>  static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref=
_root,
> @@ -3321,13 +3322,13 @@ void btrfs_qgroup_convert_reserved_meta(struct =
btrfs_root *root, int num_bytes)
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
> -	    !is_fstree(root->objectid))
> +	    !is_fstree(root->root_key.objectid))
>  		return;
>  	/* Same as btrfs_qgroup_free_meta_prealloc() */
>  	num_bytes =3D sub_root_meta_rsv(root, num_bytes,
>  				      BTRFS_QGROUP_RSV_META_PREALLOC);
>  	trace_qgroup_meta_convert(root, num_bytes);
> -	qgroup_convert_meta(fs_info, root->objectid, num_bytes);
> +	qgroup_convert_meta(fs_info, root->root_key.objectid, num_bytes);
>  }
> =20
>  /*
> @@ -3354,7 +3355,7 @@ void btrfs_qgroup_check_reserved_leak(struct inod=
e *inode)
>  				inode->i_ino, unode->val, unode->aux);
>  		}
>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
> -				BTRFS_I(inode)->root->objectid,
> +				BTRFS_I(inode)->root->root_key.objectid,
>  				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
> =20
>  	}
> diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
> index e5b9e596bb92..d69fbfb30aa9 100644
> --- a/fs/btrfs/ref-verify.c
> +++ b/fs/btrfs/ref-verify.c
> @@ -732,7 +732,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64=
 bytenr, u64 num_bytes,
> =20
>  	INIT_LIST_HEAD(&ra->list);
>  	ra->action =3D action;
> -	ra->root =3D root->objectid;
> +	ra->root =3D root->root_key.objectid;
> =20
>  	/*
>  	 * This is an allocation, preallocate the block_entry in case we have=
n't
> @@ -787,8 +787,8 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64=
 bytenr, u64 num_bytes,
>  			 * one we want to lookup below when we modify the
>  			 * re->num_refs.
>  			 */
> -			ref_root =3D root->objectid;
> -			re->root_objectid =3D root->objectid;
> +			ref_root =3D root->root_key.objectid;
> +			re->root_objectid =3D root->root_key.objectid;
>  			re->num_refs =3D 0;
>  		}
> =20
> @@ -862,7 +862,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64=
 bytenr, u64 num_bytes,
>  			 * didn't thik of some other corner case.
>  			 */
>  			btrfs_err(fs_info, "failed to find root %llu for %llu",
> -				  root->objectid, be->bytenr);
> +				  root->root_key.objectid, be->bytenr);
>  			dump_block_entry(fs_info, be);
>  			dump_ref_action(fs_info, ra);
>  			kfree(ra);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 8783a1776540..d626362687d7 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -884,7 +884,8 @@ struct backref_node *build_backref_tree(struct relo=
c_control *rc,
>  		    cur->bytenr) {
>  			btrfs_err(root->fs_info,
>  	"couldn't find block (%llu) (level %d) in tree (%llu) with key (%llu =
%u %llu)",
> -				  cur->bytenr, level - 1, root->objectid,
> +				  cur->bytenr, level - 1,
> +				  root->root_key.objectid,
>  				  node_key->objectid, node_key->type,
>  				  node_key->offset);
>  			err =3D -ENOENT;
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 551294a6c9e2..f003ec949726 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1186,9 +1186,9 @@ static int __clone_root_cmp_bsearch(const void *k=
ey, const void *elt)
>  	u64 root =3D (u64)(uintptr_t)key;
>  	struct clone_root *cr =3D (struct clone_root *)elt;
> =20
> -	if (root < cr->root->objectid)
> +	if (root < cr->root->root_key.objectid)
>  		return -1;
> -	if (root > cr->root->objectid)
> +	if (root > cr->root->root_key.objectid)
>  		return 1;
>  	return 0;
>  }
> @@ -1198,9 +1198,9 @@ static int __clone_root_cmp_sort(const void *e1, =
const void *e2)
>  	struct clone_root *cr1 =3D (struct clone_root *)e1;
>  	struct clone_root *cr2 =3D (struct clone_root *)e2;
> =20
> -	if (cr1->root->objectid < cr2->root->objectid)
> +	if (cr1->root->root_key.objectid < cr2->root->root_key.objectid)
>  		return -1;
> -	if (cr1->root->objectid > cr2->root->objectid)
> +	if (cr1->root->root_key.objectid > cr2->root->root_key.objectid)
>  		return 1;
>  	return 0;
>  }
> @@ -2346,7 +2346,7 @@ static int send_subvol_begin(struct send_ctx *sct=
x)
>  		return -ENOMEM;
>  	}
> =20
> -	key.objectid =3D send_root->objectid;
> +	key.objectid =3D send_root->root_key.objectid;
>  	key.type =3D BTRFS_ROOT_BACKREF_KEY;
>  	key.offset =3D 0;
> =20
> @@ -2362,7 +2362,7 @@ static int send_subvol_begin(struct send_ctx *sct=
x)
>  	leaf =3D path->nodes[0];
>  	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
>  	if (key.type !=3D BTRFS_ROOT_BACKREF_KEY ||
> -	    key.objectid !=3D send_root->objectid) {
> +	    key.objectid !=3D send_root->root_key.objectid) {
>  		ret =3D -ENOENT;
>  		goto out;
>  	}
> @@ -4907,8 +4907,8 @@ static int send_clone(struct send_ctx *sctx,
> =20
>  	btrfs_debug(sctx->send_root->fs_info,
>  		    "send_clone offset=3D%llu, len=3D%d, clone_root=3D%llu, clone_in=
ode=3D%llu, clone_offset=3D%llu",
> -		    offset, len, clone_root->root->objectid, clone_root->ino,
> -		    clone_root->offset);
> +		    offset, len, clone_root->root->root_key.objectid,
> +		    clone_root->ino, clone_root->offset);
> =20
>  	p =3D fs_path_alloc();
>  	if (!p)
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 67de3c0fc85b..f114e848f4c9 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2177,8 +2177,10 @@ static int btrfs_statfs(struct dentry *dentry, s=
truct kstatfs *buf)
>  	buf->f_fsid.val[0] =3D be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
>  	buf->f_fsid.val[1] =3D be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
>  	/* Mask in the root object ID too, to disambiguate subvols */
> -	buf->f_fsid.val[0] ^=3D BTRFS_I(d_inode(dentry))->root->objectid >> 3=
2;
> -	buf->f_fsid.val[1] ^=3D BTRFS_I(d_inode(dentry))->root->objectid;
> +	buf->f_fsid.val[0] ^=3D
> +		BTRFS_I(d_inode(dentry))->root->root_key.objectid >> 32;
> +	buf->f_fsid.val[1] ^=3D
> +		BTRFS_I(d_inode(dentry))->root->root_key.objectid;
> =20
>  	return 0;
>  }
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 3b84f5015029..c429bdda6348 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -118,7 +118,7 @@ static noinline void switch_commit_roots(struct btr=
fs_transaction *trans)
>  		list_del_init(&root->dirty_list);
>  		free_extent_buffer(root->commit_root);
>  		root->commit_root =3D btrfs_root_node(root);
> -		if (is_fstree(root->objectid))
> +		if (is_fstree(root->root_key.objectid))
>  			btrfs_unpin_free_ino(root);
>  		clear_btree_io_tree(&root->dirty_log_pages);
>  	}
> @@ -2330,7 +2330,7 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs=
_root *root)
>  	list_del_init(&root->root_list);
>  	spin_unlock(&fs_info->trans_lock);
> =20
> -	btrfs_debug(fs_info, "cleaner removing %llu", root->objectid);
> +	btrfs_debug(fs_info, "cleaner removing %llu", root->root_key.objectid=
);
> =20
>  	btrfs_kill_all_delayed_nodes(root);
> =20
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.=
h
> index b401c4e36394..abe3ff774f58 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -316,7 +316,7 @@ DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular=
,
>  	),
> =20
>  	TP_fast_assign_btrfs(bi->root->fs_info,
> -		__entry->root_obj	=3D bi->root->objectid;
> +		__entry->root_obj	=3D bi->root->root_key.objectid;
>  		__entry->ino		=3D btrfs_ino(bi);
>  		__entry->isize		=3D bi->vfs_inode.i_size;
>  		__entry->disk_isize	=3D bi->disk_i_size;
> @@ -367,7 +367,7 @@ DECLARE_EVENT_CLASS(
> =20
>  	TP_fast_assign_btrfs(
>  		bi->root->fs_info,
> -		__entry->root_obj	=3D bi->root->objectid;
> +		__entry->root_obj	=3D bi->root->root_key.objectid;
>  		__entry->ino		=3D btrfs_ino(bi);
>  		__entry->isize		=3D bi->vfs_inode.i_size;
>  		__entry->disk_isize	=3D bi->disk_i_size;
> @@ -1477,7 +1477,8 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
>  	),
> =20
>  	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
> -		__entry->rootid		=3D BTRFS_I(inode)->root->objectid;
> +		__entry->rootid		=3D
> +			BTRFS_I(inode)->root->root_key.objectid;
>  		__entry->ino		=3D btrfs_ino(BTRFS_I(inode));
>  		__entry->start		=3D start;
>  		__entry->len		=3D len;
> @@ -1675,7 +1676,7 @@ TRACE_EVENT(qgroup_meta_reserve,
>  	),
> =20
>  	TP_fast_assign_btrfs(root->fs_info,
> -		__entry->refroot	=3D root->objectid;
> +		__entry->refroot	=3D root->root_key.objectid;
>  		__entry->diff		=3D diff;
>  	),
> =20
> @@ -1697,7 +1698,7 @@ TRACE_EVENT(qgroup_meta_convert,
>  	),
> =20
>  	TP_fast_assign_btrfs(root->fs_info,
> -		__entry->refroot	=3D root->objectid;
> +		__entry->refroot	=3D root->root_key.objectid;
>  		__entry->diff		=3D diff;
>  	),
> =20
> @@ -1721,7 +1722,7 @@ TRACE_EVENT(qgroup_meta_free_all_pertrans,
>  	),
> =20
>  	TP_fast_assign_btrfs(root->fs_info,
> -		__entry->refroot	=3D root->objectid;
> +		__entry->refroot	=3D root->root_key.objectid;
>  		spin_lock(&root->qgroup_meta_rsv_lock);
>  		__entry->diff		=3D -(s64)root->qgroup_meta_rsv_pertrans;
>  		spin_unlock(&root->qgroup_meta_rsv_lock);
> @@ -1802,7 +1803,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
>  	),
> =20
>  	TP_fast_assign_btrfs(root->fs_info,
> -		__entry->root_objectid	=3D root->objectid;
> +		__entry->root_objectid	=3D root->root_key.objectid;
>  		__entry->ino		=3D ino;
>  		__entry->mod		=3D mod;
>  	),
>=20


--w21alpumil6s1ELmlJiRLXb0tsuO05vdZ--

--LKpQ551bfamvs6NF58dgWluo0qDdU2Hni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltn6BIACgkQwj2R86El
/qh9cQf/UlxdWAcTlbfXRJCT7GlvGFq5DWpev7Yi6um5VfhwIBgwqeIQKnpzmIpy
czz/YPAadTMQbcKEGSJeaUVh2o9oI9/YQpbgiXnHtyvMl8151ohr409Tb58PWb5k
Da5QHwgMkxxJiqjiytRUqZBw54fn7gSO6txLXmvTkQjzbgipMV9zOe/zrPjxAcTY
fRe7QEU7jR+dZcITGmcKdvEOFpuIihr5aegLLYlPaCoLYqPagI/Oi3IWEuv8bffz
t2XVkdLJBoPZKBCpi3atnegBRQEqv6B7aZVTmuS4FI6Oli6eRxurn3oIFjMif90v
TbY00UCF99QiKp5MXMQmoiAyJhTuhg==
=a3K6
-----END PGP SIGNATURE-----

--LKpQ551bfamvs6NF58dgWluo0qDdU2Hni--
