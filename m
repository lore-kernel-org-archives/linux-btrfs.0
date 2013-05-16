Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57034 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab3EPD7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 23:59:24 -0400
Message-ID: <519459C5.7080403@cn.fujitsu.com>
Date: Thu, 16 May 2013 12:00:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: Re: [PATCH 10/17] Btrfs: just flush the delalloc inodes in the source
 tree before snapshot creation
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com> <1368604111-25073-11-git-send-email-miaox@cn.fujitsu.com> <20130516032034.GE20202@liubo.jp.oracle.com>
In-Reply-To: <20130516032034.GE20202@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 16 May 2013 11:20:39 +0800, Liu Bo wrote:
> On Wed, May 15, 2013 at 03:48:24PM +0800, Miao Xie wrote:
>> Before applying this patch, we need flush all the delalloc inodes in
>> the fs when we want to create a snapshot, it wastes time, and make
>> the transaction commit be blocked for a long time. It means some other
>> user operation would also be blocked for a long time.
>>
>> This patch improves this problem, we just flush the delalloc inodes that
>> in the source trees before snapshot creation, so the transaction commit
>> will complete quickly.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c       |  6 ++++++
>>  fs/btrfs/transaction.c | 10 +---------
>>  2 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 0de4a2f..2677dcc 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -555,6 +555,12 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>  	if (!root->ref_cows)
>>  		return -EINVAL;
>>  
>> +	ret = btrfs_start_delalloc_inodes(root, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	btrfs_wait_ordered_extents(root, 0);
>> +
> 
> Does this look too radical?  Does this snapshot creation ioctl block all
> writes on its src root?

I don't think it is radical, and I think flushing delalloc inodes during the transaction commit
is stupid, especially flushing all the inodes including the roots which are not going to be snapshoted.
Because it will block the operations of the users (such as mkdir, rmdir, create and so on) for
a long time if there are lots of dirty pages.

And The snapshot creation now doesn't block the writes of the source root at all, there is no
appreciable difference between this way and the background flusher.

> No, we can only be sure that there is no ordered extents being added until
> setting trans_no_join, and then it's safe to create pending snapshots.

Actually, we can not avoid that the new ordered extents are added before trans_no_join is set.
But for the users, the 1st case below must be handled correctly, but the 2nd one can be ignored
because we can see the write of the 2nd case as the one that happens after the snapshot creation.

1st case:
	Task
	write data into a file
	make a snapshot

2nd case:
	Task0				Task1
	make a snapshot
	  flush delalloc inodes
					write data into a file
	  commit transaction
	    create_pending_snapshot

Thanks
Miao

> 
> thanks,
> liubo
> 
>>  	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
>>  	if (!pending_snapshot)
>>  		return -ENOMEM;
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 2b17213..bc22be9 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1491,17 +1491,9 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
>>  					  struct btrfs_root *root)
>>  {
>>  	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
>> -	int snap_pending = 0;
>>  	int ret;
>>  
>> -	if (!flush_on_commit) {
>> -		spin_lock(&root->fs_info->trans_lock);
>> -		if (!list_empty(&trans->transaction->pending_snapshots))
>> -			snap_pending = 1;
>> -		spin_unlock(&root->fs_info->trans_lock);
>> -	}
>> -
>> -	if (flush_on_commit || snap_pending) {
>> +	if (flush_on_commit) {
>>  		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 1);
>>  		if (ret)
>>  			return ret;
>> -- 
>> 1.8.1.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

