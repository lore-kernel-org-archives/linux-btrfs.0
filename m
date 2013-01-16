Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17562 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3APBHu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 20:07:50 -0500
Date: Wed, 16 Jan 2013 09:05:30 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash of starting balance
Message-ID: <20130116010529.GC3942@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1358261277-3566-1-git-send-email-bo.li.liu@oracle.com>
 <20130115165903.GB2040@zambezi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130115165903.GB2040@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 06:59:04PM +0200, Ilya Dryomov wrote:
> On Tue, Jan 15, 2013 at 10:47:57PM +0800, Liu Bo wrote:
> > We will crash on BUG_ON(ret == -EEXIST) when we do not resume the existing
> > balance but attempt to start a new one.
> > 
> > The steps can be:
> > 1. start balance
> > 2. pause balance
> > 3. start balance
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/volumes.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 5cce6aa..3901654 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -3100,7 +3100,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
> >  		goto out;
> >  
> >  	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
> > -		BUG_ON(ret == -EEXIST);
> > +		/*
> > +		 * This can happen when we do not resume the existing balance
> > +		 * but try to start a new one instead.
> > +		 */
> > +		if (ret == -EEXIST)
> > +			goto out;
> >  		set_balance_control(bctl);
> >  	} else {
> >  		BUG_ON(ret != -EEXIST);
> 
> OK, it seems balance pause/resume logic got broken by dev-replace code
> (5ac00addc7ac09110995fe967071d191b5981cc1), which went into v3.8-rc1.
> This is most certainly not the right way to fix it, that BUG_ON is there
> for a reason.  I'll send a fix in a couple of days.

Okay, right here waiting for test ;)

thanks,
liubo
