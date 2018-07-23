Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388029AbeGWPCh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:02:37 -0400
Date: Mon, 23 Jul 2018 16:01:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/7] btrfs: warn for num_devices below 0
Message-ID: <20180723140103.GN26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716145812.20836-6-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 10:58:10PM +0800, Anand Jain wrote:
> In preparation to de-duplicate a section of code where we deduce the
> num_devices, use warn instead of bug.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 7f4973fc2b52..0f4c512aa6b4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3726,7 +3726,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>  	num_devices = fs_info->fs_devices->num_devices;
>  	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>  	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> -		BUG_ON(num_devices < 1);
> +		WARN_ON(num_devices < 1);

I wonder if there any valid cases when there are 0 devices when balance
is started, ie. before num_devices gets decremented.

The WARN_ON is either redundant or should be turned to a proper sanity
check.

>  		num_devices--;
