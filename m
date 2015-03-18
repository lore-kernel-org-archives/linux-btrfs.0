Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53174 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbbCRVzO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 17:55:14 -0400
Date: Wed, 18 Mar 2015 21:55:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: K Richard Pixley <rpixley@graphitesystems.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: syntax for deleting subvolumes?
Message-ID: <20150318215512.GC31762@carfax.org.uk>
References: <5509E34F.6010504@graphitesystems.com>
 <CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
 <5509F08E.6070702@graphitesystems.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
In-Reply-To: <5509F08E.6070702@graphitesystems.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2015 at 02:39:26PM -0700, K Richard Pixley wrote:
> On 3/18/15 14:06 , Chris Murphy wrote:
> >The Fedora/RHEL/CentOS installer creates two subvolumes: root and
> >home. If you check out fstab, those subvolumes are mounted at /
> >and /home. Therefore the top level subvolume (id 5) is not mounted
> >by default, so there's no way to delete subvolumes in the top
> >level.
> Ah!  Thank you.  That's the piece I was missing.
> 
> IMO, someone needs to take a clue-by-four to the heads of the
> Fedora/RHEL/CentOS installer folks.  I see no reason for this with
> btrfs.

   Actually, it's the recommended approach.

   We've found over time that nesting subvolumes inside each other is,
in general, more trouble than it's worth. It makes it harder to do
things like take snapshots and then replace the original with a
snapshot (e.g. rollback to an earlier state).

   Arranging the subvolumes with the top level (subvolid=0) as nothing
but a store for subvolumes means that you don't get the subvolumes
tangled up with each other, so it's much easier to manage them in
general.

   There's a few cases where nesting subvolumes is helpful, but that's
more to do with preventing snapshots being taken of some pieces of the
filesystem.

   Hugo.

-- 
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: 65E74AC0          |                           Stephen Franklin, Babylon 5

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVCfQ/AAoJEFheFHXiqx3knzgP/jL2IJkU176QfigKibyxCod2
vTB7+49aPaK/v2+YlpEx322nUtm694bTDATgeFFy5FQyAFADkQzLMdaIjCQ1Qu+A
qroOb7iS5d8Ud77dMAoTVFuTvISpLy6e4otBx4k4SDmr5IrRFYlGhfgofSPBFSdT
hTphjJWe2769h3flMojTwP13sCtfRJLu3Y6JzoOEE1Nfiu3Y1+61hLAYj43yjHEG
3mWCD633JWc1GQ+xswPcKk7SMZa8kqePaVyPP9spuKBPh53bN4VbrOBYUCigkFoC
x5jzTVzTgmjA/Zrjuw9SSmiEDgqHqtDN63NnS+Zqomd0xd5PolSazkZE6UlAT+Zd
uQ68aI52/zorzv6uKhQbYHCOuzPLFvcLhwCfd1T8aNSR8xAth/4IdTDLA1uWs5CR
1Xb7klpbFfk1A/fPG5W82n28mRmaydc6PAkntedUit5S3cx+1lF7Efwr4HIRlCtq
zjj8D5eg1kujahSynSRJamd4QwRNnmJREfVJsgd+TjNst13VLewQ/F52NwMy4ooS
jyyitbgjjXQ4lN+/bzw0y1NAhAC48bnBUf+0DeCGsXIrd0nWthCwafBD1vxt+f4o
37fb18b9flT7glg57jR0p31A3HBON4Ytu0E8fSYsL2McSU72smlaX+cLRT60tq9h
S3lXqa9wHZoEY2MuNdq6
=zW40
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
