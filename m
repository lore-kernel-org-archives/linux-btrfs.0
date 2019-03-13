Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A842C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563D52173C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfCMJlM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:41:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:46722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726163AbfCMJlM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 05:41:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3DF41AC18;
        Wed, 13 Mar 2019 09:41:10 +0000 (UTC)
Subject: Re: [PATCH 6/6] btrfs: inode: Verify inode mode to avoid NULL pointer
 dereference
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-7-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <fc6274c2-a0a0-c87b-c7cb-8d6366860c20@suse.com>
Date:   Wed, 13 Mar 2019 11:41:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313085511.23540-7-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.03.19 г. 10:55 ч., Qu Wenruo wrote:
> [BUG]
> When access a file on a crafted image, btrfs can crash in block layer:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> PGD 136501067 P4D 136501067 PUD 124519067 PMD 0
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.0.0-rc8-default #252
> RIP: 0010:end_bio_extent_readpage+0x144/0x700
> Call Trace:
>  <IRQ>
>  blk_update_request+0x8f/0x350
>  blk_mq_end_request+0x1a/0x120
>  blk_done_softirq+0x99/0xc0
>  __do_softirq+0xc7/0x467
>  irq_exit+0xd1/0xe0
>  call_function_single_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:default_idle+0x1e/0x170
> 
> [CAUSE]
> The crafted image has a pretty tricky corruption, the INODE_ITEM has a
> different type against its parent dir:
>         item 20 key (268 INODE_ITEM 0) itemoff 2808 itemsize 160
>                 generation 13 transid 13 size 1048576 nbytes 1048576
>                 block group 0 mode 121644 links 1 uid 0 gid 0 rdev 0
>                 sequence 9 flags 0x0(none)
> 
> This mode number 0120000 means it's a soft link.
> 
> But the dir item think it's still a regular file:
>         item 8 key (264 DIR_INDEX 5) itemoff 3707 itemsize 32
>                 location key (268 INODE_ITEM 0) type FILE
>                 transid 13 data_len 0 name_len 2
>                 name: f4
>         item 40 key (264 DIR_ITEM 51821248) itemoff 1573 itemsize 32
>                 location key (268 INODE_ITEM 0) type FILE
>                 transid 13 data_len 0 name_len 2
>                 name: f4
> 
> For btrfs symlink, we don't set BTRFS_I(inode)->io_tree.ops and leave
> it empty, as symlink is only designed to have inlined extent, all
> handled by tree block read.
> Thus no need to trigger btrfs_submit_bio_hook() for inline file extent.
> 
> However for end_bio_extent_readpage() it expects tree->ops populated, as
> it's reading regular data extent.
> This causes NULL pointer dereference.
> 
> [FIX]
> This patch fixes the problem by 2 directions:
> - Verify inode mode against its dir item when looking up inode
>   So in btrfs_lookup_dentry() if we find inode mode mismatch with dir
>   item, we error out so that corrupted inode will not be access.
> 
> - Verify inode mode when getting extent mapping
>   Only regular file should have regular or preallocated extent.
>   If we found regular/preallocated file extent for soft link or
>   whatever, we error out before we submit read bio.
> 
> With this fix that crafted image can be rejected gracefully:
>   BTRFS critical (device loop0): inode mode mismatch with dir: inode mode=0121644 btrfs type=7 dir type=1
> 
> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202763
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c             | 38 ++++++++++++++++++++++++++++--------
>  fs/btrfs/tests/inode-tests.c |  1 +
>  2 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5c349667c761..4ced641aaa8e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5396,12 +5396,13 @@ void btrfs_evict_inode(struct inode *inode)
>  }
>  
>  /*
> - * this returns the key found in the dir entry in the location pointer.
> + * this returns the key found in the dir entry in the location pointer,
> + * fill @type with BTRFS_FT_*, and return 0.
>   * If no dir entries were found, returns -ENOENT.
>   * If found a corrupted location in dir entry, returns -EUCLEAN.
>   */
>  static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
> -			       struct btrfs_key *location)
> +			       struct btrfs_key *location, u8 *type)
>  {
>  	const char *name = dentry->d_name.name;
>  	int namelen = dentry->d_name.len;
> @@ -5430,6 +5431,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>  			   __func__, name, btrfs_ino(BTRFS_I(dir)),
>  			   location->objectid, location->type, location->offset);
>  	}
> +	if (!ret)
> +		*type = btrfs_dir_type(path->nodes[0], di);
>  out:
>  	btrfs_free_path(path);
>  	return ret;
> @@ -5667,6 +5670,11 @@ static struct inode *new_simple_dir(struct super_block *s,
>  	return inode;
>  }
>  
> +static inline u8 btrfs_inode_type(struct inode *inode)
> +{
> +	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
> +}
> +
>  struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
> @@ -5674,18 +5682,29 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>  	struct btrfs_root *sub_root = root;
>  	struct btrfs_key location;
> +	u8 di_type = 0;
>  	int index;
>  	int ret = 0;
>  
>  	if (dentry->d_name.len > BTRFS_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	ret = btrfs_inode_by_name(dir, dentry, &location);
> +	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
>  
>  	if (location.type == BTRFS_INODE_ITEM_KEY) {
>  		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
> +
> +		/* Do extra check against inode mode with di_type */
> +		if (btrfs_inode_type(inode) != di_type) {
> +			btrfs_crit(fs_info,
> +"inode mode mismatch with dir: inode mode=0%o btrfs type=%u dir type=%u",
> +				  inode->i_mode, btrfs_inode_type(inode),
> +				  di_type);
> +			iput(inode);
> +			return ERR_PTR(-EUCLEAN);
> +		}
>  		return inode;
>  	}
>  
> @@ -6290,11 +6309,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	return ERR_PTR(ret);
>  }
>  
> -static inline u8 btrfs_inode_type(struct inode *inode)
> -{
> -	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
> -}
> -
>  /*
>   * utility function to add 'inode' into 'parent_inode' with
>   * a give name and a given sequence number.
> @@ -6816,6 +6830,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  	extent_start = found_key.offset;
>  	if (found_type == BTRFS_FILE_EXTENT_REG ||
>  	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
> +		/* Only regular file could have regular/prealloc extent */
> +		if (!S_ISREG(inode->vfs_inode.i_mode)) {
> +			ret = -EUCLEAN;
> +			btrfs_crit(fs_info,
> +		"regular/prealloc extent found for non-regular inode %llu",
> +				   btrfs_ino(inode));
> +			goto out;
> +		}
>  		extent_end = extent_start +
>  		       btrfs_file_extent_num_bytes(leaf, item);
>  
> diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
> index af0c8e30d9e2..b01dbcab9eed 100644
> --- a/fs/btrfs/tests/inode-tests.c
> +++ b/fs/btrfs/tests/inode-tests.c
> @@ -232,6 +232,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
>  		return ret;
>  	}
>  
> +	inode->i_mode = S_IFREG;
>  	BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
>  	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
>  	BTRFS_I(inode)->location.offset = 0;
> 
