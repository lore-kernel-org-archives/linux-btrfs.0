Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37866 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752414AbdHROP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 10:15:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2CF6AF04
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 14:15:24 +0000 (UTC)
Date: Fri, 18 Aug 2017 16:14:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: remove superfluous chunk_tree argument from
 btrfs_alloc_dev_extent
Message-ID: <20170818141402.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501176997-24059-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501176997-24059-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 08:36:36PM +0300, Nikolay Borisov wrote:
> Currently this function is always called with the object id of the root key of
> the chunk_tree, which is always BTRFS_CHUNK_TREE_OBJECTID. So let's subsume it
> straight into the function itself. No functional change.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1c0a5fff0e2f..5a1913956f20 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1578,8 +1578,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
>  
>  static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>  				  struct btrfs_device *device,
> -				  u64 chunk_tree, u64 chunk_offset, u64 start,
> -				  u64 num_bytes)
> +				  u64 chunk_offset, u64 start, u64 num_bytes)

This hunk does not apply, the context in git contains u64 chunk_objectid
and I haven't found any patch that would remove or rename it. Please
refresh and resend.
