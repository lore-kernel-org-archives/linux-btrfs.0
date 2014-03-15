Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53500 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaCOLxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 07:53:08 -0400
Date: Sat, 15 Mar 2014 11:53:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael Schuerig <michael.lists@schuerig.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
Message-ID: <20140315115305.GK6151@carfax.org.uk>
References: <1564384.fRV1HUkfCq@fuchsia>
 <2106363.nA97oxn4hn@fuchsia>
 <53224D57.8020308@chinilu.com>
 <1789445.UA8sCrE2Cn@fuchsia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDymnuGqqhW10CwH"
In-Reply-To: <1789445.UA8sCrE2Cn@fuchsia>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qDymnuGqqhW10CwH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 15, 2014 at 12:35:30PM +0100, Michael Schuerig wrote:
> On Thursday 13 March 2014 17:29:11 George Mitchell wrote:
> > I currently use rsync to a separate drive to maintain a 
> > backup copy, but it is not integrated into the array like n-way would 
> > be, and is definitely not a perfect solution.
> 
> Could you explain how you're using rsync? I was just about to copy a 
> btrfs filesystem to another disk. That filesystem has several subvolumes 
> and about 100 snapshots overall. Owing to COW, this amounts to about 
> 1.2TB. However, I reckon that rsync doesn't know anything about COW and 
> accordingly would blow up my data immensely on the destination disk.
> 
> How do I copy a btrfs filesystem preserving its complete contents? How 
> do I update such a copy?
> 
> Yes, I want to keep the subvolume layout of the original and I want to 
> copy all snapshots. I don't think send/receive is the answer, but it's 
> likey I don't understand it well enough. I'm concerned, that a 
> send/receive-based approach is not robust against mishaps.

   send/receive is the answer, but it's going to be a bit more
complicated to manage *all* of the snapshots. (Questions -- do you
actually need them all backed up? Can you instead do incremental
backups of the "main" subvol and keep each of those independently on
the backup machine instead?)

> Consider: I want to incrementally back-up a filesystem to two external 
> disks. For this I'd have to for each subvolume keep a snapshot 
> corresponding to its state on the backup disk. If I make any mistake in 
> managing these snapshots, I can't update the external backup anymore.

   Correct (I got bitten by this last week with my fledgling backup
process). You need a place that stores the "current state" subvolumes
that's not going to be touched by anything else, and you can't clean
up any given base until you're certain that there's a good new one
available on both sides. One thing that helps here is that send
requires the snapshot being sent to be marked read-only, so it's not
possible to change it at all -- but you can delete them.

> Also, I don't understand whether send/receive would allow me to 
> copy/update a subvolume *including* its snapshots.

   Snapshots aren't owned by subvolumes. Once you've made a snapshot,
that snapshot is a fully equal partner of the subvol that it was a
snapshot of -- there is no hierarchy of ownership. This means that you
will have to send each snapshot independently.

   What send allows you to do is to specify that one or more
subvolumes on the send side can be assumed to exist on the receive
side (via -p and -c). If you do that, the stream can then use them as
clone sources (i.e. should make shared CoW copies from them, rather
than sending all the data).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--qDymnuGqqhW10CwH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUyQ/IFheFHXiqx3kAQJ0fRAArtb7PpkLLBJfOwTiZRrRh1aOZ5dXvqMa
hDZ2sTRakObSL6QAFfJtPNRjPWBXQHvPF5cxuffD7Qsm9/Tc/J8sbN0AYsQtG8hd
z52Ya+p1NK6Eew/P1r64IMAJ652yub2pF0a6zki3bmsTrVOoHwHhiXiu+PmgiVY9
6UA98Mks9PYAj09bej4JOu0gcR4PKoKsPrCiIPhMlzbHozLNmKIEcDCB5ExwNpMP
B1gQjSZyJqdPgXFXBat2nPGbLtewvmj7MIB+QsdiMWEAp4QWI8tNsO/zFdCczdko
rR5d8cJKZuO9bn1UBHfGIVGgSwWdBZEUtdt74Re3XDRhOx0pvJcE10PMXXXoXL6r
PMLQKDS++/QkACk55eG+Gs5Pf7dCiLlj6+6dTwY0fpOP7QL36zYjU1OJlJG83I9D
Xq1zzWDz5+/SXL3l1PKPN1z9ZdJo2+wjIyYV/aPiCfzjsD065CxNtXVjYf7xhsbJ
XmCRCFcvz2hXfk9Miw3ttAIubPvgWDjpdafRubrKZTzRWWK2RoULL5ENJ1voGt6a
LTRBFueDBb0Y0eVadFaOe1a62EpTRvCxVFe/JM0j86FVVYpqNhwHE6uzIeJ2IMOs
caamjpEIDXv2l7vcXDvWOlq9OZihMxQkspr3UKu0Rvt43reFXb07/VTGHEO7BwGh
m9ZnjRNVZDk=
=Poo8
-----END PGP SIGNATURE-----

--qDymnuGqqhW10CwH--
