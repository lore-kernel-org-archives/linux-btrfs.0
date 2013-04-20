Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59047 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab3DTVXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 17:23:13 -0400
Date: Sat, 20 Apr 2013 22:23:11 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: data DUP
Message-ID: <20130420212311.GO7639@carfax.org.uk>
References: <kkut3u$lp1$1@ger.gmane.org>
 <20130420204814.GN7639@carfax.org.uk>
 <kkv0gv$jpo$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/jkxxxtAhYIHVDuh"
In-Reply-To: <kkv0gv$jpo$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/jkxxxtAhYIHVDuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 20, 2013 at 02:15:14PM -0700, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 20/04/13 13:48, Hugo Mills wrote:> On Sat, Apr 20, 2013 at 01:17:06PM
> - -0700, Roger Binns wrote:
> >> When I try to set it with balance there is a kernel message:
> >> 
> >> btrfs: dup for data is not allowed
> > 
> > What kernel and userspace versions are you using? I thought the 
> > restriction had been removed at some point (but possibly I'm just 
> > misremembering it).
> 
> Whatever Ubuntu 12.10 ships with.  Kernel package is 3.5.0.27.43 and
> btrfs-tools is 0.19+20120328-7ubuntu1.  Note the message came from the
> kernel so it would appear to be solely to blame for refusing my request.

   OK, I'm not 100% certain, but that's probably too early for the fix
I was thinking of. You should upgrade anyway -- there's been a number
of serious bugs in btrfs fixed since then. Ubuntu has new kernels in a
PPA at [1].

> > it can be quite hard to find every single implication of a feature when
> > that feature gets changd/updated.
> 
> I'm more amused that someone went to the trouble of putting in kernel
> detection and messages plus updating the documentation in order to prevent
> using DUP for data!

   It'd have been a mere couple of lines of code, and probably there to 
match historical usage of mkfs (which I believe has also been dealt with).

   Hugo.

[1] https://launchpad.net/~yofel/+archive/btrfs

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- A linked list is still a binary tree.  Just a ---          
                          very unbalanced one.                           

--/jkxxxtAhYIHVDuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUXMHPlheFHXiqx3kAQKpUw//Xwrd97ftOOcXnebOquWDtsPy1jiXy9Pv
DSUelaFi+dW1k7Ol4fSDHpwNklpSHh0/jkeZnQzYsmuevqblPLhkt8V+yKkt8BcD
DNHIhjD+4k1aUJiOSX2/cwMGIkL8TNXg3WVEsI4HG8yoQfQa+YX+LrKZbXJEJ8JK
Muf/I2h5mE7sif00wFAQKWiJN/a1pIxrXqP18KBUxrO4O5fQ8uenerMBzEQxSU2X
D0sng7Dy5TybaNnr2EFRNRVt1SwtgDl8vRYhHg0NncWY/Ar1oWml3uiUNygVhGyq
a7DunHK53jXLZOmNi6Y0reN/hcdI1e0DIIty9w8AwVdmGk6Jm7P4R1dbxyVvijuT
1tebiz7WN5susdDNgzBWpgs8QIOQhA4W2QCIVxtSzYIQcWb7Z1HIgOoCbuG4TXIR
l3jzF6mV9GT/GMgtbDS5DbNyFqWCITS3FPxKOY9sKKx/voHnhZICHGa/5f1kurlF
grQZm7z8NByLMppXXEF0wPOj5yTFOVeMk2/zTbZwESqqEp1TXDmOqeJxq6YSbwS5
qKFpU7xHeD2S1T4mUPshfgGuEcY1GV9yqcU7Y7Ijbwipqpxns0cDuQUtaqHBUDWk
sJliIgytzHp9sOY/0plf0LiXd2KYTWC5G411khKYpj4Wp/UnjGx9FaPepNXXANYj
G79sxn91ioE=
=f/cm
-----END PGP SIGNATURE-----

--/jkxxxtAhYIHVDuh--
