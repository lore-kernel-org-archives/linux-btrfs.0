Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:65291 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbaDXRQJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 13:16:09 -0400
Received: by mail-vc0-f171.google.com with SMTP id lg15so3288757vcb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 10:16:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140423225302.GC2391@carfax.org.uk>
References: <CACZaor2-NMo2PeZ=pO0ygz=VjE4JDoORp4Np8unVGd3buwKBxw@mail.gmail.com>
	<20140423225302.GC2391@carfax.org.uk>
Date: Thu, 24 Apr 2014 13:16:08 -0400
Message-ID: <CACZaor1F6rAdtUjQ+K97GOfwXu2-EXctLcfYauKyzx+xNYDytA@mail.gmail.com>
Subject: Re: raid6, disks of different sizes, ENOSPC errors despite having
 plenty of space
From: Sergey Ivanyuk <modemch@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Sergey Ivanyuk <modemch@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, this makes sense. I freed up some space and the re-balance
back to raid1 is now running (I had to run 'btrfs balance -dusage=5'
before some free space actually became available).

Filed the other issue as https://bugzilla.kernel.org/show_bug.cgi?id=74761 .

On Wed, Apr 23, 2014 at 6:53 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Apr 23, 2014 at 05:04:10PM -0400, Sergey Ivanyuk wrote:
>> Hi,
>>
>> I have a filesystem that I've converted to raid6 from raid1, on 4 drives (I
>> have another copy of the data):
>>
>>         Total devices 4 FS bytes used 924.64GiB
>>         devid    1 size 1.82TiB used 474.00GiB path /dev/sdd
>>         devid    2 size 465.76GiB used 465.76GiB path /dev/sda
>>         devid    3 size 465.76GiB used 465.76GiB path /dev/sdb
>>         devid    4 size 465.76GiB used 465.73GiB path /dev/sdc
>>
>> Data, RAID6: total=924.00GiB, used=923.42GiB
>> System, RAID1: total=32.00MiB, used=208.00KiB
>> Metadata, RAID1: total=1.70GiB, used=1.28GiB
>> Metadata, DUP: total=384.00MiB, used=252.13MiB
>> unknown, single: total=512.00MiB, used=0.00
>>
>>
>> Recent btrfs-progs built from source, kernel 3.15.0-rc2 on armv7l. Despite
>> having plenty of space left on the larger drive, attempting to copy more
>> data onto the filesystem results in a kworker process pegged at 100% CPU
>> for a very long time (10s of minutes), at which point the writes proceed
>> for some time, and the process repeats until the eventual "No space left on
>> device" error. Balancing fails with the same error, even if attempting to
>> convert back to raid1.
>>
>> I realize that this likely has something to do with the disparity between
>> device sizes, and per the wiki a fixed-width stripe may help, though I'm
>> not sure if it's possible to change the stripe width in my situation, since
>> I can't rebalance. Is there anything I can do to get this filesystem back
>> to writable state?
>
>    With those device sizes, yes, you're going to have limits on the
> available data you can store -- with RAID-6, it'll be 465.76*(4-2) =
> 931.52 GB (less metadata space), so your conclusion above is indeed
> correct.
>
>    We don't have the fixed-width stripe feature implemented yet, which
> probably explains why you can't use it. :) You can play with an
> approximation of the consequences, once the feature is there, at
> http://carfax.org.uk/btrfs-usage/ . Without that feature, though,
> there's not much you can do to improve the situation. What might help
> in converting back to RAID-1 is adding a small device to the FS
> temporarily before doing the conversion, and then removing it again
> afterwards.
>
>> Also, here's a stack trace for the stuck kworker process, which appears to
>> be a bug since it does this for a very long time:
>
>    This is probably something different.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>      --- Computer Science is not about computers,  any more than ---
>                      astronomy is about telescopes.
