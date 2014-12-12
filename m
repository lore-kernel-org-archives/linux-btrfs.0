Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38810 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933985AbaLLEcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 23:32:11 -0500
Date: Thu, 11 Dec 2014 23:32:09 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance & scrub & defrag
Message-ID: <20141212043209.GE22023@hungrycats.org>
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
In-Reply-To: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2014 at 04:15:17PM -0600, sys.syphus wrote:
> I am working on a script that i can run daily that will do maintenance
> on my btrfs mountpoints. is there any reason not to concurrently do
> all of the above? possibly including discards as well.
>=20
>=20
> also, is there anything existing currently that will do maintenance on
> btrfs so i don't have to reinvent the wheel?

There's not a lot of wheel to reinvent.  Just a one-liner in a crontab
is sufficient.

> #!/bin/bash
> btrfs filesystem defragment -r -v /media/btrfs/  &
> btrfs scrub start /media/btrfs/ &
> btrfs balance start /media/btrfs/ &

They should be run sequentially for simple performance reasons.  They all
attempt to occupy all the available disk bandwidth, so running them all
at the same time just increases access latency and usually makes them
much slower than if they were run sequentially.  There is no cooperative
scheduling of these operations in btrfs, even though they theoretically
could be combined into a single pass.

Run scrub once a week on low-end consumer drives, once a month on drives
designed for NAS applications.  Scrub is a fast and (assuming no errors
are detected) read-only scan of allocated data areas that is well worth
its relatively low cost.  There's no need to run it daily--but there's no
reason _not_ to run it daily either, if your disks' speed-to-size ratio
is big enough.

Don't run defragment at all, unless you have a database or VM image,
and if you do, run defrag only on that.  It's necessary for databases
because each fragment ends up being the size of a database page, and
the extent records for large badly-fragmented files consume almost
as much RAM as the file pages themselves.  defrag on arbitrary large
files is a fairly good way to lock yourself out of your system:  defrag
will eventually finish, but in pathological cases it can take hours and
prevent you from using the filesystem while it runs.  You can try using
the autodefrag mount option instead, but be prepared to turn it off if
autodefrag is not right for your workload.

Balance is something to use only when there is a configuration change
(e.g. you added a new disk or replaced one with a larger one) or you've
drastically changed the average size of files in a nearly-full filesystem.
It will make the filesystem painfully slow the whole time it runs, and it
can run for weeks on a filesystem smaller than 1TB.  There's a _reason_
why balance requests persist across reboots.  Speaking of reboots: if
a balance is interrupted by a reboot, it can delay the next mount for
minutes or hours (the mount command seems to hang until it has processed
the interrupted block group) depending on filesystem size.

> watch -d -n 30 "btrfs balance status /media/btrfs/; btrfs scrub status
> /media/btrfs/"

That part is fine.  I throw in 'btrfs fi df' into the watches too.


--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSKb8cACgkQgfmLGlazG5z9AACbBjGkRmjdLeRxbcIEn1jALqTf
vawAnitj9PSEXVRakU2ebF8LskTl8mqT
=eFED
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
