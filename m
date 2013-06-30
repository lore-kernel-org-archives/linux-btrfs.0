Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3F3PC3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 11:02:29 -0400
Date: Sun, 30 Jun 2013 23:02:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
Message-ID: <20130630150208.GA11892@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372562251-27123-1-git-send-email-jbacik@fusionio.com>
 <51CFEB61.1040008@jan-o-sch.net>
 <20130630112200.GA4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130630112200.GA4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 07:22:00AM -0400, Josef Bacik wrote:
> On Sun, Jun 30, 2013 at 10:25:05AM +0200, Jan Schmidt wrote:
> > On 30.06.2013 05:17, Josef Bacik wrote:
> > > We need to hold the tree mod log lock in __tree_mod_log_rewind since we walk
> > > forward in the tree mod entries, otherwise we'll end up with random entries and
> > > trip the BUG_ON() at the front of __tree_mod_log_rewind.  This fixes the panics
> > > people were seeing when running
> > > 
> > > find /whatever -type f -exec btrfs fi defrag {} \;
> > 
> > This patch cannot help to solve the problem, as far as I've understood
> > what is going on. It does change timing, though, which presumably makes
> > it pass the current reproducer we're having.
> > 
> > On rewinding, iteration through the tree mod log rb-tree goes backwards
> > in time, which means that once we've found our staring point we cannot
> > be trapped by later additions. The old items we're rewinding towards
> > cannot be freed, because we've allocated a blocker element within the
> > tree and rewinding never goes beyond the allocated blocker. The blocker
> > element is allocated by btrfs_get_tree_mod_seq and mostly referred to as
> > time_seq within the other tree mod log functions in ctree.c. To sum up,
> > the added lock is not required.
> > 
> > The debug output I've analyzed so far shows that after we've rewinded
> > all REMOVE_WHILE_FREEING operations on a buffer, ordered consecutively
> > as expected, there comes another REMOVE_WHILE_FREEING with a sequence
> > number much further in the past for the same buffer (but that sequence
> > number is still higher than out time_seq rewind barrier at that point).
> > This must be a logical problem I've not completely understood so far,
> > but locking doesn't seem to be the right track.
> > 
> 
> So I've seen 2 scenarios with my debug output, once with my printk() which
> seemed to be unreliable and then again with trace_printk() which was much more
> reliable.
> 
> With the printk() output I saw what you described, however I was also printing
> out every mod we added and I never saw the sequence number allocated that we had
> suddenly tripped over, so I assumed that the printk() just got lost between the
> boxes (I was using netconsole to capture the output).  However if it was never
> actually allocated then it would make sense that we just pointed into some
> random peice of memory.
> 
> The second bit I saw which is when I was convinced this was the problem had us
> processing the keys, and suddenly we'd try to process the key again.  So I saw
> something like this (I lost the output because I was capturing the output into
> the same file again when I tried to reproduce with this patch so I don't have
> the exact output)
> 
> processing op 3, seq 10 slot 0
> processing op 3, seq 9 slot 1
> processing op 3, seq 8 slot 2
> processing op 3, seq 7 slot 3
> processing op 3, seq 6 slot 4
> processing op 3, seq 5 slot 5
> processing op 3, seq 8 slot 2
> 
> so we got an entry we had already processed, which is completely in line with
> the rb_tree pointing to something random when we do rb_next.
> 
> Now I had another theory early on, but I haven't seen output to confirm this.
> We can re-allocate a block if we've allocated it in the same transaction, and it
> appears this would completely screw up the tree mod log.  So say we allocate
> block 5, we add keys to it, and then we free it, so we get this
> MOVE_WHILE_FREEING thing done on the entire block, but then we re-allocate the
> same block and start doing normal operations to it.  Then we go to replay back
> and we will replay all the normal operations, but then we will walk into the
> REMOVE_WHILE_FREEING entries from when the block was free'd last and this will
> trigger the BUG_ON().  Now I hadn't actually had this happen so either it can't
> happen some how and I've missed the reasoning for it, or what I saw was just the
> rb_tree messup because we aren't locking it and what you are seeing is this
> particular case.  Either way I'm going to back my patch out and re-run a few
> more times with my trace_printk()'s so I can have several runs to look at and
> verify what I'm seeing.  Thanks,

I doubt the theory here, if we free a block, it's marked as pinned and
will then be marked as free only when we commit the transaction, isn't it?

- liubo
