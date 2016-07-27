Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53452 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932413AbcG0B3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 21:29:20 -0400
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion work
 when allocating data space
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <df0eb696-efea-0902-8e18-131a0898857c@fb.com>
 <20160726120420.29692-1-wangxg.fnst@cn.fujitsu.com>
 <82bb9660-3245-a40c-4ac4-650a235c0d90@fb.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57980DBE.9050702@cn.fujitsu.com>
Date: Wed, 27 Jul 2016 09:26:22 +0800
MIME-Version: 1.0
In-Reply-To: <82bb9660-3245-a40c-4ac4-650a235c0d90@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/26/2016 11:51 PM, Josef Bacik wrote:
> On 07/26/2016 08:04 AM, Wang Xiaoguang wrote:
>> cleaner_kthread() may run at any time, in which it'll call 
>> btrfs_delete_unused_bgs()
>> to delete unused block groups. Because this work is asynchronous, it 
>> may also result
>> in false ENOSPC error. Please see below race window:
>>
>>                CPU1                           |             CPU2
>>                                               |
>> |-> btrfs_alloc_data_chunk_ondemand()         |-> cleaner_kthread()
>>     |-> do_chunk_alloc()                      |   |
>>     |   assume it returns ENOSPC, which means |   |
>>     |   btrfs_space_info is full and have free|   |
>>     |   space to satisfy data request.        |   |
>>     |                                         |   |- > 
>> btrfs_delete_unused_bgs()
>>     |                                         |   |    it will 
>> decrease btrfs_space_info
>>     |                                         |   | total_bytes and make
>>     |                                         |   | btrfs_space_info 
>> is not full.
>>     |                                         |   |
>> In this case, we may get ENOSPC error, but btrfs_space_info is not full.
>>
>> To fix this issue, in btrfs_alloc_data_chunk_ondemand(), if we need 
>> to call
>> do_chunk_alloc() to allocating new chunk, we should block 
>> btrfs_delete_unused_bgs().
>> So here we introduce a new struct rw_semaphore bg_delete_sem to do 
>> this job.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>> v3: improve one code logic suggested by Josef, thanks.
>> ---
>>  fs/btrfs/ctree.h       |  1 +
>>  fs/btrfs/disk-io.c     |  1 +
>>  fs/btrfs/extent-tree.c | 44 
>> ++++++++++++++++++++++++++++++++++++++------
>>  3 files changed, 40 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 7eb2913..bf0751d 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -800,6 +800,7 @@ struct btrfs_fs_info {
>>      struct mutex cleaner_mutex;
>>      struct mutex chunk_mutex;
>>      struct mutex volume_mutex;
>> +    struct rw_semaphore bg_delete_sem;
>>
>>      /*
>>       * this is taken to make sure we don't set block groups ro after
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 60ce119..f8609fd 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2683,6 +2683,7 @@ int open_ctree(struct super_block *sb,
>>      init_rwsem(&fs_info->commit_root_sem);
>>      init_rwsem(&fs_info->cleanup_work_sem);
>>      init_rwsem(&fs_info->subvol_sem);
>> +    init_rwsem(&fs_info->bg_delete_sem);
>>      sema_init(&fs_info->uuid_tree_rescan_sem, 1);
>>
>>      btrfs_init_dev_replace_locks(fs_info);
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index df8d756..50b440e 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4111,6 +4111,7 @@ int btrfs_alloc_data_chunk_ondemand(struct 
>> inode *inode, u64 bytes)
>>      int ret = 0;
>>      int need_commit = 2;
>>      int have_pinned_space;
>> +    int have_bg_delete_sem = 0;
>>
>>      /* make sure bytes are sectorsize aligned */
>>      bytes = ALIGN(bytes, root->sectorsize);
>> @@ -4121,8 +4122,11 @@ int btrfs_alloc_data_chunk_ondemand(struct 
>> inode *inode, u64 bytes)
>>      }
>>
>>      data_sinfo = fs_info->data_sinfo;
>> -    if (!data_sinfo)
>> +    if (!data_sinfo) {
>> +        down_read(&root->fs_info->bg_delete_sem);
>> +        have_bg_delete_sem = 1;
>>          goto alloc;
>> +    }
>>
>>  again:
>>      /* make sure we have enough space to handle the data first */
>> @@ -4135,6 +4139,19 @@ again:
>>          struct btrfs_trans_handle *trans;
>>
>>          /*
>> +         * We may need to allocate new chunk, so we should block
>> +         * btrfs_delete_unused_bgs()
>> +         */
>> +        if (!have_bg_delete_sem) {
>> +            spin_unlock(&data_sinfo->lock);
>> +            down_read(&root->fs_info->bg_delete_sem);
>> +            have_bg_delete_sem = 1;
>> +            spin_lock(&data_sinfo->lock);
>> +            if (used + bytes <= data_sinfo->total_bytes)
>
> Doh sorry I forgot to mention you need to re-calculate used here. Also 
> I noticed we already have a delete_unused_bgs_mutex, can we drop that 
> and replace it with bg_delete_sem as well?  Thanks,
Sorry, I also forgot to re-calculate used...
OK, I'll try to replace delete_unused_bgs_mutex with bg_delete_sem, 
please wait a while :)

Regards,
Xiaoguang Wang

>
> Josef
>
>



