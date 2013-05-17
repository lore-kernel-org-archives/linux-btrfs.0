Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25981 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3EQJey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 05:34:54 -0400
Date: Fri, 17 May 2013 17:34:27 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak in replace_path
Message-ID: <20130517093425.GO20202@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1368780344-7157-1-git-send-email-bo.li.liu@oracle.com>
 <5195EFC0.7000209@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5195EFC0.7000209@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 17, 2013 at 10:52:16AM +0200, Stefan Behrens wrote:
> On Fri, 17 May 2013 16:45:44 +0800, Liu Bo wrote:
> > We need to unlock and free extent buffer before the return.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/relocation.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index 704a1b8..5c5b8bb 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -1773,7 +1773,7 @@ again:
> >  			if (!eb || !extent_buffer_uptodate(eb)) {
> >  				ret = (!eb) ? -ENOMEM : -EIO;
> >  				free_extent_buffer(eb);
> > -				return ret;
> > +				break;
> >  			}
> >  			btrfs_tree_lock(eb);
> >  			if (cow) {
> > 
> 
> ELATE
> 
> 5887f17 Btrfs: fix possible memory leak in replace_path()
> 

oh, good catch :)

thanks,
liubo
