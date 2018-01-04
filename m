Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752408AbeADNVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jan 2018 08:21:05 -0500
Subject: Re: [PATCH 1/2] btrfs: remove check for BTRFS_FS_STATE_ERROR which we
 just set
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180104100155.9160-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <20ed0a25-2c0a-43ea-fd10-64de82e40e3b@suse.com>
Date: Thu, 4 Jan 2018 15:21:03 +0200
MIME-Version: 1.0
In-Reply-To: <20180104100155.9160-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.01.2018 12:01, Anand Jain wrote:
> __btrfs_handle_fs_error() sets BTRFS_FS_STATE_ERROR, and calls
> btrfs_handle_error() so no need to check if the BTRFS_FS_STATE_ERROR
> is set in btrfs_handle_error(). And there is no other user of
> btrfs_handle_error() as well.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/super.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4c49bb5632a2..60766f8ca434 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -113,20 +113,18 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
>  	if (sb_rdonly(sb))
>  		return;
>  
> -	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
> -		sb->s_flags |= SB_RDONLY;
> -		btrfs_info(fs_info, "forced readonly");
> -		/*
> -		 * Note that a running device replace operation is not
> -		 * canceled here although there is no way to update
> -		 * the progress. It would add the risk of a deadlock,
> -		 * therefore the canceling is omitted. The only penalty
> -		 * is that some I/O remains active until the procedure
> -		 * completes. The next time when the filesystem is
> -		 * mounted writeable again, the device replace
> -		 * operation continues.
> -		 */
> -	}
> +	sb->s_flags |= SB_RDONLY;
> +	btrfs_info(fs_info, "forced readonly");
> +	/*
> +	 * Note that a running device replace operation is not
> +	 * canceled here although there is no way to update
> +	 * the progress. It would add the risk of a deadlock,
> +	 * therefore the canceling is omitted. The only penalty
> +	 * is that some I/O remains active until the procedure
> +	 * completes. The next time when the filesystem is
> +	 * mounted writeable again, the device replace
> +	 * operation continues.
> +	 */
>  }
>  
>  /*
> 
