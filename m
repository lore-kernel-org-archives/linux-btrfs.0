Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38239 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdARSVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 13:21:06 -0500
Received: by mail-wm0-f54.google.com with SMTP id r144so38749486wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 10:21:05 -0800 (PST)
Received: from localhost ([108.63.177.210])
        by smtp.gmail.com with ESMTPSA id f67sm46993593wmd.13.2017.01.18.10.21.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Jan 2017 10:21:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Steven Hum <sdothum@gmail.com>
To: linux-btrfs@vger.kernel.org
References: <148475784092.5560.1270748127213800815@luna>
In-Reply-To: <148475784092.5560.1270748127213800815@luna>
Message-ID: <148476361856.4724.1672841945552712109@luna>
Subject: Re: Cannot mount volume after balance crash (skip_balance mount also failed)
Date: Wed, 18 Jan 2017 13:20:18 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Attempted to mount vol with skip_balance option. This also resulted in
the system hanging. dmesg output can be found at url

http://cwillu.com:8080/108.63.177.210/2

which looks similar (to me).

Is there any further recourse I might consider or is the fs effectively
DOA in spite of passing btrfs check?

Regards,
Steven

Quoting Steven Hum (2017-01-18 11:44:00)
> Added 2 drives to my RAID10, then ran btrfs balance. The system appears
> to have crashed after several hours (I was ssh'd into that server at the
> time on my local network). When I rebooted the Arch system, I ran btrfs
> check and no errors were reported.
>
> However, attempting to mount the vol hangs the system. Trying to mount
> the system in recovery mode also hangs the system.
>
>     ─────  uname -a                                                                                                                             ~
> Linux luna 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET 2016 x86_64 GNU/Linux
>     ─────     btrfs --version                                                                                                                   ~
> btrfs-progs v4.9
>     ─────     btrfs fi show                                                                                                                     ~
> Label: 'Archlinux'  uuid: e5ee12ac-7fb3-4e73-b9b2-a5cfb35145ae
>         Total devices 1 FS bytes used 66.41GiB
>         devid    1 size 111.24GiB used 111.24GiB path /dev/sda2
>
> Label: 'Share'  uuid: 9102bb33-49ad-4baf-a88d-1c7622bff938
>         Total devices 6 FS bytes used 4.20TiB
>         devid    1 size 2.73TiB used 1.90TiB path /dev/sdc
>         devid    2 size 2.73TiB used 1.90TiB path /dev/sdd
>         devid    3 size 2.73TiB used 1.90TiB path /dev/sde
>         devid    4 size 2.73TiB used 1.90TiB path /dev/sdb
>         devid    5 size 2.73TiB used 440.34GiB path /dev/sdf
>         devid    6 size 2.73TiB used 440.34GiB path /dev/sdg
>
> The dmesg log when attempting to mount the vol can be found at url
>
> http://cwillu.com:8080/108.63.177.210/1
>
> Any ideas what can be done to be able to mount the volume and complete
> the balancing?
>
> Regards,
> Steven
>
>
> --
> "Truth or die."
>
> Steven Hum
> 417 Mayfair Av
> Ottawa, ON K1Y 0K4
> email sdothum@gmail.com
> tel 613.237.9058
>

--
"Truth or die."

Steven Hum
417 Mayfair Av
Ottawa, ON K1Y 0K4
email sdothum@gmail.com
tel 613.237.9058

