Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab2FFCQY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jun 2012 22:16:24 -0400
Message-ID: <4FCEBDB8.800@redhat.com>
Date: Wed, 06 Jun 2012 10:17:28 +0800
From: Asias He <asias@redhat.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        jeffm@suse.com
Subject: Re: [PATCH 1/2] btrfs: Drop unused function btrfs_abort_devices()
References: <1337915422-24988-1-git-send-email-asias@redhat.com> <20120528134159.GT24394@twin.jikos.cz>
In-Reply-To: <20120528134159.GT24394@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Jeff

On 05/28/2012 09:41 PM, David Sterba wrote:
> On Fri, May 25, 2012 at 11:10:21AM +0800, Asias He wrote:
>> 1) This function is not used anywhere.
>
> This was added in 49b25e0540904be0bf558b84475c69d72e4de66e adding a
> transaction abort infrastructure.  I'm not sure if Jeff had some
> intentions with it or whether it got obsolete during the patchset long
> evolution, CCed.

Any comments?

>
>
> david
>
>
>> 2) Using the blk_abort_queue() to abort the queue seems not correct.
>> blk_abort_queue() is used for timeout handling (block/blk-timeout.c).
>>
>> Cc: Chris Mason<chris.mason@oracle.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Cc: Jens Axboe<axboe@kernel.dk>
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Asias He<asias@redhat.com>
>> ---
>>   fs/btrfs/disk-io.c |   13 -------------
>>   fs/btrfs/disk-io.h |    1 -
>>   2 files changed, 14 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index e1fe74a..3521866 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2902,19 +2902,6 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
>>   	return ret;
>>   }
>>
>> -/* Kill all outstanding I/O */
>> -void btrfs_abort_devices(struct btrfs_root *root)
>> -{
>> -	struct list_head *head;
>> -	struct btrfs_device *dev;
>> -	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
>> -	head =&root->fs_info->fs_devices->devices;
>> -	list_for_each_entry_rcu(dev, head, dev_list) {
>> -		blk_abort_queue(dev->bdev->bd_disk->queue);
>> -	}
>> -	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>> -}
>> -
>>   void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
>>   {
>>   	spin_lock(&fs_info->fs_roots_radix_lock);
>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>> index ab1830a..05b3fab 100644
>> --- a/fs/btrfs/disk-io.h
>> +++ b/fs/btrfs/disk-io.h
>> @@ -89,7 +89,6 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
>>   int btrfs_cleanup_transaction(struct btrfs_root *root);
>>   void btrfs_cleanup_one_transaction(struct btrfs_transaction *trans,
>>   				  struct btrfs_root *root);
>> -void btrfs_abort_devices(struct btrfs_root *root);
>>
>>   #ifdef CONFIG_DEBUG_LOCK_ALLOC
>>   void btrfs_init_lockdep(void);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Asias
