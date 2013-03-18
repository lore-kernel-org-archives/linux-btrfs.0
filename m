Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58949 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3CRS5G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 14:57:06 -0400
Date: Mon, 18 Mar 2013 18:57:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Kyle <lists@lolwut.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
Message-ID: <20130318185702.GB19395@carfax.org.uk>
References: <514759B5.5000507@lolwut.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
In-Reply-To: <514759B5.5000507@lolwut.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 18, 2013 at 02:15:17PM -0400, Kyle wrote:
> After reading through the btrfs documentation I'm curious to know if
> it's possible to ever securely erase a file from a btrfs filesystem
> (or ZFS for that matter).

   Not really.

   It gets even worse for SSDs, because the SSD itself can be
effectively CoW, with old pages lurking away in the flash storage
where (with a bit of physical persuasion of the hardware) they can be
read. So you have the same problem on SSDs even with non-CoW
filesystems.

> On non-COW filesystems atop regular HDDs one can simply overwrite
> the file with zeros or random data using dd or some other tool and
> rest assured that the blocks which contained the sensitive
> information have been wiped.

   Assuming that anything that's modified the file since its creation
hasn't written a copy and then overwritten it with rename(), of
course...

> However on btrfs it would seem any such attempt would write the
> zeros/random data to a new location, leaving the old blocks with the
> sensitive data intact. Further, since specifying NOCOW is only
> possible for newly created files, there seems to be no way to
> overwrite the appropriate blocks short of deleting the associated
> file and then filling the entire free filesystem space with
> zeros/random data such that the old blocks are eventually
> overwritten. What's the verdict on this?

   Your analysis is pretty much correct, but should be expanded to a
whole load of other data-leakage paths in generalised storage systems.
Overwriting file contents hasn't really been a reliable method of
erasing files for many years (if ever).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Great oxymorons of the world, no.  3: Military Intelligence ---   

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUUdjfr9z9OVl50rAAQJncxAAinTN8f9xnTKEzCXFzZEv9rMndcHVNR4o
fWMo/kV8VSvwLPo1RYrIOAGZg+Oqc3j9xIp5yWUXT1Sgw8I49+Nk0j9j/rtX9N0D
YJjtu/VdaKTxZD+U8TSPW0Z9x6VQLD9ZMpu+ajbwfCyfIyJDI8mNhjqxUU6N7RX+
v0jGHVBzErewHwiRF1lMBx1QyLHAGYexH6g4xrxyCKohpL3jPSlnjxVqAnYYiHqi
vJlXRtpcHGoSPqU6/5PUkP7O9mWDWB1o89Ea8VdN7Sl1E4APaP6rywr5ASRRgHrO
3zQyf/ruYEXCB0U2z9EKep99KWyNCbGcc5S6e7h+KEiEvCtj88JazNr1tWXFopo9
T3lx8CaFbSEem5g+uaXrIw1nSqtZXNkGGBlJ8+nw6f0UbA/7qOgZd1CvltH25ivz
7wSf6w468fpoRJg07WzR6irwGo7/UheTbZINNkzjIhbqt2oGlzzgNiCiZyORLp+Z
dnhCKjshWzSApxxEAB4wlxQF1SStb8KOp2VjcU6YBeW3ppJU80Jfk7hGmL+S43dq
XQrdhEMa/s64aWK9PDOKonRbzlQqR9jTo1osFtIWS7LTryu8I2gXMCA30JhJ863f
KxGaHPSiXSmKr9Orn169UuDOfpa4/HLR0PRzqEysXLKqVEBHqdZ9XMvLKKn9R+As
pL5aBX0Uu1w=
=XpMw
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
