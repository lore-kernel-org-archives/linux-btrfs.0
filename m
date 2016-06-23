Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcFWViV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 17:38:21 -0400
Subject: Re: [PATCH 0/3] btrfs-progs: check improve 'checking extents'
 scalability
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
References: <1466709966-31506-1-git-send-email-jeffm@suse.com>
 <576C53A2.3090704@applied-asynchrony.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <5b5ab997-42e5-8d06-352d-58a9ac502081@suse.com>
Date: Thu, 23 Jun 2016 17:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <576C53A2.3090704@applied-asynchrony.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rwTVlFhkXXbqhV0bfN9TmEewahGUhUeW5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rwTVlFhkXXbqhV0bfN9TmEewahGUhUeW5
Content-Type: multipart/mixed; boundary="1sPA7HDL8nDoHXClPBESqVA7wRNtx8osX"
From: Jeff Mahoney <jeffm@suse.com>
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <5b5ab997-42e5-8d06-352d-58a9ac502081@suse.com>
Subject: Re: [PATCH 0/3] btrfs-progs: check improve 'checking extents'
 scalability
References: <1466709966-31506-1-git-send-email-jeffm@suse.com>
 <576C53A2.3090704@applied-asynchrony.com>
In-Reply-To: <576C53A2.3090704@applied-asynchrony.com>

--1sPA7HDL8nDoHXClPBESqVA7wRNtx8osX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/23/16 5:24 PM, Holger Hoffst=C3=A4tte wrote:
> On 06/23/16 21:26, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>

Hi Holger -

>> While running xfstests generic/291, which creates a single file popula=
ted

Whoops, this should've been generic/297.

>> with reflinks to the same extent, I found that fsck had been running f=
or
>> hours.  perf top lead me to find_data_backref as the culprit, and a li=
tte
>> more digging made it clear: For every extent record we add, we iterate=

>> the entire list first.  My test case had ~2M records.  That math doesn=
't
>> go well.
>>
>> This patchset converts the extent_backref list to an rbtree.  The test=

>> that used to run for more than 8 hours without completing now takes
>> less than 20 seconds.
>=20
> Very interesting. Time for science!
>=20
> unpatched:
>=20
> holger>time btrfs check /dev/sdc1=20
> Checking filesystem on /dev/sdc1
> ..
> btrfs check /dev/sdc1  17.03s user 3.79s system 25% cpu 1:22.82 total
>=20
> patched:
>=20
> holger>time btrfs check /dev/sdc1
> Checking filesystem on /dev/sdc1
> ..
> btrfs check /dev/sdc1  17.03s user 3.74s system 24% cpu 1:23.24 total
>=20
> This is a 1TB disk with ~850GB data in 4 subvolumes, ~2 snapshots each.=

> I guess it only starts to matter (relative to the necessary I/O cost pe=
r
> extent) when the level of sharing is higher, i.e. many more snapshots?

Thanks for testing.  This is exactly the result I wanted to see -- that
the impact on the regular case is minimal.  Once the number of reflinks
to a single extent rises significantly, the improvement is clear.  My
test case was an 8 GB file with every block referencing the first block
of the file.  You're welcome to try that test case as well, but I will
warn you *not* to run filefrag on it or you'll either have to wait a
really long time for it to complete or reboot your system.

> OTOH it doesn't explode, so that's good. :)

Hey, I'll take that feedback. :)

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--1sPA7HDL8nDoHXClPBESqVA7wRNtx8osX--

--rwTVlFhkXXbqhV0bfN9TmEewahGUhUeW5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXbFbIAAoJEB57S2MheeWybuQQAIXZkyQwYU5DfqzsctQUUJwe
8zcHPj1e4y22DQgdOjGknx+fbCVsgWgXOY1x/jfmTUgQIPo+vgsnQjhHGxA8DYsH
FQqxXGJf6iYrqE+MmzOkywkFd7geXrYV5/Ze+6+9Bnblbi4ta7XE08hflYQLKX9x
ShnWJuoR+wVnIGL/CmC76wDyoCHLJcctJWMn5kpthBjr7+fN5HQsDg2YU2QSz/jw
+0bR1NxnKjIm30bBLPnu7p0+ipdeF7tSlrbsldnpaUUvqM3zV2owVQOUtmNhJf6K
IWz3Siwz0P/47dbOE42i6f3q8azfgL0m5DLu/I/J9TKFnTFQ4+LTj+M23v6z7bXf
ZSndfBPJUqKJdH6cuRF5SzkTaPA8BTKitTWyQgESYJlL8CfVdyeFamzfVKS+Ei9Y
9/4nyFdOzFwwycrRda1/mkEH521lj/tAacYpna4GR1HcXWJOtvI5S7r5uV2rRtM1
r1/Z31PacKkheMqCF6+7gPwXbuqWwjdEqsa/zlanQgqAOJ2nxSgN2UdgkfPRyZcV
Rko1XWtCH4xXbz05y/LgCkTYP7cfm3YBjrYa2dA8Qh6pZAU8Luf/vZRfBAY8pULg
gskDPp5brxvb+G/GxULwp93zm5QLA/XSzuD54triX/ZKfOz53sY6RE8NYGuluf5q
dmp8F+Ze/1xC1jneyDFi
=5oGj
-----END PGP SIGNATURE-----

--rwTVlFhkXXbqhV0bfN9TmEewahGUhUeW5--
