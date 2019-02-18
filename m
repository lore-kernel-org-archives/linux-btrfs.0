Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F00FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F90E20838
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbfBRJ02 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:26:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:57268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728447AbfBRJ01 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 04:26:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D312AEDF;
        Mon, 18 Feb 2019 09:26:25 +0000 (UTC)
Subject: Re: [PATCH v5.1 12/12] btrfs: Do mandatory tree block check before
 submitting bio
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-13-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7a0248d2-754d-e352-796b-df41f9fbce53@suse.com>
Date:   Mon, 18 Feb 2019 11:26:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218052753.24138-13-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 18.02.19 г. 7:27 ч., Qu Wenruo wrote:
> There are at least 2 reports about memory bit flip sneaking into on-disk
> data.
> 
> Currently we only have a relaxed check triggered at
> btrfs_mark_buffer_dirty() time, as it's not mandatory and only for
> CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build, it doesn't help user to
> detect such problem.
> 
> This patch will address the hole by triggering comprehensive check on
> tree blocks before writing it back to disk.
> 
> The design points are:
> - Timing of the check: Tree block write hook
>   This timing is chosen to reduce the overhead.
>   The comprehensive check should be as expensive as csum.
>   Doing full check at btrfs_mark_buffer_dirty() is too expensive for end
>   user.
> 
> - Loose empty leaf check
>   Originally for empty leaf, tree-checker will report error if it's not
>   a tree root.
>   The problem for such check at write time is:
>   * False alert for tree root created in current transaction
>     In that case, the commit root still needs to be written to disk.
>     And since current root can differ from commit root, then it will
>     cause false alert.
>     This happens for log tree.
> 
>   * False alert for relocated tree block
>     Relocated tree block can be written to disk due to memory pressure,
>     in that case an empty csum tree root can be written to disk and
>     cause false alert, since csum root node hasn't been updated.
> 
>   Although some more reliable empty leaf check is still kept as is.
>   Namely essential trees (e.g. extent, chunk) should never be empty.
> 
> The example error output will be something like:
>   BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>   BTRFS error (device dm-3): block=1350630375424 write time tree block corruption detected
>   BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
>   BTRFS info (device dm-3): forced readonly
>   BTRFS warning (device dm-3): Skipping commit of aborted transaction.
>   BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
>   BTRFS info (device dm-3): delayed_refs has NO entry
> 
> Reported-by: Leonard Lausen <leonard@lausen.nl>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c      | 10 ++++++++++
>  fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
>  fs/btrfs/tree-checker.h |  8 ++++++++
>  3 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6052ab508f84..fff789f8db63 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>  			return -EUCLEAN;
>  		}
>  	} else {
> +		if (btrfs_header_level(buf))
> +			err = btrfs_check_node(fs_info, buf);
> +		else
> +			err = btrfs_check_leaf_write(fs_info, buf);
> +		if (err < 0) {
> +			btrfs_err(fs_info,
> +			"block=%llu write time tree block corruption detected",
> +				  buf->start);
> +			return err;
> +		}

This code should be moved in csum_dirty_buffer. Currently there is
pending cleanups in csum_tree_block and the final if there will be
removed and respective read/write code factored out in
csum_dirty_buffer/btree_readpage_end_io_hook.

Eventually csum_tree_block's sole purpose should be to calculate the
checksum and nothing more.

>  		write_extent_buffer(buf, result, 0, csum_size);
>  	}
>  
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index a62e1e837a89..b8cdaf472031 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -477,7 +477,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  }
>  
>  static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
> -		      bool check_item_data)
> +		      bool check_item_data, bool check_empty_leaf)
>  {
>  	/* No valid key type is 0, so all key should be larger than this key */
>  	struct btrfs_key prev_key = {0, 0, 0};
> @@ -516,6 +516,18 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>  				    owner);
>  			return -EUCLEAN;
>  		}
> +
> +		/*
> +		 * Skip empty leaf check, mostly for write time tree block
> +		 *
> +		 * Such skip mostly happens for tree block write time, as
> +		 * we can't use @owner as accurate owner indicator.
> +		 * Case like balance and new tree block created for commit root
> +		 * can break owner check easily.
> +		 */
> +		if (!check_empty_leaf)
> +			return 0;
> +
>  		key.objectid = owner;
>  		key.type = BTRFS_ROOT_ITEM_KEY;
>  		key.offset = (u64)-1;
> @@ -636,13 +648,19 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>  int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
>  			  struct extent_buffer *leaf)
>  {
> -	return check_leaf(fs_info, leaf, true);
> +	return check_leaf(fs_info, leaf, true, true);
>  }
>  
>  int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
>  			     struct extent_buffer *leaf)
>  {
> -	return check_leaf(fs_info, leaf, false);
> +	return check_leaf(fs_info, leaf, false, true);
> +}
> +
> +int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
> +			   struct extent_buffer *leaf)
> +{
> +	return check_leaf(fs_info, leaf, false, false);
>  }
>  
>  int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
> diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
> index ff043275b784..6f8d1b627c53 100644
> --- a/fs/btrfs/tree-checker.h
> +++ b/fs/btrfs/tree-checker.h
> @@ -23,6 +23,14 @@ int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
>   */
>  int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
>  			     struct extent_buffer *leaf);
> +
> +/*
> + * Write time specific leaf checker.
> + * Don't check if the empty leaf belongs to a tree root. Mostly for balance
> + * and new tree created in current transaction.
> + */
> +int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
> +			   struct extent_buffer *leaf);
>  int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
>  
>  #endif
> 
