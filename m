Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726881AbeIKRtK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 13:49:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09CC1AFD2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 12:49:58 +0000 (UTC)
Date: Tue, 11 Sep 2018 16:49:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print-tree: Skip deprecated blockptr /
 nodesize output
Message-ID: <20180911144944.GD2997@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180823061129.9412-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180823061129.9412-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 02:11:29PM +0800, Qu Wenruo wrote:
> When printing tree nodes, we output slots like:
> key (EXTENT_TREE ROOT_ITEM 0) block 73625600 (17975) gen 16
> 
> The number in the parentheses is blockptr / nodesize.
> 
> However this number doesn't really do any thing useful.
> And in fact for unaligned metadata block group (block group start bytenr
> is not aligned to 16K), the number doesn't even make sense as it's
> rounded down.
> 
> In factor kernel doesn't ever output such divided result in its
> print-tree.c
> 
> Remove it so later reader won't wonder what the number means.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
