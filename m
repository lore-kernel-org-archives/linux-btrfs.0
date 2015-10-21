Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23628 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbbJUJMp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 05:12:45 -0400
Subject: Re: [RFC PATCH 3/3] btrfs-progs: kernel based default features for
 btrfs-convert
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <1445417149-804-3-git-send-email-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56275706.7080507@cn.fujitsu.com>
Date: Wed, 21 Oct 2015 17:12:38 +0800
MIME-Version: 1.0
In-Reply-To: <1445417149-804-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/10/21 16:45 +0800:
> btrfs-convert convert FS with latest default features enabled, and
> if the kernel is down-rev and does not support a latest feature then
> mount fails, as expected.
>
> This patch disables default features based on the running kernel.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   btrfs-convert.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index cb92020..edec09e 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -2890,7 +2890,10 @@ int main(int argc, char *argv[])
>   	int progress = 1;
>   	char *file;
>   	char fslabel[BTRFS_LABEL_SIZE];
> -	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
> +	u64 features;
> +
> +	features = btrfs_features_allowed_by_kernel();
> +	features &= BTRFS_MKFS_DEFAULT_FEATURES;
Same with previous patch.

Thanks,
Qu
>
>   	while(1) {
>   		enum { GETOPT_VAL_NO_PROGRESS = 256 };
>
