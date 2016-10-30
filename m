Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752800AbcJaBJF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 21:09:05 -0400
Date: Sun, 30 Oct 2016 16:36:06 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, david@fromorbit.com,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, jweiner@fb.com
Subject: Re: [PATCH 3/5] writeback: add counters for metadata usage
Message-ID: <20161030153606.GB17039@quack2.suse.cz>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-4-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477420904-1399-4-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 25-10-16 14:41:42, Josef Bacik wrote:
> Btrfs has no bounds except memory on the amount of dirty memory that we have in
> use for metadata.  Historically we have used a special inode so we could take
> advantage of the balance_dirty_pages throttling that comes with using pagecache.
> However as we'd like to support different blocksizes it would be nice to not
> have to rely on pagecache, but still get the balance_dirty_pages throttling
> without having to do it ourselves.
> 
> So introduce *METADATA_DIRTY_BYTES and *METADATA_WRITEBACK_BYTES.  These are
> zone and bdi_writeback counters to keep track of how many bytes we have in
> flight for METADATA.  We need to count in bytes as blocksizes could be
> percentages of pagesize.  We simply convert the bytes to number of pages where
> it is needed for the throttling.
> 
> Also introduce NR_METADATA_BYTES so we can keep track of the total amount of
> pages used for metadata on the system.  This is also needed so things like dirty
> throttling know that this is dirtyable memory as well and easily reclaimed.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
