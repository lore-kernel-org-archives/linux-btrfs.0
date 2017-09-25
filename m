Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47422 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932117AbdIYHnt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 03:43:49 -0400
Date: Mon, 25 Sep 2017 07:43:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marat Khalili <mkh@rqc.ru>
Cc: Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
Message-ID: <20170925074343.GB25529@carfax.org.uk>
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
In-Reply-To: <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 10:42:06AM +0300, Marat Khalili wrote:
> On 25/09/17 10:30, Nikolay Borisov wrote:
> >On 19.09.2017 10:41, Misono, Tomohiro wrote:
> >>"btrfs subvolume create/delete" outputs the message of "Create/Delete
> >>subvolume ..." even when an operation fails.
> >>Since it is confusing, let's outputs the message only when an operation succeeds.
> >Please change the verb to past tense, more strongly signaling success -
> >i.e. "Created subvolume"
> What about recalling some UNIX standards and returning to NOT
> outputting any message when operation succeeds? My scripts are full
> of grep -v calls after each btrfs command, and this sucks (and I
> don't think I'm alone in this situation). If you change the message
> a lot of scripts will have to be changed, at least make it worth it.

   Seconded. Make sure the return code reflects the result, and drop
the printed message (or keep it if there's a --verbose flag, maybe).

   Hugo.

-- 
Hugo Mills             | If you see something, say nothing and drink to
hugo@... carfax.org.uk | forget
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                 Welcome to Night Vale

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZyLOvAAoJEFheFHXiqx3kwE0P/iojqPRNetRn7NVF+8lOwvFY
9XHNdME/ronmkYnWLmuwXFfDrY44N6ZUO+dfjasi50X3uD/bX/No1KfSdrlkSS9z
VEdP6Zbmmb0z8fHxnfc6msI6vYxqnXjdZsM14YXXrd3nsxtQuuM7ZVTAUHiUt/7D
xpMy7ymrF3RuwsY1J7w1SDufyMMHnbxFM/7DGb8tOu2dpt6pmy94hVzKlButYgz7
CA8HH+DIjV8HvDJTWe1M0a0jbE6RgLkUeSdC6M24MVSRuSIgiRZeQXf1dj++dEJ9
BBCQkUX4kyx125U4y5fUQ1Vbg1ti/Gf4RNF1UzmgZ+7wvXhmbluv05+rBqF5yfVE
aoSFiutoz6lIScQQoP7yAijFd88gbgVGMvmCYg17D4Jo3kJRf4C1Dlwh30BWktkI
LVZBgMJsXC3oF1hXLHeb3GpZqS6pj38/ij8KYfqo3fUyAEMtHL1XTEy0VjKxA1kM
ZAJF/TbnphUMxx1WzBCZmF187xqHL4gh+x35ERBE2TUIdMjUPXN0zJd9m19g1ShS
cLj9op3/Z3nYxVrM8GHX1VWVadSN6QaEZYBB9N5iX3zW4/gQKM47l0oZ1uLG/O2u
yZLu/vfhcZvrwyH9hZ4iHq1R2Rz+J6eCmBnrAWsG9rofc9xuWpiBflzkuZPtr2lY
VbmDa/+07l1Xxv926C4v
=gNzP
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
