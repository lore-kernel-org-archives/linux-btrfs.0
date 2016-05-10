Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35737 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbcEJKKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 06:10:20 -0400
Received: by mail-io0-f177.google.com with SMTP id d62so10088986iof.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 May 2016 03:10:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABUxAXmNaaboabeJNS59Oh9q6urxKf3beXiZ9Xk=NherKQVSbQ@mail.gmail.com>
References: <CABUxAXmNaaboabeJNS59Oh9q6urxKf3beXiZ9Xk=NherKQVSbQ@mail.gmail.com>
From: Zachary Bischof <zbischof@eecs.northwestern.edu>
Date: Tue, 10 May 2016 05:09:59 -0500
Message-ID: <CABUxAXnZpjZuHwDKCAaHFoOrejHVXiJJR4LO0-Oes+cdEta7Yg@mail.gmail.com>
Subject: Re: Parent transid failed wanted x found x + [3-5]
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shoot, sorry all. I am clearly too sleep deprived. I just realized
that I was misreading the transid errors, and that the journal was
ahead of the disk. Sorry for the mistake.

On Tue, May 10, 2016 at 3:23 AM, Zachary Bischof
<zbischof@eecs.northwestern.edu> wrote:
> Hi all,
>
> I'm a bit of an overly cautious newb when it comes to BTRFS. I've been
> experimenting with BTRFS on my home media server. I have all my
> important data backed up to two other boxes, so I'm not too worried
> about losing anything. I'm mostly just looking to learn and want to
> avoid wiping and transferring all the data back since it appears that
> the case should be resolvable.
>
> Anyway, the other day, one of my disks randomly disappeared, so smartd
> sent me an email saying:
>
> "The following warning/error was logged by the smartd daemon:
>
> Device: /dev/sdn [SAT], unable to open device"
>
> After this, the BTRFS device went to read only. I finished backing up
> any important data and rebooted. Before doing the reboot, I set my
> mount options in my fstab for that BTRFS device to
> "defaults,nofail,noatime,recovery,nospace_cache,clear_cache" (I
> appended the last three flags).
>
> The disk /dev/sdn appeared to come back upon reboot and was not
> missing, though I am tempted to replace it soon. After rebooting, the
> volume was able to successfully mount.
>
> However, the dmesg output was a bit scary. Here is an excerpt of the
> worrisome lines I saw:
>
> [   30.910714] BTRFS error (device sdf): parent transid verify failed
> on 15949201571840 wanted 26582 found 26387
> [   39.374823] BTRFS error (device sdf): parent transid verify failed
> on 15948808585216 wanted 26581 found 26385
> [   43.057670] BTRFS error (device sdf): parent transid verify failed
> on 15949359611904 wanted 26583 found 26388
> [   46.306913] BTRFS error (device sdf): parent transid verify failed
> on 15948514164736 wanted 26579 found 26384
> [   46.380649] BTRFS error (device sdf): parent transid verify failed
> on 15949359644672 wanted 26583 found 26388
> [   46.857965] BTRFS error (device sdf): parent transid verify failed
> on 15949350076416 wanted 26583 found 26388
> [  131.878427] BTRFS error (device sdf): parent transid verify failed
> on 15949373440000 wanted 26583 found 26388
> [  132.025501] BTRFS error (device sdf): parent transid verify failed
> on 15948655837184 wanted 26580 found 26384
> [  750.720037] BTRFS error (device sdf): parent transid verify failed
> on 14754648391680 wanted 26577 found 26445
> [  852.889827] BTRFS error (device sdf): parent transid verify failed
> on 14754499002368 wanted 26577 found 26445
> [  856.920655] BTRFS error (device sdf): parent transid verify failed
> on 14754822848512 wanted 26577 found 26446
> [  857.431038] BTRFS error (device sdf): parent transid verify failed
> on 13683875823616 wanted 26576 found 26444
> [  860.418258] BTRFS error (device sdf): parent transid verify failed
> on 15949023690752 wanted 26581 found 24058
> [  860.570057] BTRFS error (device sdf): parent transid verify failed
> on 13683881132032 wanted 26576 found 26381
> [  865.190648] BTRFS error (device sdf): parent transid verify failed
> on 15949215416320 wanted 26582 found 26387
> [  868.364139] BTRFS error (device sdf): parent transid verify failed
> on 15948959891456 wanted 26581 found 26386
> [  868.377273] BTRFS error (device sdf): parent transid verify failed
> on 15948474548224 wanted 26579 found 26384
> [  869.656851] BTRFS error (device sdf): parent transid verify failed
> on 15948596264960 wanted 26580 found 26384
> [  884.364491] BTRFS error (device sdf): parent transid verify failed
> on 15949359628288 wanted 26583 found 26388
> [  885.436263] BTRFS error (device sdf): parent transid verify failed
> on 15948787089408 wanted 26581 found 26385
> [  889.864500] BTRFS error (device sdf): parent transid verify failed
> on 15948783681536 wanted 26581 found 26385
>
> I was wondering what I should do for next steps? I've been seeing
> messages like this repeated a few times later in the dmesg log (full
> log is attached). I did a bit of Googling and searching on the mailing
> lists, but found it odd that most of the "wanted" transids in the
> journal were behind the "found" ones -- that is, the journal is behind
> the disk? In a couple cases, the journal appears to be ahead of the
> disk -- I'm guessing this is for the disk that had disappeared? I had
> trouble finding specifics on what to do in this case.
>
> Does mounting with the "-o recover" flag eventually fix this?
> Currently, the volume is mounted as r/w and seems to be working fine,
> but I'm trying to be cautious because of some bad experiences in the
> past. I started running a scrub but was wondering if that was a bad
> choice. I'm also hesitant to run btrfs-zero-log since I was able to
> mount the system (it seems like most advised against doing so in this
> case).
>
> Here's a description of my system (again, my full dmesg log is attached):
>
> Linux XXXXXX 4.5.2-1-ARCH #1 SMP PREEMPT Thu Apr 21 18:21:27 CEST 2016
> x86_64 GNU/Linux
>
> btrfs-progs v4.5.1
>
> Label: 'media'  uuid: 4b017b42-0ad6-4d81-9ae3-41e8a4705073
>         Total devices 16 FS bytes used 27.48TiB
>         devid    1 size 3.64TiB used 3.23TiB path /dev/sdi
>         devid    2 size 3.64TiB used 3.23TiB path /dev/sdj
>         devid    3 size 3.64TiB used 3.23TiB path /dev/sdk
>         devid    4 size 3.64TiB used 3.23TiB path /dev/sdl
>         devid    5 size 3.64TiB used 3.23TiB path /dev/sdq
>         devid    6 size 2.73TiB used 2.63TiB path /dev/sdr
>         devid    7 size 2.73TiB used 2.63TiB path /dev/sds
>         devid    8 size 1.82TiB used 1.81TiB path /dev/sdt
>         devid    9 size 1.82TiB used 1.81TiB path /dev/sdf
>         devid   10 size 1.82TiB used 1.81TiB path /dev/sdg
>         devid   11 size 1.82TiB used 1.81TiB path /dev/sda
>         devid   12 size 1.82TiB used 1.81TiB path /dev/sdh
>         devid   13 size 1.36TiB used 1.36TiB path /dev/sdm
>         devid   14 size 1.36TiB used 1.36TiB path /dev/sdn
>         devid   15 size 1.36TiB used 1.36TiB path /dev/sdo
>         devid   16 size 1.36TiB used 1.36TiB path /dev/sdp
>
> Data, RAID6: total=29.44TiB, used=27.44TiB
> System, RAID6: total=238.00MiB, used=1.84MiB
> Metadata, RAID6: total=36.81GiB, used=33.90GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> I realize I'm playing it a bit dangerous with 16 disks on RAID 6, but
> I have dual backups of all the most crucial data, this is partially
> just to play around with. Like I mentioned above, I'm interested for
> the learning experience and would like to avoid wiping and pulling
> from backups if possible.
>
> Cheers,
> Zachary
