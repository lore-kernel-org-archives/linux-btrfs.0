Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbeCOJoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 05:44:07 -0400
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com [209.85.213.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232D121742
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 09:44:07 +0000 (UTC)
Received: by mail-vk0-f46.google.com with SMTP id x5so2566118vkd.7
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 02:44:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22e962f5-86d8-05bd-f215-df4d95c74406@suse.com>
References: <20180313184700.30173-1-fdmanana@kernel.org> <20180313224817.3418-1-fdmanana@kernel.org>
 <22e962f5-86d8-05bd-f215-df4d95c74406@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 15 Mar 2018 09:44:05 +0000
Message-ID: <CAL3q7H7WmAgJekDro4t7nUU_9wn-rNVYPx0NBkED+Ldo79PvXg@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 9:04 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 14.03.2018 00:48, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Under some cases the filesystem checker reports an error when it finds
>> checksum items for an extent that is referenced by an inode as a prealloc
>> extent. Such cases are not an error when the extent is actually shared
>> (was cloned/reflinked) with other inodes and was written through one of
>> those other inodes.
>>
>> Example:
>>
>>   $ mkfs.btrfs -f /dev/sdb
>>   $ mount /dev/sdb /mnt
>>
>>   $ touch /mnt/foo
>>   $ xfs_io -c "falloc 0 256K" /mnt/foo
>>   $ sync
>>
>>   $ xfs_io -c "pwrite -S 0xab 0 256K" /mnt/foo
>>   $ touch /mnt/bar
>>   $ xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
>>   $ xfs_io -c "fsync" /mnt/bar
>>
>>   <power fail>
>>   $ mount /dev/sdb /mnt
>>   $ umount /mnt
>>
>>   $ btrfs check /dev/sdc
>>   Checking filesystem on /dev/sdb
>>   UUID: 52d3006e-ee3b-40eb-aa21-e56253a03d39
>>   checking extents
>>   checking free space cache
>>   checking fs roots
>>   root 5 inode 257 errors 800, odd csum item
>>   ERROR: errors found in fs roots
>>   found 688128 bytes used, error(s) found
>>   total csum bytes: 256
>>   total tree bytes: 163840
>>   total fs tree bytes: 65536
>>   total extent tree bytes: 16384
>>   btree space waste bytes: 138819
>>   file data blocks allocated: 10747904
>>    referenced 10747904
>>   $ echo $?
>>   1
>>
>> So teach check to not report such cases as errors by checking if the
>> extent is shared with other inodes and if so, consider it an error the
>> existence of checksum items only if all those other inodes are referencing
>> the extent as a prealloc extent.
>> This case can be hit often when running the generic/475 testcase from
>> fstests.
>>
>> A test case will follow in a separate patch.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>
>> V2: Made stuff work with lowmem mode as well.
>>     Added a comment about the limitations of the current check.
>>     Removed filtering by inode number since it was unreliable as we can
>>     have different inodes with same inode number but in different roots
>>     (so opted to drop the filtering instead of filtering by root as well,
>>     to keep it simpler).
>>
>>  check/main.c        |  11 ++-
>>  check/mode-common.c | 258 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  check/mode-common.h |   3 +
>>  check/mode-lowmem.c |  14 ++-
>>  4 files changed, 281 insertions(+), 5 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 392195ca..88e6c1e9 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -1515,8 +1515,15 @@ static int process_file_extent(struct btrfs_root *root,
>>                       if (found < num_bytes)
>>                               rec->some_csum_missing = 1;
>>               } else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
>> -                     if (found > 0)
>> -                             rec->errors |= I_ERR_ODD_CSUM_ITEM;
>> +                     if (found > 0) {
>> +                             ret = check_prealloc_extent_written(root->fs_info,
>> +                                                                 disk_bytenr,
>> +                                                                 num_bytes);
>> +                             if (ret < 0)
>> +                                     return ret;
>> +                             if (ret == 0)
>> +                                     rec->errors |= I_ERR_ODD_CSUM_ITEM;
>> +                     }
>>               }
>>       }
>>       return 0;
>> diff --git a/check/mode-common.c b/check/mode-common.c
>> index 1b56a968..559cd11d 100644
>> --- a/check/mode-common.c
>> +++ b/check/mode-common.c
>> @@ -24,6 +24,264 @@
>>  #include "check/mode-common.h"
>>
>>  /*
>> + * Check if the inode referenced by the given data reference uses the extent
>> + * at disk_bytenr as a non-prealloc extent.
>> + *
>> + * Returns 1 if true, 0 if false and < 0 on error.
>> + */
>> +static int check_prealloc_data_ref(struct btrfs_fs_info *fs_info,
>> +                                u64 disk_bytenr,
>> +                                struct btrfs_extent_data_ref *dref,
>> +                                struct extent_buffer *eb)
>> +{
>> +     u64 rootid = btrfs_extent_data_ref_root(eb, dref);
>> +     u64 objectid = btrfs_extent_data_ref_objectid(eb, dref);
>> +     u64 offset = btrfs_extent_data_ref_offset(eb, dref);
>> +     struct btrfs_root *root;
>> +     struct btrfs_key key;
>> +     struct btrfs_path path;
>> +     int ret;
>> +
>> +     btrfs_init_path(&path);
>> +     key.objectid = rootid;
>> +     key.type = BTRFS_ROOT_ITEM_KEY;
>> +     key.offset = (u64)-1;
>> +     root = btrfs_read_fs_root(fs_info, &key);
>> +     if (IS_ERR(root)) {
>> +             ret = PTR_ERR(root);
>> +             goto out;
>> +     }
>> +
>> +     key.objectid = objectid;
>> +     key.type = BTRFS_EXTENT_DATA_KEY;
>> +     key.offset = offset;
>> +     ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>> +     if (ret > 0) {
>> +             fprintf(stderr,
>> +                     "Missing file extent item for inode %llu, root %llu, offset %llu",
>> +                     objectid, rootid, offset);
>> +             ret = -ENOENT;
>> +     }
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     while (true) {
>> +             struct btrfs_file_extent_item *fi;
>> +             int extent_type;
>> +
>> +             if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
>> +                     ret = btrfs_next_leaf(fs_info->extent_root, &path);
>
> Shouldn't you use the read fs root rather than extent root in
> btrfs_next_leaf?

It should, copy paste error.
thanks

>
>> +                     if (ret < 0)
>> +                             goto out;
>> +                     if (ret > 0)
>> +                             break;
>> +             }
>> +
>> +             btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
>> +             if (key.objectid != objectid ||
>> +                 key.type != BTRFS_EXTENT_DATA_KEY)
>> +                     break;
>> +
>> +             fi = btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +                                 struct btrfs_file_extent_item);
>> +             extent_type = btrfs_file_extent_type(path.nodes[0], fi);
>> +             if (extent_type != BTRFS_FILE_EXTENT_REG &&
>> +                 extent_type != BTRFS_FILE_EXTENT_PREALLOC)
>> +                     goto next;
>> +
>> +             if (btrfs_file_extent_disk_bytenr(path.nodes[0], fi) !=
>> +                 disk_bytenr)
>> +                     break;
>> +
>> +             if (extent_type == BTRFS_FILE_EXTENT_REG) {
>> +                     ret = 1;
>> +                     goto out;
>> +             }
>> +next:
>> +             path.slots[0]++;
>> +     }
>> +     ret = 0;
>> + out:
>> +     btrfs_release_path(&path);
>> +     return ret;
>> +}
>> +
>> +/*
>> + * Check if a shared data reference points to a node that has a file extent item
>> + * pointing to the extent at @disk_bytenr that is not of type prealloc.
>> + *
>> + * Returns 1 if true, 0 if false and < 0 on error.
>> + */
>> +static int check_prealloc_shared_data_ref(struct btrfs_fs_info *fs_info,
>> +                                       u64 parent,
>> +                                       u64 disk_bytenr)
>> +{
>> +     struct extent_buffer *eb;
>> +     u32 nr;
>> +     int i;
>> +     int ret = 0;
>> +
>> +     eb = read_tree_block(fs_info, parent, 0);
>> +     if (!extent_buffer_uptodate(eb)) {
>> +             ret = -EIO;
>> +             goto out;
>> +     }
>> +
>> +     nr = btrfs_header_nritems(eb);
>> +     for (i = 0; i < nr; i++) {
>> +             struct btrfs_key key;
>> +             struct btrfs_file_extent_item *fi;
>> +             int extent_type;
>> +
>> +             btrfs_item_key_to_cpu(eb, &key, i);
>> +             if (key.type != BTRFS_EXTENT_DATA_KEY)
>> +                     continue;
>> +
>> +             fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
>> +             extent_type = btrfs_file_extent_type(eb, fi);
>> +             if (extent_type != BTRFS_FILE_EXTENT_REG &&
>> +                 extent_type != BTRFS_FILE_EXTENT_PREALLOC)
>> +                     continue;
>> +
>> +             if (btrfs_file_extent_disk_bytenr(eb, fi) == disk_bytenr &&
>> +                 extent_type == BTRFS_FILE_EXTENT_REG) {
>> +                     ret = 1;
>> +                     break;
>> +             }
>> +     }
>> + out:
>> +     free_extent_buffer(eb);
>> +     return ret;
>> +}
>> +
>> +/*
>> + * Check if a prealloc extent is shared by multiple inodes and if any inode has
>> + * already written to that extent. This is to avoid emitting invalid warnings
>> + * about odd csum items (a inode has an extent entirely marked as prealloc
>> + * but another inode shares it and has already written to it).
>> + *
>> + * Note: right now it does not check if the number of checksum items in the
>> + * csum tree matches the number of bytes written into the ex-prealloc extent.
>> + * It's complex to deal with that because the prealloc extent might have been
>> + * partially written through multiple inodes and we would have to keep track of
>> + * ranges, merging them and notice ranges that fully or partially overlap, to
>> + * avoid false reports of csum items missing for areas of the prealloc extent
>> + * that were not written to - for example if we have a 1M prealloc extent, we
>> + * can have only the first half of it written, but 2 different inodes refer to
>> + * the its first half (through reflinks/cloning), so keeping a counter of bytes
>> + * covered by checksum items is not enough, as the correct value would be 512K
>> + * and not 1M (whence the need to track ranges).
>> + *
>> + * Returns 0 if the prealloc extent was not written yet by any inode, 1 if
>> + * at least one other inode has written to it, and < 0 on error.
>> + */
>> +int check_prealloc_extent_written(struct btrfs_fs_info *fs_info,
>> +                               u64 disk_bytenr,
>> +                               u64 num_bytes)
>> +{
>> +     struct btrfs_path path;
>> +     struct btrfs_key key;
>> +     int ret;
>> +     struct btrfs_extent_item *ei;
>> +     u32 item_size;
>> +     unsigned long ptr;
>> +     unsigned long end;
>> +
>> +     key.objectid = disk_bytenr;
>> +     key.type = BTRFS_EXTENT_ITEM_KEY;
>> +     key.offset = num_bytes;
>> +
>> +     btrfs_init_path(&path);
>> +     ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, &path, 0, 0);
>> +     if (ret > 0) {
>> +             fprintf(stderr,
>> +                     "Missing extent item in extent tree for disk_bytenr %llu, num_bytes %llu\n",
>> +                     disk_bytenr, num_bytes);
>> +             ret = -ENOENT;
>> +     }
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     /* First check all inline refs. */
>> +     ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +                         struct btrfs_extent_item);
>> +     item_size = btrfs_item_size_nr(path.nodes[0], path.slots[0]);
>> +     ptr = (unsigned long)(ei + 1);
>> +     end = (unsigned long)ei + item_size;
>> +     while (ptr < end) {
>> +             struct btrfs_extent_inline_ref *iref;
>> +             int type;
>> +
>> +             iref = (struct btrfs_extent_inline_ref *)ptr;
>> +             type = btrfs_extent_inline_ref_type(path.nodes[0], iref);
>> +             ASSERT(type == BTRFS_EXTENT_DATA_REF_KEY ||
>> +                    type == BTRFS_SHARED_DATA_REF_KEY);
>> +
>> +             if (type == BTRFS_EXTENT_DATA_REF_KEY) {
>> +                     struct btrfs_extent_data_ref *dref;
>> +
>> +                     dref = (struct btrfs_extent_data_ref *)(&iref->offset);
>> +                     ret = check_prealloc_data_ref(fs_info, disk_bytenr,
>> +                                                   dref, path.nodes[0]);
>> +                     if (ret != 0)
>> +                             goto out;
>> +             } else if (type == BTRFS_SHARED_DATA_REF_KEY) {
>> +                     u64 parent;
>> +
>> +                     parent = btrfs_extent_inline_ref_offset(path.nodes[0],
>> +                                                             iref);
>> +                     ret = check_prealloc_shared_data_ref(fs_info,
>> +                                                          parent,
>> +                                                          disk_bytenr);
>> +                     if (ret != 0)
>> +                             goto out;
>> +             }
>> +
>> +             ptr += btrfs_extent_inline_ref_size(type);
>> +     }
>> +
>> +     /* Now check if there are any non-inlined refs. */
>> +     path.slots[0]++;
>> +     while (true) {
>> +             if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
>> +                     ret = btrfs_next_leaf(fs_info->extent_root, &path);
>> +                     if (ret < 0)
>> +                             goto out;
>> +                     if (ret > 0) {
>> +                             ret = 0;
>> +                             break;
>> +                     }
>> +             }
>> +
>> +             btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
>> +             if (key.objectid != disk_bytenr)
>> +                     break;
>> +
>> +             if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
>> +                     struct btrfs_extent_data_ref *dref;
>> +
>> +                     dref = btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +                                           struct btrfs_extent_data_ref);
>> +                     ret = check_prealloc_data_ref(fs_info, disk_bytenr,
>> +                                                   dref, path.nodes[0]);
>> +                     if (ret != 0)
>> +                             goto out;
>> +             } else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
>> +                     ret = check_prealloc_shared_data_ref(fs_info,
>> +                                                          key.offset,
>> +                                                          disk_bytenr);
>> +                     if (ret != 0)
>> +                             goto out;
>> +             }
>> +
>> +             path.slots[0]++;
>> +     }
>> +out:
>> +     btrfs_release_path(&path);
>> +     return ret;
>> +}
>> +
>> +/*
>>   * Search in csum tree to find how many bytes of range [@start, @start + @len)
>>   * has the corresponding csum item.
>>   *
>> diff --git a/check/mode-common.h b/check/mode-common.h
>> index ffae782b..79e1b0cf 100644
>> --- a/check/mode-common.h
>> +++ b/check/mode-common.h
>> @@ -80,6 +80,9 @@ static inline int fs_root_objectid(u64 objectid)
>>       return is_fstree(objectid);
>>  }
>>
>> +int check_prealloc_extent_written(struct btrfs_fs_info *fs_info,
>> +                               u64 disk_bytenr,
>> +                               u64 num_bytes);
>>  int count_csum_range(struct btrfs_fs_info *fs_info, u64 start,
>>                    u64 len, u64 *found);
>>  int insert_inode_item(struct btrfs_trans_handle *trans,
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 2424cdc2..02806377 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -1511,9 +1511,17 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>>                     csum_found, search_len);
>>       } else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
>>                  csum_found > 0) {
>> -             err |= ODD_CSUM_ITEM;
>> -             error("root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have csum, but has: %llu",
>> -                   root->objectid, fkey->objectid, fkey->offset, csum_found);
>> +             ret = check_prealloc_extent_written(root->fs_info,
>> +                                                 disk_bytenr,
>> +                                                 disk_num_bytes);
>> +             if (ret < 0)
>> +                     return ret;
>> +             if (ret == 0) {
>> +                     err |= ODD_CSUM_ITEM;
>> +                     error("root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have csum, but has: %llu",
>> +                           root->objectid, fkey->objectid, fkey->offset,
>> +                           csum_found);
>> +             }
>>       }
>>
>>       /* Check EXTENT_DATA hole */
>>
