Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34229 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbH0Rzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 13:55:36 -0400
Date: Thu, 27 Aug 2015 17:55:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: carlo von lynX <lynX@time.to.get.psyced.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Impossible to mount two different copies of the same btrfs
Message-ID: <20150827175535.GK23769@carfax.org.uk>
References: <20150827173229.GA30068@lo.psyced.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
In-Reply-To: <20150827173229.GA30068@lo.psyced.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2015 at 07:32:29PM +0200, carlo von lynX wrote:
> Hi there. Excuse me if I didn't subscribe the list. Just wanted to
> let you know of this behavior assuming you haven't noticed it yet.

   Thanks for the thought. :)

> When mounting two copies of the same file system from two different
> hard disks with the intention of syncing the older with the newer
> one, btrfs behaves differently from ext4: it will mount the first
> one twice rather than mounting each. I assume it has something to
> do with all UUIDs being identical, which doesn't disturb ext4 though.

   When you have a multi-device filesystem, all of the devices contain
a filesystem with the same UUID (because it's the same filesystem).
btrfs therefore uses the UUID to distinguish between filesystems,
whereas ext4 can simply use the device ID (major,minor). Create two
devices containing a copy of the same filesystem, btrfs sees two
devices with the same UUID on them, and decides they're a part of the
same FS.

> This only happens with btrfs - I cannot mount two file systems that
> happen to have the same UUID (or are deemed identical by some other
> criterion I cannot determine). I presume this is not intended
> behavior. I tried relabeling one of the copies, but it didn't have
> any effect. Now I'm looking into ways to change the UUID.

   It's well-known behaviour, and documented on the btrfs wiki's
Gotchas page -- first item in the list, in fact. :) Basically, it's
likely to give you results somewhere between "doesn't work" and "eats
your filesystem, sets fire to your sofa and feeds strychnine to your
cat"(*). I can't really recommend trying it.

   You can change the UUID offline using a recent (4.1 or later)
version of btrfstune.

   Hugo.

(*) No sofas were harmed in the writing of this email.

-- 
Hugo Mills             | You know... I'm sure this code would seem a lot
hugo@... carfax.org.uk | better if I never tried running it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV308XAAoJEFheFHXiqx3kDBoP/i6GHtUKYr6qQucdYg2Yecwe
zP3wrK/A5lpJDtSD0F2wEw68qizZbE1Wt3ecK04aPshB+OGS6tMd7Zak0jw8hvW1
EFfWHOHLqwuz+CTfjEQTwxqdDDb1K+ByrNeWHR3uPo/wyW/oRIUzmxiiu/qOT0vV
sMR2lix5EAguk8syMs6qXxdRG1TONQVKhfhZDVOYcCKKQTEK0B5SGBbUif6cHFV4
Y65bQEfcxSviuZVAMTyl9R6AZIwBvRwwfu8VhIHuueF4xoUSj1+h37pqI1jiYp4t
TckE+O5VwjSfWUkueZyuIW2ZQrI7eHJcymexbTAuAlNRIUlBpWG/FntSCB7/6Ydn
runuiv0X9X6w+sF1eEvTvDtCemSwAQxccVMW1xfL09BgWYuEyIi3oQXpmdujPc8o
yJF48FC8l6Am3CgCSiUlrmyECCD78pBUm6HC2WX4Aq8RDQGFzZ+oU/C71Ee0VyuW
Moq43Xi2IxI4Bwa5IWB5UrV9gxj7R4v0PZk4PSGJnostidK7HSoI7Df0CV4N8t9Y
j+XAyAgQrcx3n3KqaBDSX26ljmL89yyc8qM71q+fZJFhFpVHltDdp667AyW3k5fO
Pc/yX4W4oPM49cHVuHkWoz7kHvbBH+QCE+ipWXPmOWImTft0CAPB3znmM2/Kj1eb
BemuR/WaP0Yn0kkUo89D
=8C89
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
