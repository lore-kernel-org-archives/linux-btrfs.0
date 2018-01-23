Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33387 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751813AbeAWQpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 11:45:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 639E2AD00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 16:45:03 +0000 (UTC)
Date: Tue, 23 Jan 2018 17:42:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Prevent temporary system chunk to
 use space in reserved 1M range
Message-ID: <20180123164253.GN15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180110045648.3239-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180110045648.3239-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:56:47PM +0800, Qu Wenruo wrote:
> When creating btrfs, mkfs.btrfs will firstly create a temporary system
> chunk as basis, and then created needed trees or new devices.
> 
> However the layout temporary system chunk is hard-coded and uses
> reserved [0, 1M) range of devid 1.
> 
> Change the temporary chunk layout from old:
> 
> 0	1M				4M	5M
> |<----------- temp chunk -------------->|
>   And it's 1:1 mapped, which means it's a SINGLE chunk,
>   and stripe offset is also 0.
> 
> to new layout:
> 
> 0	1M				4M	5M
> 	|<----------- temp chunk -------------->|
>   And still keeps the 1:1 mapping.
> 
> The problem can only be exposed by "-m single" or "-M" where we reuse the
> temporary chunk.
> 
> With other meta profiles, system and meta chunks are allocated by later
> btrfs_alloc_chunk() call, and old SINGLE chunks are removed, so it will
> be no such problem for other meta profiles.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

The test mkfs-tests/010-minimal-size fails with this patch (devel
branch). I've added some debugging and the requested minimal size by
mkfs is not sufficient. I think it's because of the 1MB shift but
haven't looked closely.

The math in "btrfs-progs: mkfs: move source dir size calculation to its
own files" may need to be updated, I'm not sure how exactly to do that.
It would be good if you find the fix and we'll then see where to put it
(separate patch or fold it to some other one).

Otherwise I'm going to apply patches 1 and 2, thanks.
