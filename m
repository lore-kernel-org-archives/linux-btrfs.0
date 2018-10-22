Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8E5C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1401720645
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nK8Zn583"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1401720645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbeJWDaf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 23:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbeJWDaf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:30:35 -0400
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C0B20664
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 19:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540235450;
        bh=/1yLtTU8mT0mlmlLBKGaDDkO+ynP8lLHXy9xstnXqq0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nK8Zn583+PLR+l2uEEZsfa7++k5Ken//HG3TkvLLXZ1y1TqFCH217Ms2412lHpKpS
         2Qth+gOHY6SNcwVednZHLqS4/LNmZ32j3KI1hugPZubTcySddj5aW+TW0Dore1iRw3
         tEczG6rn3FbZ7ieDAnij4UXawm2uU19wrhioHU5o=
Received: by mail-vs1-f53.google.com with SMTP id e126so30340487vsc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 12:10:48 -0700 (PDT)
X-Gm-Message-State: ABuFfoh8ueAycKltdSWNDJE884RdBWqhXj7qA0ZgWanRd+atZgaHHlel
        8//sgkohJ7Hon8+ZZLIxfcqVOdwZTuJqpXa9KTM=
X-Google-Smtp-Source: ACcGV60gOpJv93FPUKIr+CT9m9ySPGeukGcCwliauNDm1H4otlOBqAD/u6r0JZJEUlMN7kPfJFSsLoFKeZcXtAHEfv8=
X-Received: by 2002:a67:8a88:: with SMTP id m130mr19658734vsd.206.1540235447827;
 Mon, 22 Oct 2018 12:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181022184830.415-1-fdmanana@kernel.org>
 <20181022185556.2bfuoijklvsdyzx6@destiny>
In-Reply-To: <20181022185556.2bfuoijklvsdyzx6@destiny>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 22 Oct 2018 20:10:36 +0100
X-Gmail-Original-Message-ID: <CAL3q7H53va+39Xbf1JLSzhvmqP3wsSodfNMUReQY6-NpWBKBOA@mail.gmail.com>
Message-ID: <CAL3q7H53va+39Xbf1JLSzhvmqP3wsSodfNMUReQY6-NpWBKBOA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock on tree root leaf when finding
 free extent
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 7:56 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On Mon, Oct 22, 2018 at 07:48:30PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When we are writing out a free space cache, during the transaction commit
> > phase, we can end up in a deadlock which results in a stack trace like the
> > following:
> >
> >  schedule+0x28/0x80
> >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> >  ? finish_wait+0x80/0x80
> >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> >  ? inode_insert5+0x119/0x190
> >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> >  ? kmem_cache_alloc+0x166/0x1d0
> >  btrfs_iget+0x113/0x690 [btrfs]
> >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> >  load_free_space_cache+0x7c/0x170 [btrfs]
> >  ? cache_block_group+0x72/0x3b0 [btrfs]
> >  cache_block_group+0x1b3/0x3b0 [btrfs]
> >  ? finish_wait+0x80/0x80
> >  find_free_extent+0x799/0x1010 [btrfs]
> >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> >  btrfs_cow_block+0xdc/0x180 [btrfs]
> >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> >  ? kmem_cache_alloc+0x166/0x1d0
> >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> >  cache_save_setup+0xe4/0x3a0 [btrfs]
> >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> >
> > At cache_save_setup() we need to update the inode item of a block group's
> > cache which is located in the tree root (fs_info->tree_root), which means
> > that it may result in COWing a leaf from that tree. If that happens we
> > need to find a free metadata extent and while looking for one, if we find
> > a block group which was not cached yet we attempt to load its cache by
> > calling cache_block_group(). However this function will try to load the
> > inode of the free space cache, which requires finding the matching inode
> > item in the tree root - if that inode item is located in the same leaf as
> > the inode item of the space cache we are updating at cache_save_setup(),
> > we end up in a deadlock, since we try to obtain a read lock on the same
> > extent buffer that we previously write locked.
> >
> > So fix this by skipping the loading of free space caches of any block
> > groups that are not yet cached (rare cases) if we are COWing an extent
> > buffer from the root tree and space caching is enabled (-o space_cache
> > mount option). This is a rare case and its downside is failure to
> > find a free extent (return -ENOSPC) when all the already cached block
> > groups have no free extents.
> >
> > Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> > Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> > Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Made the solution more generic, since the problem could happen in any
> >     path COWing an extent buffer from the root tree.
> >
> >     Applies on top of a previous patch titled:
> >
> >      "Btrfs: fix deadlock when writing out free space caches"
> >
> >  fs/btrfs/ctree.c       |  4 ++++
> >  fs/btrfs/ctree.h       |  3 +++
> >  fs/btrfs/disk-io.c     |  2 ++
> >  fs/btrfs/extent-tree.c | 15 ++++++++++++++-
> >  4 files changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 089b46c4d97f..646aafda55a3 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1065,10 +1065,14 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
> >           root == fs_info->chunk_root ||
> >           root == fs_info->dev_root)
> >               trans->can_flush_pending_bgs = false;
> > +     else if (root == fs_info->tree_root)
> > +             atomic_inc(&fs_info->tree_root_cows);
> >
> >       cow = btrfs_alloc_tree_block(trans, root, parent_start,
> >                       root->root_key.objectid, &disk_key, level,
> >                       search_start, empty_size);
> > +     if (root == fs_info->tree_root)
> > +             atomic_dec(&fs_info->tree_root_cows);
>
> Do we need this though?  Our root should be the root we're cow'ing the block
> for, and it should be passed all the way down to find_free_extent properly, so
> we really should be able to just do if (root == fs_info->tree_root) and not add
> all this stuff.

Ups, I missed that we could actually pass the root down to find_free_extent().
That's why made the atomic thing.

Sending v3, thanks.

>
> Not to mention this will race with anybody else doing stuff, so if another
> thread that isn't actually touching the tree_root it would skip caching a block
> group when it's completely ok for that thread to do it.  Thanks,
>
> Josef
