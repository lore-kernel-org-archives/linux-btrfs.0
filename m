Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55118 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3KAMkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 08:40:36 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3E6D29A0414
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Nov 2013 06:40:36 -0600 (MDT)
Date: Fri, 1 Nov 2013 08:40:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: check file extent type before anything else
Message-ID: <20131101124034.GC16855@localhost.localdomain>
References: <1383252643-6429-1-git-send-email-jbacik@fusionio.com>
 <527358A4.9060003@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <527358A4.9060003@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 08:30:44AM +0100, Stefan Behrens wrote:
> On Thu, 31 Oct 2013 16:50:43 -0400, Josef Bacik wrote:
> > I hit this problem with my no holes patch and it made me realize what the
> > problem was for bz 60834.  If the first item in the leaf is an inline extent and
> > we try to read anything starting from disk_bytenr onward we will read off the
> > end of the leaf.  So we need to check to see what it's type is, and if it's not
> > REG we can just break out.  This should fix this problem.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/backref.c |  1 +
> >  fs/btrfs/send.c    | 10 +++++-----
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 3775947..b763f10 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
> > @@ -1051,6 +1051,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
> >  
> >  	if (ret < 0 && ret != -ENOENT) {
> >  		free_leaf_list(*leafs);
> > +		ulist_free(*leafs);
> 
> An en passant fix for which problem?
> 

Oops, sorry about that, not a problem just me doing other things, I'll drop that
bit.  Thanks,

Josef
