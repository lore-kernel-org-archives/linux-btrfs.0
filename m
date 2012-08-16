Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:44181 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932288Ab2HPNXb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 09:23:31 -0400
Message-ID: <502CF450.50405@gmx.net>
Date: Thu, 16 Aug 2012 15:23:28 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: trivial code style fix in root-tree.c
References: <502CF2F0.7020601@gmail.com>
In-Reply-To: <502CF2F0.7020601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16.08.2012 15:17, Wang Sheng-Hui wrote:
> Add code indent to the bad styled statements.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  root-tree.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/root-tree.c b/root-tree.c
> index 782472c..39cfef6 100644
> --- a/root-tree.c
> +++ b/root-tree.c
> @@ -182,12 +182,10 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  	if (ret < 0)
>  		goto out;
>  	if (ret) {
> -btrfs_print_leaf(root, path->nodes[0]);
> -printk("failed to del %llu %u %llu\n",
> -	(unsigned long long)key->objectid,
> -	key->type,
> -	(unsigned long long)key->offset);
> -

I guess Alexander intentionally put in the bad indentation
to remind him to remove this code before submitting the
patch :)

> +		btrfs_print_leaf(root, path->nodes[0]);
> +		printk("failed to del %llu %u %llu\n",
> +			(unsigned long long)key->objectid, key->type,
> +			(unsigned long long)key->offset);
>  	}
>  	BUG_ON(ret != 0);
>  	leaf = path->nodes[0];

