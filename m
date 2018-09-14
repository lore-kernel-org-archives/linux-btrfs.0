Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40064 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbeIOAax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 20:30:53 -0400
Date: Fri, 14 Sep 2018 12:14:57 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
Message-ID: <20180914191456.4whx5gyjtg5hwbtt@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180911153403.GF2997@twin.jikos.cz>
 <20180911183148.ji5rq2aca7mzxjep@US-160370MP2.local>
 <20180914151102.GM5847@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180914151102.GM5847@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 05:11:02PM +0200, David Sterba wrote:
> On Tue, Sep 11, 2018 at 11:31:49AM -0700, Liu Bo wrote:
> > On Tue, Sep 11, 2018 at 05:34:03PM +0200, David Sterba wrote:
> > > On Thu, Aug 23, 2018 at 03:51:48AM +0800, Liu Bo wrote:
> > > > Several structs in btrfs are using rb_first() in a while loop, it'd be
> > > > more efficient to do this with rb_first_cached() which has the O(1)
> > > > complexity.
> > > 
> > > We'd like to see some numbers, though just by reading the code I think
> > > there's going to be a noticeable improvement for some workloads.
> > > 
> > > There's a common pattern:
> > > 
> > > while(node = rb_first) {
> > > 	entry = rb_entry(node)
> > > 	next = rb_next(node)
> > > 	rb_erase(node)
> > > 	cleanup(entry)
> > > }
> > > 
> > > rb_first needs to traverse the tree up to logN depth, rb_erase can
> > > completely reshuffle the tree. With the caching we'll skip the traversal
> > > in rb_first. That's a cached memory access vs looped pointer
> > > dereference trade-off that IMHO has a clear winner.
> > > 
> > > As the pattern in many cases traverses the whole tree and removes all
> > > entries, ideally we could get rid of the rebalancing too. The entries
> > > would be cleaned up in postorder way, ie. reset the data and kfree in
> > > the end. This requires that order of the freeing does not matter, which
> > > might no apply to some trees.
> > 
> > The order of freeing does not matter, but we need the tree to return
> > the correct next node to free, IOW, we have to maintain the rbtree
> > until the last two nodes.
> > 
> > > 
> > > I did not find suitable rbtree functions or helpers for that,
> > > rbtree_postorder_for_each_entry_safe does not allow rb_erase and
> > > rb_erase itself forces the rebalancing internally. But I think we can
> > > implement that.
> > > 
> > > We could possibly use rb_next_postorder that makes sure that all
> > > children are traversed before the parent so this is at least something
> > > that could considerd.
> > > 
> > 
> > Qu was inquiring about the same thing, I haven't got time to dig it
> > further.
> > 
> > The question we need to answer is that whether we care about how fast
> > destruction can make, as some are in critical paths while some are
> > not.
> 
> Yeah, I take __btrfs_return_cluster_to_free_space as an example where
> the more efficient tree destruction would shorten the time where a lock
> is held.
> 
> In other cases it might complicate the code too much, though the
> performance is not critical, eg. at umount time. Although, it'd be good
> to optimize that too now that we know how.
> 
> And in the remaining cases it's not possible to avoid rb_erase. I had a
> closer look at btrfs_cleanup_defrag_inodes and btrfs_put_tree_mod_seq.
> Based on that I'd like to add this series to for-next, the first node
> caching is clear enough and safe. We can do the other optimizations
> later.

This needs more fine-grained debugging to see what's the cost
lies on.

About the perf. number of rb_cached_node, I measured the time spent in
extent map loop in btrfs_evict_inode(),

evict_inode_truncate_pages()
    while (!RB_EMPTY_ROOT(&map_tree->map)) {
         rb_first();
	 rb_erase();
    }


for a em tree containing 10,000 em,
- with rb_first_cached, the loop takes 4880454 ns,
- with rb_first, the loop takes 4584148 ns,

looks like the difference is not that much, ~6%.  After all it's about
scalability, the more rb tree gets, the more rb_first_cached() wins.

thanks,
-liubo
