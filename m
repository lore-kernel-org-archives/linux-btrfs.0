Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19484 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcERRuy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 13:50:54 -0400
Date: Wed, 18 May 2016 10:52:25 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected return value of fiemap
Message-ID: <20160518175225.GA7227@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1463530908-23545-1-git-send-email-bo.li.liu@oracle.com>
 <20160518094105.GY511@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160518094105.GY511@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 18, 2016 at 11:41:05AM +0200, David Sterba wrote:
> On Tue, May 17, 2016 at 05:21:48PM -0700, Liu Bo wrote:
> > btrfs's fiemap is supposed to return 0 on success and
> >  return < 0 on error, however, ret becomes 1 after looking
> > up the last file extent, and if the offset is beyond EOF,
> > we can return 1.
> > 
> > This may confuse applications using ioctl(FIEL_IOC_FIEMAP).
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> > ---
> >  fs/btrfs/extent_io.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index d247fc0..16ece52 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -4379,8 +4379,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >  	if (ret < 0) {
> >  		btrfs_free_path(path);
> >  		return ret;
> > +	} else {
> > +		WARN_ON(!ret);
> > +		if (ret == 1)
> > +			ret = 0;
> >  	}
> 
> So, ret == 1 can end up here from btrfs_lookup_file_extent ->
> btrfs_search_slot(..., ins_len=0, cow=0) and the offset does not exist,
> we'll get path pointed to the slot where it would be inserted and ret is 1.

Sounds better than the commit log, would you like me to update it?

Thanks,

-liubo
