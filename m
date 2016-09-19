Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752421AbcISSKl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:10:41 -0400
Date: Mon, 19 Sep 2016 20:08:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: handle quota reserve failure properly
Message-ID: <20160919180845.GR16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1473965868-9675-1-git-send-email-jbacik@fb.com>
 <pan$e2095$fbe056c8$f4eac82$cda700a2@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan$e2095$fbe056c8$f4eac82$cda700a2@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 09:02:22AM +0000, Holger Hoffstätte wrote:
> On Thu, 15 Sep 2016 14:57:48 -0400, Josef Bacik wrote:
> 
> > btrfs/022 was spitting a warning for the case that we exceed the quota.  If we
> > fail to make our quota reservation we need to clean up our data space
> > reservation.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent-tree.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 03da2f6..d72eaae 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -4286,13 +4286,10 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > -	/*
> > -	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
> > -	 *
> > -	 * TODO: Find a good method to avoid reserve data space for NOCOW
> > -	 * range, but don't impact performance on quota disable case.
> > -	 */
> > +	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
> >  	ret = btrfs_qgroup_reserve_data(inode, start, len);
> > +	if (ret)
> > +		btrfs_free_reserved_data_space_noquota(inode, start, len);
> >  	return ret;
> >  }
> >  
> > -- 
> > 2.7.4
> 
> This came up before, though slightly different:
> http://www.spinics.net/lists/linux-btrfs/msg56644.html
> 
> Which version is correct - with or without _noquota ?

Seems that it's the _noquota variant.
