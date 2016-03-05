Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39716 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbcCEOjh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 09:39:37 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acDMk-0002Ys-L7
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 15:39:34 +0100
Date: Sat, 5 Mar 2016 15:39:34 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160305143934.GE1902@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 03, 2016 at 02:28:36AM +0200, Dāvis Mosāns wrote:
> I've same issue, 4.4.3 kernel on Arch Linux
> 
> $ sudo btrfs fi show /mnt/fs/
> Label: 'fs'  uuid: a3c66d25-2c25-40e5-a827-5f7e5208e235
>         Total devices 1 FS bytes used 396.94GiB
>         devid    1 size 435.76GiB used 435.76GiB path /dev/sdi2
> 
> $ sudo btrfs fi df /mnt/fs/
> Data, single: total=416.70GiB, used=390.62GiB
> System, DUP: total=32.00MiB, used=96.00KiB
> Metadata, DUP: total=9.50GiB, used=6.32GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> $ sudo btrfs fi usage /mnt/fs/
> Overall:
>     Device size:                 435.76GiB
>     Device allocated:            435.76GiB
>     Device unallocated:            1.00MiB
>     Device missing:                  0.00B
>     Used:                        403.26GiB
>     Free (estimated):             26.07GiB      (min: 26.07GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:416.70GiB, Used:390.62GiB
>    /dev/sdi2     416.70GiB
> 
> Metadata,DUP: Size:9.50GiB, Used:6.32GiB
>    /dev/sdi2      19.00GiB
> 
> System,DUP: Size:32.00MiB, Used:96.00KiB
>    /dev/sdi2      64.00MiB
> 
> Unallocated:
>    /dev/sdi2       1.00MiB

http://paste.ubuntu.com/15292589/ has another log of mine with btrfs
fi usage calls as well, just in case this helps.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
