Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaIWOH5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 10:07:57 -0400
Date: Tue, 23 Sep 2014 22:07:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, nick <yocto6@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Sparse Warnings about locks in extent-tree.c
Message-ID: <20140923140743.GE3337@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <5420D38F.9060903@gmail.com>
 <20140923064543.GA3337@localhost.localdomain>
 <20140923140141.GU9715@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140923140141.GU9715@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 23, 2014 at 04:01:41PM +0200, David Sterba wrote:
> On Tue, Sep 23, 2014 at 02:45:44PM +0800, Liu Bo wrote:
> > On Mon, Sep 22, 2014 at 09:57:35PM -0400, nick wrote:
> > > Hello Btfs Developers,
> > > I am new so am unsure of how to fix this but we are hitting some sparse warnings about unlock/lock is having 
> > > a wrong count when exiting certain functions in extent-tree.c. I will paste the warnings below for you guys.
> > > Hope this is of help.
> > > Cheers,
> > > Nick  
> > > fs/btrfs/extent-tree.c:6386:39: warning: context imbalance in 'btrfs_lock_cluster' - wrong count at exit
> > > fs/btrfs/extent-tree.c:6663:44: warning: context imbalance in 'find_free_extent' - unexpected unlock
> > > fs/btrfs/extent-tree.c:8810:9: warning: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit
> > 
> > What program is producing these warning?  It looks like a static code analysis
> > tool or something.
> 
> https://sparse.wiki.kernel.org/index.php/Main_Page
> 
> It understands a few semantics like the locking and reports when there's
> an unannotated function that has imbalanced locking, like the errors
> above.

Cool, thanks Dave.

-liubo

> 
> Any static analyzer has some ratio of false positives so not every
> report means there's a bug. One would expect that a function
> 'btrfs_lock_cluster' would act as a lock and leaves some locks held at
> exit. The "fix" is to annotate it a after review.
