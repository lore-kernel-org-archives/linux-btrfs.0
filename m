Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41471 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbKNObO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 09:31:14 -0500
Date: Sat, 14 Nov 2015 14:31:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "CHENG Yuk-Pong, Daniel " <j16sdiz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: More memory more jitters?
Message-ID: <20151114143112.GK24333@carfax.org.uk>
References: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hl1kWnBARzJiTscN"
In-Reply-To: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hl1kWnBARzJiTscN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 14, 2015 at 10:11:31PM +0800, CHENG Yuk-Pong, Daniel  wrote:
> Hi List,
> 
> 
> I have read the Gotcha[1] page:
> 
>    Files with a lot of random writes can become heavily fragmented
> (10000+ extents) causing trashing on HDDs and excessive multi-second
> spikes of CPU load on systems with an SSD or **large amount a RAM**.
> 
> Why could large amount of memory worsen the problem?

   Because the kernel will hang on to lots of changes in RAM for
longer. With less memory, there's more pressure to write out dirty
pages to disk, so the changes get written out in smaller pieces more
often. With more memory, the changes being written out get "lumpier".

> If **too much** memory is a problem, is it possible to limit the
> memory btrfs use?

   There's some VM knobs you can twiddle, I believe, but I haven't
really played with them myself -- I'm sure there's more knowledgable
people around here who can suggest suitable things to play with.

   Hugo.

> Background info:
> 
> I am running a heavy-write database server with 96GB ram. In the worse
> case it cause multi minutes of high cpu loads. Systemd keeping kill
> and restarting services, and old job don't die because they stuck in
> uninterruptable wait... etc.
> 
> Tried with nodatacow, but it seems only affect new file. It is not an
> subvolume option either...
> 
> 
> Regards,
> Daniel
> 
> 
> [1] https://btrfs.wiki.kernel.org/index.php/Gotchas#Fragmentation

-- 
Hugo Mills             | Anyone who says their system is completely secure
hugo@... carfax.org.uk | understands neither systems nor security.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Bruce Schneier

--hl1kWnBARzJiTscN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWR0WwAAoJEFheFHXiqx3kMzoP/26OOpE817OsPNHsVrA34uJz
JLwab5GyhhM4UuaQ4cHjZYaEUb7gTkKwZgmUaQAue5F4/Plgc1YR3NFhRkKkTTzL
h71oo7wAkUna0cltoNH2jcTjvJKdQ1jnCkWYMjuCDdLqiHIYmaJz4KSka9AGFIXv
GPKL4BA1p/nF/nPsgWhJLE1eGY7XJ2nH83gc6jONgjiewPWdD/EAARpYBmBQgIS8
XOje1oFD5qyKpIU9hW842wH55ebvx49NRjKa2J9gtrM3k8Tgq9EruVH2GpnaZwT5
49iMkia4hJZC7QSymUmZpZYgiK6xw5lTwVwNbI+YyXU1uPy3CtdTrkaK8rj6LrfZ
eKCeRTXGtTHyRjaVhAu9MT/7JBwdcky8XNy6PTucDwOX27nBg3eNHKOKU+/WDa+F
2FTexcRdWsF5ta8o/gjITA2Uw7X0M4/Lt4QWo2ibmi6ZBiD/OhnZwjwox904IQnQ
L5hh9Rzpx5fFfFOPI+s2Qeu8D7J2mQQvMDx0IKj87E/o8vX1CHjC5xZjIgdJhusz
uUwTv3rrJEJRzq0haYg99lA71/Bblz22po7tHAHnZ7Q0NO+Sl7mNWVy99qPvb0pV
0unab1iO/YjTReKln6sh4v2H57Oo1L/U+YfULkxPlKfdd7ELah9rWrANP74GUwAO
j6zs+/MziN55Kg8jr1fn
=Lkjj
-----END PGP SIGNATURE-----

--hl1kWnBARzJiTscN--
