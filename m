Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44852 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbcINSQa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 14:16:30 -0400
Date: Wed, 14 Sep 2016 11:16:21 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: kill BUG_ON in do_relocation
Message-ID: <20160914181621.GA32358@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9426999a-06a8-d169-753a-0c4df5c7c4f8@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 01:13:34PM -0400, Josef Bacik wrote:
> On 09/14/2016 12:27 PM, Liu Bo wrote:
> > While updating btree, we try to push items between sibling
> > nodes/leaves in order to keep height as low as possible.
> > But we don't memset the original places with zero when
> > pushing items so that we could end up leaving stale content
> > in nodes/leaves.  One may read the above stale content by
> > increasing btree blocks' @nritems.
> > 
> 
> Ok this sounds really bad.  Is this as bad as I think it sounds?  We should
> probably fix this like right now right?

Yeah, I'm preparing two patches to address it.

> 
> > One case I've come across is that in fs tree, a leaf has two
> > parent nodes, hence running balance ends up with processing
> > this leaf with two parent nodes, but it can only reach the
> > valid parent node through btrfs_search_slot, so it'd be like,
> > 
> > do_relocation
> >     for P in all parent nodes of block A:
> >         if !P->eb:
> >             btrfs_search_slot(key);   --> get path from P to A.
> >         if lowest:
> >             BUG_ON(A->bytenr != bytenr of A recorded in P);
> >         btrfs_cow_block(P, A);   --> change A's bytenr in P.
> > 
> > After btrfs_cow_block, P has the new bytenr of A, but with the
> > same @key, we get the same path again, and get panic by BUG_ON.
> > 
> 
> Ok so this happens because of the problem you described above right?
> Because this shouldn't actually happen.  We should go down the next parent
> and still get to the original block where A->bytenr == node->bytenr.

After bumping block 55279616's @nritems from 320 to 492,

fs tree key (FS_TREE ROOT_ITEM 0) 
node 55230464 level 2 items 4 free 489 generation 11 owner 5
fs uuid 03737dfb-8087-4923-b058-2ec629bf39bd
chunk uuid d586e037-9d50-4332-9b3a-fa2344d210e1
        key (256 INODE_ITEM 0) block 55279616 (3374) gen 11 nr 0
        key (257 DIR_INDEX 24879) block 56410112 (3443) gen 11 nr 1
        key (10404 INODE_ITEM 0) block 60391424 (3686) gen 11 nr 2
        key (34068 INODE_ITEM 0) block 55246848 (3372) gen 11 nr 3
node 55279616 level 1 items 492 free 1 generation 11 owner 5
        ...
        key (257 DIR_INDEX 24625) block 44335104 (2706) gen 9 nr 319
        key (2100 INODE_ITEM 0) block 30425088 (1857) gen 7 nr 320
        key (2148 INODE_ITEM 0) block 30441472 (1858) gen 7 nr 321
node 56410112 level 1 items 311 free 182 generation 11 owner 5
fs uuid 03737dfb-8087-4923-b058-2ec629bf39bd
chunk uuid d586e037-9d50-4332-9b3a-fa2344d210e1
        ...
        key (2052 INODE_ITEM 0) block 30408704 (1856) gen 7 nr 137
        key (2100 INODE_ITEM 0) block 30425088 (1857) gen 7 nr 138
        key (2148 INODE_ITEM 0) block 30441472 (1858) gen 7 nr 139
        ...

If we search fs tree with disk key (2100 INODE_ITEM 0), we always get
into node block 56410112, not node block 55279616 after bin_search in
the top level, so leaf block 30408704 never gets both parent.

>  So I'm
> all for killing this BUG_ON(), but the problem description is wrong.  We
> need to keep this scenario from happening in the first place.  And then we
> kill this BUG_ON() because it can happen if there is FS corruption or
> something.  Thanks,

We really should, we can prevent it from happening by checking btree
node's validation although it is not as easy as checking a leaf.

The description is what I got from debugging, just wanna show how we
come to the BUG_ON since it's not straighforward at all.

But yes, I'll update the description that this problem is due to fs
corruption.

Thanks,

-liubo
