Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936599AbcIVRmI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:42:08 -0400
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
Date: Thu, 22 Sep 2016 13:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TdwOPSt9UgkofE5P1tP4TasBa0sXwnvkV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TdwOPSt9UgkofE5P1tP4TasBa0sXwnvkV
Content-Type: multipart/mixed; boundary="baScQoJxegcWjMA3RPj09j5jG9evQNjCD";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
Subject: Re: unable to handle kernel paging request - btrfs
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
In-Reply-To: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>

--baScQoJxegcWjMA3RPj09j5jG9evQNjCD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/22/16 8:18 AM, Rich Freeman wrote:
> I have been getting panics consistently after doing a btrfs replace
> operation on a raid1 and rebooting.  I linked a photo of the panic; I
> haven't been able to get a text capture of it.
>=20
> https://ibin.co/2vx0HhDeViu3.jpg
>=20
> I'm getting this error on the latest 4.4, 4.1, and even on an old
> 3.18.26 kernel I had lying around.
>=20
> I tried the remove root_log_ctx from ctx list before btrfs_sync_log
> returns patch on 4.1 and that did not solve my problem either.
>=20
> I'm able to boot into single-user mode and if I don't start any
> processes the system seems fairly stable.  I am also able to start a
> btrfs balance and run that for several hours without issue.  If I
> start launching services the system will tend to panic, though how
> many processes I can launch will vary.  I don't think that it is a
> particular file being accessed that is triggering the issue since the
> point where it fails varies.  I suspect it may be load-related.
>=20
> Mounting with compress=3Dno doesn't seem to help either.  Granted, I se=
e
> lzo_decompress in the backtrace and that is probably a read operation.
>=20
> Any suggestions?  Google hasn't been helpful on this one...

Can you boot with panic_on_oops=3D1, reproduce it, and capture that Oops?=

The trace in your photo is a secondary Oops (tainted D), which means
that something else went wrong before that and now the system is
tripping over it.  Secondary Oopses don't really help the debugging
process because the system was already in a broken, undefined, state.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--baScQoJxegcWjMA3RPj09j5jG9evQNjCD--

--TdwOPSt9UgkofE5P1tP4TasBa0sXwnvkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX5BfrAAoJEB57S2MheeWyKn4QAIAmJ+GcmvM6urN7gnyBXe8r
jBPITAo3Oe+lMQlRpwO9oV3RqS0/LaXzjmfHX0gnf7s9SC0EJJy+BNQee8WMt/el
+xMzbvpvJzFuiXjxp9VQA1zYcNheCUEVg86f8mlPGR2gPB6/4fgiFyXEUyomxWY1
5BMbgMQ95nv4lWhtKyInXIHmePgD5jRPtPmAMYxJJpPeeRVwGO2lwnn/o1nfaHFZ
YUvEVRqksrhdULSUgs8VjKQtJENvxeUpf+oDBLIknTy9Jccl0WR74Asp04WzKfdm
f0soNMg43rXhIK9a3kkqItUNaB7Kg2KdD3puZnUhtiSlSTltrevdr/Ddtn0bp5OI
GBNsGvesxiAKK5N95zNGKXFgV6iS1UgQY79gNRi20eNvqnfxYn2dPUBqdvF+usDA
rCnAftT+W5t04sRSMjL5FP2q8V5KD0h0iWiVx0HQsG9bBkbKEvhEwN6XYs/lyLUy
xKQWbO3MPpIOSJWuPQLcSxDanWda+B9enAvm+8StgFDdJz5ddjL3K1nM8GVpy3pt
JpbP9VHG+3jP0e3kkbwoGXxb8ZHBDDSQnywO3cMLOIQvJk9TLDZoAIaZZdv925Kv
DimVp4Kr1WaFgYTo9WE9AumHsygPIo05gNy9Sef0geSio3l1qxZ+Vkj3vU4V+USP
fuoYseqUgy6EGH9cGRIy
=2uuk
-----END PGP SIGNATURE-----

--TdwOPSt9UgkofE5P1tP4TasBa0sXwnvkV--
