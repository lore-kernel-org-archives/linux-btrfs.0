Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:62805 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaDVVwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 17:52:44 -0400
Received: by mail-oa0-f44.google.com with SMTP id n16so108394oag.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 14:52:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6W84JS1-rzAJfGyPmXMTPLqLN=0UbqefRa-BoqgyzFruhJ_g@mail.gmail.com>
References: <CAG6W84JS1-rzAJfGyPmXMTPLqLN=0UbqefRa-BoqgyzFruhJ_g@mail.gmail.com>
Date: Tue, 22 Apr 2014 23:52:43 +0200
Message-ID: <CAG6W84JEBg3FRDn6Q9m-cKgA9L=wZP0PQxJTTVXSxVn73pEotA@mail.gmail.com>
Subject: Re: convert from RAID5: enospc errors during balance (500 GB free on
 each device)
From: Arjen Nienhuis <a.g.nienhuis@gmail.com>
To: linux-btrfs@vger.kernel.org, 1i5t5.duncan@cox.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Did you try running another balance soft?

I tried a few. The only thing that happens is that more empty blocks
get allocated. I also tried convert=single,profiles=raid5. I ended up
with a few empty 'single' blocks. (The empty blocks could be discarded
with balance usage=0)

> Meanwhile... kernel v3.13, btrfs-progs v3.12.  You're just a bit behind,
> as kernel 3.14 is out (and 3.15 is rc2), and btrfs-progs is 3.14
> (possibly 3.14.1, I've not updated in a week or so).  When you run into
> problems, consider updating before reporting, as there are still very
> real fixes going into each new version, and they might just fix the
> problem you're reporting.

I just upgraded to Ubuntu 14.04. I can try a kernel ppa but I didn't
find anything in the about this on the wiki.

On Mon, Apr 21, 2014 at 8:32 AM, Arjen Nienhuis <a.g.nienhuis@gmail.com> wrote:
> I experimented with RAID5, but now I want to get rid of it:
>
> $ sudo btrfs balance start -dconvert=raid1,soft -v /
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x300): converting, target=16, soft is on
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
>
> This is in dmesg:
>
> [  166.799139] btrfs: relocating block group 13368320589824 flags 129
> [  248.927524] btrfs: relocating block group 13338255818752 flags 129
> ...
> [  409.184588] btrfs: relocating block group 11607454253056 flags 129
> [  410.528075] btrfs: relocating block group 11605306769408 flags 129
> [  411.957809] btrfs: 62 enospc errors during balance
>
> Extra info:
> Data, RAID1: total=3.26TiB, used=3.25TiB
> Data, RAID5: total=124.00GiB, used=123.90GiB
> System, RAID1: total=32.00MiB, used=508.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=9.00GiB, used=7.97GiB
> Label: data  uuid: 93be47ab-af7a-4329-8a6c-c6ff220060b0
>         Total devices 3 FS bytes used 3.38TiB
>         devid    1 size 1.82TiB used 1.22TiB path /dev/sdd
>         devid    2 size 3.64TiB used 2.63TiB path /dev/sdb
>         devid    6 size 3.64TiB used 2.87TiB path /dev/sdc
>
> Btrfs v3.12
>
> Linux maxi 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC
> 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> I tried scrub (no errors) and I cleared the free space cache. Nothing worked.
>
> Now I'm doing full balance (without 'soft') but that will take days.
