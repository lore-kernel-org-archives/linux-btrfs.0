Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49468 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbbJHVNy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 17:13:54 -0400
Date: Thu, 8 Oct 2015 21:13:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
Message-ID: <20151008211352.GC25907@carfax.org.uk>
References: <201510052226.47051.pisa@cmp.felk.cvut.cz>
 <201510081028.02178.pisa@cmp.felk.cvut.cz>
 <561657D5.1070809@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3y/CVJp2vtgPOhvS"
In-Reply-To: <561657D5.1070809@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3y/CVJp2vtgPOhvS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 08, 2015 at 07:47:33AM -0400, Austin S Hemmelgarn wrote:
> On 2015-10-08 04:28, Pavel Pisa wrote:
> >I go to use "btrfs replace" because there has not been any reply to my inplace correction
> >question. But I expect that clarification if possible/how to resync RAID1 after one
> >drive temporal disappear is really important to many of BTRFS users.
> As of right now, there is no way that I know of to safely re-sync a
> drive that's been disconnected for a while.  The best bet is
> probably to use replace, but for that to work reliably, you would
> need to tell it to ignore the now stale drive when trying to read
> each chunk.

   Scrub is officially what you need there. I can confirm that it
works correctly, having used it myself after accidentally unplugging
the wrong drive.

   Hugo.

(Sorry for the delay, I wrote this earlier, but had trouble sending it)

> It is theoretically possible to wipe the FS signature on the out-of
> sync drive, run a device scan, then run 'replace missing' pointing
> at the now 'blank' device, although going that route is really
> risky.
> 



-- 
Hugo Mills             | Gomez, darling, don't torture yourself.
hugo@... carfax.org.uk | That's my job.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Morticia Addams

--3y/CVJp2vtgPOhvS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWFtyPAAoJEFheFHXiqx3k2ScP/RIV4HDChKBjgOCGxQHZl4IA
2SspqucXcnAtB91ZpcKX0xa5TUla1Q/SVr4OIlnRp0HmOzf3ksl8vkf7qMSuc2Oa
Uhx3JIhWImsxrMDqUH1CuSjQj/i2CUsAK56gVgTeMwlWW3X1bAL6TA39OqSLn/rh
q/RxEhmE/0guz3uv7FGnkYIe4oyn21wmm6Lazjm1PDIh6DZm88pw53PujsAbZ05f
BEktqLHmydePQT0j2JAQ1QJkrNCOnkKnpnZwqkY8ADlRN04g9Xn5SLouv+xf4mkf
1hp4oFZSi4y8xD+XPTynqjdfTZ2j7BQSqN4uO4Q2cDE7PTOPzpYuNkmG9F9iZ/xg
CZ9xM+Mschcdg+nJA1yXvzc4SR6IgUUH2lX/LcucjccG9PMcJLhbypeO0/fgFOZU
meTuITTmX6KZ/1EWWQn6WVVjnTSKTYVJVFIWbBJYQ0V4KEQzPq2xWCSpE3BA1UBR
ALE1b6ef3+O4YwG58fVBGyonXHt3iTtaozHW8iWDLN6XX+Q5u9Vy6R0ibletPAGY
to9W9p7EwFTfSWrpVxhFn4aQzw7dzMDcfmMRA2UXfHFigAgY1uHgdg3c32m7SHka
KhjCu0dJSs/tweZzjSMH7D6Kp8PffhNoplW8uQz/D3oMSKl7ScH3R4xHrmI1Ff9J
Tg5EEG9UnvCda3GKCVKg
=SeM4
-----END PGP SIGNATURE-----

--3y/CVJp2vtgPOhvS--
