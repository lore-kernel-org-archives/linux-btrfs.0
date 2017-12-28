Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35763 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdL1XJg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 18:09:36 -0500
Received: by mail-io0-f181.google.com with SMTP id 14so33196617iou.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Dec 2017 15:09:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
In-Reply-To: <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com> <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
From: Stirling Westrup <swestrup@gmail.com>
Date: Thu, 28 Dec 2017 18:09:34 -0500
Message-ID: <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
Subject: Re: Hand Patching a BTRFS Superblock?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using "btrfs rescue super-recover" is of no use since there are no
valid superblocks on the disk I need to fix. In fact, it's even worse,
because the only even partly valid superblock is a copy of the one
from drive sdd, which is a perfectly valid drive. What I need to do
(as far as I can tell) is:

1) Patch the UUID_SUB and device number of sdf to make it distinct
from sdd. Or just generate an entirely new superblock for sdf which
indicates it is device 2 in the 4-device BTRFS (rather than device 1
which it now thinks it is).

2) Recover (somehow) whatever other information from the superblock
that is missing.



On Thu, Dec 28, 2017 at 7:11 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年12月28日 19:41, Nikolay Borisov wrote:
>>
>>
>> On 28.12.2017 03:53, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年12月28日 09:46, Stirling Westrup wrote:
>>>> Here's my situation: I have a network file server containing a 12TB
>>>> BTRFS spread out over four devices (sda-sdd) which I am trying to
>>>> recover. I do have a backup, but it's about 3 months old, and while I
>>>> could certainly rebuild everything from that if I really had to, I
>>>> would far rather not have to rerip my latest DVDs. So, I am willing to
>>>> experiment if it might save me a few hundred hours of reconstruction.
>>>> I don't currently have another 12 TB of space anywhere for making a
>>>> scratch copy.
>>>>
>>>> A few days ago sdb developed hard errors and I can no longer mount the
>>>> filesystem. sdb is no longer even recognized as a valid btrfs drive.
>>>> However, when I ran ddrescue over the drive I managed to make a clone
>>>> (sdf) which contains all but 12K of the original drive. However, those
>>>> missing 12K are all in the various superblocks, so the cloned drive is
>>>> still unreadable.
>>>>
>>>> In the hopes that I was only missing a few bits of the superblocks, I
>>>> started out by dd-ing the first 4M of sdd into sdf in the hopes that
>>>> ddrescue would overwrite much of the superblocks, and the final bits
>>>> from sdd would make things usable.
>>>>
>>>> No such luck. I now have a drive sdf which claims to be identical to
>>>> sdd but which is a clone of sdb. In case it matters, sda and sdc are
>>>> each 4TB while sdb and sdd are each 2TB drives; sde is my boot drive
>>>> and sdf is a 2TB clone of sdb.
>>>>
>>>> What I need to do is to somehow patch sdf's primary superblock so it
>>>> contains the correct device number and UUID_SUB for sdb, so that I can
>>>> attempt some sort of recovery. Right now my linux is (understandably)
>>>> quite confused by the situation:
>>>
>>> Did you tried "btrfs rescue super-recover"?
>>>
>>> Remember to use the devel branch from git, as there is a small bug
>>> prevent it report correct result.
>>
>> Unforutnately my patchset which fixes super-recover is still not merged,
>> so he needs to grab the patches from the mailing list and compile the
>> btrfs tools himself. The patch in question can be found here:
>>
>> https://patchwork.kernel.org/patch/10092471/
>
> And just in-case, "btrfs insp dump-super -fa" output could greatly help
> us to check if the backup superblocks are really good.
>


-- 
Stirling Westrup
Programmer, Entrepreneur.
https://www.linkedin.com/e/fpf/77228
http://www.linkedin.com/in/swestrup
http://technaut.livejournal.com
http://sourceforge.net/users/stirlingwestrup
