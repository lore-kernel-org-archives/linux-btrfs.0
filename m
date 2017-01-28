Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:33665 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdA1SWw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 13:22:52 -0500
Received: by mail-ua0-f175.google.com with SMTP id i68so225867747uad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 10:22:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$bea71$c88f268f$3fe2f55a$caf61eb5@cox.net>
References: <CAE8gLhk=Gf7Qejs6zit+hGdFNeNSPexJZ=jgCY1CADt6xoNHhA@mail.gmail.com>
 <pan$bea71$c88f268f$3fe2f55a$caf61eb5@cox.net>
From: MegaBrutal <megabrutal@gmail.com>
Date: Sat, 28 Jan 2017 19:15:01 +0100
Message-ID: <CAE8gLhkjgOzRgJXKL=az8Mw8njCg+m6d0zyH8WmDPNx_-Wp9Ow@mail.gmail.com>
Subject: Re: File system is oddly full after kernel upgrade, balance doesn't help
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Of course I can't retrieve the data from before the balance, but here
is the data from now:

root@vmhost:~# btrfs fi show /tmp/mnt/curlybrace
Label: 'curlybrace'  uuid: f471bfca-51c4-4e44-ac72-c6cd9ccaf535
    Total devices 1 FS bytes used 752.38MiB
    devid    1 size 2.00GiB used 1.90GiB path
/dev/mapper/vmdata--vg-lxc--curlybrace

root@vmhost:~# btrfs fi df /tmp/mnt/curlybrace
Data, single: total=773.62MiB, used=714.82MiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=577.50MiB, used=37.55MiB
GlobalReserve, single: total=512.00MiB, used=0.00B
root@vmhost:~# btrfs fi usage /tmp/mnt/curlybrace
Overall:
    Device size:           2.00GiB
    Device allocated:           1.90GiB
    Device unallocated:         103.38MiB
    Device missing:             0.00B
    Used:             789.94MiB
    Free (estimated):         162.18MiB    (min: 110.50MiB)
    Data ratio:                  1.00
    Metadata ratio:              2.00
    Global reserve:         512.00MiB    (used: 0.00B)

Data,single: Size:773.62MiB, Used:714.82MiB
   /dev/mapper/vmdata--vg-lxc--curlybrace     773.62MiB

Metadata,DUP: Size:577.50MiB, Used:37.55MiB
   /dev/mapper/vmdata--vg-lxc--curlybrace       1.13GiB

System,DUP: Size:8.00MiB, Used:16.00KiB
   /dev/mapper/vmdata--vg-lxc--curlybrace      16.00MiB

Unallocated:
   /dev/mapper/vmdata--vg-lxc--curlybrace     103.38MiB


So... if I sum the data, metadata, and the global reserve, I see why
only ~170 MB is left. I have no idea, however, why the global reserve
sneaked up to 512 MB for such a small file system, and how could I
resolve this situation. Any ideas?


MegaBrutal



2017-01-28 7:46 GMT+01:00 Duncan <1i5t5.duncan@cox.net>:
> MegaBrutal posted on Fri, 27 Jan 2017 19:45:00 +0100 as excerpted:
>
>> Hi,
>>
>> Not sure if it caused by the upgrade, but I only encountered this
>> problem after I upgraded to Ubuntu Yakkety, which comes with a 4.8
>> kernel.
>> Linux vmhost 4.8.0-34-generic #36-Ubuntu SMP Wed Dec 21 17:24:18 UTC
>> 2016 x86_64 x86_64 x86_64 GNU/Linux
>>
>> This is the 2nd file system which showed these symptoms, so I thought
>> it's more than happenstance. I don't remember what I did with the first
>> one, but I somehow managed to fix it with balance, if I remember
>> correctly, but it doesn't help with this one.
>>
>> FS state before any attempts to fix:
>> Filesystem      1M-blocks   Used Available Use% Mounted on
>> [...]curlybrace      1024   1024         0 100% /tmp/mnt/curlybrace
>>
>> Resized LV, run „btrfs filesystem resize max /tmp/mnt/curlybrace”:
>> [...]curlybrace      2048   1303         0 100% /tmp/mnt/curlybrace
>>
>> Notice how the usage magically jumped up to 1303 MB, and despite the FS
>> size is 2048 MB, the usage is still displayed as 100%.
>>
>> Tried full balance (other options with -dusage had no result):
>> root@vmhost:~# btrfs balance start -v /tmp/mnt/curlybrace
>
>> Starting balance without any filters.
>> ERROR: error during balancing '/tmp/mnt/curlybrace':
>> No space left on device
>
>> No space left on device? How?
>>
>> But it changed the situation:
>> [...]curlybrace      2048   1302       190  88% /tmp/mnt/curlybrace
>>
>> This is still not acceptable. I need to recover at least 50% free space
>> (since I increased the FS to the double).
>>
>> A 2nd balance attempt resulted in this:
>> [...]curlybrace      2048   1302       162  89% /tmp/mnt/curlybrace
>>
>> So... it became slightly worse.
>>
>> What's going on? How can I fix the file system to show real data?
>
> Something seems off, yes, but...
>
> https://btrfs.wiki.kernel.org/index.php/FAQ
>
> Reading the whole thing will likely be useful, but especially 1.3/1.4 and
> 4.6-4.9 discussing the problem of space usage, reporting, and (primarily
> in some of the other space related FAQs beyond the specific ones above)
> how to try and fix it when space runes out, on btrfs.
>
> If you read them before, read them again, because you didn't post the
> btrfs free-space reports covered in 4.7, instead posting what appears to
> be the standard (non-btrfs) df report, which for all the reasons
> explained in the FAQ, is at best only an estimate on btrfs.  That
> estimate is obviously behaving unexpectedly in your case, but without the
> btrfs specific reports, it's nigh impossible to even guess with any
> chance at accuracy what's going on, or how to fix it.
>
> A WAG would be that part of the problem might be that you were into
> global reserve before the resize, so after the filesystem got more space
> to use, the first thing it did was unload that global reserve usage,
> thereby immediately upping apparent usage.  That might explain that
> initial jump in usage after the resize.  But that's just a WAG.  Without
> at least btrfs filesystem usage, or btrfs filesystem df plus btrfs
> filesystem show, from before the resize, after, and before and after the
> balances, a WAG is what it remains.  And again, without those reports,
> there's no way to say whether balance can be expected to help, or not.
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
