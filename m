Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750996AbeGIHqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jul 2018 03:46:35 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 042ECADE5
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jul 2018 07:46:34 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs-progs: Exit gracefully when overlap chunks are
 detected
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180709065054.1392-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <70a8923d-2b76-7b1d-670d-c30ae0922c59@suse.com>
Date: Mon, 9 Jul 2018 10:46:33 +0300
MIME-Version: 1.0
In-Reply-To: <20180709065054.1392-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.07.2018 09:50, Qu Wenruo wrote:
> BUG_ON() can be triggered if some image contains overlap chunks.
> volumes.c:1930: read_one_chunk: BUG_ON `ret` triggered, value -17
> btrfs(+0x2cf12)[0x5601efa17f12]
> btrfs(+0x2fd8b)[0x5601efa1ad8b]
> btrfs(btrfs_read_chunk_tree+0x2bf)[0x5601efa1b30f]
> btrfs(btrfs_setup_chunk_tree_and_device_map+0xe8)[0x5601efa07718]
> btrfs(+0x1c944)[0x5601efa07944]
> btrfs(open_ctree_fs_info+0x90)[0x5601efa07b90]
> btrfs(cmd_check+0x4d7)[0x5601efa4f8c7]
> btrfs(main+0x88)[0x5601ef9fd768]
> /usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f3c7787306b]
> btrfs(_start+0x2a)[0x5601ef9fd88a]
> 
> Extent cache code can already detect it without problem, we only need to
> remove the BUG_ON() and exit gracefully.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200409
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  volumes.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/volumes.c b/volumes.c
> index 24eb3e8b2578..21a1fc31fcba 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -1924,9 +1924,12 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  
>  	}
>  	ret = insert_cache_extent(&map_tree->cache_tree, &map->ce);
> -	BUG_ON(ret);
> +	if (ret < 0) {
> +		error("failed to add chunk map start=%llu len=%llu: %d (%s)",
> +		      map->ce.start, map->ce.size, ret, strerror(-ret));
> +	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int fill_device_from_item(struct extent_buffer *leaf,
> 
