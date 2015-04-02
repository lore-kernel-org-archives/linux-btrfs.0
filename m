Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47784 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbDBK3P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 06:29:15 -0400
Date: Thu, 2 Apr 2015 10:29:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andy Smith <andy@strugglers.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is this normal? Should I use scrub?
Message-ID: <20150402102913.GF32078@carfax.org.uk>
References: <20150401151114.GR4327@bitfolk.com>
 <20150401154202.GD32078@carfax.org.uk>
 <20150402095839.GS4327@bitfolk.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
In-Reply-To: <20150402095839.GS4327@bitfolk.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 02, 2015 at 09:58:39AM +0000, Andy Smith wrote:
> Hi Hugo,
> 
> Thanks for your help.

   Makes a change from you answering my questions. :)

> On Wed, Apr 01, 2015 at 03:42:02PM +0000, Hugo Mills wrote:
> > On Wed, Apr 01, 2015 at 03:11:14PM +0000, Andy Smith wrote:
> > > Should I run a scrub as well?
> > 
> >    Yes. The output you've had so far will be just the pieces that the
> > FS has tried to read, and where, as a result, it's been able to detect
> > the out-of-date data. A scrub will check and fix everything.
> 
> Thanks, things seem to be fine now. :)
> 
> What's the difference between "verufy" and "csum" here?

   verify would be where the internal consistency checks for metadata
failed. That might be, for example, where it's detected that a tree
node has a newer transaction ID (effectively a monotonic timestamp)
than its parent. This should never happen, so the parent is probably
out of date. If there's another copy of the metadata that doesn't have
the same problem, it can be used to repair the obviously-wrong copy.

   csum is where the checksum validation failed -- this would be, for
example, where some data was modified on one copy and left unchanged
on the older copy, but the metadata for both copies was updated. In
that case, the data on the out-of-date drive wouldn't match the
checksum, and needs to be updated from the good copy.

   Hugo.

> scrub status for 472ee2b3-4dc3-4fc1-80bc-5ba967069ceb
> scrub device /dev/sdh (id 2) history
>         scrub started at Wed Apr  1 20:05:58 2015 and finished after 14642 seconds
>         total bytes scrubbed: 383.42GiB with 0 errors
> scrub device /dev/sdg (id 3) history
>         scrub started at Wed Apr  1 20:05:58 2015 and finished after 14504 seconds
>         total bytes scrubbed: 382.62GiB with 0 errors
> scrub device /dev/sdf (id 4) history
>         scrub started at Wed Apr  1 20:05:58 2015 and finished after 14436 seconds
>         total bytes scrubbed: 383.00GiB with 0 errors
> scrub device /dev/sdk (id 5) history
>         scrub started at Wed Apr  1 20:05:58 2015 and finished after 21156 seconds
>         total bytes scrubbed: 1.13TiB with 14530 errors
>         error details: verify=10909 csum=3621
>         corrected errors: 14530, uncorrectable errors: 0, unverified errors: 0
> scrub device /dev/sdj (id 6) history
>         scrub started at Wed Apr  1 20:05:58 2015 and finished after 5693 seconds
>         total bytes scrubbed: 119.42GiB with 0 errors
> scrub device /dev/sde (id 7) history
>         scrub started at Wed Apr  1 20:05:58 2015 and finished after 5282 seconds
>         total bytes scrubbed: 114.45GiB with 0 errors
> 
> Cheers,
> Andy

-- 
Hugo Mills             | Debugging is like hitting yourself in the head with
hugo@... carfax.org.uk | hammer: it feels so good when you find the bug, and
http://carfax.org.uk/  | you're allowed to stop debugging.
PGP: 65E74AC0          |                                        PotatoEngineer

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVHRn4AAoJEFheFHXiqx3kg7AP/0Izabj7OGp18mQoreipPvxe
WPNdChM8jKYxXKl9C/18EdoUN/Ak2o7+ZNyt+lro7HotYLO7dcti3p9YJJIwk4RP
N4PiZtPokTxD+pHlHoS1hb4ViXjBk9m94Hpx/wuU9lWkTAfyjsWvtInBuckJ2YCv
TDmhbBQM+QPxUyTw6k6WHT2c7EO4ZzDt2rUz/sMqvkWJKzxpb0cs8cWU9V57we5R
JbTS5pFsyufV9+D+LPHby//87/plhzAY7OpWK47jUPVBR7MVEKhCptWstmxcnC3Y
Z/Xpz/b71/w7SMJxxKSdTgAOqbvuQtiKQWofeQOI10MXTeZo8Kq8lwt8pk2DDUPc
5SeDiXOjAITzgocsDpqzQTvQN10xFuhhY++ko+Jq2iAb1sK4PEVPY8AzdyySGCyU
Cb7vMCQOjYXso7xUoBh5FAbADZaOsTtUXXd1O+5jVW+7s1Wd+y6kZzmZ9M/IGb6n
eyDsOAgQ0pvEtDEPcyTyALTULvL6ObkBLBwPwhvS2Vqcm6vnuQypFumNPsnwxPH1
WUmFlVwO1nC87CgDel7xjSTUjZxYCt8l3oNEELswEedkYc1x76cV32Jr4KrpOu/y
fZANuJ69z9nOmmiM57ffnvlwwAIiAAw9lAOJ/cqHU5Ne6tBGJmc7F+IU3v8KsTjD
yE9ODxZZXRymhOmGigPm
=DFVT
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
