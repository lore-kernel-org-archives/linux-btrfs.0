Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CBAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15E2D2183F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfCMJ20 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:28:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:44956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727321AbfCMJ20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 05:28:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A192B010
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 09:28:23 +0000 (UTC)
Subject: Re: [PATCH 5/6] btrfs: tree-checker: Verify inode item
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-6-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <53f3d158-c7bd-d3ae-f7ca-93d59f5a76a6@suse.com>
Date:   Wed, 13 Mar 2019 11:28:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313085511.23540-6-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.03.19 г. 10:55 ч., Qu Wenruo wrote:
> There is a report in kernel bugzilla about mismatch file type in dir
> item and inode item.
> 
> This inspires us to check inode mode in inode item.
> 
> This patch will check the following members:
> - inode key objectid
>   Should be ROOT_DIR_DIR or [256, (u64)-256] or FREE_INO.
> 
> - inode key offset
>   Should be 0
> 
> - inode item generation
> - inode item transid
>   No newer than sb generation + 1.
>   The +1 is for log tree.
> 
> - inode item mode
>   No unknown bits.
>   No invalid S_IF* bit.
>   NOTE: S_IFMT check is not enough, need extra check for it.
> 
> - inode item nlink
>   Dir should have no more link than 1.
> 
> - inode item flags
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h        |  2 +
>  fs/btrfs/tree-checker.c | 99 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 101 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7a2a2621f0d9..f002c63a34e3 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1504,6 +1504,8 @@ do {                                                                   \
>  #define BTRFS_INODE_COMPRESS		(1 << 11)
>  
>  #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
> +#define BTRFS_INODE_FLAG_MASK		(((1 << 12) - 1) |\
> +					 BTRFS_INODE_ROOT_ITEM_INIT)
>  
>  struct btrfs_map_token {
>  	const struct extent_buffer *eb;
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index c08609627720..4b178ef1a9e7 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -682,6 +682,102 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
>  	return -EUCLEAN;
>  }
>  
> +/* Inode item error output has the same format as dir_item_err() */
> +#define inode_item_err(fs_info, eb, slot, fmt, ...)	\
> +	dir_item_err(fs_info, eb, slot, fmt, __VA_ARGS__)
> +
> +static int check_inode_item(struct btrfs_fs_info *fs_info,
> +			    struct extent_buffer *leaf,
> +			    struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_inode_item *iitem;
> +	u64 super_gen = btrfs_super_generation(fs_info->super_copy);
> +	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
> +	u32 mode;
> +
> +	if ((key->objectid < BTRFS_FIRST_FREE_OBJECTID ||
> +	     key->objectid > BTRFS_LAST_FREE_OBJECTID) &&
> +	     key->objectid != BTRFS_ROOT_TREE_DIR_OBJECTID &&
> +	     key->objectid != BTRFS_FREE_INO_OBJECTID) {
> +		generic_err(fs_info, leaf, slot,
> +	"invalid key objectid: has %llu expect %llu or [%llu, %llu] or %llu",
> +			    key->objectid, BTRFS_ROOT_TREE_DIR_OBJECTID,
> +			    BTRFS_FIRST_FREE_OBJECTID,
> +			    BTRFS_LAST_FREE_OBJECTID,
> +			    BTRFS_FREE_INO_OBJECTID);
> +		goto error;
> +	}
> +	if (key->offset != 0) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid key offset: has %llu expect 0",
> +			key->offset);
> +		goto error;
> +	}
> +	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
> +
> +	/* Here we use super block generation + 1 to handle log tree */
> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect (0, %llu]",
> +			       btrfs_inode_generation(leaf, iitem),
> +			       super_gen + 1);
> +		goto error;
> +	}
> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could make its transid as 0 */
> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect [0, %llu]",
> +			       btrfs_inode_transid(leaf, iitem),
> +			       super_gen + 1);
> +		goto error;
> +	}
> +
> +	/*
> +	 * For size and nbytes it's better not to be too strict, as for dir
> +	 * item its size/nbytes can easily get wrong, but doesn't affect
> +	 * any thing of the fs. So here we skip the check.
> +	 */
> +
> +	mode = btrfs_inode_mode(leaf, iitem);
> +	if (mode & ~valid_mask) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "unknown mode bit detected: 0x%x",
> +			       mode & ~valid_mask);
> +		goto error;
> +	}
> +
> +	/*
> +	 * S_IFMT is not bit mapped so we can't completely rely is_power_of_2(),
> +	 * but is_power_of_2() can save us from checking FIFO/CHR/DIR/REG.
> +	 * Only needs to check BLK, LNK and SOCKS
> +	 */
> +	if (!is_power_of_2(mode & S_IFMT)) {
> +		if (!S_ISLNK(mode) && ! S_ISBLK(mode) && !S_ISSOCK(mode)) {
> +			inode_item_err(fs_info, leaf, slot,
> +			"invalid mode: has 0%o expect valid S_IF* bit(s)",
> +				       mode & S_IFMT);
> +			goto error;
> +		}
> +	}
> +	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "invalid nlink: has %u expect no more than 1 for dir",
> +			btrfs_inode_nlink(leaf, iitem));
> +		goto error;
> +	}
> +	if (btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "unknown flags detected: 0x%llx",
> +			       btrfs_inode_flags(leaf, iitem) &
> +			       ~BTRFS_INODE_FLAG_MASK);
> +		goto error;
> +	}
> +	return 0;
> +
> +error:
> +	return -EUCLEAN;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -715,6 +811,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  	case BTRFS_DEV_ITEM_KEY:
>  		ret = check_dev_item(fs_info, leaf, key, slot);
>  		break;
> +	case BTRFS_INODE_ITEM_KEY:
> +		ret = check_inode_item(fs_info, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
> 
