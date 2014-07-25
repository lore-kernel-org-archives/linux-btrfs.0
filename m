Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26706 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGYBA3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 21:00:29 -0400
Date: Fri, 25 Jul 2014 09:00:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Message-ID: <20140725010018.GA25859@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
 <53D11E73.60101@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D11E73.60101@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 10:55:47AM -0400, Chris Mason wrote:
> On 07/24/2014 10:48 AM, Liu Bo wrote:
> > When failing to allocate space for the whole compressed extent, we'll
> > fallback to uncompressed IO, but we've forgotten to redirty the pages
> > which belong to this compressed extent, and these 'clean' pages will
> > simply skip 'submit' part and go to endio directly, at last we got data
> > corruption as we write nothing.
> 
> This fallback code was my #1 suspect for the hangs people have been
> seeing since 3.15.  I changed things around to trigger the fallback
> randomly and wasn't able to trigger problems, but I was looking for
> hangs and not corruptions.
> 

So now you're able to trigger the hang without changing the fallback code?

I tried raid1 and raid0 with fsmark and rsync in different ways but still fails
to reproduce the hang :-(

The most weird thing is who the hell holds the free space inode's page, is it
possible to share pages with other inode? (My answer is NO, but I'm not sure
now...)

thanks,
-liubo

> -chris
> 
> 
