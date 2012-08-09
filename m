Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39446 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab2HINLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Aug 2012 09:11:13 -0400
Date: Thu, 9 Aug 2012 09:11:09 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: Miao Xie <miaox@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting
 shared block reference
Message-ID: <20120809131109.GE4185@shiny>
References: <50232A19.2010704@cn.fujitsu.com>
 <20120809122319.GG2141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120809122319.GG2141@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 09, 2012 at 06:23:19AM -0600, Josef Bacik wrote:
> On Wed, Aug 08, 2012 at 09:10:17PM -0600, Miao Xie wrote:
> > If we create several snapshots at the same time, the following BUG_ON() will be
> > triggered.
> > 
> > 	kernel BUG at fs/btrfs/extent-tree.c:6047!
> > 
> > Steps to reproduce:
> >  # mkfs.btrfs <partition>
> >  # mount <partition> <mnt>
> >  # cd <mnt>
> >  # for ((i=0;i<2400;i++)); do touch long_name_to_make_tree_more_deep$i; done
> >  # for ((i=0; i<4; i++))
> >  > do
> >  > mkdir $i
> >  > for ((j=0; j<200; j++))
> >  > do
> >  > btrfs sub snap . $i/$j
> >  > done &
> >  > done
> > 
> > The reason is:
> > Before transaction commit, some operations changed the fs tree and new tree
> > blocks were allocated because of COW. We used the implicit non-shared back
> > reference for those newly allocated tree blocks because they were not shared by
> > two or more trees.
> > 
> > And then we created the first snapshot for the fs tree, according to the back
> > reference rules, we also used implicit back refs for the child tree blocks of
> > the root node of the fs tree, now those child nodes/leaves were shared by two
> > trees.
> > 
> > Then We didn't deal with the delayed references, and continued to change the fs
> > tree(created the second snapshot and inserted the dir item of the new snapshot
> > into the fs tree). According to the rules of the back reference, we added full
> > back refs for those tree blocks whose parents have be shared by two trees.
> > Now some newly allocated tree blocks had two types of the references.
> > 
> > As we know, the delayed reference system handles these delayed references from
> > back to front, and the full delayed reference is inserted after the implicit
> > ones. So when we dealt with the back references of those newly allocated tree
> > blocks, the full references was dealt with at first. And if the first reference
> > is a shared back reference and the tree block that the reference points to is
> > newly allocated, It would be considered as a tree block which is shared by two
> > or more trees when it is allocated and should be a full back reference not a
> > implicit one, the flag of its reference also should be set to FULL_BACKREF.
> > But in fact, it was a non-shared tree block with a implicit reference at
> > beginning, so it was not compulsory to set the flags to FULL_BACKREF. So BUG_ON
> > was triggered.
> > 
> > We have several methods to fix this bug:
> > 1. deal with delayed references after the snapshot is created and before we
> >    change the source tree of the snapshot. This is the easiest and safest way.
> > 2. modify the sort method of the delayed reference tree, make the full delayed
> >    references be inserted before the implicit ones. It is also very easy, but
> >    I don't know if it will introduce some problems or not.
> 
> Thanks for tracking this down, FWIW I like option 2 the most, it would be
> intereseting to see if it does actually introduce new issues.  Thanks,

For this release, I like the current patch ;)  Great job tracking it
down Miao.

-chris

