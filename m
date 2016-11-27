Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37778 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752329AbcK0QyO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 11:54:14 -0500
Date: Sun, 27 Nov 2016 11:53:55 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161127165355.GL8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <20161126185402.GK8685@hungrycats.org>
 <59e0b1c7-51a9-ede4-6571-fa0b20394145@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L/Qt9NZ8t00Dhfad"
In-Reply-To: <59e0b1c7-51a9-ede4-6571-fa0b20394145@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--L/Qt9NZ8t00Dhfad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 27, 2016 at 12:16:34AM +0100, Goffredo Baroncelli wrote:
> On 2016-11-26 19:54, Zygo Blaxell wrote:
> > On Sat, Nov 26, 2016 at 02:12:56PM +0100, Goffredo Baroncelli wrote:
> >> On 2016-11-25 05:31, Zygo Blaxell wrote:
> [...]
> >>
> >> BTW Btrfs in RAID1 mode corrects the data even in the read case. So
> >=20
> > Have you tested this?  I think you'll find that it doesn't.
>=20
> Yes I tested it; and it does the rebuild automatically.
> I corrupted a disk of mirror, then I read the related file. The log  says:
>=20
> [   59.287748] BTRFS warning (device vdb): csum failed ino 257 off 0 csum=
 12813760 expected csum 3114703128
> [   59.291542] BTRFS warning (device vdb): csum failed ino 257 off 0 csum=
 12813760 expected csum 3114703128
> [   59.294950] BTRFS info (device vdb): read error corrected: ino 257 off=
 0 (dev /dev/vdb sector 2154496)
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> IIRC In case of RAID5/6 the last line is missing. However in both the
> case the data returned is good; but in RAID1 the data is corrected
> also on the disk.
>=20
> Where you read that the data is not rebuild automatically ?

Experience?  I have real disk failures all the time.  Errors on RAID1
arrays persist until scrubbed.

No, wait... _transid_ errors always persist until scrubbed.  csum failures
are rewritten in repair_io_failure.  There is a comment earlier in
repair_io_failure that rewrite in RAID56 is not supported yet.

> In fact I was surprised that RAID5/6 behaves differently....

The difference is surprising, no matter which strategy you believe
is correct.  ;)

> >> I am still convinced that is the RAID5/6 behavior "strange".
> >>
> >> BR
> >> G.Baroncelli
> >> --=20
> >> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> >> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> >>
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>=20

--L/Qt9NZ8t00Dhfad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg7D6MACgkQgfmLGlazG5zsrQCg3rX3sc2IOBD98ukzV4l57Ngo
r2cAoJ7nJXGLe2H1lorzlHACw+SgoS8+
=GOXK
-----END PGP SIGNATURE-----

--L/Qt9NZ8t00Dhfad--
