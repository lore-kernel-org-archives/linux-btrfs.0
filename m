Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39713 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaLHOEE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 09:04:04 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1418046791.4845.5@mail.thefacebook.com>
References: <1417987953-31549-1-git-send-email-fdmanana@suse.com>
	<1418046791.4845.5@mail.thefacebook.com>
Date: Mon, 8 Dec 2014 14:04:02 +0000
Message-ID: <CAL3q7H4KK_3AZMWjGY7jspRh7tzcSXRc2r7W7_sToGVZMfujuQ@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix fs corruption on transaction abort if
 device supports discard
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 8, 2014 at 1:53 PM, Chris Mason <clm@fb.com> wrote:
> On Sun, Dec 7, 2014 at 4:31 PM, Filipe Manana <fdmanana@suse.com> wrote:
>>
>> When we abort a transaction we iterate over all the ranges marked as dirty
>> in fs_info->freed_extents[0] and fs_info->freed_extents[1], clear them
>> from those trees, add them back (unpin) to the free space caches and, if
>> the fs was mounted with "-o discard", perform a discard on those regions.
>> Also, after adding the regions to the free space caches, a fitrim ioctl
>> call
>> can see those ranges in a block group's free space cache and perform a
>> discard
>> on the ranges, so the same issue can happen without "-o discard" as well.
>>
>> This causes corruption, affecting one or multiple btree nodes (in the
>> worst
>> case leaving the fs unmountable) because some of those ranges (the ones in
>> the fs_info->pinned_extents tree) correspond to btree nodes/leafs that are
>> referred by the last committed super block - breaking the rule that
>> anything
>> that was committed by a transaction is untouched until the next
>> transaction
>> commits successfully.
>
>
> This is great work Filipe, thank you!
>
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 7e2405a..ce65b0c 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -4134,12 +4134,6 @@ again:
>>                 if (ret)
>>                         break;
>>
>> -               /* opt_discard */
>> -               if (btrfs_test_opt(root, DISCARD))
>> -                       ret = btrfs_error_discard_extent(root, start,
>> -                                                        end + 1 - start,
>> -                                                        NULL);
>> -
>
>
> While you're here, can you please just delete btrfs_error_discard_extent and
> use btrfs_discard_extent directly?  It's already being used in non-error
> cases, and since it only discards, I don't see how we want to do that on
> errors anyway.

Agreed, the function doesn't make sense and its name is confusing
since it's just an alias to btrfs_discard_extent().
I've sent a separate cleanup patch to remove it:
https://patchwork.kernel.org/patch/5456261/

thanks

>
> -chris
>
>
>>
>>                 clear_extent_dirty(unpin, start, end, GFP_NOFS);
>>                 btrfs_error_unpin_extent_range(root, start, end);
>>                 cond_resched();
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index c2fc261..fc74a9b 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -5728,7 +5728,8 @@ void btrfs_prepare_extent_commit(struct
>> btrfs_trans_handle *trans,
>>         update_global_block_rsv(fs_info);
>>  }
>>
>> -static int unpin_extent_range(struct btrfs_root *root, u64 start, u64
>> end)
>> +static int unpin_extent_range(struct btrfs_root *root, u64 start, u64
>> end,
>> +                             const bool return_free_space)
>>  {
>>         struct btrfs_fs_info *fs_info = root->fs_info;
>>         struct btrfs_block_group_cache *cache = NULL;
>> @@ -5752,7 +5753,8 @@ static int unpin_extent_range(struct btrfs_root
>> *root, u64 start, u64 end)
>>
>>                 if (start < cache->last_byte_to_unpin) {
>>                         len = min(len, cache->last_byte_to_unpin - start);
>> -                       btrfs_add_free_space(cache, start, len);
>> +                       if (return_free_space)
>> +                               btrfs_add_free_space(cache, start, len);
>>                 }
>>
>>                 start += len;
>> @@ -5816,7 +5818,7 @@ int btrfs_finish_extent_commit(struct
>> btrfs_trans_handle *trans,
>>                                                    end + 1 - start, NULL);
>>
>>                 clear_extent_dirty(unpin, start, end, GFP_NOFS);
>> -               unpin_extent_range(root, start, end);
>> +               unpin_extent_range(root, start, end, true);
>>                 cond_resched();
>>         }
>>
>> @@ -9705,7 +9707,7 @@ out:
>>
>>  int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start,
>> u64 end)
>>  {
>> -       return unpin_extent_range(root, start, end);
>> +       return unpin_extent_range(root, start, end, false);
>>  }
>>
>>  int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
>> --
>> 2.1.3
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
