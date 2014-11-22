Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38737 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752503AbaKVCZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 21:25:17 -0500
Date: Fri, 21 Nov 2014 21:25:12 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141122022510.GN17380@hungrycats.org>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
 <546AF572.2020101@swiftspirit.co.za>
 <20141121045801.GS17395@hungrycats.org>
 <546EE43C.7020900@swiftspirit.co.za>
 <20141121174229.GT17395@hungrycats.org>
 <CAJCQCtQF9Lqeo_7OZQYAknTU_a7+k7b1-xt5DXe49_hwg-1QtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
In-Reply-To: <CAJCQCtQF9Lqeo_7OZQYAknTU_a7+k7b1-xt5DXe49_hwg-1QtQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 11:06:19AM -0700, Chris Murphy wrote:
> On Fri, Nov 21, 2014 at 10:42 AM, Zygo Blaxell <zblaxell@furryterror.org>=
 wrote:
>=20
> > I run 'smartctl -t long' from cron overnight (or whenever the drives
> > are most idle).  You can also set up smartd.conf to launch the self
> > tests; however, the syntax for test scheduling is byzantine compared to
> > cron (and that's saying something!).  On multi-drive systems I schedule
> > a different drive for each night.
> >
> > If you are also doing btrfs scrub, then stagger the scheduling so
> > e.g. smart runs in even weeks and btrfs scrub runs in odd weeks.
> >
> > smartd is OK for monitoring test logs and email alerts.  I've had no
> > problems there.
>=20
> Most attributes are always updated without issuing a smart test of any
> kind. A drive I have here only has four offline updateable attributes.

One of those four is Offline_Uncorrectable, which is a really important
attribute to monitor!

> When it comes to bad sectors, the drive won't use a sector that
> persistently fails writes. So you don't really have to worry about
> latent bad sectors that don't have data on them already. The sectors
> you care about are the ones with data. A scrub reads all of those
> sectors.

A scrub reads all the _allocated_ sectors.  A long selftest reads
_everything_, and also exercises the electronics and mechanics of the
drive in ways that normal operation doesn't.  I have several disks that
are less than 25% occupied, which means scrubs will ignore 75% of the
disk surface at any given time.

A sharp increase in the number of bad sectors (no matter how they are
detected) usually indicates a total drive failure is coming.  Many drives
have been nice enough to give me enough warning for their RMA replacements
to be delivered just a few hours before the drive totally fails.

> First the drive could report a read error in which case Btrfs
> raid1/10, and any (md, lvm, hardware) raid can use mirrored data, or
> rebuild it from parity, and write to the affected sector; and also
> this same mechanism happens in normal reads so it's a kind of passive
> scrub. But it happens to miss checking inactively read data, which a
> scrub will check.
>=20
> Second, the drive could report no problem, and Btrfs raid1/10 could
> still fix the problem in case of a csum mismatch. And it looks like
> soonish we'll see this apply to raid5/6.
>=20
> So I think a nightly long smart test is a bit overkill. I think you
> could do nightly -t short tests which will report problems scrub won't
> notice, such as higher seek times or lower throughput performance. And
> then scrub once a week.

Drives quite often drop a sector or two over the years, and it can
be harmless.  What you want to be watching out for is hundreds of bad
sectors showing up over a period of few days--that means something is
rattling around on the disk platters, damaging the hardware as it goes.
To get that data, you have to test the disks every few days.

> > The drive itself could be failing in some way that prevents recording
> > SMART errors (e.g. because of host timeouts triggering a bus reset,
> > which also prevents the SMART counter update for what was going wrong at
> > the time).  This is unfortunately quite common, especially with drives
> > configured for non-RAID workloads.
>=20
> Libata resetting the link should be recorded in kernel messages.

This is true, but the original question was about SMART data coverage.
This is why it's important to monitor both.

> --=20
> Chris Murphy

--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEUEARECAAYFAlRv9AYACgkQgfmLGlazG5w4KgCeJRVcux1zAyohN0wGHHaRjgmI
1LYAl1EJOUBETmACANEjnV1d70NsyWQ=
=6Lgd
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
