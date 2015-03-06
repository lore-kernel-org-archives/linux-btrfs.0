Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43368 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbbCFUBx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 15:01:53 -0500
Received: by labgf13 with SMTP id gf13so35285223lab.10
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 12:01:51 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1423685339-8278-3-git-send-email-jbacik@fb.com>
References: <1423685339-8278-1-git-send-email-jbacik@fb.com>
	<1423685339-8278-3-git-send-email-jbacik@fb.com>
Date: Fri, 6 Mar 2015 20:01:51 +0000
Message-ID: <CAL3q7H4w-BJ0wd0jdtGb2kG4buNpxZ1AzOMWLK_f2oAW9zktQg@mail.gmail.com>
Subject: Re: [PATCH 3/3] Btrfs: account for large extents with enospc
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 8:08 PM, Josef Bacik <jbacik@fb.com> wrote:
> On our gluster boxes we stream large tar balls of backups onto our fses.  With
> 160gb of ram this means we get really large contiguous ranges of dirty data, but
> the way our ENOSPC stuff works is that as long as it's contiguous we only hold
> metadata reservation for one extent.  The problem is we limit our extents to
> 128mb, so we'll end up with at least 800 extents so our enospc accounting is
> quite a bit lower than what we need.  To keep track of this make sure we
> increase outstanding_extents for every multiple of the max extent size so we can
> be sure to have enough reserved metadata space.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Hi Josef,

So this change causes the outstanding_extents to never decrease to
zero or stay with very large values due to underflow, causing warnings
such as the ones reported at
https://bugzilla.kernel.org/show_bug.cgi?id=94401 or the ASSERT() you
added to drop_outstanding_extent() when assertions are enabled.

It's very easy to reproduce this, like with the following fio job config:

  [global]
  ioengine=sync
  direct=1
  bssplit=130M/100
  fallocate=none
  fadvise_hint=0
  filename=foobar

  [job1]
  numjobs=1
  size=600M
  rw=randwrite

So the following happens:

1) btrfs_delalloc_reserve_metadata, num_bytes 136314880 (num_extents
2), outstanding extents == 0, incremented outstanding extents by 1
(and not num_extents)

2) btrfs_drop_outstanding_extent num_bytes 136314880 (num_extents 2),
outstanding extents == 1, decrement outstanding extents by 2
(num_extents) giving 4294967295

For buffered writes (by setting direct=0 in that fio job config),
outstanding_extents rarely gets decremented to 0, but I haven't
checked why exactly (extent state merges need to happen at least for
all the special cases in btrfs_merge_extent_hook).

thanks


> ---
>  fs/btrfs/ctree.h       |  2 ++
>  fs/btrfs/extent-tree.c | 16 +++++++++----
>  fs/btrfs/extent_io.c   |  2 +-
>  fs/btrfs/inode.c       | 63 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 76 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0b4683f..1675602 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -198,6 +198,8 @@ static int btrfs_csum_sizes[] = { 4, 0 };
>
>  #define BTRFS_DIRTY_METADATA_THRESH    (32 * 1024 * 1024)
>
> +#define BTRFS_MAX_EXTENT_SIZE (128 * 1024 * 1024)
> +
>  /*
>   * The key defines the order in the tree, and so it also defines (optimal)
>   * block layout.
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a346487..eb30b90 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4966,19 +4966,25 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
>  /**
>   * drop_outstanding_extent - drop an outstanding extent
>   * @inode: the inode we're dropping the extent for
> + * @num_bytes: the number of bytes we're relaseing.
>   *
>   * This is called when we are freeing up an outstanding extent, either called
>   * after an error or after an extent is written.  This will return the number of
>   * reserved extents that need to be freed.  This must be called with
>   * BTRFS_I(inode)->lock held.
>   */
> -static unsigned drop_outstanding_extent(struct inode *inode)
> +static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
>  {
>         unsigned drop_inode_space = 0;
>         unsigned dropped_extents = 0;
> +       unsigned num_extents = 0;
>
> -       BUG_ON(!BTRFS_I(inode)->outstanding_extents);
> -       BTRFS_I(inode)->outstanding_extents--;
> +       num_extents = (unsigned)div64_u64(num_bytes +
> +                                         BTRFS_MAX_EXTENT_SIZE - 1,
> +                                         BTRFS_MAX_EXTENT_SIZE);
> +       ASSERT(num_extents);
> +       ASSERT(BTRFS_I(inode)->outstanding_extents >= num_extents);
> +       BTRFS_I(inode)->outstanding_extents -= num_extents;
>
>         if (BTRFS_I(inode)->outstanding_extents == 0 &&
>             test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
> @@ -5149,7 +5155,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
>
>  out_fail:
>         spin_lock(&BTRFS_I(inode)->lock);
> -       dropped = drop_outstanding_extent(inode);
> +       dropped = drop_outstanding_extent(inode, num_bytes);
>         /*
>          * If the inodes csum_bytes is the same as the original
>          * csum_bytes then we know we haven't raced with any free()ers
> @@ -5228,7 +5234,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
>
>         num_bytes = ALIGN(num_bytes, root->sectorsize);
>         spin_lock(&BTRFS_I(inode)->lock);
> -       dropped = drop_outstanding_extent(inode);
> +       dropped = drop_outstanding_extent(inode, num_bytes);
>
>         if (num_bytes)
>                 to_free = calc_csum_metadata_size(inode, num_bytes, 0);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4ebabd2..3fbc177 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3239,7 +3239,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>                                                page,
>                                                &delalloc_start,
>                                                &delalloc_end,
> -                                              128 * 1024 * 1024);
> +                                              BTRFS_MAX_EXTENT_SIZE);
>                 if (nr_delalloc == 0) {
>                         delalloc_start = delalloc_end + 1;
>                         continue;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fb16fd3..4564975 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1530,10 +1530,45 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
>  static void btrfs_split_extent_hook(struct inode *inode,
>                                     struct extent_state *orig, u64 split)
>  {
> +       u64 size;
> +
>         /* not delalloc, ignore it */
>         if (!(orig->state & EXTENT_DELALLOC))
>                 return;
>
> +       size = orig->end - orig->start + 1;
> +       if (size > BTRFS_MAX_EXTENT_SIZE) {
> +               u64 num_extents;
> +               u64 new_size;
> +
> +               /*
> +                * We need the largest size of the remaining extent to see if we
> +                * need to add a new outstanding extent.  Think of the following
> +                * case
> +                *
> +                * [MEAX_EXTENT_SIZEx2 - 4k][4k]
> +                *
> +                * The new_size would just be 4k and we'd think we had enough
> +                * outstanding extents for this if we only took one side of the
> +                * split, same goes for the other direction.  We need to see if
> +                * the larger size still is the same amount of extents as the
> +                * original size, because if it is we need to add a new
> +                * outstanding extent.  But if we split up and the larger size
> +                * is less than the original then we are good to go since we've
> +                * already accounted for the extra extent in our original
> +                * accounting.
> +                */
> +               new_size = orig->end - split + 1;
> +               if ((split - orig->start) > new_size)
> +                       new_size = split - orig->start;
> +
> +               num_extents = div64_u64(size + BTRFS_MAX_EXTENT_SIZE - 1,
> +                                       BTRFS_MAX_EXTENT_SIZE);
> +               if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
> +                             BTRFS_MAX_EXTENT_SIZE) < num_extents)
> +                       return;
> +       }
> +
>         spin_lock(&BTRFS_I(inode)->lock);
>         BTRFS_I(inode)->outstanding_extents++;
>         spin_unlock(&BTRFS_I(inode)->lock);
> @@ -1549,10 +1584,34 @@ static void btrfs_merge_extent_hook(struct inode *inode,
>                                     struct extent_state *new,
>                                     struct extent_state *other)
>  {
> +       u64 new_size, old_size;
> +       u64 num_extents;
> +
>         /* not delalloc, ignore it */
>         if (!(other->state & EXTENT_DELALLOC))
>                 return;
>
> +       old_size = other->end - other->start + 1;
> +       new_size = old_size + (new->end - new->start + 1);
> +
> +       /* we're not bigger than the max, unreserve the space and go */
> +       if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
> +               spin_lock(&BTRFS_I(inode)->lock);
> +               BTRFS_I(inode)->outstanding_extents--;
> +               spin_unlock(&BTRFS_I(inode)->lock);
> +               return;
> +       }
> +
> +       /*
> +        * If we grew by another max_extent, just return, we want to keep that
> +        * reserved amount.
> +        */
> +       num_extents = div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
> +                               BTRFS_MAX_EXTENT_SIZE);
> +       if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
> +                     BTRFS_MAX_EXTENT_SIZE) > num_extents)
> +               return;
> +
>         spin_lock(&BTRFS_I(inode)->lock);
>         BTRFS_I(inode)->outstanding_extents--;
>         spin_unlock(&BTRFS_I(inode)->lock);
> @@ -1648,6 +1707,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
>                                  unsigned long *bits)
>  {
>         u64 len = state->end + 1 - state->start;
> +       u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE -1,
> +                                   BTRFS_MAX_EXTENT_SIZE);
>
>         spin_lock(&BTRFS_I(inode)->lock);
>         if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
> @@ -1667,7 +1728,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
>                         *bits &= ~EXTENT_FIRST_DELALLOC;
>                 } else if (!(*bits & EXTENT_DO_ACCOUNTING)) {
>                         spin_lock(&BTRFS_I(inode)->lock);
> -                       BTRFS_I(inode)->outstanding_extents--;
> +                       BTRFS_I(inode)->outstanding_extents -= num_extents;
>                         spin_unlock(&BTRFS_I(inode)->lock);
>                 }
>
> --
> 1.8.3.1
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
