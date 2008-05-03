From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Sat, 3 May 2008 15:25:00 +0800
Message-ID: <3d0408630805030025s2c9006c1qad3c29011caf3013@mail.gmail.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <200804250941.35343.chris.mason@oracle.com>
	 <Pine.LNX.4.64.0804251119260.23551@cobra.newdream.net>
	 <Pine.LNX.4.64.0804251531510.20107@cobra.newdream.net>
	 <3d0408630805022144h3dd137e6k40f5c315c7b18f36@mail.gmail.com>
	 <Pine.LNX.4.64.0805022255370.15314@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Chris Mason" <chris.mason@oracle.com>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: "Sage Weil" <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0805022255370.15314@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

2008/5/3, Sage Weil <sage@newdream.net>:
> Hi Yan-
>
> On Sat, 3 May 2008, Yan Zheng wrote:
> > I think the clone ioctl won't work in some corner case. The big loop
> > in btrfs_ioctl_clone uses path->slots[0]++ and btrfs_next_leaf to get
> > next item in the tree. However, this approach works only when the
> > layout of tree keeps unchangeed. In btrfs_ioctl_clone, both
> > btrfs_insert_file_extent and dup_item_to_inode may change the layout
> > of tree.
> >
> > To be safe, I think the codes should:
> >  use btrfs_search_slot to find next item.
> >  use a intermediate buffer when coping item between two extent buffer.
>
> Oh, right.  I think for the item copy, though, we just need to re-search
> for the source key again after doing the insert_empty_item.  Then we can
> still use copy_extent_buffer, since at that point both paths will be
> valid?
>
> Something like the below (untested) patch.  I suspect I didn't hit this
> because I was always cloning 'file' to something like 'file2' that always
> sorted after the src file, and didn't shift its position in the leaf. I'll
> try to test this in the next few days.
>
> Thanks-
> sage
>
>
> diff -r f6ba18a50ad7 inode.c
> --- a/inode.c   Fri May 02 16:13:49 2008 -0400
> +++ b/inode.c   Fri May 02 23:11:49 2008 -0700
> @@ -3103,25 +3103,27 @@ out:
>
>  void dup_item_to_inode(struct btrfs_trans_handle *trans,
>                       struct btrfs_root *root,
> -                      struct btrfs_path *path,
> -                      struct extent_buffer *leaf,
> -                      int slot,
> -                      struct btrfs_key *key,
> +                      struct btrfs_path *srcpath,
> +                      struct btrfs_key *srckey,
>                       u64 destino)
>  {
> -       struct btrfs_path *cpath = btrfs_alloc_path();
> -       int len = btrfs_item_size_nr(leaf, slot);
> -       int dstoff;
> -       struct btrfs_key ckey = *key;
> +       struct btrfs_key dstkey = *srckey;
> +       struct btrfs_path *dstpath = btrfs_alloc_path();
> +       int len = btrfs_item_size_nr(srcpath->nodes[0],
> +                                    srcpath->slots[0]);
>        int ret;
>
> -       ckey.objectid = destino;
> -       ret = btrfs_insert_empty_item(trans, root, cpath, &ckey, len);
> -       dstoff = btrfs_item_ptr_offset(cpath->nodes[0], cpath->slots[0]);
> -       copy_extent_buffer(cpath->nodes[0], leaf, dstoff,
> -                          btrfs_item_ptr_offset(leaf, slot),
> +       dstkey.objectid = destino;
> +       ret = btrfs_insert_empty_item(trans, root, dstpath, &dstkey, len);
> +       /* re-search for src key, in case we changed srcpath */
> +       ret = btrfs_search_slot(trans, root, srckey, srcpath, 0, 0);
> +       copy_extent_buffer(dstpath->nodes[0], srcpath->nodes[0],
> +                          btrfs_item_ptr_offset(dstpath->nodes[0],
> +                                                dstpath->slots[0]),
> +                          btrfs_item_ptr_offset(srcpath->nodes[0],
> +                                                srcpath->slots[0]),
>                           len);
> -       btrfs_release_path(root, cpath);
> +       btrfs_release_path(root, dstpath);
>  }
>
>  long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
> @@ -3137,7 +3139,6 @@ long btrfs_ioctl_clone(struct file *file
>        struct btrfs_key key;
>        struct extent_buffer *leaf;
>        u32 nritems;
> -       int nextret;
>        int slot;
>
>        src_file = fget(src_fd);
> @@ -3178,6 +3179,8 @@ long btrfs_ioctl_clone(struct file *file
>        while (1) {
>                ret = btrfs_lookup_file_extent(trans, root, path, src->i_ino,
>                                               pos, 0);
> +
> +next_slot:
>                if (ret < 0)
>                        goto out;
>                if (ret > 0) {
> @@ -3187,7 +3190,7 @@ long btrfs_ioctl_clone(struct file *file
>                        }
>                        path->slots[0]--;
>                }
> -next_slot:
> +
>                leaf = path->nodes[0];
>                slot = path->slots[0];
>                btrfs_item_key_to_cpu(leaf, &key, slot);
> @@ -3225,22 +3228,19 @@ next_slot:
>                                }
>                                pos = key.offset + len;
>                        } else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
> -                               dup_item_to_inode(trans, root, path, leaf, slot,
> -                                                 &key, inode->i_ino);
> +                               dup_item_to_inode(trans, root, path, &key,
> +                                                 inode->i_ino);
>                                pos = key.offset + btrfs_item_size_nr(leaf,
>                                                                      slot);
>                        }
>                } else if (btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY)
> -                       dup_item_to_inode(trans, root, path, leaf, slot, &key,
> +                       dup_item_to_inode(trans, root, path, &key,
>                                          inode->i_ino);
>
> -               if (slot >= nritems - 1) {
> -                       nextret = btrfs_next_leaf(root, path);
> -                       if (nextret)
> -                               goto out;
> -               } else {
> -                       path->slots[0]++;
> -               }
> +               /* path may not still be valid, so explicitly search
> +                * for the next key */
> +               key.offset = pos;
> +               ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
>                goto next_slot;
>        }
>
>

In my previous mail, I said items of different types should be
differentiated. Actually, there is no need to do that. Please consider
changing the big loop in btrfs_ioctl_clone to something like:
---
key.objectid = src->i_ino;
key.offset = 0;
key.type = BTRFS_EXTENT_DATA_KEY;
while (1) {
	ret = btrfs_search_slot(trans, root, &key, &path, 0, 0);
	if (ret < 0)
		goto fail;

	leaf = path.nodes[0];
	if (path.slots[0] >= btrfs_header_nritems(leaf)) {
		ret = btrfs_next_leaf(extent_root, &path);
		if (ret < 0)
			goto fail;
		if (ret > 0)
			break;
		leaf = path.nodes[0];
	}

	btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);

	...
	do some works
	...

	btrfs_release_path(root, path);
	key.offset++;
}

---
Regards
YZ
