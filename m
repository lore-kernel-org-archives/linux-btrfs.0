Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57543 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754810AbdETB0j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 21:26:39 -0400
Date: Fri, 19 May 2017 18:25:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Message-ID: <20170520012522.GC29894@merlins.org>
References: <20170519041638.sf7sensley4lpxiz@merlins.org> <20170519190358.GC10137@lim.localdomain> <20170520001134.GW29894@merlins.org> <20170520003747.GO9701@carfax.org.uk> <20170520004748.GA29894@merlins.org> <20170520005709.GP9701@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
In-Reply-To: <20170520005709.GP9701@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 20, 2017 at 12:57:09AM +0000, Hugo Mills wrote:
>    I think from the POV of removing these BUG_ONs, it doesn't matter
> which FS causes them. "All" you need to know is where the error
> happened. From there, you can (in theory) work out what was wrong and
> handle it more elagantly than simply stopping.
=20
Sorry, "you" being the code author, or the user?
If code author, I'd rather this be worked out without the extra steps of
having to guess or spend more time to see which FS.
My FS takes up to a day to scrub and btrfs check, clearly making me do this
over 3 of them is not a good use of time and a loss of up to 3 days of wall
clock time.
Not counting that during that time, I have loss of service on all my
filesystems because I don't want to mount them read-write.

>    Obviously it would be nice, from the POV of the sysadmin, to know
> which FS was complaining, but as an FS developer it's secondary to
> identifying a BUG_ON which happens in real life, which offers an
> opportunity to make the error path more elegant.

If the FS is remounted R/O, further damage is averted and it's obvious to
the admin which FS has a problem.
Is there a reason why all errors that are serious enough, do not cause the
FS to remount R/O instead of having any BUG/BUG_ON at all?
WARN_ON is also fine obviously if the error is not serious enough, or doing
a WARN_ON + a remount R/O

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQCVAwUBWR+bAn4xUKZ2O+kBAQKW0wP+Kuo77fpdK8V0UoxCYMpWJ6EzPxAkH/JS
5s7zNOP4wj5FOjujrGGqYOj+z50HMz4CjWLVGD5FYcjv9QtN9PLd6kaOTRjb1YLh
nge8YgZ0vQMBmifkJGuiWPJncivENfdiWg6t2zYYWqM+f2stGYSz+XMX3B1Uawib
gXiJ0ZBhwFc=
=qHjq
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
