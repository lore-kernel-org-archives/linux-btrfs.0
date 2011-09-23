From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] btrfs/ioctl.c: quiet sparse warnings
Date: Fri, 23 Sep 2011 11:15:59 -0700
Message-ID: <1316801760.28330.5.camel@Joe-Laptop>
References: <201109231107.54227.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201109231107.54227.hartleys@visionengravers.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2011-09-23 at 11:07 -0700, H Hartley Sweeten wrote:
> Quiet the following sparse warnings:
[]
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
[]
> @@ -2705,7 +2705,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
>  		up_read(&info->groups_sem);
>  	}
>  
> -	user_dest = (struct btrfs_ioctl_space_info *)
> +	user_dest = (struct btrfs_ioctl_space_info __user *)
>                 (arg + sizeof(struct btrfs_ioctl_space_args));

	user_dest = arg;
	user_dest++;

?


