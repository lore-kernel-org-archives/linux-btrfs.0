Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38244 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1TQi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 14:16:38 -0500
Date: Tue, 28 Jan 2014 19:16:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Snapshots =?utf-8?B?4oCTIG5vbw==?= =?utf-8?Q?b?= questions
Message-ID: <20140128191616.GP3314@carfax.org.uk>
References: <52E664E0.5070909@gmail.com>
 <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
 <lc8th4$8um$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AKkMM/tm2Mk6Yn/s"
In-Reply-To: <lc8th4$8um$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--AKkMM/tm2Mk6Yn/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 28, 2014 at 06:39:45PM +0000, Martin wrote:
> On 27/01/14 18:44, Chris Murphy wrote:
> > 
> > On Jan 27, 2014, at 6:53 AM, KC <impactoria@googlemail.com> wrote:
> >>
> >> 3. If I make a snapshot of / and there are some separate partitions mounted under /mnt/ or /home/, will snapshot skip them?
> > 
> > A snapshot of a subvolume only snapshots that subvolume, not other subvolumes contained in it or other partitions/file systems.
> 
> Thanks. That's a critical detail to know.
> 
> 
> A few follow-on questions... Are taking snapshots:
> 
> 
> "atomic"?

   Yes. The state of the snapshot is that of a single point in the
filesystem's history.

> Do they hold up or lock out other disk activity?

   Yes, but only very briefly -- no more than any other simple
filesystem operation.

> Is there an overhead to keeping many snapshots other than the storage
> any changed files take?

   The storage the changed metadata takes, but that's all.

> Can we now consider making and deleting snapshots a "debugged stable
> feature"?

   I think so, yes, although there are still cases where having lots
of snapshots (thousands and upwards) can cause problems. I'm thinking
specifically of deletion of snapshots, where the system can bog down
quite heavily doing all the deletions.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 10: Business Ethics ---      

--AKkMM/tm2Mk6Yn/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUugB/1heFHXiqx3kAQLp1w/9GYYCRwhwtUPrNHkK51Bdy25q7XYtzgL+
VeJZMA/wvzyqDLDr1YR47aDMTKcj+HCk57yYz+jVT+dt39qzIqOtHC8gC88UvKds
EHjqxDHPxXfTCy947PBJ344JR0FVtbd+qv6lQ2oCazGrLTyogvxKADyfgChGj7ip
R2IuKYL9pJiY/crPFPBeAV0duF8/sqMs9Wgvy+JWaRPo1tjPiFQZfyVhLmj7Qroe
QAaox6TAe5usDzS/lNGm0CfuNwY0dHPoFAPiF0bVO1mCDEp0YPo4xzWdeBIrWKsq
/i6Yym7n4OUzPY3HXkTAZ5ZgNUOOsS1hz5VTxL4Qv+4Adw09ZLF/NECS6ePAe97F
1BnekyerNbb7kd7qPn3VFOCllTnFyoTuHSmYaVSKwHBZEcABzCRwp3fEMEa63pk2
GmOPbAu7F25SeFs3kWpPyL0Jfq3XBdoN5ig6DbwDUWtPOjqB3eHtYCN+7TWKLqdY
yKrlcGPHkCYHiJ3oeAYVl4tmH+B81MZHgahCQE2mRpYrr+HKPSnB/72fmAUTV0Z6
/vLacKWjZNR8KOJRKj6yR27uUUO6fVePJkZ5OISt5b1U+iXZHN7V6fsFQo+KQGiR
9Ca1aNcrAQ0iEBaTSYxA44m/hmRHhZwPuWhIrVh8ZoL6YOx9koYgILCCv3rbHPHU
YV7drSkId5I=
=vjt2
-----END PGP SIGNATURE-----

--AKkMM/tm2Mk6Yn/s--
