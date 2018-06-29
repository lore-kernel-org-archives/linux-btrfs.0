Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:45482 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932183AbeF2HCo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:02:44 -0400
Received: by mail-pl0-f65.google.com with SMTP id bi1-v6so4008457plb.12
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 00:02:44 -0700 (PDT)
Date: Fri, 29 Jun 2018 00:02:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 1/3] fs: add initial bh_result->b_private value to
 __blockdev_direct_IO()
Message-ID: <20180629070242.GA14870@vader>
References: <cover.1525933432.git.osandov@fb.com>
 <9a09b9878759e377b138336886b3e2c6e5d7eae9.1525933432.git.osandov@fb.com>
 <20180511200538.GE30522@ZenIV.linux.org.uk>
 <20180511203001.GE29366@vader>
 <20180514163548.GN6649@twin.jikos.cz>
 <20180625171638.GH27958@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180625171638.GH27958@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 07:16:38PM +0200, David Sterba wrote:
> On Mon, May 14, 2018 at 06:35:48PM +0200, David Sterba wrote:
> > On Fri, May 11, 2018 at 01:30:01PM -0700, Omar Sandoval wrote:
> > > On Fri, May 11, 2018 at 09:05:38PM +0100, Al Viro wrote:
> > > > On Thu, May 10, 2018 at 11:30:10PM -0700, Omar Sandoval wrote:
> > > > >  do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
> > > > >  		      struct block_device *bdev, struct iov_iter *iter,
> > > > >  		      get_block_t get_block, dio_iodone_t end_io,
> > > > > -		      dio_submit_t submit_io, int flags)
> > > > > +		      dio_submit_t submit_io, int flags, void *private)
> > > > 
> > > > Oh, dear...  That's what, 9 arguments?  I agree that the hack in question
> > > > is obscene, but so is this ;-/
> > > 
> > > So looking at these one by one, obviously needed:
> > > 
> > > - iocb
> > > - inode
> > > - iter
> > > 
> > > bdev is almost always inode->i_sb->s_bdev, except for Btrfs :(
> > > 
> > > These could _maybe_ go in struct kiocb:
> > > 
> > > - flags could maybe be folded into ki_flags
> > > - private could maybe go in iocb->private, but I haven't yet read
> > >   through to figure out if we're already using iocb->private for direct
> > >   I/O
> > 
> > I think the kiocb::private can be used for the purpose. There's only one
> > user, ext4, that also passes some DIO data around so it would in line
> > with the interface AFAICS.
> 
> Omar, do you have an update to the patchset? Thanks.

Al, what do you think of changing all users of map_bh->b_private to use
iocb->private? We'd have to pass the iocb to get_block() and
submit_io(), but we could get rid of dio->private.
