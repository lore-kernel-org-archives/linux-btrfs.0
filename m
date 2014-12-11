Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28773 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756252AbaLKHmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 02:42:11 -0500
Message-ID: <54894ACF.8050000@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 15:42:07 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <mwilck@arcor.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 01/18] btrfs-progs: btrfs-debug-tree: add option -f for
 "block only"
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de> <1418244708-7087-2-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-2-git-send-email-mwilck@arcor.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 01/18] btrfs-progs: btrfs-debug-tree: add option -f for 
"block only"
From: <mwilck@arcor.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月11日 04:51
> From: Martin Wilck <mwilck@arcor.de>
>
> btrfs-debug-tree prints only the given block. It is sometimes
> useful to be able to print the subtree under this block.
> This patch enables this behavior with the option "-f".
>
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>   btrfs-debug-tree.c |   10 ++++++++--
>   1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
> index e46500d..e61c71c 100644
> --- a/btrfs-debug-tree.c
> +++ b/btrfs-debug-tree.c
> @@ -41,6 +41,8 @@ static int print_usage(void)
>   	fprintf(stderr, "\t-u : print info of uuid tree only\n");
>   	fprintf(stderr, "\t-b block_num : print info of the specified block"
>                       " only\n");
> +	fprintf(stderr, "\t-f : (with -b) follow subtree of the specified"
> +		" block\n");
>   	fprintf(stderr,
>   		"\t-t tree_id : print only the tree with the given id\n");
>   	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
> @@ -137,6 +139,7 @@ int main(int ac, char **av)
>   	int roots_only = 0;
>   	int root_backups = 0;
>   	u64 block_only = 0;
> +	int block_follow = 0;
>   	struct btrfs_root *tree_root_scan;
>   	u64 tree_id = 0;
>   
> @@ -144,7 +147,7 @@ int main(int ac, char **av)
>   
>   	while(1) {
>   		int c;
> -		c = getopt(ac, av, "deb:rRut:");
> +		c = getopt(ac, av, "defb:rRut:");
>   		if (c < 0)
>   			break;
>   		switch(c) {
> @@ -167,6 +170,9 @@ int main(int ac, char **av)
>   			case 'b':
>   				block_only = arg_strtou64(optarg);
>   				break;
> +			case 'f':
> +				block_follow = 1;
> +				break;
>   			case 't':
>   				tree_id = arg_strtou64(optarg);
>   				break;
> @@ -211,7 +217,7 @@ int main(int ac, char **av)
>   				(unsigned long long)block_only);
>   			goto close_root;
>   		}
> -		btrfs_print_tree(root, leaf, 0);
> +		btrfs_print_tree(root, leaf, block_follow);
Although not a bug of your patch, but would you please fix the extent 
buffer leak by
adding a free_extent_buffer(buf)?

Thanks,
Qu
>   		goto close_root;
>   	}
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
