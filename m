Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbbFRQop (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 12:44:45 -0400
Date: Thu, 18 Jun 2015 18:44:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Robert Marklund <robbelibobban@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] check: check so offset is not bigger then the leaf
Message-ID: <20150618164443.GH6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 01:59:13AM +0200, Robert Marklund wrote:
> This could crash before because of dangerous dangling
> offset of pointer.

That's right, this can happen. There are more btrfs_item_ptr that would
be good to validate that way, namely in the checker as it's most likely
to see corrupted data.

I think it's worth to add a wrapper macro for that, that would be like

(int) btrfs_item_ptr_validate(ei, leaf, slot, struct ..., *optional_key)

and return 0 if it's ok, 1 if there's a problem and prints the details.

> Signed-off-by: Robert Marklund <robbelibobban@gmail.com>
> ---
>  cmds-check.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 778f141..da36758 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -8906,6 +8906,16 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
>  			goto next;
>  
>  		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
> +
> +		if ((long long)ei > info->extent_root->leafsize) {
> +			 fprintf(stderr, "Bad leaf = %p, slot = %d\n", leaf, slot);
> +			 fprintf(stderr, "item ptr = %p\n", ei);
> +			 fprintf(stderr, "objectid = %llx\n", found_key.objectid);
> +			 fprintf(stderr, "type     = %x\n", found_key.type);
> +			 fprintf(stderr, "offset   = %llx\n", found_key.offset);

Hm, I'm not sure whether to continue or fail at this point.

Do you have a crafted filesystem image that can reproduce that or was
that found by code inspection?

> +			 goto next;
> +		}
> +
>  		flags = btrfs_extent_flags(leaf, ei);
>  
>  		if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
