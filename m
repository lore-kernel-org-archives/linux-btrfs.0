Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44091 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JIM5P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 08:57:15 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A44367C06AC
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 06:57:14 -0600 (MDT)
Date: Wed, 9 Oct 2013 08:57:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: limit delalloc pages outside of
 find_delalloc_range
Message-ID: <20131009125712.GE16461@localhost.localdomain>
References: <1381253517-914-1-git-send-email-jbacik@fusionio.com>
 <20131009100720.GA13983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131009100720.GA13983@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 09, 2013 at 06:07:20PM +0800, Liu Bo wrote:
> On Tue, Oct 08, 2013 at 01:31:57PM -0400, Josef Bacik wrote:
> > Liu fixed part of this problem and unfortunately I steered him in slightly the
> > wrong direction and so didn't completely fix the problem.  The problem is we
> > limit the size of the delalloc range we are looking for to max bytes and then we
> > try to lock that range.  If we fail to lock the pages in that range we will
> > shrink the max bytes to a single page and re loop.  However if our first page is
> > inside of the delalloc range then we will end up limiting the end of the range
> > to a period before our first page.  This is illustrated below
> > 
> > [0 -------- delalloc range --------- 256mb]
> >                                   [page]
> > 
> > So find_delalloc_range will return with delalloc_start as 0 and end as 128mb,
> > and then we will notice that delalloc_start < *start and adjust it up, but not
> > adjust delalloc_end up, so things go sideways.  To fix this we need to not limit
> 
> This makes me more confused...
> so do you mean that 'delalloc_end < delalloc_start' leads to the not locked pages?
> 

No, it leads to an infinite loop, I still have no idea how that guy was seeing
unlocked pages with you patch :(.  Thanks,

Josef
