Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51579 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756125AbdGXVA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 17:00:58 -0400
Date: Mon, 24 Jul 2017 21:00:36 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Best Practice: Add new device to RAID1 pool
Message-ID: <20170724210036.GK7140@carfax.org.uk>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
 <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
 <20170724204257.GJ7140@carfax.org.uk>
 <CAJCQCtTpdn0zNmogkbDr0h4RjNvb8u21w7Sj3xjUrj77A+ss8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mMdCh5/a0q2ATNCM"
In-Reply-To: <CAJCQCtTpdn0zNmogkbDr0h4RjNvb8u21w7Sj3xjUrj77A+ss8w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mMdCh5/a0q2ATNCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 24, 2017 at 02:55:00PM -0600, Chris Murphy wrote:
> On Mon, Jul 24, 2017 at 2:42 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> >
> >    In my experience, it's pretty consistent at about a minute per 1
> > GiB for data on rotational drives on RAID-1. For metadata, it can go
> > up to several hours (or more) per 256 MiB chunk, depending on what
> > kind of metadata it is. With extents shared between lots of files, it
> > slows down. In my case, with a few hundred snapshots of the same
> > thing, my system was taking 4h per chunk for the chunks full of the
> > extent tree.
> 
> Egads.
> 
> Maybe Cloud Admin ought to consider using a filter to just balance the
> data chunks across the three devices, and just leave the metadata on
> the original two disks?
> 
> Maybe
> 
> sudo btrfs balance start -dusage=100 <mp>

   It's certainly a plausible approach, yes.

   Or just wait it out -- the number of slow chunks is typically very
small. Note that most of the metadata will be csums (which are fast),
and not all of the other metadata chunks are slow ones.

   It would be interesting to know in this case the times of the
chunks that have been balanced to date (grep for the lines with the
chunk IDs in system logs).

   Hugo.

-- 
Hugo Mills             | Two things came out of Berkeley in the 1960s: LSD
hugo@... carfax.org.uk | and Unix. This is not a coincidence.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--mMdCh5/a0q2ATNCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZdl/zAAoJEFheFHXiqx3kf7QQALw2Ssf3wmRJwj7lKZV08Ga5
+nOEMv43D5dWZ2AvGsKK827mIQ2EyP3DhFPQFSfCri2SCH9ZukzrtOLv87CPZxgv
88Y8PW1t+gLKfYtowSDLWqD2iZNuFOX3hiOI4GP3FthDQ1RnOHRX/1zqgfffx3st
AOe0wRpVEhqdp+IlfCVtM1QbVqJ1sFhIfhWaiy6ntAYAdB+anprY1nj4ueo62LP8
gDSWlMBlHIM++kBh3ew8zRG46JOlCKbvA5+pS9Z1tUXLy+Oe7rgPRrB1O7gtvusn
hxz1WANBB68Ifo2IdmdFbVdoGhqecmI7exOo3qrfpk5EyfWlYr6MBacjgRxP81oI
riBs57dW8cX3Kq6FeIfSXiA1rHpDgk1s1Il0IOUX3lrjiXQFi/f6gNmq+heNkdKG
RcsCbZ5HV8dQqM0sOPXEUOzVO1fk2IeBxrDxlXi8IKF17zYs9qHbW99w1FdNP6ah
l2P4Ep/RasyTjd4UNaGLuw5Fxm1NU+Ram725eidlYZVhNDL9jcY6izcu9Y7Ggjeq
YRN5tnaM+o7yDaYJakj/U8CPwg/Y0Y4w7XbEUP24f/o0jUGUFybo0X7oS0w0/ZXU
gdpU4yBzhHazXzaKznxrV/MExvY07xXHVftRFclyZ9tsW6TD2dYFx4WMTbFURtnf
5vMUShmSgxcsQ7ombYdE
=+DWV
-----END PGP SIGNATURE-----

--mMdCh5/a0q2ATNCM--
