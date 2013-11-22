Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab3KVXIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 18:08:07 -0500
Date: Sat, 23 Nov 2013 10:07:53 +1100
From: NeilBrown <neilb@suse.de>
To: stan@hardwarefreak.com
Cc: John Williams <jwilliams4200@gmail.com>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
Message-ID: <20131123100753.1820ab7c@notabene.brown>
In-Reply-To: <528E8FEC.2070204@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com>
	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>
	<528DADB1.8010604@hardwarefreak.com>
	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>
	<528E8FEC.2070204@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//YK9iPeR0onJXBircwTYPaU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//YK9iPeR0onJXBircwTYPaU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Nov 2013 16:57:48 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 11/21/2013 1:05 AM, John Williams wrote:
> > On Wed, Nov 20, 2013 at 10:52 PM, Stan Hoeppner <stan@hardwarefreak.com=
> wrote:
> >> On 11/20/2013 8:46 PM, John Williams wrote:
> >>> For myself or any machines I managed for work that do not need high
> >>> IOPS, I would definitely choose triple- or quad-parity over RAID 51 or
> >>> similar schemes with arrays of 16 - 32 drives.
> >>
> >> You must see a week long rebuild as acceptable...
> >=20
> > It would not be a problem if it did take that long, since I would have
> > extra parity units as backup in case of a failure during a rebuild.
> >=20
> > But of course it would not take that long. Take, for example, a 24 x
> > 3TB triple-parity array (21+3) that has had two drive failures
> > (perhaps the rebuild started with one failure, but there was soon
> > another failure). I would expect the rebuild to take about a day.
>=20
> You're looking at today.  We're discussing tomorrow's needs.  Today's
> 6TB 3.5" drives have sustained average throughput of ~175MB/s.
> Tomorrow's 20TB drives will be lucky to do 300MB/s.  As I said
> previously, at that rate a straight disk-disk copy of a 20TB drive takes
> 18.6 hours.  This is what you get with RAID1/10/51.  In the real world,
> rebuilding a failed drive in a 3P array of say 8 of these disks will
> likely take at least 3 times as long, 2 days 6 hours minimum, probably
> more.  This may be perfectly acceptable to some, but probably not to all.

Could you explain your logic here?  Why do you think rebuilding parity
will take 3 times as long as rebuilding a copy?  Can you measure that sort =
of
difference today?

Presumably when we have 20TB drives we will also have more cores and quite
possibly dedicated co-processors which will make the CPU load less
significant.

NeilBrown

--Sig_//YK9iPeR0onJXBircwTYPaU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUo/jyTnsnt1WYoG5AQJxihAAxBt/GCVeavsK4FwhEpzIALog/CchgPRA
zSEcQVYf1DJXH7cWejcOWDtEB2euzSp+6U4B8KWTAaQOlp9di0IDVvrSPgpSwU2k
EuO6epcMxhRqXmu8ZVP9MLeQeb0Fs/UjGepD/bkNyx+HPVW0Y1zNjf6wYBTsqeGv
gwPghzJ+/9fd4CU97M6J+P/1n5hXjMqKpkI4qWgOIeEqqzYwfXEiVgJH52hnP6+0
9we/y4KkUkruUqWRfRfZXaaBux5uu6HvxsNT5MRC+GYXhQnUGrQa1K8tnIaJNyXi
xTAnS1/WKXFLKLaG7U9nmg8WRhJjJLXK7O0sGFk4Mdo28qqRr6jS80xsTroyeGN/
pr1JW2OQdFX/dPcY39z/vM8BG2dDX6dPCfsKdQ6A04+mLN5YCopUIeuZdov+ZFkV
XpIQNDPjdbQcFcfP+o0pYOY/z6hBmneZo5eXEk2BTUF69GMSUJ71SBs2zxX5b7hz
vVZMC1R9F6U4cS+ghAsI0AqRxcqAkoPFdRgKEPuJZJO7QMUdgF43iwdEntjZOW6y
k7LxGT+ftrM44RtI07rGpjwbw5KdqZbvuLywiBNhbYsiGJMUq3ePoRbRxdADbNXC
FtneXGYnpoWJmr/u8+FC6xUMEpkUsoq/RENX1AT6+egWqvVBIBEeyZ+zUQLmifGj
GNFlxqCX7Nc=
=pLuD
-----END PGP SIGNATURE-----

--Sig_//YK9iPeR0onJXBircwTYPaU--
