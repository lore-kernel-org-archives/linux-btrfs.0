Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3AOGDJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 01:03:09 -0500
Message-ID: <50F4F145.9060201@cn.fujitsu.com>
Date: Tue, 15 Jan 2013 14:03:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: dsterba@suse.cz, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 10/11] Btrfs: use bit operation for ->fs_state
References: <50EEB96F.6040706@cn.fujitsu.com> <20130110175735.GI20089@twin.jikos.cz> <50F3B8C7.3000902@cn.fujitsu.com> <20130115040301.GA2430@liubo>
In-Reply-To: <20130115040301.GA2430@liubo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 15 Jan 2013 12:03:03 +0800, Liu Bo wrote:
> On Mon, Jan 14, 2013 at 03:50:31PM +0800, Miao Xie wrote:
>> On 	thu, 10 Jan 2013 18:57:35 +0100, David Sterba wrote:
>>> On Thu, Jan 10, 2013 at 08:51:59PM +0800, Miao Xie wrote:
>>>> There is no lock to protect fs_info->fs_state, it will introduce some problems,
>>>> such as the value may be covered by the other task when several tasks modify
>>>> it. Now we use bit operation for it to fix the above problem.
>>>
>>> Can you please describe in more detail how does that happen and to what
>>> problems it leads?
>>
>> For example:
>> 	Task0 - CPU0		Task1 - CPU1
>> 	mov %fs_state rax
>> 	or $0x1 rax
>> 				mov %fs_state rax
>> 				or $0x2 rax
>> 	mov rax %fs_state
>> 				mov rax %fs_state
>>
>> The expected value is 3, but in fact, it is 2
> 
> The code shows that fs_state is only set by open_ctree() and
> save_error_info(), how could the above race can happen?

The reason that the above race can not happen is because there is only one flag currently.
But as we know, ->fs_state can be accessed and updated by multi-task, so the current code
is error prone, if we add other flags, the above problem will happen to a certainty. (Adding
new flags is very likely) So why not write right and robust code at the beginning?

> Although I'm ok with this as a harmless cleanup patch, I'm afraid the commit log
> is not persuadable anyway.

I think the changelog is right since ->fs_state can be accessed and updated by multi-task
actually.

Thanks
Miao

> 
> thanks,
> liubo
> 
>>
>> Thanks
>> Miao
>>
>>>
>>> thanks,
>>> david
>>>
>>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>>> ---
>>>>  fs/btrfs/ctree.h       | 4 +++-
>>>>  fs/btrfs/disk-io.c     | 5 +++--
>>>>  fs/btrfs/file.c        | 2 +-
>>>>  fs/btrfs/scrub.c       | 2 +-
>>>>  fs/btrfs/super.c       | 4 ++--
>>>>  fs/btrfs/transaction.c | 9 ++++-----
>>>>  6 files changed, 14 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index c95b539..c34e36e 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -338,7 +338,9 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>>>>  /*
>>>>   * File system states
>>>>   */
>>>> +#define BTRFS_FS_STATE_ERROR		0
>>>>  
>>>> +/* Super block flags */
>>>>  /* Errors detected */
>>>>  #define BTRFS_SUPER_FLAG_ERROR		(1ULL << 2)
>>>>  
>>>> @@ -1540,7 +1542,7 @@ struct btrfs_fs_info {
>>>>  	u64 qgroup_seq;
>>>>  
>>>>  	/* filesystem state */
>>>> -	u64 fs_state;
>>>> +	unsigned long fs_state;
>>>>  
>>>>  	struct btrfs_delayed_root *delayed_root;
>>>>  
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index cf03a45..d06e50c 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -2196,7 +2196,8 @@ int open_ctree(struct super_block *sb,
>>>>  		goto fail_alloc;
>>>>  
>>>>  	/* check FS state, whether FS is broken. */
>>>> -	fs_info->fs_state |= btrfs_super_flags(disk_super);
>>>> +	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
>>>> +		set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
>>>>  
>>>>  	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
>>>>  	if (ret) {
>>>> @@ -3354,7 +3355,7 @@ int close_ctree(struct btrfs_root *root)
>>>>  			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
>>>>  	}
>>>>  
>>>> -	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
>>>> +	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
>>>>  		btrfs_error_commit_super(root);
>>>>  
>>>>  	btrfs_put_block_group_cache(fs_info);
>>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>>> index 3e9fa0e..ec87b69 100644
>>>> --- a/fs/btrfs/file.c
>>>> +++ b/fs/btrfs/file.c
>>>> @@ -1531,7 +1531,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
>>>>  	 * although we have opened a file as writable, we have
>>>>  	 * to stop this write operation to ensure FS consistency.
>>>>  	 */
>>>> -	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>>>> +	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state)) {
>>>>  		mutex_unlock(&inode->i_mutex);
>>>>  		err = -EROFS;
>>>>  		goto out;
>>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>>> index af0b566..2e91b56 100644
>>>> --- a/fs/btrfs/scrub.c
>>>> +++ b/fs/btrfs/scrub.c
>>>> @@ -2700,7 +2700,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
>>>>  	int	ret;
>>>>  	struct btrfs_root *root = sctx->dev_root;
>>>>  
>>>> -	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
>>>> +	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
>>>>  		return -EIO;
>>>>  
>>>>  	gen = atomic64_read(&root->fs_info->last_trans_committed);
>>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>>> index 6f0524d..f714379 100644
>>>> --- a/fs/btrfs/super.c
>>>> +++ b/fs/btrfs/super.c
>>>> @@ -98,7 +98,7 @@ static void __save_error_info(struct btrfs_fs_info *fs_info)
>>>>  	 * today we only save the error info into ram.  Long term we'll
>>>>  	 * also send it down to the disk
>>>>  	 */
>>>> -	fs_info->fs_state = BTRFS_SUPER_FLAG_ERROR;
>>>> +	set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
>>>>  }
>>>>  
>>>>  static void save_error_info(struct btrfs_fs_info *fs_info)
>>>> @@ -114,7 +114,7 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
>>>>  	if (sb->s_flags & MS_RDONLY)
>>>>  		return;
>>>>  
>>>> -	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>>>> +	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
>>>>  		sb->s_flags |= MS_RDONLY;
>>>>  		printk(KERN_INFO "btrfs is forced readonly\n");
>>>>  		/*
>>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>>> index 7999bf8..a950d48 100644
>>>> --- a/fs/btrfs/transaction.c
>>>> +++ b/fs/btrfs/transaction.c
>>>> @@ -62,7 +62,7 @@ static noinline int join_transaction(struct btrfs_root *root, int type)
>>>>  	spin_lock(&fs_info->trans_lock);
>>>>  loop:
>>>>  	/* The file system has been taken offline. No new transactions. */
>>>> -	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>>>> +	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
>>>>  		spin_unlock(&fs_info->trans_lock);
>>>>  		return -EROFS;
>>>>  	}
>>>> @@ -114,7 +114,7 @@ loop:
>>>>  		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
>>>>  		cur_trans = fs_info->running_transaction;
>>>>  		goto loop;
>>>> -	} else if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>>>> +	} else if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
>>>>  		spin_unlock(&fs_info->trans_lock);
>>>>  		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
>>>>  		return -EROFS;
>>>> @@ -302,7 +302,7 @@ start_transaction(struct btrfs_root *root, u64 num_items, int type,
>>>>  	int ret;
>>>>  	u64 qgroup_reserved = 0;
>>>>  
>>>> -	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
>>>> +	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
>>>>  		return ERR_PTR(-EROFS);
>>>>  
>>>>  	if (current->journal_info) {
>>>> @@ -635,9 +635,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>>>>  		btrfs_run_delayed_iputs(root);
>>>>  
>>>>  	if (trans->aborted ||
>>>> -	    root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>>>> +	    test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
>>>>  		err = -EIO;
>>>> -	}
>>>>  	assert_qgroups_uptodate(trans);
>>>>  
>>>>  	memset(trans, 0, sizeof(*trans));
>>>> -- 
>>>> 1.7.11.7
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

