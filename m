From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] Btrfs: fix dentry->d_parent abuses
Date: Thu, 28 Oct 2010 18:08:19 +0800
Message-ID: <1288260499.3151.28.camel@localhost>
References: <1288190373-21381-1-git-send-email-josef@redhat.com>
	 <1288237324.3151.17.camel@localhost>
	 <20101028064332.GA8899@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101028064332.GA8899@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2010-10-28 at 02:43 -0400, Josef Bacik wrote:
> On Thu, Oct 28, 2010 at 11:42:04AM +0800, Ian Kent wrote:
> > On Wed, 2010-10-27 at 10:39 -0400, Josef Bacik wrote:
> > > There are lots of places where we do dentry->d_parent->d_inode without holding
> > > the dentry->d_lock.  This could cause problems with rename.  So instead use
> > > dget_parent where we can, or in some cases we don't even need to use
> > > dentry->d_parent->d_inode since we get the inode of the dir passed to us from
> > > VFS.  I tested this with xfstests and my no space tests and everything turned
> > > out fine.  Thanks,
> > > 
> > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > > ---
> > >  fs/btrfs/file.c        |    2 ++
> > >  fs/btrfs/inode.c       |   48 ++++++++++++++++++++++++------------------------
> > >  fs/btrfs/ioctl.c       |   11 +++++++++--
> > >  fs/btrfs/transaction.c |    5 ++++-
> > >  fs/btrfs/tree-log.c    |   22 ++++++++++++++++++----
> > >  5 files changed, 57 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > > index e354c33..6a4daa0 100644
> > > --- a/fs/btrfs/file.c
> > > +++ b/fs/btrfs/file.c
> > > @@ -1047,8 +1047,10 @@ out:
> > >  
> > >  		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
> > >  			trans = btrfs_start_transaction(root, 0);
> > 
> > If btrfs_start_transaction() fails now the inode mutex will be held as
> > well. I guess the resulting oops makes this irrelevant, ;)
> > 
> > Looking through the dead end BUG_ON()s in the transaction code, and
> > callers, one thing I've found difficult is working out how to recover
> > from IS_ERR() returns from btrfs_start_transaction() in situations like
> > this.
> > 
> > Any chance of a patch to handle this to give me an example (well one
> > case anyway) of how to do it?
> >
> 
> Yup I can do that.  Recovering from some of these errors is going to be tricky,
> if you are going to work on that what I had in mind was doing alot of

Yep, looks downright difficult to me, but it has to be done sometime.

I've looked at a few functions in relation to eliminating dead end
BUG_ON()s (loosely related to this), some at the bottom of the call tree
upward and others at the top of the call tree downward, and it doesn't
take much to realize why no-one has tackled it already.

The bigger issue is that the problem is self perpetuating in that, in
order to fix things, often one has to continue to not handle some of the
error cases because of possible side effects, ouch!

Ian

