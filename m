Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbcGHP0x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 11:26:53 -0400
Date: Fri, 8 Jul 2016 17:27:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@kernel.org
Subject: Re: [PATCH] btrfs: fix WARNING in btrfs_select_ref_head()
Message-ID: <20160708152710.GN13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466385532-6005-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466385532-6005-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 09:18:52AM +0800, Wang Xiaoguang wrote:
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

I don't feel qualified to review this and add it to the 4.8 first pull.
The patch will be in for-next though.
