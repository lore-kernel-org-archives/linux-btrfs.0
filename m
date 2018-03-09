Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeCIPv6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 10:51:58 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E66A3AF2D
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 15:51:56 +0000 (UTC)
Date: Fri, 9 Mar 2018 16:49:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: free-space-cache: Enhance free space
 cache free space check
Message-ID: <20180309154936.GV23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180308070231.28876-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180308070231.28876-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 03:02:31PM +0800, Qu Wenruo wrote:
> When we found free space difference between free space cache and block
> group item, we just discard this free space cache.
> 
> Normally such difference is caused by btrfs_reserve_extent() called by
> delalloc which is out of a transaction.
> And since all btrfs_release_extent() is called with a transaction, under
> heavy race free space cache can have less free space than block group
> item.
> 
> Normally kernel will detect such difference and just discard that cache.
> 
> However we must be more careful if free space cache has more free space
> cache, and if that happens, paried with above race one invalid free
> space cache can be loaded into kernel.
> 
> So if we find any free space cache who has more free space then block
> group item, we report it as an error other than ignoring it.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> v2:
>   Fix the timming of free space output.

I'll apply the v2 patch, thanks. The message can be updated with manual
page together.
