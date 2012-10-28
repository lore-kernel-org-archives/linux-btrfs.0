Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58847 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2J1N0m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 09:26:42 -0400
Date: Sun, 28 Oct 2012 13:26:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Ronnie Collinson <notthinking@gmail.com>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Subject: Re: How does btrfs behave on checksum mismatch?
Message-ID: <20121028132639.GC5042@carfax.org.uk>
References: <20121027215645.GU2381@yeono.kjorling.se>
 <20121027220940.GV2381@yeono.kjorling.se>
 <CAGa+R32R83cAWLQO4Xgwcvp22r1oPkWhmEOMiWB1HUTSb=r18g@mail.gmail.com>
 <201210281423.51427.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
In-Reply-To: <201210281423.51427.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 28, 2012 at 02:23:51PM +0100, Martin Steigerwald wrote:
> Am Sonntag, 28. Oktober 2012 schrieb Ronnie Collinson:
> > In a raid1 situation, it will also rewrite the effected data, on the
> > drive that failed the checksum
> 
> Will it do so without an explicit scrub?

   If a failed checksum is detected, yes.

   If there's a bad block, and the FS happens to read the good copy
first, it won't fix it, because it hasn't tried reading the bad copy
yet.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUI0yj79z9OVl50rAAQKY5Q/+N3jeJTuuB/Ii4HHPbOcd1O4C2ewNnUT1
RzafOnXBvjqglyv2+xT9pBHkc0e3pveXcn5kA7xK5V+AArubwpD2+fLqCijzhLMm
CsGEKK3Svnd55PS1RjdV8dedLNWpNxUov4QkH7OAVF/Pr6d2Nnfw6dmsuaV/hb1P
WEBhmwyxdRZdiicC5PMBp83HeDmY8MGT8ODhDI+7Y94NbjWooxhJGIZutTLqsAwP
mwQ1PzsNrA8W/FHCJ2MUvn4JD+B0XNozi5ISkSYM7F3Z6wCkTRevTD4NqKQy8efP
rbXM5W/ndQc7nbOXeTO3zK5fdFmU6NWVcjx3PhcOyklKD+lhJyVelkn74NikXs45
nIAlQvxMaKizr4Cnzc4rlJr+sNwH8IXC7+YYkkOTqz/MGQTipxOwW0FmvHlTHrsv
1A0XsxIWoWRvcMmPG/1EMIlakVofEez6349h+wD342Xt48/kdpcw9qhlK1ZMxftd
HeZbiKhsOAIM7gqpsgOWe7Pev8msePn8S1tPyW6vWVjz9KpU8wDJ1abLW7rzTNgy
/dbtgj3EeWCsXwCQBdPiZObCQXtldSFslKB+dGLII9igMknOud22+XQvJxPyUmq0
bMVB1NgMb5fKOgD7WAUXyf01I9JUyWC9R/UABxzSRS3qdFsk3NmjY1b15i2g+TX4
SkGxCInAwa0=
=FWat
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
