Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56235 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbbKXWdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 17:33:54 -0500
Date: Tue, 24 Nov 2015 22:33:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: shall distros run btrfsck on boot?
Message-ID: <20151124223349.GV24333@carfax.org.uk>
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net>
 <56549AFB.3040904@redhat.com>
 <1448385809.21291.22.camel@scientia.net>
 <5654CAE0.5040907@gmail.com>
 <5654E427.6060708@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jMesTDEFHiw5APJ"
In-Reply-To: <5654E427.6060708@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+jMesTDEFHiw5APJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 24, 2015 at 04:26:47PM -0600, Eric Sandeen wrote:
> On 11/24/15 2:38 PM, Austin S Hemmelgarn wrote:
> 
> > if the system was
> > shut down cleanly, you're fine barring software bugs, but if it
> > crashed, you should be running a check on the FS.
> 
> Um, no...
> 
> The *entire point* of having a journaling filesystem is that after a
> crash or power loss, a journal replay on next mount will bring the
> metadata into a consistent state.

   Not an actual argument within the discussion, but an interesting
observation on a fine distinction:

   It's interesting to note that there's a difference here between
journalling and CoW filesystems. A journalling FS needs a journal
replay to become consistent. A CoW FS is _always_ consistent, by
design. Now, btrfs has a log that should be replayed after an unclean
shutdown, but that's all about the data that got written within the
current transaction that wasn't committed, rather than about FS
metadata consistency. This means that a read-only mount of btrfs can
_actually_ be read-only, not modifying any of the data on the disk,
whereas a read-only mount of a journalling FS _must_ modify the disk
data after an unclean shitdown, in order to be useful (because the FS
isn't consistent without the journal replay).

   Hugo.

-- 
Hugo Mills             | I'll take your bet, but make it ten thousand francs.
hugo@... carfax.org.uk | I'm only a _poor_ corrupt official.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              Capt. Renaud, Casablanca

--+jMesTDEFHiw5APJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVOXNAAoJEFheFHXiqx3k+W8P/1MPAHj8dQApfux0hK0Uyrrl
DCo7xB2BQdfpEB7ybY9YGO2yZdqidAeJSstXZepFmyMKtFSmdC2CYzrqPoUPAqbq
+dGSL3Asv7MnUXtV0bGPKL65ZT+0Gu5HXM5EM/Hr4ULY7vgGpwhZ1dQ8KE5lkg71
q/tybckKcqHe9+cLNv26j+fGyhfEa2d0d5W6er/PzN3XxX9cXuGeBIsxnvQT00EX
uwtbJTpaiONaR7+ovO52KvYt56jQzbLNL6udL3DahRvLsZ52JkV1kl2Edk1OLywv
LaBuam5yheh36oao8jtzjaSoIySalZ0d4QQGRHP1KB490aur5kA5LDXDvIhfzUzT
amaRrOk1pg1XFyOvahYEx73vPf59SWQ4/o4wNSG0u5EYnUy70+1jvdsmKJyWtQIH
NzK98av+mx8wC22HUOWpS2vBlgOstRvpvWNaL14acGeyyfeNlRkigDKPlv33U2d4
r9TXp2hcXT+xhbrZpXsvjJkJCw7QAN92FbjzsNQTAiC6wYLn0Du6djV5Y7WfB3lK
DBNM6uVz2mSV+1z1853/fco/CRL4v/p8uqjKPYrbUB37x7qu9/F1eS+qy2fdpGNR
BfFvdrVuYESnEFy1yPexnwjfnD7tTo9S6gZVQdHK4LxLL9nAhWfZ3C5CrpP8iPeS
hZ1rx1zH6XXHEWXP4Eir
=wJHY
-----END PGP SIGNATURE-----

--+jMesTDEFHiw5APJ--
