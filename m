Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41903 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbeCVNnY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:43:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1BB43AC12
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 13:43:23 +0000 (UTC)
Date: Thu, 22 Mar 2018 14:40:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
Message-ID: <20180322134058.GA6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180319091841.18603-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180319091841.18603-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 05:18:41PM +0800, Qu Wenruo wrote:
> We have several reports about node pointer points to incorrect child
> tree blocks, which could have even wrong owner and level but still with
> valid generation and checksum.
> 
> Although btrfs check could handle it and print error message like:
> leaf parent key incorrect 60670574592
> 
> Kernel doesn't have enough check on this type of corruption correctly.
> At least add such check to read_tree_block() and btrfs_read_buffer(),
> where we need two new parameters @first_key and @level to verify the
> child tree block.
> 
> For case where we don't have parent node to get @first_key and @level,
> just pass @first_key as NULL and kernel will skip such check.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c     |  6 +++--
>  fs/btrfs/ctree.c       | 25 +++++++++++++-----
>  fs/btrfs/disk-io.c     | 69 ++++++++++++++++++++++++++++++++++++++++----------
>  fs/btrfs/disk-io.h     |  8 +++---
>  fs/btrfs/extent-tree.c |  6 ++++-
>  fs/btrfs/print-tree.c  | 10 +++++---
>  fs/btrfs/qgroup.c      |  7 +++--
>  fs/btrfs/relocation.c  | 21 ++++++++++++---
>  fs/btrfs/tree-log.c    | 12 ++++++---
>  9 files changed, 126 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 26484648d090..3866b8ab20f1 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
>  		BUG_ON(ref->key_for_search.type);
>  		BUG_ON(!ref->wanted_disk_byte);
>  
> -		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0);
> +		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,
> +				     0);

Please add 2nd function that will take the extended parameters and
keep read_tree_block as is.
