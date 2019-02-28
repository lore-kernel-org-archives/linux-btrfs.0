Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55638C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3832184A
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbfB1QvB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:51:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:48806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727861AbfB1QvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 11:51:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A190DAEB7
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 16:51:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2A5C5DA944; Thu, 28 Feb 2019 17:52:21 +0100 (CET)
Date:   Thu, 28 Feb 2019 17:52:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH v2 02/12] btrfs: combine device update operations during
 transaction commit
Message-ID: <20190228165221.GL31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
References: <20190211083510.27591-1-nborisov@suse.com>
 <20190211083510.27591-3-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211083510.27591-3-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 10:35:00AM +0200, Nikolay Borisov wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
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

Agreed, overall sounds good.

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -75,6 +75,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
>  			btrfs_put_block_group_trimming(cache);
>  			btrfs_put_block_group(cache);
>  		}
> +		BUG_ON(!list_empty(&transaction->dev_update_list));

Why BUG_ON? Would ASSERT or WARN_ON enough?

>  		kfree(transaction);
>  	}
>  }
> @@ -334,6 +333,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid,
>  
>  void btrfs_free_device(struct btrfs_device *device)
>  {
> +	BUG_ON(!list_empty(&device->post_commit_list));

Same here

>  	rcu_string_free(device->name);
>  	bio_put(device->flush_bio);
>  	kfree(device);
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

Agreed, the chunk_mutex should be enough from what I've seen.

>  	}
> -	mutex_unlock(&fs_info->chunk_mutex);
> +	mutex_unlock(&trans->fs_info->chunk_mutex);
>  }
>  
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
