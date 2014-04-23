Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59852 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaDWWnH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:43:07 -0400
Date: Wed, 23 Apr 2014 23:43:03 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Message-ID: <20140423224303.GB2391@carfax.org.uk>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
 <20140423185413.GF26949@merlins.org>
 <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
 <20140423191546.GG26949@merlins.org>
 <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info>
 <20140423205819.GH26949@merlins.org>
 <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info>
 <20140423220312.GK26949@merlins.org>
 <000a01cf5f42$2b180b30$81482190$@petrovi.no-ip.info>
 <ECBC57F1-E3A0-4423-9248-6D7C72DDF09A@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
In-Reply-To: <ECBC57F1-E3A0-4423-9248-6D7C72DDF09A@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 04:40:33PM -0600, Chris Murphy wrote:
> The screen shot provided makes it clear that one of the following kernel parameters is incorrect:
> 
> > root=/dev/mapper/cryptroot
> 
> > rootflags=subvol=root
> 
> So either the dmcrypt volume hasn't been opened, thus isn't available; or rootfs isn't on a subvolume named root found at the top level of the file system. So I'd say this isn't a btrfs problem, rather it's due to some earlier misconfiguration that's preventing rootfs from being mounted.

   You'll need an initrd to run cryptsetup (or whatever) to collect a
passphrase and decrypt the volume before you try to mount it. This
sounds like a case for an initrd again.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1hB9lheFHXiqx3kAQJ0TQ//Yx0wN0UTQqE/9dpilp5qG1m6oU3pSEqk
0M/To3viu7pNeoslcTqp7oB2BZEV10J3p8Zfg7eoPFCzt8weouivtUfPUt14lu+z
JfG3F02GQVsaDdEnOPteLvOyLWGPcOe9x2bGRoBV6wPycOlAVSZLdmyTXL8G3eQ4
UB74Y2xnBHjq1fZN35q6cH8W49m4nRfnGFWy+wy7x2YUQVC4VulYsRGki/zEAqEA
i7Eb82l2Lrg4mbhw+CAJeLY40xNrJEwDpsamheJ8cPRFNIZNxEDTrD0lHy9MKPBC
AqNg02NaFgADfK0yzrifcThqc3zAmVgWNXZekIEFPuzF1Gc9sYUoIPe8VaRL8152
G3h5OiSF1mDikkp53+oaxhm9l62Tw2VyPyu8M+mjfaFMHZVhX3+2c1IH/aVqBJjB
sdLtPeCrAC0FXop8Ou4habzDMli3bIK22rXNDdlIGc8x5OqAQ827AkzAbjO1DssF
dwSnpIeGtc6hNwIIXCripCff9JRl/ESKx3miN7fx+Xe4kpIw3/1zXgTZUBrrymxW
xh5MI5pwGLd4KMG5zvXWLyqJcrfpj/Twu01lw+aHh0BywmbE+bUdmROyG1CBb2HT
d7zCfVGakJzJOcUT+zts6xTC4VEesvdtPppxlEDAmWdYALyKoWZtchP7/db0UVbQ
5P26a+TKI/k=
=4bY+
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
