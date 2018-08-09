Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:50338 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbeHII2d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 04:28:33 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 01734AC0172
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Aug 2018 15:05:14 +0900 (JST)
Subject: Re: [PATCH v4] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1c76deaf-af9b-7c8c-e100-058d67f40fb5@gmx.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <e5f6227a-cb6d-94e9-912a-60736499fd8b@jp.fujitsu.com>
Date: Thu, 9 Aug 2018 15:05:07 +0900
MIME-Version: 1.0
In-Reply-To: <1c76deaf-af9b-7c8c-e100-058d67f40fb5@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/09 14:47, Qu Wenruo wrote:
> 
> 
> On 8/9/18 12:12 PM, Misono Tomohiro wrote:
>> When qgroup is on, subvolume deletion does not remove qgroup items
>> of the subvolume (qgroup info, limit, relation) from quota tree and
>> they need to get removed manually by "btrfs qgroup destroy".
>>
>> Since level 0 qgroup cannot be used/inherited by any other subvolume,
>> let's remove them automatically when subvolume is deleted
>> (to be precise, when the subvolume root is dropped).
>>
>> Note that qgroup becomes inconsistent in following case:
>>   1. qgroup relation exists
>>   2. and subvolume's excl != rref
> 
> That's a little strange.
> 
> If a subvolume is completely dropped, its excl should be the same rfer,
> all 0, and removing its relationship should not mark qgroup inconsistent.
> 
> So the problem is the timing when btrfs_remove_qgroup() is called.
> 
> Since qgroup accounting is only called at transaction commit time, and
> we're holding a trans handler, it's almost ensured we can't commit this
> transaction, thus the number is not updated yet (still not 0)
> 
> So that's why qgroup is inconsistent.
> 
> What about commit current transaction and then call btrfs_remove_qgroup()?
> 
> (Sorry I didn't catch this problem last time I reviewed this patch)

well, I'm little confusing about flow of transaction commit.
btrfs_drop_snapshot() is called from cleaner_kthread and
is it ok to commit transaction in it?

> 
> Thanks,
> Qu
> 
>> In this case manual qgroup rescan is needed.
>>
>> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> ---
>> Hi David,
>> It turned out that this patch may cause qgroup inconsistency in case
>> described above and need manual rescan. Since current code will keep 
>> qgroup items but not break qgroup consistency when deleting subvolume,
>> I cannot clearly say which behavior is better for qgroup usability.
>> Can I ask your opinion?
>>
>> v3 -> v4:
>>   Check return value of btrfs_remove_qgroup() and if it is 1,
>>   print message in syslog that fs needs qgroup rescan
>>
>>  fs/btrfs/extent-tree.c | 22 ++++++++++++++++++----
>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9e7b237b9547..828d9e68047d 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>>  	struct btrfs_root_item *root_item = &root->root_item;
>>  	struct walk_control *wc;
>>  	struct btrfs_key key;
>> +	u64 objectid = root->root_key.objectid;
>>  	int err = 0;
>>  	int ret;
>>  	int level;
>>  	bool root_dropped = false;
>>  
>> -	btrfs_debug(fs_info, "Drop subvolume %llu", root->objectid);
>> +	btrfs_debug(fs_info, "Drop subvolume %llu", objectid);
>>  
>>  	path = btrfs_alloc_path();
>>  	if (!path) {
>> @@ -9030,7 +9031,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>>  		goto out_end_trans;
>>  	}
>>  
>> -	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
>> +	if (objectid != BTRFS_TREE_RELOC_OBJECTID) {
>>  		ret = btrfs_find_root(tree_root, &root->root_key, path,
>>  				      NULL, NULL);
>>  		if (ret < 0) {
>> @@ -9043,8 +9044,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>>  			 *
>>  			 * The most common failure here is just -ENOENT.
>>  			 */
>> -			btrfs_del_orphan_item(trans, tree_root,
>> -					      root->root_key.objectid);
>> +			btrfs_del_orphan_item(trans, tree_root, objectid);
>>  		}
>>  	}
>>  
>> @@ -9056,6 +9056,20 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>>  		btrfs_put_fs_root(root);
>>  	}
>>  	root_dropped = true;
>> +
>> +	 /* Remove level-0 qgroup items since no other subvolume can use them */
>> +	ret = btrfs_remove_qgroup(trans, objectid);
>> +	if (ret == 1) {
>> +		/* This means qgroup becomes inconsistent by removing items */
>> +		btrfs_info(fs_info,
>> +		    "qgroup inconsistency found, need qgroup rescan");
>> +	} else if (ret == -EINVAL || ret == -ENOENT) {
>> +		/* qgroup is not enabled or already removed, just ignore this */
>> +	} else if (ret) {
>> +		btrfs_abort_transaction(trans, ret);
>> +		err = ret;
>> +	}
>> +
>>  out_end_trans:
>>  	btrfs_end_transaction_throttle(trans);
>>  out_free:
>>
> 

