Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:35784 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcK3XCa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 18:02:30 -0500
Received: by mail-yw0-f178.google.com with SMTP id i145so171488238ywg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 15:02:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
References: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 30 Nov 2016 16:02:29 -0700
Message-ID: <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com>
Subject: Re: Metadata balance fails ENOSPC
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 2:03 PM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> Hello,
>
> # btrfs balance start -v -dusage=0 -musage=1 /ssddisk/
> Dumping filters: flags 0x7, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=0
>   METADATA (flags 0x2): balancing, usage=1
>   SYSTEM (flags 0x2): balancing, usage=1
> ERROR: error during balancing '/ssddisk/': No space left on device
> There may be more info in syslog - try dmesg | tail

You haven't provided kernel messages at the time of the error.

Also useful is the kernel version.



>
> # btrfs filesystem show /ssddisk/
> Label: none  uuid: a69d2e90-c2ca-4589-9876-234446868adc
>         Total devices 1 FS bytes used 305.67GiB
>         devid    1 size 500.00GiB used 500.00GiB path /dev/vdb1
>
> # btrfs filesystem usage /ssddisk/
> Overall:
>     Device size:                 500.00GiB
>     Device allocated:            500.00GiB
>     Device unallocated:            1.05MiB

Drive is actually fully allocated so if Btrfs needs to create a new
chunk right now, it can't. However,



>
> Data,single: Size:483.97GiB, Used:298.18GiB
>    /dev/vdb1     483.97GiB
>
> Metadata,single: Size:16.00GiB, Used:7.51GiB
>    /dev/vdb1      16.00GiB
>
> System,single: Size:32.00MiB, Used:144.00KiB
>    /dev/vdb1      32.00MiB

All three chunk types have quite a bit of unused space in them, so
it's unclear why there's a no space left error.

Try remounting with enoscp_debug, and then trigger the problem again,
and post the resulting kernel messages.


-- 
Chris Murphy
