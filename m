Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44609 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeFSFeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 01:34:10 -0400
Subject: Re: [PATCH] btrfs-progs: Check factor out root parsing from
 check_chunks_and_extents
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1529320258-23095-1-git-send-email-nborisov@suse.com>
 <ca369d20-3a41-165d-9ae9-5000aea31a1b@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2e5cb8bc-f2ca-3be3-f6f5-f3801f87841e@suse.com>
Date: Tue, 19 Jun 2018 08:34:07 +0300
MIME-Version: 1.0
In-Reply-To: <ca369d20-3a41-165d-9ae9-5000aea31a1b@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.06.2018 05:18, Su Yue wrote:
> 
> 
> On 06/18/2018 07:10 PM, Nikolay Borisov wrote:
>> check_chunks_and_extents does quite a number of distinct things. The
>> first of those is going through all root items in the root tree and
>> classify every root depending on whether they have a dropping operation
>> in progress or not. Lets factor out this code and move the variables
>> specific to this in a separate function so clean up
>> check_chunks_and_extents
>> a bit. Accidentally, this patch fixes some reference leaks since
>> in error conditions in the loop the code does "goto out" but at that
>> label we don't really release the path. Having this code extracted in a
>> separate function which always releases the path avoids this problem
>> entirely.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Code looks okay. One nitpick belows.
> 
>> ---
>>   check/main.c | 141
>> +++++++++++++++++++++++++++++++++++------------------------
>>   1 file changed, 85 insertions(+), 56 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index a4d6855dccbf..fb5c86df21c9 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -8069,6 +8069,89 @@ static int deal_root_from_list(struct list_head
>> *list,
>>       return ret;
>>   }
>>   +/**
>> + * parse_tree_roots - Go over all roots in the tree root and add each
>> one to
>> + *              a list.
>> + *
>> + * @fs_info        - pointer to fs_info struct of the file system.
>> + *
>> + * @normal_trees   - list to contains all roots which don't have a drop
>> + *             operation in progress
>> + *
>> + * @dropping_trees - list containing all roots which have a drop
>> operation
>> + *             pending
>> + *
>> + * Returns 0 on success or a negative value indicating an error.
>> + *
>> + */
>> +static int parse_tree_roots(struct btrfs_fs_info *fs_info,
>> +               struct list_head *normal_trees,
>> +               struct list_head *dropping_trees)
>> +{
>> +    struct btrfs_path path;
>> +    struct btrfs_key key;
>> +    struct btrfs_key found_key;
>> +    struct btrfs_root_item ri;
>> +    struct extent_buffer *leaf;
>> +    int slot;
>> +    int ret = 0;
>> +
>> +    btrfs_init_path(&path);
>> +    key.offset = 0;
>> +    key.objectid = 0;
>> +    key.type = BTRFS_ROOT_ITEM_KEY;
>> +    ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0,
>> 0);
>> +    if (ret < 0)
>> +        goto out;
>> +    while (1) {
>> +        leaf = path.nodes[0];
>> +        slot = path.slots[0];
>> +        if (slot >= btrfs_header_nritems(path.nodes[0])) {
>> +            ret = btrfs_next_leaf(fs_info->tree_root, &path);
>> +            if (ret != 0)
>> +                break;
>> +            leaf = path.nodes[0];
>> +            slot = path.slots[0];
>> +        }
> 
> Nit:
> I know the segment is just moved. The @slot is unused.

It's used in the if (slot >= btrfs_header_nritems(path.nodes[0])) check.
I guess the definition could be moved inside the while to reduce the
scope but it's a minor thing.

>> +        btrfs_item_key_to_cpu(leaf, &found_key, path.slots[0]);
>> +        if (found_key.type == BTRFS_ROOT_ITEM_KEY) {
>> +            unsigned long offset;
>> +            u64 last_snapshot;
>> +            u8 level;
>> +
>> +            offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
>> +            read_extent_buffer(leaf, &ri, offset, sizeof(ri));
>> +            last_snapshot = btrfs_root_last_snapshot(&ri);
>> +            level = btrfs_root_level(&ri);
>> +            if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
>> +                ret = add_root_item_to_list(normal_trees,
>> +                        found_key.objectid,
>> +                        btrfs_root_bytenr(&ri),
>> +                        last_snapshot, level,
>> +                        0, NULL);
>> +                if (ret < 0)
>> +                    break;
>> +            } else {
>> +                u64 objectid = found_key.objectid;
>> +                btrfs_disk_key_to_cpu(&found_key,
>> +                              &ri.drop_progress);
>> +                ret = add_root_item_to_list(dropping_trees,
>> +                        objectid,
>> +                        btrfs_root_bytenr(&ri),
>> +                        last_snapshot, level,
>> +                        ri.drop_level, &found_key);
>> +                if (ret < 0)
>> +                    break;
>> +            }
>> +        }
>> +        path.slots[0]++;
>> +    }
>> +
>> +out:
>> +    btrfs_release_path(&path);
>> +    return ret;
>> +}
>> +
>>   static int check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>>   {
>>       struct rb_root dev_cache;
>> @@ -8082,20 +8165,13 @@ static int check_chunks_and_extents(struct
>> btrfs_fs_info *fs_info)
>>       struct cache_tree nodes;
>>       struct extent_io_tree excluded_extents;
>>       struct cache_tree corrupt_blocks;
>> -    struct btrfs_path path;
>> -    struct btrfs_key key;
>> -    struct btrfs_key found_key;
>>       int ret, err = 0;
>>       struct block_info *bits;
>>       int bits_nr;
>> -    struct extent_buffer *leaf;
>> -    int slot;
>> -    struct btrfs_root_item ri;
>>       struct list_head dropping_trees;
>>       struct list_head normal_trees;
>>       struct btrfs_root *root1;
>>       struct btrfs_root *root;
>> -    u64 objectid;
>>       u8 level;
>>         root = fs_info->fs_root;
>> @@ -8146,57 +8222,10 @@ static int check_chunks_and_extents(struct
>> btrfs_fs_info *fs_info)
>>                       root1->node->start, 0, level, 0, NULL);
>>       if (ret < 0)
>>           goto out;
>> -    btrfs_init_path(&path);
>> -    key.offset = 0;
>> -    key.objectid = 0;
>> -    key.type = BTRFS_ROOT_ITEM_KEY;
>> -    ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0,
>> 0);
>> +
>> +    ret = parse_tree_roots(fs_info, &normal_trees, &dropping_trees);
>>       if (ret < 0)
>>           goto out;
>> -    while (1) {
>> -        leaf = path.nodes[0];
>> -        slot = path.slots[0];
>> -        if (slot >= btrfs_header_nritems(path.nodes[0])) {
>> -            ret = btrfs_next_leaf(fs_info->tree_root, &path);
>> -            if (ret != 0)
>> -                break;
>> -            leaf = path.nodes[0];
>> -            slot = path.slots[0];
>> -        }
>> -        btrfs_item_key_to_cpu(leaf, &found_key, path.slots[0]);
>> -        if (found_key.type == BTRFS_ROOT_ITEM_KEY) {
>> -            unsigned long offset;
>> -            u64 last_snapshot;
>> -
>> -            offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
>> -            read_extent_buffer(leaf, &ri, offset, sizeof(ri));
>> -            last_snapshot = btrfs_root_last_snapshot(&ri);
>> -            if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
>> -                level = btrfs_root_level(&ri);
>> -                ret = add_root_item_to_list(&normal_trees,
>> -                        found_key.objectid,
>> -                        btrfs_root_bytenr(&ri),
>> -                        last_snapshot, level,
>> -                        0, NULL);
>> -                if (ret < 0)
>> -                    goto out;
>> -            } else {
>> -                level = btrfs_root_level(&ri);
>> -                objectid = found_key.objectid;
>> -                btrfs_disk_key_to_cpu(&found_key,
>> -                              &ri.drop_progress);
>> -                ret = add_root_item_to_list(&dropping_trees,
>> -                        objectid,
>> -                        btrfs_root_bytenr(&ri),
>> -                        last_snapshot, level,
>> -                        ri.drop_level, &found_key);
>> -                if (ret < 0)
>> -                    goto out;
>> -            }
>> -        }
>> -        path.slots[0]++;
>> -    }
>> -    btrfs_release_path(&path);
>>         /*
>>        * check_block can return -EAGAIN if it fixes something, please
>> keep
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
