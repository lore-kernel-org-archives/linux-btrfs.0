Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42605 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaDDR7b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 13:59:31 -0400
Date: Fri, 4 Apr 2014 18:59:25 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Lists <lists@benjamindsmith.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS send/receive limitations
Message-ID: <20140404175924.GS7442@carfax.org.uk>
References: <533EE2BD.7060608@benjamindsmith.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KD3NH8oGZ7XN2Llp"
In-Reply-To: <533EE2BD.7060608@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KD3NH8oGZ7XN2Llp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 09:50:05AM -0700, Lists wrote:
> I read recently that you can't send/receive concurrent streams on the same
> filesystem, which begs the question of what is meant by a "filesystem". Is
> that to say that you can't send/receive snapshots on different subvolumes to
> the same "root filesystem"? Or that you can't send/receive multiple
> snapshots on the same subvolume? Can you send/receive a snapshot or
> subvolume to the same root filesystem?

   The restriction was on the same *filesystem* as a whole: there was
a global lock on the whole FS, which could cause deadlocks with send
and receive both accessing the same FS (any subvolumes). I don't
recall hearing about problems with two sends from different subvols on
the same FS, but that might just be because I wasn't paying attention.
:)

   I think those restrictions are gone now, in some patch in the
pipeline. Possibly for 3.15 -- I'm not sure if the patches made it
into 3.14.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Gomez, darling, don't torture yourself.  That's my job. ---     

--KD3NH8oGZ7XN2Llp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUz7y/FheFHXiqx3kAQKu5RAAiaQxOJFSOgBBrVzOUUsOC93QMvcgiboP
gdXFMkYiyXy7UyTClouR+IkI+z8OzZqmcFcopnBrTktVX3KMARjC5qshLAK1qSld
rw5JA1+GEpJD8clnQY5pl6N8EhA0mSXypDAze7XNr5aisEsQmWZBZpW22mROTkr/
9mIbAFMhpvZ4kwfNv277TAojHkc8wBQY2NjNKOH3ZBCDQANKGPWXkNTLlSzhHLGb
sfjRFrCGQIpv5cV05FitpDth9Fug03k7baIYdcQwtaOdBsLDvCfd0bOj9OGq9qkK
FDRo/A+f4Gk/ZGZfd6bVch2Zy73a5srpW+Y99HhQqBr8mnYykIfIHh6TjJFdh4sm
hhEBL2Z5a2BR0W9BLXfFP+EeoKLarALiqZF5G/8OdYGy6rZ7H6EOIpZjx9SQZDmQ
0kwYRYb8L+xfY0v0HpZ70eu80Ndl+ZzjATgpOz5wOi2C5mPDEBgy16uOkd1OGJs0
nT41D5h7avX6IIIN0FKPQjO1QH43Zfy8MwjlJr8ZrW06ZfOAHnKcMcPLGAIiitd9
Narml6M7CSgI+Px+QVk2RALc3UyGwfUe57KktkKR9QtixCAWRMJa9Rjt0JjXTMak
F5B3J0QLZFk9zyiCkVMLhdd2MwnESusIDL3OnYw2tr5U9Pw+i83q0OjEnLcIRVZs
lAVUw8eQX4E=
=1gyx
-----END PGP SIGNATURE-----

--KD3NH8oGZ7XN2Llp--
