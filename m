Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60754 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbcB1UgV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 15:36:21 -0500
Date: Sun, 28 Feb 2016 20:36:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian Robottom Reis <kiko@async.com.br>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Replacing RAID-1 devices with larger disks
Message-ID: <20160228203619.GI14504@carfax.org.uk>
References: <20160228201532.GA26692@anthem.async.com.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
In-Reply-To: <20160228201532.GA26692@anthem.async.com.br>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 28, 2016 at 05:15:32PM -0300, Christian Robottom Reis wrote:
> Hello there,
> 
>     I'm running a btrfs RAID-1 on two 128GB SSDs that were getting kind
> of full. I found two 256GB SSDs that I plan to use to replace the 128TB
> versions.
> 
> I've managed to do the actual swap using a series of btrfs replace
> commands with no special arguments, and the system is now live and
> booting from the 256GB drives. However, I haven't actually noticed any
> difference in btrfs fi show output, and usage looks weird. Has anyone
> seen this before or have a clue as to who?

   Device replace doesn't change the amount of the device that the FS
will use -- Like most FSes, btrfs has its own concept of the amount of
a device it should use.

  You probably need to run btrfs fi resize on the FS for each device:

# btrfs fi resize 1:max /mountpoint
# btrfs fi resize 2:max /mountpoint

   Hugo.

> The relevant partition sizes are now (sdb is identical):
> 
>     /dev/sda1   *        2048    83888127    41943040   83  Linux
>     /dev/sda3        92276736   427821055   167772160   83  Linux
> 
> Here's the show output:
> 
>     Label: 'root'  uuid: 670d1132-00dc-4511-a2f6-d28ce08b4d3a
>         Total devices 2 FS bytes used 9.33GiB
>         devid    1 size 13.97GiB used 11.78GiB path /dev/sda1
>         devid    2 size 13.97GiB used 11.78GiB path /dev/sdb1
> 
>     Label: 'var'  uuid: 815b3280-e90f-483a-b244-1d2dfe9b6e67
>         Total devices 2 FS bytes used 56.14GiB
>         devid    1 size 80.00GiB used 80.00GiB path /dev/sda3
>         devid    2 size 80.00GiB used 80.00GiB path /dev/sdb3
> 
> Those sizes have not changed over the resize; i.e. the original sda1/sdb1 pair
> was 14GB and the sda3/sdb3 pair was 80GB, and after the replace, they haven't
> changed.
> 
> And usage for / is now weird:
> 
>     Overall:
>         Device size:          27.94GiB
>         Device allocated:         21.56GiB
>         Device unallocated:        6.38GiB
>         Device missing:          0.00B
>         Used:             18.66GiB
>         Free (estimated):          3.99GiB  (min: 3.99GiB)
>         Data ratio:               2.00
>         Metadata ratio:           2.00
>         Global reserve:      208.00MiB  (used: 0.00B)
> 
>     Data,RAID1: Size:9.00GiB, Used:8.20GiB
>        /dev/sda1       9.00GiB
>        /dev/sdb1       9.00GiB
> 
>     Metadata,RAID1: Size:1.75GiB, Used:1.13GiB
>        /dev/sda1       1.75GiB
>        /dev/sdb1       1.75GiB
> 
>     System,RAID1: Size:32.00MiB, Used:16.00KiB
>        /dev/sda1      32.00MiB
>        /dev/sdb1      32.00MiB
> 
> Usage for /var also looks wrong, but in a different way:
> 
>     Overall:
>         Device size:         160.00GiB
>         Device allocated:        160.00GiB
>         Device unallocated:        2.00MiB
>         Device missing:          0.00B
>         Used:            112.28GiB
>         Free (estimated):         21.20GiB  (min: 21.20GiB)
>         Data ratio:               2.00
>         Metadata ratio:           2.00
>         Global reserve:      512.00MiB  (used: 0.00B)
> 
>     Data,RAID1: Size:74.97GiB, Used:53.77GiB
>        /dev/sda3      74.97GiB
>        /dev/sdb3      74.97GiB
> 
>     Metadata,RAID1: Size:5.00GiB, Used:2.37GiB
>        /dev/sda3       5.00GiB
>        /dev/sdb3       5.00GiB
> 
>     System,RAID1: Size:32.00MiB, Used:16.00KiB
>        /dev/sda3      32.00MiB
>        /dev/sdb3      32.00MiB
> 
>     Unallocated:
>        /dev/sda3       1.00MiB
>        /dev/sdb3       1.00MiB
> 
> 
> Version information:
> 
>     async@riff:~$ uname -a
>     Linux riff 4.2.0-30-generic #36~14.04.1-Ubuntu SMP Fri Feb 26 18:49:23
>     UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
>     async@riff:~$ btrfs --version
>     btrfs-progs v4.0
> 
> Thanks,

-- 
Hugo Mills             | You stay in the theatre because you're afraid of
hugo@... carfax.org.uk | having no money? There's irony...
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                     Slings and Arrows

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW01pCAAoJEFheFHXiqx3kEtkP/3uhVqTg0I7EVmU1BMQ1Lh10
LxI8TEa2beHUt0dAia6AexNVy7wx60i8NdAP9U57ECTKLhEu8WlqI1iD+O+/9q+p
tBybyfXbCSywhnj6QXji/HjGcTAtHo8s2rf59S/CQKbIl7suz+uDvxpGGm//izB4
q1Us/SbIfiK4/ZSkr0D78U9NusjXvbze+U+kr7WZC+2wZ+NjJg5EzAMCMMSKsy02
97HE4rFy9nTmVufFSmFMJvissniNslUpbq+0TmzbM2l+d+kyBoC7JZpH5ZllsQwE
SserIiJRabEKPqESfcuswjJrQ/8bQeGMn6fT+2KCzYLKll6oTwSSHk+rlG1zoiCw
p+YTPjqssVtn1LMNywtIDguI0Xs8OpHFXdLICCBCZrTb4aCGDTH/2BXy+8tfAZvT
hOla1Pwt/rHCr91ETaYyBW//SE2Oie2uQZ9bykSDhhAf+F0QZzyonONX/YtkV2be
z5LTcJaeG9J+fUEESLPakK0HJdqsnzecEisB/Soo2gPdzzmKR13z4btBhnf98/SD
69GjwnrBFY7AbiCPO3bkCevqsZSom1piWRBWMUlFMuuh96r+r98v0gBdbgmtoa32
TLkgJb8uxY+jKBgYWrC9OZMPahc4EdaL6an2N5fPUX0/8umdPyxpm/+Q7BfKzJHK
SRHnsZvgaG/9MIfcDSq0
=tU9W
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
