Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33282 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754AbcECTAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 15:00:19 -0400
Received: by mail-lf0-f48.google.com with SMTP id y84so33663098lfc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 12:00:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$6f3dc$4726806a$a5dc5eab$10f59711@cox.net>
References: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
	<CAJCQCtTG68BicgFwoyYgM0OzphsVbstgWTNybF3CeBo1VCJhNg@mail.gmail.com>
	<CAGGqMYTso0XNjgfmWfY8g3Xs9xym5gHFcTizzAq1_Y-mMTTx0w@mail.gmail.com>
	<CAJCQCtRk+V0vhdCsyi-3aoNDimV0E4XJjQc9Us35uO59HpjSAQ@mail.gmail.com>
	<CAGGqMYSZ8P=ZVSgL4zWJKi7uuYLxRMZh=XEzPYpT2PykQD58oQ@mail.gmail.com>
	<pan$e4ba4$a250943d$4b67b01a$4a6c9e1c@cox.net>
	<CAGGqMYQH7h4-atS+ecBzngBMLu7iRe4-CehjavUAcJMje+v=wA@mail.gmail.com>
	<pan$6f3dc$4726806a$a5dc5eab$10f59711@cox.net>
Date: Tue, 3 May 2016 21:00:17 +0200
Message-ID: <CAGGqMYRzhDCsZ+DhB4pgcskuRd0+Y97tA+=Mm-V-Pj8scwTQ8g@mail.gmail.com>
Subject: Re: receive snapshot, complains about missing file
From: Alexander Fougner <fougner89@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-04-30 13:28 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> Alexander Fougner posted on Sat, 30 Apr 2016 12:55:06 +0200 as excerpted:
>
>>>> Receive side only outputs this:
>>>> sudo btrfs check -p /dev/sdc Couldn't open file system
>>>
>>> It wasn't mounted at the time, right?
>>
>> Nope
>>
>>
>>> Cuz btrfs check won't work with a mounted filesystem.
>>>
>>> Of course you'll need to be root to access the device as well,
>>> but that's pretty much a given.
>>
>> I think sudo should do that, right?
>
> Yes.
>
> I wonder then why it couldn't access it?
>
Me too!

It worked with a liveusb though. Btrfs-progs 4.4

sudo btrfs check /dev/sdc
Checking filesystem on /dev/sdc
UUID: 666172ff-0adb-45e8-8640-4feed682f378
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 2334784469221 bytes used err is 0
total csum bytes: 2243595764
total tree bytes: 8267939840
total fs tree bytes: 5431869440
total extent tree bytes: 271794176
btree space waste bytes: 1221110549
file data blocks allocated: 146702044540928
 referenced 2388234321920

Looks good to me.

Also, it works to resend the complete chain of snapshots to a new FS.
However, deleting the complete chain of snapshots on the trouble-FS
and resending everything still results in the same error.

> Just to be sure, since I didn't think to ask the first time and with
> subvolumes it's possible to mount other subvolumes and possibly forget
> that they're actually part of the same filesystem, you didn't have /any/
> subvolumes of that filesystem mounted, right?

I'm pretty sure nothing else was mounted. Besides, that should output
a different error message, warning us about the mounted FS.

>
> What does btrfs fi show say about the filesystem?
>
Label: 'storage'  uuid: 666172ff-0adb-45e8-8640-4feed682f378
        Total devices 2 FS bytes used 2.12TiB
        devid    3 size 2.73TiB used 2.23TiB path /dev/sde
        devid    4 size 2.73TiB used 2.23TiB path /dev/sdc


> I'm assuming it's mountable.  Does a mount and umount then let it be
> btrfs checked?  On the other end of things, what about a reboot and btrfs
> device scan, then btrfs check?
>
> If it's not the low-hanging fruit like that, perhaps check is keying off
> the same error that receive is, but I haven't the foggiest what the
> problem would be.
>
> I guess another possibility would be that btrfs check is violating some
> sort of security policy such as selinux.  I don't run anything of that
> nature here so know little more about it beyond the possibility, but from
> previous posts I think Chris Murphy has at some experience in that area.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
