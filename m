Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756032AbeDZNJS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 09:09:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 63038ACBD
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 13:09:17 +0000 (UTC)
Date: Thu, 26 Apr 2018 15:06:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
Message-ID: <20180426130644.GS21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426062425.8574-1-wqu@suse.com>
 <606c532d-c641-ac55-8d17-4b8c8beacfdb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <606c532d-c641-ac55-8d17-4b8c8beacfdb@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 09:27:11AM +0300, Nikolay Borisov wrote:
> 
> 
> On 26.04.2018 09:24, Qu Wenruo wrote:
> > fs_info can be extracted from btrfs_block_group_cache, and all
> > btrfs_block_group_cache is created by btrfs_create_block_group_cache()
> > with fs_info initialized, no need to worry about NULL pointer
> > dereference.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> I very  much hate function which take parameters solely for the purpose
> of trace points!
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
