Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47108 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab3HISIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 14:08:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 0BEEE9A0405
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2013 12:08:55 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <alpine.DEB.2.00.1308091101480.14125@cobra.newdream.net>
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain>
 <20130618165952.9494.8953@localhost.localdomain>
 <alpine.DEB.2.00.1306192043380.14838@cobra.newdream.net>
 <alpine.DEB.2.00.1306201455440.454@cobra.newdream.net>
 <20130621004216.4477.93556@localhost.localdomain>
 <alpine.DEB.2.00.1308091101480.14125@cobra.newdream.net>
Message-ID: <20130809180852.17880.6919@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Fri, 9 Aug 2013 14:08:52 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Sage Weil (2013-08-09 14:04:15)
> Hi Chris,
> 
> On Thu, 20 Jun 2013, Chris Mason wrote:
> > Quoting Sage Weil (2013-06-20 17:56:19)
> > > On Wed, 19 Jun 2013, Sage Weil wrote:
> > > > Hi Chris,
> > > > 
> > > > On Tue, 18 Jun 2013, Chris Mason wrote:
> > > > > [...]
> > > > > Very long way of saying I think we're one release_path short.  Sage, I
> > > > > haven't tested this at all yet, I was hoping to trigger it first.
> > > > > 
> > > > > diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> > > > > index c276ac9..c1954b3 100644
> > > > > --- a/fs/btrfs/tree-log.c
> > > > > +++ b/fs/btrfs/tree-log.c
> > > > > @@ -3730,6 +3730,7 @@ next_slot:
> > > > >  log_extents:
> > > > >     if (fast_search) {
> > > > >             btrfs_release_path(dst_path);
> > > > > +           btrfs_release_path(path);
> > > > >             ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
> > > > >             if (ret) {
> > > > >                     err = ret;
> > > > 
> > > > This seems to be doing the trick.  I'll keep testing overnight, but so far 
> > > > so good!
> > > 
> > > ...and it's still holding up well in QA.
> > 
> > Awesome, thanks for getting the traces for us.  Looks like this one has
> > been around since v3.7, so I'm not going to try and sneak it into the
> > 3.10 final.  I'll have it in the next merge window and for stable.
> 
> I was just pulling in the current -rc for testing and realized that this 
> isn't upstream yet.  Was this missed?  Sorry I didn't check earlier.

Ack, thanks Sage.  It'll go into the next pull (cc stable)

-chris

