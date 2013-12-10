Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3LJBmn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 20:42:43 -0500
Message-ID: <52A67179.7040609@cn.fujitsu.com>
Date: Tue, 10 Dec 2013 09:42:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix an oops when doing balance relocation
References: <1386605674-3320-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1386605674-3320-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2013 12:14 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> I hit a BUG_ON() when inserting reloc root into rc->reloc_root_tree.rb_root,
> the fact is block bytenr has been inserted before, this is really a redicious
> bug, the reason is that we freed root node after we have allocated root
> node block,and this block bytenr will be reused and then oops happens.
oops, this is wrong, sorry for noise.

Thanks,
Wang
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/relocation.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index ce459a7..4dc7f26 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1361,7 +1361,6 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
>   	}
>   
>   	btrfs_tree_unlock(eb);
> -	free_extent_buffer(eb);
>   
>   	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
>   				&root_key, root_item);

