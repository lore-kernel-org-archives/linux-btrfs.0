Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37852 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbCMJCo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 05:02:44 -0400
Received: by lbdu10 with SMTP id u10so21324272lbd.4
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 02:02:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H7M27wiqpcA9hrbNvmZogNfd4+bp1Md2QFkkWpBd62Zcw@mail.gmail.com>
References: <1426174618-929-1-git-send-email-fdmanana@suse.com>
	<20150313081051.GA14942@localhost.localdomain>
	<CAL3q7H7M27wiqpcA9hrbNvmZogNfd4+bp1Md2QFkkWpBd62Zcw@mail.gmail.com>
Date: Fri, 13 Mar 2015 09:02:41 +0000
Message-ID: <CAL3q7H7jx8qCgoR4-enHOjNv+ED5uaHnLSWquRLzvhZsBJ79+Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: add missing inode item update in fallocate()
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 8:59 AM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Fri, Mar 13, 2015 at 8:11 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> On Thu, Mar 12, 2015 at 03:36:58PM +0000, Filipe Manana wrote:
>>> If we fallocate(), without the keep size flag, into an area already covered
>>> by an extent previously fallocated, we were updating the inode's i_size but
>>> we weren't updating the inode item in the fs/subvol tree. A following umount
>>> + mount would result in a loss of the inode's size (and an fsync would miss
>>> too the fact that the inode changed).
>>>
>>> Reproducer:
>>>
>>>   $ mkfs.btrfs -f /dev/sdd
>>>   $ mount /dev/sdd /mnt
>>>   $ fallocate -n -l 1M /mnt/foobar
>>>   $ fallocate -l 512K /mnt/foobar
>>>   $ umount /mnt
>>>   $ mount /dev/sdd /mnt
>>>   $ od -t x1 /mnt/foobar
>>>   0000000
>>>
>>> The expected result is:
>>>
>>>   $ od -t x1 /mnt/foobar
>>>   0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>   *
>>>   2000000
>>>
>>> A test case for fstests follows soon.
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  fs/btrfs/file.c | 21 ++++++++++++++++-----
>>>  1 file changed, 16 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 8f256b1..fb4bd79 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>> @@ -2677,13 +2677,10 @@ static long btrfs_fallocate(struct file *file, int mode,
>>>                                                       1 << inode->i_blkbits,
>>>                                                       offset + len,
>>>                                                       &alloc_hint);
>>> -
>>> -                     if (ret < 0) {
>>> -                             free_extent_map(em);
>>> -                             break;
>>> -                     }
>>>               } else if (actual_end > inode->i_size &&
>>>                          !(mode & FALLOC_FL_KEEP_SIZE)) {
>>> +                     struct btrfs_trans_handle *trans;
>>> +
>>>                       /*
>>>                        * We didn't need to allocate any more space, but we
>>>                        * still extended the size of the file so we need to
>>> @@ -2692,8 +2689,22 @@ static long btrfs_fallocate(struct file *file, int mode,
>>>                       inode->i_ctime = CURRENT_TIME;
>>>                       i_size_write(inode, actual_end);
>>>                       btrfs_ordered_update_i_size(inode, actual_end, NULL);
>>> +                     /* 1 unit for inode item */
>>> +                     trans = btrfs_start_transaction(root, 1);
>>> +                     if (IS_ERR(trans)) {
>>> +                             ret = PTR_ERR(trans);
>>
>> I prefer putting this earlier, before i_size updates, to
>> protect us from another isize inconsistence(disk_i_size, isize vs isize in inode_item).
>
> I don't think that's a problem at all.
> Updating i_size (and all other btrfs_inode fields) before updating the
> inode item is done pretty much everywhere (examples:
> __btrfs_prealloc_file_range, btrfs_finish_ordered_io, etc, etc).

So re-reading this, you meant starting the transaction before doing
the size update and not doing the inode item update before updating
the i_size. So that's ok for me.

>
> So unless you can point exactly how it can become a problem, I'll
> leave as it is.
>
>>
>> Basically I mean,
>>                         ...
>>                         trans = btrfs_start_transaction(root, 1);
>>                         if (IS_ERR(trans)) {
>>                                 ret = PTR_ERR(trans);
>>                         } else {
>>                                 inode->i_ctime = CURRENT_TIME;
>>                                 ...
>>                         }
>>
>>> +                     } else {
>>> +                             ret = btrfs_update_inode(trans, root, inode);
>>> +                             if (ret)
>>> +                                     btrfs_end_transaction(trans, root);
>>> +                             else
>>> +                                     ret = btrfs_end_transaction(trans,
>>> +                                                                 root);
>>
>> calling same end_transaction() for two times seems kind of weird for me,
>> what about this?
>
> It's called one time.
>
>>
>> ret2 = btrfs_end_transaction(trans, root);
>> if (!ret)
>>         ret = ret2;
>
> Doesn't change correctness at all, purely stylistic choice.
>
> thanks
>
>>
>> But anyway, I'm okay with both.
>>
>> Thanks,
>>
>> -liubo
>>
>>>               }
>>>               free_extent_map(em);
>>> +             if (ret < 0)
>>> +                     break;
>>>
>>>               cur_offset = last_byte;
>>>               if (cur_offset >= alloc_end) {
>>> --
>>> 2.1.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
