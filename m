Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35476 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753936AbdGXOBY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:01:24 -0400
Received: by mail-qk0-f193.google.com with SMTP id k2so2530955qkf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 07:01:23 -0700 (PDT)
Date: Mon, 24 Jul 2017 10:01:21 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: dsterba@suse.cz, josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/3] btrfs: fix readdir deadlock with pagefault
Message-ID: <20170724140121.GB9406@destiny>
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
 <1500658149-20410-2-git-send-email-jbacik@fb.com>
 <20170724125050.GR2866@twin.jikos.cz>
 <20170724131408.GT2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170724131408.GT2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 03:14:08PM +0200, David Sterba wrote:
> On Mon, Jul 24, 2017 at 02:50:50PM +0200, David Sterba wrote:
> > On Fri, Jul 21, 2017 at 01:29:08PM -0400, josef@toxicpanda.com wrote:
> > > From: Josef Bacik <jbacik@fb.com>
> > > 
> > > Readdir does dir_emit while under the btree lock.  dir_emit can trigger
> > > the page fault which means we can deadlock.  Fix this by allocating a
> > > buffer on opening a directory and copying the readdir into this buffer
> > > and doing dir_emit from outside of the tree lock.
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > > ---
> > >  fs/btrfs/inode.c | 110 +++++++++++++++++++++++++++++++++++++++++--------------
> > >  1 file changed, 83 insertions(+), 27 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index 9a4413a..61396e3 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > @@ -5877,6 +5877,56 @@ unsigned char btrfs_filetype_table[] = {
> > >  	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> > >  };
> > >  
> > > +/*
> > > + * All this infrastructure exists because dir_emit can fault, and we are holding
> > > + * the tree lock when doing readdir.  For now just allocate a buffer and copy
> > > + * our information into that, and then dir_emit from the buffer.  This is
> > > + * similar to what NFS does, only we don't keep the buffer around in pagecache
> > > + * because I'm afraid I'll fuck that up.
> 
> Can you please explain the concern in more detail?
> 

If we keep the cache I'll have to have mechanisms to invalidate the page cache
so it can be regenerated at the next readdir.  Then I also have to wire up
releasepage and stuff for directories and make sure it doesn't do anything
bonkers like accidently try to write the data out for a directory.  All in all
it's not worth the headache I don't think.  Thanks,

Josef
