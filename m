Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38431 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3HBX30 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 19:29:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 02E8C7C068F
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2013 17:29:26 -0600 (MDT)
Date: Fri, 2 Aug 2013 19:29:23 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix what bits we clear when erroring out from
 delalloc
Message-ID: <20130802232923.GF2372@localhost.localdomain>
References: <1375118662-29718-1-git-send-email-jbacik@fusionio.com>
 <51F75CDC.505@cn.fujitsu.com>
 <51FB8501.80605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51FB8501.80605@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 02, 2013 at 06:08:01PM +0800, Miao Xie wrote:
> Hi, Josef
> 
> On Tue, 30 Jul 2013 14:27:40 +0800, Miao Xie wrote:
> >>  			extent_clear_unlock_delalloc(inode, start, end, NULL,
> >> -						     EXTENT_DIRTY |
> >> -						     EXTENT_DELALLOC,
> >> +						     EXTENT_DELALLOC |
> >> +						     EXTENT_DO_ACCOUNTING |
> >> +						     EXTENT_DEFRAG,
> >>  						     PAGE_UNLOCK |
> >>  						     PAGE_CLEAR_DIRTY |
> >>  						     PAGE_SET_WRITEBACK |
> > 
> > I found we released the reserved space in cow_file_range_inline(), but at that time,
> > we didn't drop the outstanding_extents counter by the number of the delalloc extents,
> > so it might leave some reserved space which was not released. So I think we should remove
> > the release function in cow_file_range_inline().
> > 
> > (This bug is not introduced by your patch. but if we don't fix the above problem before
> >  applying your patch, the double release would happen because we have released the space
> >  in cow_file_range_inline())
> 
> I'm sorry that I made a mistake, the problem I said above doesn't exist because the block
> size is equal to the page size, and we can only inline the file extent which is <= the page size,
> so it is unlikely that one inline extent has two extent state objects.
> 
> But the double release of the reserved space exists actually. We can fix by removing the release
> function in cow_file_range_inline() and passing EXTENT_DO_ACCOUNTING to the clear function.
>

Sorry I meant to send a v2, but what I've committed isn't actually this.  We
need DO_ACCOUNTING if ret < 0 but not if ret == 0, so I've changed this to take
that into account since cow_file_range_inline does do the accounting as you say.
Thanks,

Josef 
