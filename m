Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754471AbdFWSMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 14:12:36 -0400
Date: Fri, 23 Jun 2017 20:11:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, davej@codemonkey.org.uk
Subject: Re: [PATCH v2] btrfs: fix integer overflow in calc_reclaim_items_nr
Message-ID: <20170623181126.GD2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170623164821.1720197-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170623164821.1720197-1-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 09:48:21AM -0700, Chris Mason wrote:
> Dave Jones hit a WARN_ON(nr < 0) in btrfs_wait_ordered_roots() with
> v4.12-rc6.  This was because commit 70e7af244 made it possible for
> calc_reclaim_items_nr() to return a negative number.  It's not really a
> bug in that commit, it just didn't go far enough down the stack to find
> all the possible 64->32 bit overflows.
> 
> This switches calc_reclaim_items_nr() to return a u64 and changes everyone
> that uses the results of that math to u64 as well.
> 
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Fixes: 70e7af2 ("Btrfs: fix delalloc accounting leak caused by u32 overflow")
> Signed-off-by: Chris Mason <clm@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
