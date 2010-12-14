From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: Re: [RFC 4/5] implement metadata_ra in btrfs
Date: Tue, 14 Dec 2010 09:06:16 +0800
Message-ID: <AANLkTin8oHMaEVE_=-pfExrm8K4Nh0mtRDxmLcE4Rhcq@mail.gmail.com>
References: <1292224936.2323.453.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1292224936.2323.453.camel@sli10-conroe>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 13, 2010 at 3:22 PM, Shaohua Li <shaohua.li@intel.com> wrot=
e:
> Implementation btrfs .metadata_readahead. In btrfs, all metadata page=
s are in a
> special btree_inode. We do readahead in it.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> ---
> =A0fs/btrfs/disk-io.c | =A0 10 ++++++++++
> =A0fs/btrfs/super.c =A0 | =A0 13 +++++++++++++
> =A0mm/readahead.c =A0 =A0 | =A0 =A01 +
> =A03 files changed, 24 insertions(+)
>
> Index: linux/fs/btrfs/disk-io.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/fs/btrfs/disk-io.c =A0 =A0 =A0 2010-12-07 13:32:24.000=
000000 +0800
> +++ linux/fs/btrfs/disk-io.c =A0 =A02010-12-07 13:33:08.000000000 +08=
00
> @@ -776,6 +776,15 @@ static int btree_readpage(struct file *f
> =A0 =A0 =A0 =A0return extent_read_full_page(tree, page, btree_get_ext=
ent);
> =A0}
>
> +static int btree_readpages(struct file *file, struct address_space *=
mapping,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct list_head *pages, unsigned nr_pa=
ges)
> +{
> + =A0 =A0 =A0 struct extent_io_tree *tree;
> + =A0 =A0 =A0 tree =3D &BTRFS_I(mapping->host)->io_tree;
> + =A0 =A0 =A0 return extent_readpages(tree, mapping, pages, nr_pages,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btree_get_extent);
> +}
> +
> =A0static int btree_releasepage(struct page *page, gfp_t gfp_flags)
> =A0{
> =A0 =A0 =A0 =A0struct extent_io_tree *tree;
> @@ -819,6 +828,7 @@ static void btree_invalidatepage(struct
>
> =A0static const struct address_space_operations btree_aops =3D {
> =A0 =A0 =A0 =A0.readpage =A0 =A0 =A0 =3D btree_readpage,
> + =A0 =A0 =A0 .readpages =A0 =A0 =A0=3D btree_readpages,
> =A0 =A0 =A0 =A0.writepage =A0 =A0 =A0=3D btree_writepage,
> =A0 =A0 =A0 =A0.writepages =A0 =A0 =3D btree_writepages,
> =A0 =A0 =A0 =A0.releasepage =A0 =A0=3D btree_releasepage,
> Index: linux/fs/btrfs/super.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/fs/btrfs/super.c 2010-12-07 13:32:24.000000000 +0800
> +++ linux/fs/btrfs/super.c =A0 =A0 =A02010-12-07 13:33:08.000000000 +=
0800
> @@ -892,6 +892,18 @@ out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOENT;
> =A0}
>
> +static int btrfs_metadata_readahead(struct super_block *sb, loff_t o=
ffset,
> + =A0 =A0 =A0 ssize_t size)
> +{
> + =A0 =A0 =A0 struct btrfs_root *tree_root =3D btrfs_sb(sb);
> + =A0 =A0 =A0 struct inode *btree_inode =3D tree_root->fs_info->btree=
_inode;
> + =A0 =A0 =A0 struct address_space *mapping =3D btree_inode->i_mappin=
g;
> +
> + =A0 =A0 =A0 force_page_cache_readahead(mapping, NULL, offset >> PAG=
E_CACHE_SHIFT,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size >> PAGE_CACHE_SHIFT);
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0static const struct super_operations btrfs_super_ops =3D {
> =A0 =A0 =A0 =A0.drop_inode =A0 =A0 =3D btrfs_drop_inode,
> =A0 =A0 =A0 =A0.evict_inode =A0 =A0=3D btrfs_evict_inode,
> @@ -907,6 +919,7 @@ static const struct super_operations btr
> =A0 =A0 =A0 =A0.freeze_fs =A0 =A0 =A0=3D btrfs_freeze,
> =A0 =A0 =A0 =A0.unfreeze_fs =A0 =A0=3D btrfs_unfreeze,
> =A0 =A0 =A0 =A0.metadata_incore =3D btrfs_metadata_incore,
> + =A0 =A0 =A0 .metadata_readahead =3D btrfs_metadata_readahead,
> =A0};
>
> =A0static const struct file_operations btrfs_ctl_fops =3D {
> Index: linux/mm/readahead.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/mm/readahead.c =A0 2010-12-07 13:32:24.000000000 +0800
> +++ linux/mm/readahead.c =A0 =A0 =A0 =A02010-12-07 13:33:08.000000000=
 +0800
> @@ -228,6 +228,7 @@ int force_page_cache_readahead(struct ad
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return ret;
> =A0}
> +EXPORT_SYMBOL_GPL(force_page_cache_readahead);
>
> =A0/*
> =A0* Given a desired number of PAGE_CACHE_SIZE readahead pages, retur=
n a
>
>

btrfs will crash If the read-ahead range falls into unallocated chunk.
need code to check validity of the user input.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
