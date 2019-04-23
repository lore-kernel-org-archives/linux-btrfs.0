Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDC0C10F03
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 23:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFB2520878
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 23:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfDWX4y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 19:56:54 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35242 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727831AbfDWX4y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 19:56:54 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 43E4F2CAD93; Tue, 23 Apr 2019 19:56:50 -0400 (EDT)
Date:   Tue, 23 Apr 2019 19:56:27 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Jakob Unterwurzacher <jakobunt@gmail.com>
Cc:     fdmanana@gmail.com, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: fallocate does not prevent ENOSPC on write
Message-ID: <20190423235621.GC11530@hungrycats.org>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
 <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
 <CAPv9ZmkZM5E=ZyQ=dsovkrmuAYxLZ=80AjimV4cXyR1RCNqbpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <CAPv9ZmkZM5E=ZyQ=dsovkrmuAYxLZ=80AjimV4cXyR1RCNqbpw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2019 at 09:21:09PM +0200, Jakob Unterwurzacher wrote:

> > Trying the reproducer, at least on a 5.0 kernel, does never fail on a
> > pwrite for me, but always on fallocate:
> [...]
> > So either that was tested on a rather old kernel or:
> >
> > 1) we had snapshotting happening between a fallocate and a pwrite (or
> > at the same time as the pwrite)
> > 2) before the pwrite (or during) the unwritten/prealloc extent was
> > reflinked (cp --reflink, clone or dedupe ioctls)
>=20
> I am at Linux 5.0.4-200.fc29.x86_64, the user in the github ticket is
> at Linux 5.0.7-arch1-1-ARCH, so pretty recent.
> There should be no snapshot or reflink or really any other activity on
> the test filesystem.
>=20
> Maybe the difference is that I am testing on a file and you on a raw
> block device?
> This is how things look at 4GB size:
>=20
> $ dd if=3D/dev/zero of=3Dimg bs=3D1M count=3D5000
> $ mkfs.btrfs -f -b $((4 * 1024 * 1024 * 1024)) img
> $ mkdir mnt
> $ sudo mount img mnt
> $ sudo chmod 777 mnt
> $ cd mnt
> $ ../fallocate_write/fallocate_write
> reading from /dev/urandom
> writing to ./blob.qEaSZl
> writing blocks of 132096 bytes each

132096 is 129 * 1024, which is not a multiple of 4K.  There will be a CoW
operation in cases where one 4K block from each pwrite is written twice
in separate transactions (or with fsync between).

Also, fallocate only works _once_ on btrfs.  After the first write,
prealloc extents are replaced with ordinary CoW extent (ref)s, and the
fallocate no-ENOSPC guarantee is gone:

	# fallocate -l 1m foo
	# sync
	# fiewalk foo=20
	File: foo
	Extent { begin =3D 0x0, end =3D 0x100000, physical =3D 0x4aedc01000, flags=
 =3D Extent::PREALLOC|FIEMAP_EXTENT_LAST, physical_len =3D 0x100000, logica=
l_len =3D 0x100000 }
	# head -c 128k /dev/urandom | dd conv=3Dnotrunc of=3Dfoo=20
	256+0 records in
	256+0 records out
	131072 bytes (131 kB, 128 KiB) copied, 0.00201152 s, 65.2 MB/s
	# sync
	# fiewalk foo=20
	File: foo
	Extent { begin =3D 0x0, end =3D 0x20000, physical =3D 0x4aedc01000, flags =
=3D 0, physical_len =3D 0x100000, logical_len =3D 0x20000 }
	Extent { begin =3D 0x20000, end =3D 0x100000, physical =3D 0x4aedc21000, f=
lags =3D Extent::PREALLOC|FIEMAP_EXTENT_LAST, physical_len =3D 0x100000, lo=
gical_len =3D 0xe0000, offset =3D 0x20000 }

Here we see the first block is overwriting the same physical address,
but it loses the PREALLOC attribute.  A second write will trigger CoW,
and a new data extent will be allocated:

	# head -c 128k /dev/urandom | dd conv=3Dnotrunc of=3Dfoo=20
	256+0 records in
	256+0 records out
	131072 bytes (131 kB, 128 KiB) copied, 0.00187461 s, 69.9 MB/s
	# sync
	# fiewalk foo=20
	File: foo
	Extent { begin =3D 0x0, end =3D 0x20000, physical =3D 0x4ae5f00000, flags =
=3D 0, physical_len =3D 0x20000, logical_len =3D 0x20000 }
	Extent { begin =3D 0x20000, end =3D 0x100000, physical =3D 0x4aedc21000, f=
lags =3D Extent::PREALLOC|FIEMAP_EXTENT_LAST, physical_len =3D 0x100000, lo=
gical_len =3D 0xe0000, offset =3D 0x20000 }

Note that the physical address of the first extent changed, indicating
CoW.  Also, all of the space allocated to the PREALLOC extent remains
allocated until the entire PREALLOC extent is overwritten (i.e. this
uses 128K of _additional_ space, the partial overwrite doesn't free the
first 128K of prealloc space).

> total    125 MiB, 162.06 MiB/s
> total    251 MiB, 162.92 MiB/s
> pwrite failed: No space left on device
>=20
> Is your /dev/sdi an SSD? I noticed that mkfs.btrfs does NOT think that
> the disk image file is an SSD,
> despite the file residing on an SSD.

fallocate is only going to behave the way posix_fallocate specifies on
files with datacow turned off.

> Thanks,
> Jakob

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXL+mGQAKCRCB+YsaVrMb
nOvfAJ45hn6RovYx4g04yweW62G7p9ekqQCeLw8bdRonEf/s+jC5FRnI3prnnGA=
=R/wK
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
