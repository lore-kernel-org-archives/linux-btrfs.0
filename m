Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49375 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbdBGOBB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 09:01:01 -0500
Date: Tue, 7 Feb 2017 14:00:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Zaitsev <pz@percona.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS for OLTP Databases
Message-ID: <20170207140058.GA4249@carfax.org.uk>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 08:53:35AM -0500, Peter Zaitsev wrote:
> Hi,
> 
> I have tried BTRFS from Ubuntu 16.04 LTS   for write intensive OLTP MySQL
> Workload.
> 
> It did not go very well ranging from multi-seconds stalls where no
> transactions are completed to the finally kernel OOPS with "no space left
> on device" error message and filesystem going read only.
> 
> I'm complete newbie in BTRFS so  I assume  I'm doing something wrong.
> 
> Do you have any advice on how BTRFS should be tuned for OLTP workload
> (large files having a lot of random writes)  ?    Or is this the case where
> one should simply stay away from BTRFS and use something else ?
> 
> One item recommended in some places is "nodatacow"  this however defeats
> the main purpose I'm looking at BTRFS -  I am interested in "free"
> snapshots which look very attractive to use for database recovery scenarios
> allow instant rollback to the previous state.

   Well, nodatacow will still allow snapshots to work, but it also
allows the data to fragment. Each snapshot made will cause subsequent
writes to shared areas to be CoWed once (and then it reverts to
unshared and nodatacow again).

   There's another approach which might be worth testing, which is to
use autodefrag. This will increase data write I/O, because where you
have one or more small writes in a region, it will also read and write
the data in a small neghbourhood around those writes, so the
fragmentation is reduced. This will improve subsequent read
performance.

   I could also suggest getting the latest kernel you can -- 16.04 is
already getting on for a year old, and there may be performance
improvements in upstream kernels which affect your workload. There's
an Ubuntu kernel PPA you can use to get the new kernels without too
much pain.

   Hugo.

-- 
Hugo Mills             | I don't care about "it works on my machine". We are
hugo@... carfax.org.uk | not shipping your machine.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYmdMaAAoJEFheFHXiqx3kVcYP/2TJgPQDbzOnXvMLE3db+2gI
sZpW+cau8pbg5xP9qAuUfX7m75Kgh5w1MSSETed9/ijT65LBi2VvJ91R+05EnUjW
1zSUH9mINXuleMKtBEIFH51dD/BowpGJcFx486xAtFa8DGXBKuf+O4QveNjuF5kf
tCTaQp4mEMCnbDlsUAASdOT81+drgzmJ5EcgZzm/TtBA/qUt65g7yRUtGRWxzUsh
x+eySsmghFzyUrxiLY7Wd85/DVdEayUQkcBFEmAetOCVWpGRfkkCJIvleoqkATrI
UztrJ9sADJmfvrUhI+/5ttHQNpzMLY/03PxzUtfbc2Krtppv1LhmBgAfUPvWD/Wq
M1wXXZLO21xpYAGYX5eRgn/uAq1g34SzGbgc8rCuoJI87kVob8ZJrJ4t9ymsiCnS
sENy3B6TAaPTPRj27yS0KBDVLGiDxSBQX4jUAN6tUxoNjJ8KGWKeqG5Y5S2x7UKZ
CKa7VQ1ptu4/6yBbPftdgOvJS4lT04faQWmAkAI6EWNgkHWx6ZSeAy/WcHzeGl2v
Qs3WEf87d5g/r35i1ej+VxFLJKxbkdHT9L7n7l1oHlPYLMY9wrI54M/DGNDK/+AT
mHx9wr+bnSUP9Z2iS7N7c/zvr0nlnntZqEQj3xKhH4HRst2+azKMkyXZsNoqt84y
JJSivhkrt+DjzfGpBScI
=Zow+
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
