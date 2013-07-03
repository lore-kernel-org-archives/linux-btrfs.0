Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:8966 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3GCQbR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 12:31:17 -0400
Message-ID: <51D451CD.9090400@giantdisaster.de>
Date: Wed, 03 Jul 2013 18:31:09 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, wangsl-fnst@cn.fujitsu.com
Subject: Re: [PATCH RESEND] Btrfs-progs: fix compile warning in btrfs_free_block_groups()
References: <1372868685-4973-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1372868685-4973-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu,  4 Jul 2013 00:24:45 +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> extent-tree.c: In function 'btrfs_free_block_groups':
> extent-tree.c:3189:12: warning: cast to pointer from
> integer of different size [-Wint-to-pointer-cast]
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index b0cfe0a..7561bbb 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -3186,7 +3186,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
>  			break;
>  		ret = get_state_private(&info->block_group_cache, start, &ptr);
>  		if (!ret) {
> -			cache = (struct btrfs_block_group_cache *)ptr;
> +			cache = (struct btrfs_block_group_cache *)
> +				(unsigned long)ptr;

Shouldn't this be "(uintptr_t)" instead of "(unsigned long)"?

