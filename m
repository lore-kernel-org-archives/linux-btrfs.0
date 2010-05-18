From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH 1/4] btrfs-convert: make more use of cache_free_extents
Date: Tue, 18 May 2010 21:40:28 +0800
Message-ID: <AANLkTikJiGhwyOV3UTiS9vdjVX4w3yuVT2urOdXSZ8sD@mail.gmail.com>
References: <20100320042449.GA17083@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: wingedtachikoma@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100320042449.GA17083@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 20, 2010 at 12:24 PM, Sean Bartell
<wingedtachikoma@gmail.com> wrote:
> An extent_io_tree is used for all free space information. This allows
> removal of ext2_alloc_block and ext2_free_block, and makes
> create_ext2_image less ext2-specific.
> ---
> =A0convert.c | =A0154 +++++++++++++++++++++++++++++++++++++++--------=
--------------
> =A01 files changed, 99 insertions(+), 55 deletions(-)
>
> diff --git a/convert.c b/convert.c
> index d037c98..c48f8ba 100644
> --- a/convert.c
> +++ b/convert.c
> @@ -95,29 +95,10 @@ static int close_ext2fs(ext2_filsys fs)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -static int ext2_alloc_block(ext2_filsys fs, u64 goal, u64 *block_ret=
)
> +static int ext2_cache_free_extents(ext2_filsys ext2_fs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct extent_io_tree *free_tree)
> =A0{
> - =A0 =A0 =A0 blk_t block;
> -
> - =A0 =A0 =A0 if (!ext2fs_new_block(fs, goal, NULL, &block)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_fast_mark_block_bitmap(fs->block=
_map, block);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *block_ret =3D block;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 return -ENOSPC;
> -}
> -
> -static int ext2_free_block(ext2_filsys fs, u64 block)
> -{
> - =A0 =A0 =A0 BUG_ON(block !=3D (blk_t)block);
> - =A0 =A0 =A0 ext2fs_fast_unmark_block_bitmap(fs->block_map, block);
> - =A0 =A0 =A0 return 0;
> -}
> -
> -static int cache_free_extents(struct btrfs_root *root, ext2_filsys e=
xt2_fs)
> -
> -{
> - =A0 =A0 =A0 int i, ret =3D 0;
> + =A0 =A0 =A0 int ret =3D 0;
> =A0 =A0 =A0 =A0blk_t block;
> =A0 =A0 =A0 =A0u64 bytenr;
> =A0 =A0 =A0 =A0u64 blocksize =3D ext2_fs->blocksize;
> @@ -127,29 +108,68 @@ static int cache_free_extents(struct btrfs_root=
 *root, ext2_filsys ext2_fs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ext2fs_fast_test_block_bitmap(ext2=
_fs->block_map, block))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytenr =3D block * blocksize;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D set_extent_dirty(&root->fs_info=
->free_space_cache,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0bytenr, bytenr + blocksize - 1, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D set_extent_dirty(free_tree, byt=
enr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0bytenr + blocksize - 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/* mark btrfs-reserved blocks as used */
> +static void adjust_free_extents(ext2_filsys ext2_fs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
extent_io_tree *free_tree)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 u64 bytenr;
> + =A0 =A0 =A0 u64 blocksize =3D ext2_fs->blocksize;
> +
> + =A0 =A0 =A0 clear_extent_dirty(free_tree, 0, BTRFS_SUPER_INFO_OFFSE=
T - 1, 0);
> +
> =A0 =A0 =A0 =A0for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytenr =3D btrfs_sb_offset(i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytenr &=3D ~((u64)STRIPE_LEN - 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bytenr >=3D blocksize * ext2_fs->s=
uper->s_blocks_count)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_extent_dirty(&root->fs_info->free=
_space_cache, bytenr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
bytenr + STRIPE_LEN - 1, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_extent_dirty(free_tree, bytenr, b=
ytenr + STRIPE_LEN - 1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0);
> =A0 =A0 =A0 =A0}
> +}
>
> - =A0 =A0 =A0 clear_extent_dirty(&root->fs_info->free_space_cache,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, BTRFS_SUPER_I=
NFO_OFFSET - 1, 0);
> -
> +static int alloc_blocks(struct extent_io_tree *free_tree,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 *blocks, int num, u=
64 blocksize)
> +{
> + =A0 =A0 =A0 u64 start;
> + =A0 =A0 =A0 u64 end;
> + =A0 =A0 =A0 u64 last =3D 0;
> + =A0 =A0 =A0 u64 mask =3D blocksize - 1;
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 while(num) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_first_extent_bit(free_tree=
, last, &start, &end,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 EXTENT_DIRTY);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last =3D end + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (start & mask)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D (start & mask=
) + blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (last - start < blocksize)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *blocks++ =3D start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last =3D start + blocksize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_extent_dirty(free_tree, start, la=
st - 1, 0);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return 0;
> +fail:
> + =A0 =A0 =A0 fprintf(stderr, "not enough free space\n");
> + =A0 =A0 =A0 return -ENOSPC;
> =A0}
>
> =A0static int custom_alloc_extent(struct btrfs_root *root, u64 num_by=
tes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 hint_=
byte, struct btrfs_key *ins)
> =A0{
> + =A0 =A0 =A0 u64 blocksize =3D root->sectorsize;
> + =A0 =A0 =A0 u64 mask =3D blocksize - 1;
> =A0 =A0 =A0 =A0u64 start;
> =A0 =A0 =A0 =A0u64 end;
> =A0 =A0 =A0 =A0u64 last =3D hint_byte;
> @@ -171,6 +191,8 @@ static int custom_alloc_extent(struct btrfs_root =
*root, u64 num_bytes,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start =3D max(last, start);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0last =3D end + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (start & mask)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D (start & mask=
) + blocksize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (last - start < num_bytes)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> @@ -1186,9 +1208,9 @@ static int create_image_file_range(struct btrfs=
_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct btrfs_root *root, u64 objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct btrfs_inode_item *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u=
64 start_byte, u64 end_byte,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
ext2_filsys ext2_fs)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct extent_io_tree *orig_free_tree)
> =A0{
> - =A0 =A0 =A0 u32 blocksize =3D ext2_fs->blocksize;
> + =A0 =A0 =A0 u32 blocksize =3D root->sectorsize;
> =A0 =A0 =A0 =A0u32 block =3D start_byte / blocksize;
> =A0 =A0 =A0 =A0u32 last_block =3D (end_byte + blocksize - 1) / blocks=
ize;
> =A0 =A0 =A0 =A0int ret =3D 0;
> @@ -1205,7 +1227,8 @@ static int create_image_file_range(struct btrfs=
_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.errcode =A0 =A0 =A0 =A0=3D 0,
> =A0 =A0 =A0 =A0};
> =A0 =A0 =A0 =A0for (; start_byte < end_byte; block++, start_byte +=3D=
 blocksize) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ext2fs_fast_test_block_bitmap(ext2=
_fs->block_map, block))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_range_bit(orig_free_tree, star=
t_byte,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
start_byte + blocksize, EXTENT_DIRTY, 1))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D block_iterate_proc(NULL, block=
, block, &data);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret & BLOCK_ABORT) {
> @@ -1234,8 +1257,8 @@ fail:
> =A0/*
> =A0* Create the ext2fs image file.
> =A0*/
> -static int create_ext2_image(struct btrfs_root *root, ext2_filsys ex=
t2_fs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *=
name)
> +static int create_ext2_image(struct btrfs_root *root, const char *na=
me,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct exten=
t_io_tree *orig_free_tree)
> =A0{
> =A0 =A0 =A0 =A0int ret;
> =A0 =A0 =A0 =A0struct btrfs_key key;
> @@ -1348,7 +1371,7 @@ next:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bytenr > last_byte) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D create_image_f=
ile_range(trans, root, objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&btrfs_inode, last_byte,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytenr, ext2_fs);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytenr, orig_free_tree);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto f=
ail;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -1370,7 +1393,7 @@ next:
> =A0 =A0 =A0 =A0if (total_bytes > last_byte) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D create_image_file_range(trans,=
 root, objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0&btrfs_inode, last_byte,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 total_bytes, ext2_fs);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 total_bytes, orig_free_tree);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
> @@ -2332,9 +2355,23 @@ err:
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> +static int copy_dirtiness(struct extent_io_tree *out,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct extent_io_tr=
ee *in)
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 u64 start, end, last =3D 0;
> + =A0 =A0 =A0 while (!find_first_extent_bit(in, last, &start, &end, E=
XTENT_DIRTY)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D set_extent_dirty(out, start, en=
d, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last =3D end + 1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0int do_convert(const char *devname, int datacsum, int packing, int=
 noxattr)
> =A0{
> - =A0 =A0 =A0 int i, fd, ret;
> + =A0 =A0 =A0 int fd, ret;
> =A0 =A0 =A0 =A0u32 blocksize;
> =A0 =A0 =A0 =A0u64 blocks[7];
> =A0 =A0 =A0 =A0u64 total_bytes;
> @@ -2342,7 +2379,11 @@ int do_convert(const char *devname, int datacs=
um, int packing, int noxattr)
> =A0 =A0 =A0 =A0ext2_filsys ext2_fs;
> =A0 =A0 =A0 =A0struct btrfs_root *root;
> =A0 =A0 =A0 =A0struct btrfs_root *ext2_root;
> + =A0 =A0 =A0 struct extent_io_tree free_tree;
> + =A0 =A0 =A0 struct extent_io_tree orig_free_tree;
>
> + =A0 =A0 =A0 extent_io_tree_init(&free_tree);
> + =A0 =A0 =A0 extent_io_tree_init(&orig_free_tree);
> =A0 =A0 =A0 =A0ret =3D open_ext2fs(devname, &ext2_fs);
> =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "unable to open the Ex=
t2fs\n");
> @@ -2359,13 +2400,23 @@ int do_convert(const char *devname, int datac=
sum, int packing, int noxattr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "filetype feature is m=
issing\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 for (i =3D 0; i < 7; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext2_alloc_block(ext2_fs, 0, bl=
ocks + i);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "not en=
ough free space\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks[i] *=3D blocksize;
> + =A0 =A0 =A0 ret =3D ext2_cache_free_extents(ext2_fs, &orig_free_tre=
e);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "error during cache_fre=
e_extents %d\n", ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* preserve first 64KiB, just in case */
> + =A0 =A0 =A0 clear_extent_dirty(&orig_free_tree, 0, BTRFS_SUPER_INFO=
_OFFSET - 1, 0);
> +
> + =A0 =A0 =A0 ret =3D copy_dirtiness(&free_tree, &orig_free_tree);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "error during copy_dirt=
iness %d\n", ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 adjust_free_extents(ext2_fs, &free_tree);
> + =A0 =A0 =A0 ret =3D alloc_blocks(&free_tree, blocks, 7, blocksize);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0super_bytenr =3D blocks[0];
> =A0 =A0 =A0 =A0fd =3D open(devname, O_RDWR);
> @@ -2391,17 +2442,9 @@ int do_convert(const char *devname, int datacs=
um, int packing, int noxattr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "unable to open ctree\=
n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 ret =3D cache_free_extents(root, ext2_fs);
> - =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "error during cache_fre=
e_extents %d\n", ret);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 copy_dirtiness(&root->fs_info->free_space_cache, &free_=
tree);
> + =A0 =A0 =A0 extent_io_tree_cleanup(&free_tree);
> =A0 =A0 =A0 =A0root->fs_info->extent_ops =3D &extent_ops;
> - =A0 =A0 =A0 /* recover block allocation bitmap */
> - =A0 =A0 =A0 for (i =3D 0; i < 7; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks[i] /=3D blocksize;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2_free_block(ext2_fs, blocks[i]);
> - =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0ret =3D init_btrfs(root);
> =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "unable to setup the r=
oot tree\n");
> @@ -2419,11 +2462,12 @@ int do_convert(const char *devname, int datac=
sum, int packing, int noxattr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "unable to create subv=
ol\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 ret =3D create_ext2_image(ext2_root, ext2_fs, "image");
> + =A0 =A0 =A0 ret =3D create_ext2_image(ext2_root, "image", &orig_fre=
e_tree);


extent_io_tree is not very space efficient. caching free space in
several places is not good. I prefer adding a function that checks
if a given block is used to the 'convert_fs' structure.

> =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error during create_e=
xt2_image %d\n", ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 extent_io_tree_cleanup(&orig_free_tree);
> =A0 =A0 =A0 =A0printf("cleaning up system chunk.\n");
> =A0 =A0 =A0 =A0ret =3D cleanup_sys_chunk(root, ext2_root);
> =A0 =A0 =A0 =A0if (ret) {
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
