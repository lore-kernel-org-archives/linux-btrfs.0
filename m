From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [patch] btrfs scrub: handle -ENOMEM from init_ipath()
Date: Wed, 16 Nov 2011 17:56:29 +0100
Message-ID: <4EC3EB3D.4030601@jan-o-sch.net>
References: <20111116082801.GE10264@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111116082801.GE10264@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On 16.11.2011 09:28, Dan Carpenter wrote:
> init_ipath() can return an ERR_PTR(-ENOMEM).
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Thanks,
-Jan

> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ed11d38..b72ee47 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -256,6 +256,11 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
>  	btrfs_release_path(swarn->path);
>  
>  	ipath = init_ipath(4096, local_root, swarn->path);
> +	if (IS_ERR(ipath)) {
> +		ret = PTR_ERR(ipath);
> +		ipath = NULL;
> +		goto err;
> +	}
>  	ret = paths_from_inode(inum, ipath);
>  
>  	if (ret < 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
