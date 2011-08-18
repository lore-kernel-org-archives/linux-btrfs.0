From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix d_off in the first dirent
Date: Thu, 18 Aug 2011 10:12:01 +0800
Message-ID: <4E4C74F1.1000701@cn.fujitsu.com>
References: <4E4B888D.6070904@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4B888D.6070904@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 15fceef..9c1297b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4125,7 +4125,8 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
>  
>  	/* special case for "." */
>  	if (filp->f_pos == 0) {
> -		over = filldir(dirent, ".", 1, 1, btrfs_ino(inode), DT_DIR);
> +		over = filldir(dirent, ".", 1,
> +			       filp->f_pos, inode->i_ino, DT_DIR);

please stick to btrfs_ino().

>  		if (over)
>  			return 0;
>  		filp->f_pos = 1;
