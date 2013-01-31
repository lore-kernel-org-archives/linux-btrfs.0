Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:36541 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab3AaUPw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 15:15:52 -0500
Date: Thu, 31 Jan 2013 15:15:49 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix how we discard outstanding ordered extents on
 abort
Message-ID: <20130131201549.GB11835@localhost.localdomain>
References: <1359660760-3137-1-git-send-email-jbacik@fusionio.com>
 <20130131195808.GG14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20130131195808.GG14246@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 12:58:08PM -0700, Zach Brown wrote:
> > -	struct list_head splice;
> >  	struct btrfs_ordered_extent *ordered;
> 
> >  	struct inode *inode;
> 
> Remove this too?
> 
> > +	/*
> > +	 * This will just short circuit the ordered completion stuff which will
> > +	 * make sure the ordered extent gets properly cleaned up.
> > +	 */
> > +	list_for_each_entry(ordered, &root->fs_info->ordered_extents,
> > +			    root_extent_list)
> > +		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
> >  	spin_unlock(&root->fs_info->ordered_extent_lock);
> >  }
> 
> fs/btrfs/disk-io.c: In function ‘btrfs_destroy_ordered_extents’:
> fs/btrfs/disk-io.c:3548:16: warning: unused variable ‘inode’ [-Wunused-variable]
> 

Sigh I sent the wrong thing out, the one committed to my tree is right.  Thanks,

Josef
