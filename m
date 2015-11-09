Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33746 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbKILMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 06:12:40 -0500
Received: by iodd200 with SMTP id d200so182268488iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 03:12:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1446938562.7297.7.camel@scientia.net>
References: <1446938562.7297.7.camel@scientia.net>
Date: Mon, 9 Nov 2015 11:12:39 +0000
Message-ID: <CAL3q7H5EXeEVT9Fb3nZqyCe2b0f7gk53K5aYs-04y5Ym7H_hvw@mail.gmail.com>
Subject: Re: strange "No space left on device"
From: Filipe Manana <fdmanana@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 7, 2015 at 11:22 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> I just repeatedly did the following twice on a ~8GB USB stick, under
> Debian sid (ergo kernel 4.2.0-1-amd64, btrfsprogs 4.2.2-1).
>
> First, created some GPT on the stick:
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048         1048575   511.0 MiB   EF02  BIOS boot partition
>    2         1048576         3145727   1024.0 MiB  8300  Linux filesystem
>    3         3145728         4194303   512.0 MiB   8300  Linux filesystem
>    4         4194304         6291455   1024.0 MiB  8300  Linux filesystem
>    5         6291456        15687644   4.5 GiB     8300  Linux filesystem
>
>
> Then filesystems:
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-main /dev/sdb2
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              boot-main
> UUID:               150ee9fb-c650-4b5b-8f64-606e589e429a
> Node size:          16384
> Sector size:        4096
> Filesystem size:    1.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              59.19MiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     1.00GiB  /dev/sdb2
>
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-data /dev/sdb3
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              boot-data
> UUID:               b1c1fc77-c965-4f0c-a2b5-44a301fd8772
> Node size:          16384
> Sector size:        4096
> Filesystem size:    1.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              59.19MiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     1.00GiB  /dev/sdb3
>
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-archive
> /dev/sdb4
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              boot-archive
> UUID:               a063cf3b-0322-4ec7-a8c1-2dabecad9f57
> Node size:          16384
> Sector size:        4096
> Filesystem size:    1.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              59.19MiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     1.00GiB  /dev/sdb4
>
> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-rescue /dev/sdb5
> btrfs-progs v4.2.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Label:              boot-rescue
> UUID:               104b7bc3-3b8c-4a08-b0a6-9172ed664e68
> Node size:          16384
> Sector size:        4096
> Filesystem size:    3.98GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP             211.75MiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     3.98GiB  /dev/sdb5
>
>
>
> No errors in the kernel log.
>
>
>
> Then I got usage info:
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage data/
> Overall:
>     Device size:                   1.00GiB
>     Device allocated:            126.38MiB
>     Device unallocated:          897.62MiB
>     Device missing:                  0.00B
>     Used:                        256.00KiB
>     Free (estimated):            905.62MiB      (min: 456.81MiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:               16.00MiB      (used: 0.00B)
>
> Data,single: Size:8.00MiB, Used:0.00B
>    /dev/sdb3       8.00MiB
>
> Metadata,DUP: Size:51.19MiB, Used:112.00KiB
>    /dev/sdb3     102.38MiB
>
> System,DUP: Size:8.00MiB, Used:16.00KiB
>    /dev/sdb3      16.00MiB
>
> Unallocated:
>    /dev/sdb3     897.62MiB
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage main/
> Overall:
>     Device size:                   1.00GiB
>     Device allocated:            126.38MiB
>     Device unallocated:          897.62MiB
>     Device missing:                  0.00B
>     Used:                        256.00KiB
>     Free (estimated):            905.62MiB      (min: 456.81MiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:               16.00MiB      (used: 0.00B)
>
> Data,single: Size:8.00MiB, Used:0.00B
>    /dev/sdb2       8.00MiB
>
> Metadata,DUP: Size:51.19MiB, Used:112.00KiB
>    /dev/sdb2     102.38MiB
>
> System,DUP: Size:8.00MiB, Used:16.00KiB
>    /dev/sdb2      16.00MiB
>
> Unallocated:
>    /dev/sdb2     897.62MiB
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage rescue/
> Overall:
>     Device size:                   3.98GiB
>     Device allocated:            431.50MiB
>     Device unallocated:            3.56GiB
>     Device missing:                  0.00B
>     Used:                        320.00KiB
>     Free (estimated):              3.57GiB      (min: 1.79GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:               16.00MiB      (used: 0.00B)
>
> Data,single: Size:8.00MiB, Used:64.00KiB
>    /dev/sdb5       8.00MiB
>
> Metadata,DUP: Size:203.75MiB, Used:112.00KiB
>    /dev/sdb5     407.50MiB
>
> System,DUP: Size:8.00MiB, Used:16.00KiB
>    /dev/sdb5      16.00MiB
>
> Unallocated:
>    /dev/sdb5       3.56GiB
>
>
>
> Still all fine.
>
> Now I write to one of the filesystems (main at first, that still works)
> but then when I cp -a from another btrfs to data:
> cp: error writing ‘data/SHA512-sums.OLD’: No space left on device
> cp: failed to extend ‘data/SHA512-sums.OLD’: No space left on device
> cp: error writing ‘data/SHA512-sums’: No space left on device
> cp: failed to extend ‘data/SHA512-sums’: No space left on device
>
> (these files are just a few bytes large)
> On the target fs, they're there but all 0 bytes large.
>
> (btw: I've aliased cp to cp --reflink=auto
>
>
> When I now repeat the usage info:
> root@heisenberg:/data/SSS/boot# btrfs filesystem usage data
> Overall:
>     Device size:                   1.00GiB
>     Device allocated:            118.38MiB
>     Device unallocated:          905.62MiB
>     Device missing:                  0.00B
>     Used:                        256.00KiB
>     Free (estimated):              8.00EiB      (min: 8.00EiB)
>     Data ratio:                       -nan
>     Metadata ratio:                   2.00
>     Global reserve:               16.00MiB      (used: 0.00B)
>
> Metadata,DUP: Size:51.19MiB, Used:112.00KiB
>    /dev/sdc3     102.38MiB
>
> System,DUP: Size:8.00MiB, Used:16.00KiB
>    /dev/sdc3      16.00MiB
>
> Unallocated:
>    /dev/sdc3     905.62MiB
>
> It get's bogus... at least the Free space shows 8 EiB (if wishes were
> horses)...

You're likely hitting a bug introduced in kernel 4.2, and it got fixed
in 4.3 by:  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6af3e3adcac595a683bb55299a907d7d1ad61ab3

Because there are no data block groups you get the -nan data ratio
there and the 8EiB, which is a problem in the tools that don't (or
didn't, maybe they were fixed in the meanwhile) expect to find a
filesystem without data block groups. Now what matters the most is the
kernel bug, which is what leads to the ENOSPC errors when attempting
to write data (even a 1 byte file).

Just try a 4.3 kernel, or a 4.2 kernel + that patch and confirm it
fixes the issue.

thanks

>
> Still no error in kernel logs:
>  3401.934514] BTRFS: device label boot-rescue devid 1 transid 8
> /dev/sdc5
> [ 3401.985858] BTRFS: device label boot-main devid 1 transid 8
> /dev/sdc2
> [ 3401.988601] BTRFS: device label boot-data devid 1 transid 9
> /dev/sdc3
> [ 3401.997370] BTRFS: device label boot-archive devid 1 transid 9
> /dev/sdc4
> [ 3403.721091] BTRFS info (device sdc3): disk space caching is enabled
> [ 3403.721098] BTRFS: has skinny extents
> [ 3413.964033] BTRFS info (device sdb3): disk space caching is enabled
> [ 3413.964042] BTRFS: has skinny extents
> [ 3522.902309] BTRFS info (device sdb3): disk space caching is enabled
> [ 3522.902314] BTRFS: has skinny extents
> [ 3525.055653] BTRFS info (device sdc3): disk space caching is enabled
> [ 3525.055659] BTRFS: has skinny extents
>
>
> btrfs check doesn't show errors either.
>
>
> After a balance, i can copy again, even though the usage still shows 8
> EiB for a while...
>
>
> Anyway how can it happen, that on a fresh btrfs with no files at all a
> balance is necessary?
> Or is there some deeper corruption going on here?
>
>
> Thanks,
> Chris.



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
