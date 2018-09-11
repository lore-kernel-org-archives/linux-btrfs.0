Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:45809 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727007AbeIKXc2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 19:32:28 -0400
Date: Tue, 11 Sep 2018 11:31:49 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
Message-ID: <20180911183148.ji5rq2aca7mzxjep@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180911153403.GF2997@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911153403.GF2997@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 05:34:03PM +0200, David Sterba wrote:
> On Thu, Aug 23, 2018 at 03:51:48AM +0800, Liu Bo wrote:
> > Several structs in btrfs are using rb_first() in a while loop, it'd be
> > more efficient to do this with rb_first_cached() which has the O(1)
> > complexity.
> 
> We'd like to see some numbers, though just by reading the code I think
> there's going to be a noticeable improvement for some workloads.
> 
> There's a common pattern:
> 
> while(node = rb_first) {
> 	entry = rb_entry(node)
> 	next = rb_next(node)
> 	rb_erase(node)
> 	cleanup(entry)
> }
> 
> rb_first needs to traverse the tree up to logN depth, rb_erase can
> completely reshuffle the tree. With the caching we'll skip the traversal
> in rb_first. That's a cached memory access vs looped pointer
> dereference trade-off that IMHO has a clear winner.
> 
> As the pattern in many cases traverses the whole tree and removes all
> entries, ideally we could get rid of the rebalancing too. The entries
> would be cleaned up in postorder way, ie. reset the data and kfree in
> the end. This requires that order of the freeing does not matter, which
> might no apply to some trees.

The order of freeing does not matter, but we need the tree to return
the correct next node to free, IOW, we have to maintain the rbtree
until the last two nodes.

> 
> I did not find suitable rbtree functions or helpers for that,
> rbtree_postorder_for_each_entry_safe does not allow rb_erase and
> rb_erase itself forces the rebalancing internally. But I think we can
> implement that.
> 
> We could possibly use rb_next_postorder that makes sure that all
> children are traversed before the parent so this is at least something
> that could considerd.
> 

Qu was inquiring about the same thing, I haven't got time to dig it
further.

The question we need to answer is that whether we care about how fast
destruction can make, as some are in critical paths while some are
not.

thanks,
-liubo

> In cases where the order of rbnode processing must be preserved, ie. the
> rb_erase must be there, the cached rb tree is all we can do.
