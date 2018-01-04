Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59036 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752908AbeADMLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jan 2018 07:11:25 -0500
Subject: Re: [PATCH 2/2] btrfS: collapse btrfs_handle_error() into
 __btrfs_handle_fs_error()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180104100155.9160-1-anand.jain@oracle.com>
 <20180104100155.9160-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <80d38945-d3db-7579-f19a-bbc87b08fa80@suse.com>
Date: Thu, 4 Jan 2018 14:11:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180104100155.9160-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.01.2018 12:01, Anand Jain wrote:
> There is no other consumer for btrfs_handle_error() other than
> __btrfs_handle_fs_error(), further this function quite small.
> Merge it into its parent.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/super.c | 43 +++++++++++++++++++------------------------
>  1 file changed, 19 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 60766f8ca434..0216a5dd0f4b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -105,28 +105,6 @@ const char *btrfs_decode_error(int errno)
>  	return errstr;
>  }
>  
> -/* btrfs handle error by forcing the filesystem readonly */
> -static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
> -{
> -	struct super_block *sb = fs_info->sb;
> -
> -	if (sb_rdonly(sb))
> -		return;
> -
> -	sb->s_flags |= SB_RDONLY;
> -	btrfs_info(fs_info, "forced readonly");
> -	/*
> -	 * Note that a running device replace operation is not
> -	 * canceled here although there is no way to update
> -	 * the progress. It would add the risk of a deadlock,
> -	 * therefore the canceling is omitted. The only penalty
> -	 * is that some I/O remains active until the procedure
> -	 * completes. The next time when the filesystem is
> -	 * mounted writeable again, the device replace
> -	 * operation continues.
> -	 */
> -}
> -
>  /*
>   * __btrfs_handle_fs_error decodes expected errors from the caller and
>   * invokes the approciate error response.
> @@ -173,8 +151,25 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
>  	set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
>  
>  	/* Don't go through full error handling during mount */
> -	if (sb->s_flags & SB_BORN)
> -		btrfs_handle_error(fs_info);
> +	if (!(sb->s_flags & SB_BORN))
> +		return;
> +
> +	if (sb_rdonly(sb))
> +		return;
> +
> +	/* btrfs handle error by forcing the filesystem readonly */
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
>  #ifdef CONFIG_PRINTK
> 
