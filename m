Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50669 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LPMQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 07:16:29 -0500
Received: by mail-bk0-f54.google.com with SMTP id v16so2308588bkz.13
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 04:16:28 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131216115711.GE30413@localhost.localdomain>
References: <1384900175-30031-1-git-send-email-fdmanana@gmail.com>
	<20131216092707.GB30413@localhost.localdomain>
	<CAL3q7H7w76wxgRmp_SkX974r+OAg37jJQyr26zm-hC7hA3R7QA@mail.gmail.com>
	<20131216114525.GD30413@localhost.localdomain>
	<CAL3q7H76FgxQM_h7Y4xiRuJC=YSfUqhYd=F4peWe+EodCOdh_A@mail.gmail.com>
	<20131216115711.GE30413@localhost.localdomain>
Date: Mon, 16 Dec 2013 12:16:28 +0000
Message-ID: <CAL3q7H6JepyQrYnMVaeo3asSrAsyvLGeg86O-SngFt5Y780umg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix very slow inode eviction and fs unmount
From: Filipe David Manana <fdmanana@gmail.com>
To: bo.li.liu@oracle.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 11:57 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Mon, Dec 16, 2013 at 11:48:08AM +0000, Filipe David Manana wrote:
>> On Mon, Dec 16, 2013 at 11:45 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > On Mon, Dec 16, 2013 at 11:05:31AM +0000, Filipe David Manana wrote:
>> >> On Mon, Dec 16, 2013 at 9:27 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> >> > On Tue, Nov 19, 2013 at 10:29:35PM +0000, Filipe David Borba Manana wrote:
>> >> >> The inode eviction can be very slow, because during eviction we
>> >> >> tell the VFS to truncate all of the inode's pages. This results
>> >> >> in calls to btrfs_invalidatepage() which in turn does calls to
>> >> >> lock_extent_bits() and clear_extent_bit(). These calls result in
>> >> >> too many merges and splits of extent_state structures, which
>> >> >> consume a lot of time and cpu when the inode has many pages. In
>> >> >> some scenarios I have experienced umount times higher than 15
>> >> >> minutes, even when there's no pending IO (after a btrfs fs sync).
>> >> >>
>> >> >> A quick way to reproduce this issue:
>> >> >>
>> >> >> $ mkfs.btrfs -f /dev/sdb3
>> >> >> $ mount /dev/sdb3 /mnt/btrfs
>> >> >> $ cd /mnt/btrfs
>> >> >> $ sysbench --test=fileio --file-num=128 --file-total-size=16G \
>> >> >>     --file-test-mode=seqwr --num-threads=128 \
>> >> >>     --file-block-size=16384 --max-time=60 --max-requests=0 run
>> >> >> $ time btrfs fi sync .
>> >> >> FSSync '.'
>> >> >>
>> >> >> real  0m25.457s
>> >> >> user  0m0.000s
>> >> >> sys   0m0.092s
>> >> >> $ cd ..
>> >> >> $ time umount /mnt/btrfs
>> >> >>
>> >> >> real  1m38.234s
>> >> >> user  0m0.000s
>> >> >> sys   1m25.760s
>> >> >>
>> >> >
>> >> > What about the time of umount after 'sync'?
>> >>
>> >> Same huge difference.
>> >> Thanks.
>> >
>> > Not seeing that huge one with the latest btrfs, maybe because your memory is
>> > rather larger.
>>
>> Not sure if I understand you.
>> Latest btrfs-next has this change integrated. Was the test below with
>> it integrated? You would have to compare it with a build without this
>> change.
>
> I'm testing the script with Chris's upstream repo, not btrfs-next, and umount
> is normal.
>
> It's possible that some patches merged in btrfs-next make umount's latency longer
> than expected.

The umount example was just a simple way to show inode eviction was
taking a long time not waiting for or doing IO.
And yes, my test was performed on a machine with a large amount of ram
(32Gb) compared to that tests total file size.

thanks

>
> thanks,
> -liubo
>
>>
>> Thanks.
>>
>> >
>> > time sync
>> > FSSync '/mnt/btrfs'
>> >
>> > real    0m17.006s
>> > user    0m0.004s
>> > sys     0m0.056s
>> >
>> > time umount /mnt/btrfs
>> >
>> > real    0m0.910s
>> > user    0m0.003s
>> > sys     0m0.715s
>> >
>> > -liubo
>> >
>> >>
>> >> >
>> >> > The following ext4 uses sync while btrfs uses 'btrfs filesystem sync'.
>> >> >
>> >> > I don't think they are the same thing.
>> >> >
>> >> > -liubo
>> >> >
>> >> >> The same test on ext4 runs much faster:
>> >> >>
>> >> >> $ mkfs.ext4 /dev/sdb3
>> >> >> $ mount /dev/sdb3 /mnt/ext4
>> >> >> $ cd /mnt/ext4
>> >> >> $ sysbench --test=fileio --file-num=128 --file-total-size=16G \
>> >> >>     --file-test-mode=seqwr --num-threads=128 \
>> >> >>     --file-block-size=16384 --max-time=60 --max-requests=0 run
>> >> >> $ sync
>> >> >> $ cd ..
>> >> >> $ time umount /mnt/ext4
>> >> >>
>> >> >> real  0m3.626s
>> >> >> user  0m0.004s
>> >> >> sys   0m3.012s
>> >> >>
>> >> >> After this patch, the unmount (inode evictions) is much faster:
>> >> >>
>> >> >> $ mkfs.btrfs -f /dev/sdb3
>> >> >> $ mount /dev/sdb3 /mnt/btrfs
>> >> >> $ cd /mnt/btrfs
>> >> >> $ sysbench --test=fileio --file-num=128 --file-total-size=16G \
>> >> >>     --file-test-mode=seqwr --num-threads=128 \
>> >> >>     --file-block-size=16384 --max-time=60 --max-requests=0 run
>> >> >> $ time btrfs fi sync .
>> >> >> FSSync '.'
>> >> >>
>> >> >> real  0m26.774s
>> >> >> user  0m0.000s
>> >> >> sys   0m0.084s
>> >> >> $ cd ..
>> >> >> $ time umount /mnt/btrfs
>> >> >>
>> >> >> real  0m1.811s
>> >> >> user  0m0.000s
>> >> >> sys   0m1.564s
>> >> >
>> >> >>
>> >> >> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> >> >> ---
>> >> >>  fs/btrfs/inode.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++--------
>> >> >>  1 file changed, 84 insertions(+), 14 deletions(-)
>> >> >>
>> >> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> >> >> index 5a5de36..e889779 100644
>> >> >> --- a/fs/btrfs/inode.c
>> >> >> +++ b/fs/btrfs/inode.c
>> >> >> @@ -4488,6 +4488,62 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
>> >> >>       return err;
>> >> >>  }
>> >> >>
>> >> >> +/*
>> >> >> + * While truncating the inode pages during eviction, we get the VFS calling
>> >> >> + * btrfs_invalidatepage() against each page of the inode. This is slow because
>> >> >> + * the calls to btrfs_invalidatepage() result in a huge amount of calls to
>> >> >> + * lock_extent_bits() and clear_extent_bit(), which keep merging and splitting
>> >> >> + * extent_state structures over and over, wasting lots of time.
>> >> >> + *
>> >> >> + * Therefore if the inode is being evicted, let btrfs_invalidatepage() skip all
>> >> >> + * those expensive operations on a per page basis and do only the ordered io
>> >> >> + * finishing, while we release here the extent_map and extent_state structures,
>> >> >> + * without the excessive merging and splitting.
>> >> >> + */
>> >> >> +static void evict_inode_truncate_pages(struct inode *inode)
>> >> >> +{
>> >> >> +     struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
>> >> >> +     struct extent_map_tree *map_tree = &BTRFS_I(inode)->extent_tree;
>> >> >> +     struct rb_node *node;
>> >> >> +
>> >> >> +     ASSERT(inode->i_state & I_FREEING);
>> >> >> +     truncate_inode_pages(&inode->i_data, 0);
>> >> >> +
>> >> >> +     write_lock(&map_tree->lock);
>> >> >> +     while (!RB_EMPTY_ROOT(&map_tree->map)) {
>> >> >> +             struct extent_map *em;
>> >> >> +
>> >> >> +             node = rb_first(&map_tree->map);
>> >> >> +             em = rb_entry(node, struct extent_map, rb_node);
>> >> >> +             remove_extent_mapping(map_tree, em);
>> >> >> +             free_extent_map(em);
>> >> >> +     }
>> >> >> +     write_unlock(&map_tree->lock);
>> >> >> +
>> >> >> +     spin_lock(&io_tree->lock);
>> >> >> +     while (!RB_EMPTY_ROOT(&io_tree->state)) {
>> >> >> +             struct extent_state *state;
>> >> >> +             struct extent_state *cached_state = NULL;
>> >> >> +
>> >> >> +             node = rb_first(&io_tree->state);
>> >> >> +             state = rb_entry(node, struct extent_state, rb_node);
>> >> >> +             atomic_inc(&state->refs);
>> >> >> +             spin_unlock(&io_tree->lock);
>> >> >> +
>> >> >> +             lock_extent_bits(io_tree, state->start, state->end,
>> >> >> +                              0, &cached_state);
>> >> >> +             clear_extent_bit(io_tree, state->start, state->end,
>> >> >> +                              EXTENT_LOCKED | EXTENT_DIRTY |
>> >> >> +                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
>> >> >> +                              EXTENT_DEFRAG, 1, 1,
>> >> >> +                              &cached_state, GFP_NOFS);
>> >> >> +             free_extent_state(state);
>> >> >> +
>> >> >> +             spin_lock(&io_tree->lock);
>> >> >> +     }
>> >> >> +     spin_unlock(&io_tree->lock);
>> >> >> +}
>> >> >> +
>> >> >>  void btrfs_evict_inode(struct inode *inode)
>> >> >>  {
>> >> >>       struct btrfs_trans_handle *trans;
>> >> >> @@ -4498,7 +4554,8 @@ void btrfs_evict_inode(struct inode *inode)
>> >> >>
>> >> >>       trace_btrfs_inode_evict(inode);
>> >> >>
>> >> >> -     truncate_inode_pages(&inode->i_data, 0);
>> >> >> +     evict_inode_truncate_pages(inode);
>> >> >> +
>> >> >>       if (inode->i_nlink &&
>> >> >>           ((btrfs_root_refs(&root->root_item) != 0 &&
>> >> >>             root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID) ||
>> >> >> @@ -7379,6 +7436,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
>> >> >>       struct extent_state *cached_state = NULL;
>> >> >>       u64 page_start = page_offset(page);
>> >> >>       u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
>> >> >> +     int inode_evicting = inode->i_state & I_FREEING;
>> >> >>
>> >> >>       /*
>> >> >>        * we have the page locked, so new writeback can't start,
>> >> >> @@ -7394,17 +7452,21 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
>> >> >>               btrfs_releasepage(page, GFP_NOFS);
>> >> >>               return;
>> >> >>       }
>> >> >> -     lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
>> >> >> -     ordered = btrfs_lookup_ordered_extent(inode, page_offset(page));
>> >> >> +
>> >> >> +     if (!inode_evicting)
>> >> >> +             lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
>> >> >> +     ordered = btrfs_lookup_ordered_extent(inode, page_start);
>> >> >>       if (ordered) {
>> >> >>               /*
>> >> >>                * IO on this page will never be started, so we need
>> >> >>                * to account for any ordered extents now
>> >> >>                */
>> >> >> -             clear_extent_bit(tree, page_start, page_end,
>> >> >> -                              EXTENT_DIRTY | EXTENT_DELALLOC |
>> >> >> -                              EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
>> >> >> -                              EXTENT_DEFRAG, 1, 0, &cached_state, GFP_NOFS);
>> >> >> +             if (!inode_evicting)
>> >> >> +                     clear_extent_bit(tree, page_start, page_end,
>> >> >> +                                      EXTENT_DIRTY | EXTENT_DELALLOC |
>> >> >> +                                      EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
>> >> >> +                                      EXTENT_DEFRAG, 1, 0, &cached_state,
>> >> >> +                                      GFP_NOFS);
>> >> >>               /*
>> >> >>                * whoever cleared the private bit is responsible
>> >> >>                * for the finish_ordered_io
>> >> >> @@ -7428,14 +7490,22 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
>> >> >>                               btrfs_finish_ordered_io(ordered);
>> >> >>               }
>> >> >>               btrfs_put_ordered_extent(ordered);
>> >> >> -             cached_state = NULL;
>> >> >> -             lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
>> >> >> +             if (!inode_evicting) {
>> >> >> +                     cached_state = NULL;
>> >> >> +                     lock_extent_bits(tree, page_start, page_end, 0,
>> >> >> +                                      &cached_state);
>> >> >> +             }
>> >> >> +     }
>> >> >> +
>> >> >> +     if (!inode_evicting) {
>> >> >> +             clear_extent_bit(tree, page_start, page_end,
>> >> >> +                              EXTENT_LOCKED | EXTENT_DIRTY |
>> >> >> +                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
>> >> >> +                              EXTENT_DEFRAG, 1, 1,
>> >> >> +                              &cached_state, GFP_NOFS);
>> >> >> +
>> >> >> +             __btrfs_releasepage(page, GFP_NOFS);
>> >> >>       }
>> >> >> -     clear_extent_bit(tree, page_start, page_end,
>> >> >> -              EXTENT_LOCKED | EXTENT_DIRTY | EXTENT_DELALLOC |
>> >> >> -              EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 1, 1,
>> >> >> -              &cached_state, GFP_NOFS);
>> >> >> -     __btrfs_releasepage(page, GFP_NOFS);
>> >> >>
>> >> >>       ClearPageChecked(page);
>> >> >>       if (PagePrivate(page)) {
>> >> >> --
>> >> >> 1.7.9.5
>> >> >>
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >>
>> >>
>> >> --
>> >> Filipe David Manana,
>> >>
>> >> "Reasonable men adapt themselves to the world.
>> >>  Unreasonable men adapt the world to themselves.
>> >>  That's why all progress depends on unreasonable men."
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
