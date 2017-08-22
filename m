Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933001AbdHVPqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 11:46:10 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30E9BABB4
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 15:46:09 +0000 (UTC)
Date: Tue, 22 Aug 2017 17:44:45 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] btrfs-progs: extent-cache: actually cache extent
 buffers
Message-ID: <20170822154445.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-3-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170725205138.28376-3-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:51:34PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> We have the infrastructure to cache extent buffers but we don't actually
> do the caching.  As soon as the last reference is dropped, the buffer
> is dropped.  This patch keeps the extent buffers around until the max
> cache size is reached (defaults to 25% of memory) and then it drops
> the last 10% of the LRU to free up cache space for reallocation.  The
> cache size is configurable (for use by e.g. lowmem) when the cache is
> initialized.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I've started to merge the series, changed code according to the review.
In this patch, test-mkfs and test-check fail (segfaults and assertions).
A debugging build or asan (make D=all,asan) does not reproduce the
errors so this will need to be found by other means.

I also fixed some trivial coding style issues, so the changes are now in
the branch
https://github.com/kdave/btrfs-progs/tree/ext/jeffm/extent-cache

Please use this as a starting point, I'm fine with resending just this
patch or an incremental.
