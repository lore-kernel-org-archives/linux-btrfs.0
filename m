Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34642 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbF3I0D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 04:26:03 -0400
Received: by igcsj18 with SMTP id sj18so100668551igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 01:26:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CADob98Ro8iRb0pufkz90O6fkivhU-Gzrmn6nb-tQUh_TLa6UZg@mail.gmail.com>
References: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
	<1435528041-20878-2-git-send-email-dccitaliano@gmail.com>
	<CAL3q7H4jyL00OepP9GZxLOFLYF-GWKUN6JJc6o623u+Atepj8g@mail.gmail.com>
	<CADob98Ro8iRb0pufkz90O6fkivhU-Gzrmn6nb-tQUh_TLa6UZg@mail.gmail.com>
Date: Tue, 30 Jun 2015 09:26:02 +0100
Message-ID: <CAL3q7H6-0kzLayBE7yU01w_tZiJQH9yjLz2y3j+py0XEKOX5Rw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [btrfs] btrfs_rename: abort transaction in case of error.
From: Filipe David Manana <fdmanana@gmail.com>
To: Davide Italiano <dccitaliano@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 5:17 AM, Davide Italiano <dccitaliano@gmail.com> wrote:
> On Mon, Jun 29, 2015 at 4:59 AM, Filipe David Manana <fdmanana@gmail.com> wrote:
>> On Sun, Jun 28, 2015 at 10:47 PM, Davide C. C. Italiano
>> <dccitaliano@gmail.com> wrote:
>>> From: Davide Italiano <dccitaliano@gmail.com>
>>>
>>> btrfs_insert_inode_ref() may fail and we want to make sure
>>> the transaction is aborted before calling btrfs_end_transaction(),
>>> as it already happens everywhere else in this function in case
>>> of error.
>>>
>>> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
>>> ---
>>>  fs/btrfs/inode.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index 8bb0136..59c475c 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -9114,8 +9114,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>>                                              new_dentry->d_name.len,
>>>                                              old_ino,
>>>                                              btrfs_ino(new_dir), index);
>>> -               if (ret)
>>> +               if (ret) {
>>> +                       btrfs_abort_transaction(trans, root, ret);
>>>                         goto out_fail;
>>> +               }
>>> +
>>
>> Hi,
>>
>> I don't think we need a transaction abortion here. The reason it's not
>> being done is likely because at that point the trees are in a
>> consistent state (i.e. we haven't touched any of them yet) and not
>> because it was forgotten. So an abortion there is
>> unnecessary/excessive.
>>
>> thanks
>>
>
> Thank you for the comment -- I updated the other patch and I have
> mixed feeling about this one.
> I can either withdrawn the review or provide a new patch where I add a
> comment to clarify why this is not needed, for the future.
> Which one do you like better?

Hi,

I don't think it's needed. We do this pattern in many places and it's
quite obvious if one reads the code flow.

thanks

>
> --
> Davide



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
