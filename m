From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix memory leak in start_transaction()
Date: Mon, 04 Apr 2011 09:14:13 +0900
Message-ID: <4D990D55.1000504@jp.fujitsu.com>
References: <1301833888-31238-1-git-send-email-yoshinori.sano@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org
To: Yoshinori Sano <yoshinori.sano@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301833888-31238-1-git-send-email-yoshinori.sano@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/04/03 21:31), Yoshinori Sano wrote:
> Free btrfs_trans_handle when join_transaction() fails
> in start_transaction()

Woops! It's my mistake in http://marc.info/?l=linux-btrfs&m=130086817629289&w=2.
Thanks for the point.

---
Tsutomu

> 
> Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
> ---
>  fs/btrfs/transaction.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ce48eb5..d01cc24 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -197,6 +197,7 @@ again:
>  
>  	ret = join_transaction(root);
>  	if (ret < 0) {
> +		kmem_cache_free(btrfs_trans_handle_cachep, h);
>  		if (type != TRANS_JOIN_NOLOCK)
>  			mutex_unlock(&root->fs_info->trans_mutex);
>  		return ERR_PTR(ret);

