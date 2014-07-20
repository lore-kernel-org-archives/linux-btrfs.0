Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61132 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaGTLlD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 07:41:03 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0Ldq9D-1WhQtj3aXj-00j5Yh for
 <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 13:41:00 +0200
Date: Sun, 20 Jul 2014 13:40:54 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140720134054.3cd6cef3@marcec>
In-Reply-To: <20140720122233.4ef06751@marcec>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/z1ocOCCKnNYv7dxzcvX/f94"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/z1ocOCCKnNYv7dxzcvX/f94
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sun, 20 Jul 2014 12:22:33 +0200
schrieb Marc Joliet <marcec@gmx.de>:

[...]
> I'll try this and see, but I think I have more files >1GB than would acco=
unt
> for this error (which comes towards the end of the balance when only a few
> chunks are left).  I'll see what "find /mnt -type f -size +1G" finds :) .

Now that I think about it, though, it sounds like it could explain the sudd=
en
surge in total data size: for one very big file, several chunks/extents are
created, but the data cannot be copied from the original ext4 extent.

So far, the above find command has only found a few handful of files (plus =
all
the reflinks in the snapshots), much to my surprise. It still has one subvo=
lume
to go through, though.

And just for completeness, that same find command didn't find any files on =
/,
which I also converted from ext4, and for which a full balance completed
successfully.  So maybe this is in the right direction, but I'll wait and s=
ee
what Chris Murphy (or anyone else) might find in my latest dmesg output.

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/z1ocOCCKnNYv7dxzcvX/f94
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTy6rLAAoJEL/Q5oYsiHj0y/IP/3fxSlat3imK+J8kD8imnKrB
h1KW75aQagHQKU/+yjYlwwvLA6AqqZttpmNcnnyqjWl77tcRZBK4u7o/1GpIBSnu
uYjKkxKZ3omhbyWWSRCQz6fZE2M74HBXk4KTtHOpxZ2Uj3ZSStS0YPcz+61xrGXC
G0LZpsc5l/EAhF0o1aVqG73ednGk2DrOoFED0sWfYA0l+Dwka7sMprwG6cy+P94M
uNXRJbJWcfanFuK1JwqwIYnm1x9ivrtR64X9xV+G2G/fsh92gQi8ynLLTPPd+9F8
H1VFY2p3nhAFyGeoMhGi4fyQO8hBptAZlRbi1IC5OgnDAQ9pngR8kVcwq6foxas8
sQO8z8vyXU/THb6a43u6DJDPA/NCLEctORibLvP+/07zDm2S5mk0ptoguhgfbqLb
uPjPEPPpat9KwU191b1vx2PI27AGy79tOnnGJAb14SH+vnidtl+9CBMEVgrO9Ylq
JN7THJwLpWYO5IHtsfjNFuSZFTodxfBQTjMMWOjzySGU1g0oJm7iXC4kGoHsaOSX
4N1WW1SBH9U5PeOil71LX4Ltq6ohzNcqQhS6waCvjW3ejlWRICqs6yAeIWRPqPqC
6AJbOE7pm/PZ2x3jt0Ao6XCEEw0oO/345t+v5cgAVm1o4eA0DhwOpQTXzfWJYTsL
RAZkPJWsc+vOnDQCxYW2
=cQVk
-----END PGP SIGNATURE-----

--Sig_/z1ocOCCKnNYv7dxzcvX/f94--
