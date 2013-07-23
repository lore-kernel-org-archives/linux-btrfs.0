Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37121 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GWTaf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 15:30:35 -0400
Date: Tue, 23 Jul 2013 20:30:13 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Jerome Haltom <wasabi@cogito.cx>
Subject: Re: Q: Why subvolumes?
Message-ID: <20130723193013.GI20517@carfax.org.uk>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
 <20130723150620.GG20517@carfax.org.uk>
 <51EEC1BD.9030001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3U8TY7m7wOx7RL1F"
In-Reply-To: <51EEC1BD.9030001@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 07:47:41PM +0200, Gabriel de Perthuis wrote:
> >    Now... since the snapshot's FS tree is a direct duplicate of the
> > original FS tree (actually, it's the same tree, but they look like
> > different things to the outside world), they share everything --
> > including things like inode numbers. This is OK within a subvolume,
> > because we have the semantics that subvolumes have their own distinct
> > inode-number spaces. If we could snapshot arbitrary subsections of the
> > FS, we'd end up having to fix up inode numbers to ensure that they
> > were unique -- which can't really be an atomic operation (unless you
> > want to have the FS locked while the kernel updates the inodes of the
> > billion files you just snapshotted).
> 
> I don't think so; I just checked some snapshots and the inos are the same.
> Btrfs just changes the dev_id of subvolumes (somehow the vfs allows this).

   That's what I said. Our current implementation allows different
subvolumes to have the same inode numbers, which is what makes it
work. If you threw out the concept of subvolumes, or allowed snapshots
within subvolumes, then you'd be duplicating inodes within a
subvolume, which is one reason it doesn't work.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Unix: For controlling fungal diseases in crops. ---         

--3U8TY7m7wOx7RL1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUe7ZxVheFHXiqx3kAQLaTQ/+J0jAqS0voTv2uQe7FCJflDnXD5q22Jh0
P6wXcRysOLxmepZjmdubFAGsvy9+WrBMyU/dB7UrI5k94DQHqaPPDrM+wkYFdIgU
INEF5u5wCvN4tcRblAhzyVk/Ar9vA9abptQ98g2jf+dpqYNhTXf9nZLxCsskvw3Q
toi7a7MsB46dK9/4PmZCDP3eCa8PYlujEnygRj6sHMoEi7wfoZVI77haTG7HR65H
AEdLHOyiNSzd+hqtROBYYIuRA5ZT+pbF/Wcg61jp2zHOySSIaE/e+TI5D0hYbj/F
amJ/A17IqFwrwRAbTH5tezzSa16CMIYEMsdmlh7WUYN9gE6yJ/jObBCJRqX4EXtf
PtuvPjf8qTkvNQi0xxyfN2DxWAG5+wo57y3RP9yaI7XadQZZuDyIPzsQGqpHW3CP
mmmpK3LhhCCF2GOkhBYDl5QN8X70HkqIN6EhEFvoavK43qnx7yClQNxQLO/B0tGK
YEHsAUuwJaKG850GcFeourot1f61ggyG/xXpTBcfa3DVxQmBCVyER5f8PA5EMMs3
U0duiIN7ApH5Din9ZQIIIbNT+l+2jpLenC2ks3v/9/AFfNOKJRRafwVmiJiYziwL
dKFAPgoji3IjyKUrkRkyAHl65osT6kisx2my10hgYGJJoNrI17ZPdxYUAZroAXli
17eRUCk3Wpk=
=WA5M
-----END PGP SIGNATURE-----

--3U8TY7m7wOx7RL1F--
