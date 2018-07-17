Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731179AbeGQMeq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 08:34:46 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28C69AE4F
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 12:02:26 +0000 (UTC)
Date: Tue, 17 Jul 2018 14:02:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/2] btrfs: scrub: Don't use inode page cache in
 scrub_handle_errored_block()
Message-ID: <20180717120220.GV3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180711054122.13727-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180711054122.13727-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 01:41:21PM +0800, Qu Wenruo wrote:
> In commit ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device
> replace") we removed the branch of copy_nocow_pages() to avoid
> corruption for compressed nodatasum extents.
> 
> However above commit only solves the problem in scrub_extent(), if
> during scrub_pages() we failed to read some pages,
> sctx->no_io_error_seen will be non-zero and we go to fixup function
> scrub_handle_errored_block().
> 
> In scrub_handle_errored_block(), for sctx without csum (no matter if
> we're doing replace or scrub) we go to scrub_fixup_nodatasum() routine,
> which does the similar thing with copy_nocow_pages(), but does it
> without the extra check in copy_nocow_pages() routine.
> 
> So for test cases like btrfs/100, where we emulate read errors during
> replace/scrub, we could corrupt compressed extent data again.
> 
> This patch will fix it just by avoiding any "optimization" for
> nodatasum, just falls back to the normal fixup routine by try read from
> any good copy.
> 
> This also solves WARN_ON() or dead lock caused by lame backref iteration
> in scrub_fixup_nodatasum() routine.
> 
> The deadlock or WARN_ON() won't be triggered before commit ac0b4145d662
> ("btrfs: scrub: Don't use inode pages for device replace") since
> copy_nocow_pages() have better locking and extra check for data extent,
> and it's already doing the fixup work by try to read data from any good
> copy, so it won't go scrub_fixup_nodatasum() anyway.
> 
> Fixes: ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device replace")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Thanks, I'll forward this to 4.18, there are a few more regression fixes
queued.
