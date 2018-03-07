Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54138 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933935AbeCGUfs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 15:35:48 -0500
Date: Wed, 7 Mar 2018 20:35:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Diego <diegocg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Improve error stats message
Message-ID: <20180307203547.GG20688@carfax.org.uk>
References: <1588327.cr4xlG2VNd@archlinux>
 <20180307182453.GF20688@carfax.org.uk>
 <2011051.lkSedfDimf@archlinux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
In-Reply-To: <2011051.lkSedfDimf@archlinux>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2018 at 08:02:51PM +0100, Diego wrote:
> El mi=E9rcoles, 7 de marzo de 2018 19:24:53 (CET) Hugo Mills escribi=F3:
> >    On multi-device filesystems, the two are not necessarily the same.
>=20
> Ouch. FWIW, I was moved to do this because I saw this conversation on
> IRC which made me think that people aren't understanding what the
> message means:
>=20
> <nick1>       hi! I noticed bdev rd 13  as a kernel message
> <nick1>       what does it mean
> <nick2>       Well, that's not the whole message.
> <nick2>       Can you paste the whole line in here? (Just one line)
   ^^ nick2... that would be me. :)

> <nick1>       [    3.404959] BTRFS info (device sda4): bdev /dev/sda4 err=
s: wr 0, rd 13, flush 0, corrupt 0, gen 0
>=20
>=20
> Maybe something like this would be better:
>=20
> BTRFS info (device sda4): disk /dev/sda4 errors: write 0, read 13, flush =
0, corrupt 0, generation 0

   I think the single most helpful modification here would be to
change "device" to "fs on", to show that it's only an indicator of the
filesystem ID, rather than actually the device on which the errors
occurred. The others I'm not really bothered about, personally.

   Hugo.

> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2ceb924ca0d6..cfa029468585 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7239,7 +7239,7 @@ static void btrfs_dev_stat_print_on_error(struct bt=
rfs_device *dev)
>  	if (!dev->dev_stats_valid)
>  		return;
>  	btrfs_err_rl_in_rcu(dev->fs_info,
> -		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
> +		"disk %s errors: write %u, read %u, flush %u, corrupt %u, generation %=
u",
>  			   rcu_str_deref(dev->name),
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
>  			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),

--=20
Hugo Mills             | Q: What goes, "Pieces of seven! Pieces of seven!"?
hugo@... carfax.org.uk | A: A parroty error.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaoE0jAAoJEFheFHXiqx3kYf4P/iIEV4MTGCxcO5k5sqP1GVIX
ePPpsDYbPfQngu1DB6z1MEuG6d/90VKCxwQgaTyJKjkDX9+PQXNkRdGsHlajR1/w
BWmTztPTabDQlQaLSUOJIebVPYzDfkzeYG5cQE9SFp/dK1vUZZy0FCShPXYTR0zq
f28Lie5rqrxYYws1SWPQjEPjtz6XlkNWFR8vuRMu2V+nAZO5H/Svl/SiHklK0kv4
MX/EMG2KeEHe1i1jn1Cof5ym9uX9DBoLCjUAIBrnBFsYlJuWtd2F6lYJpiKsC67E
5LXPTht43MCgK/ank9L6nEMpIJhgagNsMPNRQFe+6MqUxf01wtFgQEyWiuac1fTQ
9ylfZATsZBkDc4ACAYvxn+UpqHdpLAr9HKCV/FWmZr9sWWofC7dZds5XRXGj+rNH
v6ufEgHSeb9eje6RthTGEca3sXYo5jeSAR7mn4U/XTvAg2J+zRhbAN9l1PQsE7po
8OpnwDAPy42oYWpxjjKsfE4SQapJ2nonFhDxrO0oaDlNiGlnlyNJeA1Z+JNb0P15
oxXBtfmIYOMK6tfu8d5/9mcQ/WzoJZP4ypx1pHIqBErdSqX2VlFeWosySSgWmxnt
dmk6IFPEjbTMr43VJfKa0nuKxST/T6u3/P+/p8LGf+jMEc0RcJNkpNeT90NcdUfv
t1y75pkJ/JCDOLiTqbJp
=8vzd
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
