Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbeIXVJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 17:09:25 -0400
Date: Mon, 24 Sep 2018 17:06:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: don't clean dirty pages during buffered writes
Message-ID: <20180924150645.GA3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620145612.1644763-1-clm@fb.com>
 <20180620145612.1644763-2-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620145612.1644763-2-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 07:56:11AM -0700, Chris Mason wrote:
> During buffered writes, we follow this basic series of steps:
> 
> again:
> 	lock all the pages
> 	wait for writeback on all the pages
> 	Take the extent range lock
> 	wait for ordered extents on the whole range
> 	clean all the pages
> 
> 	if (copy_from_user_in_atomic() hits a fault) {
> 		drop our locks
> 		goto again;
> 	}
> 
> 	dirty all the pages
> 	release all the locks
> 
> The extra waiting, cleaning and locking are there to make sure we don't
> modify pages in flight to the drive, after they've been crc'd.
> 
> If some of the pages in the range were already dirty when the write
> began, and we need to goto again, we create a window where a dirty page
> has been cleaned and unlocked.  It may be reclaimed before we're able to
> lock it again, which means we'll read the old contents off the drive and
> lose any modifications that had been pending writeback.
> 
> We don't actually need to clean the pages.  All of the other locking in
> place makes sure we don't start IO on the pages, so we can just leave
> them dirty for the duration of the write.
> 
> Fixes: 73d59314e6ed (the original btrfs merge)
> Signed-off-by: Chris Mason <clm@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Moved from for-next to 4.20 queue.
