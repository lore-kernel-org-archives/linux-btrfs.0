From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: Re: [PATCH] fix uncheck memory allocations
Date: Tue, 15 Feb 2011 12:47:05 +0900
Message-ID: <AANLkTikU7g0AE7tZYj8JyQZHuwmNFVsZwaUojLM55wTv@mail.gmail.com>
References: <1297509433-15183-1-git-send-email-yoshinori.sano@gmail.com>
	<4D586FEE.9040501@jp.fujitsu.com>
	<AANLkTi=OxjdsLDjWWX-SX4paOvdJHC4Pi6JM_-at794E@mail.gmail.com>
	<4D59C578.7040809@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D59C578.7040809@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011年2月15日9:14 Tsutomu Itoh <t-itoh@jp.fujitsu.com>:
> Sano-san,
>
> (2011/02/14 22:57), Yoshinori Sano wrote:
>> 2011年2月14日8:57 Tsutomu Itoh <t-itoh@jp.fujitsu.com>:
>>> (2011/02/12 20:17), Yoshinori Sano wrote:
>>>> To make Btrfs code more robust, several return value checks where memory
>>>> allocation can fail are introduced.  I use BUG_ON where I don't know how
>>>> to handle the error properly, which increases the number of using the
>>>> notorious BUG_ON, though.
>>>>
>>>> Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
>>>> ---
>>>>  fs/btrfs/compression.c |    6 ++++++
>>>>  fs/btrfs/extent-tree.c |    2 ++
>>>>  fs/btrfs/file.c        |    8 ++++++--
>>>>  fs/btrfs/inode.c       |    5 +++++
>>>>  4 files changed, 19 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>>>> index 4d2110e..f596554 100644
>>>> --- a/fs/btrfs/compression.c
>>>> +++ b/fs/btrfs/compression.c
>>>> @@ -340,6 +340,8 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
>>>>
>>>>       WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
>>>>       cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
>>>> +     if (!cb)
>>>> +             return -ENOMEM;
>>>>       atomic_set(&cb->pending_bios, 0);
>>>>       cb->errors = 0;
>>>>       cb->inode = inode;
>>>> @@ -354,6 +356,10 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
>>>>       bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
>>>>
>>>>       bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
>>>> +     if (!bio) {
>>>> +             kfree(cb);
>>>> +             return -ENOMEM;
>>>> +     }
>>>>       bio->bi_private = cb;
>>>>       bio->bi_end_io = end_compressed_bio_write;
>>>>       atomic_inc(&cb->pending_bios);
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 565e22d..aed16f4 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -6931,6 +6931,8 @@ static noinline int get_new_locations(struct inode *reloc_inode,
>>>>                       struct disk_extent *old = exts;
>>>>                       max *= 2;
>>>>                       exts = kzalloc(sizeof(*exts) * max, GFP_NOFS);
>>>> +                     if (!exts)
>>>> +                             goto out;
>
> 'ret = -ENOMEM' is necessary before 'goto out'.

I'll keep in mind to fix this too.


>
>>>>                       memcpy(exts, old, sizeof(*exts) * nr);
>>>>                       if (old != *extents)
>>>>                               kfree(old);
>>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>>> index b0ff34b..4895ad2 100644
>>>> --- a/fs/btrfs/file.c
>>>> +++ b/fs/btrfs/file.c
>>>> @@ -181,10 +181,14 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
>>>>               testend = 0;
>>>>       }
>>>>       while (1) {
>>>> -             if (!split)
>>>> +             if (!split) {
>>>>                       split = alloc_extent_map(GFP_NOFS);
>>>> -             if (!split2)
>>>> +                     BUG_ON(!split || IS_ERR(split));
>>>
>>> alloc_extent_map() returns only the address or NULL.
>>> Therefore, I think that check by IS_ERR() is unnecessary.
>>>
>>> Regards,
>>> Itoh
>>
>> Exactly.  IS_ERR is not required.
>> I should read the alloc_extent_map' s implementation more deeply.
>> Thank you.
>
> Could you please merge my patch(http://marc.info/?l=linux-btrfs&m=129764438122741&w=2)
> with your patch, and post it again?

Yes, this is a good idea :)
I'll merge your patch and post it again later.
Thank you.


>
> Thanks,
> Itoh
>
>>
>>>
>>>> +             }
>>>> +             if (!split2) {
>>>>                       split2 = alloc_extent_map(GFP_NOFS);
>>>> +                     BUG_ON(!split2 || IS_ERR(split2));
>>>> +             }
>>>>
>>>>               write_lock(&em_tree->lock);
>>>>               em = lookup_extent_mapping(em_tree, start, len);
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index c9bc0af..40bbe00 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -287,6 +287,7 @@ static noinline int add_async_extent(struct async_cow *cow,
>>>>       struct async_extent *async_extent;
>>>>
>>>>       async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
>>>> +     BUG_ON(!async_extent);
>>>>       async_extent->start = start;
>>>>       async_extent->ram_size = ram_size;
>>>>       async_extent->compressed_size = compressed_size;
>>>> @@ -384,6 +385,7 @@ again:
>>>>            (BTRFS_I(inode)->force_compress))) {
>>>>               WARN_ON(pages);
>>>>               pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
>>>> +             BUG_ON(!pages);
>>>>
>>>>               if (BTRFS_I(inode)->force_compress)
>>>>                       compress_type = BTRFS_I(inode)->force_compress;
>>>> @@ -644,6 +646,7 @@ retry:
>>>>                                       async_extent->ram_size - 1, 0);
>>>>
>>>>               em = alloc_extent_map(GFP_NOFS);
>>>> +             BUG_ON(!em || IS_ERR(em));
>>>>               em->start = async_extent->start;
>>>>               em->len = async_extent->ram_size;
>>>>               em->orig_start = em->start;
>>>> @@ -820,6 +823,7 @@ static noinline int cow_file_range(struct inode *inode,
>>>>               BUG_ON(ret);
>>>>
>>>>               em = alloc_extent_map(GFP_NOFS);
>>>> +             BUG_ON(!em || IS_ERR(em));
>>>>               em->start = start;
>>>>               em->orig_start = em->start;
>>>>               ram_size = ins.offset;
>>>> @@ -1169,6 +1173,7 @@ out_check:
>>>>                       struct extent_map_tree *em_tree;
>>>>                       em_tree = &BTRFS_I(inode)->extent_tree;
>>>>                       em = alloc_extent_map(GFP_NOFS);
>>>> +                     BUG_ON(!em || IS_ERR(em));
>>>>                       em->start = cur_offset;
>>>>                       em->orig_start = em->start;
>>>>                       em->len = num_bytes;
>>>
>>>
>>
>
>

-- 
Yoshinori Sano <yoshinori.sano@gmail.com>
