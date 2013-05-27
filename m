Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26361 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab3E0NxQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 09:53:16 -0400
Date: Mon, 27 May 2013 21:52:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: fix use-after-free bug during umount
Message-ID: <20130527135232.GA4666@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
 <1369576231-17836-2-git-send-email-bo.li.liu@oracle.com>
 <20130527120700.GB28422@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130527120700.GB28422@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 27, 2013 at 02:07:00PM +0200, David Sterba wrote:
> On Sun, May 26, 2013 at 09:50:27PM +0800, Liu Bo wrote:
> > Commit be283b2e674a09457d4563729015adb637ce7cc1
> > (    Btrfs: use helper to cleanup tree roots) introduced the following bug,
> 
> Well, it did not introduce the bug, but made it visible.
> 
> > We've free'ed commit_root before actually getting to free block groups where
> > caching thread needs valid extent_root->commit_root.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/disk-io.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index e7b3cb5..a5c8f28 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3512,10 +3512,10 @@ int close_ctree(struct btrfs_root *root)
> >  		       percpu_counter_sum(&fs_info->delalloc_bytes));
> >  	}
> >  
> > -	free_root_pointers(fs_info, 1);
> > -
> >  	btrfs_free_block_groups(fs_info);
> >  
> > +	free_root_pointers(fs_info, 1);
> > +
> >  	del_fs_roots(fs_info);
> >  
> >  	iput(fs_info->btree_inode);
> 
> This makes it just harder to hit, but the worker threads that get
> stopped after iput may still access the freed roots, like mentioned here
> 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24239.html
> 
> david

Hi David,

The original code just free_extent_buffer(commit_root), so the bug proves that
there can still be a reference on commit_root during the period between freeing
tree roots and stopping workers.

I think we should add a parameter for free_root_pointers() to tell it not set
root->commit_root NULL.

If you agree on this, I can make a patch :)

(I did spend a lot of time to reproduce this with xfstests as you
showed, but I failed somehow, the magic is that I reproduced it while
testing the dedup patch set, lol)

thanks,
liubo
