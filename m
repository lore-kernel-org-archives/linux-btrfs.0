Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37113 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935202AbcIPMVw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 08:21:52 -0400
Received: by mail-it0-f50.google.com with SMTP id 186so14940824itf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 05:21:51 -0700 (PDT)
Date: Fri, 16 Sep 2016 08:21:48 -0400
From: Nicholas Steeves <nsteeves@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Size of scrubbed Data
Message-ID: <20160916122148.GA17713@DigitalMercury.dynalias.net>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
 <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
In-Reply-To: <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thank you for the assistance Chris :-)

On 15 September 2016 at 17:18, Chris Murphy <lists@colorremedies.com> wrote:
>> On Thu, Sep 15, 2016 at 9:48 AM, Stefan Malte Schumacher
>> <stefan.m.schumacher@gmail.com> wrote:
...
>> I believe it may be a result of replacing my old installation of
>> Debian Jessie with Debian Stretch
...
>
>>
>> btrfs --version
>> btrfs-progs v4.7.1
>
> Upgrade to 4.7.2 or downgrade to 4.6.1 before using btrfs check; see
> the changelog for details. I'm not recommending that you use btrfs
> check, just saying this version of tools is not reliable for some
> file systems.

Hi Stefan, as far as I can tell 4.7.2 is currently blocked from
migrating from unstable to testing due to a glibc version transition,
so the easiest thing to do is to get fall back on 4.6.1 found here:
http://snapshot.debian.org/package/btrfs-progs/4.6.1-1/


Cheers,
Nicholas

P.S. You're brave to run testing before the soft-freeze!  Occasionally
security fixes in sid can't propagate to testing, because a transition
like this is in progress ( https://www.debian.org/security/faq#testing
).

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJX2+PcAAoJEFqIMEdffRBhURoP/A1z9DERlPM4eDoQetx/4UBS
0/qJXiuXr+V3Q+Zta+Qr/1WymSKpiP+Zwm3dpAXVERSbC4wGQBzwsUszj6nqKps7
6MH9fNXGBTACg70qMfUgjJnlmp/LaU/XrOvGMatlkqmOmAxBZSljsKO7iJZCChCE
3S7/kVCcXvLyK0e13b4S9/AAeB3TzjqVU6Ch24Txo9JAaahzBqNZB5s9IC+/ex+t
ZKlY9j8L0d7mFc8UGxvui4Lpb0fMbdYSrFDqoHBIbfbbOAB8wbHibXInBv1AIqdF
JhyM7xptrijDXOxppIdU+O0JbKXAsBFxqIJfKjrxVQpVV62izBKRvaOujAFrqcx2
Qi9d1hC+T8gRHmfYg2wc67FtHVahfpeov4W9t4FRfcmgeC4142bC/p/Czuk2DK9n
jyUUrrcPCvBvBqW5MGQBvF3biZztbITJmuWa5WmMYrIYbBPeR5T8DVQaB8GsVW3m
fxCE9U4flmHv6NJeab2Ce/mCHOiQ9ZFvBZCMIt+3VuqnQLpwtK5b/Mjyx1m+a3fK
XvP+h0UnB1zReA+FR1nEwCnLc3BmUXLkf571zm5nY/LXv4qDfY3qrFeeOaYO95UY
YAxfyMcW/+KrFfY1FbC7iwyyEMA5KAb/rPnEukXJrH2aNfpsfEyCx8z3obo4xmAs
GrxIPpNPfTnLX3zVHNXf
=OblS
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
