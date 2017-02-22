Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932342AbdBVOFN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 09:05:13 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7E4322024D
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 14:05:07 +0000 (UTC)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com [209.85.214.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43494201BC
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 14:05:06 +0000 (UTC)
Received: by mail-it0-f52.google.com with SMTP id k200so39623872itb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 06:05:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170222000756.GD32725@lim.localdomain>
References: <1487537799-17570-1-git-send-email-fdmanana@kernel.org> <20170222000756.GD32725@lim.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 22 Feb 2017 14:05:05 +0000
Message-ID: <CAL3q7H6H3zbvLPp0-7ttytM0yNCjz==Ra=K=s5wq6ThPGc7JVQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: try harder to migrate items to left sibling before
 splitting a leaf
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 22, 2017 at 12:07 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Sun, Feb 19, 2017 at 08:56:39PM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Before attempting to split a leaf we try to migrate items from the leaf to
>> its right and left siblings. We start by trying to move items into the
>> rigth sibling and, if the new item is meant to be inserted at the end of
>> our leaf, we try to free from our leaf an amount of bytes equal to the
>> number of bytes used by the new item, by setting the variable space_needed
>> to the byte size of that new item. However if we fail to move enough items
>> to the right sibling due to lack of space in that sibling, we then try
>> to move items into the left sibling, and in that case we try to free
>> an amount equal to the size of the new item from our leaf, when we need
>> only to free an amount corresponding to the size of the new item minus
>> the current free space of our leaf. So make sure that before we try to
>> move items to the left sibling we do set the variable space_needed with
>> a value corresponding to the new item's size minus the leaf's current
>> free space.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/ctree.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index a426dc8..1d66761 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -4160,6 +4160,9 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
>>
>>       /* try to push all the items before our slot into the next leaf */
>>       slot = path->slots[0];
>> +     space_needed = data_size;
>> +     if (slot > 0)
>> +             space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
>
> Good point.
>
>>       ret = push_leaf_left(trans, root, path, 1, space_needed, 0, slot);
>>       if (ret < 0)
>>               return ret;
>> @@ -4215,6 +4218,10 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>>               if (wret < 0)
>>                       return wret;
>>               if (wret) {
>> +                     space_needed = data_size;
>> +                     if (slot > 0)
>> +                             space_needed -= btrfs_leaf_free_space(fs_info,
>> +                                                                   l);
>
> Not sure if we need this, the above push_leaf_right() was called with
> @min_data_size == space_needed, thus if @wret == 1, no items have been moved in
> push_leaf_right() so that leaf 'l' remains unchanged.

That's exactly the point. If the item is meant to be appended and we
failed to move it into the right sibling, we want to try to move items
from the leaf into its left sibling with the goal of freeing
"new_item_size - leaf_free_space(l)" bytes from our leaf. Without this
new assignment, we try to free new_item_size bytes, which has higher
chances of not being successful at migrating items into the left
sibling (example, the left sibling has less than new_item_size bytes
free, but has at least "new_item_size - leaf_free_space(l)" bytes
free).

>
> Thanks,
>
> -liubo
>>                       wret = push_leaf_left(trans, root, path, space_needed,
>>                                             space_needed, 0, (u32)-1);
>>                       if (wret < 0)
>> --
>> 2.7.0.rc3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
