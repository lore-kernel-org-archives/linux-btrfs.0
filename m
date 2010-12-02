From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH 2/4 v2] Btrfs: avoid transaction stuff when readonly
Date: Thu, 02 Dec 2010 11:42:04 +0800
Message-ID: <4CF7158C.30801@cn.fujitsu.com>
References: <4CF62169.8000702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF62169.8000702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2010 06:20 PM, liubo wrote:
> When the filesystem is readonly, avoid transaction stuff by checking MS_RDONLY at 
> start transaction time.
> 

This patch may lead btrfs panic.

Since btrfs allows transaction under readonly fs state, which is a bit weird, btrfs
does not even check the returned transaction from start_transaction, although it may
return -ENOMEM. 

With this patch, if btrfs flips readonly or is mounted readonly, to start a transaction
will get a -EROFS. So we needs to check transaction more carefully, rather than just
leave it alone.

thanks,
Liu Bo

> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/transaction.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 1fffbc0..14a597d 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -181,6 +181,9 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>  	struct btrfs_trans_handle *h;
>  	struct btrfs_transaction *cur_trans;
>  	int ret;
> +
> +	if (root->fs_info->sb->s_flags & MS_RDONLY)
> +		return ERR_PTR(-EROFS);
>  again:
>  	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
>  	if (!h)

