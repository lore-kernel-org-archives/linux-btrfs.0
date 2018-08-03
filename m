Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:56679 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbeHCKd1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 06:33:27 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A7FC9AC020F
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 17:38:04 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 83B3A692779
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 17:38:03 +0900 (JST)
Subject: Re: [PATCH v2] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
 <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
 <9e46637d-f717-7210-06e2-a077a58d9638@jp.fujitsu.com>
 <20180803071527.GD2049@fnst.localdomain>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <aa50e661-d575-340d-d6c4-95382114ad72@jp.fujitsu.com>
Date: Fri, 3 Aug 2018 17:37:53 +0900
MIME-Version: 1.0
In-Reply-To: <20180803071527.GD2049@fnst.localdomain>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/03 16:15, Lu Fengqi wrote:
> On Fri, Aug 03, 2018 at 03:21:12PM +0900, Misono Tomohiro wrote:
>> When qgroup is on, subvolume deletion does not remove qgroup item
>> of the subvolume (qgroup info, limits, relation) from quota tree and
>> they needs to get removed manually by "btrfs qgroup destroy".
>>
>> Since level 0 qgroup cannot be used/inherited by any other subvolume,
>> let's remove them automatically when subvolume is deleted
>> (to be precise, when the subvolume root is dropped).
>>
>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> 
> Looks good to me.
> 
> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Thanks for the review.

> 
> There is an off-topic question below.
> 
>> ---
>> Note that btrfs/057 fails, but it is the problem of testcase.
>> I will update it too.
>>
>> v1 -> v2:
>>  Move call of btrfs_remove_qgroup() from btrfs_delete_subvolume()
>>  to btrfs_snapshot_destroy() so that it will be called after the
>>  subvolume root is really dropped
>>
>> fs/btrfs/extent-tree.c | 16 ++++++++++++----
>> 1 file changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9e7b237b9547..b56dea8c8b9f 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>> 	struct btrfs_root_item *root_item = &root->root_item;
>> 	struct walk_control *wc;
>> 	struct btrfs_key key;
>> +	u64 objectid = root->objectid;
>> 	int err = 0;
>> 	int ret;
>> 	int level;
>> 	bool root_dropped = false;
>>
>> -	btrfs_debug(fs_info, "Drop subvolume %llu", root->objectid);
>> +	btrfs_debug(fs_info, "Drop subvolume %llu", objectid);
>>
>> 	path = btrfs_alloc_path();
>> 	if (!path) {
>> @@ -9030,7 +9031,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>> 		goto out_end_trans;
>> 	}
>>
>> -	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
>> +	if (objectid != BTRFS_TREE_RELOC_OBJECTID) {
> 
> Here use root->objectid instead of root->root_key.objectid. If I recall
> correctly, the root->objectid and root->root_key.objectid are set to the
> identical value. I just wonder if there is any difference between the two
> "objectid"s after the btrfs_root was created?

in __setup_root(root, fs_info, objectid):
<snip>
  root->objectid = objectid;
<snip>
  root->root_key.objectid = objectid;
<snip>

and I don't see any update of objectid from "grep -r "root_key.objectid ="",
I think it the same too (and fstests is ok), but any comment from
those who more familiar with code is helpful.

thanks,
Misono

> 
> --
> Thanks,
> Lu
> 
>> 		ret = btrfs_find_root(tree_root, &root->root_key, path,
>> 				      NULL, NULL);
>> 		if (ret < 0) {
>> @@ -9043,8 +9044,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>> 			 *
>> 			 * The most common failure here is just -ENOENT.
>> 			 */
>> -			btrfs_del_orphan_item(trans, tree_root,
>> -					      root->root_key.objectid);
>> +			btrfs_del_orphan_item(trans, tree_root, objectid);
>> 		}
>> 	}
>>
>> @@ -9056,6 +9056,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>> 		btrfs_put_fs_root(root);
>> 	}
>> 	root_dropped = true;
>> +
>> +	 /* Remove level-0 qgroup items since no other subvolume can use them */
>> +	ret = btrfs_remove_qgroup(trans, objectid);
>> +	if (ret && ret != -EINVAL && ret != -ENOENT) {
>> +		btrfs_abort_transaction(trans, ret);
>> +		err = ret;
>> +	}
>> +
>> out_end_trans:
>> 	btrfs_end_transaction_throttle(trans);
>> out_free:
>> -- 
>> 2.14.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

