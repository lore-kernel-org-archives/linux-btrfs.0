Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56877 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934063AbeCGQMq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:12:46 -0500
Date: Wed, 7 Mar 2018 17:10:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix unexpected cow in run_delalloc_nocow
Message-ID: <20180307161024.GJ23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180125180256.10844-2-bo.li.liu@oracle.com>
 <20180201000913.27378-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180201000913.27378-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 05:09:13PM -0700, Liu Bo wrote:
> Fstests generic/475 provides a way to fail metadata reads while
> checking if checksum exists for the inode inside run_delalloc_nocow(),
> and csum_exist_in_range() interprets error (-EIO) as inode having
> checksum and makes its caller enters the cow path.
> 
> In case of free space inode, this ends up with a warning in
> cow_file_range().
> 
> The same problem applies for btrfs_cross_ref_exist() since it may also
> read metadata in between.
> 
> With this, run_delalloc_nocow() bails out when errors occur at the two
> places.
> 
> cc: <stable@vger.kernel.org> v2.6.28+
> Fixes: 17d217fe970d ("Btrfs: fix nodatasum handling in balancing code")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

For the record, this has been added to next some time ago and testing
was ok.
