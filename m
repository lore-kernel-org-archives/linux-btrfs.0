Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48802 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3JINHV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 09:07:21 -0400
Date: Wed, 9 Oct 2013 21:07:13 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: limit delalloc pages outside of
 find_delalloc_range
Message-ID: <20131009130711.GB13983@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381253517-914-1-git-send-email-jbacik@fusionio.com>
 <20131009100720.GA13983@localhost.localdomain>
 <20131009125712.GE16461@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131009125712.GE16461@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 09, 2013 at 08:57:12AM -0400, Josef Bacik wrote:
> On Wed, Oct 09, 2013 at 06:07:20PM +0800, Liu Bo wrote:
> > On Tue, Oct 08, 2013 at 01:31:57PM -0400, Josef Bacik wrote:
> > > Liu fixed part of this problem and unfortunately I steered him in slightly the
> > > wrong direction and so didn't completely fix the problem.  The problem is we
> > > limit the size of the delalloc range we are looking for to max bytes and then we
> > > try to lock that range.  If we fail to lock the pages in that range we will
> > > shrink the max bytes to a single page and re loop.  However if our first page is
> > > inside of the delalloc range then we will end up limiting the end of the range
> > > to a period before our first page.  This is illustrated below
> > > 
> > > [0 -------- delalloc range --------- 256mb]
> > >                                   [page]
> > > 
> > > So find_delalloc_range will return with delalloc_start as 0 and end as 128mb,
> > > and then we will notice that delalloc_start < *start and adjust it up, but not
> > > adjust delalloc_end up, so things go sideways.  To fix this we need to not limit
> > 
> > This makes me more confused...
> > so do you mean that 'delalloc_end < delalloc_start' leads to the not locked pages?
> > 
> 
> No, it leads to an infinite loop, I still have no idea how that guy was seeing
> unlocked pages with you patch :(.  Thanks,

Oh infinite loop yah, that makes sense :)

-liubo
