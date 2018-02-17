Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:45391 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeBQEeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 23:34:09 -0500
Received: by mail-lf0-f47.google.com with SMTP id x196so6567511lfd.12
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Feb 2018 20:34:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$44d82$cdc95127$80ea1d4a$cb43d97@cox.net>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com> <pan$44d82$cdc95127$80ea1d4a$cb43d97@cox.net>
From: Shehbaz Jaffer <shehbazjaffer007@gmail.com>
Date: Fri, 16 Feb 2018 23:34:07 -0500
Message-ID: <CAPLK-i8zoUfmq8aYN7b-bczQieMyAsN6pY+-q5GHxGM0ca9U-g@mail.gmail.com>
Subject: Re: Ongoing Btrfs stability issues
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>It's hosted on an EBS volume; we don't use ephemeral storage at all. The EBS volumes are all SSD

I have recently done some SSD corruption experiments on small set of
workloads, so I thought I would share my experience.

While creating btrfs using mkfs.btrfs command for SSDs, by default the
metadata duplication option is disabled. this renders btrfs-scrubbing
ineffective, as there are no redundant metadata to restore corrupted
metadata from.
So if there are any errors during read operation on SSD, unlike HDD
where the corruptions would be handled by btrfs scrub on the fly while
detecting checksum error, for SSD the read would fail as uncorrectable
error.

Could you confirm if metadata DUP is enabled for your system by
running the following cmd:

$btrfs fi df /mnt # mount is the mount point
Data, single: total=8.00MiB, used=64.00KiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=168.00MiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

If metadata is single in your case as well (and not DUP), that may be
the problem for btrfs-scrub not working effectively on the fly
(mid-stream bit-rot correction), causing reliability issues. A couple
of such bugs that are observed specifically for SSDs is reported here:

https://bugzilla.kernel.org/show_bug.cgi?id=198463
https://bugzilla.kernel.org/show_bug.cgi?id=198807

These do not occur for HDD, and I believe should not occur when
filesystem is mounted with nossd mode.

On Fri, Feb 16, 2018 at 10:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Austin S. Hemmelgarn posted on Fri, 16 Feb 2018 14:44:07 -0500 as
> excerpted:
>
>> This will probably sound like an odd question, but does BTRFS think your
>> storage devices are SSD's or not?  Based on what you're saying, it
>> sounds like you're running into issues resulting from the
>> over-aggressive SSD 'optimizations' that were done by BTRFS until very
>> recently.
>>
>> You can verify if this is what's causing your problems or not by either
>> upgrading to a recent mainline kernel version (I know the changes are in
>> 4.15, I don't remember for certain if they're in 4.14 or not, but I
>> think they are), or by adding 'nossd' to your mount options, and then
>> seeing if you still have the problems or not (I suspect this is only
>> part of it, and thus changing this will reduce the issues, but not
>> completely eliminate them).  Make sure and run a full balance after
>> changing either item, as the aforementioned 'optimizations' have an
>> impact on how data is organized on-disk (which is ultimately what causes
>> the issues), so they will have a lingering effect if you don't balance
>> everything.
>
> According to the wiki, 4.14 does indeed have the ssd changes.
>
> According to the bug, he's running 4.13.x on one server and 4.14.x on
> two.  So upgrading the one to 4.14.x should mean all will have that fix.
>
> However, without a full balance it /will/ take some time to settle down
> (again, assuming btrfs was using ssd mode), so the lingering effect could
> still be creating problems on the 4.14 kernel servers for the moment.
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



-- 
Shehbaz Jaffer
