Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:54625 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab2HAMK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Aug 2012 08:10:27 -0400
Date: Wed, 1 Aug 2012 08:10:23 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: unlock extent when the dio completes for reads
Message-ID: <20120801121023.GB2263@localhost.localdomain>
References: <1343766827-6674-1-git-send-email-jbacik@fusionio.com>
 <20120731213049.GB31939@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120731213049.GB31939@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2012 at 03:30:49PM -0600, Zach Brown wrote:
> > +static void btrfs_direct_read_iodone(struct kiocb *iocb, loff_t offset,
> > +				     ssize_t bytes, void *private, int ret,
> > +				     bool is_async)
> > +{
> > +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> > +	u64 lockend;
> > +
> > +	if (get_state_private(&BTRFS_I(inode)->io_tree, offset, &lockend)) {
> > +		WARN_ON(1);
> > +		goto out;
> > +	}
> > +
> > +	unlock_extent(&BTRFS_I(inode)->io_tree, offset, lockend);
> > +out:
> > +	if (is_async)
> > +		aio_complete(iocb, ret, 0);
> > +	inode_dio_done(inode);
> > +}
> 
> Hmm.  I'm worried that this can be called from interrupt context and the
> state/extent calls there seem to use bare spin locks.  Did you run this
> with lockdep?  Am I confused?
> 

Our read completions are run in a helper thread since we need to do things like
clear the extent state stuff and such so it's safe in this regard.  Course I hit
a lockup with xfstests 91 because there are some cases where we can return
errors without doing the dio complete (rightly so since we haven't setup the dio
yet), so now I have to figure out how to know when we've been unlocked via dio
complete or that I've gotten an error back and already unlocked it...

Josef
