Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934912AbcIFRgC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 13:36:02 -0400
Date: Tue, 6 Sep 2016 19:34:27 +0200
From: David Sterba <dsterba@suse.cz>
To: jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, fdmanana@kernel.org,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix WARNING in btrfs_select_ref_head()
Message-ID: <20160906173427.GF16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466385532-6005-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1466385532-6005-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef, can you please review this?

On Mon, Jun 20, 2016 at 09:18:52AM +0800, Wang Xiaoguang wrote:
> This issue was found when testing in-band dedupe enospc behaviour,
> sometimes run_one_delayed_ref() may fail for enospc reason, then
> __btrfs_run_delayed_refs（）will return, but forget to add num_heads_read
> back, which will trigger "WARN_ON(delayed_refs->num_heads_ready == 0)" in
> btrfs_select_ref_head().
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6146729..eeedff3 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2665,7 +2665,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  
>  		btrfs_free_delayed_extent_op(extent_op);
>  		if (ret) {
> +			spin_lock(&delayed_refs->lock);
>  			locked_ref->processing = 0;
> +			delayed_refs->num_heads_ready++;
> +			spin_unlock(&delayed_refs->lock);
>  			btrfs_delayed_ref_unlock(locked_ref);
>  			btrfs_put_delayed_ref(ref);
>  			btrfs_debug(fs_info, "run_one_delayed_ref returned %d", ret);
> -- 
> 1.8.3.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
