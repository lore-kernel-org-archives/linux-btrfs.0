Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59796 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbHSQRG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 12:17:06 -0400
Date: Wed, 19 Aug 2015 16:17:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: understanding btrfs fi df
Message-ID: <20150819161703.GZ12976@carfax.org.uk>
References: <55D09F50.5070900@friedels.name>
 <20150816145719.GU12976@carfax.org.uk>
 <55D4AA5E.60306@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0EIE/3F9PxFGTcfe"
In-Reply-To: <55D4AA5E.60306@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0EIE/3F9PxFGTcfe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 19, 2015 at 06:10:06PM +0200, Hendrik Friedel wrote:
> Hello Hugo,
> 
> thanks for your hint.
> 
> On 16.08.2015 16:57, Hugo Mills wrote:
> >    Here's your problem -- you've got a RAID 5 filesystem, which has a
> >minimum allocation of 2 devices, but only one device has free space on
> >it for allocation, so no more chunks can be allocated. I'm not sure
> >how it ended up in this situation, but that's what's happened.
> >
> >2) convert a few chunks of the existing FS, on devices 1 and 3, to
> >single, which should free up some space across all the devices, and
> >then run a full balance, and finally convert the single back to RAID
> >5:
> >
> ># btrfs balance start -dconvert=single,devid=1,limit=4/mnt/__Complete_Disk
> ># btrfs balance start -dconvert=single,devid=3,limit=4/mnt/__Complete_Disk
> ># btrfs balance start -dprofiles=raid5/mnt/__Complete_Disk
> ># btrfs balance start -dconvert=raid5,soft/mnt/__Complete_Disk
> 
> 
> I did that. In order to run the first two commands I had to free
> some space though, which was no problem.
> 
> Now the output is:
> root@homeserver:/media# btrfs fi df /mnt/__Complete_Disk
> 
> Data, RAID5: total=3.79TiB, used=3.78TiB
> System, RAID5: total=32.00MiB, used=416.00KiB
> Metadata, RAID5: total=6.46GiB, used=4.85GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> root@homeserver:/media# btrfs fi show
> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>         Total devices 3 FS bytes used 3.79TiB
>         devid    1 size 2.73TiB used 2.43TiB path /dev/sdf
>         devid    2 size 2.73TiB used 2.43TiB path /dev/sdd
>         devid    3 size 2.73TiB used 1.38TiB path /dev/sde
> 
> How can only 1.38TiB be used on devid 3?

   It shouldn't happen, as I understand how the process works. Can you
show the output of "btrfs fi df /mnt/__Complete_Disk"? Let's just
check that everything is indeed RAID-5 still.

   After this, we're probably going to have to look at the device and
chunk trees to work out what's going on.

   Hugo.

-- 
Hugo Mills             | "I lost my leg in 1942. Some bastard stole it in a
hugo@... carfax.org.uk | pub in Pimlico."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--0EIE/3F9PxFGTcfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV1Kv/AAoJEFheFHXiqx3k8x4QAKUr8Hb1ScjQMjUjsywd5u+j
+rDfKwpLu3x8D9UVmnSUq1YH935wZlBznEZjnWTfwxHgyjd/NcjFM0D47MmIdFC4
Bi+nnyjSkLZua4cmdbv0HMaJi8fY4jvC2qhvThNlmFH8wTGTN6CClkQG47uCjLKQ
ncHG8WMlzbAvKdTkt+eaivSl+dulDfv5o3qkkq5QRAMY02mdqxST+Pn065LkqK6e
cpLhKBRWaGCR0+b42NNmGvmOaGlG0F0AQwVUwP3kdeDBsu0PtABuz5a8zYplIep4
fi8RKRhG532PzgR0ZP9TFPXKLhT4P7KqByBPklgeqMbm8IxONWLRG4VeNLRKI2Kf
0bl0x2zMVqWD2Mhy2eg94LZlWpCHvyLcymAR9FTvakexVw63LIK25kqKq9C3Z/8/
2AkTswxtqyRNeAgFmQh37OeUJjUK8g/iQvfdLquNOX310kREfJgW+z7W3g4vY1YI
BTVuhZ6Q+9uKJ2R0DRy9g3E5Ram5S97ykGZn0q+wh1cenxjMO7jj7niDdr9lKXZ5
F3kjyCc9bMndBbqTpuH5Kra2fZEa+djjad74U1S+Hx/ClU17hPT1juka2msET9Up
sduTvYppQm8vsRuh6bG7eSpsaEu7XXoJv8pfThUAj19AZaOmeTN68UdBbZVtvw4g
I4dtftbkyQfKompXjUkb
=ssav
-----END PGP SIGNATURE-----

--0EIE/3F9PxFGTcfe--
