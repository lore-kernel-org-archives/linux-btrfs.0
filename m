Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36467 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaDKJ2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 05:28:37 -0400
Date: Fri, 11 Apr 2014 17:28:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chip Turner <cturner@pattern.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Filesystem unable to recover from ENOSPC
Message-ID: <20140411092827.GD26503@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAH3EO-o-S7WveO7V++zB1+Zd3kfrxk4YyMZ6P+GrcNWfALgrfA@mail.gmail.com>
 <20140410203439.GB20307@carfax.org.uk>
 <CAH3EO-oSzYTd2Q3H3wfg9eV9ii-phuquvtzU2mT5KGKF1_x5iw@mail.gmail.com>
 <pan$18fc6$7005cb64$a96a9a75$5cd6742f@cox.net>
 <CAH3EO-qB91cTUT0ZAib4xAA82_RDGM4dOWmp3smtUfS_=e1uxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH3EO-qB91cTUT0ZAib4xAA82_RDGM4dOWmp3smtUfS_=e1uxg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 10, 2014 at 11:10:33PM -0700, Chip Turner wrote:
> Thank you for the extremely detailed and helpful reply.  I now
> understand what was happening.  To me, when I read "total=" I guess I
> thought that was capacity rather than allocated (but now "holey")
> chunks.  I agree that perhaps adjusting the phrasing of the output of
> df and show would be helpful in making this clearer (or perhaps some
> adjustment to the wiki; maybe I will do that).
> 
> I assume metadata is where filesystem information (directory entries,
> inodes, etc) are stored and not being able to delete was because there
> wasn't room in the metadata chunks, and no room to allocate more
> metadata chunks?  Or are those also data chunks and it was purely
> about data chunks?

Yes and no.  Deleting metadata also needs metadata, and metadata chunk and data
chunk are different ones.

> 
> Does defrag do similar reallocation to balance such that it would help
> combat this behavior?

I'm afraid it won't, since you have that many hardlinks, defrag may not help on
reducing metadata.

thanks,
-liubo
