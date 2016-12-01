Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:63945 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751676AbcLALzx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 06:55:53 -0500
Subject: Re: Metadata balance fails ENOSPC
To: Andrei Borzenkov <arvidjaar@gmail.com>
References: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
 <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com>
 <af47955b-19a4-7ff5-8d88-d94f40300e65@profihost.ag>
 <CAA91j0WLve+R5VBHkb7p2NO_hTuLcRp5KvjsPmnZgOoF1MTWzA@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <f4f9b69c-ae3b-69e3-3dbd-3173b4627bef@profihost.ag>
Date: Thu, 1 Dec 2016 12:55:48 +0100
MIME-Version: 1.0
In-Reply-To: <CAA91j0WLve+R5VBHkb7p2NO_hTuLcRp5KvjsPmnZgOoF1MTWzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 01.12.2016 um 09:12 schrieb Andrei Borzenkov:
> On Thu, Dec 1, 2016 at 10:49 AM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
> ...
>>
>> Custom 4.4 kernel with patches up to 4.10. But i already tried 4.9-rc7
>> which does the same.
>>
>>
>>>> # btrfs filesystem show /ssddisk/
>>>> Label: none  uuid: a69d2e90-c2ca-4589-9876-234446868adc
>>>>         Total devices 1 FS bytes used 305.67GiB
>>>>         devid    1 size 500.00GiB used 500.00GiB path /dev/vdb1
>>>>
>>>> # btrfs filesystem usage /ssddisk/
>>>> Overall:
>>>>     Device size:                 500.00GiB
>>>>     Device allocated:            500.00GiB
>>>>     Device unallocated:            1.05MiB
>>>
>>> Drive is actually fully allocated so if Btrfs needs to create a new
>>> chunk right now, it can't. However,
>>
>> Yes but there's lot of free space:
>>     Free (estimated):            193.46GiB      (min: 193.46GiB)
>>
>> How does this match?
>>
>>
>>> All three chunk types have quite a bit of unused space in them, so
>>> it's unclear why there's a no space left error.
>>>
> 
> I remember discussion that balance always tries to pre-allocate one
> chunk in advance, and I believe there was patch to correct it but I am
> not sure whether it was merged.

Is there otherwise a possibility to make the free space unallocated again?

Stefan

> 
>>> Try remounting with enoscp_debug, and then trigger the problem again,
>>> and post the resulting kernel messages.
>>
>> With enospc debug it says:
>> [39193.425682] BTRFS warning (device vdb1): no space to allocate a new
>> chunk for block group 839941881856
>> [39193.426033] BTRFS info (device vdb1): 1 enospc errors during balance
>>
