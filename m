Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:35297 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbcJKP56 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 11:57:58 -0400
Received: by mail-it0-f53.google.com with SMTP id e203so50458365itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 08:57:57 -0700 (PDT)
From: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
To: "'Chris Murphy'" <lists@colorremedies.com>
Cc: "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com> <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
In-Reply-To: <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
Subject: RE: raid6 file system in a bad state
Date: Tue, 11 Oct 2016 10:52:14 -0500
Message-ID: <5e8501d223d7$715a9bb0$540fd310$@com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: chris@colorremedies.com [mailto:chris@colorremedies.com] On
> Behalf Of Chris Murphy
> Sent: Monday, October 10, 2016 11:23 PM
> To: Jason D. Michaelson
> Cc: Chris Murphy; Btrfs BTRFS
> Subject: Re: raid6 file system in a bad state
> 
> What do you get for
> 
> btrfs-find-root <dev>

root@castor:~/logs# btrfs-find-root /dev/sda
parent transid verify failed on 5752357961728 wanted 161562 found 159746
parent transid verify failed on 5752357961728 wanted 161562 found 159746
Couldn't setup extent tree
Superblock thinks the generation is 161562
Superblock thinks the level is 1

There's no further output, and btrfs-find-root is pegged at 100%.

At the moment, the perceived bad disc is connected. I received the same results without as well.

> btrfs rescue super-recover -v <dev>

root@castor:~/logs# btrfs rescue super-recover -v /dev/sda
All Devices:
        Device: id = 2, name = /dev/sdh
        Device: id = 3, name = /dev/sdd
        Device: id = 5, name = /dev/sdf
        Device: id = 6, name = /dev/sde
        Device: id = 4, name = /dev/sdg
        Device: id = 1, name = /dev/sda

Before Recovering:
        [All good supers]:
                device name = /dev/sdd
                superblock bytenr = 65536

                device name = /dev/sdd
                superblock bytenr = 67108864

                device name = /dev/sdd
                superblock bytenr = 274877906944

                device name = /dev/sdf
                superblock bytenr = 65536

                device name = /dev/sdf
                superblock bytenr = 67108864

                device name = /dev/sdf
                superblock bytenr = 274877906944

                device name = /dev/sde
                superblock bytenr = 65536

                device name = /dev/sde
                superblock bytenr = 67108864

                device name = /dev/sde
                superblock bytenr = 274877906944

                device name = /dev/sdg
                superblock bytenr = 65536

                device name = /dev/sdg
                superblock bytenr = 67108864

                device name = /dev/sdg
                superblock bytenr = 274877906944

                device name = /dev/sda
                superblock bytenr = 65536

                device name = /dev/sda
                superblock bytenr = 67108864

                device name = /dev/sda
                superblock bytenr = 274877906944

        [All bad supers]:
                device name = /dev/sdh
                superblock bytenr = 65536

                device name = /dev/sdh
                superblock bytenr = 67108864

                device name = /dev/sdh
                superblock bytenr = 274877906944


Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure? [y/N]: n
Aborted to recover bad superblocks

I aborted this waiting for instructions on whether to proceed from the list.

> 	
> 
> 
> It shouldn't matter which dev you pick, unless it face plants, then try
> another.

