Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43492 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbbJBQe3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 12:34:29 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 2 Oct 2015 22:04:26 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 893F7394005A
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2015 22:04:23 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t92GYLTx6947138
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Oct 2015 22:04:21 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t92GYJJr026840
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Oct 2015 22:04:20 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, bo.li.liu@oracle.com,
        dsterba@suse.cz, quwenruo@cn.fujitsu.com, chandan@mykolab.com
Subject: Re: [PATCH V5 11/13] Btrfs: Clean pte corresponding to page straddling i_size
Date: Fri, 02 Oct 2015 22:04:17 +0530
Message-ID: <9501565.vVUm90Rsjs@localhost.localdomain>
In-Reply-To: <560D49F0.4040200@fb.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com> <1443608912-31667-12-git-send-email-chandan@linux.vnet.ibm.com> <560D49F0.4040200@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 01 Oct 2015 10:57:52 Josef Bacik wrote:
> On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> > When extending a file by either "truncate up" or by writing beyond i_size,
> > the page which had i_size needs to be marked "read only" so that future
> > writes to the page via mmap interface causes btrfs_page_mkwrite() to be
> > invoked. If not, a write performed after extending the file via the mmap
> > interface will find the page to be writaeable and continue writing to the
> > page without invoking btrfs_page_mkwrite() i.e. we end up writing to a
> > file without reserving disk space.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> >   fs/btrfs/file.c  | 12 ++++++++++--
> >   fs/btrfs/inode.c |  2 +-
> >   2 files changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 360d56d..5715e29 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1757,6 +1757,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb
> > *iocb,> 
> >   	ssize_t err;
> >   	loff_t pos;
> >   	size_t count;
> > 
> > +	loff_t oldsize;
> > +	int clean_page = 0;
> > 
> >   	mutex_lock(&inode->i_mutex);
> >   	err = generic_write_checks(iocb, from);
> > 
> > @@ -1795,14 +1797,17 @@ static ssize_t btrfs_file_write_iter(struct kiocb
> > *iocb,> 
> >   	pos = iocb->ki_pos;
> >   	count = iov_iter_count(from);
> >   	start_pos = round_down(pos, root->sectorsize);
> > 
> > -	if (start_pos > i_size_read(inode)) {
> > +	oldsize = i_size_read(inode);
> > +	if (start_pos > oldsize) {
> > 
> >   		/* Expand hole size to cover write data, preventing empty gap 
*/
> >   		end_pos = round_up(pos + count, root->sectorsize);
> > 
> > -		err = btrfs_cont_expand(inode, i_size_read(inode), end_pos);
> > +		err = btrfs_cont_expand(inode, oldsize, end_pos);
> > 
> >   		if (err) {
> >   		
> >   			mutex_unlock(&inode->i_mutex);
> >   			goto out;
> >   		
> >   		}
> > 
> > +		if (start_pos > round_up(oldsize, root->sectorsize))
> > +			clean_page = 1;
> > 
> >   	}
> >   	
> >   	if (sync)
> > 
> > @@ -1814,6 +1819,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb
> > *iocb,> 
> >   		num_written = __btrfs_buffered_write(file, from, pos);
> >   		if (num_written > 0)
> >   		
> >   			iocb->ki_pos = pos + num_written;
> > 
> > +		if (clean_page)
> > +			pagecache_isize_extended(inode, oldsize,
> > +						i_size_read(inode));
> > 
> >   	}
> >   	
> >   	mutex_unlock(&inode->i_mutex);
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index c937357..f31da87 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -4853,7 +4853,6 @@ static int btrfs_setsize(struct inode *inode, struct
> > iattr *attr)> 
> >   	}
> >   	
> >   	if (newsize > oldsize) {
> > 
> > -		truncate_pagecache(inode, newsize);
> 
> So I don't understand why we are dropping this bit here, could you
> explain?  Otherwise the patch looks fine to me.  Thanks,
>
Josef, As per our previous discussion on IRC we found that the
"truncate_pagecache(inode, newsize)" statement to be a relic of the
past. During the test runs, I haven't seen any sort of failure caused by the
removal of this statement.

-- 
chandan

