Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f178.google.com ([209.85.208.178]:38191 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbeIDIp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 04:45:58 -0400
Received: by mail-lj1-f178.google.com with SMTP id p6-v6so1935468ljc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Sep 2018 21:22:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP8EXU0u1sDa97jCeaZWL=+3sRRwigheEeeOL1aM57777XpRQw@mail.gmail.com>
References: <CAP8EXU0u1sDa97jCeaZWL=+3sRRwigheEeeOL1aM57777XpRQw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 3 Sep 2018 22:22:42 -0600
Message-ID: <CAJCQCtR6tmRaYwipw9JEut9Nu=1754LYz1EBmSRH8Gu_1_JBGg@mail.gmail.com>
Subject: Re: Does ssd auto detected work for microSD cards?
To: GWB <gwb@2realms.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 3, 2018 at 7:53 PM, GWB <gwb@2realms.com> wrote:
> Curious instance here, but perhaps this is the expected behaviour:
>
> mount | grep btrfs
> /dev/sdb3 on / type btrfs (rw,ssd,subvol=@)
> /dev/sdb3 on /home type btrfs (rw,ssd,subvol=@home)
> /dev/sde1 on /media/gwb09/btrfs-32G-MicroSDc type btrfs
> (rw,nosuid,nodev,uhelper=udisks2)
>
> This is on an Ubuntu 14 client.
>
> /dev/sdb is indeed an ssd, a Samsung 850 EVO 500Gig, where Ubuntu runs
> on btrfs root.   It appears btrfs did indeed auto detected an ssd
> drive.   However:
>
> /dev/sde is a micro SD card (32Gig Samsung) sitting in a USB 3 card
> reader, inserted into a USB 3 card slot.  But ssh is not detected.
>
> So is that the expected behavior?

cat /sys/block/sde/queue/rotational

That's what Btrfs uses for detection. I'm willing to bet the SD Card
slot is not using the mmc driver, but instead USB and therefore always
treated as a rotational device.


> If not, does it make a difference?
>
> Would it be best to mount an sd card with ssd_spread?

For the described use case, it probably doesn't make much of a
difference. It sounds like these are fairly large contiguous files,
ZFS send files.

I think for both SDXC and eMMC, F2FS is probably more applicable
overall than Btrfs due to its reduced wandering trees problem. But
again for your use case it may not matter much.



> Yet another side note: both btrfs and zfs are now "housed" at Oracle
> (and most of java, correct?).

Not really. The ZFS we care about now is OpenZFS, forked from Oracle's
ZFS. And a bunch of people not related to Oracle do that work. And
Btrfs has a wide assortment of developers: Facebook, SUSE, Fujitsu,
Oracle, and more.


-- 
Chris Murphy
