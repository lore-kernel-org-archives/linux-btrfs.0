Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50215 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbeEVKFn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 06:05:43 -0400
Date: Tue, 22 May 2018 12:03:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [RFC PATCH 1/8] btrfs: use iocb for __btrfs_buffered_write
Message-ID: <20180522100300.GA6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171117174456.13393-1-rgoldwyn@suse.de>
 <20171117174456.13393-2-rgoldwyn@suse.de>
 <f4cc3baa-2083-6e89-c11e-234076aa8270@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f4cc3baa-2083-6e89-c11e-234076aa8270@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 03:40:18PM +0900, Misono Tomohiro wrote:
> > @@ -1815,7 +1816,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
> >  {
> >  	struct file *file = iocb->ki_filp;
> >  	struct inode *inode = file_inode(file);
> > -	loff_t pos = iocb->ki_pos;
> >  	ssize_t written;
> >  	ssize_t written_buffered;
> >  	loff_t endbyte;
> > @@ -1826,8 +1826,8 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
> >  	if (written < 0 || !iov_iter_count(from))
> >  		return written;
> >  
> > -	pos += written;
> > -	written_buffered = __btrfs_buffered_write(file, from, pos);
> 
> > +	iocb->ki_pos += written;
> 
> Hi,
> 
> I found btrfs/026 fails on current misc-next branch and
> git bisect points this commit.

Thanks, that's appreciated.

> I noticed generic_file_direct_write() already updates iocb->ki_pos, and therefore
> above "iocb->ki_pos += written" is not needed.
> 
> > +	written_buffered = __btrfs_buffered_write(iocb, from);
> >  	if (written_buffered < 0) {
> >  		err = written_buffered;
> >  		goto out;
> > @@ -1836,16 +1836,16 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
> >  	 * Ensure all data is persisted. We want the next direct IO read to be
> >  	 * able to read what was just written.
> >  	 */
> > -	endbyte = pos + written_buffered - 1;
> > -	err = btrfs_fdatawrite_range(inode, pos, endbyte);
> > +	endbyte = iocb->ki_pos + written_buffered - 1;
> > +	err = btrfs_fdatawrite_range(inode, iocb->ki_pos, endbyte);
> >  	if (err)
> >  		goto out;
> > -	err = filemap_fdatawait_range(inode->i_mapping, pos, endbyte);
> > +	err = filemap_fdatawait_range(inode->i_mapping, iocb->ki_pos, endbyte);
> >  	if (err)
> >  		goto out;
> > +	iocb->ki_pos += written_buffered;
> >  	written += written_buffered;
> > -	iocb->ki_pos = pos + written_buffered;
> > -	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
> > +	invalidate_mapping_pages(file->f_mapping, iocb->ki_pos >> PAGE_SHIFT,
> >  				 endbyte >> PAGE_SHIFT);
> 
> Also, this invalidate_mapping_pages() should be done before updating iocb->ki_pos
> to invalidate buffered written area.

This sounds like the patch needs more review, I treated it as more like
a cleanup so I'll drop it from misc-next and revisit once the whole
iomap patchset will be sent again.
