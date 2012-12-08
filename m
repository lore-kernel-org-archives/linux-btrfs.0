Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:1025 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2LHKKt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Dec 2012 05:10:49 -0500
Message-ID: <50C31218.6070807@huawei.com>
Date: Sat, 8 Dec 2012 18:10:32 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: <chris.mason@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: make sure fs_info is not null before its field
 is used in __btrfs_panic
References: <n> <1354894924-13050-1-git-send-email-shhuiw@gmail.com>
In-Reply-To: <1354894924-13050-1-git-send-email-shhuiw@gmail.com>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/12/7 23:42, Wang Sheng-Hui wrote:
> We should make sure fs_info is not null before we refer to its field.
> Add simple check here.

Why? Is there any caller passing NULL @fs_info to this function?

> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/super.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 915ac14..c6a3633 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -280,7 +280,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
>  	vaf.va = &args;
>  
>  	errstr = btrfs_decode_error(fs_info, errno, nbuf);
> -	if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
> +	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
>  		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
>  			s_id, function, line, &vaf, errstr);
>  
> 

