Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17044 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdBNTGO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 14:06:14 -0500
Date: Tue, 14 Feb 2017 11:05:18 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use helper to get used bytes of space_info
Message-ID: <20170214190518.GB31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1487029341-12911-1-git-send-email-bo.li.liu@oracle.com>
 <20170214155606.GO16928@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170214155606.GO16928@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2017 at 04:56:06PM +0100, David Sterba wrote:
> On Mon, Feb 13, 2017 at 03:42:21PM -0800, Liu Bo wrote:
> > This uses a helper instead of open code around used byte of space_info
> > everywhere.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> > ---
> >  fs/btrfs/extent-tree.c | 42 ++++++++++++++++++++----------------------
> >  1 file changed, 20 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 097fa4a..b2b0b82 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -4118,6 +4118,15 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
> >  	return ret;
> >  }
> >  
> > +static u64 btrfs_space_info_used(struct btrfs_space_info *s_info,
> > +				 bool may_used_included)
> > +{
> > +	ASSERT(s_info);
> > +	return s_info->bytes_used + s_info->bytes_reserved +
> > +		s_info->bytes_pinned + s_info->bytes_readonly +
> > +		((may_used_included) ? s_info->bytes_may_use : 0);
> 
> I'd rename may_used_included to 'may_use_included' so it matches bytes_may_use.

I agree, it sounds better.

Thanks,

-liubo
