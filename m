Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35032 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaF2T26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 15:28:58 -0400
Received: by mail-lb0-f179.google.com with SMTP id z11so5188983lbi.24
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 12:28:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <53B067CD.4050903@fb.com>
References: <1404071004-20724-1-git-send-email-fdmanana@gmail.com>
	<53B067CD.4050903@fb.com>
Date: Sun, 29 Jun 2014 20:28:56 +0100
Message-ID: <CAL3q7H5RbqDeXx7=4Cj5ktqnz5dZGL1+-SrZtyCotmjg17ZqVw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix use-after-free when cloning a trailing file hole
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 29, 2014 at 8:23 PM, Chris Mason <clm@fb.com> wrote:
> On 06/29/2014 03:43 PM, Filipe David Borba Manana wrote:
>> The transaction handle was being used after being freed.
>>
>> Cc: Chris Mason <clm@fb.com>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>  fs/btrfs/ioctl.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 02dc64b..2562dc7 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3565,12 +3565,10 @@ process_slot:
>>                       btrfs_end_transaction(trans, root);
>>                       goto out;
>>               }
>> -             ret = clone_finish_inode_update(trans, inode, destoff + len,
>> -                                             destoff, olen);
>> -             if (ret)
>> -                     goto out;
>>               clone_update_extent_map(inode, trans, path, NULL, last_dest_end,
>>                                       destoff + len - last_dest_end);
>> +             ret = clone_finish_inode_update(trans, inode, destoff + len,
>> +                                             destoff, olen);
>>       }
>>
>>  out:
>>
>
> What about the path?  It has been released, so it should either be NULL
> or we have other problems ;)

Hi Chris,

Not needed. clone_update_extent_map ignores path if its 4th argument
is NULL (which is the case here).
Either way it's more clear if path is passed to that function as NULL
too. I'll update it for clarity.

>
> -chris



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
