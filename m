Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:54768 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbdKJOLo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 09:11:44 -0500
Received: by mail-vk0-f68.google.com with SMTP id b18so3851794vkd.11
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 06:11:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1504662179-21877-2-git-send-email-gujx@cn.fujitsu.com>
References: <1504662179-21877-1-git-send-email-gujx@cn.fujitsu.com> <1504662179-21877-2-git-send-email-gujx@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 10 Nov 2017 19:41:03 +0530
Message-ID: <CAKuJGC-sTE+tvc28ie-CB5rwKK=H8SvFQNz95HgGB9A+ggb_uQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: Replace some BUG_ON by return
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gu,

I applied these two patches:

https://patchwork.kernel.org/patch/9939879/
https://patchwork.kernel.org/patch/9939881/

Still the test "sudo make TEST=003\* test-fuzz" is failing like:

 btrfs-progs/btrfs check --check-data-csum
btrfs-progs/tests/fuzz-tests/images/bko-156731.raw.restored
checking extents
cmds-check.c:5660: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
 btrfs-progs/btrfs[0x44dce4]
 btrfs-progs/btrfs[0x45b396]
 btrfs-progs/btrfs[0x45c2f0]
 btrfs-progs/btrfs[0x45ce92]
 btrfs-progs/btrfs(cmd_check+0x17ee)[0x460ee7]
 btrfs-progs/btrfs(main+0x15d)[0x40b523]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7faf98a4d830]
 btrfs-progs/btrfs(_start+0x29)[0x40aff9]
Checking filesystem on
btrfs-progs/tests/fuzz-tests/images/bko-156731.raw.restored
UUID: 52975385-d05a-482b-8fb8-613a86a66042
failed (ignored, ret=134):  btrfs-progs/btrfs check --check-data-csum
btrfs-progs/tests/fuzz-tests/images/bko-156731.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 003-multi-check-unmounted

Did I miss some other patch? thanks.

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Wed, Sep 6, 2017 at 7:12 AM, Gu Jinxiang <gujx@cn.fujitsu.com> wrote:
> The following test failed becasuse there is no data/metadata/system block_group.
> Use return ret to replace BUG_ON(ret) to avoid system crash, because there is
> enough message for user to understand what happened.
>
> $sudo TEST=003\* make test-fuzz
> Unable to find block group for 0
> Unable to find block group for 0
> Unable to find block group for 0
> extent-tree.c:2693: btrfs_reserve_extent: BUG_ON `ret` triggered, value -28
> /home/fnst/btrfs/btrfs-progs/btrfs[0x419966]
> /home/fnst/btrfs/btrfs-progs/btrfs(btrfs_reserve_extent+0xb16)[0x41f500]
> /home/fnst/btrfs/btrfs-progs/btrfs(btrfs_alloc_free_block+0x55)[0x41f59b]
> /home/fnst/btrfs/btrfs-progs/btrfs[0x46a6ce]
> /home/fnst/btrfs/btrfs-progs/btrfs(cmd_check+0x1012)[0x47c885]
> /home/fnst/btrfs/btrfs-progs/btrfs(main+0x127)[0x40b055]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x2aae83e89f45]
> /home/fnst/btrfs/btrfs-progs/btrfs[0x40a939]
> Creating a new CRC tree
> Checking filesystem on /home/fnst/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-155621-bad-block-group-offset.raw.restored
> UUID: 5cb33553-6f6d-4ce8-83fd-20af5a2f8181
> Reinitialize checksum tree
> failed (ignored, ret=134): /home/fnst/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/fnst/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-155621-bad-block-group-offset.raw.restored
> mayfail: returned code 134 (SIGABRT), not ignored
> test failed for case 003-multi-check-unmounted
>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  extent-tree.c | 16 ++++++++++------
>  transaction.c |  8 ++++++--
>  2 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/extent-tree.c b/extent-tree.c
> index eed56886..14838a5d 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -2678,11 +2678,13 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
>                         ret = do_chunk_alloc(trans, info,
>                                              num_bytes,
>                                              BTRFS_BLOCK_GROUP_METADATA);
> -                       BUG_ON(ret);
> +                       if (ret)
> +                               goto out;
>                 }
>                 ret = do_chunk_alloc(trans, info,
>                                      num_bytes + SZ_2M, data);
> -               BUG_ON(ret);
> +               if (ret)
> +                       goto out;
>         }
>
>         WARN_ON(num_bytes < info->sectorsize);
> @@ -2690,9 +2692,11 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
>                                search_start, search_end, hint_byte, ins,
>                                trans->alloc_exclude_start,
>                                trans->alloc_exclude_nr, data);
> -       BUG_ON(ret);
> +       if (ret)
> +               goto out;
>         clear_extent_dirty(&info->free_space_cache,
>                            ins->objectid, ins->objectid + ins->offset - 1);
> +out:
>         return ret;
>  }
>
> @@ -2761,7 +2765,8 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
>         int ret;
>         ret = btrfs_reserve_extent(trans, root, num_bytes, empty_size,
>                                    hint_byte, search_end, ins, 0);
> -       BUG_ON(ret);
> +       if (ret)
> +               goto out;
>
>         if (root_objectid == BTRFS_EXTENT_TREE_OBJECTID) {
>                 struct pending_extent_op *extent_op;
> @@ -2792,6 +2797,7 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
>                 finish_current_insert(trans, root->fs_info->extent_root);
>                 del_pending_extents(trans, root->fs_info->extent_root);
>         }
> +out:
>         return ret;
>  }
>
> @@ -2813,7 +2819,6 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
>                                trans->transid, 0, key, level,
>                                empty_size, hint, (u64)-1, &ins);
>         if (ret) {
> -               BUG_ON(ret > 0);
>                 return ERR_PTR(ret);
>         }
>
> @@ -2821,7 +2826,6 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
>         if (!buf) {
>                 btrfs_free_extent(trans, root, ins.objectid, ins.offset,
>                                   0, root->root_key.objectid, level, 0);
> -               BUG_ON(1);
>                 return ERR_PTR(-ENOMEM);
>         }
>         btrfs_set_buffer_uptodate(buf);
> diff --git a/transaction.c b/transaction.c
> index ad705728..33225002 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -165,9 +165,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>         BUG_ON(ret);
>  commit_tree:
>         ret = commit_tree_roots(trans, fs_info);
> -       BUG_ON(ret);
> +       if (ret)
> +               goto error;
>         ret = __commit_transaction(trans, root);
> -       BUG_ON(ret);
> +       if (ret)
> +               goto error;
>         write_ctree_super(trans, fs_info);
>         btrfs_finish_extent_commit(trans, fs_info->extent_root,
>                                    &fs_info->pinned_extents);
> @@ -177,6 +179,8 @@ commit_tree:
>         fs_info->running_transaction = NULL;
>         fs_info->last_trans_committed = transid;
>         return 0;
> +error:
> +       return ret;
>  }
>
>  void btrfs_abort_transaction(struct btrfs_trans_handle *trans, int error)
> --
> 2.13.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
