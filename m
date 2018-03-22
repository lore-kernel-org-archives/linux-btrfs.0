Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbeCVIWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 04:22:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 90C5CACBF
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 08:22:10 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs-progs: print-tree: Add output for node flags
 and backref version
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180322073711.5943-1-wqu@suse.com>
 <20180322073711.5943-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6b4c51f9-c487-3062-29fc-04c8c5df4c45@suse.com>
Date: Thu, 22 Mar 2018 10:22:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180322073711.5943-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.03.2018 09:37, Qu Wenruo wrote:
> Just like what we did for leaf, also add this output to make it easier
> to distinguish tree reloc tree blocks.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  print-tree.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/print-tree.c b/print-tree.c
> index d5bb413019bb..a82cdc945247 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1364,11 +1364,14 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
>  
>  void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int follow)
>  {
> +	u8 backref_rev;
>  	u32 i;
>  	u32 nr;
> +	u64 flags;
>  	struct btrfs_disk_key disk_key;
>  	struct btrfs_key key;
>  	struct extent_buffer *next;
> +	char flags_str[HEADER_FLAGS_BUF_LEN];
>  
>  	if (!eb)
>  		return;
> @@ -1377,6 +1380,9 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
>  		btrfs_print_leaf(root, eb);
>  		return;
>  	}
> +	flags = btrfs_header_flags(eb) & ~BTRFS_BACKREF_REV_MASK;
> +	backref_rev = btrfs_header_flags(eb) >> BTRFS_BACKREF_REV_SHIFT;
> +	header_flags_to_str(flags, flags_str);
>  	printf("node %llu level %d items %d free %u generation %llu owner ",
>  	       (unsigned long long)eb->start,
>  	        btrfs_header_level(eb), nr,
> @@ -1384,6 +1390,8 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
>  		(unsigned long long)btrfs_header_generation(eb));
>  	print_objectid(stdout, btrfs_header_owner(eb), 0);
>  	printf("\n");
> +	printf("node %llu flags 0x%llx(%s) backref revision %d\n",
> +		eb->start, flags, flags_str, backref_rev);
>  	print_uuids(eb);
>  	fflush(stdout);
>  	for (i = 0; i < nr; i++) {
> 
