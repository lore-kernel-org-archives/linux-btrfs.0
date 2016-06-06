Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46564 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcFFPAh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 11:00:37 -0400
Date: Mon, 6 Jun 2016 15:00:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
Message-ID: <20160606150031.GI24492@carfax.org.uk>
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
 <20160606091729.GX29147@twin.jikos.cz>
 <CA+jCKRUtDqwVppYSv3jCODZW+U-AV5v1421x4TRHjp36aftw8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
In-Reply-To: <CA+jCKRUtDqwVppYSv3jCODZW+U-AV5v1421x4TRHjp36aftw8A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 06, 2016 at 09:43:19AM -0400, Andrew Armenia wrote:
> On Mon, Jun 6, 2016 at 5:17 AM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Jun 02, 2016 at 09:50:15PM -0400, Andrew Armenia wrote:
> >> This patch adds mount option 'chunk_width_limit=X', which when set forces
> >> the chunk allocator to use only up to X devices when allocating a chunk.
> >> This may help reduce the seek penalties seen in filesystems with large
> >> numbers of devices.
> >
> > There is a use for such limit but passing it as a mount is not the right
> > way to do it. Changing the value requires remount, different raid levels
> > might need different values, it's not persistent etc.
> 
> Thanks for the feedback. I agree that it's less than an ideal way to
> do it. I guess I was a bit quick to release proof-of-concept code.
> I'll try to do some more work on the configuration side of things and
> resubmit.

   Last time something like this came up in discussion, the consensus
was to put the configuration in xattrs in the btrfs namespace. There
should be one with a name to indicate "global" configuration, applied
to the top of subvol 5. If the feature allows configuration on a
per-subvol or per-object basis, then there should also be a name for
the relevant xattr (also in the btrfs namespace) that can be created
on each object as required.

   Hugo.

-- 
Hugo Mills             | Klytus, I'm bored. What plaything can you offer me
hugo@... carfax.org.uk | today?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                      Ming the Merciless, Flash Gordon

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXVZAPAAoJEFheFHXiqx3k62cQAKfuJB9/K+Aoct2CcSbFCsIm
WF62XXJUIIw90MGXWsQjmOP7wyxDHwXRxUYffWHOxSCWTVxsxCNnne7NJkH+NsFe
7Bbu2qtYMjXCPFa3jXowk4Mhj0V6KZyzUgxNdFF7UeD9T5nMgFXSVFlmRnGdhv3w
jBjxdfxRhR47Jd9E0HhR4pXJaZAJm6rI/sE5nteG9IsLYiZ0ktPoRfVokaeZV72d
ZylNUP6QijoFazXXH5Q3YsYPsg25zSOPz0B7WOG9KTykNJHgtyeBK1wj/i0mLEIq
mv+u58fkyQ6yOl6gzn1l923uH5AN2Bk45xkofaQDxggxyl3PVqXs/M76zr0z4Dww
NrAlFw2X1hGl+MwfkidjwHskbTqNhuy/TX9kYPc3NPpSj/RI2hufBmkqE5AC6bSW
ibBaUpiOlkkLl2hY2tqnUn11/TwZu5VvBNUm6XJch29YfFL9ta4JjO2y2OaSqvPL
6VJDEq4fxgJynbPGGAUpifm3CcbSkqoUmM9aNwBMl0JutdDxXIF+pSwcdR1Kz0Y/
lqKbf30FsbS3q4Ul6J2IUSQVYz3u0dTYHfQW0Y6LWiVNdo8UTzFDSQKxM55tKcZl
Avj8QBkHaz6C5HubOUnV60FemjgLwpnI4N8bR+oqu1Xsx29mhIWlx646hMCyjfiJ
Z/GluMlpDRk/qEqoogcr
=zQb8
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--
