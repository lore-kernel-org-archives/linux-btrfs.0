Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10723 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751388AbcJZHjA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 03:39:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 995C6480B678
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Oct 2016 15:38:53 +0800 (CST)
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
To: <linux-btrfs@vger.kernel.org>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <58105C0F.6070907@cn.fujitsu.com>
Date: Wed, 26 Oct 2016 15:32:31 +0800
MIME-Version: 1.0
In-Reply-To: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/11/2016 02:47 PM, Wang Xiaoguang wrote:
> If we use mount option "-o max_inline=sectorsize", say 4096, indeed
> even for a fresh fs, say nodesize is 16k, we can not make the first
> 4k data completely inline, I found this conditon causing this issue:
>    !compressed_size && (actual_end & (root->sectorsize - 1)) == 0
>
> If it retuns true, we'll not make data inline. For 4k sectorsize,
> 0~4094 dara range, we can make it inline, but 0~4095, it can not.
> I don't think this limition is useful, so here remove it which will
> make max inline data can be equal to sectorsize.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/inode.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ea15520..c0db393 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -267,8 +267,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
>   	if (start > 0 ||
>   	    actual_end > root->sectorsize ||
>   	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
> -	    (!compressed_size &&
> -	    (actual_end & (root->sectorsize - 1)) == 0) ||
>   	    end + 1 < isize ||
>   	    data_len > root->fs_info->max_inline) {
>   		return 1;
Any comments about this patch?

Regards,
Xiaoguang Wang




