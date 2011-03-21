From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Mon, 21 Mar 2011 08:08:17 -0400
Message-ID: <1300709085-sup-9849@think>
References: <4D8324DE.4010400@cn.fujitsu.com> <1300666966-sup-3510@think> <4D86DC92.40608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D86DC92.40608@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-03-21 01:05:22 -0400:
> On sun, 20 Mar 2011 20:33:34 -0400, Chris Mason wrote:
> > Excerpts from Miao Xie's message of 2011-03-18 05:24:46 -0400:
> >> Changelog V3 -> V4:
> >> - Fix nested lock, which is reported by Itaru Kitayama, by updating space cache
> >>   inodes in time.
> > 
> > I ran some tests on this and had trouble with my stress.sh script:
> > 
> > http://oss.oracle.com/~mason/stress.sh
> > 
> > I used:
> > 
> > stress.sh -n 50 -c <path to linux kernel git tree> /mnt
> > 
> > The git tree has all the .git files but no .o files.
> > 
> > The problem was that within about 20 minutes, the filesystem was
> > spending almost all of its time in balance_dirty_pages().  The problem
> > is that data writeback isn't complete until the endio handlers have
> > finished inserting metadata into the btree.
> > 
> > The v4 patch calls btrfs_btree_balance_dirty() from all the
> > btrfs_end_transaction variants, which means that the FS writeback code
> > waits for balance_dirty_pages(), which won't make progress until the FS
> > writeback code is done.
> > 
> > So I changed things to call the delayed inode balance function only from
> > inside btrfs_btree_balance_dirty(), which did resolve the stalls.  But
> 
> Ok, but can we invoke the delayed inode balance function before
> balance_dirty_pages_ratelimited_nr(), because the delayed item insertion and
> deletion also bring us some dirty pages.

Yes, good point.

> 
> > I found a few times that when I did rmmod btrfs, there would be delayed
> > inode objects leaked in the slab cache.  rmmod will try to destroy the
> > slab cache, which will fail because we haven't freed everything.
> > 
> > It looks like we have a race in btrfs_get_or_create_delayed_node, where
> > two concurrent callers can both create delayed nodes and then race on
> > adding it to the inode.
> 
> Sorry for my mistake, I thought we updated the inodes when holding i_mutex originally,
> so I didn't use any lock or other method to protect delayed_node of the inodes.
> 
> But I think we needn't use rcu lock to protect delayed_node when we want to get the
> delayed node, because we won't change it after it is created, cmpxchg() and ACCESS_ONCE()
> can protect it well. What do you think about?
> 
> PS: I worry about the inode update without holding i_mutex.

We have the tree locks to make sure we're serialized while we actually
change the tree.  The only places that go in without locking are times
updates.

> 
> > I also think that code is racing with the code that frees delayed nodes,
> > but haven't yet triggered my debugging printks to prove either one.
> 
> We free delayed nodes when we want to destroy the inode, at that time, just one task,
> which is destroying inode, can access the delayed nodes, so I think ACCESS_ONCE() is
> enough. What do you think about?

Great, I see what you mean.  The bigger problem right now is that we may do
a lot of operations in destroy_inode(), which can block the slab
shrinkers on our metadata operations.  That same stress.sh -n 50 run is
running into OOM.

So we need to rework the part where the final free is done.  We could
keep a ref on the inode until the delayed items are complete, or we
could let the inode go and make a way to lookup the delayed node when
the inode is read.

I'll read more today.

-chris
