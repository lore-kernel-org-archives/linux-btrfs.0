Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35034 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752291AbeA3NdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 08:33:23 -0500
Date: Tue, 30 Jan 2018 14:31:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected cow in run_delalloc_nocow
Message-ID: <20180130133110.GD19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180125180256.10844-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:49AM -0700, Liu Bo wrote:
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

This and the other fixes sent in this batch have been added to next and
I'm going to push them to 4.16 either during the merge window still or
at rc1 time. Thanks.
