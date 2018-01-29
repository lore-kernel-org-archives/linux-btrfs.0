Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbeA2Qsu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 11:48:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EF0DCAC8C
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 16:48:48 +0000 (UTC)
Subject: Re: [PATCH] btrfs: btrfs_evict_inode must clear all inodes
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <c38b2527-899f-9be2-87e5-6b4048e17217@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aad59b4a-1dcd-4c8a-cbdc-a6a5633d697b@suse.com>
Date: Mon, 29 Jan 2018 18:48:47 +0200
MIME-Version: 1.0
In-Reply-To: <c38b2527-899f-9be2-87e5-6b4048e17217@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.01.2018 18:46, Jeff Mahoney wrote:
> btrfs_evict_inode must clear all inodes or we'll hit a BUG_ON in evict().
> 
> Fixes: 3d48d9810de (btrfs: Handle uninitialised inode eviction)
> Cc: Nikolay Borisov <nborisov@suse.com>
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>


Yep, this is a genuine bug, however Liu Bo already sent a fix for that:

Btrfs: fix btrfs_evict_inode to handle abnormal inodes correctly

> ---
>  fs/btrfs/inode.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5282,6 +5282,7 @@ void btrfs_evict_inode(struct inode *ino
>  	trace_btrfs_inode_evict(inode);
>  
>  	if (!root) {
> +		clear_inode(inode);
>  		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
>  		return;
>  	}
> 
