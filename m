Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753382AbeD1Rrq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 13:47:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7906CACD5
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 17:47:45 +0000 (UTC)
Date: Sat, 28 Apr 2018 19:45:11 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
Message-ID: <20180428174511.GL21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426062425.8574-1-wqu@suse.com>
 <20180428164206.GI21272@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180428164206.GI21272@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 28, 2018 at 06:42:06PM +0200, David Sterba wrote:
> On Thu, Apr 26, 2018 at 02:24:25PM +0800, Qu Wenruo wrote:
> > fs_info can be extracted from btrfs_block_group_cache, and all
> > btrfs_block_group_cache is created by btrfs_create_block_group_cache()
> > with fs_info initialized, no need to worry about NULL pointer
> > dereference.
> 
> Famous last words.

And it's a false alert, it's caused by another patch yet to be
identified.
