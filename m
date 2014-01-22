Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36998 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaAVNfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 08:35:33 -0500
Date: Wed, 22 Jan 2014 13:35:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        Tomasz Torcz <tomek@pipebreaker.pl>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140122133508.GH3314@carfax.org.uk>
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <20140117160436.GA3356@mother.pipebreaker.pl>
 <8E968DF3B7EC0D40B67B5A9D25675A6A0400BF@MBXSRV03EDU.edu.local>
 <20140122120533.GE6498@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wj9ZLJVQDRFjGSdK"
In-Reply-To: <20140122120533.GE6498@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wj9ZLJVQDRFjGSdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2014 at 01:05:33PM +0100, David Sterba wrote:
> On Sat, Jan 18, 2014 at 12:50:54PM +0000, Toggenburger Lukas wrote:
> > Hello Tomasz
> > 
> > > Have you considered per-file/per-directory selection of raid level?
> > 
> > Sounds great, I haven't thought about it before.
> > 
> > Do you or someone else know what the current state of development is?
> > Is someone working on this?
> 
> The feature lacks interface to specify the raid flags per-object. This
> is WIP, keyword is 'properties', you'll find some preliminary patches in
> the list. This is the ground work for all sorts of fancy tuning.
> 
> The filesystem split into areas with different raid levels will bring
> interesting problems regarding free space and operations that cross the
> raid levels. But I think it's doable.

   There's some potentially horrible ENOSPC cases with uneven-sized
devices. I need to run some simulations to see how it'll behave...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- The early bird gets the worm,  but the second mouse ---       
                            gets the cheese.                             

--wj9ZLJVQDRFjGSdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUt/JDFheFHXiqx3kAQLoIg//SEHTSa1VrOJUAG6ui392G+Xjt5s58cem
zKcL8TNMiCuPoTDtEcBXGp4gQKRTIuRmcVJU2oc2TPETmfERJkkj7UoU7Yur46SM
3L3BEntIgIs+pKIeVTcdcTpFZW51aOdKoUpVuJRq/EtkP3g0T6GhblI8WYHZyRqu
3BYon/A5LyQ2T/zR4tAN3VLaFPfV50/4e+rAQ0ujawQBWhg8ohArahDbffYoHV8l
ktnZZggU2FvvjkCPuFWEIjUcUV2vAooOWXsLQKy64ybonTwR3NCX3jt3hVVJ7I4m
3HJ+feczRe/tWmQlGuHmo58WR1XFayyknmcoeLZzyYz0pG5KYnx02FA5vRFlISou
yi1PvXDo7w/ar7ha9ypiKnyd9w5KqbHiErkFIuJ53YelIQtieiyKBW8JMFYrintf
dSIqOux1su+Q87ZNw57Y6l+NzlhhOvAosq2zDrVX1yNFoZcn1ZYl1vEbBLnjjN/+
DWJSjsGq9YB/Re9cZQbLZTlpHJv6FpMzBjJXBEIUxh/Q+thxUs10ng0A3tvZEKTP
+uz/npvuKMSEciYcSnvNfpVbzdPivMTs384CPHyLJKeZcCYMgVShWqQksZaS+2uu
nETPouv0MrolNhxHVIShuvwzqZP5jDNzaI+/pTRpAcwRtVytvgzNRDObLHdFNGUF
LEdpI2cRSnE=
=c5ZT
-----END PGP SIGNATURE-----

--wj9ZLJVQDRFjGSdK--
