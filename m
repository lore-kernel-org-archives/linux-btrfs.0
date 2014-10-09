Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46013 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaJIMM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 08:12:28 -0400
Date: Thu, 9 Oct 2014 13:12:22 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: What is the vision for btrfs fs repair?
Message-ID: <20141009121222.GB10301@carfax.org.uk>
References: <54358C77.2070808@redhat.com>
 <54367193.6000202@gmail.com>
 <pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
 <54367A97.3080106@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
In-Reply-To: <54367A97.3080106@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 08:07:51AM -0400, Austin S Hemmelgarn wrote:
> On 2014-10-09 07:53, Duncan wrote:
> >Austin S Hemmelgarn posted on Thu, 09 Oct 2014 07:29:23 -0400 as
> >excerpted:
> >
> >>Also, you should be running btrfs scrub regularly to correct bit-rot
> >>and force remapping of blocks with read errors.  While BTRFS
> >>technically handles both transparently on reads, it only corrects thing
> >>on disk when you do a scrub.
> >
> >AFAIK that isn't quite correct.  Currently, the number of copies is
> >limited to two, meaning if one of the two is bad, there's a 50% chance of
> >btrfs reading the good one on first try.
> >
> >If btrfs reads the good copy, it simply uses it.  If btrfs reads the bad
> >one, it checks the other one and assuming it's good, replaces the bad one
> >with the good one both for the read (which otherwise errors out), and by
> >overwriting the bad one.
> >
> >But here's the rub.  The chances of detecting that bad block are
> >relatively low in most cases.  First, the system must try reading it for
> >some reason, but even then, chances are 50% it'll pick the good one and
> >won't even notice the bad one.
> >
> >Thus, while btrfs may randomly bump into a bad block and rewrite it with
> >the good copy, scrub is the only way to systematically detect and (if
> >there's a good copy) fix these checksum errors.  It's not that btrfs
> >doesn't do it if it finds them, it's that the chances of finding them are
> >relatively low, unless you do a scrub, which systematically checks the
> >entire filesystem (well, other than files marked nocsum, or nocow, which
> >implies nocsum, or files written when mounted with nodatacow or
> >nodatasum).
> >
> >At least that's the way it /should/ work.  I guess it's possible that
> >btrfs isn't doing those routine "bump-into-it-and-fix-it" fixes yet, but
> >if so, that's the first /I/ remember reading of it.
> 
> I'm not 100% certain, but I believe it doesn't actually fix things on disk
> when it detects an error during a read,

   I'm fairly sure it does, as I've had it happen to me. :)

> I know it doesn't it the fs is
> mounted ro (even if the media is writable), because I did some testing to
> see how 'read-only' mounting a btrfs filesystem really is.

   If the FS is RO, then yes, it won't fix things.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great films about cricket:  Interview with the Umpire ---      

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVDZ7pVheFHXiqx3kAQLa1g/+OLOr0IrOv7Xbvlp9z7XkKtHSNS++GKOL
etFByVWb77M4cgnd0PRnX/VPYR89h3zv+tNBRUL4c9jNmEThDRHlMBScIPfyNGGp
1xCdFBYU7z/IelFMdChX2Cp7Gq/ngA/o22eoginKQtzd9JXQNzkzmg0SBdlgcFxY
qW2fUL+ixOU8f61FR7Zt9G4RykaxgCg0KKwnnzxvI5WC8CquQqOKE5dOgfdHUJME
8eDNm1IVMrTWuqQFESKsAsqY86qRfpW8GNTDI7axqikQDTeElFq108sS2QWQ6ZFk
D7gSg/laFX3ct58+pddCpk1+1UIzB4G6Rner/sDIuSmjVKbu8Is7kCBjZdHpJnkQ
UPOmGrlDdGKLTH2hKhQb3RbaA5k3TZEZkDuxbK/oP7mDew2wQCgqmlp6r6JaQL2k
4VyWUnWb46f3F1W6PIL4wxMd7SiEIiYumlF9nRIwD62zuHzhxJTznP2Mz+8TPcVP
zotKYpwnXqx1PHnsT0PLoGxUchKHjX90nVYRB6G4VqhvJcHoYhFM/+WI2uZ/tIOb
ALgQZ/hlzbphZ4k/wHXrF/O5Zv0083cLwDnUSgAymjdWFe/pSK9N7hGWFyPxRfaP
MqCp2l0SQlaADGXj6c8zHmeyUyeAl7yWwVNMallLbYEwk9H6F/6spyFaOGZ+LXV+
enmqJze71aA=
=XecH
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
