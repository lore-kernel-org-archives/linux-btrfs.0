Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33755 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3CKI4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 04:56:30 -0400
Date: Mon, 11 Mar 2013 08:56:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sam tygier <samtygier@yahoo.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130311085626.GI30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <khj6gq$nan$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/8E7gjuj425jZz9t"
In-Reply-To: <khj6gq$nan$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/8E7gjuj425jZz9t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 10, 2013 at 11:55:10PM +0000, sam tygier wrote:
> On 09/03/13 20:31, Hugo Mills wrote:
> >    Some time ago, and occasionally since, we've discussed altering the
> > "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> > number of copies, m is the number of (data) devices in a stripe per copy,
> > and p is the number of parity devices in a stripe.
> > 
> >    The current kernel implementation uses as many devices as it can in the
> > striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
> > written as "mS" (with a literal "m"). The mS and pP sections are omitted
> > if the value is 1S or 0P.
> > 
> >    The magic look-up table for old-style / new-style is:
> > 
> > single 		 1C (or omitted, in btrfs fi df output)
> > RAID-0		 1CmS
> > RAID-1		 2C
> > DUP			 2CD
> > RAID-10		 2CmS
> > RAID-5		 1CmS1P
> > RAID-6		 1CmS2P
> 
> Are these the only valid options?

   Currently, yes.

> Are 'sensible' new levels (eg 3C, mirrored to 3 disk or 1CmS3P, like
> raid6 with but with 3 parity blocks) allowed?

   Not right now, but:

 - I don't know if the forthcoming 3c code will allow arbitrary values
   or not, but Chris has promised 3c.

 - Fixed S will definitely happen for the parity-RAID levels. I'm not
   sure about the stripe-RAID levels.

 - Higher P are mathematically possible, but (AIUI) awkward to
   construct efficient and effective ones (and it's a manual process
   to do so). I suspect that 3p may happen, but 4p may not for a long
   time.

> Are any arbitrary levels allowed (some other comments in the thread
> suggest no)?

   Currently, no, and I don't think there are immediate plans to
generalise it, but I'd like to see that happen eventually.

> Will there be a recommended (or supported) set?

   Quite likely, even with the limited (forthcoming) set of
parameters. Using mSpP on an array of larger than some particular size
is probably not going to be particularly good for performance, for
example.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---    
                         money? There's irony...                         

--/8E7gjuj425jZz9t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUT2cOb9z9OVl50rAAQJODg/+N9NiZ19uWnsiY15z0YARd+OhxMppQOUM
xxgQlYm4/S0DjhvOwL+2miEiWTsMUoZX2sPtuw+vViU+knTn/D22qJbaEE23qV9N
wSlqFqPBDSlj2slt5vEzftrf0nV+tHUI7h22gS2YUaiLTpgtGFCCszT45H/ss5VR
9d6g6ASqYbZK5pO3ZayTCngZvstBSVWk8zmSE4xa0JeNjuvJe6vgKP9DEesiPrzf
TZJcHcolylClx4IKT3TtiPWyhPx4c6PJoGV/vWLBEv7+paEPO0CzgXdgg14V82rV
6x+8SHzuwNE80gSlA1rmWXyUmD6Faj1vuSjTb4Wupwv4NklieJ1MU3mthmUrl6xw
GCwl4LoKRZtTz1Lp3YUAQf3us8fbItBU/qgHnkt7EgmeHg6mCy/xojUWGJGKsHhz
6uJVL0FsZ3XPUjunlaN3wD8p2InVjtZle8uDuwHzHWXloemXsz4iK/aRPUxGKEn3
OQnc1PReTxBdP+gefxGqyiBpzUzhuQ0SwraKsutC/rKRkPnSvmgqLgEnrQwZBmYT
u7Gaj0dgr4YB5pMWEXB1wgFhgwUVZ1igdwfSwR4N2ckbqfj02Er1mkY9yGe1kC5o
u1qZHF1nVvXOT5WAzELtGUhHiN/eJaYsWsOnolwDepIRSwZnv8eIteIL7g/VEztU
mXylIF8Q31Y=
=gkKQ
-----END PGP SIGNATURE-----

--/8E7gjuj425jZz9t--
