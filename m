Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32954 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbF3ERg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 00:17:36 -0400
Received: by wiwl6 with SMTP id l6so118485065wiw.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 21:17:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4jyL00OepP9GZxLOFLYF-GWKUN6JJc6o623u+Atepj8g@mail.gmail.com>
References: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
	<1435528041-20878-2-git-send-email-dccitaliano@gmail.com>
	<CAL3q7H4jyL00OepP9GZxLOFLYF-GWKUN6JJc6o623u+Atepj8g@mail.gmail.com>
Date: Tue, 30 Jun 2015 00:17:35 -0400
Message-ID: <CADob98Ro8iRb0pufkz90O6fkivhU-Gzrmn6nb-tQUh_TLa6UZg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [btrfs] btrfs_rename: abort transaction in case of error.
From: Davide Italiano <dccitaliano@gmail.com>
To: fdmanana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 29, 2015 at 4:59 AM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Sun, Jun 28, 2015 at 10:47 PM, Davide C. C. Italiano
> <dccitaliano@gmail.com> wrote:
>> From: Davide Italiano <dccitaliano@gmail.com>
>>
>> btrfs_insert_inode_ref() may fail and we want to make sure
>> the transaction is aborted before calling btrfs_end_transaction(),
>> as it already happens everywhere else in this function in case
>> of error.
>>
>> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
>> ---
>>  fs/btrfs/inode.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 8bb0136..59c475c 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -9114,8 +9114,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>                                              new_dentry->d_name.len,
>>                                              old_ino,
>>                                              btrfs_ino(new_dir), index);
>> -               if (ret)
>> +               if (ret) {
>> +                       btrfs_abort_transaction(trans, root, ret);
>>                         goto out_fail;
>> +               }
>> +
>
> Hi,
>
> I don't think we need a transaction abortion here. The reason it's not
> being done is likely because at that point the trees are in a
> consistent state (i.e. we haven't touched any of them yet) and not
> because it was forgotten. So an abortion there is
> unnecessary/excessive.
>
> thanks
>

Thank you for the comment -- I updated the other patch and I have
mixed feeling about this one.
I can either withdrawn the review or provide a new patch where I add a
comment to clarify why this is not needed, for the future.
Which one do you like better?

--
Davide
