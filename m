Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3KWHM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 02:12:27 -0500
Date: Sat, 23 Nov 2013 18:12:08 +1100
From: NeilBrown <neilb@suse.de>
To: John Williams <jwilliams4200@gmail.com>
Cc: stan@hardwarefreak.com, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
Message-ID: <20131123181208.5103bee4@notabene.brown>
In-Reply-To: <CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com>
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
	<20131123100753.1820ab7c@notabene.brown>
	<5290252A.8020508@hardwarefreak.com>
	<20131123160428.6f1c5898@notabene.brown>
	<CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3eXsn+WT6Y4wjoqZdDCFrFy"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/3eXsn+WT6Y4wjoqZdDCFrFy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 21:34:41 -0800 John Williams <jwilliams4200@gmail.com>
wrote:

> On Fri, Nov 22, 2013 at 9:04 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> > I guess with that many drives you could hit PCI bus throughput limits.
> >
> > A 16-lane PCIe 4.0 could just about give 100MB/s to each of 16 devices.=
  So
> > you would really need top-end hardware to keep all of 16 drives busy in=
 a
> > recovery.
> > So yes: rebuilding a drive in a 16-drive RAID6+ would be slower than in=
 e.g.
> > a 20 drive RAID10.
>=20
> Not really. A single 8x PCIe 2.0 card has 8 x 500MB/s =3D 4000MB/s of
> potential bandwidth. That would be 250MB/s per drive for 16 drives.
>=20
> But quite a few people running software RAID with many drives have
> multiple PCIe cards. For example, in one machine I have three IBM
> M1015 cards (which I got for $75/ea) that are 8x PCIe 2.0. That comes
> to 3 x 500MB/s x 8 =3D 12GB/s of IO bandwidth.
>=20
> Also, your math is wrong. PCIe 3.0 is 985 MB/s per lane. If we assume
> PCIe 4.0 would double that, we would have 1970MB/s per lane. So one
> lane of the hypothetical PCIe 4.0 would have enough IO bandwidth to
> give about 120MB/s to each of 16 drives. A single 8x PCIe 4.0 card
> would have 8 times that capability which is more than 15GB/s.

It wasn't my math, it was my reading :-(
16-lane PCIe 4.0 is 31 GB/sec so 2GB/sec per drive.  I was reading the
"1-lane" number...

>=20
> Even a single 8x PCIe 3.0 card has potentially over 7GB/s of bandwidth.
>=20
> Bottom line is that IO bandwidth is not a problem for a system with
> prudently chosen hardware.
>=20
> More likely is that you would be CPU limited (rather than bus limited)
> in a high-parity rebuild where more than one drive failed. But even
> that is not likely to be too bad, since Andrea's single-threaded
> recovery code can recover two drives at nearly 1GB/s on one of my
> machines. I think the code could probably be threaded to achieve a
> multiple of that running on multiple cores.

Indeed.  It seems likely that with modern hardware, the  linear write speed
would be the limiting factor for spinning-rust drives.
For SSDs the limit might end up being somewhere else ...

Thanks,
NeilBrown

--Sig_/3eXsn+WT6Y4wjoqZdDCFrFy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpBVSDnsnt1WYoG5AQIHAw/8CW3fVpqmiRIV+zjiIXi4mtS8+duzq4Iw
EL4I2AetVJ7BtzWQo/XdxH/j/RoQOeBzDrkBBTSykFFvFJxkC5NSq96UAJA1mZyc
HNTaQxtl5cci6A9Q3JCgRAVJz0Mz00Yj/8TwSid3QytykrJ+Rl/uEeRbjQAmBD8K
BcLEaMIIa1e+LovjwjfF7F+CvyPN6nSDOwqt+qg0XGvDciQOyCg1AxukNGT3D+Qp
0aRY0v0hB8scbInC1KEOLjWRVqrPx5iHaLHdi3NNAvbHtTwx98rfBJKg5vE8e5Ex
G7tzDRFiUmPxv1txXeobeZD4m+NmVY8d2X5b227bg/Cc3Z6RFixgalRvfUEa6QwW
Gd3+fxy7DVvt5ic4v3ZwU0v/hfkQxrAlUdoMBq2kIvMJ3ghXca/OSdWT7AiktfSh
CEfgxZCxcygvtNjnfKB9ZvD58NH75tq4jqkuuO7HRoIXe3i8lCp8pS2Kaiel229K
TzK20vZczsSnF4JdnUAjyRzsPHVpXAYt8zGCWfLBeJO9GfOlwWRzO40K1CrMdmGQ
EXFbUf2NzRD9SOjAkrNy0m/4q4ZnUkMz3WJA26ZLibNjLlx2qwAmAeP0+YZkZNBI
41hWJhSlgDl1Wbc2YyHfrJVXvy4dtDxWMH/zziah8ZL/q0E+Vl/Jr+AYG6iPKIvW
LxDkofbdxbQ=
=n4oU
-----END PGP SIGNATURE-----

--Sig_/3eXsn+WT6Y4wjoqZdDCFrFy--
