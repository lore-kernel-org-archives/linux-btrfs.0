Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47186 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3KFRes (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 12:34:48 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F35459A0340
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Nov 2013 10:34:47 -0700 (MST)
Date: Wed, 6 Nov 2013 12:34:44 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.cz>, <dustymabe@gmail.com>
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner
 accounting (bug #61951)
Message-ID: <20131106173444.GD27784@localhost.localdomain>
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
 <20131104174230.GK16855@localhost.localdomain>
 <527A7A6F.7080407@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <527A7A6F.7080407@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 06, 2013 at 06:20:47PM +0100, Jan Schmidt wrote:
>  
> On Mon, November 04, 2013 at 18:42 (+0100), Josef Bacik wrote:
> > On Thu, Oct 24, 2013 at 03:22:06PM +0200, Jan Schmidt wrote:
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
> >>
> >> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> >> Tested-by: <dustymabe@gmail.com>
> > 
> > This breaks btrfs/003, I'm kicking it out.
> 
> Can you be a bit more specific? Works fine here.
> 

It's blowing up on the balance, so maybe make a bigger fs and balance that so
you can see it?  It's exploding in __btrfs_free_extent because we can't find the
ref we're trying to drop, so I assume you've broken the dropping of the reloc
root part where it depends on you giving it btrfs_header_owner() instead of
root->root_key.objectid as when we cow blocks that belong to the reloc root we
leave the owner set to whoever owned the block originally and not the reloc
root.  Thanks,

Josef
