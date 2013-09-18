Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3IRO31 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 10:29:27 -0400
Message-ID: <5239B8C2.4070107@suse.com>
Date: Wed, 18 Sep 2013 10:29:22 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clmason@fusionio.com
Subject: Re: [patch 1/9] btrfs: add ioctls to query/change feature bits online
References: <20130916181910.799140428@suse.com> <20130916182017.776301648@suse.com> <20130918141459.GA6810@twin.jikos.cz>
In-Reply-To: <20130918141459.GA6810@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Ml94uKLMeOe1nbgUTDLX7R0pSLtwHvro8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ml94uKLMeOe1nbgUTDLX7R0pSLtwHvro8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/18/13 10:14 AM, David Sterba wrote:
> On Mon, Sep 16, 2013 at 02:19:11PM -0400, Jeff Mahoney wrote:
>> There are some feature bits that require no offline setup and can
>> be enabled online. I've only reviewed extended irefs, but there will
>> probably be more.
>=20
> Each feature bit being set online has to be treated separately regardin=
g
> safety of the data in flight.
>=20
> You can set extended irefs online, there's only one place where the bit=

> is checked (if the hadlink count overflows the leaf), it's ok to set th=
e
> bit anytime before or after and it will not break anything.
>=20
> Skinny metadata bit is checked all over the place and I'm not sure it's=

> ok to set it on after some portion of data has been processed in the
> non-skinny mode.
>=20
> 'default_subvol', lzo are ok, the rest depends on mkfs and can't be
> modified online at all.
>=20
> So, for skinny metadata it's most likely required to set the bit in a
> delayed manner and schedule it eg. to post-commit time.

Yep, that's why extended_iref is the only one I've enabled so far. Other
features with harder requirements are going to need to be handled
explicitly.

> The sysfs and ioctl interface looks ok to me.

Great, thanks.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Ml94uKLMeOe1nbgUTDLX7R0pSLtwHvro8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSObjCAAoJEB57S2MheeWyXhcQAJndIMroY6S7ibrHDpxyThFC
nrHUJNGaTSNChmcdjfFn2EszA5umPOdqAAucY2QozY9xy/4KFyrdFESd9T9PIqK2
D0EcdiHNz6OFjCDMH0npVMC1YwTLRQ5dxjvn+6YPGyww+tyfy6Xe0zLomo9ar5U6
Hyux6DvkVKtFn2ce/w6rtLFrVe7gHfJdTfCNJDT9EJjb7XO6DqUhZyWN7hELs5r1
NOG/TjgMW5XC+kQOYRYzn/GqD+XBtFe13lRTCByfH9r1DbN2v534XIJSHcp23tjl
u/CzTECgLaAlkuHBMolYbHzoeVXNl1JYYSuYxrGQpXoylAGQSquXtmazBw/r+VlH
m92pIrnDfywz0s+yMFajrKqVbJK2CFBqX9HrHR4H1dMUgum/uarZbYTU50gogHpJ
/GL41NywA6iHFwFGx7HOkW8fGmBOlPRyRdLhK5rJfoV3JekUQeRVFQY9kcrjWXjM
yGYzByXGiYsObER5QY5LbMfNFH2nTcIB3l6MCBh3PNOqWNHC/FL0rlG4+Xkd0ifE
HZNdR3/uMrx5pIVe5/SGghH614V/F+CRgD1w4pFdPu+MivalrCiRFCzWlTXJC2Jb
XwmSN2LcSqR4+GiIxt3Wt5b8JBcBFyW+lrDkAaFKm1xxzHW1JDxletMn2T5D+92C
pb2uYjpJ2ghxRYkNraPo
=y9WJ
-----END PGP SIGNATURE-----

--Ml94uKLMeOe1nbgUTDLX7R0pSLtwHvro8--
