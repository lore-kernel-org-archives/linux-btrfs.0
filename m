Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48145 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab3ANRl6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 12:41:58 -0500
Date: Mon, 14 Jan 2013 17:41:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can moving data to a subvolume not take as long as a fully copy?
Message-ID: <20130114174155.GA19051@carfax.org.uk>
References: <20130114173250.GA23026@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p76r+0aZ/vhNbw2t"
In-Reply-To: <20130114173250.GA23026@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p76r+0aZ/vhNbw2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 14, 2013 at 09:32:50AM -0800, Marc MERLIN wrote:
> I made a mistake and copied data in the root of a new btrfs filesystem.
> I created a subvolume, and used mv to put everything in there.
> Something like:
> cd /mnt
> btrfs subvolume create dir
> mv * dir
> 
> Except it's been running for over a day now (ok, it's 5TB of data)
> 
> Looks like mv is really copying all the data as if it were an entirely
> different filesystem.
> 
> Is there not a way to short circuit this and only update the metadata?

   I guess the best way of doing this in this case is to teach mv to
do cp --reflink=always then unlink the origin.

   Clearly that won't work over mount boundaries (where a copy of the
data is the best you're going to get), but that's not what you've got
here.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---       

--p76r+0aZ/vhNbw2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPRDY79z9OVl50rAAQKlkBAAmrqE+Rleq9f/JS5uIssCXj692wz8bNAH
/7xFJCZOVHNsNa8gxXpzwNa8UDzBerz3ykVzlfjaJ0Ax8VtXMj+u5Xtr9frHZB8B
tTNqZZk4vmfR28axMD3U97C8nlnD05vs5zBIFjIATTinIWoYxqw//iSon2GfDU0m
J/+brI4iYMmQ3Oo1kBuTZCObnumyJP+aCvQj/KsGGbzoFSiN8y2kwYMTT5BsNEN+
GGy3z0BSLK8uq6yyHWWj0Z1zTaVxs8f2nxYlbrMS9NWZ2dZlQrSX83IgEuHaZcc9
Jb1tmAE1yNjrgzgpY2o0nGss7UAG6NQIuu2rwxHDGdFk0IOHjcHvimRRxuBOZA2g
1LrmaLMcoLycNl2TJCG2QAiBNHovLdhKGt33y5Mt/CEkPCJLcTEErUJUOHZEj9u3
jcaWKAM4K7VJCOrA0J/nZeiSKAROUekQMj/SpXcNHWQ1M3JwfWTqsN4Zmq1jw9DJ
VUHYTQ5os3HBUbeltQX3r5zejBMabE/U2FvQNKjKZIgVjJQT0TvNROICAadlr3ff
+tlhdy9/xqMO608HDJd8XGJfL6Mq9VuPWG26d+Ze1yh3HX0SdjL2SCjFXxfFNK84
Fm025nMH4n+AiD3lI4X5W6LQriq7gRrIzVTFzb903FTtPiIo0pMHzpR8t++L0Jkh
wG5Lhmt232k=
=69jD
-----END PGP SIGNATURE-----

--p76r+0aZ/vhNbw2t--
