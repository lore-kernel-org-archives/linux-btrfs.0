Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55133 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3KAMmq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 08:42:46 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 15D479A06D1
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Nov 2013 06:42:46 -0600 (MDT)
Date: Fri, 1 Nov 2013 08:42:41 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner
 accounting (bug #61951)
Message-ID: <20131101124241.GD16855@localhost.localdomain>
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
 <801531AB-DF1E-44AC-B58E-D0388C7FCC55@gmail.com>
 <52737175.6020906@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <52737175.6020906@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 10:16:37AM +0100, Jan Schmidt wrote:
> (cc Arne)
> 
> On Thu, October 24, 2013 at 16:49 (+0200), Wang Shilong wrote:
> > Hello Jan,
> > 
> >> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
> >> tracking is based on delayed refs. The owner of a tree block is set when a
> >> tree block is allocated, it is never updated.
> >>
> >> When you allocate a tree block and then remove the subvolume that did the
> >> allocation, the qgroup accounting for that removal is correct. However, the
> >> removal was accounted again for each subvolume deletion that also referenced
> >> the tree block, because accounting was erroneously based on the owner.
> >>
> >> Instead of queueing delayed refs for the non-existent owner, we now
> >> queue delayed refs for the root being removed. This fixes the qgroup
> >> accounting.
> > 
> > Thanks for tracking this, i apply your patch, and using the flowing patch,
> > found the problem still exist, the test script like the following:
> > 
> > #!/bin/sh
> > 
> > for i in $(seq 1000)
> > do
> > 	dd if=/dev/zero of=<mnt>/$i""aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  bs=10K count=1
> > done
> > 
> > btrfs sub snapshot <mnt> <mnt>/1
> > for i in $(seq 100)
> > do
> > 	btrfs sub snapshot <mnt>/$i <mnt>/$(($i+1))
> > done
> > 
> > for i in $(seq 101)
> > do
> > 	btrfs sub delete <mnt>/$i
> > done
> 
> I've understood the problem this reproducer creates. In fact, you can shorten it
> dramatically. The story of qgroups is going to turn awkward at this point.
> 
> mkfs and enable quota, put some data in (needs a level 2 tree)
> -> this accounts rfer and excl for qgroup 5
> 
> take a snapshot
> -> this creates qgroup 257, which gets rfer(257) = rfer(5) and excl(257) = 0,
> excl(5) = 0.
> 
> now make sure you don't cow anything (which we always did in our extensive
> tests), just drop the newly created snapshot.
> -> excl(5) ought to become what it was before the snapshot, and there's no code
> for this. This is because there is node code that brings rfer(257) to zero, the
> data extents are not touched because the tree blocks of 5 and 257 are shared.
> 
> Drop tree does not go down the whole tree, when it finds a tree block with
> refcnt > 1 it just decrements it and is done. This is very efficient but is bad
> the qgroup numbers.
> 
> We have got three possibile solutions in mind:
> 
> A: Always walk down the whole tree for quota-enabled fs tree drops. Can be done
> with the read-ahead code, but is potentially a whole lot of work for large file
> systems.
> 

No.

Josef
