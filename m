Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38926 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbeIADEm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 23:04:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id w14-v6so6075787plp.6
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 15:55:04 -0700 (PDT)
Date: Fri, 31 Aug 2018 15:55:02 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 02/35] btrfs: add cleanup_ref_head_accounting helper
Message-ID: <20180831225502.GA17237@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-3-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-3-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:41:52PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We were missing some quota cleanups in check_ref_cleanup, so break the
> ref head accounting cleanup into a helper and call that from both
> check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
> we don't screw up accounting in the future for other things that we add.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 39 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6799950fa057..4c9fd35bca07 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2461,6 +2461,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
>  	return ret ? ret : 1;
>  }
>  
> +static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> +					struct btrfs_delayed_ref_head *head)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_delayed_ref_root *delayed_refs =
> +		&trans->transaction->delayed_refs;
> +
> +	if (head->total_ref_mod < 0) {
> +		struct btrfs_space_info *space_info;
> +		u64 flags;
> +
> +		if (head->is_data)
> +			flags = BTRFS_BLOCK_GROUP_DATA;
> +		else if (head->is_system)
> +			flags = BTRFS_BLOCK_GROUP_SYSTEM;
> +		else
> +			flags = BTRFS_BLOCK_GROUP_METADATA;
> +		space_info = __find_space_info(fs_info, flags);
> +		ASSERT(space_info);
> +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
> +				   -head->num_bytes,
> +				   BTRFS_TOTAL_BYTES_PINNED_BATCH);

While you're here, could you fix this botched whitespace?
