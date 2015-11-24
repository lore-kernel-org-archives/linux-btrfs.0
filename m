Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56149 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbbKXWI2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 17:08:28 -0500
Date: Tue, 24 Nov 2015 22:08:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Nils Steinger <nst@voidptr.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
Message-ID: <20151124220823.GU24333@carfax.org.uk>
References: <20151123211012.GA12286@ny.voidptr.de>
 <pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net>
 <56545C1B.1080507@gmail.com>
 <1448390914.21291.42.camel@scientia.net>
 <5654CC1B.4030209@gmail.com>
 <1448398257.21291.63.camel@scientia.net>
 <5654CF58.8080207@gmail.com>
 <1448399833.21291.84.camel@scientia.net>
 <20151124212746.GS24333@carfax.org.uk>
 <1448400986.21291.95.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OLq6itPlQwcDjwuA"
In-Reply-To: <1448400986.21291.95.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OLq6itPlQwcDjwuA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2015 at 10:36:26PM +0100, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 21:27 +0000, Hugo Mills wrote:
> > =A0 =A0-p only sends the file metadata for the changes from the referen=
ce
> > snapshot to the sent snapshot. -c sends all the file metadata, but
> > will preserve the reflinks between the sent snapshot and the (one or
> > more) reference snapshots.
> Let me see if I got that right:
> - -p sends just the differences, for both data and meta-data.
> - Plus, -c sends *all* the metadata, you said... but will it send all
> data (and simply ignore what's already there) or will it also just send
> the differences in terms of data?

   Well, if you have a snapshot A, snap to A', and then send -p A A',
it'll send the same amount of data as send -c A A'.

   However, the effect on the receiving system is slightly different
in terms of the subvol metadata -- with -p, it will preserve the
information that A and A' are snapshots of the same original. With -c,
it won't preserve that.

   This will probably have knock-on effects in terms of round-tripping
the snapshots (e.g. for restoring one to the hosed system and
continuing with the incremental backup scheme). I'd have to do some
hard thinking again with the send/receive algebra to work out what the
effect would be, but with the -c approach, you'd probably have
difficulties. The round-tripping feature hasn't been implemented yet,
so the point is currently moot, but it's certainly possible to do it
(with a small send stream change), and it probably will be done at
some point.

> - So that means effectively I'll end up with the same... right?
>=20
> In other words, -p should be a tiny bit faster... but not that extremely =
much (unless I have tons[0] of metadata changes)

   Yes.

> >  You can only use one -p (because there's
> > only one difference you can compute at any one time), but you can use
> > as many -c as you like (because you can share extents with any number
> > of subvols).
> So that means, if it would work correctly, -p would be the right choice
> for me, as I never have multiple snapshots that I need to draw my
> relinks from, right?

   Correct. The -c case is much less often needed. It's useful if you
have, say, several otherwise unrelated subvols that you need to
transfer efficiently from a filesystem that has had dedup run on it.
(Other use cases may apply as well).

> > =A0=A0=A0In implementation terms, on the receiver, -p takes a (writable)
> > snapshot of the reference subvol, and modifies it according to the
> > stream data. -c makes a new empty subvol, and populates it from
> > scratch, using the reflink ioctl to use data which is known to exist
> > in the reference subvols.
> I see...
> I think the manpage needs more information like this... :)
[snip]
> [0] People may argue that one has XXbytes of metadata, and tons are a
> measurement of weight... but when I recently carried 4 of the 8TB HDDs
> in my back... I came to the conclusion that data correlates to gram ;-)

   Yeah, I've met that particular equation too... :)

   Hugo.

--=20
Hugo Mills             | Anyone who claims their cryptographic protocol is
hugo@... carfax.org.uk | secure is either a genius or a fool. Given the
http://carfax.org.uk/  | genius/fool ratio for our species, the odds aren't
PGP: E2AB1DE4          | good.                                  Bruce Schne=
ier

--OLq6itPlQwcDjwuA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVN/XAAoJEFheFHXiqx3kPlgQAJrsJSap6NfWj++H5Uhb4te5
m08lTApL46G9ICmhSwg6CJPEDEk7gzQKd00MCd9KxZFE+WbOw50rbnpyBYVhj7Yf
3k0bkbBR4QyrjPtlR91mfA73ST8WkOzSyv6WVjEbY9gDbnOltDR6dj/3dEoF3xck
1YaYbZcmjrbI6Y8RMtE/xj8nfB91V3GxGmEBOfattN6rEbMvb92stkeYTxpvriSP
ZH2fHAsLsZURhDyEf3hY2gLPMjaXB9JBbAZ8JGQYksH8BFCC4zAIubp/eBbrJ4Mu
JjRYJ9HTN49+odP1Q7I5HFBZr9TcM1r4uoKSJ/FtuQCba9CiONrogf45RPtzCwdC
RSrsmTPL4AYzbAaZotfNesNTPJv/aq4zF5jCJsHf4B9hRjDsLoKBf1dO0beNS3lt
1P/i7UrYlUIgBdNoLeEbip92GguMTx0mMiTLLir9GQx3L0+LblF2MiDPMFLApoc6
Xj00IM7INhMOek4B2XIkTbTyCXPTXM0Jsx38lUhQ+/cZ9yT6055teiIiXnrnGNaH
+vICFJatADAcpNUCniIWM6rU2RlzVSkDLQLu1MQHOi0dHp/0nb0IJcIVJLli0Occ
Sck11a2excosHQEC9uyUJdjmOd8r7kGLyPrgkD1yaejTU2A29zZ4OO6SKrIsicTI
rEwS8v6KPrw0zAqSKjuT
=5y3s
-----END PGP SIGNATURE-----

--OLq6itPlQwcDjwuA--
