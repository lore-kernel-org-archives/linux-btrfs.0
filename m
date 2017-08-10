Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45787 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753270AbdHJTZS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 15:25:18 -0400
Date: Thu, 10 Aug 2017 19:25:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Eric Biggers <ebiggers3@gmail.com>, Nick Terrell <terrelln@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Message-ID: <20170810192506.GF7140@carfax.org.uk>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vMk55pD2JuhdWiRw"
In-Reply-To: <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vMk55pD2JuhdWiRw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 10, 2017 at 01:41:21PM -0400, Chris Mason wrote:
> On 08/10/2017 04:30 AM, Eric Biggers wrote:
> >
> >Theses benchmarks are misleading because they compress the whole file as a
> >single stream without resetting the dictionary, which isn't how data will
> >typically be compressed in kernel mode.  With filesystem compression the data
> >has to be divided into small chunks that can each be decompressed independently.
> >That eliminates one of the primary advantages of Zstandard (support for large
> >dictionary sizes).
> 
> I did btrfs benchmarks of kernel trees and other normal data sets as
> well.  The numbers were in line with what Nick is posting here.
> zstd is a big win over both lzo and zlib from a btrfs point of view.
> 
> It's true Nick's patches only support a single compression level in
> btrfs, but that's because btrfs doesn't have a way to pass in the
> compression ratio.  It could easily be a mount option, it was just
> outside the scope of Nick's initial work.

   Could we please not add more mount options? I get that they're easy
to implement, but it's a very blunt instrument. What we tend to see
(with both nodatacow and compress) is people using the mount options,
then asking for exceptions, discovering that they can't do that, and
then falling back to doing it with attributes or btrfs properties.
Could we just start with btrfs properties this time round, and cut out
the mount option part of this cycle.

   In the long run, it'd be great to see most of the btrfs-specific
mount options get deprecated and ultimately removed entirely, in
favour of attributes/properties, where feasible.

   Hugo.

-- 
Hugo Mills             | Klytus! Are your men on the right pills? Maybe you
hugo@... carfax.org.uk | should execute their trainer!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                      Ming the Merciless, Flash Gordon

--vMk55pD2JuhdWiRw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZjLMRAAoJEFheFHXiqx3kedQP/A3+EFG+DMMW0h6GspoeN4Wy
dvp4dInu85BiKF2Po4EncmtE7fvtjsrvAejreSToBTsnpHY8WBW8YCB7G0ZL8mU7
eal2tviCB8OTaMj8StjzewJJOxx7HKd46K9F/A6oNj7dx+uRUrX9Wn+luq7zR23y
x0kVrFWRRO8nF3Pq6Efo21vQ9LhTLNlh+g0NwSTkjbm//Acy51NEJpeGz4ZVBYMR
Fty/cQe6v54FLlVHb49tQ+5Tsrlqm9QsUXg2xJrFmdeNr/b/fS+FRvG8UsjhWhPA
QP3pwGYX6PtATojZ8IK0sSeBdW64X0xxIvP/FjXDtWVQPauwJuAiLoaLvAoY8Z6G
uBiA9eqSdKhCR/Eu/X96GTENIl54hoYwupnbqIDDJulPWGRVjH4Cyuog9Q7gmIJJ
Q88RKs6YU21g6trq6GLGLrfkPfTepINnwkmhZK9eYE1sZs/uoP9lnIKjlKHmRekR
D3icZaU/MnmUBVrWcRDEIsi0WsNXokLb2Ww9emPZlSlwlebGMTYcKeqObRnkGeZ2
z4JqLDZk/nW9xjpxFmNrc0juN3Bi2YdRjjXm2Yq8ZUFqg6M156vFqdcRTwJpJC+G
AwOx7MXH2rvRbpH3hVuqnZCdCShQDngacssxpylobtJU/dBe4RY6cS/14JLrrUgl
ZGavyNViPMHIEv7BMRJ7
=hnJL
-----END PGP SIGNATURE-----

--vMk55pD2JuhdWiRw--
