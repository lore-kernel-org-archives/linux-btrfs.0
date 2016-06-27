Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35585 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbcF0R3w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 13:29:52 -0400
Received: by mail-oi0-f48.google.com with SMTP id r2so210038536oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 10:29:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com>
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
 <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 11:29:51 -0600
Message-ID: <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
To: Nick Austin <nick@smartaustin.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 26, 2016 at 10:02 PM, Nick Austin <nick@smartaustin.com> wrote:
> On Sun, Jun 26, 2016 at 8:57 PM, Nick Austin <nick@smartaustin.com> wrote:
>> sudo btrfs fi show /mnt/newdata
>> Label: '/var/data'  uuid: e4a2eb77-956e-447a-875e-4f6595a5d3ec
>>         Total devices 4 FS bytes used 8.07TiB
>>         devid    1 size 5.46TiB used 2.70TiB path /dev/sdg
>>         devid    2 size 5.46TiB used 2.70TiB path /dev/sdl
>>         devid    3 size 5.46TiB used 2.70TiB path /dev/sdm
>>         devid    4 size 5.46TiB used 2.70TiB path /dev/sdx
>
> It looks like fi show has bad data:
>
> When I start heavy IO on the filesystem (running rsync -c to verify the data),
> I notice zero IO on the bad drive I told btrfs to replace, and lots of IO to the
>  expected replacement.
>
> I guess some metadata is messed up somewhere?
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           25.19    0.00    7.81   28.46    0.00   38.54
>
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sdg             437.00     75168.00      1792.00      75168       1792
> sdl             443.00     76064.00      1792.00      76064       1792
> sdm             438.00     75232.00      1472.00      75232       1472
> sdw             443.00     75680.00      1856.00      75680       1856
> sdx               0.00         0.00         0.00          0          0

There's reported some bugs with 'btrfs replace' and raid56, but I
don't know the exact nature of those bugs, when or how they manifest.
It's recommended to fallback to use 'btrfs add' and then 'btrfs
delete' but you have other issues going on also.

Devices dropping off and being renamed is something btrfs, in my
experience, does not handle well at all. The very fact the hardware is
dropping off and coming back is bad, so you really need to get that
sorted out as a prerequisite no matter what RAID technology you're
using.

First advice, make a backup. Don't change the volume further until
you've done this. Each attempt to make the volume healthy again
carries risks of totally breaking it and losing the ability to mount
it. So as long as it's mounted, take advantage of that. Pretend the
very next repair attempt will break the volume, and make your backup
accordingly.

Next is to decide to what degree you want to salvage this volume and
keep using Btrfs raid56 despite the risks (it's still rather
experimental, and in particular some things have been realized on the
list in the last week especially that make it not recommended, except
by people willing to poke it with a stick and learn how many more
bodies can be found with the current implementation) or if you just
want to migrate it over to something like XFS on mdadm or LVM raid 5
as soon as possible?

There's also the obligatory notice that applies to all Linux software
raid implementations which is to discover if you have a very common
misconfiguration that enhances the chance of data loss if the volume
ever goes degraded and you need to rebuild with a new drive:

smartctl -l scterc <dev>
cat /sys/block/<dev>/device/timeout

The first value must be less than the second. Note the first value is
in deciseconds, the second is in seconds. And either 'unsupported' or
'unset' translates into a vague value that could be as high as 180
seconds.



-- 
Chris Murphy
