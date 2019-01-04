Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B40C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A84621871
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfADP7j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:59:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:60834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727192AbfADP7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:59:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DCCCAE55;
        Fri,  4 Jan 2019 15:59:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11AC0DA7CE; Fri,  4 Jan 2019 16:59:06 +0100 (CET)
Date:   Fri, 4 Jan 2019 16:59:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     ethanlien <ethanlien@synology.com>
Cc:     Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Message-ID: <20190104155905.GT23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, ethanlien <ethanlien@synology.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <69f3dbc8d8b5a3d6554d8133ba81a80b@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69f3dbc8d8b5a3d6554d8133ba81a80b@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 04:38:48PM +0800, ethanlien wrote:
> Chris Mason 於 2018-12-12 22:47 寫到:
> > On 28 May 2018, at 1:48, Ethan Lien wrote:
> > 
> > It took me a while to trigger, but this actually deadlocks ;)  More
> > below.
> > 
> >> [Problem description and how we fix it]
> >> We should balance dirty metadata pages at the end of
> >> btrfs_finish_ordered_io, since a small, unmergeable random write can
> >> potentially produce dirty metadata which is multiple times larger than
> >> the data itself. For example, a small, unmergeable 4KiB write may
> >> produce:
> >> 
> >>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
> >>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
> >>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
> >> 
> >> Although we do call balance dirty pages in write side, but in the
> >> buffered write path, most metadata are dirtied only after we reach the
> >> dirty background limit (which by far only counts dirty data pages) and
> >> wakeup the flusher thread. If there are many small, unmergeable random
> >> writes spread in a large btree, we'll find a burst of dirty pages
> >> exceeds the dirty_bytes limit after we wakeup the flusher thread -
> >> which
> >> is not what we expect. In our machine, it caused out-of-memory problem
> >> since a page cannot be dropped if it is marked dirty.
> >> 
> >> Someone may worry about we may sleep in
> >> btrfs_btree_balance_dirty_nodelay,
> >> but since we do btrfs_finish_ordered_io in a separate worker, it will
> >> not
> >> stop the flusher consuming dirty pages. Also, we use different worker
> >> for
> >> metadata writeback endio, sleep in btrfs_finish_ordered_io help us
> >> throttle
> >> the size of dirty metadata pages.
> > 
> > In general, slowing down btrfs_finish_ordered_io isn't ideal because it
> > adds latency to places we need to finish quickly.  Also,
> > btrfs_finish_ordered_io is used by the free space cache.  Even though
> > this happens from its own workqueue, it means completing free space
> > cache writeback may end up waiting on balance_dirty_pages, something
> > like this stack trace:
> > 
> > 12260 kworker/u96:16+btrfs-freespace-write D
> > [<0>] balance_dirty_pages+0x6e6/0x7ad
> > [<0>] balance_dirty_pages_ratelimited+0x6bb/0xa90
> > [<0>] btrfs_finish_ordered_io+0x3da/0x770
> > [<0>] normal_work_helper+0x1c5/0x5a0
> > [<0>] process_one_work+0x1ee/0x5a0
> > [<0>] worker_thread+0x46/0x3d0
> > [<0>] kthread+0xf5/0x130
> > [<0>] ret_from_fork+0x24/0x30
> > [<0>] 0xffffffffffffffff
> > 
> > Transaction commit will wait on the freespace cache:
> > 
> > 838 btrfs-transacti D
> > [<0>] btrfs_start_ordered_extent+0x154/0x1e0
> > [<0>] btrfs_wait_ordered_range+0xbd/0x110
> > [<0>] __btrfs_wait_cache_io+0x49/0x1a0
> > [<0>] btrfs_write_dirty_block_groups+0x10b/0x3b0
> > [<0>] commit_cowonly_roots+0x215/0x2b0
> > [<0>] btrfs_commit_transaction+0x37e/0x910
> > [<0>] transaction_kthread+0x14d/0x180
> > [<0>] kthread+0xf5/0x130
> > [<0>] ret_from_fork+0x24/0x30
> > [<0>] 0xffffffffffffffff
> > 
> > And then writepages ends up waiting on transaction commit:
> > 
> > 9520 kworker/u96:13+flush-btrfs-1 D
> > [<0>] wait_current_trans+0xac/0xe0
> > [<0>] start_transaction+0x21b/0x4b0
> > [<0>] cow_file_range_inline+0x10b/0x6b0
> > [<0>] cow_file_range.isra.69+0x329/0x4a0
> > [<0>] run_delalloc_range+0x105/0x3c0
> > [<0>] writepage_delalloc+0x119/0x180
> > [<0>] __extent_writepage+0x10c/0x390
> > [<0>] extent_write_cache_pages+0x26f/0x3d0
> > [<0>] extent_writepages+0x4f/0x80
> > [<0>] do_writepages+0x17/0x60
> > [<0>] __writeback_single_inode+0x59/0x690
> > [<0>] writeback_sb_inodes+0x291/0x4e0
> > [<0>] __writeback_inodes_wb+0x87/0xb0
> > [<0>] wb_writeback+0x3bb/0x500
> > [<0>] wb_workfn+0x40d/0x610
> > [<0>] process_one_work+0x1ee/0x5a0
> > [<0>] worker_thread+0x1e0/0x3d0
> > [<0>] kthread+0xf5/0x130
> > [<0>] ret_from_fork+0x24/0x30
> > [<0>] 0xffffffffffffffff
> > 
> > Eventually, we have every process in the system waiting on
> > balance_dirty_pages(), and nobody is able to make progress on page
> > writeback.
> > 
> >> 
> >> [Reproduce steps]
> > 
> > [ ... ]
> > 
> >> 
> >> V2:
> >> 	Replace btrfs_btree_balance_dirty with
> >> btrfs_btree_balance_dirty_nodelay.
> >> 	Add reproduce steps.
> >> 
> >>  fs/btrfs/inode.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index 8e604e7071f1..e54547df24ee 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -3158,6 +3158,8 @@ static int btrfs_finish_ordered_io(struct
> >> btrfs_ordered_extent *ordered_extent)
> >>  	/* once for the tree */
> >>  	btrfs_put_ordered_extent(ordered_extent);
> >> 
> >> +	btrfs_btree_balance_dirty_nodelay(fs_info);
> >> +
> >>  	return ret;
> >>  }
> > 
> > 
> > The original OOM you describe feels like an MM bug to me, but I'm going
> > to try the repro steps here.  Since the freespace cache has its own
> > workqueue, we could fix the deadlock just by wrapping the
> > balance_dirty_pages call in a check for the freespace inode.  But, I
> > think we'll get better performance by nudging the fix outside of
> > btrfs_finish_ordered_io.  I'll see if I can reproduce.
> 
> Before this patch, I tried adding a new workqueue for metadata 
> writeback,
> and kick off async flush work on fs_info->btree_inode in
> btrfs_finish_ordered_io(). It works, but it can't guarantee we control 
> dirty
> pages under MM's dirty_bytes limit if btrfs_finish_ordered_io() still 
> running
> at full speed.
> 
> > I haven't been able to trigger the OOM this morning.  Ethan, is this
> > something you can still hit on upstream kernels with the
> > balance_dirty_pages() removed?
> 
> I hit the OOM problem in 4.4 kernel. I'll try if I can trigger it in 
> uptodate kernel.

Any followup to your testing? Otherwise I'm going to add revert of the
patch.
