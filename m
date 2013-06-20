Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:42513 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab3FTV4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 17:56:20 -0400
Date: Thu, 20 Jun 2013 14:56:19 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <chris.mason@fusionio.com>
cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: hang on 3.9, 3.10-rc5
In-Reply-To: <alpine.DEB.2.00.1306192043380.14838@cobra.newdream.net>
Message-ID: <alpine.DEB.2.00.1306201455440.454@cobra.newdream.net>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net> <20130618163706.GC19183@localhost.localdomain> <20130618165952.9494.8953@localhost.localdomain> <alpine.DEB.2.00.1306192043380.14838@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 19 Jun 2013, Sage Weil wrote:
> Hi Chris,
> 
> On Tue, 18 Jun 2013, Chris Mason wrote:
> > [...]
> > Very long way of saying I think we're one release_path short.  Sage, I
> > haven't tested this at all yet, I was hoping to trigger it first.
> > 
> > diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> > index c276ac9..c1954b3 100644
> > --- a/fs/btrfs/tree-log.c
> > +++ b/fs/btrfs/tree-log.c
> > @@ -3730,6 +3730,7 @@ next_slot:
> >  log_extents:
> >  	if (fast_search) {
> >  		btrfs_release_path(dst_path);
> > +		btrfs_release_path(path);
> >  		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
> >  		if (ret) {
> >  			err = ret;
> 
> This seems to be doing the trick.  I'll keep testing overnight, but so far 
> so good!

...and it's still holding up well in QA.

Thanks, Chris!
sage
