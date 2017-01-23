Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38493 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdAWMLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 07:11:25 -0500
Subject: Re: gdb log of crashed "btrfs-image -s"
To: Christoph Groth <christoph@grothesque.org>
References: <87o9z7dzvd.fsf@grothesque.org>
 <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org>
 <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
 <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
 <877f5tcmgk.fsf@grothesque.org> <87wpdsc03i.fsf_-_@grothesque.org>
 <ab4eb6a1-f634-6a8d-b260-1a7abf09f6f1@suse.de>
 <87fukgcenb.fsf@grothesque.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <6e996667-04f7-6688-563d-aacded918945@suse.de>
Date: Mon, 23 Jan 2017 06:09:53 -0600
MIME-Version: 1.0
In-Reply-To: <87fukgcenb.fsf@grothesque.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oHlq506UPN54Qfxe8Uk2U7t6jP6HaWNHt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oHlq506UPN54Qfxe8Uk2U7t6jP6HaWNHt
Content-Type: multipart/mixed; boundary="Knif1wGe4JpFOjlmTeLNL9R37b3nb1w9S";
 protected-headers="v1"
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Christoph Groth <christoph@grothesque.org>
Cc: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6e996667-04f7-6688-563d-aacded918945@suse.de>
Subject: Re: gdb log of crashed "btrfs-image -s"
References: <87o9z7dzvd.fsf@grothesque.org>
 <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org>
 <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
 <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
 <877f5tcmgk.fsf@grothesque.org> <87wpdsc03i.fsf_-_@grothesque.org>
 <ab4eb6a1-f634-6a8d-b260-1a7abf09f6f1@suse.de>
 <87fukgcenb.fsf@grothesque.org>
In-Reply-To: <87fukgcenb.fsf@grothesque.org>

--Knif1wGe4JpFOjlmTeLNL9R37b3nb1w9S
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 01/18/2017 02:11 PM, Christoph Groth wrote:
> Goldwyn Rodrigues wrote:
>> Thanks Christoph for the backtrace. I am unable to reproduce it, but
>> looking at your backtrace, I found a bug. Would you be able to give it=

>> a try and check if it fixes the problem?
>=20
> I applied your patch to v4.9, and compiled the static binaries.
> Unfortunately, it still segfaults. (Perhaps your fix is correct, and
> there's a second problem?)  I attach a new backtrace.  Do let me know i=
f
> I can help in another way.

I looked hard, and could not find the reason of a failure here. The
bakctrace of the new one is a little different than previous one, but I
am not sure why it crashes. Until I have a reproduction scneario, I may
not be able to fix this. How about a core? However, a core will have
values which you are trying to mask with sanitize.


--=20
Goldwyn


--Knif1wGe4JpFOjlmTeLNL9R37b3nb1w9S--

--oHlq506UPN54Qfxe8Uk2U7t6jP6HaWNHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJYhfKaAAoJEAE1niapr6PJOO8H/37LCx7sqSySRiATr2vkRPyf
iw6m0iXrXZmbXiZNaTum5EDbcR9H+J3tiwQS5PZHxnz9ym5ZQxInRQ9fq5ARURvR
62XB+bZxQSyAUwenhzOmWDv8J9cxCMzN5ElgnP5+VLivQXsM624jrq+xXgxNmG+j
2R6YrPwtGyhelD9Mr8+4JQ2fPC+7jjLfVTKIeFVKN04m/X4EN0u8Lh1MS4X8FoKd
jZEenFBp9zRD/IT2aem3bVr/xPwADNr1le2kCGN3u44tJOWmHdzXcFR02PzsSbx3
PBusQkMEiHZn7PyT0VItZyishhUWbkObQJMOEjiPbMESkM4OkGN6t44jeQQVnhw=
=lFq3
-----END PGP SIGNATURE-----

--oHlq506UPN54Qfxe8Uk2U7t6jP6HaWNHt--
