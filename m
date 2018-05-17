Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751642AbeEQMJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 08:09:22 -0400
Date: Thu, 17 May 2018 14:06:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs: balance: add kernel log for end or paused
Message-ID: <20180517120640.GJ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516025128.9899-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 10:51:28AM +0800, Anand Jain wrote:
> Add a kernel log when the balance ends, either for cancel or completed
> or if it is paused.

Missing S-O-B.

> ---
> v1->v2: Moved from 2/3 to 3/3
> 
>  fs/btrfs/volumes.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ce68c4f42f94..a4e243a29f5c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4053,6 +4053,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>  	ret = __btrfs_balance(fs_info);
>  
>  	mutex_lock(&fs_info->balance_mutex);
> +	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
> +		btrfs_info(fs_info, "balance: paused");
> +	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
> +		btrfs_info(fs_info, "balance: canceled");
> +	else
> +		btrfs_info(fs_info, "balance: ended with status: %d", ret);

Wouldn't that repeat the same once again? There are status messages
printed already, when eg. balance is cancelled or paused.
