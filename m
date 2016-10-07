Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21582 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751027AbcJGCdH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Oct 2016 22:33:07 -0400
Subject: Re: [PATCH] btrfs: relocation: Fix NULL pointer access and leaking
 qgroups in btrfs_recover_relocation
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20161006080337.31691-1-quwenruo@cn.fujitsu.com>
 <4bdf1336-dc97-4dcb-1095-a2545419e95a@suse.de>
CC: <rgoldwyn@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <82aef874-2fc1-15fc-8e50-04c087051489@cn.fujitsu.com>
Date: Fri, 7 Oct 2016 10:32:56 +0800
MIME-Version: 1.0
In-Reply-To: <4bdf1336-dc97-4dcb-1095-a2545419e95a@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/07/2016 02:00 AM, Goldwyn Rodrigues wrote:
> Hi Qu,
>
> On 10/06/2016 03:03 AM, Qu Wenruo wrote:
>> We fixed balance qgroup leaking by introducing
>> qgroup_fix_relocated_data_extents(), but it only covers normal balance
>> routine well.
>>
>> For case btrfs_recover_relocation() routine, since rc->stage or
>> rc->data_inode are not initialized, we either skip
>> qgroup_fix_relocated_data_extents() or just cause NULL pointer access.
>>
>> Since we skip qgroup_fix_relocated_data_extents() in
>> btrfs_recover_relocation(), we will still leak qgroup numbers for that
>> routine.
>>
>> In the fix, we won't use data_inode any longer, as at the timing of the
>> qgroup fix, noone will modify data_reloc tree any longer, so path
>> locking should be good enough.
>>
>> And add check against rc->merge_reloc_tree, so we can detect if we are
>> in btrfs_recover_relocation() routine and continue qgroup fix.
>
> While testing this patch, I realized the original problem of qgroup
> values being incorrect after a balance, has returned... or probably was
> not solved completely. I tried it with the shell script sent sometime
> back. The script fails when I checkout fix df2c95f33e0a2 as well.
>
> I remember it did not appear when I tested it last, so it is possible
> that some other change has affected this.
>
> Would recommend to hold off this until the balance issue is not
> completely fixed.
>
> For reference, the test script is:
>
> #!/bin/bash -x
>
> MNT="/mnt"
> DEV="/dev/vdb"
>
> mkfs.btrfs -f $DEV
> mount -t btrfs $DEV $MNT
>
> mkdir $MNT/snaps
> echo "populate $MNT with some data"
> #cp -a /usr/share/fonts $MNT/
> cp -a /usr/ $MNT/ &
> for i in `seq -w 0 8`; do
>         S="$MNT/snaps/snap$i"
>         echo "create and populate $S"
>         btrfs su snap $MNT $S;
>         cp -a /boot $S;
> done;
>
> #let the cp from above finish
> wait
>
> btrfs fi sync $MNT
>
> btrfs quota enable $MNT
> btrfs quota rescan -w $MNT
> btrfs qg show $MNT
>
> umount $MNT
>
> mount -t btrfs $DEV $MNT
>
>
> time btrfs balance start --full-balance $MNT
>
> umount $MNT
>
> btrfsck $DEV
>
>

Thanks for the report.

Yes, the script can reproduce the problem, almost 100% possibility.

But it also takes a long time to run.(Partly because of the slow 
find_parent_nodes function call).

I tried to simplify it by using inline extent to bumping the tree level 
and use small file extents to reduce IO.
But no good reproducer yet.

Did you remember which kernel version you tested the original fix?
Maybe it could provide some clue.

Thanks,
Qu

>
>>
>> Reported-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/relocation.c | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index c0c13dc..f250187 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -3946,8 +3946,7 @@ static int qgroup_fix_relocated_data_extents(struct btrfs_trans_handle *trans,
>>  					     struct reloc_control *rc)
>>  {
>>  	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
>> -	struct inode *inode = rc->data_inode;
>> -	struct btrfs_root *data_reloc_root = BTRFS_I(inode)->root;
>> +	struct btrfs_root *data_reloc_root;
>>  	struct btrfs_path *path;
>>  	struct btrfs_key key;
>>  	int ret = 0;
>> @@ -3956,18 +3955,28 @@ static int qgroup_fix_relocated_data_extents(struct btrfs_trans_handle *trans,
>>  		return 0;
>>
>>  	/*
>> +	 * For normal balance routine, merge_reloc_tree flag is always cleared
>> +	 * before commit trans.
>> +	 * For recover relocation routine, merge_reloc_tree is always 1, we need
>> +	 * to continue anyway.
>> +	 *
>>  	 * Only for stage where we update data pointers the qgroup fix is
>>  	 * valid.
>>  	 * For MOVING_DATA stage, we will miss the timing of swapping tree
>>  	 * blocks, and won't fix it.
>>  	 */
>> -	if (!(rc->stage == UPDATE_DATA_PTRS && rc->extents_found))
>> +	if (!(rc->stage == UPDATE_DATA_PTRS && rc->extents_found) &&
>> +	    rc->merge_reloc_tree == 0)
>>  		return 0;
>>
>> +	data_reloc_root = read_fs_root(fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
>> +	if (IS_ERR(data_reloc_root))
>> +		return PTR_ERR(data_reloc_root);
>> +
>>  	path = btrfs_alloc_path();
>>  	if (!path)
>>  		return -ENOMEM;
>> -	key.objectid = btrfs_ino(inode);
>> +	key.objectid = BTRFS_FIRST_FREE_OBJECTID + 1;
>>  	key.type = BTRFS_EXTENT_DATA_KEY;
>>  	key.offset = 0;
>>
>> @@ -3975,13 +3984,10 @@ static int qgroup_fix_relocated_data_extents(struct btrfs_trans_handle *trans,
>>  	if (ret < 0)
>>  		goto out;
>>
>> -	lock_extent(&BTRFS_I(inode)->io_tree, 0, (u64)-1);
>>  	while (1) {
>>  		struct btrfs_file_extent_item *fi;
>>
>>  		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> -		if (key.objectid > btrfs_ino(inode))
>> -			break;
>>  		if (key.type != BTRFS_EXTENT_DATA_KEY)
>>  			goto next;
>>  		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> @@ -4004,7 +4010,6 @@ next:
>>  			break;
>>  		}
>>  	}
>> -	unlock_extent(&BTRFS_I(inode)->io_tree, 0 , (u64)-1);
>>  out:
>>  	btrfs_free_path(path);
>>  	return ret;
>>
>


