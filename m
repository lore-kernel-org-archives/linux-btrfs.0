From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 4/4] Add fallocate support v2
Date: Thu, 30 Oct 2008 14:20:53 -0400
Message-ID: <1225390853.6533.27.camel@think.oraclecorp.com>
References: <4909E8B3.6070409@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, ukernel@gmail.com
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4909E8B3.6070409@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-31 at 01:02 +0800, Yan Zheng wrote:
> Hello,
> 
> This patch updates btrfs-progs for fallocate support.

Thanks for rediffing these, one question though:

> diff -urp 4/fs/btrfs/ctree.h 5/fs/btrfs/ctree.h
> --- 4/fs/btrfs/ctree.h	2008-10-30 13:45:33.000000000 +0800
> +++ 5/fs/btrfs/ctree.h	2008-10-30 14:21:24.000000000 +0800
> @@ -462,8 +462,9 @@ struct btrfs_root_item {
>  	u8 level;
>  } __attribute__ ((__packed__));
>  
> -#define BTRFS_FILE_EXTENT_REG 0
> -#define BTRFS_FILE_EXTENT_INLINE 1
> +#define BTRFS_FILE_EXTENT_INLINE 0
> +#define BTRFS_FILE_EXTENT_REG 1
> +#define BTRFS_FILE_EXTENT_PREALLOC 2

Why do we swap these around?

-chris


