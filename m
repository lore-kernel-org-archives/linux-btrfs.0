Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35013 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbJWLwh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 07:52:37 -0400
Received: by lfbn126 with SMTP id n126so46115200lfb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2015 04:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151023001459.GF4400@hungrycats.org>
References: <CAGqmi76ZKv3ezguTyxGL_Jv_xtq5w_SGPvjwTy90Z=oNY73Vmw@mail.gmail.com>
 <20151023001459.GF4400@hungrycats.org>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 23 Oct 2015 14:51:56 +0300
Message-ID: <CAGqmi77ugFRYrV774py_=_XpPOSwh4zY9MsnexVgxH8MfnhjTQ@mail.gmail.com>
Subject: Re: [RFC PATCH] btrfs/ioctl.c: Prefer inode with lowest offset as
 source for clone
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo, you are right
Thread closed, thanks

2015-10-23 3:14 GMT+03:00 Zygo Blaxell <ce3g8jdj@umail.furryterror.org>:
> On Tue, Oct 20, 2015 at 04:29:46PM +0300, Timofey Titovets wrote:
>> For performance reason, leave data at the start of disk, is preferable
>> while deduping
>> It's might sense for the reasons:
>> 1. Spinning rust - start of the disk is much faster
>> 2. Btrfs can deallocate empty data chunk from the end of fs - ie it's compact fs
>
> "src" is the extent that is kept, and "dst" is the extent that is
> discarded.  When both extents are shared, the dedup userspace has to
> pass a common "src" with many different "dst" over several extent-same
> calls in order to get rid of all of the references to the "dst" extent.
>
> If "src" and "dst" are arbitrarily swapped over multiple extent-same calls
> then it becomes impossible to dedup shared extents.  Heck, if there are
> more than two extents even in one extent-same call then it stops working.
>
> It would be possible to have dedup figure out which extent the kernel
> picked after the fact, but that's totally unnecessary extra work in
> cases where the userspace has a good reason to pick the extents it did
> (e.g. administrator hints about future usage of the files where the
> extents were found).
>
> Dedup userspace can figure out the physical addresses of the extents
> and rearrange the arguments itself if desired.
>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/ioctl.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 3e3e613..3eb77c0 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3074,8 +3074,13 @@ static int btrfs_extent_same(struct inode *src,
>> u64 loff, u64 olen,
>>
>>   /* pass original length for comparison so we stay within i_size */
>>   ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
>> - if (ret == 0)
>> -     ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
>> + if (ret == 0) {
>> +     /* prefer inode with lowest offset as source for clone*/
>> +     if (loff > dest_loff)
>> +         ret = btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
>> +     else
>> +         ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
>> + }
>>
>>   if (same_inode)
>>   unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
>> --
>> 2.6.1
>
>> From 5ed3822bc308c726d91a837fbd97ebacaa51e58d Mon Sep 17 00:00:00 2001
>> From: Timofey Titovets <nefelim4ag@gmail.com>
>> Date: Tue, 20 Oct 2015 15:53:20 +0300
>> Subject: [RFC PATCH] btrfs/ioctl.c: Prefer inode with lowest offset as source for
>>  clone
>>
>> For performance reason, leave data at the start of disk, is preferable
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/ioctl.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 3e3e613..3eb77c0 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3074,8 +3074,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>>
>>       /* pass original length for comparison so we stay within i_size */
>>       ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
>> -     if (ret == 0)
>> -             ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
>> +     if (ret == 0) {
>> +             /* prefer inode with lowest offset as source for clone*/
>> +             if (loff > dest_loff)
>> +                     ret = btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
>> +             else
>> +                     ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
>> +     }
>>
>>       if (same_inode)
>>               unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
>> --
>> 2.6.1
>>
>



-- 
Have a nice day,
Timofey.
