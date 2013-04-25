Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab3DYWSy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 18:18:54 -0400
Date: Thu, 25 Apr 2013 15:18:31 -0700
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle errors returned from get_tree_block_key
Message-ID: <20130425221831.GK25389@lenny.home.zabbo.net>
References: <1366822294-9193-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366822294-9193-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 24, 2013 at 06:51:34PM +0200, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/relocation.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index c22ccfe..e85be23 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -2878,8 +2878,11 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
>  	rb_node = rb_first(blocks);
>  	while (rb_node) {
>  		block = rb_entry(rb_node, struct tree_block, rb_node);
> -		if (!block->key_ready)
> -			get_tree_block_key(rc, block);
> +		if (!block->key_ready) {
> +			err = get_tree_block_key(rc, block);
> +			if (err)
> +				goto out_path;
> +		}

Doesn't this leak the path?  Whoever named that label out_path was
having a laugh :).

		btrfs_free_path(path);
	out_path:
		free_block_list(blocks);
		return err;
	}

- z
