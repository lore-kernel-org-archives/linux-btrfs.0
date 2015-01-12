Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17082 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbALQpy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 11:45:54 -0500
Message-ID: <54B3FA3F.6070907@oracle.com>
Date: Tue, 13 Jan 2015 00:45:51 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] Btrfs: fix unused members in struct btrfs_root
References: <1421078887-29970-1-git-send-email-anand.jain@oracle.com> <CAL3q7H6zoiMmBPyoCSGvhcMZ65wR2_7gENgku=YkQV4XyXC_uA@mail.gmail.com>
In-Reply-To: <CAL3q7H6zoiMmBPyoCSGvhcMZ65wR2_7gENgku=YkQV4XyXC_uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks Filipe for pointing out.
my hands moved too fast, 2 concurrent calls case didn't pop in mind.
sorry my mistake.  I see other two members (root_kobj and 
kobj_unregister) are still not used.

Anand

On 13/01/2015 00:17, Filipe David Manana wrote:
> On Mon, Jan 12, 2015 at 4:08 PM, Anand Jain <anand.jain@oracle.com> wrote:
>> There isn't any real use of following members of struct btrfs_root
>> so delete them.
>>
>> struct kobject root_kobj;
>> struct completion kobj_unregister;
>> struct mutex objectid_mutex;
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ctree.h     | 4 ----
>>   fs/btrfs/disk-io.c   | 3 ---
>>   fs/btrfs/inode-map.c | 2 --
>>   3 files changed, 9 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 7e60741..afcd199 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1793,10 +1793,6 @@ struct btrfs_root {
>>          struct btrfs_fs_info *fs_info;
>>          struct extent_io_tree dirty_log_pages;
>>
>> -       struct kobject root_kobj;
>> -       struct completion kobj_unregister;
>> -       struct mutex objectid_mutex;
>> -
>>          spinlock_t accounting_lock;
>>          struct btrfs_block_rsv *block_rsv;
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 8c63419..76c6e67 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1249,7 +1249,6 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
>>          spin_lock_init(&root->accounting_lock);
>>          spin_lock_init(&root->log_extents_lock[0]);
>>          spin_lock_init(&root->log_extents_lock[1]);
>> -       mutex_init(&root->objectid_mutex);
>>          mutex_init(&root->log_mutex);
>>          mutex_init(&root->ordered_extent_mutex);
>>          mutex_init(&root->delalloc_mutex);
>> @@ -1275,12 +1274,10 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
>>          memset(&root->root_key, 0, sizeof(root->root_key));
>>          memset(&root->root_item, 0, sizeof(root->root_item));
>>          memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
>> -       memset(&root->root_kobj, 0, sizeof(root->root_kobj));
>>          if (fs_info)
>>                  root->defrag_trans_start = fs_info->generation;
>>          else
>>                  root->defrag_trans_start = 0;
>> -       init_completion(&root->kobj_unregister);
>>          root->root_key.objectid = objectid;
>>          root->anon_dev = 0;
>>
>> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
>> index 74faea3..fc120d9 100644
>> --- a/fs/btrfs/inode-map.c
>> +++ b/fs/btrfs/inode-map.c
>> @@ -546,7 +546,6 @@ error:
>>   int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>>   {
>>          int ret;
>> -       mutex_lock(&root->objectid_mutex);
>>
>>          if (unlikely(root->highest_objectid < BTRFS_FIRST_FREE_OBJECTID)) {
>>                  ret = btrfs_find_highest_objectid(root,
>> @@ -563,6 +562,5 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>>          *objectid = ++root->highest_objectid;
>>          ret = 0;
>>   out:
>> -       mutex_unlock(&root->objectid_mutex);
>
> This seems wrong. Without this lock how do you ensure 2 concurrent
> calls don't get the same objectid?
>
>>          return ret;
>>   }
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
