Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27562 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752733AbbJUJMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 05:12:19 -0400
Subject: Re: [RFC PATCH 2/3] btrfs-progs: kernel based default features for
 mkfs
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <1445417149-804-2-git-send-email-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <562756ED.1090302@cn.fujitsu.com>
Date: Wed, 21 Oct 2015 17:12:13 +0800
MIME-Version: 1.0
In-Reply-To: <1445417149-804-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/10/21 16:45 +0800:
> mkfs from latest btrfs-progs will enable latest default features,
> and if the kernel is down-rev and does not support a latest default
> feature then mount fails, as expected.
>
> This patch disables default features based on the running kernel.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   mkfs.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mkfs.c b/mkfs.c
> index a5802f7..2b9d734 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1357,10 +1357,13 @@ int main(int ac, char **av)
>   	int dev_cnt = 0;
>   	int saved_optind;
>   	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
> -	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
> +	u64 features;
>   	struct mkfs_allocation allocation = { 0 };
>   	struct btrfs_mkfs_config mkfs_cfg;
>
> +	features = btrfs_features_allowed_by_kernel();
> +	features &= BTRFS_MKFS_DEFAULT_FEATURES;
> +

Despite the problem of btrfs_features_allowed_by_kernel() I mentioned in 
previous mail,
the behavior is a little aggressive for me.

So a user with old kernel won't be able to create a filesystem with 
newer feature forever.
Maybe the user are just making btrfs for his or her newer kernel?

IMHO, it's better to output a warning other than just change features 
without any information.

Thanks,
Qu

>   	while(1) {
>   		int c;
>   		static const struct option long_options[] = {
>
