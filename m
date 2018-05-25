Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50825 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936316AbeEYOim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 10:38:42 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F5F6ADF5
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 14:38:41 +0000 (UTC)
Date: Fri, 25 May 2018 16:35:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: More meaningful qgroup_rescan_init error
 message
Message-ID: <20180525143558.GM6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180502052803.4222-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180502052803.4222-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2018 at 01:28:03PM +0800, Qu Wenruo wrote:
> Error message from qgroup_rescan_init() mostly looks like:
> 
> ------
> BTRFS info (device nvme0n1p1): qgroup_rescan_init failed with -115
> ------
> 
> Which is far from meaningful, and sometimes confusing as for above
> -EINPROGRESS it's mostly (despite the init race) harmless, but sometimes
> it can also indicates problem if return value is -EINVAL.
> 
> Change it to some more meaningful messages like:
> 
> ------
> BTRFS info (device nvme0n1p1): qgroup rescan is already in progress
> ------
> 
> And
> 
> ------
> BTRFS err(device nvme0n1p1): qgroup_rescan_init failed, qgroup is not enabled
> ------
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index ec2339a49ec3..a5742e9e9a14 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2760,26 +2760,37 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>  {
>  	int ret = 0;
>  
> -	if (!init_flags &&
> -	    (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) ||
> -	     !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))) {
> -		ret = -EINVAL;
> -		goto err;
> +	if (!init_flags) {
> +		/* we're resuming qgroup rescan at mount time */
> +		if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
> +			btrfs_err(fs_info, "%s failed, qgroup is not enabled",
> +				  __func__);

I've updated this to avoid the function name as it's supposed to be a
user message, but it's the same string without the _. Also the error
level was originally info, but as you now filter the important messages,
from the wording I'd say they're warnings not really errors.

Anyway, updated and added to misc-next, thanks.
