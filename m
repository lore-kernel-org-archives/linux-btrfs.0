Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48632 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755066AbcIGUgD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 16:36:03 -0400
Date: Wed, 7 Sep 2016 16:29:32 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Security implications of btrfs receive?
Message-ID: <20160907202932.GA21290@hungrycats.org>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net>
 <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
In-Reply-To: <1473271679.24874.36.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2016 at 08:07:59PM +0200, Christoph Anton Mitterer wrote:
> Even other multi-device containers (LVM, MD) don't at least corrupt
> your data like it allegedly can happen with btrfs.

LVM and MD also check sequence numbers and timestamps.  You can't just
guess the UUID, you need a UUID *and* some other values that change
every time an array is activated.

They don't change enough for security purposes--it's still possible to
intentionally spoof them--but they do prevent accidents like dd copies
of hard drives or LVM snapshots.  In this case, only one of the copies
will increment its sequence number, and after that the other copies will
not be permitted to join the array any more.

BTRFS could use transids for this.  It currently seems to accept the
last device to present the desired device UUID without checking to see
if the transid is consistent with the other devices, or if there are
other devices with the correct UUID and transid.  More can be done here.


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfQeKwACgkQgfmLGlazG5zcDgCgjM3aFVGrvmgiIROSRUNZxMcH
xTEAn0Pqoqc5mDulQ4nDnySUqKyAmTAc
=2ZAS
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
