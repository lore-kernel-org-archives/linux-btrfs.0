Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25993 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdBVFbl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 00:31:41 -0500
Date: Tue, 21 Feb 2017 21:31:23 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: remove BUG_ON from __tree_mod_log_insert
Message-ID: <20170222053123.GA1497@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1487614974.git.dsterba@suse.com>
 <f4837430011633a26eeb2c1410d20f1f954e2395.1487614974.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f4837430011633a26eeb2c1410d20f1f954e2395.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 07:25:01PM +0100, David Sterba wrote:
> All callers dereference the 'tm' parameter before it gets to this
> function, the NULL check does not make much sense here.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 1192bc7d2ee7..2c3c943bfcdc 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -453,8 +453,6 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>  	struct rb_node *parent = NULL;
>  	struct tree_mod_elem *cur;
>  
> -	BUG_ON(!tm);
> -
>  	tm->seq = btrfs_inc_tree_mod_seq(fs_info);
>  
>  	tm_root = &fs_info->tree_mod_log;
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
