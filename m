Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:50539 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2GBMkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 08:40:04 -0400
Date: Mon, 2 Jul 2012 08:40:02 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix dio write vs buffered read race V3
Message-ID: <20120702124002.GA6185@localhost.localdomain>
References: <1340888944-9471-1-git-send-email-jbacik@fusionio.com>
 <4FF027C4.30203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FF027C4.30203@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 01, 2012 at 04:34:44AM -0600, Miao Xie wrote:
> On Thu, 28 Jun 2012 09:09:04 -0400, Josef Bacik wrote:
> >  fs/btrfs/file.c  |   13 ------------
> >  fs/btrfs/inode.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 50 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 70dc8ca..9aa01ec 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1334,7 +1334,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
> >  				    loff_t *ppos, size_t count, size_t ocount)
> >  {
> >  	struct file *file = iocb->ki_filp;
> > -	struct inode *inode = fdentry(file)->d_inode;
> >  	struct iov_iter i;
> >  	ssize_t written;
> >  	ssize_t written_buffered;
> > @@ -1344,18 +1343,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
> >  	written = generic_file_direct_write(iocb, iov, &nr_segs, pos, ppos,
> >  					    count, ocount);
> >  
> > -	/*
> > -	 * the generic O_DIRECT will update in-memory i_size after the
> > -	 * DIOs are done.  But our endio handlers that update the on
> > -	 * disk i_size never update past the in memory i_size.  So we
> > -	 * need one more update here to catch any additions to the
> > -	 * file
> > -	 */
> > -	if (inode->i_size != BTRFS_I(inode)->disk_i_size) {
> > -		btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
> > -		mark_inode_dirty(inode);
> > -	}
> > -
> >  	if (written < 0 || written == count)
> >  		return written;
> 
> We should fall back the i_size in btrfs_direct_IO if we fails to do direct IO, right?
> 

No we would have only updated the i_size in the case that we created new
extents, we won't have i_size beyond where we have data.  Thanks,

Josef
