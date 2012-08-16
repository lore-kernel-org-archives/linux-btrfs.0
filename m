Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:44807 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755719Ab2HPIDU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 04:03:20 -0400
Message-ID: <502CA945.602@gmx.net>
Date: Thu, 16 Aug 2012 10:03:17 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction
References: <502CA7E6.8020004@gmail.com>
In-Reply-To: <502CA7E6.8020004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16.08.2012 09:57, Wang Sheng-Hui wrote:
> For malloc may fail, we should check it before assign
> values to the fields of struct btrfs_trans_handle *h.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  transaction.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/transaction.h b/transaction.h
> index a1070e0..d4e42a1 100644
> --- a/transaction.h
> +++ b/transaction.h
> @@ -32,7 +32,12 @@ static inline struct btrfs_trans_handle *
>  btrfs_start_transaction(struct btrfs_root *root, int num_blocks)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +
>  	struct btrfs_trans_handle *h = malloc(sizeof(*h));
> +	if (!h) {
> +		BUG();
> +		return NULL;
> +	}

a more simple way would be to write
BUG_ON(!h);

>  
>  	BUG_ON(root->commit_root);
>  	BUG_ON(fs_info->running_transaction);

