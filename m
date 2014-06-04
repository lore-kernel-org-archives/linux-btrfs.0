Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54314 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaFDXRZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 19:17:25 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so203499wgh.16
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 16:17:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEezp7uCfnYJOfN0v1CS3hGy1ccupe6=WaX_+k3MzDSbyQkX0g@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
 <CAG1y0sfrmSD31iKfqyR9jMJSBNvs=dihiHtd8nMwiawkhykUQw@mail.gmail.com> <CAEezp7uCfnYJOfN0v1CS3hGy1ccupe6=WaX_+k3MzDSbyQkX0g@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 5 Jun 2014 02:17:04 +0300
Message-ID: <CAGqmi77eemaOVfeFmB5xP8gvK34-dFmToqQTWczOv4ayo9jD7Q@mail.gmail.com>
Subject: Re: Very slow filesystem
To: Igor M <igork20@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i can mistake, but i think what:
btrfstune -x <dev> # can improve perfomance because this decrease metadata
Also, in last versions of btrfs progs changed from 4k to 16k, it also
can help (but for this, you must reformat fs)
For clean btrfs fi df /, you can try do:
btrfs bal start -f -sconvert=dup,soft -mconvert=dup,soft <path>
  Data, single: total=52.01GiB, used=49.29GiB
  System, DUP: total=8.00MiB, used=16.00KiB
  Metadata, DUP: total=1.50GiB, used=483.77MiB
Also disable compression or use without force option, if i properly
understand it also do additional fragmentation (filefrag helpfull).
Also, for defragmentation data (if you need defrag some files), you
can do it by "just copy-past", it create nodefragment copy

2014-06-05 1:45 GMT+03:00 Igor M <igork20@gmail.com>:
> On Thu, Jun 5, 2014 at 12:27 AM, Fajar A. Nugraha <list@fajar.net> wrote:
>> On Thu, Jun 5, 2014 at 5:15 AM, Igor M <igork20@gmail.com> wrote:
>>> Hello,
>>>
>>> Why btrfs becames EXTREMELY slow after some time (months) of usage ?
>>
>>> # btrfs fi show
>>> Label: none  uuid: b367812a-b91a-4fb2-a839-a3a153312eba
>>>         Total devices 1 FS bytes used 2.36TiB
>>>         devid    1 size 2.73TiB used 2.38TiB path /dev/sde
>>
>>> # btrfs fi df /mnt/old
>>> Data, single: total=2.36TiB, used=2.35TiB
>>
>> Is that the fs that is slow?
>>
>> It's almost full. Most filesystems would exhibit really bad
>> performance when close to full due to fragmentation issue (threshold
>> vary, but 80-90% full usually means you need to start adding space).
>> You should free up some space (e.g. add a new disk so it becomes
>> multi-device, or delete some files) and rebalance/defrag.
>>
>> --
>> Fajar
>
> Yes this one is slow. I know it's getting full I'm just copying to new
> disk (it will take days or even weeks!).
> It shouldn't be so much fragmented, data is mostly just added. But
> still, can reading became so slow just because fullness and
> fragmentation ?
> It just seems strange to me. If it would be 60Mb/s instead 130, but so
> much slower. I'll delete some files and see if it will be faster, but
> it will take hours to copy them to new disk.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Timofey.
