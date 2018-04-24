Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48395 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbeDXSDL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 14:03:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB144ACB8
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 18:03:09 +0000 (UTC)
Subject: Re: [PATCH] btrfs: push relocation recovery into a helper thread
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0d7559af-b5ea-f725-1859-1c561984622f@suse.com>
 <20180423214331.GZ21272@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <18d45880-1321-de86-601d-9652a0fd0189@suse.com>
Date: Tue, 24 Apr 2018 14:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <20180423214331.GZ21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/23/18 5:43 PM, David Sterba wrote:
> On Tue, Apr 17, 2018 at 02:45:33PM -0400, Jeff Mahoney wrote:
>> On a file system with many snapshots and qgroups enabled, an interrupted
>> balance can end up taking a long time to mount due to recovering the
>> relocations during mount.  It does this in the task performing the mount,
>> which can't be interrupted and may prevent mounting (and systems booting)
>> for a long time as well.  The thing is that as part of balance, this
>> runs in the background all the time.  This patch pushes the recovery
>> into a helper thread and allows the mount to continue normally.  We hold
>> off on resuming any paused balance operation until after the relocation
>> has completed, disallow any new balance operations if it's running, and
>> wait for it on umount and remounting read-only.
> 
> The overall logic sounds ok.

Thanks for the review.  I've updated the style issues in my patch and
removed them from the quote below.

> So, this can also stall the umount, right? Eg. if I start mount,
> relocation goes to background, then unmount will have to wait for
> completion.

Yep, I didn't try to solve that problem since the file system wouldn't
even mount before.  Makes sense to make it unmountable, though.  That's
a change that would probably speed up btrfs balance cancel as well.

> Balance pause is requested at umount time, something similar should be
> possible for relocation recovery. The fs_state bit CLOSING could be
> checked somewhere in the loop.

An earlier version had that check in the top of the loop in
merge_reloc_roots, but I think a better spot would be the top of the
merge_reloc_root loop.

>> This doesn't do anything to address the relocation recovery operation
>> taking a long time but does allow the file system to mount.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/ctree.h      |    7 +++
>>  fs/btrfs/disk-io.c    |    7 ++-
>>  fs/btrfs/relocation.c |   92 +++++++++++++++++++++++++++++++++++++++++---------
>>  fs/btrfs/super.c      |    5 +-
>>  fs/btrfs/volumes.c    |    6 +++
>>  5 files changed, 97 insertions(+), 20 deletions(-)
>>
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1052,6 +1052,10 @@ struct btrfs_fs_info {
>>  	struct btrfs_work qgroup_rescan_work;
>>  	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
>>  
>> +	/* relocation recovery items */
>> +	bool relocation_recovery_started;
>> +	struct completion relocation_recovery_completion;
> 
> This seems to copy the pattern of qgroup rescan, the completion +
> workqueue. I'm planning to move this scheme to the fs_state bit instead
> of bool and the wait_for_war with global workqueue, but for now we can
> leave as it is here.

Such that we just put these jobs on a workqueue instead?

>> +	if (err == 0) {
>> +		struct btrfs_root *fs_root;
>> +
>> +		/* cleanup orphan inode in data relocation tree */
>> +		fs_root = read_fs_root(fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
>> +		if (IS_ERR(fs_root))
>> +			err = PTR_ERR(fs_root);
>> +		else
>> +			err = btrfs_orphan_cleanup(fs_root);
>> +	}
>> +	mutex_unlock(&fs_info->cleaner_mutex);
>> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> 
> The part that sets the bit is in the caller, btrfs_recover_relocation,
> but this can race if the kthread is too fast.
> 
> btrfs_recover_relocation
> 	start kthread with btrfs_resume_relocation
> 		clear_bit
> 	set_bit
> 	...
> 
> now we're stuck with the EXCL_OP set without any operation actually running.
> 
> The bit can be set right before the kthread is started and cleared
> inside.

There's no opportunity to race since the thread can't run until
btrfs_recover_relocation returns and releases the cleaner mutex.

>> @@ -4620,16 +4670,21 @@ int btrfs_recover_relocation(struct btrf
>>  	if (err)
>>  		goto out_free;
>>  
>> -	merge_reloc_roots(rc);
>> -
>> -	unset_reloc_control(rc);
>> -
>> -	trans = btrfs_join_transaction(rc->extent_root);
>> -	if (IS_ERR(trans)) {
>> -		err = PTR_ERR(trans);
>> +	tsk = kthread_run(btrfs_resume_relocation, fs_info,
>> +			  "relocation-recovery");
> 
> Would be good to name it 'btrfs-reloc-recovery', ie with btrfs in the
> name so it's easy greppable from the process list.

Right.  In an earlier version, I was using a btrfs_worker so that was
added automatically.

>> +	if (IS_ERR(tsk)) {
>> +		err = PTR_ERR(tsk);
>>  		goto out_free;
>>  	}
>> -	err = btrfs_commit_transaction(trans);
>> +
>> +	fs_info->relocation_recovery_started = true;
>> +
>> +	/* protected from racing with resume thread by the cleaner_mutex */
>> +	init_completion(&fs_info->relocation_recovery_completion);
>> +
>> +	set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> 
> The 2nd comment above refers to this.

The response too.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
