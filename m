Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44361 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425268AbeE1PyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:17 -0400
Subject: Re: [PATCH 2/2] btrfs: Refactor running of delayed inode items during
 transaction commit
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1518531409-31625-1-git-send-email-nborisov@suse.com>
 <1518531409-31625-2-git-send-email-nborisov@suse.com>
 <ffd02095-4489-6d90-a47f-93f4020ab097@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>
Message-ID: <995d8c20-c619-c4e6-cb3e-2a9196289775@suse.com>
Date: Mon, 28 May 2018 11:35:16 +0300
MIME-Version: 1.0
In-Reply-To: <ffd02095-4489-6d90-a47f-93f4020ab097@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.05.2018 11:21, Misono Tomohiro wrote:
> Hello,
> 
> I found current misc-next sometimes fails btrfs/152 when the number
> of cpu is >= 4 in my vm and git bisect points this commit.
> (btrfs/152 performs parallel send/receive.)
> 
> The failure is caused by _check_dmesg and sometimes also leads to inconsistent fs.
> 
> dmesg looks like:
> [    6.649213] WARNING: CPU: 0 PID: 2838 at fs/btrfs/transaction.c:303 record_root_in_trans+0x38/0xd0
> [    6.650807] CPU: 0 PID: 2838 Comm: btrfs Tainted: G        W         4.17.0-rc6+ #113
> [    6.651998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
> [    6.653325] RIP: 0010:record_root_in_trans+0x38/0xd0
> [    6.654090] RSP: 0018:ffff90b781e23a68 EFLAGS: 00010206
> [    6.654882] RAX: ffff8f346a48b720 RBX: ffff8f3479ce86c0 RCX: 0000000000000000
> [    6.655965] RDX: 0000000000000000 RSI: ffff8f347c8ec000 RDI: ffff8f346a03a958
> [    6.657059] RBP: ffff90b781e23b80 R08: 0000000000025870 R09: ffffffffa8c112bb
> [    6.658162] R10: ffff90b781e23ba0 R11: 0000000000000002 R12: ffff8f346a03a958
> [    6.659290] R13: ffff8f347c8d9000 R14: ffff8f347ba2a0b8 R15: 0000000000000000
> [    6.660374] FS:  00007f3b62ebc8c0(0000) GS:ffff8f347fc00000(0000) knlGS:0000000000000000
> [    6.661349] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    6.661928] CR2: 00007f0a641995e0 CR3: 000000006af5c000 CR4: 00000000000006f0
> [    6.662651] Call Trace:
> [    6.662909]  create_pending_snapshot+0x1ab/0xd00
> [    6.663391]  ? btrfs_delayed_inode_release_metadata+0xe0/0xf0
> [    6.663972]  ? __btrfs_update_delayed_inode+0x1aa/0x210
> [    6.664526]  ? __btrfs_release_delayed_node.part.18+0x8f/0x1d0
> [    6.665116]  ? create_pending_snapshots+0x81/0xa0
> [    6.665597]  create_pending_snapshots+0x81/0xa0
> [    6.666068]  btrfs_commit_transaction+0x279/0x860
> [    6.666553]  ? start_transaction+0x98/0x3c0
> [    6.666989]  btrfs_mksubvol+0x589/0x5a0
> [    6.667390]  ? btrfs_opendir+0x39/0x70
> [    6.667778]  btrfs_ioctl_snap_create_transid+0x16a/0x1a0
> [    6.668327]  btrfs_ioctl_snap_create_v2+0x121/0x180
> [    6.668827]  btrfs_ioctl+0x56d/0x25a0
> [    6.669205]  ? do_filp_open+0xaa/0x110
> [    6.669591]  ? do_vfs_ioctl+0x9f/0x610
> [    6.669980]  ? btrfs_ioctl_get_supported_features+0x20/0x20
> [    6.670550]  do_vfs_ioctl+0x9f/0x610
> [    6.670922]  ksys_ioctl+0x6b/0x80
> [    6.671261]  __x64_sys_ioctl+0x11/0x20
> [    6.671650]  do_syscall_64+0x49/0x100
> [    6.672040]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [    6.672545] RIP: 0033:0x7f3b61cbddd7
> [    6.672899] RSP: 002b:00007ffcdbe7b318 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [    6.673666] RAX: ffffffffffffffda RBX: 00007ffcdbe90610 RCX: 00007f3b61cbddd7
> [    6.674430] RDX: 00007ffcdbe7b360 RSI: 0000000050009417 RDI: 0000000000000003
> [    6.675154] RBP: 00005634403ec020 R08: 000000000000ffff R09: 0000000000001010
> [    6.675878] R10: 0000000000000000 R11: 0000000000000246 R12: 00005634403ed670
> [    6.676604] R13: 00007ffcdbe7c470 R14: 0000000000000053 R15: 00007ffcdbe7b360
> [    6.677330] Code: f0 01 00 00 a8 02 74 27 48 8b 07 48 39 86 40 03 00 00 73 1b 49 39 75 28 0f 84 91 00 00 00 85 d2 75 17 48 8b 06 48 39 46 08 74 0e <0f> 0b eb 0a 85 d2 74 65 49 3b 75 28 74 76 41 89 d4 48 89 f3 48
> [    6.679318] ---[ end trace b2378f91e69026c3 ]---
> 
> transaction.c:303:
>   WARN_ON(!force && root->commit_root != root->node);
> 
> And 152.out.full looks like:
>   *** fsck.btrfs output ***
>   root item for root 261, current bytenr 53870592, current gen 149, current
>   level 0, new bytenr 54067200, new gen 149, new level 0
>   Found 1 roots with an outdated root item.
>   Please run a filesystem check with the option --repair to fix them.
> 
> =====
> (My observation)
> 
> Call chain is:
>   btrfs_commit_transaction()
>    create_pending_snapshots()
>      create_pending_snapshot()
>        run_delayed_item() <- removed
>        qgroup_account_snapshot()
>    run_delayed_item() <- added
> 
> This commit removes run_delayed_item() in create_pending_snapshot() and
> instead calls it after create_pending_snapshots().
> 
> However, as qgroup_account_snapshot() updates commit_root, if there are
> more than one pending snapshots under the same subvolume, it may fail
> to update root item correctly.
> 
> So, I think we cannot remove run_delayed_item() here.

So btrfs_run_delayed_items is run once before going into
create_pending_snapshots. This means that when we go into
create_pending_snapshots the filesystem should be consistent from the
POV of delayed items (as per patch's changelog).

I somehow fail to reconcile how the removal of run delayed items (which
really pertain to inode state) have anything to do with an outdated
root?  IMHO you are hitting some race which my patch just made more
visible due to removing code in the critical path.

> 
> Thanks,
> Tomohiro Misono
> 
> On 2018/02/13 23:16, Nikolay Borisov wrote:
>> Currently calls to btrfs_run_delayed_inode items have been scattered
>> around the transaction commit code with no real design argument when they 
>> should be execute.
>>
>> We have one call, after transaction writers go to 0. Then we have the delayed
>> items running as part of creating a snapshot (once per pedning snapshot).
>> Finally, delayed items are run once more _after_ snapshots have been created.
>> All in all this amounts to 2 + N (N = number of snapshots slated for creation).
>> In reality we need to flush delayed items once before
>> create_pending_snapshots is called to ensure snapshosts are consistent with
>> inode data and once after snapshots are created so that newly introduced inode 
>> items during snapshot creation process are correctly persisted on disk. This 
>> patch brings the total executions of run_delayed_items to just 2. 
>>
>> This survived multiple xfstest runs. 
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/transaction.c | 31 ++++++++++---------------------
>>  1 file changed, 10 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 02bc1e6212e6..b32d3136f36c 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1524,18 +1524,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>  	}
>>  	btrfs_release_path(path);
>>  
>> -	/*
>> -	 * pull in the delayed directory update
>> -	 * and the delayed inode item
>> -	 * otherwise we corrupt the FS during
>> -	 * snapshot
>> -	 */
>> -	ret = btrfs_run_delayed_items(trans);
>> -	if (ret) {	/* Transaction aborted */
>> -		btrfs_abort_transaction(trans, ret);
>> -		goto fail;
>> -	}
>> -
>>  	record_root_in_trans(trans, root, 0);
>>  	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>>  	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
>> @@ -2069,10 +2057,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  	wait_event(cur_trans->writer_wait,
>>  		   extwriter_counter_read(cur_trans) == 0);
>>  
>> -	/* some pending stuffs might be added after the previous flush. */
>> -	ret = btrfs_run_delayed_items(trans);
>> -	if (ret)
>> -		goto cleanup_transaction;
>>  
>>  	btrfs_wait_delalloc_flush(fs_info);
>>  
>> @@ -2095,6 +2079,16 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  		ret = cur_trans->aborted;
>>  		goto scrub_continue;
>>  	}
>> +
>> +	/*
>> +	 * Run delayed items because we need them to be consistent on-disk
>> +	 * so that snapshots created in create_pending_snapshots don't corrupt
>> +	 * the filesystem. At this point we are the one doing transaction
>> +	 * commit and now one can come and introduce new delayed inode items
>> +	 */
>> +	ret = btrfs_run_delayed_items(trans);
>> +	if (ret)
>> +		goto scrub_continue;
>>  	/*
>>  	 * the reloc mutex makes sure that we stop
>>  	 * the balancing code from coming in and moving
>> @@ -2102,11 +2096,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  	 */
>>  	mutex_lock(&fs_info->reloc_mutex);
>>  
>> -	/*
>> -	 * We needn't worry about the delayed items because we will
>> -	 * deal with them in create_pending_snapshot(), which is the
>> -	 * core function of the snapshot creation.
>> -	 */
>>  	ret = create_pending_snapshots(trans);
>>  	if (ret) {
>>  		mutex_unlock(&fs_info->reloc_mutex);
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
