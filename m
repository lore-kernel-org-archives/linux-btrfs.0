Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46840 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbHAUdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 16:33:00 -0400
Date: Sat, 1 Aug 2015 20:32:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Data single *and* raid?
Message-ID: <20150801203258.GA14352@carfax.org.uk>
References: <55BD277F.2040201@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
In-Reply-To: <55BD277F.2040201@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 01, 2015 at 10:09:35PM +0200, Hendrik Friedel wrote:
> Hello,
> 
> I converted an array to raid5 by
> btrfs device add /dev/sdd /mnt/new_storage
> btrfs device add /dev/sdc /mnt/new_storage
> btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/
> 
> The Balance went through. But now:
> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>         Total devices 3 FS bytes used 5.28TiB
>         devid    1 size 2.73TiB used 2.57TiB path /dev/sde
>         devid    2 size 2.73TiB used 2.73TiB path /dev/sdc
>         devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
> btrfs-progs v4.1.1
> 
> Already the 2.57TiB is a bit surprising:
> root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
> Data, single: total=2.55TiB, used=2.55TiB
> Data, RAID5: total=2.73TiB, used=2.72TiB
> System, RAID5: total=32.00MiB, used=736.00KiB
> Metadata, RAID1: total=6.00GiB, used=5.33GiB
> Metadata, RAID5: total=3.00GiB, used=2.99GiB

   Looking at the btrfs fi show output, you've probably run out of
space during the conversion, probably due to an uneven distribution of
the original "single" chunks.

   I think I would suggest balancing the single chunks, and trying the
conversion (of the unconverted parts) again:

# btrfs balance start -dprofiles=single -mprofile=raid1 /mnt/new_storage/
# btrfs balance start -dconvert=raid5,soft -mconvert=raid5,soft /mnt/new_storage/

   You may have to do this more than once.

   Hugo.

> Why is there Data single and Raid?
> Why is Metadata RAID1 and Raid5?
> 
> A scrub is currently running and showed no errors yet.

-- 
Hugo Mills             | You've read the project plan. Forget that. We're
hugo@... carfax.org.uk | going to Do Stuff and Have Fun doing it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           Jeremy Frey

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVvSz6AAoJEFheFHXiqx3k6j4QAKuP1zbOa1yPFbVh4nXnj/6z
O4ZIW/v9sm01ZbuozNCeH8FjOBkCPHZllrSA+Nx78Y5bCjuv3JgnEXv4bBIuVmgX
PTORRwYfZ2aIGrjQollJRwA5ZKkVqy1Hx8fQf3IMpq6qJnZHcL+C6b3XxAIgyMqI
R4ZG2pVCrEoKI4lNfRz3GspkF4fasa5TBL5UrR7wOTD7tCSBh9tECIzYt3VjuXEx
3s7buOwBQreskK67iE+YGDVsMalAHhd9k1tYiw3as3zF9RGO2sZAHW49r5VUV8GV
TOCenL9miSsoX0BHBQvbjcs4KwN2HztidWWzwrLa5iedc1DmVk45kUfXJXw90vBU
2Qfb0EteBg6JEYrthcOyW5/Er4NVvYoGW3RAdNxcSO+xBmRUQnyCIfESd/rKvDJm
VMF/DTiOi1zQFEsSvA6coxqWdQfGvp5BJ2saxJIdY6PKFjygo4VZeAe6jr21vOvw
LdOcVssgBK31nxWI8rGkeFqoVkWL6AHceRo/o/L8FiJpL5b7GjOTmofJPGuBPyFU
dqGFjxGNsh9X2oHiI/SfTm3oaHJjv0eh3Swcf0UlokjEWS5Q5nhdM0EqpCooUGgw
pemvZ3aMFgwRv0xVgdO2iXpp6SFYqwREcryyXOCv1T8/KrCqssauJFKEto7TTtye
BgEFwTjHxKGj3/fzMGEr
=zn0h
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
