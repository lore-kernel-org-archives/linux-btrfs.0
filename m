Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43909 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750785AbeASHft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 02:35:49 -0500
Subject: Re: [PATCH v2 1/3] btrfs-progs: lowmem fsck: Remove corupted link
 before re-add correct link
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-2-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <0ae39c2b-bc58-0213-693a-a4939e74a34f@cn.fujitsu.com>
Date: Fri, 19 Jan 2018 15:40:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180119072536.22286-2-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/19/2018 03:25 PM, Qu Wenruo wrote:
> For repair_ternary_lowmem() used in lowmem mode, if it found 1 of
> DIR_INDEX/DIR_ITEM/INODE_REF missing, it will try to insert correct
> link.
> 
> However for case like invalid type in DIR_INDEX, we should delete the
> corrupted DIR_INDEX first before inserting the correct link.
> 
> This patch will remove the corrupted link before re-insert.
> This should solve the duplicated DIR_INDEX problem in old lowmem mode
> repair.
> 
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   cmds-check.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 7fc30da83ea1..f302724dd840 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -4997,6 +4997,10 @@ int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
>   		goto out;
>   	}
>   	if (stage == 1) {
> +		ret = btrfs_unlink(trans, root, ino, dir_ino, index, name,
> +				   name_len, 0);
> +		if (ret)
> +			goto out;
>   		ret = btrfs_add_link(trans, root, ino, dir_ino, name, name_len,
>   			       filetype, &index, 1, 1);
>   		goto out;
> 


