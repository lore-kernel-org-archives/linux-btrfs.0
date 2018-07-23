Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388449AbeGWNa6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 09:30:58 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46465ACB5
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 12:29:59 +0000 (UTC)
Date: Mon, 23 Jul 2018 14:29:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: extent-tree: Remove dead alignment check
Message-ID: <20180723122951.GJ26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180723064729.9236-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180723064729.9236-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2018 at 02:47:29PM +0800, Qu Wenruo wrote:
> In find_free_extent() under checks: tag, we have the following code
> 
> ------
> 		search_start = ALIGN(offset, fs_info->stripesize);
> 		/* move on to the next group */
> 		if (search_start + num_bytes >
> 		    block_group->key.objectid + block_group->key.offset) {
> 			btrfs_add_free_space(block_group, offset, num_bytes);
> 			goto loop;
> 		}
> 		if (offset < search_start)
> 			btrfs_add_free_space(block_group, offset,
> 					     search_start - offset);
> 		BUG_ON(offset > search_start);
> ------
> 
> However ALIGN() is rounding up, thus @search_start >= @offset and that
> BUG_ON() will never be triggered.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
