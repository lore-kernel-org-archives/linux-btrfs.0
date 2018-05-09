Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934840AbeEINDK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:03:10 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86C8BAEA6
        for <linux-btrfs@vger.kernel.org>; Wed,  9 May 2018 13:03:09 +0000 (UTC)
Date: Wed, 9 May 2018 15:00:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Finish rescan when hit the last leaf of
 extent tree
Message-ID: <20180509130030.GY6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180504055659.1862-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180504055659.1862-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2018 at 01:56:59PM +0800, Qu Wenruo wrote:
> Under the following case, qgroup rescan can double account cowed tree
> blocks:
> 
> In this case, extent tree only has one tree block.
> 
> -
> | transid=5 last committed=4
> | btrfs_qgroup_rescan_worker()
> | |- btrfs_start_transaction()
> | |  transid = 5
> | |- qgroup_rescan_leaf()
> |    |- btrfs_search_slot_for_read() on extent tree
> |       Get the only extent tree block from commit root (transid = 4).
> |       Scan it, set qgroup_rescan_progress to the last
> |       EXTENT/META_ITEM + 1
> |       now qgroup_rescan_progress = A + 1.
> |
> | fs tree get CoWed, new tree block is at A + 16K
> | transid 5 get committed
> -
> | transid=6 last committed=5
> | btrfs_qgroup_rescan_worker()
> | btrfs_qgroup_rescan_worker()
> | |- btrfs_start_transaction()
> | |  transid = 5
> | |- qgroup_rescan_leaf()
> |    |- btrfs_search_slot_for_read() on extent tree
> |       Get the only extent tree block from commit root (transid = 5).
> |       scan it using qgroup_rescan_progress (A + 1).
> |       found new tree block beyong A, and it's fs tree block,
> |       account it to increase qgroup numbers.
> -
> 
> In above case, tree block A, and tree block A + 16K get accounted twice,
> while qgroup rescan should stop when it already reach the last leaf,
> other than continue using its qgroup_rescan_progress.
> 
> Such case could happen by just looping btrfs/017 and with some
> possibility it can hit such double qgroup accounting problem.
> 
> Fix it by checking the path to determine if we should finish qgroup
> rescan, other than relying on next loop to exit.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Is this something for 4.17-rc ?
