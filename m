Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37783 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752432AbeADNyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jan 2018 08:54:18 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C29BADF8
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Jan 2018 13:54:17 +0000 (UTC)
Subject: Re: [PATCH 0/5] Cleanups for later btrfs_alloc_chunk() rework
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180103071306.11500-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a4cc71f8-dcc1-0c85-1734-17916858fa95@suse.com>
Date: Thu, 4 Jan 2018 15:54:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.01.2018 09:13, Qu Wenruo wrote:
> Just small cleanups for incoming btrfs_alloc_chunk() rework, which is
> designed to allow btrfs_alloc_chunk() to be able to alloc meta chunk,
> even current meta chunks are already full.
> 
> The cleanups are quite small, most of them are just removing unnecessary
> parameters, and make some function static.
> 
> Qu Wenruo (5):
>   btrfs-progs: Use bool parameter to determine if we're allocating data
>     extent
>   btrfs-progs: volumes: Make find_free_dev_extent_start static
>   btrfs-progs: volumes: Remove unnecessary trans parameter
>   btrfs-progs: volumes: Remove unnecessary parameters when allocating
>     device extent
>   btrfs-progs: Remove unnecessary parameter for btrfs_add_block_group
> 

For the whole series:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

>  cmds-check.c   |  4 ++--
>  convert/main.c |  4 +---
>  ctree.h        |  7 +++----
>  extent-tree.c  | 31 ++++++++++++++++---------------
>  mkfs/main.c    | 14 ++++----------
>  volumes.c      | 35 ++++++++++++++---------------------
>  6 files changed, 40 insertions(+), 55 deletions(-)
> 
