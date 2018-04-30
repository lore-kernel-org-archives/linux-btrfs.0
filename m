Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57729 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751242AbeD3DnK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 23:43:10 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree()
 check to avoid out-of-boundary memory access
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180430031545.29891-1-wqu@suse.com>
 <20180430031545.29891-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <747b3412-e111-8075-20fd-656e76cdb2b0@cn.fujitsu.com>
Date: Mon, 30 Apr 2018 11:49:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180430031545.29891-3-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/30/2018 11:15 AM, Qu Wenruo wrote:
> For btrfs_print_tree(), if nr_items is corrupted, it can easily go
> beyond extent buffer boundary.
> 
> Add extra nr_item check, and only print as many valid slots as possible.
> 

Make sense.

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   print-tree.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index 31a851ef4413..55db80bebb2a 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1376,6 +1376,11 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
>   		btrfs_print_leaf(eb);
>   		return;
>   	}
> +	/* We are crossing eb boundary, this node must be corrupted */
> +	if (nr > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
> +		warning(
> +		"node nr_items corrupted, has %u limit %u, continue print anyway",
> +			nr, BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb));
>   	printf("node %llu level %d items %d free %u generation %llu owner ",
>   	       (unsigned long long)eb->start,
>   	        btrfs_header_level(eb), nr,
> @@ -1386,7 +1391,11 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
>   	print_uuids(eb);
>   	fflush(stdout);
>   		
> -		u64 blocknr = btrfs_node_blockptr(eb, i);
> +		u64 blocknr;
> +
> +		if (i > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
> +			break;

Should it be i >= BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb)?

Here BTRFS_NODEPTRS_PER_EXTENT_BUFFER() is called during iterations.
The judement can be calculated in advance like:

	ptr_num = BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb);
	...
	for (i = 0; i < nr && i < ptr_num  ; i++) {

Thanks,
Su

> +		blocknr = btrfs_node_blockptr(eb, i);
>   		btrfs_node_key(eb, &disk_key, i);
>   		btrfs_disk_key_to_cpu(&key, &disk_key);
>   		printf("\t");
> 


