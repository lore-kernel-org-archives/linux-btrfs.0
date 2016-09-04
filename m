Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34410 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754025AbcIDV6G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 17:58:06 -0400
Received: by mail-oi0-f50.google.com with SMTP id m11so99758128oif.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Sep 2016 14:57:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
 <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com> <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Sep 2016 15:57:37 -0600
Message-ID: <CAJCQCtS6ENQ-RYBQoW52g5zirGzxeLMLibtaWGKUoXZT3p2DVA@mail.gmail.com>
Subject: Re: Re[2]: btrfs check "Couldn't open file system" after error in transaction.c
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lost track of this...sorry.

On Sun, Aug 28, 2016 at 12:04 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hi Chris,
>
> thanks for your reply -especially on a Sunday.
>>>
>>>  I have a filesystem (three disks with no raid)
>>
>>
>> So it's data single *and* metadata single?
>>
> No:
> Data, single: total=8.14TiB, used=7.64TiB
> System, RAID1: total=32.00MiB, used=912.00KiB
> Metadata, RAID1: total=18.00GiB, used=16.45GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>>
>>>  btrfs check will lead to  "Couldn't open file system"

That's a bug worth filing. That bug report will need a URL for where
you put the btrfs-image file.


>>  Maybe
>> take advantage of the fact it does read only and recreate it. You
>> could take a btrfs-image and btrfs-debug-tree first,
>
> And what do I do with it?

Put it somewhere it can live a while, it might be months before a dev
gets around to looking at it. I usually put them on google drive in
the public folder, and then post the URL (get shareable link) in the
bug report.



>
>> because there's
>> some bug somewhere: somehow it became inconsistent, and can't be fixed
>> at mount time or even with btrfs check.
>
> Ok, so is there any way to help you finding this bug?
> Coming back to my objectives:
> -Understand the reason behind the issue and prevent it in future
> Finding the but would help on the above

No idea.

>
> -If not possible to repair the filesystem:
>    -understand if the data that I read from the drive is valid or corrupted
> Can you answer this?

Other than nocow files which do not have csums, Btrfs will spit back
an I/O error and path to the bad file rather than hand over data it
thinks is corrupt (doesn't match csum). So data read from the volume
should be valid.


>
> As mentioned: I do have a backup, a month old. The data does not change so
> regularly, so most should be ok.
> Now I have two sources of data:
> the backup and the current degraded filesystem.
> If data differs, which one do I take? Is it safe to use the more recent one
> from the degraded filesystem?

If data differs you have to figure out a way to inspect the file to
determine which one is correct. Databases have their own consistency
checks, for example, if it's an image, open it in a viewer - big
problems will be visible, small problems might just be one wrong pixel
and you may not even notice it.


-- 
Chris Murphy
