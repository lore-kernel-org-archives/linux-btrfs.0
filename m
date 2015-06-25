Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:33006 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbFYRzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 13:55:21 -0400
Received: by yhpn97 with SMTP id n97so33031471yhp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 10:55:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADob98RbfYyiyyw+15cdhou1=fcGtB2kGypvLLKyirkd=e8Jzw@mail.gmail.com>
References: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
	<1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
	<CADob98RbfYyiyyw+15cdhou1=fcGtB2kGypvLLKyirkd=e8Jzw@mail.gmail.com>
Date: Thu, 25 Jun 2015 10:55:20 -0700
Message-ID: <CADob98RxO6=OuFDtYC=3_N98jZgxgiByLta0CyahQfo76Jk2=A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Improve FL_KEEP_SIZE handling in fallocate.
From: Davide Italiano <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2015 at 1:49 PM, Davide Italiano <dccitaliano@gmail.com> wrote:
> On Mon, Apr 6, 2015 at 10:09 PM, Davide Italiano <dccitaliano@gmail.com> wrote:
>> - We call inode_size_ok() only if FL_KEEP_SIZE isn't specified.
>> - As an optimisation we can skip the call if (off + len)
>>   isn't greater than the current size of the file. This operation
>>   is called under the lock so the less work we do, the better.
>> - If we call inode_size_ok() pass to it the correct value rather
>>   than a more conservative estimation.
>>
>> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
>> ---
>>  fs/btrfs/file.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 30982bb..f649bfc 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -2586,9 +2586,13 @@ static long btrfs_fallocate(struct file *file, int mode,
>>         }
>>
>>         mutex_lock(&inode->i_mutex);
>> -       ret = inode_newsize_ok(inode, alloc_end);
>> -       if (ret)
>> -               goto out;
>> +
>> +       if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>> +           offset + len > inode->i_size) {
>> +               ret = inode_newsize_ok(inode, offset + len);
>> +               if (ret)
>> +                       goto out;
>> +       }
>>
>>         if (alloc_start > inode->i_size) {
>>                 ret = btrfs_cont_expand(inode, i_size_read(inode),
>> --
>> 2.3.4
>>
>
> Any comment on this?

Very gentle ping after couple of months.
