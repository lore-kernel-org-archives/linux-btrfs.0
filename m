From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2] Btrfs: serialize flushers in reserve_metadata_bytes
Date: Thu, 09 Jun 2011 10:00:42 -0400
Message-ID: <4DF0D20A.4040906@redhat.com>
References: <1307479449-14765-1-git-send-email-josef@redhat.com> <1307479449-14765-3-git-send-email-josef@redhat.com> <20110609094547.GK12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110609094547.GK12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2011 05:45 AM, David Sterba wrote:
> On Tue, Jun 07, 2011 at 04:44:09PM -0400, Josef Bacik wrote:
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2932,6 +2932,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>>  	found->full = 0;
>>  	found->force_alloc = CHUNK_ALLOC_NO_FORCE;
>>  	found->chunk_alloc = 0;
>> +	found->flush = 0;
>> +	init_waitqueue_head(&found->wait);
>>  	*space_info = found;
>>  	list_add_rcu(&found->list, &info->space_info);
>>  	atomic_set(&found->caching_threads, 0);
>> @@ -3314,9 +3316,13 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
>>  	if (reserved == 0)
>>  		return 0;
>>  
>> -	/* nothing to shrink - nothing to reclaim */
>> -	if (root->fs_info->delalloc_bytes == 0)
>> +	smp_mb();
> 
> can you please explain why do you use the barrier here? (and add that
> explanation as a comment)
> 
> it's for the delalloc_bytes test, right? this is being modified in
> btrfs_set_bit_hook/btrfs_clear_bit_hook, protected by a spinlock.
> the counter is sum of all delalloc_bytes for each delalloc inode.
> if the counter is nonzero, then fs_info->delalloc_inodes is expected to
> be nonempty, but the list is not touched in this function, but
> indirectly from writeback_inodes_sb_nr_if_idle and the respective
> .writepages callback, ending up in __extent_writepage which starts
> messing with delalloc.
> 
> it think it's possible to reach state, where counter is nonzero, but the
> delalloc_inodes list is empty. then writeback will just skip the
> delalloc work in this round and will process it later.
> even with a barrier in place:
> 
> btrfs_set_bit_hook:
> # counter increased, a barrier will assure len is obtained from
> # delalloc_bytes in shrink_delalloc
> 1349                 root->fs_info->delalloc_bytes += len;
> # but fs_info->delalloc_list may be empty
> 1350                 if (do_list && list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
> 1351				list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
> 1352				&root->fs_info->delalloc_inodes);
> 1353                 }
> 
> although this does not seem to crash or cause corruption, I suggest to
> use the spinlock as the synchronization mechanism to protect reading
> fs_info->delalloc_bytes
> 

We're just looking to optimize the case where there is no delalloc.  If
there is delalloc we want to start the flushing thread.  Is there a
possibility that we could have delalloc_bytes set but nothing on the
list yet?  Sure, but in the time that we actually get to the writing out
of dirty inodes it should be on the list.  And if not, we loop several
times, so at some point it will be on the list and we will be good to
go.  We're not trying to be perfect here, we're trying to be fast :).
Thanks,

Josef
