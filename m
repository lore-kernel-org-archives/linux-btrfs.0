Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:32785 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbbFHDoY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 23:44:24 -0400
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com [209.85.223.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id 639ED1E15913
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2015 11:44:21 +0800 (CST)
Received: by iebmu5 with SMTP id mu5so54725620ieb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2015 20:44:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4LR_72Gs6mrtoaanEum__U8h_tq=VR0CgdV3saJKu1Xw@mail.gmail.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-6-git-send-email-robbieko@synology.com>
	<CAL3q7H4LR_72Gs6mrtoaanEum__U8h_tq=VR0CgdV3saJKu1Xw@mail.gmail.com>
Date: Mon, 8 Jun 2015 11:44:19 +0800
Message-ID: <CAJiZgcpNgyka+L+PRx+QGhb5S8Q10Q3yOrdkcg3OLKKpJczpng@mail.gmail.com>
Subject: Re: [PATCH 5/5] Btrfs: incremental send, fix rmdir not send utimes
From: Robbie Ko <robbieko@synology.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

I've fixed "don't send utimes for non-existing directory" with another solution.

 In apply_dir_move(), the old parent dir. and new parent dir. will be
updated after the current dir. has moved.

And there's only one entry in old parent dir. (e.g. entry with
smallest ino) will be tagged with rmdir_ino to prevent its parent dir.
is deleted but updated.

However, if we process rename for another entry not tagged with
rmdir_ino first, its old parent dir. which is deleted  will be updated
according to apply_dir_move().

Therefore, I think we should check the existence of  the dir. before
we're going to update it's utime.

The patch is pasted in the following link, could you give me some comment?

https://friendpaste.com/h8tZqOS9iAUpp2DvgGI2k

Thans!

Robbie Ko

2015-06-05 0:14 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
> On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
>> There's one case where we can't issue a utimes operation for a directory.
>> When 263 will delete, waiting 261 and set 261 rmdir_ino, but 262 earlier
>> processed and update uime between two parent directory.
>> So fix this by not update non exist utimes for this case.
>
> So you mean that we attempt to update utimes for an inode,
> corresponding to a directory, that exists in the parent snapshot but
> not in the send snapshot.
>
> So the subject should be something like "Btrfs: incremental send,
> don't send utimes for non-existing directory" instead of "Btrfs:
> incremental send, fix rmdir not send utimes"
>
>>
>> Example:
>>
>> Parent snapshot:
>> |---- a/ (ino 259)
>>   |---- c (ino 264)
>> |---- b/ (ino 260)
>>   |---- d (ino 265)
>> |---- del/ (ino 263)
>>   |---- item1/ (ino 261)
>>   |---- item2/ (ino 262)
>>
>> Send snapshot:
>> |---- a/ (ino 259)
>> |---- b/ (ino 260)
>> |---- c/ (ino 2)
>>   |---- item2 (ino 259)
>> |---- d/ (ino 257)
>>   |---- item1/ (ino 258)
>>
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> ---
>>  fs/btrfs/send.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index e8eb3ab..46f954c 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -2468,7 +2468,7 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
>>         key.type = BTRFS_INODE_ITEM_KEY;
>>         key.offset = 0;
>>         ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
>> -       if (ret < 0)
>> +       if (ret != 0)
>>                 goto out;
>
> So I don't think this is a good fix. The problem is in some code that
> calls this function (send_utimes) against the directory that doesn't
> exist - it just shouldn't do that, its logic should be fixed.
> Following this approach, while it works, it's just hiding logic errors
> in one or more code paths, and none of its callers checks for a return
> value of 1 - they only react to values < 0 and introduces the
> possibility of propagating a return value of 1 to user space.
>
> thanks
>
>>
>>         eb = path->nodes[0];
>> --
>> 1.9.1
>>
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
