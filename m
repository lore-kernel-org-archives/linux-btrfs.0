Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51093 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757957AbeDXNZG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:25:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89B9CABEF
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:25:04 +0000 (UTC)
Date: Tue, 24 Apr 2018 15:22:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Unexport btrfs_alloc_delalloc_work
Message-ID: <20180424132231.GF21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
 <1524470057-21969-6-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524470057-21969-6-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 23, 2018 at 10:54:17AM +0300, Nikolay Borisov wrote:
> It's used only in inode.c so makes no sense to have it exported.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 91f51a80334f..e5c24d86fdfa 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3170,8 +3170,6 @@ struct btrfs_delalloc_work {
>  	struct btrfs_work work;
>  };
>  
> -struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode);

So thic can be also made static, I can fix that.
