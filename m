Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3DPNtf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 09:49:35 -0400
Date: Tue, 16 Apr 2013 21:49:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: return error when we specify wrong start to
 defrag
Message-ID: <20130416134911.GB26176@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1366104028-26830-1-git-send-email-bo.li.liu@oracle.com>
 <20130416133827.GN18193@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416133827.GN18193@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 03:38:28PM +0200, David Sterba wrote:
> On Tue, Apr 16, 2013 at 05:20:28PM +0800, Liu Bo wrote:
> > We need such a sanity check for wrong start when we defrag a file, otherwise,
> > even with a wrong start that's larger than file size, we can end up changing
> > not only inode's force compress flag but also FS's incompat flags.
> 
> The range->start check is good, but why are you worried about the
> incompat flag? LZO support has been around for more than 2 years.

As the code of setting LZO incompat flags is just there, so I take it as a side
effect.

Well, I'm not worried now :)

> 
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -1152,8 +1152,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
> >  	u64 new_align = ~((u64)128 * 1024 - 1);
> >  	struct page **pages = NULL;
> >  
> > -	if (extent_thresh == 0)
> > -		extent_thresh = 256 * 1024;
> > +	if (isize == 0)
> > +		return 0;
> > +
> > +	if (range->start >= isize)
> > +		return -EINVAL;
> ...
> > -	if (isize == 0)
> > -		return 0;
> > +	if (extent_thresh == 0)
> > +		extent_thresh = 256 * 1024;
> 
> That's a more logical order of the checks, good.
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>

Thanks for the quick review!

thanks,
liubo
