Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13986 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750977AbdCMHZg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:25:36 -0400
Subject: Re: [PATCH v3.1 1/7] btrfs: Introduce a function to check if all
 chunks a OK for degraded rw mount
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
 <20170309013442.19957-2-quwenruo@cn.fujitsu.com>
 <f01fd9f3-85fe-c390-5358-be8c5d67ebc6@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4b9409a0-290a-02d4-4288-2b66c1ed0cd6@cn.fujitsu.com>
Date: Mon, 13 Mar 2017 15:25:26 +0800
MIME-Version: 1.0
In-Reply-To: <f01fd9f3-85fe-c390-5358-be8c5d67ebc6@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/13/2017 03:29 PM, Anand Jain wrote:
>
>
> On 03/09/2017 09:34 AM, Qu Wenruo wrote:
>> Introduce a new function, btrfs_check_rw_degradable(), to check if all
>> chunks in btrfs is OK for degraded rw mount.
>>
>> It provides the new basis for accurate btrfs mount/remount and even
>> runtime degraded mount check other than old one-size-fit-all method.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> Tested-by: Adam Borowski <kilobyte@angband.pl>
>> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
>> ---
>>  fs/btrfs/volumes.c | 55
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/volumes.h |  1 +
>>  2 files changed, 56 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 73d56eef5e60..83613955e3c2 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6765,6 +6765,61 @@ int btrfs_read_sys_array(struct btrfs_fs_info
>> *fs_info)
>>      return -EIO;
>>  }
>>
>> +/*
>> + * Check if all chunks in the fs is OK for read-write degraded mount
>> + *
>> + * Return true if the fs is OK to be mounted degraded read-write
>> + * Return false if the fs is not OK to be mounted degraded
>> + */
>> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
>> +{
>> +    struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>> +    struct extent_map *em;
>> +    u64 next_start = 0;
>> +    bool ret = true;
>> +
>> +    read_lock(&map_tree->map_tree.lock);
>> +    em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)-1);
>> +    read_unlock(&map_tree->map_tree.lock);
>> +    /* No chunk at all? Return false anyway */
>> +    if (!em) {
>> +        ret = false;
>> +        goto out;
>> +    }
>> +    while (em) {
>> +        struct map_lookup *map;
>> +        int missing = 0;
>> +        int max_tolerated;
>> +        int i;
>> +
>> +        map = (struct map_lookup *) em->bdev;
>
>
>    any idea why not   map = em->map_lookup;  here?


My fault, will update the patch.

Thanks,
Qu
>
> Thanks, Anand
>
>
>> +        max_tolerated =
>> +            btrfs_get_num_tolerated_disk_barrier_failures(
>> +                    map->type);
>> +        for (i = 0; i < map->num_stripes; i++) {
>> +            if (map->stripes[i].dev->missing)
>> +                missing++;
>> +        }
>> +        if (missing > max_tolerated) {
>> +            ret = false;
>> +            btrfs_warn(fs_info,
>> +    "chunk %llu missing %d devices, max tolerance is %d for writeble
>> mount",
>> +                   em->start, missing, max_tolerated);
>> +            free_extent_map(em);
>> +            goto out;
>> +        }
>> +        next_start = extent_map_end(em);
>> +        free_extent_map(em);
>> +
>> +        read_lock(&map_tree->map_tree.lock);
>> +        em = lookup_extent_mapping(&map_tree->map_tree, next_start,
>> +                       (u64)(-1) - next_start);
>> +        read_unlock(&map_tree->map_tree.lock);
>> +    }
>> +out:
>> +    return ret;
>> +}
>> +
>>  int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
>>  {
>>      struct btrfs_root *root = fs_info->chunk_root;
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 59be81206dd7..db1b5ef479cf 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -538,4 +538,5 @@ struct list_head *btrfs_get_fs_uuids(void);
>>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>
>> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
>>  #endif
>>
>
>


