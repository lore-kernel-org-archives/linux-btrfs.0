Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52938 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2L0PDa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 10:03:30 -0500
Date: Thu, 27 Dec 2012 15:03:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Another novice question & comment
Message-ID: <20121227150328.GV19051@carfax.org.uk>
References: <50DC5B51.9060506@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ck3np9Ek/EMsFxRu"
In-Reply-To: <50DC5B51.9060506@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ck3np9Ek/EMsFxRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 27, 2012 at 09:29:37AM -0500, Gene Czarcinski wrote:
> OK, this is from inside a shell.  I have a btrfs volume or a btrfs
> subvolume on some arbitrary mount mount.  Is there some way to tell
> if it is a btrfs volume or a btrfs subvolume that is mounted?

   <nitpick> It's always a subvolume, even if you've mounted the
top-level subvolume (which has subvolid=5). </nipick>

   Right now, no, there isn't any way of telling which subvolume is
mounted at a given location. I think that someone has been working on
it (David?), but I don't think the patches have seen the light of day
yet.

> Comment:  It sure would be nice if the btrfs man page corresponded
> better to the btrfs code.  Example, the man page says there is a
> "btrfs subvolume show" command.  The code disagrees and so does
> "btrfs --help"

   The man page doesn't have that in it on my system. Are you running
with an ancient btrfs-progs installation? (Any distribution package
with a date before the end of March 2012 is definitely ancient --
there's still some of them out there).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- We don't just borrow words;  on occasion, English has pursued ---  
         other languages down alleyways to beat them unconscious         
               and rifle their pockets for new vocabulary.               

--ck3np9Ek/EMsFxRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNxjP79z9OVl50rAAQL4RA//XT8MdYOmIaDcLAoLWgES9OY9F2w+Qqv/
5RWL5pdwTjAG+B7fN3uZAi2VFy2Je04jvAlsLlJ3oMpZM+E+hI3QW1fMWt9CmXOi
j7hkSKJVlJatugd8I4x3nu2Eoy9E19H10uGOJJ/ACJtX405jrJ5J/5MHKD6yrpXz
jqicPJ94+alny5zfIzmVDsIuoEWOEhpgTKQO2p2rtf/7dWzyJvGbPMX3UgYOnN1M
gZjrh+YcfMacvPeg3G5ClM15T6D+FgMpxTDuUKK9uXzc2izSArVh9hsyUC9hlM+U
q9bHTkLG7DxA++jTyXQbLNDf8nEMXnMBIZ8FzMTvJNJFqhXd07ig0515SnDSZxq9
Zy9B+xbOnD59cERoYZvBUtA6y+Vo/l80H4d2pThfCMn8Xii6TW9/OWtF74K+h8kU
9RBky6ZkN30AqNNgbRV7VMO2bl+CXLe0olsvlqUYabZI1Pig2whUQQxTm2k2jyMO
c4fN+9aguuJwpiDvUr7UidBsaihq4GUrKaCoYadVG31nO8H67FwmeP1GHW/Dq7Uz
W/45QHvzlSNpBBE71qJdFsO4QcngtSS5P6mKNw2LUXB8PxzbxwE0cLUqDJFZ+q36
BSlwiS7Nugv4W26ZfHIG+JcnGcPjdurqo5/ii8QXZP28KuDpgOP/euJU4P38vnpy
u6SA4SEMfso=
=Zv77
-----END PGP SIGNATURE-----

--ck3np9Ek/EMsFxRu--
