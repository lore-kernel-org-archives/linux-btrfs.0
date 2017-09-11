Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35603 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdIKHyq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 03:54:46 -0400
Received: by mail-qt0-f195.google.com with SMTP id l25so2229584qtf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 00:54:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <03f4db85-bd2c-679d-e369-65ccc5d61ad7@gmx.com>
References: <CAP9W88gEje_unDuNTGCZXn5PKoDwHtTgrjc7Cwzn0a_2KWtWow@mail.gmail.com>
 <03f4db85-bd2c-679d-e369-65ccc5d61ad7@gmx.com>
From: shally verma <shallyvermacavium@gmail.com>
Date: Mon, 11 Sep 2017 13:24:15 +0530
Message-ID: <CAP9W88hGwo_L6k_-s7SUQpn7e-oVeFWydM9eiK=wtAK-kBDEXg@mail.gmail.com>
Subject: Re: BTRFS Deduplication
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 11, 2017 at 12:16 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年09月11日 14:05, shally verma wrote:
>>
>> I was going through  BTRFS Deduplication page
>> (https://btrfs.wiki.kernel.org/index.php/Deduplication) and I read
>>
>> "As such, xfs_io, is able to perform deduplication on a BTRFS file
>> system," ..
>>
>> following this, I followed on to xfs_io link
>> https://linux.die.net/man/8/xfs_io
>>
>> As I understand, these are set of commands allow us to do different
>> operations on "xfs" filesystem.
>
>
> Nope, it's just a tool triggering different read/write or ioctls.
> In fact most of its command is fs independent.
> Only a limited number of operations are only supported by XFS.
>
> It's just due to historical reasons it's still named as xfs_io.
>
> I won't be surprised if one day it's split as an independent tool.
>
>> and command set mentioned here, couldn't see which is command to
>> invoke dedupe task.
>
>
> "dedupe" and "reflink" command.
Oh. That means page link referred on BTRFS Wiki page is not updated
with this. I googled another page that has reference of these two
command in xfs_io here
https://www.systutorials.com/docs/linux/man/8-xfs_io/
May be Wiki need an update here.

>
>> and how this works with BTRFS.
>
>
> Fs support FIDEDUPERANGE or BTRFS_IOC_FILE_EXTENT_SAME ioctl can use it to
> determine if two ranges are containing identical data.
>
> And if they are identical, we use FICLONERANGE or BTRFS_IOC_CLONE_RANGE
> ioctl to reflink one to another, freeing one of them.
>
> BTW nowadays, such dedupe and reflink ioctl is genericized in VFS.
> file_operations structure now includes both clone_file_range() and
> dedupe_file_range() callbacks now.
Yea. Understand that part. So going by description of "dedupe" and
"reflink", seems through these commands, one can do deduplication part
and NOT duplicate find part. That's still out of xfs_io command scope.
Is that understanding correct?
Thanks
Shally
>
> Thanks,
> Qu
>>
>>
>> So, can anyone help here and point me what am I missing here.
>>
>> Thanks
>> Shally
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
