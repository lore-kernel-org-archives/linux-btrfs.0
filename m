Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422761AbeCBINV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 03:13:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 43951AE79
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 08:13:20 +0000 (UTC)
Subject: Re: [PATCH 0/5] max_inline related enhancement
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <771b3695-cc28-e14b-8afc-079c06a1b837@suse.com>
Date: Fri, 2 Mar 2018 10:13:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180302052254.7059-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.03.2018 07:22, Qu Wenruo wrote:
> This patchset intends to reduce confusion about "max_inline" mount
> option.
> 
> The max_inline mount option has the following problems:
> 
> 1) Different behavior for plain and compressed data extent
>    For plain data extent, it's limiting the extent data size, and will
>    never reach sector size.
>    For compressed data extent, it's limiting the compressed data size,
>    and compressed data size can reach sector size.
> 
>    The compressed behavior is very confusing for normal user, as it's
>    almost impossible for end user to know if their operation will end up
>    inlined or no inlined.
> 
> 2) Inaccurate max inline output
>    Passing max_inline=4096 and kernel will prompt max_inline is 4096,
>    but we still don't allow inline plain data extent to reach 4096.
> 
> 3) Symbol link can exceed sector size for its inlined data
>    Since btrfs_symlink() is calling BTRFS_MAX_INLINE_DATA_SIZE()
>    directly without extra truncation.
> 
> This patchset will fixes such problems by:
> 
> 1) Limit both plain and compressed inline extent size by uncompressed
>    data size
>    So user know exactly what will end up on-disk, just by checking the data
>    size.
> 
> 2) Output max inline size by limiting it to BTRFS_MAX_INLINE_DATA_SIZE()
>    other than sector size.
> 
> 3) Embed sector size check into BTRFS_MAX_INLINE_DATA_SIZE()
>    So now btrfs_symlink() won't create any inline extent larger than
>    page size.
>    (Only affects later operations, and can still read such existing
>     symbol link)
> 
> Qu Wenruo (5):
>   btrfs: Parse options after node/sector size initialized
>   btrfs: Always limit inline extent size by uncompressed size
>   btrfs: Embed sector size check into BTRFS_MAX_INLINE_DATA_SIZE()
>   btrfs: Unify inline extent creation condition for plain and compressed
>     data
>   btrfs: Show more accurate max_inline
> 
>  fs/btrfs/ctree.h   |  5 +++--
>  fs/btrfs/disk-io.c | 13 +++++++------
>  fs/btrfs/inode.c   |  5 +----
>  fs/btrfs/super.c   |  4 ++--
>  4 files changed, 13 insertions(+), 14 deletions(-)

The series look good so:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>



> 
