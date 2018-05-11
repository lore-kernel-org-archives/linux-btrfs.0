Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38342 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbeEKUaE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 16:30:04 -0400
Received: by mail-pg0-f68.google.com with SMTP id n9-v6so2878947pgq.5
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 13:30:04 -0700 (PDT)
Date: Fri, 11 May 2018 13:30:01 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 1/3] fs: add initial bh_result->b_private value to
 __blockdev_direct_IO()
Message-ID: <20180511203001.GE29366@vader>
References: <cover.1525933432.git.osandov@fb.com>
 <9a09b9878759e377b138336886b3e2c6e5d7eae9.1525933432.git.osandov@fb.com>
 <20180511200538.GE30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511200538.GE30522@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 09:05:38PM +0100, Al Viro wrote:
> On Thu, May 10, 2018 at 11:30:10PM -0700, Omar Sandoval wrote:
> >  do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
> >  		      struct block_device *bdev, struct iov_iter *iter,
> >  		      get_block_t get_block, dio_iodone_t end_io,
> > -		      dio_submit_t submit_io, int flags)
> > +		      dio_submit_t submit_io, int flags, void *private)
> 
> Oh, dear...  That's what, 9 arguments?  I agree that the hack in question
> is obscene, but so is this ;-/

So looking at these one by one, obviously needed:

- iocb
- inode
- iter

bdev is almost always inode->i_sb->s_bdev, except for Btrfs :(

These could _maybe_ go in struct kiocb:

- flags could maybe be folded into ki_flags
- private could maybe go in iocb->private, but I haven't yet read
  through to figure out if we're already using iocb->private for direct
  I/O

That leaves the callbacks, get_block, end_io, and submit_io. Perhaps we
can add those to inode_operations?

Thoughts?
