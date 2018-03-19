Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50155 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932277AbeCSMHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 08:07:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5BB8AACF8
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 12:07:13 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180319102810.24356-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7dd81c72-771b-86e4-0394-946f4def4dc9@suse.com>
Date: Mon, 19 Mar 2018 14:07:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180319102810.24356-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.03.2018 12:28, Qu Wenruo wrote:
> Commit Fixes: 8c36786c8198 ("btrfs-progs: print-tree: Print offset as tree objectid for ROOT_ITEM")
> changes how we translate offset of ROOT_ITEM.
> 
> However the fact is, even for ROOT_ITEM, we have different meaning of
> offset.
> 
> For tree reloc tree, it's indeed subvolume id.
> But for other trees, it's the transid of when it's created.
> 
> Fix it.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  print-tree.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index 45350fea0963..848e296c4e67 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -834,7 +834,16 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
>  	 */
>  	case BTRFS_ROOT_ITEM_KEY:
>  		printf(" ");
> -		print_objectid(stdout, offset, type);
> +		/*
> +		 * Normally offset of ROOT_ITEM should presents the generation
> +		 * when this root is created.
> +		 * However if this is tree reloc tree, offset is the subvolume
> +		 * id of its source. Here we do extra check on this.
> +		 */
> +		if (objectid == BTRFS_TREE_RELOC_OBJECTID)
> +			print_objectid(stdout, offset, type);
> +		else
> +			printf("%lld", offset);
>  		printf(")");

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

>  		break;
>  	default:
> 
