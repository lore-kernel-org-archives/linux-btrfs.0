Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbbHQVNe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 17:13:34 -0400
Date: Mon, 17 Aug 2015 14:13:32 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Subject: Re: Major qgroup regression in 4.2?
Message-ID: <20150817211332.GC1145@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150813231307.GA1145@wotan.suse.de>
 <20150814211448.GB1145@wotan.suse.de>
 <55D13A02.2050400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D13A02.2050400@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Firstly thanks for the response. I have a few new questions and comments
below,

On Mon, Aug 17, 2015 at 09:33:54AM +0800, Qu Wenruo wrote:
> Thanks for pointing out the problem.
> But it's already known and we didn't have a good idea to solve it yet.
> 
> BTW, the old framework won't handle it well either.
> Liu Bo's testcase (btrfs/017) can easily trigger it.
> So it's not a regression.

I don't understand your meaning here. btrfs/017 doesn't have anything to do
with subvolume deletion. The regression I am talking about is that deleting
a subvolume in btrfs on 4.2 breaks qgroup numbers, whereas it did not in
4.1. Btw, I do acknowledge that 017 *was* broken before and fixed by your
patches (thanks) but that's of course been at the expense of reintroducing
the subvol regression :(


> Let me explain the problem a little and then introduce the fixing plan.
> 
> [Qgroup for subvolume delete]
> Here are two subvolumes, sharing the whole tree.
> The whole trees are consistent with 8 tree blocks.
> A B are the tree root of subv 257 and 258 respectively.
> C~H are all shared by the two subvolumes.
> And I is one data extent which is recorded in tree block H.
> 
> 
> subv 257(A)    subv258(B)
>    |     \       /    |
>    C                  D
>   / \                / \
>   E F                G H
>                        :
>                        :
>                        I
> 
> Let's assume the tree block are all in 4K size(just for easy
> calculation), and I is in 16K size.
> 
> Now qgroup info should be:
> 257: excl: 4K, rfer: 44K (6 shared tree block + 1 data + 1 tree root)
> 258: excl: 4K, rfer: 44K
> 
> If we are going to delete subvolume 258, then expected qgroup should be:
> 257: excl 44K, rfer 44K

Ok, this is basically explaining how we expect the numbers from a subvolume
delete to work out. Everything there looks normal to me.


> Which means we need to recalculate all the reference relation of
> tree block C~H and data extent I.
>
> [[The real problem]]
> Now the real problem is, we need to mark *ALL* metadata and data
> extent of a subvolume dirty to make subvolume deletion work.

I don't understand why we have to mark all nodes of a subvol. The previous
implementation was able to get this correct without recalculating every
block in the tree. It only passed shared nodes and items through to the
qgroup accounting code. The accounting code in turn had very simple logic
for working it out - if the extent is now exclusively owned, we adjust
qgroup->excl for the (now only remaing) owner.

If you go back to qgroup_subtree_accounting() it, you would see
*that it never* changes ->rfer on a qgroup. That is because the rfer counts
on any related subvolumes don't change during subvol delete. Your example above in
fact illustrates this.

So to be clear,

- Why do we have to visit all tree nodes with the qgroup code given that
we only cared about shared ones before"


> Forgot to say, that's at transaction commit time, if we really do that,
> commit time consumption is not acceptable if the subvolume is huge.

This too is confusing to me. Even if we assume that qgroups will get every
node now instead of just the shared ones:

- Drop subvol already visits every node (though it doesn't pass them all to
the qgroup code). We were doing this before just fine to my knowledge - what
changed? The commit-time qgroup accounting?

- Also, btrfs_drop_snapshot() throttles transaction commits (via
btrfs_end_transaction_throttle()), so anything done at commit time looks
like it would be broken up into smaller chunks of work for us.

Am I mistaken in how I understand these functions?


Also I must ask... How did you discover this performance issue? Are we
talking about something theoretical here or was your implementation slow on
subvolume delete?


> [[Possible fix plan]]
> As you can see the biggest problem is the number of child
> metadata/data extents can be quite large, it's not possible to mark
> them all and account at commit transaction time.

... right so handling qgroups at commit time is performance sensitive in
that too many qgroup updates will cause the commit code to do a lot of work.
I think that actually answers one of my questions above, though my followup would be:

Would I be correct if I said this is a problem for any workload that creates
a large number of qgroup updates in a short period of time?


> But the good news is, we can keep the snapshot and account them in
> several commits.
> The new extent-orient accounting is quite accurate as it happens at
> commit time.

Btw, one thing I should say is that in general I really like your rewrite
grats on that - the code is far easier to read through and I like very much
that we've taken some of the open-coded qgroup code out of our extent
inc/dec code.


> So one possible fix is, if we want to delete a subvolume, we put the
> subvolume into an orphan status, and let qgroup account to ignore
> that qgroup from then on, and mark some extent dirty in one
> transaction, and continue marking in next transaction until we mark
> all extents in that subvolume dirty.
> Then free the subvolume.
> 
> That's the ideal method for both snapshot creation and deletion, but
> takes the most time.

It also sounds like a disk format change which would really suck to tell
users to do just so they can get accurate qgroup numbers.


> [Hot fix idea]
> So far, the best and easiest method I come up with is, if we found
> qgroup is enabled and the snapshot to delete is above level 1(level
> starts from 0), then mark the QGROUP_INCONSISTENT flag to info user
> to do a rescan.

This is exactly the kind of band-aid solution we wanted to avoid the first
time qgroups and subvolume handling were fixed.
	--Mark

--
Mark Fasheh
