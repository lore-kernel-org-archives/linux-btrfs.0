Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756671AbeEJILB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 04:11:01 -0400
Subject: Re: [PATCH 03/10] Btrfs: don't BUG_ON() in
 btrfs_truncate_inode_items()
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <cover.1525932796.git.osandov@fb.com>
 <5f6e2fe358fea83f8995a1863d3da3908e5365ec.1525932796.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6b069ff7-73e5-3cf2-091f-92803e4021b2@suse.com>
Date: Thu, 10 May 2018 11:10:58 +0300
MIME-Version: 1.0
In-Reply-To: <5f6e2fe358fea83f8995a1863d3da3908e5365ec.1525932796.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.05.2018 09:21, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_free_extent() can fail because of ENOMEM. There's no reason to
> panic here, we can just abort the transaction.
> 
> Fixes: f4b9aa8d3b87 ("btrfs_truncate")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 79d1da01a90d..bd4975476f0e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4655,7 +4655,10 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  						extent_num_bytes, 0,
>  						btrfs_header_owner(leaf),
>  						ino, extent_offset);
> -			BUG_ON(ret);
> +			if (ret) {
> +				btrfs_abort_transaction(trans, ret);
> +				break;
> +			}
>  			if (btrfs_should_throttle_delayed_refs(trans, fs_info))
>  				btrfs_async_run_delayed_refs(fs_info,
>  					trans->delayed_ref_updates * 2,
> 
