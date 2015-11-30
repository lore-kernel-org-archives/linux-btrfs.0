Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46215 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbbK3P2i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 10:28:38 -0500
Date: Mon, 30 Nov 2015 15:28:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Bug/regression: Read-only mount not read-only
Message-ID: <20151130152837.GB8775@carfax.org.uk>
References: <20151128134634.GF24333@carfax.org.uk>
 <565C645C.5030608@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
In-Reply-To: <565C645C.5030608@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 30, 2015 at 09:59:40AM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-28 08:46, Hugo Mills wrote:
> >    We've just had someone on IRC with a problem mounting their FS. The
> >main problem is that they've got a corrupt log tree. That isn't the
> >subject of this email, though.
> >
> >    The issue I'd like to raise is that even with -oro as a point
> >option, the FS is trying to replay the log tree. The dmesg output from
> >mount -oro is at the end of the email.
> >
> >    Now, my memory, experience and understanding is that the FS
> >doesn't, and shouldn't replay the log tree on a RO mount, because the
> >FS should still be consistent even without the reply, and
> >RO-means-actually-RO is possible and desirable. (Compared to a
> >journalling FS, where journal replay is required for a consistent,
> >usable FS).
> This is exactly how it should behave (being able to say that a RO
> mount is really RO (if atimes aren't enabled) is a huge selling
> point).  On a side note, a properly designed journaling filesystem
> _can_ be made to behave like this, but it makes the filesystem
> _really_ slow if you don't have enough RAM to cache all the blocks
> modified by the journal (because each block access has to check the
> journal for modifications).
> >
> >    So, this looks to me like a regression that's come in somewhere.
> I'm not sure that this ever worked the way it should.  It should be
> fixed regardless of what state things were however.

   I'm pretty sure it was like that at some point, because I've used
it as a diagnostic tool: If you can mount OK with -oro, but not
without, then the log tree is broken, and btrfs-zero-log can be used
to good effect. (In fact, that's what I was trying to do with the OP
when I spotted the issue).

   Hugo.

-- 
Hugo Mills             | You are not stuck in traffic: you are traffic
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                    German ad campaign

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWXGslAAoJEFheFHXiqx3kMVgP/0dHeB2eFlJAo78MzX29xoLo
zy4NMujCicjYtj+stwFHCajpOThYoMRnOtI2dVNVM2KmHYA5/QIKMLmCjCgCUB3q
Z+zxi3xSqM7o26/al/Ts2UeHn7i8dHd3KCAwlvMGoSpwIwR7CniPLlPImrvTz+GT
GNCMFyWAmNTlRHdITYOvuKAvQE0D7P6a8G6BZIgl96m9zTYPGuAMixewODL4BRNo
C6CPmqIHag6Q6G9etEoqXdKZPDJqxBnT1ECBdirAaBWnoZgvUk1aFdom0QTRKqAD
590A0twYMMz09pnvgkdFkWqklRo9ncI8GANUfp1iGzIf/u46xf1TPeaQQFfwPLAp
8VyVJcti6cwcJz0npJttHoVIVhvFVh/1oP8mMD4Y1adBj+Aaa9B0g8jY7o4BSJK5
WhdBtyqaXCbDp9VSl8CfTDYP30ZIbNP/Loi/hreNQ3fnPAjcD9NH0qXNqfMNSWRX
Qee77S+DLX16OTU4pm4MoTjaN1KxcjbEyC8o+eLXnjUdv0f+/cdxQ7dvsxBflQOE
jIIzHBxGikmoSmZhNGDx+iwlcftm0wW3ag/09VBuWLvHXZHojnrbSX1QvAuPz1fQ
mCuTu+dzba2HO5m+mh4LgPuVLQ+G9lxKz8sCOU/BXiHDkZxGVKulvO8UICLaF0of
xgmrlN9bTPBtj9Cs3o+d
=sSfT
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
