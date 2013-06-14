Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3FNJdc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 05:33:32 -0400
Message-ID: <51BAE233.5080608@cn.fujitsu.com>
Date: Fri, 14 Jun 2013 17:28:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix the comment typo for btrfs_attach_transaction_barrier
References: <CAKXJSOEhk5tYpJd3L4r9zNsEFHRihz+tZXv4hZ5gAmDF_1G9cQ@mail.gmail.com>
In-Reply-To: <CAKXJSOEhk5tYpJd3L4r9zNsEFHRihz+tZXv4hZ5gAmDF_1G9cQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 14 Jun 2013 16:21:24 +0800, Wang Sheng-Hui wrote:
> The comment is for btrfs_attach_transaction_barrier, not for
> btrfs_attach_transaction. Fix the typo.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

My miss, sorry.

Acked-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/transaction.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 0544587..6d4c595 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -490,7 +490,7 @@ struct btrfs_trans_handle
> *btrfs_attach_transaction(struct btrfs_root *root)
>  }
> 
>  /*
> - * btrfs_attach_transaction() - catch the running transaction
> + * btrfs_attach_transaction_barrier() - catch the running transaction
>   *
>   * It is similar to the above function, the differentia is this one
>   * will wait for all the inactive transactions until they fully
> 

