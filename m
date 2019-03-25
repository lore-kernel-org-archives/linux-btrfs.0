Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AA1C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62AE220830
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfCYNoJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:44:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:39424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbfCYNoI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 09:44:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71F8DAC0C
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 13:44:06 +0000 (UTC)
Subject: Re: [PATCH v3 02/12] btrfs: combine device update operations during
 transaction commit
To:     linux-btrfs@vger.kernel.org
References: <20190325123132.27835-1-nborisov@suse.com>
 <20190325123132.27835-3-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <97cbfc6e-68ee-f35e-a280-163ddd809bb8@suse.com>
Date:   Mon, 25 Mar 2019 15:44:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190325123132.27835-3-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.03.19 г. 14:31 ч., Nikolay Borisov wrote:
> We currently overload the pending_chunks list to handle updating
> btrfs_device->commit_bytes used.  We don't actually care about
> the extent mapping or even the device mapping for the chunk - we
> just need the device, and we can end up processing it multiple
> times.  The fs_devices->resized_list does more or less the same
> thing, but with the disk size.  They are called consecutively
> during commit and have more or less the same purpose.
> 
> We can combine the two lists into a single list that attaches
> to the transaction and contains a list of devices that need
> updating.  Since we always add the device to a list when we
> change bytes_used or disk_total_size, there's no harm in
> copying both values at once.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/dev-replace.c |  2 +-
>  fs/btrfs/disk-io.c     |  7 ++++
>  fs/btrfs/transaction.c |  5 ++-
>  fs/btrfs/transaction.h |  1 +
>  fs/btrfs/volumes.c     | 84 ++++++++++++++++++------------------------
>  fs/btrfs/volumes.h     | 13 ++-----
>  6 files changed, 51 insertions(+), 61 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index ee193c5222b2..dba43ada41d1 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -662,7 +662,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	btrfs_device_set_disk_total_bytes(tgt_device,
>  					  src_device->disk_total_bytes);
>  	btrfs_device_set_bytes_used(tgt_device, src_device->bytes_used);
> -	ASSERT(list_empty(&src_device->resized_list));
> +	ASSERT(list_empty(&src_device->post_commit_list));
>  	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
>  	tgt_device->commit_bytes_used = src_device->bytes_used;
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 82f6dfc132a7..80f0787eb278 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4497,10 +4497,17 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
>  void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
>  				   struct btrfs_fs_info *fs_info)
>  {
> +	struct btrfs_device *dev, *tmp;
> +
>  	btrfs_cleanup_dirty_bgs(cur_trans, fs_info);
>  	ASSERT(list_empty(&cur_trans->dirty_bgs));
>  	ASSERT(list_empty(&cur_trans->io_bgs));
>  
> +	list_for_each_entry_safe(dev, tmp, &cur_trans->dev_update_list,
> +				 post_commit_list) {
> +		list_del_init(&dev->post_commit_list);
> +	}
> +
>  	btrfs_destroy_delayed_refs(cur_trans, fs_info);
>  
>  	cur_trans->state = TRANS_STATE_COMMIT_START;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index f1732b77a379..4aa827a2e951 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -75,6 +75,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
>  			btrfs_put_block_group_trimming(cache);
>  			btrfs_put_block_group(cache);
>  		}
> +		WARN_ON(!list_empty(&transaction->dev_update_list));
>  		kfree(transaction);
>  	}
>  }
> @@ -264,6 +265,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
>  
>  	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
>  	INIT_LIST_HEAD(&cur_trans->pending_chunks);
> +	INIT_LIST_HEAD(&cur_trans->dev_update_list);
>  	INIT_LIST_HEAD(&cur_trans->switch_commits);
>  	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
>  	INIT_LIST_HEAD(&cur_trans->io_bgs);
> @@ -2241,8 +2243,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	memcpy(fs_info->super_for_commit, fs_info->super_copy,
>  	       sizeof(*fs_info->super_copy));
>  
> -	btrfs_update_commit_device_size(fs_info);
> -	btrfs_update_commit_device_bytes_used(cur_trans);
> +	btrfs_commit_device_sizes(cur_trans);
>  
>  	clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
>  	clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index b34678e7968e..2bd76f681520 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -52,6 +52,7 @@ struct btrfs_transaction {
>  	wait_queue_head_t commit_wait;
>  	struct list_head pending_snapshots;
>  	struct list_head pending_chunks;
> +	struct list_head dev_update_list;
>  	struct list_head switch_commits;
>  	struct list_head dirty_bgs;
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index db934ceae9c1..3f81380265e5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -318,7 +318,6 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid,
>  	mutex_init(&fs_devs->device_list_mutex);
>  
>  	INIT_LIST_HEAD(&fs_devs->devices);
> -	INIT_LIST_HEAD(&fs_devs->resized_devices);
>  	INIT_LIST_HEAD(&fs_devs->alloc_list);
>  	INIT_LIST_HEAD(&fs_devs->fs_list);
>  	if (fsid)
> @@ -334,6 +333,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid,
>  
>  void btrfs_free_device(struct btrfs_device *device)
>  {
> +	WARN_ON(!list_empty(&device->post_commit_list));
>  	rcu_string_free(device->name);
>  	bio_put(device->flush_bio);
>  	kfree(device);
> @@ -402,7 +402,7 @@ static struct btrfs_device *__alloc_device(void)
>  
>  	INIT_LIST_HEAD(&dev->dev_list);
>  	INIT_LIST_HEAD(&dev->dev_alloc_list);
> -	INIT_LIST_HEAD(&dev->resized_list);
> +	INIT_LIST_HEAD(&dev->post_commit_list);
>  
>  	spin_lock_init(&dev->io_lock);
>  
> @@ -2880,9 +2880,9 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
>  	btrfs_device_set_total_bytes(device, new_size);
>  	btrfs_device_set_disk_total_bytes(device, new_size);
>  	btrfs_clear_space_info_full(device->fs_info);
> -	if (list_empty(&device->resized_list))
> -		list_add_tail(&device->resized_list,
> -			      &fs_devices->resized_devices);
> +	if (list_empty(&device->post_commit_list))
> +		list_add_tail(&device->post_commit_list,
> +			      &trans->transaction->dev_update_list);
>  	mutex_unlock(&fs_info->chunk_mutex);
>  
>  	return btrfs_update_device(trans, device);
> @@ -4871,9 +4871,9 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  	}
>  
>  	btrfs_device_set_disk_total_bytes(device, new_size);
> -	if (list_empty(&device->resized_list))
> -		list_add_tail(&device->resized_list,
> -			      &fs_info->fs_devices->resized_devices);
> +	if (list_empty(&device->post_commit_list))
> +		list_add_tail(&device->post_commit_list,
> +			      &trans->transaction->dev_update_list);
>  
>  	WARN_ON(diff > old_total);
>  	btrfs_set_super_total_bytes(super_copy,
> @@ -5222,9 +5222,14 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		goto error_del_extent;
>  
> -	for (i = 0; i < map->num_stripes; i++)
> -		btrfs_device_set_bytes_used(map->stripes[i].dev,
> -				map->stripes[i].dev->bytes_used + stripe_size);
> +	for (i = 0; i < map->num_stripes; i++) {
> +		struct btrfs_device *dev = map->stripes[i].dev;
> +
> +		btrfs_device_set_bytes_used(dev, dev->bytes_used + stripe_size);
> +		if (list_empty(&dev->post_commit_list))
> +			list_add_tail(&dev->post_commit_list,
> +				      &trans->transaction->dev_update_list);
> +	}
>  
>  	atomic64_sub(stripe_size * map->num_stripes, &info->free_chunk_space);
>  
> @@ -7674,51 +7679,34 @@ void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_pat
>  }
>  
>  /*
> - * Update the size of all devices, which is used for writing out the
> - * super blocks.
> + * Update the size and bytes used for each device where it changed.
> + * This is delayed since we would otherwise get errors while writing
> + * out the superblocks.
> + *
> + * Must be invoked during transaction commit.
>   */
> -void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
> +void btrfs_commit_device_sizes(struct btrfs_transaction *trans)
>  {
> -	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>  	struct btrfs_device *curr, *next;
>  
> -	if (list_empty(&fs_devices->resized_devices))
> -		return;
> -
> -	mutex_lock(&fs_devices->device_list_mutex);
> -	mutex_lock(&fs_info->chunk_mutex);
> -	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
> -				 resized_list) {
> -		list_del_init(&curr->resized_list);
> -		curr->commit_total_bytes = curr->disk_total_bytes;
> -	}
> -	mutex_unlock(&fs_info->chunk_mutex);
> -	mutex_unlock(&fs_devices->device_list_mutex);
> -}
> -
> -/* Must be invoked during the transaction commit */
> -void btrfs_update_commit_device_bytes_used(struct btrfs_transaction *trans)
> -{
> -	struct btrfs_fs_info *fs_info = trans->fs_info;
> -	struct extent_map *em;
> -	struct map_lookup *map;
> -	struct btrfs_device *dev;
> -	int i;
> +	ASSERT(trans->state != TRANS_STATE_COMMIT_DOING);

I changed this to an assert form a BUG_ON but it also needs to
adjustment of the condition, it should be:
ASSERT(trans->state == TRANS_STATE_COMMIT_DOING);

>  
> -	if (list_empty(&trans->pending_chunks))
> +	if (list_empty(&trans->dev_update_list))
>  		return;
>  
> -	/* In order to kick the device replace finish process */
> -	mutex_lock(&fs_info->chunk_mutex);
> -	list_for_each_entry(em, &trans->pending_chunks, list) {
> -		map = em->map_lookup;
> -
> -		for (i = 0; i < map->num_stripes; i++) {
> -			dev = map->stripes[i].dev;
> -			dev->commit_bytes_used = dev->bytes_used;
> -		}
> +	/*
> +	 * We don't need the device_list_mutex here.  This list is owned
> +	 * by the transaction and the transaction must complete before
> +	 * the device is released.
> +	 */
> +	mutex_lock(&trans->fs_info->chunk_mutex);
> +	list_for_each_entry_safe(curr, next, &trans->dev_update_list,
> +				 post_commit_list) {
> +		list_del_init(&curr->post_commit_list);
> +		curr->commit_total_bytes = curr->disk_total_bytes;
> +		curr->commit_bytes_used = curr->bytes_used;
>  	}
> -	mutex_unlock(&fs_info->chunk_mutex);
> +	mutex_unlock(&trans->fs_info->chunk_mutex);
>  }
>  
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 3ad9d58d1b66..a0f09aad3770 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -45,6 +45,7 @@ struct btrfs_pending_bios {
>  struct btrfs_device {
>  	struct list_head dev_list;
>  	struct list_head dev_alloc_list;
> +	struct list_head post_commit_list; /* chunk mutex */
>  	struct btrfs_fs_devices *fs_devices;
>  	struct btrfs_fs_info *fs_info;
>  
> @@ -102,18 +103,12 @@ struct btrfs_device {
>  	 * size of the device on the current transaction
>  	 *
>  	 * This variant is update when committing the transaction,
> -	 * and protected by device_list_mutex
> +	 * and protected by chunk mutex
>  	 */
>  	u64 commit_total_bytes;
>  
>  	/* bytes used on the current transaction */
>  	u64 commit_bytes_used;
> -	/*
> -	 * used to manage the device which is resized
> -	 *
> -	 * It is protected by chunk_lock.
> -	 */
> -	struct list_head resized_list;
>  
>  	/* for sending down flush barriers */
>  	struct bio *flush_bio;
> @@ -235,7 +230,6 @@ struct btrfs_fs_devices {
>  	struct mutex device_list_mutex;
>  	struct list_head devices;
>  
> -	struct list_head resized_devices;
>  	/* devices not currently being allocated */
>  	struct list_head alloc_list;
>  
> @@ -558,8 +552,7 @@ static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
>  
>  const char *get_raid_name(enum btrfs_raid_types type);
>  
> -void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
> -void btrfs_update_commit_device_bytes_used(struct btrfs_transaction *trans);
> +void btrfs_commit_device_sizes(struct btrfs_transaction *trans);
>  
>  struct list_head *btrfs_get_fs_uuids(void);
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
> 
