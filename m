Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50732 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3GNPO0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 11:14:26 -0400
Date: Sun, 14 Jul 2013 16:14:21 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can btrfs handle different RAID levels for different subvolumes?
Message-ID: <20130714151421.GD29644@carfax.org.uk>
References: <51E2BABB.3060506@statystyka.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
In-Reply-To: <51E2BABB.3060506@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 14, 2013 at 04:50:35PM +0200, Adam Ryczkowski wrote:
> Can one btrfs filesystem handle different RAID levels e.g. for
> different subvolumes? If so, how does deduplication with bedup
> (https://github.com/g2p/bedup) across them work?

   No, not yet.

   It's planned at some point (probably in the fairly distant future),
but hasn't arrived yet.

   Hugo.

> (It has been asked already on the Net (http://unix.stackexchange.com/questions/82869/can-btrfs-handle-different-raid-levels-for-different-subvolumes)
> but the question didn't get the answer. I guess answering it should
> be straightforward for you, guys :-) )
> 
> Adam Ryczkowski
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---    
                       cool,  and punk mainstream.                       

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUeLATFheFHXiqx3kAQJdhw/8CTs39fwP9q+cgUIiE3jtm/KCPUdLTRCZ
lfYz705EfyVdcdMrlH7BIpUg/bE11LFTKVm0Oa/1obXbEQ2M2lDzTJL+pToKiVLr
iqTLLocdfXEUtetYM+Fmip836EDS4LQ7oUK+KO9QtwseQUfyfAHjmgwY62tmcJbz
rjm8LL8MXapzVVQZYczhJ8ITH8UmWZq1CMpmYucmNPOwhaOr1jN6UnI6IJGit/GM
5q0tDyJJ7wD7Eyrz6iqxuY9y5zpkeMSrXBBhR9soaPbaMttSPO+FPyx9DyUrPrMN
AgT8QGRDcbd0dtBC0q+ZeSbRvSgEOnp92P7qlVjTRLWSmnOlYvE2FFKd3VqJ1tDb
0fVb0loVfTU5wCUid2uREcmrqOYbJR/2zDPYkNvCUSSJtJzwYfjIKQt0eWe1JmWo
9n2lz6gr18z+ctthUcq3Aon0F1CrQ6/nWTZ9qTvMxVadNqEaOvYLHWJ+YhbiNWwq
LGwXQqD8seHkSvxw46fJIr4HFljcjwN7LfyySnZ2FLM4B9lGnZxuka0pr1B9xCBh
rNFFFzyGEjHscb3SZ/2Se+DtPznqeqEhR1in70GrnP3GUVrJWqoz++0aVKkVb9hS
oMjVaaCBVx3nC36cQIxcedipAX4oQmK5Muf51DEEL57+1BxHEKjnN2/LyVNFfEyB
3JaJCK9sZfI=
=V5hh
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
