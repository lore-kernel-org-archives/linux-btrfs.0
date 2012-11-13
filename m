Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45434 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2KMLUK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Nov 2012 06:20:10 -0500
Date: Tue, 13 Nov 2012 11:20:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Fred Chang <fredchang@qnap.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Mixed RAID 1 and 0 in different subvolumes (cont.)
Message-ID: <20121113112002.GA23574@carfax.org.uk>
References: <CAGnBOw-58=g4pZcKC9GYBBJtpaOC_sj2mmQpNS+J6JR9+AY9YQ@mail.gmail.com>
 <CAGnBOw-qpoydiEpgX0dBSh5xdkpZb3HGTMnMO0uYKFL596dM+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
In-Reply-To: <CAGnBOw-qpoydiEpgX0dBSh5xdkpZb3HGTMnMO0uYKFL596dM+A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 06:52:42PM +0800, Fred Chang wrote:
> Assume I have two disks, said disk1 and disk2, and two subvolumes,
> said sv1 and sv2. With BTRFS, may I assign sv1 working with raid0 and
> sv2 working with raid1?

   Not yet. It's planned, but nobody's done it yet.

   Hugo.

> One year ago, this function was not aviliable. If there were test
> version, I am willing to test it.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUKIs4r9z9OVl50rAAQK9dw/9EolQE7KYYW/rXFeUOAj4KAwMbrMAqy9U
OVPv/gNqufQSAIIlF2NJ3gMArL8inuaa9clK7at1bIaoU6hoYHLvju5/f0jghNzB
GsCl2H8MwsdM0pTFXdsZyOByjriKP0srcaPDE1pwmX1Bg0YjKRcXC60Je0KfAZjn
rNs7KgSXeX8l2lEc8ucinB7fxj0B5wu6GXJ4uGsvEzpKghUyh/UXADcqwS+yfPeK
x+xvNSVzH7qNs3lIRnIR0qs819GsztEshhXadWY+px8vS2F0rvjLlSyNZXET4vfi
rZKEvL4vwKs5NNFs/e3kz+kRjkSuCluhlCXhXvBe9TeC92GANfjt3Sd4j3dl3f1t
iZEstvQ/faNwk/XVZNY+V3+pcsfCvhu1A4F6l8wFHcM+e3+BRljChcqgvzRv1oYo
hmeZ/dINn4KQDv76F8lGOdAYUx7MmXj2tojLNxMlFfjGgXD4ds7OkF0BRMFXJiwa
Eb253wxUiWexsJbWpfy1zE1jmLaaPU3v1UtF7ytrPktzdEdzX/kAxYrya7BirfC4
fLN3YklcZUzjs//A4rxatvfsvNfzcO0T+vnt1ObC98Fx+OHwMjj/TQ+/T2W4AVwr
eReEPXIUM0LbHSZqQdJAZfUiOzNYXyi/3JJf3BtjGVUsgPZN+APxtEiHjPIGDw6z
UhkrQD8fSoY=
=x1cq
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
