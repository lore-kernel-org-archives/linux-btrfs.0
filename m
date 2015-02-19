Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:35147
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbbBSKGG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 05:06:06 -0500
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 39EAA21F15
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 10:06:05 +0000 (GMT)
Message-ID: <54E5B58C.50704@barrowhillfarm.org.uk>
Date: Thu, 19 Feb 2015 10:06:04 +0000
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Re-assembling a btrfs raid1 array
References: <54E5ACE0.7000709@barrowhillfarm.org.uk>
In-Reply-To: <54E5ACE0.7000709@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 19/02/15 09:29, Bob Williams wrote:
> My system comprises 2 x 3TB hard drives, each partitioned into a
> 4GB swap, a 36GB /, and the rest for /home. / and /home are (were)
> then assembled into btrfs raid1 arrays, with both metadata and data
> being mirrored.
> 
> I then installed the wrong graphics drivers for my nVidia card, 
> resulting in an unbootable system. The only way out was to
> reinstall the system (openSUSE 13.2), but it only used a single
> drive, resulting in the following setup:
> 
> :~ # btrfs fi sh Label: none  uuid:
> d5919e1a-b52f-421d-9785-cb081ae3b334 Total devices 1 FS bytes used
> 5.60GiB devid    1 size 36.00GiB used 8.04GiB path /dev/sdf2
> 
> Label: 'home'  uuid: 56884b1d-93ab-4db9-bc93-eff3833e91e1 Total
> devices 2 FS bytes used 1.06TiB devid    1 size 2.69TiB used
> 1.07TiB path /dev/sdf3 devid    2 size 2.69TiB used 1.07TiB path
> /dev/sdg3
> 
> Label: none  uuid: 06ea503f-58ff-48ca-9c50-b0679288fae6 Total
> devices 2 FS bytes used 15.87GiB devid    2 size 36.00GiB used
> 17.03GiB path /dev/sdg2 *** Some devices missing
> 
> Btrfs v3.16.2+20141003
> 
> :~ # uname -r 3.16.7-7-desktop
> 
> I would like some advice on how to safely delete the contents of 
> /dev/sdg2, and then add it to /dev/sdf2 to make a new raid1 array.
> I know how to do the second step,
> 
> mkfs.btrfs -m raid1 -d raid1 /dev/sdf2 /dev/sdg2
> 
> (or would that destroy the data on /dev/sdf2 ?)
> 
Whoops. I really meant to say:

# btrfs device add -f /dev/sdg2 /
# btrfs balance start -dconvert=raid1 -mconvert=raid1 /

> and I could delete the contents of the partition, but in between
> these two steps I'm supposing I need to disassemble one raid1 array
> and then put it together again.
> 
> Or maybe I'm making this seem harder than it really is?
> 
> Bob -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

- -- 
Bob Williams
System:  Linux 3.16.7-7-desktop
Distro:  openSUSE 13.2 (x86_64) with KDE Development Platform: 4.14.3
Uptime:  06:00am up 7:55, 3 users, load average: 0.16, 0.05, 0.06
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTltYoACgkQ0Sr7eZJrmU7KbgCgogQVHMce+HzMWnBoUSQr56gP
vusAn3J73p7QYfLhJDOqXlgilsAmX2ZF
=Y4Wx
-----END PGP SIGNATURE-----
