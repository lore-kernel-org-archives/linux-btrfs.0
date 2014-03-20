Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50131 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaCTAUI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 20:20:08 -0400
Date: Wed, 19 Mar 2014 17:20:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
Message-ID: <20140320002007.GY18959@merlins.org>
References: <20140319223723.GU18959@merlins.org> <CF4FA917.20FD%clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CF4FA917.20FD%clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 20, 2014 at 12:13:36AM +0000, Chris Mason wrote:
> >Should I double it?
> >
> >For now, I have the copy running again, and it's been going for 8 hours
> >without failure on the old kernel but of course that doesn't mean my 2TB
> >copy will complete without hitting the bug again.
> 
> Sorry, I misspoke, you should bump /proc/sys/vm/min_free_kbytes.  Honestly
> though, it¹s just a bug in the mvs driver.  Atomic 8K allocations are
> doomed to fail eventually.

Gotcha
polgara:/mnt/btrfs_backupcopy# cat /proc/sys/vm/min_free_kbytes
45056
polgara:/mnt/btrfs_backupcopy# echo 100000 > /proc/sys/vm/min_free_kbytes
polgara:/mnt/btrfs_backupcopy# cat /proc/sys/vm/min_free_kbytes
100000
polgara:/mnt/btrfs_backupcopy# 
 
> The driver should either busy loop until the allocation completes (really
> not a great choice), gracefully deal with the failure (looks tricky), or
> preallocate the space (like the rest of the block layer).

Gotcha. I'll report this to the folks maintaining the marvel driver.

So just to make sure I got you right, although the page allocation failure
was shown in btrfs, it's really the underlying marvel driver at fault here,
and there isn't really anything to change on the btrfs side, correct?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
