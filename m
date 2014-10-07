Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33940 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJGJGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 05:06:12 -0400
Date: Tue, 7 Oct 2014 10:06:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Juan Orti Alcaine <juan.orti@miceliux.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Identify mounted subvolume
Message-ID: <20141007090608.GE11870@carfax.org.uk>
References: <c7a9551462105e36f8ac5f874d19e9c2@miceliux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
In-Reply-To: <c7a9551462105e36f8ac5f874d19e9c2@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 10:47:56AM +0200, Juan Orti Alcaine wrote:
> I cannot find the answer to this one. How can I determine which subvolume I
> have mounted in a certain path? I'm looking through /sys but no clue.

   Rumour has it that /proc/self/mountinfo is meant to have the
information, but I've just checked, and it doesn't seem to have the
subvol in it on my server (3.16.2).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Unix:  For controlling fungal diseases in crops ---         

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVDOs/1heFHXiqx3kAQKR+w//b2lIhjwKI9RVKyQjt1E6FmVl9aXC0qxs
SONGE1/ud7vKqy0etCRvtGMHq4IIoiW9GK75JVvimWfpybHpcADbDHHAZ6aw15E/
tr9kadsNAsCw4LNuxrCUvzMiqixbFk0MR+YZtNi7N38v4hr5pneULRMRRxgpY3dr
Pm/G/Hd+jeW1CopTH8gq/dvxy6jISEYZrlOUPDtl8snNFSwoC0k0A+CPQ1hrh4Uf
Cm+FvOJoOklf8RuIId2K3DdF7MNtzwIqO4Sy4NSC18X+G/IQF/fEHqsnMkEV59GG
m6To/K6aurDSUAeZlt7h9S25ft0bx/4a0u/w1f8BmomCNELVFyF6RyZPqLPqG5Vh
FHgbfuxKkVZFDzq5+CyppFIphMevHf3en2BXnTVjx9Ab7Vp74glQKfWAJ2BG8FO7
rJbLJflq7bv/yZOvU9Vq4NdttDFGGoN0tkAyu99O2GAbmtH3Esu64NvGlidf7bXe
bc0w2moV7XmK5AZE+aan6z8d0Z8OIyZXfk6S8V7aan4DW8b47EZ90o31cdZRA8cm
ek8Ig0tKvOJEtyxzyCreTjCYTL9ZIdCOE4Yrxg9znggZ7wPGkdpgQ1SPH/5akljd
rjZEMprv305YjoLQLRyYonF1MJ2DyrWR0zvPDO724gh32ZhuOUObeuYc62oLEtrb
Wo+YIzquat0=
=ndBW
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--
