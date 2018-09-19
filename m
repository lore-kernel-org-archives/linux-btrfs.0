Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40045 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbeISF4W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 01:56:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id s13-v6so1794382pfi.7
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 17:21:16 -0700 (PDT)
Date: Tue, 18 Sep 2018 17:21:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 32/36] btrfs: clear delayed_refs_rsv for dirty bg cleanup
Message-ID: <20180919002114.GH479@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-33-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-33-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:58:03PM -0400, Josef Bacik wrote:
> We keep track of dirty bg's as a reservation in the delayed_refs_rsv, so
> when we abort and we cleanup those dirty bgs we need to drop their
> reservation so we don't have accounting issues and lots of scary
> messages on umount.

Shouldn't this just be part of patch 6?

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/disk-io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index caaca8154a1a..54fbdc944a3f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4412,6 +4412,7 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
>  
>  		spin_unlock(&cur_trans->dirty_bgs_lock);
>  		btrfs_put_block_group(cache);
> +		btrfs_delayed_refs_rsv_release(fs_info, 1);
>  		spin_lock(&cur_trans->dirty_bgs_lock);
>  	}
>  	spin_unlock(&cur_trans->dirty_bgs_lock);
> -- 
> 2.14.3
> 
