Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3256 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbaKSDqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 22:46:12 -0500
Date: Wed, 19 Nov 2014 14:45:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not move em to modified list when unpinning
Message-ID: <20141119034556.GG29950@dastard>
References: <1415999790-4144-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415999790-4144-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 04:16:30PM -0500, Josef Bacik wrote:
> We use the modified list to keep track of which extents have been modified so we
> know which ones are candidates for logging at fsync() time.  Newly modified
> extents are added to the list at modification time, around the same time the
> ordered extent is created.  We do this so that we don't have to wait for ordered
> extents to complete before we know what we need to log.  The problem is when
> something like this happens
> 
> log extent 0-4k on inode 1
> copy csum for 0-4k from ordered extent into log
> sync log
> commit transaction
> log some other extent on inode 1
> ordered extent for 0-4k completes and adds itself onto modified list again
> log changed extents
> see ordered extent for 0-4k has already been logged
> 	at this point we assume the csum has been copied
> sync log
> crash
> 
> On replay we will see the extent 0-4k in the log, drop the original 0-4k extent
> which is the same one that we are replaying which also drops the csum, and then
> we won't find the csum in the log for that bytenr.  This of course causes us to
> have errors about not having csums for certain ranges of our inode.  So remove
> the modified list manipulation in unpin_extent_cache, any modified extents
> should have been added well before now, and we don't want them re-logged.  This
> fixes my test that I could reliably reproduce this problem with.  Thanks,

Is it possiible to turn this unspecified test in into another
generic fsync xfstest?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
