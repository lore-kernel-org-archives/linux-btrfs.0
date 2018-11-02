Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DEEC65C22
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 10:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 165C42081F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 10:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 165C42081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbeKBTHj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 15:07:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:49928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725935AbeKBTHj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 15:07:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B8AEACBD;
        Fri,  2 Nov 2018 10:01:01 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: use tagged writepage to mitigate livelock of
 snapshot
To:     Ethan Lien <ethanlien@synology.com>, linux-btrfs@vger.kernel.org
References: <20181102090607.19804-1-ethanlien@synology.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7be70783-26a4-0d95-fafc-ba79cfede9c9@suse.com>
Date:   Fri, 2 Nov 2018 12:00:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181102090607.19804-1-ethanlien@synology.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2.11.18 г. 11:06 ч., Ethan Lien wrote:
> Snapshot is expected to be fast. But if there are writers steadily
> create dirty pages in our subvolume, the snapshot may take a very long
> time to complete. To fix the problem, we use tagged writepage for
> snapshot flusher as we do in generic write_cache_pages(): we quickly
> tag all dirty pages with a TOWRITE tag, then do the hard work of
> writepage only on those pages with TOWRITE tag, so we ommit pages dirtied
> after the snapshot command.
> 
> We do a simple snapshot speed test on a Intel D-1531 box:
> 
> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=write --size=64G
> --direct=0 --thread=1 --numjobs=1 --time_based --runtime=120
> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
> 
> original: 1m58sec
> patched:  6.54sec
> 
> This is the best case for this patch since for a sequential write case,
> we omit nearly all pages dirtied after the snapshot command.
> 
> For a multi writers, random write test:
> 
> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=randwrite --size=64G
> --direct=0 --thread=1 --numjobs=4 --time_based --runtime=120
> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
> 
> original: 15.83sec
> patched:  10.35sec
> 
> The improvement is less compared with the sequential write case, since
> we omit only half of the pages dirtied after snapshot command.
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

Codewise it looks good, though I'd also document the reason you are
using  wbc->nr_to_write == LONG_MAX (i.e the fact that other flushers
might race and inadvertently disable the snapshot flag) but this is
something which David can fix on the way in. So:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> 
> V2:
> 	Add more details in commit message.
> 	rename BTRFS_INODE_TAGGED_FLUSH to BTRFS_INODE_SNAPSHOT_FLUSH.
> 	remove unnecessary sync_mode check.
> 	start_delalloc_inodes use boolean argument.
> 
>  fs/btrfs/btrfs_inode.h |  1 +
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/extent_io.c   | 14 ++++++++++++--
>  fs/btrfs/inode.c       | 10 ++++++----
>  fs/btrfs/ioctl.c       |  2 +-
>  5 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1343ac57b438..ffc9a1c77375 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -29,6 +29,7 @@ enum {
>  	BTRFS_INODE_IN_DELALLOC_LIST,
>  	BTRFS_INODE_READDIO_NEED_LOCK,
>  	BTRFS_INODE_HAS_PROPS,
> +	BTRFS_INODE_SNAPSHOT_FLUSH,
>  };
>  
>  /* in memory btrfs inode */
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2cddfe7806a4..82682da5a40d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3155,7 +3155,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  			       struct inode *inode, u64 new_size,
>  			       u32 min_type);
>  
> -int btrfs_start_delalloc_inodes(struct btrfs_root *root);
> +int btrfs_start_delalloc_snapshot(struct btrfs_root *root);
>  int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr);
>  int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
>  			      unsigned int extra_bits,
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4dd6faab02bb..93f2e413535d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3928,12 +3928,22 @@ static int extent_write_cache_pages(struct address_space *mapping,
>  			range_whole = 1;
>  		scanned = 1;
>  	}
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +
> +	/*
> +	 * We do the tagged writepage as long as the snapshot flush bit is set
> +	 * and we are the first one who do the filemap_flush() on this inode.
> +	 */
> +	if (range_whole && wbc->nr_to_write == LONG_MAX &&
> +			test_and_clear_bit(BTRFS_INODE_SNAPSHOT_FLUSH,
> +				&BTRFS_I(inode)->runtime_flags))
> +		wbc->tagged_writepages = 1;
> +
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
>  		tag = PAGECACHE_TAG_TOWRITE;
>  	else
>  		tag = PAGECACHE_TAG_DIRTY;
>  retry:
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
>  		tag_pages_for_writeback(mapping, index, end);
>  	done_index = index;
>  	while (!done && !nr_to_write_done && (index <= end) &&
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3ea5339603cf..593445d122ed 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9975,7 +9975,7 @@ static struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode
>   * some fairly slow code that needs optimization. This walks the list
>   * of all the inodes with pending delalloc and forces them to disk.
>   */
> -static int start_delalloc_inodes(struct btrfs_root *root, int nr)
> +static int start_delalloc_inodes(struct btrfs_root *root, int nr, bool snapshot)
>  {
>  	struct btrfs_inode *binode;
>  	struct inode *inode;
> @@ -10003,6 +10003,8 @@ static int start_delalloc_inodes(struct btrfs_root *root, int nr)
>  		}
>  		spin_unlock(&root->delalloc_lock);
>  
> +		if (snapshot)
> +			set_bit(BTRFS_INODE_SNAPSHOT_FLUSH, &binode->runtime_flags);
>  		work = btrfs_alloc_delalloc_work(inode);
>  		if (!work) {
>  			iput(inode);
> @@ -10036,7 +10038,7 @@ static int start_delalloc_inodes(struct btrfs_root *root, int nr)
>  	return ret;
>  }
>  
> -int btrfs_start_delalloc_inodes(struct btrfs_root *root)
> +int btrfs_start_delalloc_snapshot(struct btrfs_root *root)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	int ret;
> @@ -10044,7 +10046,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root)
>  	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
>  		return -EROFS;
>  
> -	ret = start_delalloc_inodes(root, -1);
> +	ret = start_delalloc_inodes(root, -1, true);
>  	if (ret > 0)
>  		ret = 0;
>  	return ret;
> @@ -10073,7 +10075,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr)
>  			       &fs_info->delalloc_roots);
>  		spin_unlock(&fs_info->delalloc_root_lock);
>  
> -		ret = start_delalloc_inodes(root, nr);
> +		ret = start_delalloc_inodes(root, nr, false);
>  		btrfs_put_fs_root(root);
>  		if (ret < 0)
>  			goto out;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d60b6caf09e8..d1293b6c31f6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -775,7 +775,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	wait_event(root->subv_writers->wait,
>  		   percpu_counter_sum(&root->subv_writers->counter) == 0);
>  
> -	ret = btrfs_start_delalloc_inodes(root);
> +	ret = btrfs_start_delalloc_snapshot(root);
>  	if (ret)
>  		goto dec_and_free;
>  
> 
