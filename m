Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:62939 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbaIRNQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 09:16:15 -0400
Received: by mail-la0-f53.google.com with SMTP id ge10so1087260lab.26
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 06:16:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1410926015-26820-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1410926015-26820-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Thu, 18 Sep 2014 14:16:14 +0100
Message-ID: <CAL3q7H4Nqof4dhZCxDsOPyB116RGtSgLCUuDoxahEOsFHzo9UQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to insert
 best fitted extent map
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 17, 2014 at 4:53 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> The following commit enhanced the merge_extent_mapping() to reduce
> fragment in extent map tree, but it can't handle case which existing
> lies before map_start:
> 51f39 btrfs: Use right extent length when inserting overlap extent map.
>
> [BUG]
> When existing extent map's start is before map_start,
> the em->len will be minus, which will corrupt the extent map and fail to
> insert the new extent map.
> This will happen when someone get a large extent map, but when it is
> going to insert it into extent map tree, some one has already commit
> some write and split the huge extent into small parts.

This sounds like very deterministic to me.
Any reason to not add tests to the sanity tests that exercise
this/these case/cases?

Thanks

>
> [REPRODUCER]
> It is very easy to tiger using filebench with randomrw personality.
> It is about 100% to reproduce when using 8G preallocated file in 60s
> randonrw test.
>
> [FIX]
> This patch can now handle any existing extent position.
> Since it does not directly use existing->start, now it will find the
> previous and next extent around map_start.
> So the old existing->start < map_start bug will never happen again.
>
> [ENHANCE]
> This patch will insert the best fitted extent map into extent map tree,
> other than the oldest [map_start, map_start + sectorsize) or the
> relatively newer but not perfect [map_start, existing->start).
>
> The patch will first search existing extent that does not intersects with
> the desired map range [map_start, map_start + len).
> The existing extent will be either before or behind map_start, and based
> on the existing extent, we can find out the previous and next extent
> around map_start.
>
> So the best fitted extent would be [prev->end, next->start).
> For prev or next is not found, em->start would be prev->end and em->end
> wold be next->start.
>
> With this patch, the fragment in extent map tree should be reduced much
> more than the 51f39 commit and reduce an unneeded extent map tree search.
>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 79 ++++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 57 insertions(+), 22 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 016c403..8039021 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6191,21 +6191,60 @@ out_fail_inode:
>         goto out_fail;
>  }
>
> +/* Find next extent map of a given extent map, caller needs to ensure locks */
> +static struct extent_map *next_extent_map(struct extent_map *em)
> +{
> +       struct rb_node *next;
> +
> +       next = rb_next(&em->rb_node);
> +       if (!next)
> +               return NULL;
> +       return container_of(next, struct extent_map, rb_node);
> +}
> +
> +static struct extent_map *prev_extent_map(struct extent_map *em)
> +{
> +       struct rb_node *prev;
> +
> +       prev = rb_prev(&em->rb_node);
> +       if (!prev)
> +               return NULL;
> +       return container_of(prev, struct extent_map, rb_node);
> +}
> +
>  /* helper for btfs_get_extent.  Given an existing extent in the tree,
> + * the existing extent is the nearest extent to map_start,
>   * and an extent that you want to insert, deal with overlap and insert
> - * the new extent into the tree.
> + * the best fitted new extent into the tree.
>   */
>  static int merge_extent_mapping(struct extent_map_tree *em_tree,
>                                 struct extent_map *existing,
>                                 struct extent_map *em,
>                                 u64 map_start)
>  {
> +       struct extent_map *prev;
> +       struct extent_map *next;
> +       u64 start;
> +       u64 end;
>         u64 start_diff;
>
>         BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
> -       start_diff = map_start - em->start;
> -       em->start = map_start;
> -       em->len = existing->start - em->start;
> +
> +       if (existing->start > map_start) {
> +               next = existing;
> +               prev = prev_extent_map(next);
> +       } else {
> +               prev = existing;
> +               next = next_extent_map(prev);
> +       }
> +
> +       start = prev ? extent_map_end(prev) : em->start;
> +       start = max_t(u64, start, em->start);
> +       end = next ? next->start : extent_map_end(em);
> +       end = min_t(u64, end, extent_map_end(em));
> +       start_diff = start - em->start;
> +       em->start = start;
> +       em->len = end - start;
>         if (em->block_start < EXTENT_MAP_LAST_BYTE &&
>             !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
>                 em->block_start += start_diff;
> @@ -6482,25 +6521,21 @@ insert:
>
>                 ret = 0;
>
> -               existing = lookup_extent_mapping(em_tree, start, len);
> -               if (existing && (existing->start > start ||
> -                   existing->start + existing->len <= start)) {
> +               existing = search_extent_mapping(em_tree, start, len);
> +               /*
> +                * existing will always be non-NULL, since there must be
> +                * extent causing the -EEXIST.
> +                */
> +               if (start >= extent_map_end(existing) ||
> +                   start + len <= existing->start) {
> +                       /*
> +                        * The existing extent map is the one nearest to
> +                        * the [start, start + len) range which overlaps
> +                        */
> +                       err = merge_extent_mapping(em_tree, existing,
> +                                                  em, start);
>                         free_extent_map(existing);
> -                       existing = NULL;
> -               }
> -               if (!existing) {
> -                       existing = lookup_extent_mapping(em_tree, em->start,
> -                                                        em->len);
> -                       if (existing) {
> -                               err = merge_extent_mapping(em_tree, existing,
> -                                                          em, start);
> -                               free_extent_map(existing);
> -                               if (err) {
> -                                       free_extent_map(em);
> -                                       em = NULL;
> -                               }
> -                       } else {
> -                               err = -EIO;
> +                       if (err) {
>                                 free_extent_map(em);
>                                 em = NULL;
>                         }
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
