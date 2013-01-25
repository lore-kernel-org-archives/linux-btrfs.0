Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39535 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3AYC0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 21:26:18 -0500
Date: Fri, 25 Jan 2013 10:23:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix memory leak on extent map after fsync
Message-ID: <20130125022342.GC11440@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <1357656561-24604-2-git-send-email-bo.li.liu@oracle.com>
 <20130124164433.GE2349@localhost.localdomain>
 <20130125013805.GB11440@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130125013805.GB11440@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 09:38:06AM +0800, Liu Bo wrote:
> On Thu, Jan 24, 2013 at 11:44:33AM -0500, Josef Bacik wrote:
> > On Tue, Jan 08, 2013 at 07:49:21AM -0700, Liu Bo wrote:
> > > During fsync, we put the changed parts(i.e. extent map) into the log tree,
> > > and we ship these parts from a list of modified_extents to a local list
> > > to process, of course, we must increment the refs of the extent maps to
> > > avoid it from getting evicted from cache.
> > > 
> > > The problem is
> > > we don't hold the tree writer lock all the time of iterating the local list,
> > > and it is possible that other threads hack in and delete the extent map from
> > > the local list silently.  So we'll end up with memory leak here.
> > > 
> > > I hit this when testing xfstest 274 with mount options 'autodefrag,compress=zlib'.
> > > 
> > > With this fix, the memory leak has gone away.
> > 
> > This isn't going to work, we use the LOGGING flag to make sure the em isn't
> > merged as well.  Thanks,

Well, never mind, I've seen the fix in your btrfs-next.  But it'd be
better if you can also send it to the list where everyone can review it
easily.

thanks,
liubo

> 
> A quick grep shows,
> 
>    1     16  fs/btrfs/extent_map.h <<GLOBAL>>
>              #define EXTENT_FLAG_LOGGING 4
>    2    406  fs/btrfs/extent_map.c <<remove_extent_mapping>>
>              if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
>    3   3403  fs/btrfs/tree-log.c <<btrfs_log_changed_extents>>
>              set_bit(EXTENT_FLAG_LOGGING, &em->flags);
>    4   3413  fs/btrfs/tree-log.c <<btrfs_log_changed_extents>>
>              clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
> 
> how does the flag avoid merging em?
> 
> Seems we lost the check.
> 
> static int mergable_maps(struct extent_map *prev, struct extent_map *next)       
> {                                                                                
>         if (test_bit(EXTENT_FLAG_PINNED, &prev->flags))                          
>                 return 0;                                                        
>                                                                                  
>         /*                                                                       
>          * don't merge compressed extents, we need to know their                 
>          * actual size                                                           
>          */                                                                      
>         if (test_bit(EXTENT_FLAG_COMPRESSED, &prev->flags))                      
>                 return 0;                                                        
> 
> 	...
> }
>                                                                                  
> thanks,
> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
