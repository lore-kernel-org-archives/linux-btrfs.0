Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36649 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbcLAIV3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 03:21:29 -0500
Received: by mail-qk0-f179.google.com with SMTP id n21so237038270qka.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 00:21:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <af47955b-19a4-7ff5-8d88-d94f40300e65@profihost.ag>
References: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
 <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com> <af47955b-19a4-7ff5-8d88-d94f40300e65@profihost.ag>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 1 Dec 2016 11:12:42 +0300
Message-ID: <CAA91j0WLve+R5VBHkb7p2NO_hTuLcRp5KvjsPmnZgOoF1MTWzA@mail.gmail.com>
Subject: Re: Metadata balance fails ENOSPC
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 1, 2016 at 10:49 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
...
>
> Custom 4.4 kernel with patches up to 4.10. But i already tried 4.9-rc7
> which does the same.
>
>
>>> # btrfs filesystem show /ssddisk/
>>> Label: none  uuid: a69d2e90-c2ca-4589-9876-234446868adc
>>>         Total devices 1 FS bytes used 305.67GiB
>>>         devid    1 size 500.00GiB used 500.00GiB path /dev/vdb1
>>>
>>> # btrfs filesystem usage /ssddisk/
>>> Overall:
>>>     Device size:                 500.00GiB
>>>     Device allocated:            500.00GiB
>>>     Device unallocated:            1.05MiB
>>
>> Drive is actually fully allocated so if Btrfs needs to create a new
>> chunk right now, it can't. However,
>
> Yes but there's lot of free space:
>     Free (estimated):            193.46GiB      (min: 193.46GiB)
>
> How does this match?
>
>
>> All three chunk types have quite a bit of unused space in them, so
>> it's unclear why there's a no space left error.
>>

I remember discussion that balance always tries to pre-allocate one
chunk in advance, and I believe there was patch to correct it but I am
not sure whether it was merged.

>> Try remounting with enoscp_debug, and then trigger the problem again,
>> and post the resulting kernel messages.
>
> With enospc debug it says:
> [39193.425682] BTRFS warning (device vdb1): no space to allocate a new
> chunk for block group 839941881856
> [39193.426033] BTRFS info (device vdb1): 1 enospc errors during balance
>
