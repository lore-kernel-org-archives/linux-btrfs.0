Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053A5C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 06:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC91B2147C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 06:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfBHGaN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 01:30:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:49296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbfBHGaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 01:30:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4AA4AF1F;
        Fri,  8 Feb 2019 06:30:10 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: reserve space for inheriting properties
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20190207165426.15866-1-josef@toxicpanda.com>
 <20190207165426.15866-2-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <12a76243-ae38-974b-957f-c50955d53934@suse.com>
Date:   Fri, 8 Feb 2019 08:30:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190207165426.15866-2-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 7.02.19 г. 18:54 ч., Josef Bacik wrote:
> We've been seeing errors on our build servers related to failing to
> inherit inode properties.  This is because we do not pre-reserve space
> for them, instead trying to reserve space with NO_FLUSH at inheritance
> time.  NO_FLUSH can transiently fail, but we'll still complain.  It's

Put one or two sentences describing the implications of
BTRFS_RESERVE_NO_FLUSH. I.e that it NO_FLUSH won't try to flush current
metadata reservation which could result in the said transient failure.
Just to give a bit more context for someone who might be reading the
commit message in the future.

> just an extra credit, so simply add that to the places that call
> btrfs_new_inode and call it good enough.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/inode.c | 78 ++++++++++++++++++++++----------------------------------
>  fs/btrfs/ioctl.c | 27 ++++++++++++--------
>  2 files changed, 46 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6126de9b8b9c..0da4a9d6d9fe 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -59,6 +59,14 @@ struct btrfs_dio_data {
>  	int overwrite;
>  };
>  
> +/*
> + * 2 for inode item and ref
> + * 2 for dir items
> + * 1 for xattr if selinux is on
> + * 1 for inherited properties
> + */
> +#define BTRFS_NEW_INODE_ITEMS 6

Rather than having scattered defines I'd much prefer if we have an enum
and over time add all distinct reservations to that enum and change
btrfs_start_transaction's interface to take this enum. It will be much
more descriptive than having scattered defines.

> +
>  static const struct inode_operations btrfs_dir_inode_operations;
>  static const struct inode_operations btrfs_symlink_inode_operations;
>  static const struct inode_operations btrfs_dir_ro_inode_operations;
> @@ -6479,12 +6487,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
>  	u64 objectid;
>  	u64 index = 0;
>  
> -	/*
> -	 * 2 for inode item and ref
> -	 * 2 for dir items
> -	 * 1 for xattr if selinux is on
> -	 */
> -	trans = btrfs_start_transaction(root, 5);
> +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> @@ -6543,12 +6546,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
>  	u64 objectid;
>  	u64 index = 0;
>  
> -	/*
> -	 * 2 for inode item and ref
> -	 * 2 for dir items
> -	 * 1 for xattr if selinux is on
> -	 */
> -	trans = btrfs_start_transaction(root, 5);
> +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> @@ -6695,12 +6693,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	u64 objectid = 0;
>  	u64 index = 0;
>  
> -	/*
> -	 * 2 items for inode and ref
> -	 * 2 items for dir items
> -	 * 1 for xattr if selinux is on
> -	 */
> -	trans = btrfs_start_transaction(root, 5);
> +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> @@ -9428,14 +9421,11 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>  		down_read(&fs_info->subvol_sem);
>  
>  	/*
> -	 * We want to reserve the absolute worst case amount of items.  So if
> -	 * both inodes are subvols and we need to unlink them then that would
> -	 * require 4 item modifications, but if they are both normal inodes it
> -	 * would require 5 item modifications, so we'll assume their normal
> -	 * inodes.  So 5 * 2 is 10, plus 2 for the new links, so 12 total items
> -	 * should cover the worst case number of items we'll modify.
> +	 * The same math from btrfs_rename applies here, except we need an extra
> +	 * 2 items for the new links.
>  	 */
> -	trans = btrfs_start_transaction(root, 12);
> +	trans = btrfs_start_transaction(root,
> +					(BTRFS_NEW_INODE_ITEMS << 1) + 2);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
>  		goto out_notrans;
> @@ -9768,19 +9758,19 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
>  		down_read(&fs_info->subvol_sem);
>  	/*
> -	 * We want to reserve the absolute worst case amount of items.  So if
> -	 * both inodes are subvols and we need to unlink them then that would
> -	 * require 4 item modifications, but if they are both normal inodes it
> -	 * would require 5 item modifications, so we'll assume they are normal
> -	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
> -	 * should cover the worst case number of items we'll modify.
> -	 * If our rename has the whiteout flag, we need more 5 units for the
> -	 * new inode (1 inode item, 1 inode ref, 2 dir items and 1 xattr item
> -	 * when selinux is enabled).
> +	 * We want to reserve the absolute worst case amount of items.  Subvol
> +	 * inodes don't have an inode item to worry about and don't have a
> +	 * selinux attr, so we use the BTRFS_NEW_INODE_ITEMS counter for how
> +	 * much it costs per inode to modify.  Worse case we'll have to mess
> +	 * with 2 inodes, so 2 x BTRFS_NEW_INODE_ITEMS, and then we need an
> +	 * extra reservation for the new link.
> +	 *
> +	 * If our rename has the whiteout flag we need a full new inode which
> +	 * means another set of BTRFS_NEW_INODE_ITEMS.
>  	 */
> -	trans_num_items = 11;
> +	trans_num_items = (BTRFS_NEW_INODE_ITEMS << 1) + 1;
>  	if (flags & RENAME_WHITEOUT)
> -		trans_num_items += 5;
> +		trans_num_items += BTRFS_NEW_INODE_ITEMS;
>  	trans = btrfs_start_transaction(root, trans_num_items);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
> @@ -10149,14 +10139,8 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
>  	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
>  		return -ENAMETOOLONG;
>  
> -	/*
> -	 * 2 items for inode item and ref
> -	 * 2 items for dir items
> -	 * 1 item for updating parent inode item
> -	 * 1 item for the inline extent item
> -	 * 1 item for xattr if selinux is on
> -	 */
> -	trans = btrfs_start_transaction(root, 7);
> +	/* 1 item for the inline extent item */
> +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> @@ -10427,10 +10411,8 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	u64 index;
>  	int ret = 0;
>  
> -	/*
> -	 * 5 units required for adding orphan entry
> -	 */
> -	trans = btrfs_start_transaction(root, 5);
> +	/* 1 unit required for adding orphan entry */
> +	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f38a659c918c..21f8ab2d8570 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -83,6 +83,17 @@ struct btrfs_ioctl_send_args_32 {
>  			       struct btrfs_ioctl_send_args_32)
>  #endif
>  
> +/*
> + * 1 - parent dir inode
> + * 2 - dir entries
> + * 1 - root item
> + * 2 - root ref/backref
> + * 1 - root of snapshot
> + * 1 - UUID item
> + * 1 - properties
> + */
> +#define BTRFS_NEW_ROOT_ITEMS 9

Even if you choose to have defines currently, I insist on them being
grouped in one place e.g. ctree.h

> +
>  static int btrfs_clone(struct inode *src, struct inode *inode,
>  		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
>  		       int no_time_update);
> @@ -596,7 +607,8 @@ static noinline int create_subvol(struct inode *dir,
>  	 * The same as the snapshot creation, please see the comment
>  	 * of create_snapshot().
>  	 */
> -	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 8, false);
> +	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
> +					       BTRFS_NEW_ROOT_ITEMS, false);
>  	if (ret)
>  		goto fail_free;
>  
> @@ -804,17 +816,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  
>  	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>  			     BTRFS_BLOCK_RSV_TEMP);
> -	/*
> -	 * 1 - parent dir inode
> -	 * 2 - dir entries
> -	 * 1 - root item
> -	 * 2 - root ref/backref
> -	 * 1 - root of snapshot
> -	 * 1 - UUID item
> -	 */
> +
>  	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
> -					&pending_snapshot->block_rsv, 8,
> -					false);
> +					&pending_snapshot->block_rsv,
> +					BTRFS_NEW_ROOT_ITEMS, false);
>  	if (ret)
>  		goto dec_and_free;
>  
> 
