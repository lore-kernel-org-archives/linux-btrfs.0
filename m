Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59723 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751015AbdEBOQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 10:16:39 -0400
Date: Tue, 2 May 2017 16:16:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix memory leak when 0 sized block group
 item is found
Message-ID: <20170502141632.GF23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170425080117.18694-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170425080117.18694-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 25, 2017 at 04:01:17PM +0800, Qu Wenruo wrote:
> When a 0 sized block group item is found, set_extent_bits() will not
> really set any bits.
> While set_state_private() still inserts allocated block group cache into
> block group extent_io_tree.
> 
> So at close_ctree() time, we won't free the private block group cache
> stored since we can't find any bit set for the 0 sized block group.
> 
> To fix it, at btrfs_read_block_groups() we skip any 0 sized block group,
> so such leak won't happen.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
