Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KECaJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 21:30:09 -0500
Message-ID: <52785873.6050106@cn.fujitsu.com>
Date: Tue, 05 Nov 2013 10:31:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com, majianpeng <majianpeng@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG]:bad unlock balance detected!
References: <201311050933582618320@gmail.com> <20131105021216.GA15974@localhost.localdomain>
In-Reply-To: <20131105021216.GA15974@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	tue, 5 Nov 2013 10:12:17 +0800, Liu Bo wrote:
> Hi,
> 
> Would you please try the following patch?
> 
> -liubo
> 
> From: Liu Bo <bo.li.liu@oracle.com>
> Subject: [PATCH] Btrfs: fix to use the right trans for async commit
> 
> @trans has been freed and is undefined, and we should use the trans
> handle created for async commit instead.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/transaction.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 8c81bdc..648d839 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1494,7 +1494,7 @@ int btrfs_commit_transaction_async(struct
> btrfs_trans_handle *trans,
>  	 * Tell lockdep we've released the freeze rwsem, since the
>  	 * async commit thread will be the one to unlock it.
>  	 */
> -	if (trans->type < TRANS_JOIN_NOLOCK)
> +	if (ac->newtrans->type < TRANS_JOIN_NOLOCK)

It should be:

if (trans->type & __TRANS_FREEZABLE)

The same for

do_async_commit()

>  		rwsem_release(
>  			&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
>  			1, _THIS_IP_);
> 

