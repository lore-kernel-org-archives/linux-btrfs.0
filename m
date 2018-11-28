Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE17C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 11:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35CE320832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 11:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35CE320832
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbeK1WZJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 17:25:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:45196 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727678AbeK1WZJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 17:25:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03872AD4A;
        Wed, 28 Nov 2018 11:23:47 +0000 (UTC)
Subject: Re: [PATCH] Fix typos
To:     Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <54384bb2-e602-a1d5-ea6f-96513d7e1f3a@suse.com>
Date:   Wed, 28 Nov 2018 13:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181128110513.6079-1-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.11.18 г. 13:05 ч., Andrea Gelmini wrote:
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
> 
> Stupid fixes. Made on 4.20-rc4, and ported on linux-next (next-20181128).
> 
> 
>  fs/btrfs/backref.c         |  4 ++--
>  fs/btrfs/check-integrity.c |  2 +-
>  fs/btrfs/compression.c     |  4 ++--
>  fs/btrfs/ctree.c           |  4 ++--
>  fs/btrfs/dev-replace.c     |  2 +-
>  fs/btrfs/disk-io.c         |  4 ++--
>  fs/btrfs/extent-tree.c     | 28 ++++++++++++++--------------
>  fs/btrfs/extent_io.c       |  4 ++--
>  fs/btrfs/extent_io.h       |  2 +-
>  fs/btrfs/extent_map.c      |  2 +-
>  fs/btrfs/file.c            |  6 +++---
>  fs/btrfs/free-space-tree.c |  2 +-
>  fs/btrfs/inode.c           | 10 +++++-----
>  fs/btrfs/ioctl.c           |  4 ++--
>  fs/btrfs/lzo.c             |  2 +-
>  fs/btrfs/qgroup.c          | 14 +++++++-------
>  fs/btrfs/qgroup.h          |  4 ++--
>  fs/btrfs/raid56.c          |  2 +-
>  fs/btrfs/ref-verify.c      |  6 +++---
>  fs/btrfs/relocation.c      |  2 +-
>  fs/btrfs/scrub.c           |  2 +-
>  fs/btrfs/send.c            |  4 ++--
>  fs/btrfs/super.c           |  8 ++++----
>  fs/btrfs/transaction.c     |  4 ++--
>  fs/btrfs/tree-checker.c    |  6 +++---
>  fs/btrfs/tree-log.c        |  4 ++--
>  fs/btrfs/volumes.c         |  8 ++++----
>  27 files changed, 72 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 4a15f87dbbb4..78556447e1d5 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -591,7 +591,7 @@ unode_aux_to_inode_list(struct ulist_node *node)
>  }
>  
>  /*

<snip>

> @@ -9807,7 +9807,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache)
>  }
>  
>  /*
> - * checks to see if its even possible to relocate this block group.
> + * checks to see if it's even possible to relocate this block group.
>   *
>   * @return - false if not enough space can be found for relocation, true
>   * otherwise
> @@ -9872,7 +9872,7 @@ bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>  	 * ok we don't have enough space, but maybe we have free space on our
>  	 * devices to allocate new chunks for relocation, so loop through our
>  	 * alloc devices and guess if we have enough space.  if this block
> -	 * group is going to be restriped, run checks against the target
> +	 * group is going to be restripped, run checks against the target

Drop this hunk, here we mean to restripe the changes and not restrip
them. So restriped is the correct past tense of the verb.

>  	 * profile instead of the current one.
>  	 */
>  	can_reloc = false;
> @@ -10424,7 +10424,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  		 * check for two cases, either we are full, and therefore
>  		 * don't need to bother with the caching work since we won't
>  		 * find any space, or we are empty, and we can just add all
> -		 * the space in and be done with it.  This saves us _alot_ of
> +		 * the space in and be done with it.  This saves us _a_lot_ of

This should be _a lot_

>  		 * time, particularly in the full case.
>  		 */
>  		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
> @@ -10700,7 +10700,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  
>  	mutex_lock(&trans->transaction->cache_write_mutex);
>  	/*
> -	 * make sure our free spache cache IO is done before remove the
> +	 * make sure our free space cache IO is done before remove the

I think there should be a 'we' before 'remove'

>  	 * free space inode
>  	 */
>  	spin_lock(&trans->transaction->dirty_bgs_lock);
> @@ -11217,7 +11217,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>  	if (!blk_queue_discard(bdev_get_queue(device->bdev)))
>  		return 0;
>  
> -	/* Not writeable = nothing to do. */
> +	/* Not writable = nothing to do. */

This comment is redundant so could be removed altogether

>  	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
>  		return 0;
>  
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index aef3c9866ff0..1493f0c102ec 100644

<snip>

> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index e5089087eaa6..13e71efcfe21 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -550,7 +550,7 @@ static void free_space_set_bits(struct btrfs_block_group_cache *block_group,
>  
>  /*
>   * We can't use btrfs_next_item() in modify_free_space_bitmap() because
> - * btrfs_next_leaf() doesn't get the path for writing. We can forgo the fancy
> + * btrfs_next_leaf() doesn't get the path for writing. We can forgot the fancy

Drop this hunk, the meaning is we can eschew the fancy tree walking.

>   * tree walking in btrfs_next_leaf() anyways because we know exactly what we're
>   * looking for.
>   */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index bab2f1983c07..babbd75d91d2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -104,7 +104,7 @@ static void __endio_write_update_ordered(struct inode *inode,
>  
>  /*
>   * Cleanup all submitted ordered extents in specified range to handle errors
> - * from the fill_dellaloc() callback.
> + * from the fill_delalloc() callback.

This is a pure whitespace fix which is generally frowned upon. What you
can do though, is replace 'fill_delalloc callback' with
'btrfs_run_delalloc_range' since the callback is gone already.

>   *
>   * NOTE: caller must ensure that when an error happens, it can not call
>   * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
> @@ -1831,7 +1831,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,

<snip>

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 410c7e007ba8..d7b6c2b09a0c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -892,7 +892,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>   *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
>   *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
>   *  9. We can't remove a root or mountpoint.
> - * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
> + * 10. We don't allow removal of NFS silly renamed files; it's handled by
>   *     nfs_async_unlink().
>   */
>  
> @@ -3522,7 +3522,7 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
>  					       false);
>  	/*
>  	 * If one of the inodes has dirty pages in the respective range or
> -	 * ordered extents, we need to flush dellaloc and wait for all ordered
> +	 * ordered extents, we need to flush delalloc and wait for all ordered

Just whitespace fix, drop it.

<snip>
