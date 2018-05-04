Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59707 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbeEDIyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 04:54:23 -0400
Subject: Re: [PATCH 0/3] Misc cleanups to cached extent
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1525420047-17397-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2f30882d-ffc4-404b-eeb0-0b81188b472e@gmx.com>
Date: Fri, 4 May 2018 16:54:13 +0800
MIME-Version: 1.0
In-Reply-To: <1525420047-17397-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月04日 15:47, Nikolay Borisov wrote:
> Here are a couple of cleanups I stumbled upon while looking at the freespace 
> validation code. The first one simplifies btrfs_rmap_block that has an unused 
> parameter. The next 2 patches cleanup the cache_extent apis since they provide
> more than we are actually using (or have ever used).

Under all cases, only insert_cache_extent2() is used, so removing
add_cache_extent2() is completely fine.

> Nikolay Borisov (3):
>   btrfs-progs: Remove devid parameter from btrfs_rmap_block
>   btrfs-progs: Remove add_cache_extent2
>   btrfs-progs: Remove objectid argument from alloc_cache_extent

All of them looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
>  check/main.c   |  2 +-
>  extent-cache.c | 21 ++++-----------------
>  extent-cache.h |  2 --
>  extent-tree.c  | 10 +++++-----
>  volumes.c      |  7 ++-----
>  volumes.h      |  4 ++--
>  6 files changed, 14 insertions(+), 32 deletions(-)
> 
