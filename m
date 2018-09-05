Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727201AbeIEMLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 08:11:08 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83F4BB1C3
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 07:42:11 +0000 (UTC)
Subject: Re: [PATCH 1/4] btrfs-progs: print-tree: Skip deprecated blockptr /
 nodesize output
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180905062924.23836-1-wqu@suse.com>
 <20180905062924.23836-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <16b92c63-360a-7d72-527d-aa0104fccebd@suse.com>
Date: Wed, 5 Sep 2018 10:42:10 +0300
MIME-Version: 1.0
In-Reply-To: <20180905062924.23836-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.09.2018 09:29, Qu Wenruo wrote:
> When printing tree nodes, we output slots like:
> key (EXTENT_TREE ROOT_ITEM 0) block 73625600 (17975) gen 16
> 
> The number in the parentheses is blockptr / nodesize.
> 
> However this number doesn't really do any thing useful.
> And in fact for unaligned metadata block group (block group start bytenr
> is not aligned to 16K), the number doesn't even make sense as it's
> rounded down.
> 
> In factor kernel doesn't ever output such divided result in its
> print-tree.c
> 
> Remove it so later reader won't wonder what the number means.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  print-tree.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index a09ecfbb28f0..31f6fa12522f 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1420,9 +1420,8 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
>  		btrfs_disk_key_to_cpu(&key, &disk_key);
>  		printf("\t");
>  		btrfs_print_key(&disk_key);
> -		printf(" block %llu (%llu) gen %llu\n",
> +		printf(" block %llu gen %llu\n",
>  		       (unsigned long long)blocknr,
> -		       (unsigned long long)blocknr / eb->len,
>  		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
>  		fflush(stdout);
>  	}
> 
