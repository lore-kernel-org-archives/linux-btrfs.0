Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbeCGL17 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 06:27:59 -0500
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>
Date: Wed, 7 Mar 2018 13:27:55 +0200
MIME-Version: 1.0
In-Reply-To: <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
 <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>



On  7.03.2018 13:18, Qu Wenruo wrote:
> 
> 
> On 2018年03月07日 19:01, robbieko wrote:
>> Qu Wenruo 於 2018-03-07 18:42 寫到:
>>> On 2018年03月07日 18:33, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018年03月07日 16:20, robbieko wrote:
>>>>> From: Robbie Ko <robbieko@synology.com>
>>>>>
>>>>> [BUG]
>>>>> Range clone can cause fiemap to return error result.
>>>>> Like:
>>>>>  # mount /dev/vdb5 /mnt/btrfs
>>>>>  # dd if=/dev/zero bs=16K count=2 oflag=dsync of=/mnt/btrfs/file
>>>>>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>>  /mnt/btrfs/file:
>>>>>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>>>    0: [0..63]:         4241424..4241487    64   0x1
>>>>>
>>>>>  # cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clone
>>>>>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>>  /mnt/btrfs/file:
>>>>>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>>>    0: [0..63]:         4241424..4241487    64   0x1
>>>>>  If we clone second file extent, we will get error FLAGS,
>>>>>  SHARED bit is not set.
>>>>>
>>>>> [REASON]
>>>>> Btrfs only checks if the first extent in extent map is shared,
>>>>> but extent may merge.
>>>>>
>>>>> [FIX]
>>>>> Here we will check each extent with extent map range,
>>>>> if one of them is shared, extent map is shared.
>>>>>
>>>>> [PATCH RESULT]
>>>>>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>>  /mnt/btrfs/file:
>>>>>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>>>    0: [0..63]:         4241424..4241487    64 0x2001
>>>>>
>>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>>> ---
>>>>>  fs/btrfs/extent_io.c | 146
>>>>> +++++++++++++++++++++++++++++++++++++++++++++------
>>>>>  1 file changed, 131 insertions(+), 15 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>>>> index 066b6df..5c6dca9 100644
>>>>> --- a/fs/btrfs/extent_io.c
>>>>> +++ b/fs/btrfs/extent_io.c
>>>>> @@ -4394,8 +4394,8 @@ static int emit_fiemap_extent(struct
>>>>> fiemap_extent_info *fieinfo,
>>>>>       */
>>>>>      if (cache->offset + cache->len  == offset &&
>>>>>          cache->phys + cache->len == phys  &&
>>>>> -        (cache->flags & ~FIEMAP_EXTENT_LAST) ==
>>>>> -            (flags & ~FIEMAP_EXTENT_LAST)) {
>>>>> +        (cache->flags & ~(FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_SHARED)) ==
>>>>> +            (flags & ~(FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_SHARED))) {
>>>>>          cache->len += len;
>>>>>          cache->flags |= flags;
>>>>>          goto try_submit_last;
>>>>> @@ -4450,6 +4450,134 @@ static int emit_last_fiemap_cache(struct
>>>>> btrfs_fs_info *fs_info,
>>>>>      return ret;
>>>>>  }
>>>>>
>>>>> +/*
>>>>> + * Helper to check the file range is shared.
>>>>> + *
>>>>> + * Fiemap extent will be combined with many extents, so we need to
>>>>> examine
>>>>> + * each extent, and if shared, the results are shared.
>>>>> + *
>>>>> + * Return: 0 if file range is not shared, 1 if it is shared, < 0 on
>>>>> error.
>>>>> + */
>>>>> +static int extent_map_check_shared(struct inode *inode, u64 start,
>>>>> u64 end)
>>>>> +{
>>>>> +    struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>>>> +    struct btrfs_root *root = BTRFS_I(inode)->root;
>>>>> +    int ret = 0;
>>>>> +    struct extent_buffer *leaf;
>>>>> +    struct btrfs_path *path;
>>>>> +    struct btrfs_file_extent_item *fi;
>>>>> +    struct btrfs_key found_key;
>>>>> +    int check_prev = 1;
>>>>> +    int extent_type;
>>>>> +    int shared = 0;
>>>>> +    u64 cur_offset;
>>>>> +    u64 extent_end;
>>>>> +    u64 ino = btrfs_ino(BTRFS_I(inode));
>>>>> +    u64 disk_bytenr;
>>>>> +
>>>>> +    path = btrfs_alloc_path();
>>>>> +    if (!path) {
>>>>> +        return -ENOMEM;
>>>>> +    }
>>>>> +
>>>>> +    cur_offset = start;
>>>>> +    while (1) {
>>>>> +        ret = btrfs_lookup_file_extent(NULL, root, path, ino,
>>>>> +                           cur_offset, 0);
>>>>> +        if (ret < 0)
>>>>> +            goto error;
>>>>> +        if (ret > 0 && path->slots[0] > 0 && check_prev) {
>>>>> +            leaf = path->nodes[0];
>>>>> +            btrfs_item_key_to_cpu(leaf, &found_key,
>>>>> +                          path->slots[0] - 1);
>>>>> +            if (found_key.objectid == ino &&
>>>>> +                found_key.type == BTRFS_EXTENT_DATA_KEY)
>>>>> +                path->slots[0]--;
>>>>> +        }
>>>>> +        check_prev = 0;
>>>>> +next_slot:
>>>>> +        leaf = path->nodes[0];
>>>>> +        if (path->slots[0] >= btrfs_header_nritems(leaf)) {
>>>>> +            ret = btrfs_next_leaf(root, path);
>>>>> +            if (ret < 0)
>>>>> +                goto error;
>>>>> +            if (ret > 0)
>>>>> +                break;
>>>>> +            leaf = path->nodes[0];
>>>>> +        }
>>>>> +
>>>>> +        disk_bytenr = 0;
>>>>> +        btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
>>>>> +
>>>>> +        if (found_key.objectid > ino)
>>>>> +            break;
>>>>> +        if (WARN_ON_ONCE(found_key.objectid < ino) ||
>>>>> +            found_key.type < BTRFS_EXTENT_DATA_KEY) {
>>>>> +            path->slots[0]++;
>>>>> +            goto next_slot;
>>>>> +        }
>>>>> +        if (found_key.type > BTRFS_EXTENT_DATA_KEY ||
>>>>> +            found_key.offset > end)
>>>>> +            break;
>>>>> +
>>>>> +        fi = btrfs_item_ptr(leaf, path->slots[0],
>>>>> +                    struct btrfs_file_extent_item);
>>>>> +        extent_type = btrfs_file_extent_type(leaf, fi);
>>>>> +
>>>>> +        if (extent_type == BTRFS_FILE_EXTENT_REG ||
>>>>> +            extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
>>>>> +            disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
>>>>> +            extent_end = found_key.offset +
>>>>> +                btrfs_file_extent_num_bytes(leaf, fi);
>>>>> +            if (extent_end <= start) {
>>>>> +                path->slots[0]++;
>>>>> +                goto next_slot;
>>>>> +            }
>>>>> +            if (disk_bytenr == 0) {
>>>>> +                path->slots[0]++;
>>>>> +                goto next_slot;
>>>>> +            }
>>>>> +
>>>>> +            btrfs_release_path(path);
>>>>> +
>>>>> +            /*
>>>>> +             * As btrfs supports shared space, this information
>>>>> +             * can be exported to userspace tools via
>>>>> +             * flag FIEMAP_EXTENT_SHARED.  If fi_extents_max == 0
>>>>> +             * then we're just getting a count and we can skip the
>>>>> +             * lookup stuff.
>>>>> +             */
>>>>> +            ret = btrfs_check_shared(root,
>>>>> +                         ino, disk_bytenr);
>>>>> +            if (ret < 0)
>>>>> +                goto error;
>>>>> +            if (ret)
>>>>> +                shared = 1;
>>>>> +            ret = 0;
>>>>> +            if (shared) {
>>>>> +                break;
>>>>> +            }
>>>>> +        } else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>>>>> +            extent_end = found_key.offset +
>>>>> +                btrfs_file_extent_inline_len(leaf,
>>>>> +                             path->slots[0], fi);
>>>>> +            extent_end = ALIGN(extent_end, fs_info->sectorsize);
>>>>> +            path->slots[0]++;
>>>>> +            goto next_slot;
>>>>> +        } else {
>>>>> +            BUG_ON(1);
>>>>> +        }
>>>>> +        cur_offset = extent_end;
>>>>> +        if (cur_offset > end)
>>>>> +            break;
>>>>> +    }
>>>>> +
>>>>> +    ret = 0;
>>>>> +error:
>>>>> +    btrfs_free_path(path);
>>>>> +    return !ret ? shared : ret;
>>>>> +}
>>>>> +
>>>>>  int extent_fiemap(struct inode *inode, struct fiemap_extent_info
>>>>> *fieinfo,
>>>>>          __u64 start, __u64 len, get_extent_t *get_extent)
>>>>>  {
>>>>> @@ -4587,19 +4715,7 @@ int extent_fiemap(struct inode *inode, struct
>>>>> fiemap_extent_info *fieinfo,
>>>>>              flags |= (FIEMAP_EXTENT_DELALLOC |
>>>>>                    FIEMAP_EXTENT_UNKNOWN);
>>>>>          } else if (fieinfo->fi_extents_max) {
>>>>> -            u64 bytenr = em->block_start -
>>>>> -                (em->start - em->orig_start);
>>>>> -
>>>>> -            /*
>>>>> -             * As btrfs supports shared space, this information
>>>>> -             * can be exported to userspace tools via
>>>>> -             * flag FIEMAP_EXTENT_SHARED.  If fi_extents_max == 0
>>>>> -             * then we're just getting a count and we can skip the
>>>>> -             * lookup stuff.
>>>>> -             */
>>>>> -            ret = btrfs_check_shared(root,
>>>>> -                         btrfs_ino(BTRFS_I(inode)),
>>>>> -                         bytenr);
>>>>
>>>> Since we're going to use the whole extent to determine the SHARED flags,
>>>> what about just passing the extent bytenr into btrfs_check_shared?
>>>>
>>>> In that case I think we could get correct shared flag without using
>>>> another helper function.
>>>> (IIRC it's em->block_start)
>>>
>>> Well, it's not em->block_start, but a little more complex.
>>> (For compressed one it's em->block_start, but for plaintext one, it's
>>> more complex)
>>>
>>> em->block_start = file_extent_disk_bytenr +
>>> file_extent_file_extent_offset
>>>
>>> We need extra calculation to determine the real extent bytenr
>>> (file_extent_disk_bytenr).
>>>
>>> IIRC the correct calculation would be:
>>> file_extent_disk_bytenr = em->block_start - em->start + em->orig_start.
>>>
>>> (Who thought out such anti-human calculation for extent map?!)
>>>
>>> Thanks,
>>> Qu
>>
>> dd if=/dev/zero bs=16K count=4 oflag=dsync of=file
>>
>> btrfs-debugfs -f file
>> (276 0): ram 16384 disk 2171609088 disk_size 16384
>> (276 16384): ram 16384 disk 2171625472 disk_size 16384
>> (276 32768): ram 16384 disk 2171641856 disk_size 16384
>> (276 49152): ram 16384 disk 2171658240 disk_size 16384
>> file: file extents 4 disk size 65536 logical size 65536 ratio 1.00
>>
>> xfs_io -c "fiemap -v" file
>> file:
>>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>    0: [0..127]:        4241424..4241551   128   0x1
>>
>> My point is that we have only one extent_map,
>> but in fact it can correspond to many extents
>> and each one has the potential to be cloned
>> so we need to examine each one individually.
> 
> Right, I missed this point.
> 
> SHARED flag is determined after extent map merge, so here we can't rely
> on em here.

Shouldn't extent maps correspond to 1:1 disk-state. I.e. they are just
the memory cache of the extent state. So if we merge them, shouldn't we
also merge the on-disk extents as well ?

> 
> So the current helper function looks valid, unless we have method to
> access the original extent map.
> 
> Thanks,
> Qu
> 
>>
>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> +            ret = extent_map_check_shared(inode, em->start,
>>>>> extent_map_end(em) - 1);
>>>>>              if (ret < 0)
>>>>>                  goto out_free;
>>>>>              if (ret)
>>>>> -- 
>>>>> 1.9.1
>>>>>
>>>>> -- 
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>
> 
