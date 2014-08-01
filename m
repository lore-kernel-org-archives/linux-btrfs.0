Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46801 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHARCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 13:02:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVjF_6mRWDLbZLXsr5F2PT3H-GW=rQdF7Yt9LYdKayGdVQ@mail.gmail.com>
References: <CAPDOMVhHq9kmRh11tX7BF_V4XjDncpzUROoJJntif-vwKZbbNw@mail.gmail.com>
	<CAPDOMVjF_6mRWDLbZLXsr5F2PT3H-GW=rQdF7Yt9LYdKayGdVQ@mail.gmail.com>
Date: Fri, 1 Aug 2014 13:02:07 -0400
Message-ID: <CAPDOMVggqiG1Y0dJ6OyW7g_MKa-Po9E-_AB1U3e-TvLy2+DSbw@mail.gmail.com>
Subject: Re: Help with btrfs_zero_range function
From: Nick Krause <xerofoify@gmail.com>
To: "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 1, 2014 at 12:58 PM, Nick Krause <xerofoify@gmail.com> wrote:
> Please forget my other questions , seems the only work to make punch
> hole work for zero range is to
> make a function like the one I am pasting below for zero range and
> change the calls to punch range to
> zero range as the other parts of the function can be the same from my reading.
> Regards Nick
> static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
> {
>     struct extent_map *em;
>     int ret = 0;
>
>     em = btrfs_get_extent(inode, NULL, 0, *start, *len, 0);
>     if (IS_ERR_OR_NULL(em)) {
>         if (!em)
>             ret = -ENOMEM;
>         else
>             ret = PTR_ERR(em);
>         return ret;
>     }
>
>     /* Hole or vacuum extent(only exists in no-hole mode) */
>     if (em->block_start == EXTENT_MAP_HOLE) {
>         ret = 1;
>         *len = em->start + em->len > *start + *len ?
>                0 : *start + *len - em->start - em->len;
>         *start = em->start + em->len;
>     }
>     free_extent_map(em);
>     return ret;
> }

Sorry just forget we need one to fill a zero range. I am also now
patching fill holes if someone can help me convert this it would be
great and
I will then change the calls and send out the function as I have
titled, btrfs_zero_range with calls to in it the fallocate method for
btrfs and also
I am need help with the one for finding the first hole just converting again.
Regards Nick
static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
              struct btrfs_path *path, u64 offset, u64 end)
{
    struct btrfs_root *root = BTRFS_I(inode)->root;
    struct extent_buffer *leaf;
    struct btrfs_file_extent_item *fi;
    struct extent_map *hole_em;
    struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
    struct btrfs_key key;
    int ret;

    if (btrfs_fs_incompat(root->fs_info, NO_HOLES))
        goto out;

    key.objectid = btrfs_ino(inode);
    key.type = BTRFS_EXTENT_DATA_KEY;
    key.offset = offset;

    ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
    if (ret < 0)
        return ret;
    BUG_ON(!ret);

    leaf = path->nodes[0];
    if (hole_mergeable(inode, leaf, path->slots[0]-1, offset, end)) {
        u64 num_bytes;

        path->slots[0]--;
        fi = btrfs_item_ptr(leaf, path->slots[0],
                    struct btrfs_file_extent_item);
        num_bytes = btrfs_file_extent_num_bytes(leaf, fi) +
            end - offset;
        btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
        btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
        btrfs_set_file_extent_offset(leaf, fi, 0);
        btrfs_mark_buffer_dirty(leaf);
        goto out;
    }

    if (hole_mergeable(inode, leaf, path->slots[0]+1, offset, end)) {
        u64 num_bytes;

        path->slots[0]++;
        key.offset = offset;
        btrfs_set_item_key_safe(root, path, &key);
        fi = btrfs_item_ptr(leaf, path->slots[0],
                    struct btrfs_file_extent_item);
        num_bytes = btrfs_file_extent_num_bytes(leaf, fi) + end -
            offset;
        btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
        btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
        btrfs_set_file_extent_offset(leaf, fi, 0);
        btrfs_mark_buffer_dirty(leaf);
        goto out;
    }
    btrfs_release_path(path);

    ret = btrfs_insert_file_extent(trans, root, btrfs_ino(inode), offset,
                       0, 0, end - offset, 0, end - offset,
                       0, 0, 0);
    if (ret)
        return ret;

out:
    btrfs_release_path(path);

    hole_em = alloc_extent_map();
    if (!hole_em) {
        btrfs_drop_extent_cache(inode, offset, end - 1, 0);
        set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
            &BTRFS_I(inode)->runtime_flags);
    } else {
        hole_em->start = offset;
        hole_em->len = end - offset;
        hole_em->ram_bytes = hole_em->len;
        hole_em->orig_start = offset;

        hole_em->block_start = EXTENT_MAP_HOLE;
        hole_em->block_len = 0;
        hole_em->orig_block_len = 0;
        hole_em->bdev = root->fs_info->fs_devices->latest_bdev;
        hole_em->compress_type = BTRFS_COMPRESS_NONE;
        hole_em->generation = trans->transid;

        do {
            btrfs_drop_extent_cache(inode, offset, end - 1, 0);
            write_lock(&em_tree->lock);
            ret = add_extent_mapping(em_tree, hole_em, 1);
            write_unlock(&em_tree->lock);
        } while (ret == -EEXIST);
        free_extent_map(hole_em);
        if (ret)
            set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
                &BTRFS_I(inode)->runtime_flags);
    }

    return 0;
}
