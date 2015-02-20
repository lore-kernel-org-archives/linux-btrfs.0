Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbbBTOf2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 09:35:28 -0500
Date: Fri, 20 Feb 2015 15:35:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix allocation size calculations in
 alloc_btrfs_bio
Message-ID: <20150220143526.GS8720@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150220015930.GA28726@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150220015930.GA28726@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 19, 2015 at 08:59:30PM -0500, Chris Mason wrote:
> Since commit 8e5cfb55d3f (Btrfs: Make raid_map array be inlined in
> btrfs_bio structure), the raid map array is allocated along with the
> btrfs bio in alloc_btrfs_bio.  The calculation used to decide how much
> we need to allocate was using the wrong parameter passed into the
> allocation function.
> 
> The passed in real_stripes will be zero if a target replace operation
> is not currently running.  We want to use total_stripes instead.
> 
> Signed-off-by: Chris Mason <clm@fb.com>
> Reported-by: Dave Sterba <dsterba@suse.cz>

Tested-by: David Sterba <dsterba@suse.cz>

Current master + this patch with full slub_debug is now ok with
btrfs/023.
