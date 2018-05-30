Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935163AbeE3H3z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 03:29:55 -0400
Subject: Re: [PATCH v2 2/2] btrfs-progs: ins: dump-tree: Print tree name for
 extent data/tree block backref
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
 <f6cac4991b513c3c4b00781414d422b3f4c87f6e.1527655420.git.misono.tomohiro@jp.fujitsu.com>
 <5f258c66-ffde-e7e0-4640-9e3465203c95@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5e6575e5-f5a3-3ec0-4a10-4f426c8380e0@suse.com>
Date: Wed, 30 May 2018 10:29:52 +0300
MIME-Version: 1.0
In-Reply-To: <5f258c66-ffde-e7e0-4640-9e3465203c95@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.05.2018 10:25, Misono Tomohiro wrote:
> Print tree name instead of number to make output more readable.
> 
> Example:
> [before]
>    extent data backref root 5 objectid 257 offset 16384 count 1
>    
>    tree block backref root 18446744073709551607
> 
> [after]
>    extent data backref root FS_TREE objectid 257 offset 16384 count 1
>    
>    tree block backref root DATA_RELOC_TREE
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  v1 -> v2
>    - Update extent data backref too
>    - Add output example
> 
>  print-tree.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index 90173c2b..c5be5e6c 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -470,8 +470,9 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
>  		offset = btrfs_extent_inline_ref_offset(eb, iref);
>  		switch (type) {
>  		case BTRFS_TREE_BLOCK_REF_KEY:
> -			printf("\t\ttree block backref root %llu\n",
> -			       (unsigned long long)offset);
> +			printf("\t\ttree block backref root ");
> +			print_objectid(stdout, offset, 0);
> +			printf("\n");
>  			break;
>  		case BTRFS_SHARED_BLOCK_REF_KEY:
>  			printf("\t\tshared block backref parent %llu\n",
> @@ -479,9 +480,10 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
>  			break;
>  		case BTRFS_EXTENT_DATA_REF_KEY:
>  			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
> -			printf("\t\textent data backref root %llu "
> -			       "objectid %llu offset %lld count %u\n",
> -			       (unsigned long long)btrfs_extent_data_ref_root(eb, dref),
> +			printf("\t\textent data backref root ");
> +			print_objectid(stdout,
> +		(unsigned long long)btrfs_extent_data_ref_root(eb, dref), 0);
> +			printf(" objectid %llu offset %lld count %u\n",
>  			       (unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
>  			       btrfs_extent_data_ref_offset(eb, dref),
>  			       btrfs_extent_data_ref_count(eb, dref));
> @@ -1018,9 +1020,10 @@ static void print_extent_data_ref(struct extent_buffer *eb, int slot)
>  	struct btrfs_extent_data_ref *dref;
>  
>  	dref = btrfs_item_ptr(eb, slot, struct btrfs_extent_data_ref);
> -	printf("\t\textent data backref root %llu "
> -		"objectid %llu offset %llu count %u\n",
> -		(unsigned long long)btrfs_extent_data_ref_root(eb, dref),
> +	printf("\t\textent data backref root ");
> +	print_objectid(stdout,
> +		(unsigned long long)btrfs_extent_data_ref_root(eb, dref), 0);
> +	printf(" objectid %llu offset %llu count %u\n",
>  		(unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
>  		(unsigned long long)btrfs_extent_data_ref_offset(eb, dref),
>  		btrfs_extent_data_ref_count(eb, dref));
> 
