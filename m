From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix memory leak in btrfs_ioctl_start_sync()
Date: Mon, 04 Apr 2011 10:52:13 +0900
Message-ID: <4D99244D.5050704@jp.fujitsu.com>
References: <4D991A3B.9020805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D991A3B.9020805@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry. Ignore previous patch.
New patch is as follows.

Thanks,
Tsutomu

(2011/04/04 10:09), Tsutomu Itoh wrote:
> Free btrfs_trans_handle if btrfs_commit_transaction_async() fails.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -urNp linux-2.6.39-rc1/fs/btrfs/ioctl.c linux-2.6.39-rc1.new/fs/btrfs/ioctl.c
> --- linux-2.6.39-rc1/fs/btrfs/ioctl.c	2011-03-30 04:09:47.000000000 +0900
> +++ linux-2.6.39-rc1.new/fs/btrfs/ioctl.c	2011-04-04 09:52:17.000000000 +0900
> @@ -2436,8 +2436,10 @@ static noinline long btrfs_ioctl_start_s
>  		return PTR_ERR(trans);
>  	transid = trans->transid;
>  	ret = btrfs_commit_transaction_async(trans, root, 0);
> -	if (ret)
> +	if (ret) {
> +		kmem_cache_free(btrfs_trans_handle_cachep, trans);
>  		return ret;
> +	}
>  
>  	if (argp)
>  		if (copy_to_user(argp, &transid, sizeof(transid)))
> 


Call btrfs_end_transaction() if btrfs_commit_transaction_async() fails.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -urNp linux-2.6.39-rc1/fs/btrfs/ioctl.c linux-2.6.39-rc1.new/fs/btrfs/ioctl.c
--- linux-2.6.39-rc1/fs/btrfs/ioctl.c	2011-03-30 04:09:47.000000000 +0900
+++ linux-2.6.39-rc1.new/fs/btrfs/ioctl.c	2011-04-04 10:46:45.000000000 +0900
@@ -2436,8 +2436,10 @@ static noinline long btrfs_ioctl_start_s
 		return PTR_ERR(trans);
 	transid = trans->transid;
 	ret = btrfs_commit_transaction_async(trans, root, 0);
-	if (ret)
+	if (ret) {
+		btrfs_end_transaction(trans, root);
 		return ret;
+	}
 
 	if (argp)
 		if (copy_to_user(argp, &transid, sizeof(transid)))


