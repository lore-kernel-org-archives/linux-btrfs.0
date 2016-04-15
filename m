Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34462 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370AbcDOBAe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 21:00:34 -0400
Subject: Re: [PATCH v3] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: Mark Fasheh <mfasheh@suse.de>
References: <1460612320-19199-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160414214208.GM2187@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57103D16.2050100@cn.fujitsu.com>
Date: Fri, 15 Apr 2016 09:00:06 +0800
MIME-Version: 1.0
In-Reply-To: <20160414214208.GM2187@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/04/14 14:42 -0700:
> Hi Qu,
>
> On Thu, Apr 14, 2016 at 01:38:40PM +0800, Qu Wenruo wrote:
>> Current btrfs qgroup design implies a requirement that after calling
>> btrfs_qgroup_account_extents() there must be a commit root switch.
>>
>> Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
>> inside btrfs_commit_transaction() just be commit_cowonly_roots().
>>
>> However there is a exception at create_pending_snapshot(), which will
>> call btrfs_qgroup_account_extents() but no any commit root switch.
>>
>> In case of creating a snapshot whose parent root is itself (create a
>> snapshot of fs tree), it will corrupt qgroup by the following trace:
>> (skipped unrelated data)
>> ======
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>> ======
>>
>> The problem here is in first qgroup_account_extent(), the
>> nr_new_roots of the extent is 1, which means its reference got
>> increased, and qgroup increased its rfer and excl.
>>
>> But at second qgroup_account_extent(), its reference got decreased, but
>> between these two qgroup_account_extent(), there is no switch roots.
>> This leads to the same nr_old_roots, and this extent just got ignored by
>> qgroup, which means this extent is wrongly accounted.
>>
>> Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
>> create_pending_snapshot(), with needed preparation.
>>
>> Reported-by: Mark Fasheh <mfasheh@suse.de>
>
> Can you please CC me on this patch when you send it out? FYI it's customary
> to CC anyone listed here as well as significant reviewers of your patch
> (such as Filipe).
>
>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>    Fix a soft lockup caused by missing switch_commit_root() call.
>>    Fix a warning caused by dirty-but-not-committed root.
>
> This version doesn't introduce any lockups that I encountered, thanks!
>
>
>> v3:
>>    Fix a difference behavior that btrfs qgroup will start accounting
>>    dropped roots if we are creating snapshots.
>>    Other than always account them in next transaction.
>
> This still corrupts the qgroup numbers if you do anything significant to the
> source subvolume. For example, this script shows a 16K difference. My guess
> is that we're missing accounting of some metadata somewhere?
>
>
> #!/bin/bash
>
> DEV=/dev/vdb1
> MNT=/btrfs
>
> mkfs.btrfs -f $DEV
> mount -t btrfs $DEV $MNT
> btrfs quota enable $MNT
> mkdir "$MNT/snaps"
> mkdir "$MNT/data"
> echo "populate $MNT with some data"
> for i in `seq -w 0 640`; do
>      dd if=/dev/zero of="$MNT/data/file$i" bs=1M count=1 >&/dev/null
> done;
> for i in `seq -w 0 1`; do
>          S="$MNT/snaps/snap$i"
>          echo "create snapshot $S"
>          btrfs su snap $MNT $S;
> done;
> btrfs qg show $MNT
>
> umount $MNT
> btrfsck $DEV
>
>
> Sample output:
>
> btrfs-progs v4.4+20160122
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              (null)
> UUID:               a0b648b1-7a23-4213-9bc3-db02b8520efe
> Node size:          16384
> Sector size:        4096
> Filesystem size:    16.00GiB
> Block group profiles:
>    Data:             single            8.00MiB
>    Metadata:         DUP               1.01GiB
>    System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1    16.00GiB  /dev/vdb1
>
> populate /btrfs with some data
> create snapshot /btrfs/snaps/snap0
> Create a snapshot of '/btrfs' in '/btrfs/snaps/snap0'
> create snapshot /btrfs/snaps/snap1
> Create a snapshot of '/btrfs' in '/btrfs/snaps/snap1'
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5         641.34MiB     16.00KiB
> 0/258       641.34MiB     16.00KiB
> 0/259       641.34MiB     16.00KiB
> Checking filesystem on /dev/vdb1
> UUID: a0b648b1-7a23-4213-9bc3-db02b8520efe
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> checking quota groups
> Counts for qgroup id: 5 are different
> our:		referenced 672497664 referenced compressed 672497664
> disk:		referenced 672497664 referenced compressed 672497664
> our:		exclusive 49152 exclusive compressed 49152
> disk:		exclusive 16384 exclusive compressed 16384
> diff:		exclusive 32768 exclusive compressed 32768
> found 673562626 bytes used err is 0
> total csum bytes: 656384
> total tree bytes: 1425408
> total fs tree bytes: 442368
> total extent tree bytes: 98304
> btree space waste bytes: 385361
> file data blocks allocated: 672661504
>   referenced 672661504
> extent buffer leak: start 30965760 len 16384
> extent buffer leak: start 30998528 len 16384
> extent buffer leak: start 31014912 len 16384

I recently found btrfsck --qgroup-report itself is not stable.

So here I prefer to do the accounting check by qgroup rescan, and 
compare the binary output.
>
>
>
> How are you testing this on your end?

Much like yours, but with smaller fs size, about 16M.

The result shows pretty good:
(As I didn't believe btrfsck --qgroup-report now, I use rescan to check 
the result)
------
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB         none         none ---     ---
populating '/mnt/test' with 16 normal files, 1M size
sync
Create a snapshot of '/mnt/test' in '/mnt/test/snap1'
Create a snapshot of '/mnt/test' in '/mnt/test/snap2'
Create a snapshot of '/mnt/test' in '/mnt/test/snap3'
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16793600        16384         none         none ---     ---
0/258        16793600        16384         none         none ---     ---
0/259        16793600        16384         none         none ---     ---
0/260        16793600        16384         none         none ---     ---
quota rescan started
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16793600        16384         none         none ---     ---
0/258        16793600        16384         none         none ---     ---
0/259        16793600        16384         none         none ---     ---
0/260        16793600        16384         none         none ---     ---
------

And yes, even after rescan, btrfsck --qgroup-report seems to report 
false alert.
------
Counts for qgroup id: 5
our:		referenced 16793600 referenced compressed 16793600
disk:		referenced 16793600 referenced compressed 16793600
our:		exclusive 16384 exclusive compressed 16384
disk:		exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 258
our:		referenced 16793600 referenced compressed 16793600
disk:		referenced 16793600 referenced compressed 16793600
our:		exclusive 16384 exclusive compressed 16384
disk:		exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 259
our:		referenced 16793600 referenced compressed 16793600
disk:		referenced 16793600 referenced compressed 16793600
our:		exclusive 16384 exclusive compressed 16384
disk:		exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 260
our:		referenced 16793600 referenced compressed 16793600
disk:		referenced 16793600 referenced compressed 16793600
our:		exclusive 16384 exclusive compressed 16384
disk:		exclusive 16384 exclusive compressed 16384
extent buffer leak: start 30130176 len 16384
extent buffer leak: start 29884416 len 16384
extent buffer leak: start 30015488 len 16384
extent buffer leak: start 30146560 len 16384
------

Anyway, there is something wrong with either btrfsck or kernel qgroup.

Thanks,
Qu



>
>
>> ---
>>   fs/btrfs/transaction.c | 122 +++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 87 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 43885e5..5ba0d9a 100644
>> @@ -1516,6 +1520,65 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>   		goto fail;
>>   	}
>>
>> +	/*
>> +	 * Account qgroups before insert the dir item
>> +	 * As such dir item insert will modify parent_root, which could be
>> +	 * src root. If we don't do it now, wrong accounting may be inherited
>> +	 * to snapshot qgroup.
>> +	 *
>> +	 * For reason locking tree_log_mutex, see btrfs_commit_transaction()
>> +	 * comment
>> +	 */
>> +	mutex_lock(&root->fs_info->tree_log_mutex);
>> +
>> +	ret = commit_fs_roots(trans, root);
>> +	if (ret) {
>> +		mutex_unlock(&root->fs_info->tree_log_mutex);
>> +		goto fail;
>> +	}
>> +
>> +	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
>> +	if (ret < 0) {
>> +		mutex_unlock(&root->fs_info->tree_log_mutex);
>> +		goto fail;
>> +	}
>> +	ret = btrfs_qgroup_account_extents(trans, root->fs_info);
>> +	if (ret < 0) {
>> +		mutex_unlock(&root->fs_info->tree_log_mutex);
>> +		goto fail;
>> +	}
>> +	/*
>> +	 * Now qgroup are all updated, we can inherit it to new qgroups
>> +	 */
>> +	ret = btrfs_qgroup_inherit(trans, fs_info,
>> +				   root->root_key.objectid,
>> +				   objectid, pending->inherit);
>> +	if (ret < 0) {
>> +		mutex_unlock(&root->fs_info->tree_log_mutex);
>> +		goto fail;
>> +	}
>> +	/*
>> +	 * qgroup_account_extents() must be followed by a
>> +	 * switch_commit_roots(), or next qgroup_account_extents() will
>> +	 * be corrupted
>> +	 */
>> +	ret = commit_cowonly_roots(trans, root);
>> +	if (ret) {
>> +		mutex_unlock(&root->fs_info->tree_log_mutex);
>> +		goto fail;
>> +	}
>> +	/*
>> +	 * Just like in btrfs_commit_transaction(), we need to
>> +	 * switch_commit_roots().
>> +	 * However this time we don't need to do a full one,
>> +	 * excluding tree root and chunk root should be OK.
>> +	 *
>> +	 * Also we don't want to free dropped roots here.
>> +	 * Only the final switch_commit_roots() will free them
>> +	 */
>> +	switch_commit_roots(trans->transaction, root->fs_info, 0);
>> +	mutex_unlock(&root->fs_info->tree_log_mutex);
>> +
>>   	ret = btrfs_insert_dir_item(trans, parent_root,
>>   				    dentry->d_name.name, dentry->d_name.len,
>>   				    parent_inode, &key,
>
> create_pending_snapshot() is too big as it is - could we please put this
> code in a separate function?
> 	--Mark
>
> --
> Mark Fasheh
>
>


