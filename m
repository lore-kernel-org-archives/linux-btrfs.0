Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56777 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbaJFBOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 21:14:38 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s961EbDH015369
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Oct 2014 09:14:37 +0800
Message-ID: <5431ED1B.3050006@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 09:15:07 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Check the csum tree node before go through
 the csum tree
References: <1412067130-11504-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1412067130-11504-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patch since Wang's patch has already fixed them.

https://patchwork.kernel.org/patch/4254631/

Thanks,
Qu
-------- Original Message --------
Subject: [PATCH] btrfs-progs: Check the csum tree node before go through 
the csum tree
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年09月30日 16:52
> [BUG]
> Some fsfuzzed btrfs image will cause btrfsck segfault.
>
> [REPRODUCER]
> Run btrfsck on a csum tree block corrupted image.
>
> [REASON]
> check_csums() function call btrfs_search_slot() on csum_tree but doesn't
> check whether the csum_tree contains a valid extent_buffer, which causes
> the segfault.
>
> [FIX]
> Check the csum_root->node before any search.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   cmds-check.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 9471709..537376a 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -3905,6 +3905,10 @@ static int check_csums(struct btrfs_root *root)
>   	unsigned long leaf_offset;
>   
>   	root = root->fs_info->csum_root;
> +	if (!extent_buffer_uptodate(root->node)) {
> +		fprintf(stderr, "No valid csum tree found\n");
> +		return -ENOENT;
> +	}
>   
>   	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
>   	key.type = BTRFS_EXTENT_CSUM_KEY;

