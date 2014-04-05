Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49193 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaDEWDw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 18:03:52 -0400
Date: Sat, 5 Apr 2014 23:03:46 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: cwillu <cwillu@cwillu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Message-ID: <20140405220346.GV7442@carfax.org.uk>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com>
 <20140404184620.GA12124@merlins.org>
 <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com>
 <20140405220203.GB13857@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e1+sTVyxRliB/aPL"
In-Reply-To: <20140405220203.GB13857@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--e1+sTVyxRliB/aPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 05, 2014 at 03:02:03PM -0700, Marc MERLIN wrote:
> On Sat, Apr 05, 2014 at 04:00:27PM -0600, cwillu wrote:
> > >> +'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
> > >> +allow you to mount the filesystem again.
> > >> +
> > >> +The common case where this happens has been fixed a long time ago,
> > >> +so it is unlikely that you will see this particular problem.
> > >
> > > A note on this one: this can happen if your SSD rites things in the
> > > wrong order or potentially writes garbage when power is lost, or before
> > > locking up.
> > > I hit this problem about 10 times and it wasn't a btrfs bug, just the
> > > drive doing bad things.
> > 
> > And -o recovery didn't work around it?  My understanding is that -o
> > recovery will skip reading the log.
> 
> Maybe it does, but if you're trying to mount your root filesystem to boot
> your laptop, that's not super useful since -o recovery is indeed a read only
> recovery mode.
> btrfs-zero-log just cleans the last log entry and gave me back a fully working
> read/write filesystem each time.

   As far as I recall, -orecovery is read-write. -oro,recovery is
read-only.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Dullest spy film ever: The Eastbourne Ultimatum ---         

--e1+sTVyxRliB/aPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0B9wlheFHXiqx3kAQIrjhAAq0ACW6Dz1OXek16M251hi5/MRQUyBuvi
vJCg4G3JtDz6kxTGiFXjfPoGeYyWEkC8uhM9JDhM69+VUgq3pwueLfGkOmTlwivN
xD+Nx3jcXe7AKwbxu+mpnjXxKARE5SvlEPJDax3T8JlYCZgyf68Gt6TAK2Ec4tuQ
rqZh432tbxCuxO239VmqZtHVKEbb8XEuNrTyDct4QFMzVHS8F62WIeAxgLKAa5P+
e3wQTO6Zz+loMmuiPQt542nRcFX4lML3GEuniLnFRWqyPVPBkP0E3KJRUWOC3z/C
sRwmPfLT1q2lFvgGAnqmfM+SNlsRCmYWzpOkf9CR9HyqRviaf1nm/9kTIvTKtrxQ
OQd1zN2uGn6SVflsBByvtn9wW6iZ4bTK0qhfHqG/b5LD//aXNCzajv7Zl6/mm+lL
BnHJLgwUDFBld5AAonP3SIusYpbadz2cXv3OtORxBSMSW79QVDgyPok9egyJ3ft2
wtVc0wqD5SeAGURnOY2eqeYJkGLo1OuNIGbhtwFUkQ/IuVbB9jp+lN01FGPxA/p5
3c8dhJsyhEi2juNBKRCF/XgkBUFHL5gok6fqCYJn1CGuYL9RvlnDW/aLHezP1Y86
mDitheLp7dEgaI0a8qabSxC6B3RicEXPcdYqCCobCQfZ3jjJa2Wv7Lkzx4MVlwwX
qU5SKIWEeBA=
=teE9
-----END PGP SIGNATURE-----

--e1+sTVyxRliB/aPL--
