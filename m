Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56497 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2FYWyb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 18:54:31 -0400
Date: Mon, 25 Jun 2012 23:54:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
Message-ID: <20120625225424.GG25572@carfax.org.uk>
References: <4FE1F9E4.5090301@zytor.com>
 <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
 <20120621005048.GA19507@shiny>
 <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com>
 <20120625152142.GD17638@shiny>
 <4FE8A3D9.3060400@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c7hkjup166d4FzgN"
In-Reply-To: <4FE8A3D9.3060400@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--c7hkjup166d4FzgN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 25, 2012 at 10:46:01AM -0700, H. Peter Anvin wrote:
> On 06/25/2012 08:21 AM, Chris Mason wrote:
> > Yes and no.  If you have 2 drives and you add one more, we can make it
> > do all new chunks over 3 drives.  But, turning the existing double
> > mirror chunks into a triple mirror requires a balance.
> > 
> > -chris
> 
> So trigger one.  This is the exact analogue to the resync pass that is
> required in classic RAID after adding new media.

   You'd have to cancel and restart if a second new disk was added
while the first balance was ongoing. Fortunately, this isn't a problem
these days.

   Also, it occurs to me that I should just check -- are you aware
that the btrfs implementation of RAID-1 makes no guarantees about the
location of any given piece of data? i.e. if I have a piece of data
stored at block X on disk 1, it's not guaranteed to be stored at block
X on disks 2, 3, 4, ... I'm not sure if this is important to you, but
it's a significant difference between the btrfs implementation of
RAID-1 and the MD implementation.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Never underestimate the bandwidth of a Volvo filled ---       
                           with backup tapes.                            

--c7hkjup166d4FzgN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP6OwgIKyzvlFcI40RAtNKAJ9fbplckSuifhJPQqKbaxkMJ1CHgACglCN7
fM0vxNjponaQBblFC2wuXRA=
=qoWw
-----END PGP SIGNATURE-----

--c7hkjup166d4FzgN--
