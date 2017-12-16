Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:43869 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752251AbdLPKLh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Dec 2017 05:11:37 -0500
Received: by mail-ua0-f177.google.com with SMTP id g4so428897ual.10
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 02:11:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
 <20171215103423.0fd678a6@natsu> <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
 <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Sat, 16 Dec 2017 11:11:16 +0100
Message-ID: <CAA85sZv=cAu1TfbJeGXdRwYOzVOqGbNAfNZeW23muu7VG22pLg@mail.gmail.com>
Subject: Re: [4.14.3] btrfs out of space error
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 15, 2017 at 9:53 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2017年12月15日 16:36, Ian Kumlien wrote:
>> On Fri, Dec 15, 2017 at 6:34 AM, Roman Mamedov <rm@romanrm.net> wrote:
>>> On Fri, 15 Dec 2017 01:39:03 +0100
>>> Ian Kumlien <ian.kumlien@gmail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> Running a 4.14.3 kernel, this just happened, but there should have
>>>> been another 20 gigs or so available.
>>>>
>>>> The filesystem seems fine after a reboot though
>>>
>>> What are your mount options, and can you show the output of "btrfs fi
>>> df" and "btrfs fi us" for the filesystem? And what does
>>> "cat /sys/block/sdb/queue/rotational" return.
>>
>> It's a btrfs raid1 mirror of two ssd:s

[--8<--]

(sorry if you got a reply before - dang html mails)

> Well, at least no new chunk can be allocated.
>
>
> In v4.15, Josef introduced a new inode reservation system, which I think
> it would enhance metadata related reservation.

Humm... maybe when it has been trough some rc:s ;)

> If you're hitting the problem quite frequently, please consider to try
> v4.15-rc* to see if it solves the problem.
>
> Despite of that, there should be no damage to your fs.
> (except some unwritten data in buffer)

Yeah figured as much - did a full defrag and recompress (with zstd
this time) just to play with it

> Thanks,
> Qu
>
>>
>> And as expected:
>> cat /sys/block/sdb/queue/rotational
>> 0
>>
>>> I wonder if it's the same old "ssd allocation scheme" problem, and no
>>> balancing done in a long time or at all.
>>
>> I had something similar happen on a laptop a while ago - took a while
>> before i could get it back in order
>> (in that case i think it was actually a oops --- it kept saying "no
>> space left" and switched to read only even
>> if you removed a lot of data, invalidated the space cache and so on)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
