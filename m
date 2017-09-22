Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55973 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbdIVU3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 16:29:41 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LnDof-1dReXO3u3R-00hO8g for
 <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 22:29:40 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: defragmenting best practice?
Date: Fri, 22 Sep 2017 22:29:34 +0200
Message-ID: <6912497.aQNEZV21sa@thetick>
In-Reply-To: <fd4d55ff-3b6c-3ed1-6a8e-1823083243d9@gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170921221013.5576f90e@jupiter.sol.kaishome.de> <fd4d55ff-3b6c-3ed1-6a8e-1823083243d9@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1818318.LJRaCilf5L"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1818318.LJRaCilf5L
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Freitag, 22. September 2017, 13:22:52 CEST schrieb Austin S. Hemmelgarn:
> > I'm not sure where Firefox puts its cache, I only use it on very rare
> > occasions. But I think it's going to .cache/mozilla last time looked
> > at it.
> 
> I'm pretty sure that is correct.

FWIW, on my system Firefox's cache looks like this:

% du -hsc (find .cache/mozilla/firefox/ -type f) | wc -l
9008                                                                                                                                                                                                                                                                           
% du -hsc (find .cache/mozilla/firefox/ -type f) | sort -h | tail
5,4M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
83CEC8ADA08D9A9658458AB872BE107A216E71C6
5,5M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
C60061B33D3BB91ED45951C922BAA1BB40022CB7
5,7M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
0900D9EA8E3222EB8690348C2482C69308B15A20
5,7M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
F8E90D121B884360E36BCB1735CC5A8B1B7A744B
5,8M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
903C4CD01ABD74E353C7484C6E21A053AAC5DCC2
6,1M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
3A0D4193B009700155811D14A28DBE38C37C0067
6,1M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/startupCache/
scriptCache-current.bin
6,5M    .cache/mozilla/firefox/cb236e4s.default-1464421886682/cache2/entries/
304405168662C3624D57AF98A74345464F32A0DB
8,8M    .cache/mozilla/firefox/ik7qsfwb.Temp/cache2/entries/
BD7CA4125B3AA87D6B16C987741F33C65DBFFFDD
427M    insgesamt

So lots of files, many of which are (I suppose) relatively large, but do not 
look "everything in one database" large to me.

(This is with Firefox 55.0.2.)

-- 
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart1818318.LJRaCilf5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAlnFcq4ACgkQv9DmhiyI
ePQUuA/+I5bQUtxjApOruoicirRsgI2PC+ng9MqOgS6T27KSqEfv50TRb5s+/LZE
JzmNxuHidc2GuZekIKk9D8FfbYYPc4VRfC46bRBRj29qHXej0VsgAqfGNuyjuAAv
FZtgFjSIObmQOiF/G1JWmfsg82xvmToyC00jqa9n2D1IoUz+B+0LHMr09oIa2jMY
cX8XNxN3GShXAcw+csX9faOLeTEmDkgG44iLuACrfOOSFR+UB7/v84CRhQCfNfU2
Tps2unD69y7ht4/BJ5Xgr6dv2HTgim9q6g3tBB1nawlCO0RKUbaGq9DSwzBn34TD
X5r/usqq3gXeLhaQ7Y0GzgjqWV7Dgi29Bp9cZYN+tEYp9BIkK9X0z5qo/sO2Llno
hAap/O2uAjj02YLcgy7LXEuLZPxrMLFiBXYlh6JBkujQEnzBU+dbGV/pvYRPNeEu
r9BNA09dWe8hXdRVIhGdIkXokRqIEHfQupo+B7TqNpmMkxA/0hjd/dvXnX/p9wGc
HDTV0HQfoO6ldkHh+9JYhk2WU7lE5sanxtcXR5kK66wNpdRltW4xmGY86lc05Ecc
LsePmujOs0+WsNMH6eJJitXfKb+lPEw6UDq2/ORVgHRVB0JzmQkOTJP8MO61x84b
RsyQdlU1hdOfSrnxzBUajLaTfFA3MgjJgupbRgWpr77j5JzDYzs=
=xNTm
-----END PGP SIGNATURE-----

--nextPart1818318.LJRaCilf5L--

