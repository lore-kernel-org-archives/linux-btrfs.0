Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3JXOtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:49:10 -0400
Received: by mail-pb0-f46.google.com with SMTP id un1so2703770pbc.5
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 07:49:09 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting (bug #61951)
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
Date: Thu, 24 Oct 2013 22:49:03 +0800
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, dustymabe@gmail.com
Message-Id: <801531AB-DF1E-44AC-B58E-D0388C7FCC55@gmail.com>
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
> tracking is based on delayed refs. The owner of a tree block is set when a
> tree block is allocated, it is never updated.
> 
> When you allocate a tree block and then remove the subvolume that did the
> allocation, the qgroup accounting for that removal is correct. However, the
> removal was accounted again for each subvolume deletion that also referenced
> the tree block, because accounting was erroneously based on the owner.
> 
> Instead of queueing delayed refs for the non-existent owner, we now
> queue delayed refs for the root being removed. This fixes the qgroup
> accounting.

Thanks for tracking this, i apply your patch, and using the flowing patch,
found the problem still exist, the test script like the following:

#!/bin/sh

for i in $(seq 1000)
do
	dd if=/dev/zero of=<mnt>/$i""aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  bs=10K count=1
done

btrfs sub snapshot <mnt> <mnt>/1
for i in $(seq 100)
do
	btrfs sub snapshot <mnt>/$i <mnt>/$(($i+1))
done

for i in $(seq 101)
do
	btrfs sub delete <mnt>/$i
done


Thanks,
Wang
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> Tested-by: <dustymabe@gmail.com>
> ---
> fs/btrfs/extent-tree.c |   14 +++++++++-----
> 1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d58bef1..7846cae 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3004,12 +3004,11 @@ out:
> static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
> 			   struct btrfs_root *root,
> 			   struct extent_buffer *buf,
> -			   int full_backref, int inc, int for_cow)
> +			   int full_backref, u64 ref_root, int inc, int for_cow)
> {
> 	u64 bytenr;
> 	u64 num_bytes;
> 	u64 parent;
> -	u64 ref_root;
> 	u32 nritems;
> 	struct btrfs_key key;
> 	struct btrfs_file_extent_item *fi;
> @@ -3019,7 +3018,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
> 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
> 			    u64, u64, u64, u64, u64, u64, int);
> 
> -	ref_root = btrfs_header_owner(buf);
> 	nritems = btrfs_header_nritems(buf);
> 	level = btrfs_header_level(buf);
> 
> @@ -3075,13 +3073,19 @@ fail:
> int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> 		  struct extent_buffer *buf, int full_backref, int for_cow)
> {
> -	return __btrfs_mod_ref(trans, root, buf, full_backref, 1, for_cow);
> +	u64 ref_root;
> +
> +	ref_root = btrfs_header_owner(buf);
> +
> +	return __btrfs_mod_ref(trans, root, buf, full_backref, ref_root,
> +			       1, for_cow);
> }
> 
> int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> 		  struct extent_buffer *buf, int full_backref, int for_cow)
> {
> -	return __btrfs_mod_ref(trans, root, buf, full_backref, 0, for_cow);
> +	return __btrfs_mod_ref(trans, root, buf, full_backref, root->objectid,
> +			       0, for_cow);
> }
> 
> static int write_one_cache_group(struct btrfs_trans_handle *trans,
> -- 
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

