Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49545 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbGCKGC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 06:06:02 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 3 Jul 2015 20:06:00 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 961A2357804C
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2015 20:05:58 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t63A5mcm51052584
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jul 2015 20:05:56 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t63A5PBh029004
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jul 2015 20:05:26 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 09/21] Btrfs: subpagesize-blocksize: Direct I/O read: Work on sectorsized blocks.
Date: Fri, 03 Jul 2015 15:35 +0530
Message-ID: <27095669.9eUCvPymgs@localhost.localdomain>
In-Reply-To: <20150701144459.GD7847@localhost.localdomain>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com> <1433172176-8742-10-git-send-email-chandan@linux.vnet.ibm.com> <20150701144459.GD7847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 01 Jul 2015 22:45:00 Liu Bo wrote:
> On Mon, Jun 01, 2015 at 08:52:44PM +0530, Chandan Rajendra wrote:
> > The direct I/O read's endio and corresponding repair functions work on
> > page sized blocks. Fix this.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  try_again:
> > @@ -7810,10 +7853,10 @@ try_again:
> >  		done.start = start;
> >  		init_completion(&done.done);
> > 
> > -		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, 
start,
> > -				     start + bvec->bv_len - 1,
> > -				     io_bio->mirror_num,
> > -				     btrfs_retry_endio, &done);
> > +		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
> > +				pgoff, start, start + sectorsize - 1,
> > +				io_bio->mirror_num,
> > +				btrfs_retry_endio, &done);
> > 
> >  		if (ret) {
> >  		
> >  			err = ret;
> >  			goto next;
> > 
> > @@ -7826,8 +7869,13 @@ try_again:
> >  			goto try_again;
> >  		
> >  		}
> >  
> >  next:
> > -		offset += bvec->bv_len;
> > -		start += bvec->bv_len;
> > +		offset += sectorsize;
> > +		start += sectorsize;
> > +
> 
> It'd better to put a ASSERT(nr_sectors) in case some crazy things
> happen.
> 

Yes, I will add that statement in the future versions of the patchset.

> 
> > +		if (--nr_sectors) {
> > +			pgoff += sectorsize;
> > +			goto next_block;
> > +		}
> > 
> >  	}
> >  	
> >  	return err;

-- 
chandan

