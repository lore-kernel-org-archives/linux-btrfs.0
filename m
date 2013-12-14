Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:56491 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3LNPNW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 10:13:22 -0500
Received: by mail-bk0-f42.google.com with SMTP id w11so1786853bkz.29
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 07:13:21 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAP9B-Q=XW2x67Te8fAYWJbOBCpnUxJQH2m7Va8tSpTcXE_xJ8Q@mail.gmail.com>
References: <1387032218-29998-1-git-send-email-fdmanana@gmail.com>
	<CAP9B-Q=o7j8bdopw4TRyYZAXmuezVYAoxp8fmk+4=iZ+H_LQDg@mail.gmail.com>
	<CAL3q7H6gErp-GYX4T8UzNUG=LGd_90zJqc5-epnvtkuNxh71tA@mail.gmail.com>
	<CAP9B-Q=XW2x67Te8fAYWJbOBCpnUxJQH2m7Va8tSpTcXE_xJ8Q@mail.gmail.com>
Date: Sat, 14 Dec 2013 15:13:21 +0000
Message-ID: <CAL3q7H4z7-coQK-HQm-GOOi_bX+9_yyQrUQG1ed5SS46vjctTg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: wait for ordered extents before removing extent maps
From: Filipe David Manana <fdmanana@gmail.com>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 14, 2013 at 3:08 PM, Shilong Wang <wangshilong1991@gmail.com> wrote:
> 2013/12/14 Filipe David Manana <fdmanana@gmail.com>:
>> On Sat, Dec 14, 2013 at 2:56 PM, Shilong Wang <wangshilong1991@gmail.com> wrote:
>>> Hello Filipe,
>>>
>>> 2013/12/14 Filipe David Borba Manana <fdmanana@gmail.com>:
>>>> Wang Shilong got into a case where during inode eviction we were
>>>> removing an extent map while it was pinned. This triggered a warning
>>>> in remove_extent_mapping() because the extent map had the pinned
>>>> flag set:
>>>>
>>>> [ 1209.102076]  [<ffffffffa04721b9>] remove_extent_mapping+0x69/0x70 [btrfs]
>>>> [ 1209.102084]  [<ffffffffa0466b06>] btrfs_evict_inode+0x96/0x4d0 [btrfs]
>>>> [ 1209.102089]  [<ffffffff81073010>] ? wake_atomic_t_function+0x40/0x40
>>>> [ 1209.102092]  [<ffffffff8118ab2e>] evict+0x9e/0x190
>>>> [ 1209.102094]  [<ffffffff8118b313>] iput+0xf3/0x180
>>>> [ 1209.102101]  [<ffffffffa0461fd1>] btrfs_run_delayed_iputs+0xb1/0xd0 [btrfs]
>>>> [ 1209.102107]  [<ffffffffa045d358>] __btrfs_end_transaction+0x268/0x350 [btrfs]
>>>>
>>>> Therefore wait for any pending ordered extents, if any, which will
>>>> trigger calls to unpin_extent_cache(), before removing the extent maps.
>>>>
>>>> Wang's solution of simply clearing the pinned bit wasn't enough, as after
>>>> unpin_extent_cache() will be called and trigger another WARN_ON() because
>>>> the lookup for the extent map returned NULL.
>>>
>>> Why not in evict_inode_truncate_pages() move remove_extent_mapping() after
>>> clear_extent_bit()?
>>
>> So, if the pinned bit is set, it means some task will clear it later,
>> via unpin_extent_cache(). And if you look at that function, it has
>> this:
>>
>> write_lock(&tree->lock);
>> em = lookup_extent_mapping(tree, start, len);
>>
>> WARN_ON(!em || em->start != start);
>>
>> And remove_extent_mapping() will remove the em from the rbtree,
>> regardless of its reference count value, therefore triggering that
>> warning above.
>
> Here i mean,  in evict_inode_truncate_pages()
> We change it to:
>
> Step1:  unpin_extent_cache()
> Step2:  remove it from extent_mapping
>
> Dose this cause any problems? i am a little confused, correct me if i
> am wrong some places^_^.

It can still lead to the same WARN_ON I think. So when calling
unpin_extent_cache(), it can merge the em with its left neighbor,
therefore changing its ->start value. So later, if other task (the one
which set the pinned flag) calls remove_extent_mapping(), it will get
an em with a different ->start (because of the merge), therefore
triggering that WARN_ON().

What do you think?

thanks

>
>
>>
>> Does it makes sense?
>>
>> thanks
>>
>>>
>>> Thanks,
>>> Wang
>>>>
>>>> Thanks Wang for finding out this.
>>>>
>>>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>>>> ---
>>>>  fs/btrfs/inode.c |    5 +++--
>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index e889779..c2933fb 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -4509,6 +4509,9 @@ static void evict_inode_truncate_pages(struct inode *inode)
>>>>         ASSERT(inode->i_state & I_FREEING);
>>>>         truncate_inode_pages(&inode->i_data, 0);
>>>>
>>>> +       /* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
>>>> +       btrfs_wait_ordered_range(inode, 0, (u64)-1);
>>>> +
>>>>         write_lock(&map_tree->lock);
>>>>         while (!RB_EMPTY_ROOT(&map_tree->map)) {
>>>>                 struct extent_map *em;
>>>> @@ -4566,8 +4569,6 @@ void btrfs_evict_inode(struct inode *inode)
>>>>                 btrfs_orphan_del(NULL, inode);
>>>>                 goto no_delete;
>>>>         }
>>>> -       /* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
>>>> -       btrfs_wait_ordered_range(inode, 0, (u64)-1);
>>>>
>>>>         if (root->fs_info->log_root_recovering) {
>>>>                 BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
>>>> --
>>>> 1.7.9.5
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
