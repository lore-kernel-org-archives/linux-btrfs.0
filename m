Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35916 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeEDBtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 May 2018 21:49:16 -0400
Received: by mail-ua0-f196.google.com with SMTP id b25so6428215uak.3
        for <linux-btrfs@vger.kernel.org>; Thu, 03 May 2018 18:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <1525261974-844-1-git-send-email-nborisov@suse.com>
 <27ea72e2-3967-1688-11aa-f54592c5e735@gmx.com> <108ff266-25e4-025b-a8c0-37284e6c7311@suse.com>
 <d8e743fa-03fe-9e1c-ea94-c57879725f37@gmx.com>
In-Reply-To: <d8e743fa-03fe-9e1c-ea94-c57879725f37@gmx.com>
From: Su Yue <damenly.su@gmail.com>
Date: Fri, 04 May 2018 01:49:04 +0000
Message-ID: <CABnRu54v3cuB-LU8xxERWW-E-t5XQUd=mM5PQBN4wzwR-Y_=sg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Use exclude_super_stripes instead of account_super_bytes
To: quwenruo.btrfs@gmx.com
Cc: nborisov@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com,
        osandov@fb.com, Su Yue <suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 2, 2018 at 9:15 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:



> On 2018年05月02日 20:49, Nikolay Borisov wrote:
> >
> >
> > On  2.05.2018 15:29, Qu Wenruo wrote:
> >>
> >>
> >> On 2018年05月02日 19:52, Nikolay Borisov wrote:
> >>> Originally commit 2681e00f00fe ("btrfs-progs: check for matchingi
> >>> free space in cache") added the account_super_bytes function to
prevent
> >>> false negative when running btrfs check. Turns out this function is
> >>> really copied exclude_super_stripes, excluding the calls to
> >>> exclude_super_stripes. Later commit e4797df6a9fa ("btrfs-progs: check
> >>> the free space tree in btrfsck") introduced proper version of
> >>> exclude_super_stripes. Instead of duplicating the function, just
remove
> >>> account_super_bytes and use exclude_super_stripes instead of the
former.
> >>> This also has the benefit of bringing the userspace code a bit closer
> >>> to the kernel counterpart.
> >>>
> >>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> >>
> >> Since these two functions are the same, it's completely fine to remove
one.
> >
> > As I mentioned, they are not "comlpetely" the same. The difference is
> > that exclude_super_stripes will mark the stripes as
> > EXTENT_UPTODATE in fs_info->pinned_extents via add_excluded_extent.
> > Dunno if this has any repercussions on functionality. I've run the progs
> > test suite and didn't observe any regressions. Also looking at the usage
> > of fs_info->pinned_extents didn't see anything conspicuous.

> Yeah, still same conclusion here.
> All pinned_extents usage I found is either really for pinned extents of
> current transaction (EXTENT_DIRTY) or this excluded usage
(EXTENT_UPTODATE).
> And unlike EXTENT_DIRTY, EXTENT_UPTODATE won't be removed after
> transaction commit, so if I didn't miss anything important, it should be
OK.

It seems related to extents of super block.

In btrfs-progs, every block group is cached by function cache_block_group().
This function calls remove_sb_from_cache() to exclude extents of SB in block
group from free space cache.
So, I think it should be OK too.

> Just adding Su for this, as he worked on pinning down tree blocks for
> lowmem mode extent init re-init, he may be more experienced in this field.

> Despite that, such abuse of EXTENT_* bits in different trees at least
> need extra comment for them later.

Agreed.  Kernel part has comments for those codes even they are simple.

Thanks,
Su

> Thanks,
> Qu

> >
> >>
> >> Reviewed-by: Qu Wenruo <wqu@suse.com>
> >>
> >> Thanks,
> >> Qu
> >>
> >>> ---
> >>>  extent-tree.c | 52
++--------------------------------------------------
> >>>  1 file changed, 2 insertions(+), 50 deletions(-)
> >>>
> >>> diff --git a/extent-tree.c b/extent-tree.c
> >>> index ea205ccf4c30..391f0a784710 100644
> >>> --- a/extent-tree.c
> >>> +++ b/extent-tree.c
> >>> @@ -3164,54 +3164,6 @@ static int find_first_block_group(struct
btrfs_root *root,
> >>>     return ret;
> >>>  }
> >>>
> >>> -static void account_super_bytes(struct btrfs_fs_info *fs_info,
> >>> -                           struct btrfs_block_group_cache *cache)
> >>> -{
> >>> -   u64 bytenr;
> >>> -   u64 *logical;
> >>> -   int stripe_len;
> >>> -   int i, nr, ret;
> >>> -
> >>> -   if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
> >>> -           stripe_len = BTRFS_SUPER_INFO_OFFSET -
cache->key.objectid;
> >>> -           cache->bytes_super += stripe_len;
> >>> -   }
> >>> -
> >>> -   for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> >>> -           bytenr = btrfs_sb_offset(i);
> >>> -           ret = btrfs_rmap_block(fs_info,
> >>> -                                  cache->key.objectid, bytenr,
> >>> -                                  0, &logical, &nr, &stripe_len);
> >>> -           if (ret)
> >>> -                   return;
> >>> -
> >>> -           while (nr--) {
> >>> -                   u64 start, len;
> >>> -
> >>> -                   if (logical[nr] > cache->key.objectid +
> >>> -                       cache->key.offset)
> >>> -                           continue;
> >>> -
> >>> -                   if (logical[nr] + stripe_len <=
cache->key.objectid)
> >>> -                           continue;
> >>> -
> >>> -                   start = logical[nr];
> >>> -                   if (start < cache->key.objectid) {
> >>> -                           start = cache->key.objectid;
> >>> -                           len = (logical[nr] + stripe_len) - start;
> >>> -                   } else {
> >>> -                           len = min_t(u64, stripe_len,
> >>> -                                       cache->key.objectid +
> >>> -                                       cache->key.offset - start);
> >>> -                   }
> >>> -
> >>> -                   cache->bytes_super += len;
> >>> -           }
> >>> -
> >>> -           kfree(logical);
> >>> -   }
> >>> -}
> >>> -
> >>>  int btrfs_read_block_groups(struct btrfs_root *root)
> >>>  {
> >>>     struct btrfs_path *path;
> >>> @@ -3287,7 +3239,7 @@ int btrfs_read_block_groups(struct btrfs_root
*root)
> >>>             if (btrfs_chunk_readonly(info, cache->key.objectid))
> >>>                     cache->ro = 1;
> >>>
> >>> -           account_super_bytes(info, cache);
> >>> +           exclude_super_stripes(root, cache);
> >>>
> >>>             ret = update_space_info(info, cache->flags,
found_key.offset,
> >>>
btrfs_block_group_used(&cache->item),
> >>> @@ -3331,7 +3283,7 @@ btrfs_add_block_group(struct btrfs_fs_info
*fs_info, u64 bytes_used, u64 type,
> >>>     cache->flags = type;
> >>>     btrfs_set_block_group_flags(&cache->item, type);
> >>>
> >>> -   account_super_bytes(fs_info, cache);
> >>> +   exclude_super_stripes(fs_info->extent_root, cache);
> >>>     ret = update_space_info(fs_info, cache->flags, size, bytes_used,
> >>>                             &cache->space_info);
> >>>     BUG_ON(ret);
> >>>
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
