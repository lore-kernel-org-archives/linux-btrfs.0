Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40881 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaAUN5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 08:57:19 -0500
Received: by mail-qa0-f51.google.com with SMTP id f11so6500056qae.38
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 05:57:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DE7797.30400@uab.edu>
References: <52DE7797.30400@uab.edu>
Date: Tue, 21 Jan 2014 14:57:18 +0100
Message-ID: <CABjx-yqm5AZQmDAcQnetPk14_iP9ybq4kdZ+z2fQFSPAVA28FQ@mail.gmail.com>
Subject: Re: Btrfs shows incorrect disk size after running a replace command
From: Andreas Fischer <fisch0r@gmail.com>
To: Kyle Bentley <kwbent@uab.edu>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Kyle,

you will probably have to tell btrfs to use the complete devices.
Checkout "btrfs filesystem resize". There are cases when one does not
want to grow the used space on a replacement disk automatically, e.g.
when the disk is to be replaced with a smaller disk again, so this is
not a bug.

Cheers,
Andreas

On Tue, Jan 21, 2014 at 2:35 PM, Kyle Bentley <kwbent@uab.edu> wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I have just recently replaced two 750 GB disks with two 1 TB disks.  I
> used the replace command to do so, aka "btrfs replace start /dev/sdX
> /dev/sdY /mountpoint".  Each replacement went smoothly, with no errors
> reporting.  I'm positive that the source and destination drives were
> identified correctly.  However, when I run "btrfs filesystem show", the
> output is
>
> Label: none  uuid: b2dbc0e4-94fc-4089-9221-d79d7919f8cb
>     Total devices 2 FS bytes used 494.23GB
>     devid    2 size 698.64GB used 495.03GB path /dev/sda
>     devid    1 size 698.64GB used 495.03GB path /dev/sdb
>
> Btrfs v0.20-rc1
>
> The disks show up as the 750 GB, when they are in fact 1 TB.  smartctl
> for each drive shows
>
> root@Lore:/home/kyle# smartctl -i /dev/sda |grep "User Capacity"
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
>
> root@Lore:/home/kyle# smartctl -i /dev/sdb |grep "User Capacity"
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
>
> Is there any harm in this?  If it is simply a superficial bug I will not
> worry.  Would running a balance help?  As for the specifics, I'm using
>
> Debian testing x64
> Vanilla kernel 3.13.0
> AMD hardware
>
> Thanks,
>
> Kyle Bentley
>
> - ---------------------------------------
> kwbent@uab.edu
> UAB Dept of Physics
> 1300 University Blvd
> CH 310
> Birmingham, AL
> - ---------------------------------------
>
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Icedove - http://www.enigmail.net/
>
> iQEcBAEBAgAGBQJS3neNAAoJEKZ75usGhR84secH/iIbH/FcU3pTsg7+V9vwqMgB
> VuQeZpU13RH/2fwupuFJtu4wK021xWLrSuN7nUGG0WzrWSmt8nHvQqIV1TBY+2PO
> QqttgbBK5yDEIY6QB3lUn2fQDWohlrbG4/3CTjILoTdHWsihTBzXIug6D6aEpM1o
> 1b3smiBPM6mg6sy3d+JSr47TGi8Wko1QnOh2ory5FlkJMTZLDNWBqG2ja00B7W9H
> UKnwgaU3KZr9UcbiVlvM1BLgDBxRZlhsjWMMo+diX92PHgaBovhEOzCrHI/nyXv7
> vY3YKcwU1zH3f0olHXfp9lFjo06C/4/+EggCrQ3BEe0hxm5r3bHc44zrTCnH/Wg=
> =a/VY
> -----END PGP SIGNATURE-----
>
