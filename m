Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42692 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3HXQUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 12:20:17 -0400
Date: Sat, 24 Aug 2013 17:20:13 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Thomas Koch <thomas@koch.ro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: check for reflink capability and for shared data
Message-ID: <20130824162013.GL3115@carfax.org.uk>
References: <201308241809.58701.thomas@koch.ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/jkxxxtAhYIHVDuh"
In-Reply-To: <201308241809.58701.thomas@koch.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/jkxxxtAhYIHVDuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 24, 2013 at 06:09:58PM +0200, Thomas Koch wrote:
> Hi,
> 
> how can I do the following in a shell script:
> 
> - check whether my file system supports cp --reflink?

touch foo; if cp --reflink=always foo bar; then ...; fi; rm -f foo bar

> - check whether two files share the same data on disk, i.e. one has been 
> created by cp --reflink of the other?

   You can't, using simple userspace tools. I think the only way would
be to use the tree search ioctl to inspect the extents for each file,
and see whether any of them overlap. Why do you need to know this?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--/jkxxxtAhYIHVDuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUhjdPVheFHXiqx3kAQLi9hAAvGq98aMXsssbKzUA87Aa4H63gKgZXOqA
evFrgB+vaitmc6BIH6hsObUJ8Q1yRFEzhQm4FBrJf9FDWa1bhfzbN/+T0+u0ZRmF
TlHfsWfcAcKewVV3QCia6EIhsciamXNI7aZDutqiP58q/GkUX1N1UtfvYXBP0cyA
lDvILLo50+HvXt2Q+xF3g8HoRtyNI2QiMxyaVAGf8W+9jrktYy5wNC+XfraQaEY9
+S4MAQrWGscleivzCqXqRgVvt+MPjYeU1aImf13FE49eGgY1DLt85ZdG7jUhCq/p
EnWYeqDQGwK31/c2ktsRDryS3fn4OdWbm7bYmEeFozr5URTsrmLgx2fDY+BKiiLY
PqwGluxt+Ulo4DHlphzCtsFsRIkTc8tzvAXZUxvI3Vmn8elDES9nyA9q+Z/xd1Aq
5AgZ+XQNWbLMGGkE1n9s5H67Yd4A1BxTTGjBV/O6eiPFveb+eBgMPRIgp+jKw24h
tM3FyVTTJzWLHyAqn4p2kB7YfoIOPzllEBcvuVaLENoz0Qz3OAdbybI+nEgC9RgQ
4FFIjLsdJL303CtU0rRtx83KgHClEqzVoE6IgxBdGnABpMi5vg3SzQnrFYSvEANb
rEFIgqblAq16xxx2G9U/sGZCSrZnxhnYcAoy9aneh9Xfaad4Hs0wjTAb7auSQTg0
z3ESDVo6eE8=
=qJEH
-----END PGP SIGNATURE-----

--/jkxxxtAhYIHVDuh--
