Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34322 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbcDVI2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 04:28:25 -0400
Received: by mail-yw0-f175.google.com with SMTP id j74so101470718ywg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 01:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151229201907.rzbaxqiyjfwpqxwp@ret.masoncoding.com>
References: <cover.1443583874.git.osandov@osandov.com>
	<3319d371e22491b6901af33842b57db37b77c52c.1443583874.git.osandov@osandov.com>
	<20151229201907.rzbaxqiyjfwpqxwp@ret.masoncoding.com>
Date: Fri, 22 Apr 2016 11:28:24 +0300
Message-ID: <CAOcd+r2wCqcfbub6AKoDwyPB4XS7MDUuqeJOziw-g8vn+mM+gw@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] Btrfs: implement the free space B-tree
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Omar, Chris,

I have reviewed the free-space-tree code. It is a very nice feature.

However, I have a basic understanding question.

Let's say we are running a delayed ref which inserts a new EXTENT_ITEM
into the extent tree, e.g., we are in alloc_reserved_file_extent. At
this point we call remove_from_free_space_tree(), which updates the
free-space-tree about the allocated space. But this requires to COW
the free-space-tree itself. So we allocate a new tree block for the
free-space tree, and insert a new delayed ref, which will update the
extent tree about the new tree block allocation. We also insert a
delayed ref to free the previous copy of the free-space-tree block.

At some point we run these new delayed refs, so we insert/remove
EXTENT_ITEMs from the extent tree, and this in turn requires us to
update the free-space-tree again. So we need again to COW
free-space-tree blocks, generating more delayed refs.

At which point this recursion stops?

Do we assume that at some point all needed free-space tree blocks have
been COW'ed already, and we do not COW a tree block more than once per
transaction (unless it was written to disk due to memory pressure)?

Thanks!
Alex.


On Tue, Dec 29, 2015 at 11:19 PM, Chris Mason <clm@fb.com> wrote:
> On Tue, Sep 29, 2015 at 08:50:35PM -0700, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> The free space cache has turned out to be a scalability bottleneck on
>> large, busy filesystems. When the cache for a lot of block groups needs
>> to be written out, we can get extremely long commit times; if this
>> happens in the critical section, things are especially bad because we
>> block new transactions from happening.
>>
>> The main problem with the free space cache is that it has to be written
>> out in its entirety and is managed in an ad hoc fashion. Using a B-tree
>> to store free space fixes this: updates can be done as needed and we get
>> all of the benefits of using a B-tree: checksumming, RAID handling,
>> well-understood behavior.
>>
>> With the free space tree, we get commit times that are about the same as
>> the no cache case with load times slower than the free space cache case
>> but still much faster than the no cache case. Free space is represented
>> with extents until it becomes more space-efficient to use bitmaps,
>> giving us similar space overhead to the free space cache.
>>
>> The operations on the free space tree are: adding and removing free
>> space, handling the creation and deletion of block groups, and loading
>> the free space for a block group. We can also create the free space tree
>> by walking the extent tree and clear the free space tree.
>>
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>
>> +int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
>> +{
>> +     struct btrfs_trans_handle *trans;
>> +     struct btrfs_root *tree_root = fs_info->tree_root;
>> +     struct btrfs_root *free_space_root;
>> +     struct btrfs_block_group_cache *block_group;
>> +     struct rb_node *node;
>> +     int ret;
>> +
>> +     trans = btrfs_start_transaction(tree_root, 0);
>> +     if (IS_ERR(trans))
>> +             return PTR_ERR(trans);
>> +
>> +     free_space_root = btrfs_create_tree(trans, fs_info,
>> +                                         BTRFS_FREE_SPACE_TREE_OBJECTID);
>> +     if (IS_ERR(free_space_root)) {
>> +             ret = PTR_ERR(free_space_root);
>> +             goto abort;
>> +     }
>> +     fs_info->free_space_root = free_space_root;
>> +
>> +     node = rb_first(&fs_info->block_group_cache_tree);
>> +     while (node) {
>> +             block_group = rb_entry(node, struct btrfs_block_group_cache,
>> +                                    cache_node);
>> +             ret = populate_free_space_tree(trans, fs_info, block_group);
>> +             if (ret)
>> +                     goto abort;
>> +             node = rb_next(node);
>> +     }
>> +
>> +     btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
>> +
>> +     ret = btrfs_commit_transaction(trans, tree_root);
>> +     if (ret)
>> +             return ret;
>> +
>> +     return 0;
>> +
>> +abort:
>> +     btrfs_abort_transaction(trans, tree_root, ret);
>> +     btrfs_end_transaction(trans, tree_root);
>> +     return ret;
>> +}
>> +
>
> Hi Omar,
>
> The only problem I've hit testing this stuff is where we create the tree
> on existing filesystems.  There are a few different problems here:
>
> 1) The populate code happens after resuming balance operations.  The
> balancing code could be changing these block groups while we scan them.
> I fixed this by moving the scan up earlier.
>
> 2) Delayed references may be run, which will also change the extent tree
> as we're scanning it.
>
> 3) We might need to commit the transaction to reclaim space.
>
> For now I'm ignoring #3 and adding a flag in fs_info that will make us
> skip delayed references.  This really isn't a good long term solution,
> we need to be able to do this on a per block group basis and make
> forward progress without pinning the delayed refs in ram.
>
> But for now, it'll do to get this into the tree for more testing.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
