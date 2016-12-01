Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:22345 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751414AbcLAHvJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 02:51:09 -0500
Subject: Re: Metadata balance fails ENOSPC
To: Chris Murphy <lists@colorremedies.com>
References: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
 <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <af47955b-19a4-7ff5-8d88-d94f40300e65@profihost.ag>
Date: Thu, 1 Dec 2016 08:49:42 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 01.12.2016 um 00:02 schrieb Chris Murphy:
> On Wed, Nov 30, 2016 at 2:03 PM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>> Hello,
>>
>> # btrfs balance start -v -dusage=0 -musage=1 /ssddisk/
>> Dumping filters: flags 0x7, state 0x0, force is off
>>   DATA (flags 0x2): balancing, usage=0
>>   METADATA (flags 0x2): balancing, usage=1
>>   SYSTEM (flags 0x2): balancing, usage=1
>> ERROR: error during balancing '/ssddisk/': No space left on device
>> There may be more info in syslog - try dmesg | tail
> 
> You haven't provided kernel messages at the time of the error.

Kernel Message:
[  429.107723] BTRFS info (device vdb1): 1 enospc errors during balance

> Also useful is the kernel version.

Custom 4.4 kernel with patches up to 4.10. But i already tried 4.9-rc7
which does the same.


>> # btrfs filesystem show /ssddisk/
>> Label: none  uuid: a69d2e90-c2ca-4589-9876-234446868adc
>>         Total devices 1 FS bytes used 305.67GiB
>>         devid    1 size 500.00GiB used 500.00GiB path /dev/vdb1
>>
>> # btrfs filesystem usage /ssddisk/
>> Overall:
>>     Device size:                 500.00GiB
>>     Device allocated:            500.00GiB
>>     Device unallocated:            1.05MiB
> 
> Drive is actually fully allocated so if Btrfs needs to create a new
> chunk right now, it can't. However,

Yes but there's lot of free space:
    Free (estimated):            193.46GiB      (min: 193.46GiB)

How does this match?


> All three chunk types have quite a bit of unused space in them, so
> it's unclear why there's a no space left error.
> 
> Try remounting with enoscp_debug, and then trigger the problem again,
> and post the resulting kernel messages.

With enospc debug it says:
[39193.425682] BTRFS warning (device vdb1): no space to allocate a new
chunk for block group 839941881856
[39193.426033] BTRFS info (device vdb1): 1 enospc errors during balance

Greets,
Stefan
