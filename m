Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56369 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbbKXXGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 18:06:46 -0500
Date: Tue, 24 Nov 2015 23:06:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: shall distros run btrfsck on boot?
Message-ID: <20151124230641.GW24333@carfax.org.uk>
References: <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net>
 <56549AFB.3040904@redhat.com>
 <1448385809.21291.22.camel@scientia.net>
 <5654CAE0.5040907@gmail.com>
 <5654E427.6060708@redhat.com>
 <20151124223349.GV24333@carfax.org.uk>
 <1448406109.21291.97.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8fFQOkr0mRRE6sJ/"
In-Reply-To: <1448406109.21291.97.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8fFQOkr0mRRE6sJ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 25, 2015 at 12:01:49AM +0100, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 22:33 +0000, Hugo Mills wrote:
> > whereas a read-only mount of a journalling FS _must_ modify the disk
> > data after an unclean shitdown, in order to be useful (because the FS
> > isn't consistent without the journal replay).
> I've always considered that rather a bug,... or at least a very
> annoying handling in ext*
> If I specify "read-only" than nothing should ever be written.
> If that's not possible because of an unclean shutdown and a journal
> that needs to be replayed, the mount should (without any further
> special option) rather fail then mount it pseudo-read-only.

   At one point, I _think_, btrfs did replay the log tree
unconditionally, even on a RO mount, but it doesn't any more. There
was certainly some discussion on the point. It's actually quite handy
sometimes -- if you have a corrupt log tree, you can check it by
mounting RO (when it works) and RW (when it fails because the log tree
is broken), and the do btrfs-zero-log to clear it.

   For the record, this is about the only good use for btrfs-zero-log.
It doesn't magically fix anything else. (Yes, this is another futile
attempt at killing the persistent "btrfs-zero-log fixes everything"
meme that's been doing the rounds for the last few years).

   Hugo.

-- 
Hugo Mills             | Never underestimate the bandwidth of a Volvo filled
hugo@... carfax.org.uk | with backup tapes.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--8fFQOkr0mRRE6sJ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVO2BAAoJEFheFHXiqx3kowUP/Aj108zjFmNOArmP66rXeJfW
sJTNZ/GGyVA1ylLyv4akZ+Yd0VCiWKFsjJ/uviN49b4vY+qyxeTMzRwy4OLgT++D
QsBWUygXwDuF/Rt/js87BWz1Y55zk1Od2OFUgcLmWXo5Xij5AiaauEIIe7UZ7xiM
2gsoc7Qw0TTCqfmoL/5OimFHkM30EUH7MtWqvLhdgKYdujY9o1QH0mZx5l8AMYW/
x7ZCPr5xz38K7c4zOcEh9gfFcIJentM37T70cHORwGDXEVqTOWaYGyPOcGyGITgr
LUrLIQw5cuVy1azdRG4KDYQ9GP0yOJ3Vh2vzvNGpU0oI/4hNh1VhZMOMNVY/qvgp
fzKYnrjoGFF58t0IJitgV8UF61qmR0wA0T0N1QT/qOs26lP65sZ2emwA7K3GCtQP
9ENxUcYt6u9Hq4CAXxjvqWclUW7r5QCU/GKFvKl2/i2hi6WdlijZPjYy2Wz7j13h
KtVQH9gq3PlqgMJdY1uGnL/lHjT3WgLfgf/rGY3O3JUOrkr/yU1bFDCzZBigz7De
HRUXhUaLJPreatkvM1BLRjSwWRyY5TNxKUiu7aQY5VSw2WM6g8tUMlPjREChnI1c
Oiuw0RjUlqqo8F3UjsBEe0ewdtifeukDbjjgwKybnt89BMQSJSyqazyf+FGvi7T3
3lB0A9HgAa+7qoPfZt2j
=H3Eu
-----END PGP SIGNATURE-----

--8fFQOkr0mRRE6sJ/--
