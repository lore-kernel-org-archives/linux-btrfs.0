Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50960 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbdIKIMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 04:12:42 -0400
Subject: Re: BTRFS Deduplication
To: shally verma <shallyvermacavium@gmail.com>
Cc: linux-btrfs@vger.kernel.org, "Verma, Shally" <shally.verma@cavium.com>
References: <CAP9W88gEje_unDuNTGCZXn5PKoDwHtTgrjc7Cwzn0a_2KWtWow@mail.gmail.com>
 <03f4db85-bd2c-679d-e369-65ccc5d61ad7@gmx.com>
 <CAP9W88hGwo_L6k_-s7SUQpn7e-oVeFWydM9eiK=wtAK-kBDEXg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <32a55320-4e4f-2dea-4345-2c12b1b98eaf@gmx.com>
Date: Mon, 11 Sep 2017 16:12:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAP9W88hGwo_L6k_-s7SUQpn7e-oVeFWydM9eiK=wtAK-kBDEXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月11日 15:54, shally verma wrote:
> On Mon, Sep 11, 2017 at 12:16 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2017年09月11日 14:05, shally verma wrote:
>>>
>>> I was going through  BTRFS Deduplication page
>>> (https://btrfs.wiki.kernel.org/index.php/Deduplication) and I read
>>>
>>> "As such, xfs_io, is able to perform deduplication on a BTRFS file
>>> system," ..
>>>
>>> following this, I followed on to xfs_io link
>>> https://linux.die.net/man/8/xfs_io
>>>
>>> As I understand, these are set of commands allow us to do different
>>> operations on "xfs" filesystem.
>>
>>
>> Nope, it's just a tool triggering different read/write or ioctls.
>> In fact most of its command is fs independent.
>> Only a limited number of operations are only supported by XFS.
>>
>> It's just due to historical reasons it's still named as xfs_io.
>>
>> I won't be surprised if one day it's split as an independent tool.
>>
>>> and command set mentioned here, couldn't see which is command to
>>> invoke dedupe task.
>>
>>
>> "dedupe" and "reflink" command.
> Oh. That means page link referred on BTRFS Wiki page is not updated
> with this. I googled another page that has reference of these two
> command in xfs_io here
> https://www.systutorials.com/docs/linux/man/8-xfs_io/
> May be Wiki need an update here.

If XFS has a regularly updated online man page, we can just use that.
(But unfortunately, not every fs user tools use asciidoc like btrfs, 
which can generate both man page and html).

> 
>>
>>> and how this works with BTRFS.
>>
>>
>> Fs support FIDEDUPERANGE or BTRFS_IOC_FILE_EXTENT_SAME ioctl can use it to
>> determine if two ranges are containing identical data.
>>
>> And if they are identical, we use FICLONERANGE or BTRFS_IOC_CLONE_RANGE
>> ioctl to reflink one to another, freeing one of them.
>>
>> BTW nowadays, such dedupe and reflink ioctl is genericized in VFS.
>> file_operations structure now includes both clone_file_range() and
>> dedupe_file_range() callbacks now.
> Yea. Understand that part. So going by description of "dedupe" and
> "reflink", seems through these commands, one can do deduplication part
> and NOT duplicate find part.

Yes, one don't need to call "dedupe" ioctl if they already knows some 
data is identical and can go reflink straightforward.

> That's still out of xfs_io command scope.

Not sure what the scope here you mean, sorry for that.

Since xfs_io can be used to find duplication, and can remove 
duplication, I don't find anything strange in that wiki page.
(Especially considering how popular the tool is, you can't find any more 
handy tool than xfs_io)

Thanks,
Qu

> Is that understanding correct?
> Thanks
> Shally
>>
>> Thanks,
>> Qu
>>>
>>>
>>> So, can anyone help here and point me what am I missing here.
>>>
>>> Thanks
>>> Shally
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
