Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:58542 "EHLO
        mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752586AbdEIA13 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 May 2017 20:27:29 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
Subject: Re: File system is oddly full after kernel upgrade, balance doesn't
 help
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhk=Gf7Qejs6zit+hGdFNeNSPexJZ=jgCY1CADt6xoNHhA@mail.gmail.com>
 <pan$bea71$c88f268f$3fe2f55a$caf61eb5@cox.net>
 <CAE8gLhkjgOzRgJXKL=az8Mw8njCg+m6d0zyH8WmDPNx_-Wp9Ow@mail.gmail.com>
Message-ID: <a1468845-6974-9730-b338-c7bcb0f144cf@isoar.ca>
Date: Mon, 8 May 2017 19:45:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8gLhkjgOzRgJXKL=az8Mw8njCg+m6d0zyH8WmDPNx_-Wp9Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-28 13:15, MegaBrutal wrote:
> Hello,
>
> Of course I can't retrieve the data from before the balance, but here
> is the data from now:
>
> root@vmhost:~# btrfs fi show /tmp/mnt/curlybrace
> Label: 'curlybrace'  uuid: f471bfca-51c4-4e44-ac72-c6cd9ccaf535
>      Total devices 1 FS bytes used 752.38MiB
>      devid    1 size 2.00GiB used 1.90GiB path
> /dev/mapper/vmdata--vg-lxc--curlybrace
>
> root@vmhost:~# btrfs fi df /tmp/mnt/curlybrace
> Data, single: total=773.62MiB, used=714.82MiB
> System, DUP: total=8.00MiB, used=16.00KiB
> Metadata, DUP: total=577.50MiB, used=37.55MiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> root@vmhost:~# btrfs fi usage /tmp/mnt/curlybrace
> Overall:
>      Device size:           2.00GiB
>      Device allocated:           1.90GiB
>      Device unallocated:         103.38MiB
>      Device missing:             0.00B
>      Used:             789.94MiB
>      Free (estimated):         162.18MiB    (min: 110.50MiB)
>      Data ratio:                  1.00
>      Metadata ratio:              2.00
>      Global reserve:         512.00MiB    (used: 0.00B)
>
> Data,single: Size:773.62MiB, Used:714.82MiB
>     /dev/mapper/vmdata--vg-lxc--curlybrace     773.62MiB
>
> Metadata,DUP: Size:577.50MiB, Used:37.55MiB
>     /dev/mapper/vmdata--vg-lxc--curlybrace       1.13GiB
>
> System,DUP: Size:8.00MiB, Used:16.00KiB
>     /dev/mapper/vmdata--vg-lxc--curlybrace      16.00MiB
>
> Unallocated:
>     /dev/mapper/vmdata--vg-lxc--curlybrace     103.38MiB
>
>
> So... if I sum the data, metadata, and the global reserve, I see why
> only ~170 MB is left. I have no idea, however, why the global reserve
> sneaked up to 512 MB for such a small file system, and how could I
> resolve this situation. Any ideas?
>
>
> MegaBrutal

Total amateur here just jumping in, so feel free to ignore me, but what 
caught my eye was the small device size.

I've had issues with BTRFS on small devices (4GiB & 8GiB), forcing me to 
use other filesystems on them (like EXT4, which has a smaller allocation 
size).  Issues being both ENOSPC and miscellaneous other strange errors 
(which may have been fixed by now).

My theory being that the 1GiB data and 256MiB metadata chunk sizes are 
significant on such small devices.

I don't know if there is an official recommended minimum device size, 
but keeping 4GiB or more free seems to work most of the time for my 
usage patterns.

~~AEM
