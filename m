Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34359 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933483AbcJXPOI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 11:14:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 75474AC31
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 15:14:07 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: Initialize btrfs_path before use
To: linux-btrfs@vger.kernel.org
References: <20161024145754.7165-1-rgoldwyn@suse.de>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <27b3b293-8d6a-9878-8b23-666702e23d28@suse.de>
Date: Mon, 24 Oct 2016 10:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <20161024145754.7165-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/24/2016 09:57 AM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> While performing an fsck, an assertion failure occurs because of reusing path in a loop.
> ctree.c:1112: btrfs_search_slot: Warning: assertion `p->nodes[0] != NULL` failed, value 0
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 670ccd1..a6f281c 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -7541,6 +7541,7 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
>  		key.objectid = dback->owner;
>  		key.type = BTRFS_EXTENT_DATA_KEY;
>  		key.offset = dback->offset;
> +		btrfs_init_path(path);
>  
>  		ret = btrfs_search_slot(NULL, dest_root, &key, path, 0, 0);
>  		/*
> 

This is an incorrect fix. Please ignore. I shall send the correct fix
shortly. It should be release_path() instead.

-- 
Goldwyn
