Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36566 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758925AbcLWBIt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 20:08:49 -0500
Subject: Re: [PATCH] btrfs-progs: Get the highest inode for lost+found
To: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20161220120854.4270-1-rgoldwyn@suse.de>
 <bbcb3da4-bae9-6d2a-ad23-9239531aa5ea@cn.fujitsu.com>
 <9b0ecf8e-dd7d-d019-9272-61a2ba00d0a6@suse.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ed81b5d3-d39c-f725-87e8-4e317c790aa9@cn.fujitsu.com>
Date: Fri, 23 Dec 2016 09:08:32 +0800
MIME-Version: 1.0
In-Reply-To: <9b0ecf8e-dd7d-d019-9272-61a2ba00d0a6@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/23/2016 08:47 AM, Goldwyn Rodrigues wrote:
>
>
> On 12/20/2016 06:57 PM, Qu Wenruo wrote:
>>
>>
>> At 12/20/2016 08:08 PM, Goldwyn Rodrigues wrote:
>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>
>>> root->highest_inode is not accurate at the time of creating a lost+found
>>> and it fails because the highest_inode+1 is already present. This
>>> could be
>>> because of fixes after highest_inode is set. Instead, search
>>> for the highest inode in the tree and use it for lost+found.
>>>
>>> This makes root->highest_inode unnecessary and hence deleted.
>>
>> This is much better than recording it in root.
>>
>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> ---
>>>  cmds-check.c | 46 +++++++++++++++++++++++++++-------------------
>>>  ctree.h      |  1 -
>>>  disk-io.c    |  1 -
>>>  3 files changed, 27 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/cmds-check.c b/cmds-check.c
>>> index 1dba298..a55d00d 100644
>>> --- a/cmds-check.c
>>> +++ b/cmds-check.c
>>> @@ -2853,6 +2853,31 @@ out:
>>>      return ret;
>>>  }
>>>
>>> +static int get_highest_inode(struct btrfs_trans_handle *trans,
>>> +                struct btrfs_root *root,
>>> +                struct btrfs_path *path,
>>> +                u64 *highest_ino)
>>> +{
>>> +    struct btrfs_key key, found_key;
>>> +    int ret;
>>> +
>>> +    btrfs_init_path(path);
>>> +    key.objectid = BTRFS_LAST_FREE_OBJECTID;
>>> +    key.offset = -1;
>>> +    key.type = BTRFS_INODE_ITEM_KEY;
>>> +    ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>>> +    if (ret == 1) {
>>> +        btrfs_item_key_to_cpu(path->nodes[0], &found_key,
>>> +                path->slots[0] - 1);
>>> +        *highest_ino = found_key.objectid;
>>> +        ret = 0;
>>> +    }
>>
>> I think such search may cause problem.
>>
>> If the fs uses inode_map mount option, each fs tree will have a tailing
>> FREE_INO and FREE_SPACE items.
>>
>> And FREE_INO/FREE_SPACE are all over LAST_FREE_OBJECTID.
>>
>>         item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
>>                 inode generation 3 transid 7 size 0 nbytes 16384
>>                 block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
>>                 sequence 0 flags 0x1(none)
>>         item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>>                 inode ref index 0 namelen 2 name: ..
>>         item 2 key (FREE_INO INODE_ITEM 0) itemoff 15951 itemsize 160
>>                 inode generation 0 transid 7 size 0 nbytes 0
>>                 block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
>>                 sequence 24 flags 0x0(NOCOMPRESS|PREALLOC)
>>         item 3 key (FREE_SPACE UNTYPED 0) itemoff 15910 itemsize 41
>>                 location key (FREE_INO INODE_ITEM 0)
>>                 cache generation 0 entries 0 bitmaps 0
>>
>>
>> In that case, such search will point to the FREE_INO slot, and always
>> return -EOVERFLOW.
>>
>> What about check the objectid and if it's larger than
>> LAST_FREE_OBJECTID, try to search previous slot?
>
> If we are starting from LAST_FREE_OBJECTID which is -256ULL and smaller
> than FREE_INO (-12ULL). -256ULL < -12ULL.
> Won't a search for a (slot - 1) result in something smaller than

Oh my fault, I didn't the "path->slots[0] - 1" used in 
btrfs_item_key_to_cpu().

I always assume we should use btrfs_previous_item() to get previous 
item, not use slot - 1 directly.

BTW, btrfs_previous_item() seems safer, since it can handle case like 
slot[0] == 0.
Even though it won't happen since LAST_FREE_OBJECTID will not be used by 
any inode.

Feel free to add my reviewed tag:

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu

> -256ULL? IOW, if it results in -12ULL then it is not a valid inode
> anyways and hence should return -EOVERFLOW anyways.
>
>
>>
>> Other part looks good for me.
>>
>> Thanks,
>> Qu
>>> +    if (*highest_ino >= BTRFS_LAST_FREE_OBJECTID)
>>> +        ret = -EOVERFLOW;
>>> +    btrfs_release_path(path);
>>> +    return ret;
>>> +}
>>> +
>>>  static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
>>>                     struct btrfs_root *root,
>>>                     struct btrfs_path *path,
>>> @@ -2898,11 +2923,9 @@ static int repair_inode_nlinks(struct
>>> btrfs_trans_handle *trans,
>>>      }
>>>
>>>      if (rec->found_link == 0) {
>>> -        lost_found_ino = root->highest_inode;
>>> -        if (lost_found_ino >= BTRFS_LAST_FREE_OBJECTID) {
>>> -            ret = -EOVERFLOW;
>>> +        ret = get_highest_inode(trans, root, path, &lost_found_ino);
>>> +        if (ret < 0)
>>>              goto out;
>>> -        }
>>>          lost_found_ino++;
>>>          ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
>>>                    BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
>>> @@ -3266,21 +3289,6 @@ static int check_inode_recs(struct btrfs_root
>>> *root,
>>>      }
>>>
>>>      /*
>>> -     * We need to record the highest inode number for later 'lost+found'
>>> -     * dir creation.
>>> -     * We must select an ino not used/referred by any existing inode, or
>>> -     * 'lost+found' ino may be a missing ino in a corrupted leaf,
>>> -     * this may cause 'lost+found' dir has wrong nlinks.
>>> -     */
>>> -    cache = last_cache_extent(inode_cache);
>>> -    if (cache) {
>>> -        node = container_of(cache, struct ptr_node, cache);
>>> -        rec = node->data;
>>> -        if (rec->ino > root->highest_inode)
>>> -            root->highest_inode = rec->ino;
>>> -    }
>>> -
>>> -    /*
>>>       * We need to repair backrefs first because we could change some
>>> of the
>>>       * errors in the inode recs.
>>>       *
>>> diff --git a/ctree.h b/ctree.h
>>> index dd02ef8..0c34ae2 100644
>>> --- a/ctree.h
>>> +++ b/ctree.h
>>> @@ -1177,7 +1177,6 @@ struct btrfs_root {
>>>
>>>
>>>      u32 type;
>>> -    u64 highest_inode;
>>>      u64 last_inode_alloc;
>>>
>>>      /*
>>> diff --git a/disk-io.c b/disk-io.c
>>> index 9140a81..2a94d4f 100644
>>> --- a/disk-io.c
>>> +++ b/disk-io.c
>>> @@ -494,7 +494,6 @@ void btrfs_setup_root(u32 nodesize, u32 leafsize,
>>> u32 sectorsize,
>>>      root->fs_info = fs_info;
>>>      root->objectid = objectid;
>>>      root->last_trans = 0;
>>> -    root->highest_inode = 0;
>>>      root->last_inode_alloc = 0;
>>>
>>>      INIT_LIST_HEAD(&root->dirty_list);
>>>
>>
>>
>>
>


