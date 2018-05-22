Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32951 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbeEVRUd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:20:33 -0400
Date: Tue, 22 May 2018 19:17:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, Jun Wu <quark@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix error handling in btrfs_truncate()
Message-ID: <20180522171748.GY6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d181fa0f3fc581208a0258132c8dc3305b01be1a.1527007575.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d181fa0f3fc581208a0258132c8dc3305b01be1a.1527007575.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 09:47:58AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Jun Wu at Facebook reported that an internal service was seeing a return
> value of 1 from ftruncate() on Btrfs in some cases.

Do you have a reproducer? To estimate how likely is to hit the problem
in practice.

> This is coming from
> the NEED_TRUNCATE_BLOCK return value from btrfs_truncate_inode_items().
> 
> btrfs_truncate() uses two variables for error handling, ret and err.
> When btrfs_truncate_inode_items() returns non-zero, we set err to the
> return value. However, NEED_TRUNCATE_BLOCK is not an error. Make sure we
> only set err if ret is an error (i.e., negative).
> 
> Fixes: ddfae63cc8e0 ("btrfs: move btrfs_truncate_block out of trans handle")
> Reported-by: Jun Wu <quark@fb.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> This version makes the minimal fix which should be good for v4.17 and
> stable. I'll submit a cleanup separately.
> 
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d241285a0d2a..f276da70f659 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9117,7 +9117,8 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
>  						 BTRFS_EXTENT_DATA_KEY);
>  		trans->block_rsv = &fs_info->trans_block_rsv;
>  		if (ret != -ENOSPC && ret != -EAGAIN) {
> -			err = ret;
> +			if (ret < 0)
> +				err = ret;
>  			break;
>  		}
