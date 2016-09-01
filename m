Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752547AbcIAOdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 10:33:19 -0400
Subject: Re: [PATCH] btrfs: create example debugfs file only in debugging
 build
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1472733872-32549-1-git-send-email-dsterba@suse.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <7384afe4-fc2c-d11b-e625-e80a12f7cf52@redhat.com>
Date: Thu, 1 Sep 2016 09:33:18 -0500
MIME-Version: 1.0
In-Reply-To: <1472733872-32549-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/1/16 7:44 AM, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/btrfs/sysfs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 804bd1c42e47..31f09564e170 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -836,9 +836,18 @@ static int btrfs_init_debugfs(void)
>  	if (!btrfs_debugfs_root_dentry)
>  		return -ENOMEM;
>  
> +	/*
> +	 * Example code, how export data through debugfs.
> +	 *
> +	 * file:        /sys/kernel/debug/btrfs/test
> +	 * contents of: btrfs_debugfs_test
> +	 */
> +#ifdef CONFIG_BTRFS_DEBUG
>  	debugfs_create_u64("test", S_IRUGO | S_IWUSR, btrfs_debugfs_root_dentry,
>  			&btrfs_debugfs_test);
>  #endif
> +
> +#endif
>  	return 0;
>  }
>  
> 

