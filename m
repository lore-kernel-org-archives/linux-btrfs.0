Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40865 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3EPMFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 08:05:44 -0400
Date: Thu, 16 May 2013 20:05:20 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: Re: [PATCH 06/17] Btrfs: introduce grab/put functions for the root
 of the fs/file tree
Message-ID: <20130516120519.GK20202@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
 <1368604111-25073-7-git-send-email-miaox@cn.fujitsu.com>
 <20130516033645.GF20202@liubo.jp.oracle.com>
 <5194610F.1000603@cn.fujitsu.com>
 <20130516051556.GH20202@liubo.jp.oracle.com>
 <51946FD3.5000008@cn.fujitsu.com>
 <20130516061552.GI20202@liubo.jp.oracle.com>
 <5194893D.90505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5194893D.90505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 16, 2013 at 03:22:37PM +0800, Miao Xie wrote:
> On thu, 16 May 2013 14:15:52 +0800, Liu Bo wrote:
> > On Thu, May 16, 2013 at 01:34:11PM +0800, Miao Xie wrote:
> >> On Thu, 16 May 2013 13:15:57 +0800, Liu Bo wrote:
> >>> On Thu, May 16, 2013 at 12:31:11PM +0800, Miao Xie wrote:
> >>>> On thu, 16 May 2013 11:36:46 +0800, Liu Bo wrote:
> >>>>> On Wed, May 15, 2013 at 03:48:20PM +0800, Miao Xie wrote:
> >>>>>> The grab/put funtions will be used in the next patch, which need grab
> >>>>>> the root object and ensure it is not freed. We use reference counter
> >>>>>> instead of the srcu lock is to aovid blocking the memory reclaim task,
> >>>>>> which invokes synchronize_srcu().
> >>>>>>
> >>>>>
> >>>>> I don't think this is necessary, we put 'kfree(root)' because we really
> >>>>> need to free them at the very end time, when there should be no inodes
> >>>>> linking on the root(we should have cleaned all inodes out from it).
> >>>>>
> >>>>> So when we flush delalloc inodes and wait for ordered extents to finish,
> >>>>> the root should be valid, otherwise someone is doing wrong things.
> >>>>>
> >>>>> And even with this grab_fs_root to avoid freeing root, it's just the
> >>>>> root that remains in memory, all its attributes, like root->node,
> >>>>> commit_root, root->inode_tree, are already NULL or empty.
> >>>>
> >>>> Please consider the case:
> >>>> 	Task1			Task2					Cleaner
> >>>> 	get the root
> >>>> 				flush all delalloc inodes
> >>>> 				drop subvolume
> >>>> 				iput the last inode
> >>>> 				  move the root into the dead list
> >>>> 									drop subvolume
> >>>> 									kfree(root)
> >>>> If Task1 accesses the root now, oops will happen.
> >>>
> >>> Then it's task1's fault, why it is not protected by subvol_srcu section when
> >>> it's possible that someone like task2 sets root's refs to 0?
> >>>
> >>> synchronize_srcu(subvol_srcu) before adding root into dead root list is
> >>> just for this race case, why do we need another?
> >>
> >> Please read my changelog.
> > 
> > 'The memory reclaim task' in the changelog refers to
> > 	iput
> > 	  -> inode_tree_del
> > , right?
> > 
> > I don't like special cases, this get/put is different from our usual way:
> > if (atomic_dec_and_test(refs)) {
> > 	kfree(A->a);
> > 	kfree(A->b);
> > 	kfree(A);
> > }
> > 
> > According to the pictured case, task1 may also access root->something.
> 
> "->something" are the member variants of root object, so the problem you worry about
> can not happen unless somebody misuse this mechanism in the future. But you can not
> ascribe the misuse to this patch.
> 
> > I must say that the patch itself looks harmless, the reason is not good enough.
> 
> I don't agree with you.
> It is perishing that The memory reclaim task is blocked for a long time. We should avoid
> this problem.

So the real question is why do you think it will be blocked for a long time
by subvol_srcu?  Have you already noticed btrfs acting like this somehow?

I played with subvol_srcu for defrag bug some time ago,
on the read side we use subvol_srcu as
	index = srcu_read_lock(&fs_info->subvol_srcu);
	get root and check btrfs_root_refs();
	inode = btrfs_iget(inode);
	srcu_read_unlock(&fs_info->subvol_srcu, index);

and yes if we've deleted the subvol/snap, this section will nicely bail out
after checking btrfs_root_refs().

Even if we now have thousands of this kind of srcu section, would that be a long
time?

thanks,
liubo
