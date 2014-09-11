Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49517 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaIKMKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 08:10:40 -0400
Date: Thu, 11 Sep 2014 13:10:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: No space on empty, degraded raid10
Message-ID: <20140911121024.GM5783@carfax.org.uk>
References: <CAL-Saa_3uU936baHYjVOHXMVkNtP4mgLD6WuPUu2Wxw4SaPrzQ@mail.gmail.com>
 <540D8C7A.4030700@gmail.com>
 <201409111640.23845.russell@coker.com.au>
 <54118524.1010006@gmail.com>
 <20140911113833.GL5783@carfax.org.uk>
 <5411903D.4030801@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f54savKjS/tSNRaU"
In-Reply-To: <5411903D.4030801@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--f54savKjS/tSNRaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 08:06:21AM -0400, Austin S Hemmelgarn wrote:
> On 2014-09-11 07:38, Hugo Mills wrote:
> > On Thu, Sep 11, 2014 at 07:19:00AM -0400, Austin S Hemmelgarn wrote:
> >> On 2014-09-11 02:40, Russell Coker wrote:
> >>> Also it would be nice if there was a N-way mirror option for system data.  As 
> >>> such data is tiny (32MB on the 120G filesystem in my workstation) the space 
> >>> used by having a copy on every disk in the array shouldn't matter.
> >>
> >> N-way mirroring is in the queue for after RAID5/6 work; ideally, once it
> >> is ready, mkfs should default to one copy per disk in the filesystem.
> > 
> >    Why change the default from 2-copies, which it's been for years?
> 
> Sorry about the ambiguity in my statement, I meant that the default for
> system chunks should be one copy per disk in the filesystem.  If you
> don't have a copy of the system chunks, then you essentially don't have
> a filesystem, and that means that BTRFS RAID6 can't provide true
> resilience against 2 disks failing catastrophically unless there are at
> least 3 copies of the system chunks.

   Aah, OK. That makes perfect sense, then.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Some days, it's just not worth gnawing through the straps ---    

--f54savKjS/tSNRaU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVBGRMFheFHXiqx3kAQK85w//caa5oilEmrisyUkjNK/VTGAY1QonsUhb
XO9Bxg6HMYIg0kRumK+M0xLyro54H5yQCW785fXN4epQe2MmVa3YrivnHks6dlCE
Cra/FgQXzNKjUyUbnp61wQ/0Gg22aeY6lnqi4cTV+LWwVXBDrT0uJWzg2qHQqufi
f0JF/bT/0ZZLAMEF8YaxzjPWKMIZf6ASYMWyEjebhKI+/GjdHLXUHbyhgYQFox2v
4WduQCpALDyrl1zTxWeP/IwYYxkhgYP2sefVLvk6jRCCZiljJ2JXRIkS64sZrFDB
oUF9FvsvWy5hYodcf5CIQ7lIahQBrNhPPKmF5quj0YUDjmXNiD5I3ORGo5p5KR1x
CzL2KLQrsM7qrMeHSWlMQK3sjyc+bx8WvbqxHltmynp/+z2WJsdxQ+X5FdDPsGoz
P12vhytlH9mDL91cD8GOeYPlzGkQCRnKEt+D61Im98l927XXAwX20sotgphXamlp
fyo9bMzloMc4c1+kLTYHA0EcK3lZn2XLJFX4TNoI+o/Rzq2EfqWQQprZy39+KKXw
t3w0C0KCrcA8Z9KK9/Wc3ngX9d7wwESacjCHPv1g9f2xT0908Z7wJG7yqJ/798cj
NxqO3LVQXAuLYZYGrUZ992zwWi6hOk3s7zwqKkpVYoYluCdgu3oPOkv5MBBKny4O
9jhMIQyfAbE=
=5Vhb
-----END PGP SIGNATURE-----

--f54savKjS/tSNRaU--
