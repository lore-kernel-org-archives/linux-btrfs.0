Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752666AbdBTN6W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 08:58:22 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 332DA20114
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 13:58:20 +0000 (UTC)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com [209.85.214.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D858C20103
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 13:58:18 +0000 (UTC)
Received: by mail-it0-f46.google.com with SMTP id y135so19826708itc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 05:58:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170218003445.GB9399@lim.localdomain>
References: <1487358964-9758-1-git-send-email-fdmanana@kernel.org> <20170218003445.GB9399@lim.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 20 Feb 2017 13:58:17 +0000
Message-ID: <CAL3q7H48U1WB2reR-6bH3a04kS5+ccSyqAe5wn8TdjEkc9vTfw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary constraint when splitting a leaf
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 18, 2017 at 12:34 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Feb 17, 2017 at 07:16:04PM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> If we want to append an item to a leaf we were trying to move off from the
>> leaf into its neighbors an amount of space corresponding to the item's
>> size. That amount of space is too much and can be reduced to the item's
>> size minus the amount of free space in the leaf, like we do for all the
>> other cases (item inserted at the beginning or somewhere in the middle of
>> the leaf).
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/ctree.c | 12 +++++-------
>>  1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index a426dc8..86be619 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -4130,11 +4130,11 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
>>       int progress = 0;
>>       int slot;
>>       u32 nritems;
>> -     int space_needed = data_size;
>> +     int space_needed;
>>
>>       slot = path->slots[0];
>> -     if (slot < btrfs_header_nritems(path->nodes[0]))
>> -             space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
>> +     space_needed = data_size -
>> +             btrfs_leaf_free_space(fs_info, path->nodes[0]);
>>
>>       /*
>>        * try to push all the items after our slot into the
>> @@ -4205,11 +4205,9 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>>
>>       /* first try to make some room by pushing left and right */
>>       if (data_size && path->nodes[1]) {
>> -             int space_needed = data_size;
>> -
>> -             if (slot < btrfs_header_nritems(l))
>> -                     space_needed -= btrfs_leaf_free_space(fs_info, l);
>> +             int space_needed;
>
> One doubt, if (slot == nritems(l)), and push_leaf_right() is with @emtpy == 0,
> so it is possible to use the right sibling as the node for the new item, so if
> we minus l's free space from space_needed, then it's possible that
>
> (the original space_needed) > (free space of right node) > (the subtracted space_needed)
>
> in that case, we're going to use right node as path->nodes[0] while right node
> doesn't have enough space.

Right. And I forgot why I added this constraint in the first place and
the optimization at push_leaf_right() that uses the right leaf and its
first slot.
The idea here (this patch) was to avoid less splits when we fallback
to try to move items into the left sibling, that is, if the new item
is for a slot > 0, right sibling is full (or does not have enough
space to move items into it) we try to push the left sibling with the
goal of freeing new_item_size - leaf_free_space bytes from our leaf
instead of new_item_size bytes. Clearly while doing that I made the
first optimization of trying to use the right leaf less likely to
succeed. I've reworked this with a new subject and changelog at:
https://patchwork.kernel.org/patch/9582901/

Thanks for reminding about that.

>
> Thanks,
>
> -liubo
>>
>> +             space_needed = data_size - btrfs_leaf_free_space(fs_info, l);
>>               wret = push_leaf_right(trans, root, path, space_needed,
>>                                      space_needed, 0, 0);
>>               if (wret < 0)
>> --
>> 2.7.0.rc3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
