Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdCNM3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 08:29:04 -0400
Date: Tue, 14 Mar 2017 13:28:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, fdmanana@kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v3] qgroup: Retry after commit on getting EDQUOT
Message-ID: <20170314122826.GW14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314102350.10565-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170314102350.10565-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 05:23:50AM -0500, Goldwyn Rodrigues wrote:
> @@ -2402,6 +2404,19 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>  		qg = unode_aux_to_qgroup(unode);
>  
>  		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
> +			if (!retried && qg->reserved > 0) {
> +				struct btrfs_trans_handle *trans;

Newline here

> +				spin_unlock(&fs_info->qgroup_lock);
> +				btrfs_start_delalloc_inodes(root, 0);

Do not ignore the return value, there seem to be some valid cases to
handle.

> +				btrfs_wait_ordered_extents(root, -1, 0,
> +						(u64)-1);
> +				trans = btrfs_join_transaction(root);
> +				if (IS_ERR(trans))
> +					return PTR_ERR(trans);
> +				btrfs_commit_transaction(trans);

Do not ignore return value from the commit.

> +				retried++;
> +				goto retry;
> +			}
>  			ret = -EDQUOT;
>  			goto out;
>  		}
