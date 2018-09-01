Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33140 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbeIAEb4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:31:56 -0400
Received: by mail-yw1-f67.google.com with SMTP id x67-v6so5660727ywg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:22:00 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:21:55 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 23/35] btrfs: assert on non-empty delayed iputs
Message-ID: <20180901002155.GD29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-24-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-24-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:42:13PM -0400, Josef Bacik wrote:
> I ran into an issue where there was some reference being held on an
> inode that I couldn't track.  This assert wasn't triggered, but it at
> least rules out we're doing something stupid.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/disk-io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0e42401756b8..11ea2ea7439e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3979,6 +3979,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  	kthread_stop(fs_info->transaction_kthread);
>  	kthread_stop(fs_info->cleaner_kthread);
>  
> +	ASSERT(list_empty(&fs_info->delayed_iputs));
>  	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
>  
>  	btrfs_free_qgroup_config(fs_info);
> -- 
> 2.14.3
> 
