Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:40064 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab2GCN6k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 09:58:40 -0400
Date: Tue, 3 Jul 2012 16:58:25 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120703135824.GA8908@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
 <4FF2EF68.6090401@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <4FF2EF68.6090401@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 03:11:04PM +0200, Jan Schmidt wrote:
> > The oops is transcribed from photos, so it may contain some errors. I
>=20
> You did *what*? :-) Uploading a photo would be fine, just in case that's =
easier
> for you the next time.

Nah, it's sometimes refreshing to do something that doesn't take too
much thinking for a while. Besides I fault myself for not having had
netconsole logging on that machine and needed to punish myself for
that omission ;)

> That's looking strange.
>=20
> I checked the readahead code again: It deliberately skips locking and uses
> btrfs_node_key with a counter variable. This means, we might end up readi=
ng a
> key that's no longer actually there. However, it only operates on nodes of
> trees, not leaves. Node entries have a fixed size, so no matter what chan=
ges in
> the node, you won't reach behind the end of that node with an index that =
was
> valid the moment before.
>=20
> As far as I see it, that algorithm is safe. It could miss some keys or do=
 some
> extra work that's not strictly required, but it should never reach a GPF =
=66rom
> btrfs_node_key.
>=20
> If no other ideas come up, I'd try memtesting that machine.

Ran a full pass of memtest86+ v4.20, with no errors found. Also the
machine works very well in all other respects under heavy load.

I think I might try setting up that netconsole to see if there are any
interesting console messages before the oops... As I said, I also was
able to reproduce this on 3.4.4, so ATM I assume I'm able to reproduce
this at will.

	Sami

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP8vqAAAoJEKLT589SE0a0hSAP/AlPqGzfb1KL2ftYY+JQgWHy
oyX4aWB5fmPbesnTJK6snvF2S4gaWR7mkGC6KS+OGNKdXTGkPOz4+RZHEumuNk0I
hm0qAd5GcDPTH9MdBiuwe5mJXkvyAZ2L3Qk80JSotKqrVpT1fV1Duue/LHwQ5150
M2paGUsYi89zPrpR6Oqh0g4SYl13wvrDxiSiLMR8gAclXF2pefA4v+lfZNb9gPOJ
TyYpRafHUgy/jmeHO0V24FzZm21RUrCZdt1bdNNk7N2pZuuIKDwKORDwyY4CIdPO
3+HAY+DdWYIiW1YsK6KKN+w3pxkQhDzJY7bU7QiO9GhMQCft7w7wVv8n4LR+DpUa
uhet7r7XbTcUSczs4bl0ZUlwKziKqSLLGzoIBYzyPR0ZBddJRUp+LuIz80yRb0fS
mAl6yOm5FYW+CGActG+VTsDddLZDoyQa7catkwHpGXwK/z84LLN3+6tgsVNRCLnc
eSH6XSpdQreFGH+gUxehlby4z6POwXoCHFBd/szPqoGbekM9kEMX27s6NF44JY0n
gm7giVxo6zfpXRZXTr75EeV0aH1q/CbhXBjtmnA+Fk12gdmUgUtv8Tlif+hFz2M6
7zRpz36dlUTqy5CnwOvokyC6DxAsV7jl8G2PP9EBV3ggiisS9WUW1/Jju1xLcMFl
VRj/Bv4CmIYDveztUnbs
=XAWZ
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
