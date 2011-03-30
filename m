From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [RFC][PATCH] Btrfs: Fix uninitialized root flags for subvolumes
Date: Wed, 30 Mar 2011 08:59:03 +0200
Message-ID: <4D92D4B7.6060500@gmail.com>
References: <4D8FEBF5.2080505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Andreas Philipp <philipp.andreas@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8FEBF5.2080505@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 28.03.2011 04:01, Li Zefan wrote:
> root_item->flags and root_item->byte_limit are not initialized when
> a subvolume is created. This bug is not revealed until we added
> readonly snapshot support - now you mount a btrfs filesystem and you
> may find the subvolumes in it are readonly.
>
> To work around this problem, we steal a bit from
root_item->inode_item->flags,
> and use it to indicate if those fields have been properly initialized.
> When we read a tree root from disk, we check if the bit is set, and if
> not we'll set the flag and initialize the two fields of the root item.
>
> Reported-by: Andreas Philipp <philipp.andreas@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Andreas Philipp <philipp.andreas@gmail.com>
> ---
> fs/btrfs/ctree.h | 4 ++++
> fs/btrfs/disk-io.c | 4 +++-
> fs/btrfs/ioctl.c | 4 ++++
> fs/btrfs/root-tree.c | 18 ++++++++++++++++++
> fs/btrfs/transaction.c | 1 +
> 5 files changed, 30 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8b4b9d1..ff6b991 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1284,6 +1284,8 @@ struct btrfs_root {
> #define BTRFS_INODE_NOATIME (1 << 9)
> #define BTRFS_INODE_DIRSYNC (1 << 10)
>
> +#define BTRFS_INODE_ROOT_ITEM_INIT (1 << 31)
> +
> /* some macros to generate set/get funcs for the struct fields. This
> * assumes there is a lefoo_to_cpu for every type, so lets make a simple
> * one for u8:
> @@ -2355,6 +2357,8 @@ int btrfs_find_dead_roots(struct btrfs_root
*root, u64 objectid);
> int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
> int btrfs_set_root_node(struct btrfs_root_item *item,
> struct extent_buffer *node);
> +void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
> +
> /* dir-item.c */
> int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
> struct btrfs_root *root, const char *name,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 3e1ea3e..4f8dafc 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1184,8 +1184,10 @@ struct btrfs_root
*btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
> root->commit_root = btrfs_root_node(root);
> BUG_ON(!root->node);
> out:
> - if (location->objectid != BTRFS_TREE_LOG_OBJECTID)
> + if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
> root->ref_cows = 1;
> + btrfs_check_and_init_root_item(&root->root_item);
> + }
>
> return root;
> }
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5fdb2ab..2ff51e6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -294,6 +294,10 @@ static noinline int create_subvol(struct
btrfs_root *root,
> inode_item->nbytes = cpu_to_le64(root->leafsize);
> inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
>
> + root_item.flags = 0;
> + root_item.byte_limit = 0;
> + inode_item->flags = cpu_to_le64(BTRFS_INODE_ROOT_ITEM_INIT);
> +
> btrfs_set_root_bytenr(&root_item, leaf->start);
> btrfs_set_root_generation(&root_item, trans->transid);
> btrfs_set_root_level(&root_item, 0);
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 6a1086e..3e45c32 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -471,3 +471,21 @@ again:
> btrfs_free_path(path);
> return 0;
> }
> +
> +/*
> + * Old btrfs forgets to init root_item->flags and root_item->byte_limit
> + * for subvolumes. To work around this problem, we steal a bit from
> + * root_item->inode_item->flags, and use it to indicate if those fields
> + * have been properly initialized.
> + */
> +void btrfs_check_and_init_root_item(struct btrfs_root_item *root_item)
> +{
> + u64 inode_flags = le64_to_cpu(root_item->inode.flags);
> +
> + if (!(inode_flags & BTRFS_INODE_ROOT_ITEM_INIT)) {
> + inode_flags |= BTRFS_INODE_ROOT_ITEM_INIT;
> + root_item->inode.flags = cpu_to_le64(inode_flags);
> + root_item->flags = 0;
> + root_item->byte_limit = 0;
> + }
> +}
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 3d73c8d..f3d6681 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -970,6 +970,7 @@ static noinline int create_pending_snapshot(struct
btrfs_trans_handle *trans,
> record_root_in_trans(trans, root);
> btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
> memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
> + btrfs_check_and_init_root_item(new_root_item);
>
> root_flags = btrfs_root_flags(new_root_item);
> if (pending->readonly)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNktS2AAoJEJIcBJ3+XkgiB4gP/RqCnQQj2RcM0pxpjPqA0+GE
HC5DqXGhqYa+6Y+WIKWZJIuhpxF+x5c885U7MBYU1f5UJB6bXttYVGE5Gq7pXgs5
aWezaX3WKIOsgfLWVRFezWtlmWvUuBgz3K2cLq9U+NcUNp13KjP4nI5QWwn0xo27
o4GjqdtHiN3Fen8/BCVUTHySUlFxqo2o7DvNB9KysW8Vz0zOS8Y0SXgUN+4u5p7L
7Y76UOiayMpVF6JaGQzcqGgf5WQyA8xWtYUAzuxBs+MA1Xfbogu4Oen59FKxR4BI
c0Ihw2GddQfxHvGQLXXXK2BuCpZfbpTD3hdxRnAzRspk8OqpBU0DYnZv0YybsqLw
XC+PM+oEUtsTAxaID0MWcoqfk40S54xv36PXgKF0RjIogJFRyxq1vNNCR5hzxVRX
hjVvBc31QWyE+EkFZKBWnuVqnfVwHa0Ya9S93+dIVxD6uBcnQWSmuZagP3Awi7Xb
S8BOwABMMVp4I17t0cdJYKzEI78NZ3Q3zt1W6whiYFH5xaP4YFhkXQAQJg40op3L
h4bEcUo1+1o6QPyRV8IeiUGbNm+iU95I5tGWiU5Il2uYrbs5HYA4lvxwerNyFG34
mtJjBC/QdYJdMXa4DXri8vrxDYySJrcIVpBWu2VboxbeFpKrKZB+qLmzDaGO0soq
0xavNStqCTBWGGp4A0ux
=JVKt
-----END PGP SIGNATURE-----

