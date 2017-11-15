Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:56869 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932252AbdKOPmw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <20171114224625.1EBFC21C51@pdx-korg-gitolite-1.ci.codeaurora.org>
References: <20171114224625.1EBFC21C51@pdx-korg-gitolite-1.ci.codeaurora.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 15 Nov 2017 16:42:50 +0100
Message-ID: <CAMuHMdWHt8xHt6Ah8FYaqUDe6OhLZXrMDBxjefURgDi=XJ1c_A@mail.gmail.com>
Subject: Re: Btrfs: add a extent ref verify tool
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 11:46 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Web:        https://git.kernel.org/torvalds/c/fd708b81d972a0714b02a60eb4792fdbf15868c4
> Commit:     fd708b81d972a0714b02a60eb4792fdbf15868c4
> Parent:     84f7d8e6242ceb377c7af10a7133c653cc7fea5f
> Refname:    refs/heads/master
> Author:     Josef Bacik <josef@toxicpanda.com>
> AuthorDate: Fri Sep 29 15:43:50 2017 -0400
> Committer:  David Sterba <dsterba@suse.com>
> CommitDate: Mon Oct 30 12:28:00 2017 +0100
>
>     Btrfs: add a extent ref verify tool
>
>     We were having corruption issues that were tied back to problems with
>     the extent tree.  In order to track them down I built this tool to try
>     and find the culprit, which was pretty successful.  If you compile with
>     this tool on it will live verify every ref update that the fs makes and
>     make sure it is consistent and valid.  I've run this through with
>     xfstests and haven't gotten any false positives.  Thanks,
>
>     Signed-off-by: Josef Bacik <jbacik@fb.com>
>     Reviewed-by: David Sterba <dsterba@suse.com>
>     [ update error messages, add fixup from Dan Carpenter to handle errors
>       of read_tree_block ]
>     Signed-off-by: David Sterba <dsterba@suse.com>

> --- /dev/null
> +++ b/fs/btrfs/ref-verify.c

> +static int process_extent_item(struct btrfs_fs_info *fs_info,
> +                              struct btrfs_path *path, struct btrfs_key *key,
> +                              int slot, int *tree_block_level)
> +{
> +       struct btrfs_extent_item *ei;
> +       struct btrfs_extent_inline_ref *iref;
> +       struct btrfs_extent_data_ref *dref;
> +       struct btrfs_shared_data_ref *sref;
> +       struct extent_buffer *leaf = path->nodes[0];
> +       u32 item_size = btrfs_item_size_nr(leaf, slot);
> +       unsigned long end, ptr;
> +       u64 offset, flags, count;
> +       int type, ret;

With gcc-4.1.2:

warning: ‘ret’ may be used uninitialized in this function

> +
> +       ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
> +       flags = btrfs_extent_flags(leaf, ei);
> +
> +       if ((key->type == BTRFS_EXTENT_ITEM_KEY) &&
> +           flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
> +               struct btrfs_tree_block_info *info;
> +
> +               info = (struct btrfs_tree_block_info *)(ei + 1);
> +               *tree_block_level = btrfs_tree_block_level(leaf, info);
> +               iref = (struct btrfs_extent_inline_ref *)(info + 1);
> +       } else {
> +               if (key->type == BTRFS_METADATA_ITEM_KEY)
> +                       *tree_block_level = key->offset;
> +               iref = (struct btrfs_extent_inline_ref *)(ei + 1);
> +       }
> +
> +       ptr = (unsigned long)iref;
> +       end = (unsigned long)ei + item_size;
> +       while (ptr < end) {

Is this loop guaranteed to run at least once?
If not:
  1. uninitialized ret will be returned,
  2. To which value should ret be preinitialized? 0 or an error?

As I understand this is a verification tool, it should be implemented
using defensive programming.

> +               iref = (struct btrfs_extent_inline_ref *)ptr;
> +               type = btrfs_extent_inline_ref_type(leaf, iref);
> +               offset = btrfs_extent_inline_ref_offset(leaf, iref);
> +               switch (type) {
> +               case BTRFS_TREE_BLOCK_REF_KEY:
> +                       ret = add_tree_block(fs_info, offset, 0, key->objectid,
> +                                            *tree_block_level);
> +                       break;
> +               case BTRFS_SHARED_BLOCK_REF_KEY:
> +                       ret = add_tree_block(fs_info, 0, offset, key->objectid,
> +                                            *tree_block_level);
> +                       break;
> +               case BTRFS_EXTENT_DATA_REF_KEY:
> +                       dref = (struct btrfs_extent_data_ref *)(&iref->offset);
> +                       ret = add_extent_data_ref(fs_info, leaf, dref,
> +                                                 key->objectid, key->offset);
> +                       break;
> +               case BTRFS_SHARED_DATA_REF_KEY:
> +                       sref = (struct btrfs_shared_data_ref *)(iref + 1);
> +                       count = btrfs_shared_data_ref_count(leaf, sref);
> +                       ret = add_shared_data_ref(fs_info, offset, count,
> +                                                 key->objectid, key->offset);
> +                       break;
> +               default:
> +                       btrfs_err(fs_info, "invalid key type in iref");
> +                       ret = -EINVAL;
> +                       break;
> +               }
> +               if (ret)
> +                       break;
> +               ptr += btrfs_extent_inline_ref_size(type);
> +       }
> +       return ret;
> +}
> +
> +static int process_leaf(struct btrfs_root *root,
> +                       struct btrfs_path *path, u64 *bytenr, u64 *num_bytes)
> +{
> +       struct btrfs_fs_info *fs_info = root->fs_info;
> +       struct extent_buffer *leaf = path->nodes[0];
> +       struct btrfs_extent_data_ref *dref;
> +       struct btrfs_shared_data_ref *sref;
> +       u32 count;
> +       int i = 0, tree_block_level = 0, ret;

warning: ‘ret’ may be used uninitialized in this function

> +       struct btrfs_key key;
> +       int nritems = btrfs_header_nritems(leaf);

Can this be zero?

> +       for (i = 0; i < nritems; i++) {

If yes, the loop will never be executed, and uninitialized ret will be returned.

As I understand this is a verification tool, it should be implemented
using defensive programming.

> +               btrfs_item_key_to_cpu(leaf, &key, i);
> +               switch (key.type) {
> +               case BTRFS_EXTENT_ITEM_KEY:
> +                       *num_bytes = key.offset;
> +               case BTRFS_METADATA_ITEM_KEY:
> +                       *bytenr = key.objectid;
> +                       ret = process_extent_item(fs_info, path, &key, i,
> +                                                 &tree_block_level);
> +                       break;
> +               case BTRFS_TREE_BLOCK_REF_KEY:
> +                       ret = add_tree_block(fs_info, key.offset, 0,
> +                                            key.objectid, tree_block_level);
> +                       break;
> +               case BTRFS_SHARED_BLOCK_REF_KEY:
> +                       ret = add_tree_block(fs_info, 0, key.offset,
> +                                            key.objectid, tree_block_level);
> +                       break;
> +               case BTRFS_EXTENT_DATA_REF_KEY:
> +                       dref = btrfs_item_ptr(leaf, i,
> +                                             struct btrfs_extent_data_ref);
> +                       ret = add_extent_data_ref(fs_info, leaf, dref, *bytenr,
> +                                                 *num_bytes);
> +                       break;
> +               case BTRFS_SHARED_DATA_REF_KEY:
> +                       sref = btrfs_item_ptr(leaf, i,
> +                                             struct btrfs_shared_data_ref);
> +                       count = btrfs_shared_data_ref_count(leaf, sref);
> +                       ret = add_shared_data_ref(fs_info, key.offset, count,
> +                                                 *bytenr, *num_bytes);
> +                       break;
> +               default:

If every loop iteration hits this default case, uninitialized ret will be
returned.

Is this an error case?
If yes, ret should be set to an error value.
If no, ret should be set to zero (unless preinitialized above).

> +                       break;
> +               }
> +               if (ret)
> +                       break;
> +       }
> +       return ret;
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
