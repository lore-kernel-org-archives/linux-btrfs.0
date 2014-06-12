Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2782 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbaFLXZI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 19:25:08 -0400
Date: Fri, 13 Jun 2014 09:24:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: R: Re: Slow startup of systemd-journal on BTRFS
Message-ID: <20140612232453.GR9508@dastard>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <pan$22693$6b452195$976b783a$e4956372@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$22693$6b452195$976b783a$e4956372@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 12, 2014 at 12:37:13PM +0000, Duncan wrote:
> Goffredo Baroncelli <kreijack@libero.it> posted on Thu, 12 Jun 2014
> 13:13:26 +0200 as excerpted:
> 
> >>systemd has a very stupid journal write pattern. It checks if there is
> >>space in the file for the write, and if not it fallocates the small
> >>amount of space it needs (it does *4 byte* fallocate calls!) and then
> >>does the write to it.  All this does is fragment the crap out of the log
> >>files because the filesystems cannot optimise the allocation patterns.
> > 
> > I checked the code, and to me it seems that the fallocate() are done in
> > FILE_SIZE_INCREASE unit (actually 8MB).
> 
> FWIW, either 4 byte or 8 MiB fallocate calls would be bad, I think 
> actually pretty much equally bad without NOCOW set on the file.

So maybe it's been fixed in systemd since the last time I looked.
Yup:

http://cgit.freedesktop.org/systemd/systemd/commit/src/journal/journal-file.c?id=eda4b58b50509dc8ad0428a46e20f6c5cf516d58

The reason it was changed? To "save a syscall per append", not to
prevent fragmentation of the file, which was the problem everyone
was complaining about...

> Why?  Because btrfs data blocks are 4 KiB.  With COW, the effect for 
> either 4 byte or 8 MiB file allocations is going to end up being the 
> same, forcing (repeated until full) rewrite of each 4 KiB block into its 
> own extent.

And that's now a btrfs problem.... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
