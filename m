Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49840 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932188AbeGDHh0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 03:37:26 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 3/5] btrfs: relocation: Only remove reloc rb_trees if
 reloc control has been initialized
Date: Wed, 4 Jul 2018 07:37:27 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557C99@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-4-wqu@suse.com>
In-Reply-To: <20180703091009.16399-4-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Tuesday, July 03, 2018 5:10 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 3/5] btrfs: relocation: Only remove reloc rb_trees if reloc control has been initialized
> 
> Invalid tree reloc tree can cause kernel NULL pointer dereference when
> btrfs does some cleanup for reloc roots.
> 
> It turns out that fs_info->reloc_ctl can be NULL in
> btrfs_recover_relocation() as we allocate relocation control after all
> reloc roots are verified.
> So when we hit out: tag, we haven't call set_reloc_control() thus
> fs_info->reloc_ctl is still NULL.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199833
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/relocation.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 879b76fa881a..be94c65bb4d2 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1321,18 +1321,19 @@ static void __del_reloc_root(struct btrfs_root *root)
>  	struct mapping_node *node = NULL;
>  	struct reloc_control *rc = fs_info->reloc_ctl;
> 
> -	spin_lock(&rc->reloc_root_tree.lock);
> -	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
> -			      root->node->start);
> -	if (rb_node) {
> -		node = rb_entry(rb_node, struct mapping_node, rb_node);
> -		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
> +	if (rc) {
> +		spin_lock(&rc->reloc_root_tree.lock);
> +		rb_node = tree_search(&rc->reloc_root_tree.rb_root,
> +				      root->node->start);
> +		if (rb_node) {
> +			node = rb_entry(rb_node, struct mapping_node, rb_node);
> +			rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
> +		}
> +		spin_unlock(&rc->reloc_root_tree.lock);
> +		if (!node)
> +			return;
> +		BUG_ON((struct btrfs_root *)node->data != root);
>  	}
> -	spin_unlock(&rc->reloc_root_tree.lock);
> -
> -	if (!node)
> -		return;
> -	BUG_ON((struct btrfs_root *)node->data != root);
> 
>  	spin_lock(&fs_info->trans_lock);
>  	list_del_init(&root->root_list);
> --

Tested-by: Gu Jinxiang <gujx@cn.fujitsu.com>

> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
