Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:62809 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbeHHFOf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 01:14:35 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id AC066AC0104
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Aug 2018 11:57:01 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id A371A69246B
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Aug 2018 11:57:00 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533517699.git.misono.tomohiro@jp.fujitsu.com>
 <3ea480fc-46ad-4072-198d-1e8f49121be0@jp.fujitsu.com>
 <20180807162332.GB3288@fnst.localdomain>
Message-ID: <bed3f2b7-1be3-130d-a0b6-7a4d3ba5db4e@jp.fujitsu.com>
Date: Wed, 8 Aug 2018 11:56:37 +0900
MIME-Version: 1.0
In-Reply-To: <20180807162332.GB3288@fnst.localdomain>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/08 1:23, Lu Fengqi wrote:
> On Mon, Aug 06, 2018 at 01:53:28PM +0900, Misono Tomohiro wrote:
>> When qgroup is on, subvolume deletion does not remove qgroup items
>> of the subvolume (qgroup info, limit, relation) from quota tree and
>> they need to get removed manually by "btrfs qgroup destroy".
>>
>> Since level 0 qgroup cannot be used/inherited by any other subvolume,
>> let's remove them automatically when subvolume is deleted
>> (to be precise, when the subvolume root is dropped).
>>
>> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> ---
>> v2 -> v3:
>>  Use root->root_key.objectid instead of root->objectid
>>  Add Reviewed-by tag
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
>> index 9e7b237b9547..48edf839ed2c 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>> 	struct btrfs_root_item *root_item = &root->root_item;
>> 	struct walk_control *wc;
>> 	struct btrfs_key key;
>> +	u64 objectid = root->root_key.objectid;
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
> 
> I'm sorry for missing the snapshot case. If it is a snapshot, then when
> we remove the relevant qgroup, we will not be able to perform
> quick_update_accounting(), and it will return 1. So we shouldn't abort
> the transaction when the return value = 1.
> 
> btrfs_remove_qgroup
> -> __del_qgroup_relation
>    -> quick_update_accounting << if qgroup->excl != qgroup->rfer; return 1
> 

oh, thanks for pointing out, I missed that case...
I wonder if there is a way to keep qgroup consistency without enforcing rescan.

btw, I noticed that removing qgroup relation when excl != rfer causes
some problem without this patch:

(4.18-rc7)
$ mkfs.btrfs -fq $DEV
$ mount $DEV /mnt

$ btrfs quota enable /mnt
$ btrfs qgroup create 1/0 /mnt
$ btrfs sub create /mnt/sub
$ btrfs qgroup assign 0/257 1/0 /mnt

$ dd if=/dev/urandom of=/mnt/sub/file bs=1k count=1000
$ btrfs sub snap /mnt/sub /mnt/snap
$ dd if=/dev/urandom of=/mnt/sub/file2 bs=1k count=1000

$ btrfs fi sync /mnt
$ btrfs qgroup show -pcre /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/257         1.97MiB   1016.00KiB         none         none 1/0     ---
0/258      1016.00KiB     16.00KiB         none         none ---     ---
1/0           1.97MiB      1.97MiB         none         none ---     0/257
                           ^^^^^^^ should be 1016Kib

$ btrfs qgroup remove 0/257 1/0 /mnt
WARNING: quotas may be inconsistent, rescan needed
$ btrfs qgroup show -pcre  /mnt
WARNING: qgroup data inconsistent, rescan recommended
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/258      1016.00KiB   1016.00KiB         none         none ---     ---
1/0           1.97MiB      1.97MiB         none         none ---     ---

$ btrfs quota rescan -w /mnt
$ btrfs qgroup show -pcre /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
0/258      1016.00KiB   1016.00KiB         none         none ---     ---
1/0           1.97MiB      1.97MiB         none         none ---     ---
               ^^^^^^      ^^^^^^^ not changed, although inconsistency flag is cleared

I will look at the case to better understand qgroup.

Thanks,
Misono

