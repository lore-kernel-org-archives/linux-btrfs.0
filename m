Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38258 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3ATNWd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 08:22:33 -0500
Date: Sun, 20 Jan 2013 13:22:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Reartes Guillermo <rtguille@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: failed to read chunk tree on vde1 (f18 anaconda crash)
Message-ID: <20130120132229.GA28546@carfax.org.uk>
References: <CAPVzhpyj8oXMGyoPop6FadcDRAyDTmvX7VPncBLo0wuUOKxvwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
In-Reply-To: <CAPVzhpyj8oXMGyoPop6FadcDRAyDTmvX7VPncBLo0wuUOKxvwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 19, 2013 at 07:53:08PM -0300, Reartes Guillermo wrote:
> Hi,
> 
> I reported a bug to anaconda (rhbz 901905), but it might be btfs related.
> 
> Anaconda does this:
> 
> 18:49:10,317 INFO program: Running... mkfs.btrfs --data=single
> --label=fedora /dev/vdb1 /dev/vdc1 /dev/vdd1 /dev/vde1
> 18:49:10,742 INFO program:
> 18:49:10,746 INFO program: WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> 18:49:10,746 INFO program: WARNING! - see http://btrfs.wiki.kernel.org
> before using
> 18:49:10,748 INFO program:
> 18:49:10,749 INFO program: SMALL VOLUME: forcing mixed metadata/data groups
> 18:49:10,750 INFO program: Created a data/metadata chunk of size 8388608
> 18:49:10,750 INFO program: adding device /dev/vdc1 id 2
> 18:49:10,751 INFO program: adding device /dev/vdd1 id 3
> 18:49:10,752 INFO program: adding device /dev/vde1 id 4
> 18:49:10,752 INFO program: fs created label fedora on /dev/vdb1

   Out of interest, how big are these devices?

   Hugo.

[snip]
> I booted again and did both the mk.btrfs and the mount manually and i
> got the same error.
> 
> Is it a known issue?

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- We believe in free will because we have no choice. ---        

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPvvlb9z9OVl50rAAQJWug/+MbuX9BYzUP4hYVF4cH5GLeZFp25wcy8U
oXsdZAgxDAeKQ5+9okcW9s/Qds2er71PaWKLAdQyoXlUC1GZb/uunJKZSxaDjpha
996m0tJ6pe0scZd1L7N/AStb6uGfklhxoHPUWM93HfD3QPfStG3syrv/6krQWLy+
LvqZ3hjhK9nrwxk928efbi8ll0YEjx8YQVgqp9WBnTUjjIoZLCOiVJ2xt9YhFc9N
b5qyg2bddsIPashnZfGRvLHOuHPtplFTuAt6CGWK4v/k5z3903g2FuqphjYrJvkv
XA3BRRdHPSAhC0Jd60FcjJiPo6wKFoF4kpTwB6NSRy+qZpITSOvLWw4VjSb+HvZ3
OyQWDqy53veYVZFTd3EKlgf8aMK6agXcYUktihP+9zfCeRwmwDb5l7ow2Qs+lt21
rkpwO/5n4FhcrmcnYx/geoYYyW15U5kfse9cu07ONBVsdxjlx3Gk5vXuG3FCI9Bb
aTxDrLghqYzMeMdzHbAbdrvUGKZQCE8NOCbGg48xbohQrQu+VcRs4ifqYMqC4SlK
KhXJnGHA4mwlwThgCp7tBfMGlODFdFT5154ARZ7gj0PppEYpSb8YGA/aum1IvQqH
ZfzvasyUAclemHxNHUPpzgW7jGz2UuqeQSU1bHGFJrp7Ow0/bQfBUS6Qmi54ufXe
aHIKOvzwvcg=
=c0FG
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
