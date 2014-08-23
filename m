Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19590 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHWDyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 23:54:06 -0400
Date: Sat, 23 Aug 2014 11:53:58 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix crash on endio of reading corrupted block
Message-ID: <20140823035357.GB28391@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
 <1408524679-13583-1-git-send-email-bo.li.liu@oracle.com>
 <53F7627D.3060405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F7627D.3060405@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 10:32:13AM -0500, Eric Sandeen wrote:
> On 8/20/14, 3:51 AM, Liu Bo wrote:
> > The crash is
> > 
> > ------------[ cut here ]------------
> > kernel BUG at fs/btrfs/extent_io.c:2124!
> > invalid opcode: 0000 [#1] SMP
> 
> ...
> 
> > ---
> > v2:
> >    - Improve the commit log to be clear, suggested by Eric.
> 
> Well, I had specifically asked for it to include details on when
> the regression occurred, but didn't get that...  ;)
> 
> If you state that it's a regression, people may start wondering
> if their kernels are vulnerable, how far back into -stable it
> should go, which distros should pick up the fix, etc.  If you
> don't say when it regressed, we're all left wondering...

Oh yeah, now I get it :)

thanks,
-liubo

> 
> Thanks,
> 
> -Eric
> 
