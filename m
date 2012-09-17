Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52289 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab2IQNiR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 09:38:17 -0400
Date: Mon, 17 Sep 2012 09:38:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix race with freeze and free space inodes
Message-ID: <20120917133814.GA3143@localhost.localdomain>
References: <1347636380-30185-1-git-send-email-jbacik@fusionio.com>
 <5056B6F9.4000708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5056B6F9.4000708@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2012 at 11:36:57PM -0600, Miao Xie wrote:
> On fri, 14 Sep 2012 11:26:20 -0400, Josef Bacik wrote:
> > So we start our freeze, somebody comes in and does an fsync() on a file
> > where we have to commit a transaction for whatever reason, and we will
> > deadlock because the freeze is waiting on FS_FREEZE people to stop writing
> > to the file system, but the transaction is waiting for its free space inodes
> > to be written out, which are in turn waiting on sb_start_intwrite while
> > trying to write the file extents.  To fix this we'll just skip the
> > sb_start_intwrite() if we TRANS_JOIN_NOLOCK since we're being waited on by a
> > transaction commit so we're safe wrt to freeze and this will keep us from
> > deadlocking.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/transaction.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index c9265a6..ba74dfb 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -342,7 +342,15 @@ again:
> >  	if (!h)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > -	if (!__sb_start_write(root->fs_info->sb, SB_FREEZE_FS, false)) {
> > +	/*
> > +	 * If we are JOIN_NOLOCK we're already committing a transaction and
> > +	 * waiting on this guy, so we don't need to do the sb_start_intwrite
> > +	 * because we're already holding a ref.  We need this because we could
> > +	 * have raced in and did an fsync() on a file which can kick a commit
> > +	 * and then we deadlock with somebody doing a freeze.
> > +	 */
> > +	if (type != TRANS_JOIN_NOLOCK &&
> > +	    !__sb_start_write(root->fs_info->sb, SB_FREEZE_FS, false)) {
> >  		if (type == TRANS_JOIN_FREEZE)
> >  			return ERR_PTR(-EPERM);
> >  		sb_start_intwrite(root->fs_info->sb);
> > 
> 
> This patch forgets to deal with it in __btrfs_end_transaction(), or the freeze counter
> will be wrong.
> 

This was fixed locally I just sent the wrong patch, thanks,

Josef
