Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54019 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaCHVxx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 16:53:53 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WMPBn-0007Gq-BA
	for linux-btrfs@vger.kernel.org; Sat, 08 Mar 2014 21:53:52 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WMPBm-0003I3-UI
	for linux-btrfs@vger.kernel.org; Sat, 08 Mar 2014 21:53:50 +0000
Date: Sat, 8 Mar 2014 21:53:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: send/receive locking
Message-ID: <20140308215350.GE6318@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Is there anything that can be done about the issues of btrfs send
blocking? I've been writing a backup script (slowly), and several
times I've managed to hit a situation where large chunks of the
machine grind to a complete halt in D state because the backup script
has jammed up.

   Now, I'm aware that you can't send and receive to the same
filesystem at the same time, and that's a restriction I can live with.
However, having things that aren't related to the backup process
suddenly stop working because the backup script is trying to log its
progress to the same FS it's backing up is... umm... somewhat vexing,
to say the least.

   Is this a truly fundamental property of send/receive, or is there
likely to be a simple(ish) solution?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxuRblheFHXiqx3kAQIDLQ//T0kyWkuGHuhRaGZmZArqP3ALNPtF0TdQ
7GDM2xIB47YE4M7sTzUJ8BSUn7Y9hOJzHzpIhO6salM+YatOE7R7zChCfHjCW9CR
vrUhRCCQnhkC1p6KEmiZ8oIyKNOhdHTRdE6lBkD+SF7BsP5wVlE0iHlBSUcLOqou
YhlKKc3DKGsxhzFG58MO9i7QgOPJgiXMwlE+N9LOyoYMypPsKH6hjdF09qiCW7Nj
a7fSSj9TJmPDMC4MAdpZ1Sf71BQAbroHbdyfHoA6nM77Wa2kIMyxGXZaLIAD+I0b
xLUZLOT9PAfoXRM/pET2YGcq+2OFhewC66obS8PU+0ODhiAVzHVmkk8nOa9q3Kzx
rCSGhTjnrGVcPrGRfdYnqDXp5Xqu2TQrTCQoWk2kVoGW6yMxQ9TaHisqmqYhqxuQ
zezj23hi6FySdXacSsHyBgiqKvdNpIa1WGOlxs1U9u7nOFmeeHa1LHu15yl0xFMY
C/TuOrx4WNDTN9eKEbH+7OK1FXYZWL+/VR1jcVTVbbaE3vjFdzigCaT2p3qPLVbK
ULfbl+HPUmvffpbNN+Lp8ONWDHUKIVJDGz90syzPQGHJ1GLlgdv/2oWeF1pVeLfj
JMLtIVbuqGLxE37dtfMPynEdk15xp2CsJYvX3JNz/0ntqM9kxOAyr2itk1ReHrBH
RWcEVClcx90=
=YIi2
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
