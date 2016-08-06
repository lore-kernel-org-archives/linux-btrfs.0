Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:33021 "EHLO
	mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbcHFXQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 19:16:52 -0400
Received: by mail-ua0-f169.google.com with SMTP id 74so36751333uau.0
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Aug 2016 16:16:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
References: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Sat, 6 Aug 2016 19:09:40 -0400
Message-ID: <CA+X5Wn5uCAbfBgRM9D3is9_W8rJD_1tRnqUOONKUBxfy3BHi1A@mail.gmail.com>
Subject: Re: Unmountable and unrepairable BTRFS
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Depending on how important the data is, wanted to throw out the most
prudent first step is to get another set of drives equal to or bigger
than the ones of the bad volume, and image them using dd one by one as
block devices.  That gives you an undo button if recovery attempts go
wrong.  Always the best first step in data recovery, if there's not a
hardware failure involved.

Depending on the value of the data, it might not be practical as
you're looking at an expensive set of new drives.  Just wanted to
throw that out there, in case.

On Sat, Aug 6, 2016 at 6:36 PM, Chris McFaul <mcfaul@gmail.com> wrote:
> Hi, if anyone is able to help with a rather large (34TB of data on it)
> BTRFS RAID 6 I would be very grateful (pastebins below) - at this
> point I am only interested in recovery since I am obviously switching
> to RAID 1 once/if I get my data back.
>
> Many thanks in advance
>
> Chris
>
> Linux rockstor 4.6.0-1.el7.elrepo.x86_64 #1 SMP Mon May 16 10:54:52
> EDT 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs-progs v4.6
>
>
> Label: 'rockstor_rockstor'  uuid: af53ae5b-419e-4246-9366-611b710eead6
>         Total devices 1 FS bytes used 1.50GiB
>         devid    1 size 100.12GiB used 4.02GiB path /dev/sda3
>
>
> This one is fine:
>
> Label: '2'  uuid: 815fa02f-4871-4703-9208-03ccc48cc816
>         Total devices 9 FS bytes used 38.98TiB
>         devid    1 size 7.28TiB used 6.27TiB path /dev/sdg
>         devid    2 size 7.28TiB used 6.27TiB path /dev/sdh
>         devid    3 size 7.28TiB used 6.27TiB path /dev/sdi
>         devid    4 size 7.28TiB used 6.27TiB path /dev/sdj
>         devid    5 size 7.28TiB used 6.27TiB path /dev/sdc
>         devid    6 size 7.28TiB used 6.27TiB path /dev/sdd
>         devid    7 size 7.28TiB used 6.27TiB path /dev/sde
>         devid    8 size 7.28TiB used 6.27TiB path /dev/sdf
>         devid   11 size 7.28TiB used 6.27TiB path /dev/sdb
>
>
> this one wont mount:
>
> Label: '1'  uuid: ba29167b-e0cf-4029-92a4-f12a97f7e472
>         Total devices 11 FS bytes used 34.23TiB
>         devid    2 size 5.46TiB used 3.82TiB path /dev/sdk
>         devid    3 size 5.46TiB used 3.82TiB path /dev/sdl
>         devid    4 size 5.46TiB used 3.82TiB path /dev/sdm
>         devid    5 size 5.46TiB used 3.82TiB path /dev/sdn
>         devid    6 size 5.46TiB used 3.82TiB path /dev/sdo
>         devid    7 size 5.46TiB used 3.82TiB path /dev/sdp
>         devid    8 size 5.46TiB used 3.82TiB path /dev/sdq
>         devid    9 size 5.46TiB used 3.82TiB path /dev/sdr
>         devid   10 size 5.46TiB used 3.82TiB path /dev/sds
>         devid   11 size 5.46TiB used 3.82TiB path /dev/sdt
>         devid   12 size 5.46TiB used 3.82TiB path /dev/sdu
>
> full dmesg : http://pastebin.com/xgwfkGum
>
> trying to mount: http://pastebin.com/DSfHsda6
>
> btrfs restore: http://pastebin.com/EAuPW1pg
>
> btrfs check: http://pastebin.com/FjM7amEv
>
> finding roots: http://pastebin.com/SBsn12d9
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
