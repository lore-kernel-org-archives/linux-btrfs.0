Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49571 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdIEOjQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 10:39:16 -0400
Date: Tue, 5 Sep 2017 14:39:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs@vger.kernel.org, Henk Slager <eye1tm@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        A L <crimsoncottage@gmail.com>
Subject: Re: Is autodefrag recommended? -- re-duplication???
Message-ID: <20170905143914.GB23980@carfax.org.uk>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
 <82e453bf-ff11-a911-c432-3e0173b223b2@rqc.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
In-Reply-To: <82e453bf-ff11-a911-c432-3e0173b223b2@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 05, 2017 at 05:01:10PM +0300, Marat Khalili wrote:
> Dear experts,
> 
> At first reaction to just switching autodefrag on was positive, but
> mentions of re-duplication are very scary. Main use of BTRFS here is
> backup snapshots, so re-duplication would be disastrous.
> 
> In order to stick to concrete example, let there be two files, 4KB
> and 4GB in size, referenced in read-only snapshots 100 times each,
> and some 4KB of both files are rewritten each night and then another
> snapshot is created (let's ignore snapshots deletion here). AFAIU
> 8KB of additional space (+metadata) will be allocated each night
> without autodefrag. With autodefrag will it be perhaps 4KB+128KB or
> something much worse?

   I'm going for 132 KiB (4+128).

   Of course, if there's two 4 KiB writes close together, then there's
less overhead, as they'll share the range.

   Hugo.

-- 
Hugo Mills             | Once is happenstance; twice is coincidence; three
hugo@... carfax.org.uk | times is enemy action.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZrrcSAAoJEFheFHXiqx3kjq0P/RYmo0pekHxkLgoBrpSXF8hO
vWIBlF4oyz/nuEHMjq2DtfQ+1FMkb6Iq4gCoe+Ms/q36UMs5yltCxTdtzvVwrl4Z
UF8hlBuEJQ4Czaa2Ca8p6WkwEB4YbVvaqOqQyclBmwh9yhzwInFx0qoc4NlE4M3G
W1dEvRB9z7s9x8khdbPTYcVE9DhE5Eyv++/kiV3EWvSjtirJ1OVWl5GssNNGslK7
8LvuxoZWWkXl2Jy5BfsBa1Y8z/PDfKbk1dZZGdkiOKFzJuAmA9E6G2qjws8ZA47i
nuM0ria6YeG8Uh+guRAnP03CzLbcCkNjJrOVXjFQ+gMjMX8GwsHrcgFkZtVB7FUC
TWGNOgt+nJQ1LClEv3ou8wjhnSlpdXqUVNmj1Tnej45jqJQbpyFuFuF/DJJIWrpX
z9kKGSnDnJFlhQUIO2jbhRnoIxCMFluhboye8KDLY4QlBUs6/I0YkQv8PSif8KFV
VrwTVpvjwgkHCJTd8s2n2rTxkhCbf8qtowouU/lLwJ6wBFUKvpgYmN2zc7dmNQ8Q
00U/QM1IwZuXzdRrCUgy37ebHmyziORf/SazQcOTimwHQlmj/7cNNGE67TakgGHs
dRJ6iApXIBOaPYPvVz9N7bRFWMFv88qEnh5NXAx8DnNARYyeAQfI5M0YE2zpSzxs
qCpzEOV1oh7tYKt1Bov2
=FoIh
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
