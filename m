Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43559 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbLHUvK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 15:51:10 -0500
Date: Tue, 8 Dec 2015 20:51:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub can neither start nor cancel
Message-ID: <20151208205108.GD2376@carfax.org.uk>
References: <31519331.YQjdnfjTR6@i5>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
In-Reply-To: <31519331.YQjdnfjTR6@i5>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 08, 2015 at 09:46:48PM +0100, Wolfgang Rohdewald wrote:
> I just tried this script:
> http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair
> 
> but I did not pass the directory where the filesystem is mounted.
> 
> Next I called it correctly: btrfs-scrub /t4
> I also tried btrfs scrub start / cancel directly, but 
> I am not really sure what I did in which order.
> 
> Anyway now I can neither cancel nor start btrfs scrub. Rebooting did not help.

   It might be that the userspace tools has got confused and left
behind a lock/pid/progress file in /var/lib/btrfs/

   Take a look in there and see if there's anything that you can
delete to good effect?

   Hugo.

> Running unmodified Linux 4.3
> 
> It seems like scrub stopped and did not clean up. Maybe because:
> Dec  8 21:07:41 s5 kernel: [17833.840868] btrfs[23746]: segfault at ffffffffffffff98 ip 00000000004079e1 sp 00007fffafa27510 error 5 in btrfs[400000+53000]
> 
> How can I now clean this up?
> 
> root@s5:~# btrfs --version
> Btrfs v3.12
> 
> root@s5:~# btrfs scrub status /t4
> scrub status for 700900de-e35f-4264-8f5d-1b2b249a5c3a
>         scrub started at Tue Dec  8 21:05:31 2015, running for 20 seconds
>         total bytes scrubbed: 3.09GiB with 0 errors
> 
> root@s5:~# btrfs scrub cancel /t4
> ERROR: scrub cancel failed on /t4: not running
> 
> root@s5:~# btrfs scrub start /t4
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /t4'.
> To see the status use 'btrfs scrub status [-d] /t4'.
> 
> 

-- 
Hugo Mills             | Go not to the elves for counsel, for they will say
hugo@... carfax.org.uk | both no and yes.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWZ0K8AAoJEFheFHXiqx3kNDEP/0Yl07kQ9nlb5jTyfCsWk+4y
zt4E0LIgC9kyLsLKG92hsmMUCQh687EOiWTzuik73ubuwwTsTht7idSUlg4j13pf
aXIyF3k9BE9+yTrVW/jB6O6bL+RNBZmhaZI6MP5eosBOHs/K3N0Ep/S9J4fU0s2o
Vh04iKjFJEjfuJAaNvMtxpOc/r4SzV1nG6YEsW/Uam4fUkOWHD3x87f3zr8q8dvk
SGz1lHIUPYvupiA5aCQrOQp6sFILTlFZhmcWkx1354bhU1Xi+bAkaAF32dipp6wM
ndhRAh1pkbrIEL6C3o+KzJYDhB+o7/ZTgbIFFaHRDevPfLWLDD89KOltFWkCdPGB
0BqLeDzNdgP8MgGJ3sIkkYu6qokdPgn/cpCkRWcIxj5KZmOIEekBz5fkVjzP/0t+
eSjFkmZ9chHj20/Qyy8yZ8sxDn/3oSJ3gLf7qVDVxeO4dtLlKKeFrtyShHXcI2pR
yPp+UpUFXCNMwwg1ALOuq1mDpZcHIFwxGwHc1VLZCAmyRWQoQf2dGLNYf2o3c5tX
7QtxJh7sWK31vW3JJbTmD0lysBRQjl9+1vaahKK+lmIv+RQydayoasH7Y+yK4GSY
ry6bkbPXsoOf3+qc0obz8ENYJh6wyxotp16A9mMRVESLZr20SkO7lOllTFDj1iHP
NdoguKknXkunCkNjZpg7
=yMTa
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
