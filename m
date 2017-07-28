Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751138AbdG1F7T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 01:59:19 -0400
Subject: Re: [PATCH 2/2] btrfs: Simplify btrfs_alloc_dev_extent
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1501176997-24059-1-git-send-email-nborisov@suse.com>
 <1501176997-24059-2-git-send-email-nborisov@suse.com>
 <CAL3q7H7Em8aqkCqvvJP3zkOCFjJy1=19qdz+v79tnJ3qHt+6fw@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0817db46-3069-ad0c-778c-78f8253771d8@suse.com>
Date: Fri, 28 Jul 2017 08:59:12 +0300
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7Em8aqkCqvvJP3zkOCFjJy1=19qdz+v79tnJ3qHt+6fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.07.2017 20:57, Filipe Manana wrote:
> On Thu, Jul 27, 2017 at 6:36 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>> Currently btrfs_alloc_dev_extent essentially open codes btrfs_insert_item. So
>> let's remove the superfluous code, leaving only the important bits, namely
>> initialising the device extent and just calling btrfs_insert_item. So first add
>> definition for the stack-based set/get function. And then use them.
>> Additionally, remove the code which sets the uuid of the block header, since
>> this is something which is already handled by the core btree code.
> 
> Quite honestly, I don't see the value of this change at all.
> It doesn't make things simpler nor more readable nor nothing.
> We have many, really many places using btrfs_insert_empty_item()
> instead of calling btrfs_insert_item(), are you planning on sending a
> patch to do the replacement for each of them? What's the point?

I beg you to differ. Some of the code in btrfs is a mess, it's working
but it's messy. There is constant violation of abstractions (as is the
case in this function, heck the uuid setting of the block header
function doesn't even belong here). All of this hampers reading
comprehension of the code for newcomers. You are experienced in the code
and likely this doesn't apply to you but since I'm someone relatively
new to the code this has been my experience. And I believe any effort to
actually simplify the code, make it more coherent and succinct is a win
long-term.

I will wait for other feedback, if people feel patches like that are
just bikeshedding then I will refrain from such cleanups in the future.

> 
> Plus you are introducing now a memory leak. See below.

Will fix it.

> 
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/ctree.h   |  8 ++++++++
>>  fs/btrfs/volumes.c | 34 ++++++++++++----------------------
>>  2 files changed, 20 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index cd9497bcdb1e..567fbf186257 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1740,6 +1740,14 @@ BTRFS_SETGET_FUNCS(dev_extent_chunk_objectid, struct btrfs_dev_extent,
>>  BTRFS_SETGET_FUNCS(dev_extent_chunk_offset, struct btrfs_dev_extent,
>>                    chunk_offset, 64);
>>  BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
>> +BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_tree, struct btrfs_dev_extent,
>> +                        chunk_tree, 64);
>> +BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_objectid,
>> +                        struct btrfs_dev_extent, chunk_objectid, 64);
>> +BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_offset, struct btrfs_dev_extent,
>> +                        chunk_offset, 64);
>> +BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_length, struct btrfs_dev_extent,
>> +                        length, 64);
>>
>>  static inline unsigned long btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
>>  {
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 5a1913956f20..94e98261dbd0 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1581,42 +1581,32 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>                                   u64 chunk_offset, u64 start, u64 num_bytes)
>>  {
>>         int ret;
>> -       struct btrfs_path *path;
>> -       struct btrfs_fs_info *fs_info = device->fs_info;
>> -       struct btrfs_root *root = fs_info->dev_root;
>> +       struct btrfs_root *root = device->fs_info->dev_root;
>>         struct btrfs_dev_extent *extent;
>> -       struct extent_buffer *leaf;
>>         struct btrfs_key key;
>>
>>         WARN_ON(!device->in_fs_metadata);
>>         WARN_ON(device->is_tgtdev_for_dev_replace);
>> -       path = btrfs_alloc_path();
>> -       if (!path)
>> +
>> +       extent = kzalloc(sizeof(*extent), GFP_NOFS);
>> +       if (!extent)
>>                 return -ENOMEM;
>>
>>         key.objectid = device->devid;
>>         key.offset = start;
>>         key.type = BTRFS_DEV_EXTENT_KEY;
>> -       ret = btrfs_insert_empty_item(trans, root, path, &key,
>> -                                     sizeof(*extent));
>> -       if (ret)
>> -               goto out;
>>
>> -       leaf = path->nodes[0];
>> -       extent = btrfs_item_ptr(leaf, path->slots[0],
>> -                               struct btrfs_dev_extent);
>> -       btrfs_set_dev_extent_chunk_tree(leaf, extent,
>> -                                       BTRFS_CHUNK_TREE_OBJECTID);
>> -       btrfs_set_dev_extent_chunk_objectid(leaf, extent,
>> +       btrfs_set_stack_dev_extent_chunk_tree(extent,
>> +                                             BTRFS_CHUNK_TREE_OBJECTID);
>> +       btrfs_set_stack_dev_extent_chunk_objectid(extent,
>>                                             BTRFS_FIRST_CHUNK_TREE_OBJECTID);
>> -       btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
>> +       btrfs_set_stack_dev_extent_chunk_offset(extent, chunk_offset);
>> +       btrfs_set_stack_dev_extent_length(extent, num_bytes);
>>
>> -       write_extent_buffer_chunk_tree_uuid(leaf, fs_info->chunk_tree_uuid);
>> +       ret = btrfs_insert_item(trans, root, &key, extent, sizeof(*extent));
>> +       if (ret)
>> +               kfree(extent);
> 
> Even if ret is 0 (success), you need to kfree(extent).
> 
> thanks
> 
>>
>> -       btrfs_set_dev_extent_length(leaf, extent, num_bytes);
>> -       btrfs_mark_buffer_dirty(leaf);
>> -out:
>> -       btrfs_free_path(path);
>>         return ret;
>>  }
>>
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
