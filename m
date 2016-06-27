Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36757 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcF0RhZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 13:37:25 -0400
Received: by mail-io0-f174.google.com with SMTP id s63so154660331ioi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 10:37:25 -0700 (PDT)
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
To: Chris Murphy <lists@colorremedies.com>, Nick Austin <nick@smartaustin.com>
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
 <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com>
 <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <016f057b-b7a1-cccf-ca8a-cfe0e1d4341a@gmail.com>
Date: Mon, 27 Jun 2016 13:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-27 13:29, Chris Murphy wrote:
> On Sun, Jun 26, 2016 at 10:02 PM, Nick Austin <nick@smartaustin.com> wrote:
>> On Sun, Jun 26, 2016 at 8:57 PM, Nick Austin <nick@smartaustin.com> wrote:
>>> sudo btrfs fi show /mnt/newdata
>>> Label: '/var/data'  uuid: e4a2eb77-956e-447a-875e-4f6595a5d3ec
>>>         Total devices 4 FS bytes used 8.07TiB
>>>         devid    1 size 5.46TiB used 2.70TiB path /dev/sdg
>>>         devid    2 size 5.46TiB used 2.70TiB path /dev/sdl
>>>         devid    3 size 5.46TiB used 2.70TiB path /dev/sdm
>>>         devid    4 size 5.46TiB used 2.70TiB path /dev/sdx
>>
>> It looks like fi show has bad data:
>>
>> When I start heavy IO on the filesystem (running rsync -c to verify the data),
>> I notice zero IO on the bad drive I told btrfs to replace, and lots of IO to the
>>  expected replacement.
>>
>> I guess some metadata is messed up somewhere?
>>
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           25.19    0.00    7.81   28.46    0.00   38.54
>>
>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> sdg             437.00     75168.00      1792.00      75168       1792
>> sdl             443.00     76064.00      1792.00      76064       1792
>> sdm             438.00     75232.00      1472.00      75232       1472
>> sdw             443.00     75680.00      1856.00      75680       1856
>> sdx               0.00         0.00         0.00          0          0
>
> There's reported some bugs with 'btrfs replace' and raid56, but I
> don't know the exact nature of those bugs, when or how they manifest.
> It's recommended to fallback to use 'btrfs add' and then 'btrfs
> delete' but you have other issues going on also.
One other thing to mention, if the device is failing, _always_ add '-r' 
to the replace command line.  This will tell it to avoid reading from 
the device being replaced (in raid1 or raid10 mode, it will pull from 
the other mirror, in raid5/6 mode, it will recompute the block from 
parity and compare to the stored checksums (which in turn means that 
this _will_ be slower on raid5/6 than regular repalce)).  Link resets 
and other issues that cause devices to disappear become more common the 
more damaged a disk is, so avoiding reading from it becomes more 
important too, because just reading from a disk puts stress on it.
