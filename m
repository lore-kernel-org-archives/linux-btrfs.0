From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH 2/4] btrfs-convert: Add extent iteration functions.
Date: Tue, 18 May 2010 21:06:54 +0800
Message-ID: <AANLkTil0BsmO29G5Q-gkwXogwJPuL9fbL_kztOv9Us4O@mail.gmail.com>
References: <20100320042649.GA17106@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: wingedtachikoma@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100320042649.GA17106@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 20, 2010 at 12:26 PM, Sean Bartell
<wingedtachikoma@gmail.com> wrote:
> A filesystem can have disk extents in arbitrary places on the disk, a=
s
> well as extents that must be read into memory because they have
> compression or encryption btrfs doesn't support. These extents can be
> passed to the new extent iteration functions, which will handle all t=
he
> details of alignment, allocation, etc.
> ---
> =A0convert.c | =A0604 ++++++++++++++++++++++++++++++++++++++++-------=
--------------
> =A01 files changed, 401 insertions(+), 203 deletions(-)
>
> diff --git a/convert.c b/convert.c
> index c48f8ba..bd91990 100644
> --- a/convert.c
> +++ b/convert.c
> @@ -357,7 +357,7 @@ error:
> =A0}
>
> =A0static int read_disk_extent(struct btrfs_root *root, u64 bytenr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 num_bytes, =
char *buffer)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 num_bytes, =
char *buffer)
> =A0{
> =A0 =A0 =A0 =A0int ret;
> =A0 =A0 =A0 =A0struct btrfs_fs_devices *fs_devs =3D root->fs_info->fs=
_devices;
> @@ -371,6 +371,23 @@ fail:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -1;
> =A0 =A0 =A0 =A0return ret;
> =A0}
> +
> +static int write_disk_extent(struct btrfs_root *root, u64 bytenr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 num_byte=
s, const char *buffer)
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 struct btrfs_fs_devices *fs_devs =3D root->fs_info->fs_=
devices;
> +
> + =A0 =A0 =A0 ret =3D pwrite(fs_devs->latest_bdev, buffer, num_bytes,=
 bytenr);
> + =A0 =A0 =A0 if (ret !=3D num_bytes)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 ret =3D 0;
> +fail:
> + =A0 =A0 =A0 if (ret > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -1;
> + =A0 =A0 =A0 return ret;
> +}
> +
> =A0/*
> =A0* Record a file extent. Do all the required works, such as inserti=
ng
> =A0* file extent item, inserting extent item and backref item into ex=
tent
> @@ -378,8 +395,7 @@ fail:
> =A0*/
> =A0static int record_file_extent(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btr=
fs_root *root, u64 objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrf=
s_inode_item *inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 file_po=
s, u64 disk_bytenr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 *inode_=
nbytes, u64 file_pos, u64 disk_bytenr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 num_by=
tes, int checksum)
> =A0{
> =A0 =A0 =A0 =A0int ret;
> @@ -391,7 +407,6 @@ static int record_file_extent(struct btrfs_trans_=
handle *trans,
> =A0 =A0 =A0 =A0struct btrfs_path path;
> =A0 =A0 =A0 =A0struct btrfs_extent_item *ei;
> =A0 =A0 =A0 =A0u32 blocksize =3D root->sectorsize;
> - =A0 =A0 =A0 u64 nbytes;
>
> =A0 =A0 =A0 =A0if (disk_bytenr =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_insert_file_extent(trans=
, root, objectid,
> @@ -450,8 +465,7 @@ static int record_file_extent(struct btrfs_trans_=
handle *trans,
> =A0 =A0 =A0 =A0btrfs_set_file_extent_other_encoding(leaf, fi, 0);
> =A0 =A0 =A0 =A0btrfs_mark_buffer_dirty(leaf);
>
> - =A0 =A0 =A0 nbytes =3D btrfs_stack_inode_nbytes(inode) + num_bytes;
> - =A0 =A0 =A0 btrfs_set_stack_inode_nbytes(inode, nbytes);
> + =A0 =A0 =A0 *inode_nbytes +=3D num_bytes;
>
> =A0 =A0 =A0 =A0btrfs_release_path(root, &path);
>
> @@ -492,95 +506,355 @@ fail:
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> -static int record_file_blocks(struct btrfs_trans_handle *trans,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrf=
s_root *root, u64 objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrf=
s_inode_item *inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 file_bl=
ock, u64 disk_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 num_blo=
cks, int checksum)
> -{
> - =A0 =A0 =A0 u64 file_pos =3D file_block * root->sectorsize;
> - =A0 =A0 =A0 u64 disk_bytenr =3D disk_block * root->sectorsize;
> - =A0 =A0 =A0 u64 num_bytes =3D num_blocks * root->sectorsize;
> - =A0 =A0 =A0 return record_file_extent(trans, root, objectid, inode,=
 file_pos,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dis=
k_bytenr, num_bytes, checksum);
> -}
> -
> -struct blk_iterate_data {
> +struct extent_iterate_data {
> =A0 =A0 =A0 =A0struct btrfs_trans_handle *trans;
> =A0 =A0 =A0 =A0struct btrfs_root *root;
> - =A0 =A0 =A0 struct btrfs_inode_item *inode;
> + =A0 =A0 =A0 u64 *inode_nbytes;
> =A0 =A0 =A0 =A0u64 objectid;
> - =A0 =A0 =A0 u64 first_block;
> - =A0 =A0 =A0 u64 disk_block;
> - =A0 =A0 =A0 u64 num_blocks;
> - =A0 =A0 =A0 u64 boundary;
> - =A0 =A0 =A0 int checksum;
> - =A0 =A0 =A0 int errcode;
> + =A0 =A0 =A0 int checksum, packing;
> + =A0 =A0 =A0 u64 last_file_off;
> + =A0 =A0 =A0 u64 total_size;
> + =A0 =A0 =A0 enum {EXTENT_ITERATE_TYPE_NONE, EXTENT_ITERATE_TYPE_MEM=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 EXTENT_ITERATE_TYPE_DISK} type;
> + =A0 =A0 =A0 u64 size;
> + =A0 =A0 =A0 u64 file_off; /* always aligned to sectorsize */
> + =A0 =A0 =A0 char *data; /* for mem */
> + =A0 =A0 =A0 u64 disk_off; /* for disk */
> =A0};
>
> -static int block_iterate_proc(ext2_filsys ext2_fs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 disk_bl=
ock, u64 file_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct blk_=
iterate_data *idata)
> +static u64 extent_boundary(struct btrfs_root *root, u64 extent_start=
)
> =A0{
> - =A0 =A0 =A0 int ret;
> - =A0 =A0 =A0 int sb_region;
> - =A0 =A0 =A0 int do_barrier;
> - =A0 =A0 =A0 struct btrfs_root *root =3D idata->root;
> - =A0 =A0 =A0 struct btrfs_trans_handle *trans =3D idata->trans;
> - =A0 =A0 =A0 struct btrfs_block_group_cache *cache;
> - =A0 =A0 =A0 u64 bytenr =3D disk_block * root->sectorsize;
> -
> - =A0 =A0 =A0 sb_region =3D intersect_with_sb(bytenr, root->sectorsiz=
e);
> - =A0 =A0 =A0 do_barrier =3D sb_region || disk_block >=3D idata->boun=
dary;
> - =A0 =A0 =A0 if ((idata->num_blocks > 0 && do_barrier) ||
> - =A0 =A0 =A0 =A0 =A0 (file_block > idata->first_block + idata->num_b=
locks) ||
> - =A0 =A0 =A0 =A0 =A0 (disk_block !=3D idata->disk_block + idata->num=
_blocks)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (idata->num_blocks > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blo=
cks(trans, root, idata->objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 idata->inode, idata->first_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 idata->disk_block, idata->num_blocks,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 idata->checksum);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fa=
il;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idata->first_block +=3D=
 idata->num_blocks;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idata->num_blocks =3D 0=
;
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 u64 offset;
> + =A0 =A0 =A0 u64 boundary =3D (u64)-1;
> + =A0 =A0 =A0 for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D btrfs_sb_offset(i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset &=3D ~((u64)STRIPE_LEN - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset > extent_start) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 boundary =3D offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset + STRIPE_LEN > extent_start)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 boundary =3D offset + S=
TRIPE_LEN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (file_block > idata->first_block) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blo=
cks(trans, root, idata->objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 idata->inode, idata->first_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0, file_block - idata->first_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 idata->checksum);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 struct btrfs_block_group_cache *cache;
> + =A0 =A0 =A0 cache =3D btrfs_lookup_block_group(root->fs_info, exten=
t_start);
> + =A0 =A0 =A0 BUG_ON(!cache);
> + =A0 =A0 =A0 offset =3D cache->key.objectid + cache->key.offset;
> + =A0 =A0 =A0 return min_t(u64, boundary, offset);
> +}
> +
> +static int commit_disk_extent(struct extent_iterate_data *priv,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 file_po=
s, u64 disk_bytenr, u64 num_bytes)
> +{
> + =A0 =A0 =A0 u64 boundary;
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 if (disk_bytenr =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return record_file_extent(priv->trans, =
priv->root,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 priv->objectid, priv->inode_nbytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 file_pos, disk_bytenr, num_bytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 priv->checksum);
> + =A0 =A0 =A0 /* Break up the disk extent on blockgroup and superbloc=
k boundaries. */
> + =A0 =A0 =A0 while (num_bytes) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 boundary =3D extent_boundary(priv->root=
, disk_bytenr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 size =3D min_t(u64, boundary - disk=
_bytenr, num_bytes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_extent(priv->trans,=
 priv->root,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0priv->objectid, priv->inode_nbytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0file_pos, disk_bytenr, size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0priv->checksum);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_pos +=3D size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disk_bytenr +=3D size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_bytes -=3D size;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int commit_file_extents(struct extent_iterate_data *priv)
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TYPE_NONE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 if (priv->size =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 if (priv->file_off > priv->last_file_off) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D commit_disk_extent(priv, priv->=
last_file_off, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0priv->file_off - priv->last_file_off);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 priv->last_file_off =3D priv->file_off + priv->size;
> +
> + =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TYPE_MEM) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* allocate and write to disk */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_key key;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D custom_alloc_extent(priv->root,=
 priv->root->sectorsize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0, &key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D write_disk_extent(priv->root, k=
ey.objectid, priv->size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 priv->data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_DISK=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->disk_off =3D key.objectid;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 u64 sectorsize =3D priv->root->sectorsize;
> + =A0 =A0 =A0 if (priv->size & (sectorsize - 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size =3D (priv->size & ~(sectorsi=
ze - 1)) + sectorsize;
> + =A0 =A0 =A0 ret =3D commit_disk_extent(priv, priv->file_off, priv->=
disk_off,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0priv=
->size);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_NONE;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int start_file_extents(struct extent_iterate_data *priv,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_trans_handl=
e *trans,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *root,=
 u64 *inode_nbytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 objectid, int checks=
um, int packing, u64 total_size)
> +{
> + =A0 =A0 =A0 priv->trans =3D trans;
> + =A0 =A0 =A0 priv->root =3D root;
> + =A0 =A0 =A0 priv->inode_nbytes =3D inode_nbytes;
> + =A0 =A0 =A0 priv->objectid =3D objectid;
> + =A0 =A0 =A0 priv->checksum =3D checksum;
> + =A0 =A0 =A0 priv->packing =3D packing;
> + =A0 =A0 =A0 priv->last_file_off =3D 0;
> + =A0 =A0 =A0 priv->type =3D 0;
> + =A0 =A0 =A0 priv->total_size =3D total_size;
> + =A0 =A0 =A0 priv->data =3D malloc(root->sectorsize);
> + =A0 =A0 =A0 if (!priv->data)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int start_file_extents_range(struct extent_iterate_data *priv,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs=
_trans_handle *trans,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs=
_root *root, u64 *inode_nbytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 objectid=
, int checksum, u64 start, u64 end)
> +{
> + =A0 =A0 =A0 priv->trans =3D trans;
> + =A0 =A0 =A0 priv->root =3D root;
> + =A0 =A0 =A0 priv->inode_nbytes =3D inode_nbytes;
> + =A0 =A0 =A0 priv->objectid =3D objectid;
> + =A0 =A0 =A0 priv->checksum =3D checksum;
> + =A0 =A0 =A0 priv->packing =3D 0;
> + =A0 =A0 =A0 priv->last_file_off =3D start;
> + =A0 =A0 =A0 priv->type =3D 0;
> + =A0 =A0 =A0 priv->total_size =3D end;
> + =A0 =A0 =A0 priv->data =3D malloc(root->sectorsize);
> + =A0 =A0 =A0 if (!priv->data)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int finish_file_extents(struct extent_iterate_data *priv)
> +{
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 if (priv->packing
> + =A0 =A0 =A0 =A0 =A0 && priv->type !=3D EXTENT_ITERATE_TYPE_NONE
> + =A0 =A0 =A0 =A0 =A0 && priv->total_size <=3D BTRFS_MAX_INLINE_DATA_=
SIZE(priv->root)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size =3D min_t(u64, priv->size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 priv->total_size - priv->file_off);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* make inline extent */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TY=
PE_DISK) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_exten=
t(priv->root, priv->disk_off,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0priv->size, priv->data);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fa=
il;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
ret;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *priv->inode_nbytes +=3D priv->size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return btrfs_insert_inline_extent(priv-=
>trans, priv->root,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->objectid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->file_off, priv->data,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size);
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sb_region) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytenr +=3D STRIPE_LEN =
- 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytenr &=3D ~((u64)STRI=
PE_LEN - 1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cache =3D btrfs_lookup_=
block_group(root->fs_info, bytenr);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!cache);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytenr =3D cache->key.o=
bjectid + cache->key.offset;
> + =A0 =A0 =A0 ret =3D commit_file_extents(priv);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 if (priv->total_size > priv->last_file_off) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D commit_disk_extent(priv, priv->=
last_file_off, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 priv->total_size - priv->last_file_off);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 free(priv->data);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_o=
ff,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 size, char *data);
> +
> +int add_file_disk_extent(struct extent_iterate_data *priv, u64 file_=
off,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 disk_off, u64 si=
ze)
> +{
> + =A0 =A0 =A0 BUG_ON(file_off < priv->last_file_off);
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 u64 sectorsize =3D priv->root->sectorsize;
> + =A0 =A0 =A0 u64 mask =3D sectorsize - 1;
> + =A0 =A0 =A0 if (size =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 if ((file_off & mask) !=3D (disk_off & mask)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* It's unclear how to CoW this, so don=
't. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *data =3D malloc(size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!data)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_extent(priv->root, di=
sk_off, size, data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D add_file_mem_extent(priv, file_=
off, size, data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TYPE_DISK
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && priv->file_off + pri=
v->size =3D=3D file_off
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && priv->disk_off + pri=
v->size =3D=3D disk_off) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* It's a continuation of the same disk=
 extent. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size +=3D size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (disk_off =3D=3D 0 || disk_off & mask) {

why "disk_off =3D=3D 0" is needed here?

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We need to have an aligned start, so=
 give the first part to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* add_file_mem_extent if necessary. =
*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 mem_size =3D min_t(u64, sectorsize =
- (disk_off & mask), size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *data =3D malloc(mem_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!data)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_extent(priv->root, di=
sk_off, mem_size, data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D add_file_mem_extent(priv, file_=
off, mem_size, data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_off +=3D mem_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disk_off +=3D mem_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size -=3D mem_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (size =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D commit_file_extents(priv);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_DISK;
> + =A0 =A0 =A0 priv->size =3D size;
> + =A0 =A0 =A0 priv->file_off =3D file_off;
> + =A0 =A0 =A0 priv->disk_off =3D disk_off;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_o=
ff,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 size, char *data)
> +{
> + =A0 =A0 =A0 BUG_ON(file_off < priv->last_file_off);
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 u64 sectorsize =3D priv->root->sectorsize;
> + =A0 =A0 =A0 u64 mask =3D sectorsize - 1;
> + =A0 =A0 =A0 u64 aligned_file_off =3D file_off & ~mask;
> + =A0 =A0 =A0 u32 alignment =3D file_off - aligned_file_off;
> + =A0 =A0 =A0 size +=3D alignment;
> +
> + =A0 =A0 =A0 /* If we share a sector with a DISK extent, commit most=
 of it and turn
> + =A0 =A0 =A0 =A0* the shared part into a MEM extent. */
> + =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TYPE_DISK
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && priv->file_off + pri=
v->size > aligned_file_off) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 mem_size =3D priv->file_off + priv-=
>size - aligned_file_off;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_extent(priv->root, al=
igned_file_off, mem_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0priv->data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size -=3D mem_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D commit_file_extents(priv);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_MEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size =3D mem_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->file_off =3D aligned_file_off;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Put our first sector in priv->data. If we share a se=
ctor with the
> + =A0 =A0 =A0 =A0* previous extent, combine with it. */
> + =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TYPE_MEM
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && priv->file_off + pri=
v->size > aligned_file_off) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(priv->file_off !=3D aligned_file=
_off);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(priv->data + priv->size, 0, sect=
orsize - priv->size);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D commit_file_extents(priv);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(priv->data, 0, sectorsize);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (size < sectorsize) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(priv->data + alignment, data, si=
ze - alignment);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_MEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->file_off =3D aligned_file_off;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size =3D size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 memcpy(priv->data + alignment, data, sectorsize - align=
ment);
> + =A0 =A0 =A0 data +=3D sectorsize - alignment;
> +
> + =A0 =A0 =A0 /* We have full sectors; allocate and write them. */
> + =A0 =A0 =A0 u64 aligned_size =3D size & ~mask;
> + =A0 =A0 =A0 struct btrfs_key key;
> + =A0 =A0 =A0 ret =3D custom_alloc_extent(priv->root, aligned_size, 0=
, &key);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 ret =3D write_disk_extent(priv->root, key.objectid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectors=
ize, priv->data);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 ret =3D write_disk_extent(priv->root, key.objectid + se=
ctorsize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 aligned=
_size - sectorsize, data);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 ret =3D add_file_disk_extent(priv, aligned_file_off, ke=
y.objectid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
aligned_size);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 idata->first_block =3D file_block;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 idata->disk_block =3D disk_block;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 idata->boundary =3D bytenr / root->sect=
orsize;
> + =A0 =A0 =A0 /* Leave the rest in priv. */
> + =A0 =A0 =A0 size -=3D aligned_size;
> + =A0 =A0 =A0 if (size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D commit_file_extents(priv);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 aligned_file_off +=3D aligned_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 data +=3D aligned_size - sectorsize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_MEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->file_off =3D aligned_file_off;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size =3D size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(priv->data, data, size);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 idata->num_blocks++;
> =A0 =A0 =A0 =A0return 0;
> -fail:
> - =A0 =A0 =A0 idata->errcode =3D ret;
> - =A0 =A0 =A0 return BLOCK_ABORT;
> =A0}
>
> =A0static int __block_iterate_proc(ext2_filsys fs, blk_t *blocknr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e2_blk=
cnt_t blockcnt, blk_t ref_block,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int re=
f_offset, void *priv_data)
> =A0{
> - =A0 =A0 =A0 struct blk_iterate_data *idata;
> - =A0 =A0 =A0 idata =3D (struct blk_iterate_data *)priv_data;
> - =A0 =A0 =A0 return block_iterate_proc(fs, *blocknr, blockcnt, idata=
);
> + =A0 =A0 =A0 struct extent_iterate_data *idata;
> + =A0 =A0 =A0 idata =3D (struct extent_iterate_data *)priv_data;
> + =A0 =A0 =A0 u64 blocksize =3D fs->blocksize;
> + =A0 =A0 =A0 int ret =3D add_file_disk_extent(idata, blocksize * blo=
ckcnt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0blocksize * *blocknr, blocksize);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return BLOCK_ABORT;
> + =A0 =A0 =A0 return 0;
> =A0}
>
> =A0/*
> @@ -593,68 +867,23 @@ static int create_file_extents(struct btrfs_tra=
ns_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int datac=
sum, int packing)
> =A0{
> =A0 =A0 =A0 =A0int ret;
> - =A0 =A0 =A0 char *buffer =3D NULL;
> =A0 =A0 =A0 =A0errcode_t err;
> - =A0 =A0 =A0 u32 last_block;
> - =A0 =A0 =A0 u32 sectorsize =3D root->sectorsize;
> + =A0 =A0 =A0 u64 inode_nbytes =3D 0;
> =A0 =A0 =A0 =A0u64 inode_size =3D btrfs_stack_inode_size(btrfs_inode)=
;
> - =A0 =A0 =A0 struct blk_iterate_data data =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .trans =A0 =A0 =A0 =A0 =A0=3D trans,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .root =A0 =A0 =A0 =A0 =A0 =3D root,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .inode =A0 =A0 =A0 =A0 =A0=3D btrfs_ino=
de,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .objectid =A0 =A0 =A0 =3D objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .first_block =A0 =A0=3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .disk_block =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .num_blocks =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .boundary =A0 =A0 =A0 =3D (u64)-1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .checksum =A0 =A0 =A0 =3D datacsum,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .errcode =A0 =A0 =A0 =A0=3D 0,
> - =A0 =A0 =A0 };
> + =A0 =A0 =A0 struct extent_iterate_data data;
> + =A0 =A0 =A0 ret =3D start_file_extents(&data, trans, root, &inode_n=
bytes, objectid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data=
csum, packing, inode_size);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> =A0 =A0 =A0 =A0err =3D ext2fs_block_iterate2(ext2_fs, ext2_ino, BLOCK=
_FLAG_DATA_ONLY,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
NULL, __block_iterate_proc, &data);
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error;
> - =A0 =A0 =A0 ret =3D data.errcode;
> + =A0 =A0 =A0 ret =3D finish_file_extents(&data);
> =A0 =A0 =A0 =A0if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 if (packing && data.first_block =3D=3D 0 && data.num_bl=
ocks > 0 &&
> - =A0 =A0 =A0 =A0 =A0 inode_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root=
)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 num_bytes =3D data.num_blocks * sec=
torsize;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 disk_bytenr =3D data.disk_block * s=
ectorsize;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 nbytes;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 buffer =3D malloc(num_bytes);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!buffer)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_extent(root, disk_byt=
enr, num_bytes, buffer);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_bytes > inode_size)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_bytes =3D inode_siz=
e;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_insert_inline_extent(tran=
s, root, objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A00, buffer, num_bytes);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nbytes =3D btrfs_stack_inode_nbytes(btr=
fs_inode) + num_bytes;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_set_stack_inode_nbytes(btrfs_inod=
e, nbytes);
> - =A0 =A0 =A0 } else if (data.num_blocks > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blocks(trans, root,=
 objectid, btrfs_inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, data.disk_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.num_blocks, data.checksum);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 data.first_block +=3D data.num_blocks;
> - =A0 =A0 =A0 last_block =3D (inode_size + sectorsize - 1) / sectorsi=
ze;
> - =A0 =A0 =A0 if (last_block > data.first_block) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blocks(trans, root,=
 objectid, btrfs_inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, 0, last_block -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, data.checksum);
> - =A0 =A0 =A0 }
> -fail:
> - =A0 =A0 =A0 if (buffer)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(buffer);
> - =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 btrfs_set_stack_inode_nbytes(btrfs_inode, inode_nbytes)=
;
> + =A0 =A0 =A0 return 0;
> =A0error:
> =A0 =A0 =A0 =A0fprintf(stderr, "ext2fs_block_iterate2: %s\n", error_m=
essage(err));
> =A0 =A0 =A0 =A0return -1;
> @@ -1206,52 +1435,33 @@ static int copy_inodes(struct btrfs_root *roo=
t, ext2_filsys ext2_fs,
> =A0*/
> =A0static int create_image_file_range(struct btrfs_trans_handle *tran=
s,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct btrfs_root *root, u64 objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct btrfs_inode_item *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
u64 *inode_nbytes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u=
64 start_byte, u64 end_byte,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct extent_io_tree *orig_free_tree)
> =A0{
> - =A0 =A0 =A0 u32 blocksize =3D root->sectorsize;
> - =A0 =A0 =A0 u32 block =3D start_byte / blocksize;
> - =A0 =A0 =A0 u32 last_block =3D (end_byte + blocksize - 1) / blocksi=
ze;
> =A0 =A0 =A0 =A0int ret =3D 0;
> - =A0 =A0 =A0 struct blk_iterate_data data =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .trans =A0 =A0 =A0 =A0 =A0=3D trans,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .root =A0 =A0 =A0 =A0 =A0 =3D root,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .inode =A0 =A0 =A0 =A0 =A0=3D inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .objectid =A0 =A0 =A0 =3D objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .first_block =A0 =A0=3D block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .disk_block =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .num_blocks =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .boundary =A0 =A0 =A0 =3D (u64)-1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .checksum =A0 =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .errcode =A0 =A0 =A0 =A0=3D 0,
> - =A0 =A0 =A0 };
> - =A0 =A0 =A0 for (; start_byte < end_byte; block++, start_byte +=3D =
blocksize) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_range_bit(orig_free_tree, star=
t_byte,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
start_byte + blocksize, EXTENT_DIRTY, 1))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D block_iterate_proc(NULL, block,=
 block, &data);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret & BLOCK_ABORT) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D data.errcode;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 if (data.num_blocks > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blocks(trans, root,=
 objectid, inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, data.disk_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.num_blocks, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 data.first_block +=3D data.num_blocks;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 if (last_block > data.first_block) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blocks(trans, root,=
 objectid, inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, 0, last_block -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, 0);
> + =A0 =A0 =A0 struct extent_iterate_data data;
> + =A0 =A0 =A0 ret =3D start_file_extents_range(&data, trans, root, in=
ode_nbytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0objectid, 0, start_byte, end_byte);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 while (start_byte < end_byte) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 start, end;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_first_extent_bit(orig_free=
_tree, start_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 &start, &end, EXTENT_DIRTY);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D end_byte;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (start > start_byte) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 size =3D min_t(u64,=
 start - start_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 end_byte - start_byte);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D add_file_disk_e=
xtent(&data, start_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start_byte, size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 start_byte =3D end + 1;
> =A0 =A0 =A0 =A0}
> -fail:
> + =A0 =A0 =A0 ret =3D finish_file_extents(&data);
> =A0 =A0 =A0 =A0return ret;
> =A0}
> =A0/*
> @@ -1279,6 +1489,7 @@ static int create_ext2_image(struct btrfs_root =
*root, const char *name,
> =A0 =A0 =A0 =A0u64 last_byte;
> =A0 =A0 =A0 =A0u64 first_free;
> =A0 =A0 =A0 =A0u64 total_bytes;
> + =A0 =A0 =A0 u64 inode_nbytes;
> =A0 =A0 =A0 =A0u32 sectorsize =3D root->sectorsize;
>
> =A0 =A0 =A0 =A0total_bytes =3D btrfs_super_total_bytes(&fs_info->supe=
r_copy);
> @@ -1289,7 +1500,7 @@ static int create_ext2_image(struct btrfs_root =
*root, const char *name,
> =A0 =A0 =A0 =A0btrfs_set_stack_inode_generation(&btrfs_inode, 1);
> =A0 =A0 =A0 =A0btrfs_set_stack_inode_size(&btrfs_inode, total_bytes);
> =A0 =A0 =A0 =A0btrfs_set_stack_inode_nlink(&btrfs_inode, 1);
> - =A0 =A0 =A0 btrfs_set_stack_inode_nbytes(&btrfs_inode, 0);
> + =A0 =A0 =A0 inode_nbytes =3D 0;
> =A0 =A0 =A0 =A0btrfs_set_stack_inode_mode(&btrfs_inode, S_IFREG | 040=
0);
> =A0 =A0 =A0 =A0btrfs_set_stack_inode_flags(&btrfs_inode, BTRFS_INODE_=
NODATASUM |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
BTRFS_INODE_READONLY);
> @@ -1315,7 +1526,7 @@ static int create_ext2_image(struct btrfs_root =
*root, const char *name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D record_file_extent(trans, root=
, objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&btrfs_inode, last_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&inode_nbytes, last_byte,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 key.objectid, sectorsize, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> @@ -1370,12 +1581,12 @@ next:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bytenr > last_byte) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D create_image_f=
ile_range(trans, root, objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &btrfs_inode, last_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &inode_nbytes, last_byte,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytenr, orig_free_tree);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto f=
ail;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_extent(trans, root,=
 objectid, &btrfs_inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_extent(trans, root,=
 objectid, &inode_nbytes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bytenr, bytenr, num_bytes, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> @@ -1392,12 +1603,14 @@ next:
> =A0 =A0 =A0 =A0btrfs_release_path(root, &path);
> =A0 =A0 =A0 =A0if (total_bytes > last_byte) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D create_image_file_range(trans,=
 root, objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &btrfs_inode, last_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &inode_nbytes, last_byte,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0total_bytes, orig_free_tree);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 btrfs_set_stack_inode_nbytes(&btrfs_inode, inode_nbytes=
);
> +
> =A0 =A0 =A0 =A0ret =3D btrfs_insert_inode(trans, root, objectid, &btr=
fs_inode);
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> @@ -1934,7 +2147,7 @@ static int relocate_one_reference(struct btrfs_=
trans_handle *trans,
> =A0 =A0 =A0 =A0struct btrfs_key key;
> =A0 =A0 =A0 =A0struct btrfs_path path;
> =A0 =A0 =A0 =A0struct btrfs_inode_item inode;
> - =A0 =A0 =A0 struct blk_iterate_data data;
> + =A0 =A0 =A0 struct extent_iterate_data data;
> =A0 =A0 =A0 =A0u64 bytenr;
> =A0 =A0 =A0 =A0u64 num_bytes;
> =A0 =A0 =A0 =A0u64 cur_offset;
> @@ -1990,22 +2203,14 @@ static int relocate_one_reference(struct btrf=
s_trans_handle *trans,
> =A0 =A0 =A0 =A0btrfs_release_path(root, &path);
>
> =A0 =A0 =A0 =A0BUG_ON(num_bytes & (sectorsize - 1));
> - =A0 =A0 =A0 nbytes =3D btrfs_stack_inode_nbytes(&inode) - num_bytes=
;
> - =A0 =A0 =A0 btrfs_set_stack_inode_nbytes(&inode, nbytes);
> =A0 =A0 =A0 =A0datacsum =3D !(btrfs_stack_inode_flags(&inode) & BTRFS=
_INODE_NODATASUM);
>
> - =A0 =A0 =A0 data =3D (struct blk_iterate_data) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .trans =A0 =A0 =A0 =A0 =A0=3D trans,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .root =A0 =A0 =A0 =A0 =A0 =3D root,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .inode =A0 =A0 =A0 =A0 =A0=3D &inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .objectid =A0 =A0 =A0 =3D extent_key->o=
bjectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .first_block =A0 =A0=3D extent_key->off=
set / sectorsize,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .disk_block =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .num_blocks =A0 =A0 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .boundary =A0 =A0 =A0 =3D (u64)-1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .checksum =A0 =A0 =A0 =3D datacsum,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .errcode =A0 =A0 =A0 =A0=3D 0,
> - =A0 =A0 =A0 };
> + =A0 =A0 =A0 ret =3D start_file_extents_range(&data, trans, root, &n=
bytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0extent_key->objectid, datacsum,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0extent_key->offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0extent_key->offset + num_bytes);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
>
> =A0 =A0 =A0 =A0cur_offset =3D extent_key->offset;
> =A0 =A0 =A0 =A0while (num_bytes > 0) {
> @@ -2035,26 +2240,19 @@ static int relocate_one_reference(struct btrf=
s_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D block_iterate_proc(NULL, new_po=
s / sectorsize,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_offset / sectorsize, &data);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret & BLOCK_ABORT) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D data.errcode;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D add_file_disk_extent(&data, cur=
_offset, new_pos,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0sectorsize);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_offset +=3D sectorsize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytenr +=3D sectorsize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_bytes -=3D sectorsize;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (data.num_blocks > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D record_file_blocks(trans, root,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0extent_key->objectid, &inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.first_block, data.disk_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0data.num_blocks, datacsum);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D finish_file_extents(&data);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
>
> =A0 =A0 =A0 =A0key.objectid =3D extent_key->objectid;
> =A0 =A0 =A0 =A0key.offset =3D 0;
> --
> 1.6.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
