Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B78AC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 09:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E48E20685
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 09:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfDYJhw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:37:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:57868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728579AbfDYJhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 05:37:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19EA4AED6;
        Thu, 25 Apr 2019 09:37:50 +0000 (UTC)
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
 <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
Cc:     Filipe Manana <fdmanana@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
Date:   Thu, 25 Apr 2019 12:37:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.04.19 г. 12:29 ч., Qu Wenruo wrote:
> 
> 
> On 2018/8/6 上午10:30, robbieko wrote:
>> From: Robbie Ko <robbieko@synology.com>
>>
>> Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>> forced nocow writes to fallback to COW, during writeback,
>> when a snapshot is created. This resulted in writes made before
>> creating the snapshot to unexpectedly fail with ENOSPC during
>> writeback when success (0) was returned to user space through
>> the write system call.
>>
>> The steps leading to this problem are:
>>
>> 1. When it's not possible to allocate data space for a write,
>> the buffered write path checks if a NOCOW write is possible.
>> If it is, it will not reserve space and success (0) is returned
>> to user space.
>>
>> 2. Then when a snapshot is created, the root's will_be_snapshotted
>> atomic is incremented and writeback is triggered for all inode's
>> that belong to the root being snapshotted. Incrementing that atomic
>> forces all previous writes to fallback to COW during writeback
>> (running delalloc).
>>
>> 3. This results in the writeback for the inodes to fail and therefore
>> setting the ENOSPC error in their mappings, so that a subsequent fsync
>> on them will report the error to user space. So it's not a completely
>> silent data loss (since fsync will report ENOSPC) but it's a very
>> unexpected and undesirable behaviour, because if a clean
>> shutdown/unmount of the filesystem happens without previous calls to
>> fsync, it is expected to have the data present in the files after
>> mounting the filesystem again.
>>
>> So fix this by adding a new atomic named snapshot_force_cow to the
>> root structure which prevents this behaviour and works the following way:
> 
> This fix is a little out of dated now.
> 
> Since 609e804d771f ("Btrfs: fix file corruption after snapshotting due
> to mix of buffered/DIO writes") we will write back all dirty
> inodes/pages back to disk before snapshot.
> 
> This makes sure that all dirty inodes/pages before a transaction will
> reach disk before snapshot  subvolume is created.
> 
> Thus the whole will_be_snapshotted member no long makes sense, and in
> fact it could cause more problem if we're going back to always check
> NODATACOW at buffered write time.
> 
> Can we just revert this patch and the will_be_snapshotted member ?

I'm very much in favor of removing the whole will_be_snapshotted
mechanism. In fact I have a series which replaces it with a rwsem
essentially:

1. Serializing snapshots (acquiring write-side of the semaphore)

2. Nocow writers simply acquire the readsize of the semaphore.

the will_be_snapshoted thing is very convoluted relying on a percpu
counter/waitqueue  to exclude snapshots from pending nocow writers. OTOH
it depends on atomic_t and an implicit wait queue thanks to wait_var
infrastructure to exclude nocow writers from pending snapshots. Filipe
had some concerns regarding performance but if the patch you mentioned
fixed all issues I'm all in favor of removing the code!


> 
> Thanks,
> Qu
> 
>>
>> 1. It is incremented when we start to create a snapshot after
>> triggering writeback and before waiting for writeback to finish.
>>
>> 2. This new atomic is now what is used by writeback (running delalloc)
>> to decide whether we need to fallback to COW or not. Because we
>> incremented this new atomic after triggering writeback in the snapshot
>> creation ioctl, we ensure that all buffered writes that happened
>> before snapshot creation will succeed and not fallback to COW
>> (which would make them fail with ENOSPC).
>>
>> 3. The existing atomic, will_be_snapshotted, is kept because it is
>> used to force new buffered writes, that start after we started
>> snapshotting, to reserve data space even when NOCOW is possible.
>> This makes these writes fail early with ENOSPC when there's no
>> available space to allocate, preventing the unexpected behaviour
>> of writeback later failing with ENOSPC due to a fallback to COW mode.
>>
>> Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/ctree.h   |  1 +
>>  fs/btrfs/disk-io.c |  1 +
>>  fs/btrfs/inode.c   | 26 +++++---------------------
>>  fs/btrfs/ioctl.c   | 16 ++++++++++++++++
>>  4 files changed, 23 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 118346a..663ce05 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1277,6 +1277,7 @@ struct btrfs_root {
>>  	int send_in_progress;
>>  	struct btrfs_subvolume_writers *subv_writers;
>>  	atomic_t will_be_snapshotted;
>> +	atomic_t snapshot_force_cow;
>>  
>>  	/* For qgroup metadata reserved space */
>>  	spinlock_t qgroup_meta_rsv_lock;
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 205092d..5573916 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1216,6 +1216,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>>  	atomic_set(&root->log_batch, 0);
>>  	refcount_set(&root->refs, 1);
>>  	atomic_set(&root->will_be_snapshotted, 0);
>> +	atomic_set(&root->snapshot_force_cow, 0);
>>  	root->log_transid = 0;
>>  	root->log_transid_committed = -1;
>>  	root->last_log_commit = 0;
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index eba61bc..263b852 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -1275,7 +1275,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  	u64 disk_num_bytes;
>>  	u64 ram_bytes;
>>  	int extent_type;
>> -	int ret, err;
>> +	int ret;
>>  	int type;
>>  	int nocow;
>>  	int check_prev = 1;
>> @@ -1407,11 +1407,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  			 * if there are pending snapshots for this root,
>>  			 * we fall into common COW way.
>>  			 */
>> -			if (!nolock) {
>> -				err = btrfs_start_write_no_snapshotting(root);
>> -				if (!err)
>> -					goto out_check;
>> -			}
>> +			if (!nolock &&
>> +				unlikely(atomic_read(&root->snapshot_force_cow)))
>> +				goto out_check;
>>  			/*
>>  			 * force cow if csum exists in the range.
>>  			 * this ensure that csum for a given extent are
>> @@ -1420,9 +1418,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  			ret = csum_exist_in_range(fs_info, disk_bytenr,
>>  						  num_bytes);
>>  			if (ret) {
>> -				if (!nolock)
>> -					btrfs_end_write_no_snapshotting(root);
>> -
>>  				/*
>>  				 * ret could be -EIO if the above fails to read
>>  				 * metadata.
>> @@ -1435,11 +1430,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  				WARN_ON_ONCE(nolock);
>>  				goto out_check;
>>  			}
>> -			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
>> -				if (!nolock)
>> -					btrfs_end_write_no_snapshotting(root);
>> +			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
>>  				goto out_check;
>> -			}
>>  			nocow = 1;
>>  		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>>  			extent_end = found_key.offset +
>> @@ -1453,8 +1445,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  out_check:
>>  		if (extent_end <= start) {
>>  			path->slots[0]++;
>> -			if (!nolock && nocow)
>> -				btrfs_end_write_no_snapshotting(root);
>>  			if (nocow)
>>  				btrfs_dec_nocow_writers(fs_info, disk_bytenr);
>>  			goto next_slot;
>> @@ -1476,8 +1466,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  					     end, page_started, nr_written, 1,
>>  					     NULL);
>>  			if (ret) {
>> -				if (!nolock && nocow)
>> -					btrfs_end_write_no_snapshotting(root);
>>  				if (nocow)
>>  					btrfs_dec_nocow_writers(fs_info,
>>  								disk_bytenr);
>> @@ -1497,8 +1485,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  					  ram_bytes, BTRFS_COMPRESS_NONE,
>>  					  BTRFS_ORDERED_PREALLOC);
>>  			if (IS_ERR(em)) {
>> -				if (!nolock && nocow)
>> -					btrfs_end_write_no_snapshotting(root);
>>  				if (nocow)
>>  					btrfs_dec_nocow_writers(fs_info,
>>  								disk_bytenr);
>> @@ -1537,8 +1523,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>  					     EXTENT_CLEAR_DATA_RESV,
>>  					     PAGE_UNLOCK | PAGE_SET_PRIVATE2);
>>  
>> -		if (!nolock && nocow)
>> -			btrfs_end_write_no_snapshotting(root);
>>  		cur_offset = extent_end;
>>  
>>  		/*
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index b077544..331b495 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>  	struct btrfs_pending_snapshot *pending_snapshot;
>>  	struct btrfs_trans_handle *trans;
>>  	int ret;
>> +	bool snapshot_force_cow = false;
>>  
>>  	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
>>  		return -EINVAL;
>> @@ -777,6 +778,11 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>  		goto free_pending;
>>  	}
>>  
>> +	/*
>> +	 * Force new buffered writes to reserve space even when NOCOW is
>> +	 * possible. This is to avoid later writeback (running dealloc)
>> +	 * to fallback to COW mode and unexpectedly fail with ENOSPC.
>> +	 */
>>  	atomic_inc(&root->will_be_snapshotted);
>>  	smp_mb__after_atomic();
>>  	/* wait for no snapshot writes */
>> @@ -787,6 +793,14 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>  	if (ret)
>>  		goto dec_and_free;
>>  
>> +	/*
>> +	 * All previous writes have started writeback in NOCOW mode, so now
>> +	 * we force future writes to fallback to COW mode during snapshot
>> +	 * creation.
>> +	 */
>> +	atomic_inc(&root->snapshot_force_cow);
>> +	snapshot_force_cow = true;
>> +
>>  	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>>  
>>  	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>> @@ -851,6 +865,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>  fail:
>>  	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
>>  dec_and_free:
>> +	if (snapshot_force_cow)
>> +		atomic_dec(&root->snapshot_force_cow);
>>  	if (atomic_dec_and_test(&root->will_be_snapshotted))
>>  		wake_up_var(&root->will_be_snapshotted);
>>  free_pending:
>>
> 
