Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38460 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANJic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 04:38:32 -0500
Date: Tue, 14 Jan 2014 09:38:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck does not fix
Message-ID: <20140114093808.GD7221@carfax.org.uk>
References: <52C87B67.1040503@friedels.name>
 <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
 <52CC65C9.3090605@friedels.name>
 <52D08812.3040707@friedels.name>
 <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
 <52D317CF.2070007@friedels.name>
 <EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com>
 <pan$e93a4$196236e0$f9702991$6860b33e@cox.net>
 <4A0D47A5-0FBC-488E-83E9-311FE89DBB03@colorremedies.com>
 <pan$8a0dd$9f46c908$89053e7c$efd0a239@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
In-Reply-To: <pan$8a0dd$9f46c908$89053e7c$efd0a239@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 09:30:14AM +0000, Duncan wrote:
> Chris Murphy posted on Tue, 14 Jan 2014 00:49:13 -0700 as excerpted:
> 
> > On Jan 13, 2014, at 11:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> > 
> >> Chris Murphy posted on Mon, 13 Jan 2014 17:40:33 -0700 as excerpted:
> >> 
> >>> btrfs-image -c 9-t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>
> >>> 
> >>> You can keep it handy in case a dev asks for it or you can attach it
> >>> to a kernel.org bug report.
> >> 
> >> How big are they?  manpage says it's metadata only (data is zeroed),
> >> so I'd guess one could expect it to be about metadata size as reported
> >> by btrfs fi df?
> > 
> > # btrfs fi df /mnt/isos
> > Metadata, DUP: total=1.00GiB, used=289.53MiB
> > 
> > 193M -rw-r--r--. 1 root root 193M Jan 14 00:44 sdb.img
> > 
> > Guess that's too big to attach to a bugzilla bug.
> 
> ~ 290 MiB metadata, ~ 190 MiB btrfs-image.  So roughly 2/3 the size of 
> metadata.  Metadata minus file tails (which are actually data, thus 
> should be zeroed)?
> 
> Thanks.
> 
> I wonder if it compresses?

   Yes, that's the -c9 option, and it compresses fairly well.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Questions are a burden, and answers a prison for oneself. ---    

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUtUFgFheFHXiqx3kAQJC8BAAvUHT5IfRurckeRvNOCqoV3BWugjY/YW7
P7bgq33WdOBch0KApIfUZPtI5UNEtC5lWElaC+WhsBvqrBx4IH5GvG50aBcrO/Wn
neLghuo38CPOBNyzxzJHpGnJVvbBPVazL8kMQ1BWTyalAGJzBcJjSg3Hj0EV6Cv2
3SSK01N29/z7an7S/mX/e7BO7djVyyR+M1/qh8YoxJv2H/30QH2rc3zQXgbKefsP
HadWrcu7QJ5xF94khJN/FUz7d94hZkSPvp60BABtNeOL751PL/NXRLuhjXchd99V
gwqPpQLXL0OJ/3Zge8bat5qnJqLAEAPg88nLTVL/e0IX2ftdyoBs1Qvpe1BCBsGE
Cv1fDJVJhVgrTdeskgzhecBIqmNAXp10amA7cRAxCqaEo1Hlbf+NpmhsB2uVuiim
7VxLbv3aocRJ4iaFqqeibew+VS/yw0JJqMpx9b16i0yVxtjEOcnJcO4SO+85pr1i
vwFJn7TdDFN3vviUIHdYfkagHDit4XIZdmXO4ZXXxlLJfeXbkXdR6XxUtTVyUHW0
lFvJz1yBblTsaTOYWDRNRmjsd1cBsJxbPkypfp0haz3UFegGfZxIPFNqBxeXiWA6
IbSQ4vue1zqMg6E4zb9xe0rM6MPE7gcSEA9cA8DWiWKGli6bdkPV/PiVLW+KhVhZ
IjeRfw6CaeU=
=SVwM
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
