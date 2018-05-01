Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38949 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbeEANqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 09:46:40 -0400
Date: Tue, 1 May 2018 15:44:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: modify path->reada in btrfs_shrink_device to
 READA_BACK
Message-ID: <20180501134404.GS21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524817327-32038-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524817327-32038-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 04:22:07PM +0800, Gu Jinxiang wrote:
> In btrfs_shrink_device, before btrfs_search_slot, path->reada is
> set to READA_FORWARD. But I think READA_BACK is correct.
> Since,
>  1.key.offset is set to (u64)-1
>  2.After btrfs_search_slot, btrfs_previous_item is called.
> So, for readahead previous items, READA_BACK is correct one.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Added to next, thanks.
