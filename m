Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47363 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbBLWKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 17:10:20 -0500
Date: Thu, 12 Feb 2015 22:10:18 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Nishant Agrawal <nragrawal@cs.wisc.edu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to compile btrfs-progs?
Message-ID: <20150212221018.GS28427@carfax.org.uk>
References: <cc8040167122fea3f732a80a953ef78f@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gPQW1Pk7T/0rhUBV"
In-Reply-To: <cc8040167122fea3f732a80a953ef78f@cs.wisc.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gPQW1Pk7T/0rhUBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 12, 2015 at 04:54:47PM -0500, Nishant Agrawal wrote:
> Hi,
> 
> I am new to btrfs and trying to learn it.
> 
> I have download btrfs-progs code from the git repository but not
> able to compile it.
> 
> Can someone help me with the steps to compile this user space programs?

   There's a bunch of prerequisites you need to install. The wiki
documentation at [1], [2] may be of assistance. If you're still having
problems after that, it'd be handy to know how things are going wrong
for you, rather than "not able to compile".

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Dependencies
[2] https://btrfs.wiki.kernel.org/index.php/Getting_started#Compiling_the_userspace_utilities

-- 
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: 65E74AC0          |                           Stephen Franklin, Babylon 5

--gPQW1Pk7T/0rhUBV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU3STJAAoJEFheFHXiqx3kKTEP/3O8oEgwKRu7tlipT7FNy8JE
2JPSernWXEqlAmPFoPBntw0dNtYbiWJVh3oYWsSGALGodSwXGxDMNKbwn4louSqY
81gXn3Wl8nDO6w9vPq83tWFgwfKpZKvN+12Cz8TiYnSQuzDUyMnYlR54h1pVAEzV
PDVvmPJ896PS9C7looEJkamT6ign6sY+Qu+t6ezPjKa9ifoBhbO0rHjL0ndKVMgR
PrvL0pTVg+SuyXoMqvfKXqaDr9Z8a34VrAiqc5uACR6bzEv9BLEWkU6M862LU8cH
vlCIT8WiU5ZQhid6pNXTN0/BK/SYd8+FcAfXQ4/GL3dBfmyfEr8Z7ntyUaEUNyff
9/KYk4/1YGwEzt7uUslxCWlF7NzUmX39kIAygILORY8H11r6dNkGU2YEv+cFs4/7
BAT2V1AgdLKfEcL0snuERx3Xmh1CarrunIaXt7XSq30O0MKb/fMZISZiahr031rv
ZJN5CnAZotkRQKFNQj3pBQtruZCV7hmCjstCi1+4qJA2zn70daiYdBPTprSPg4Gg
IpMcm2wvjCJN2PIjeniH8QHV3UgcA6cyx/ZL6DP7wirigC7TAPSOSbJv5xVdDPuk
1Nw0+86a8EV1e84DiNgxWMEnIjKrzSzdRDMT8ikDo67Ni+2eX04+WweoiJdcHeDq
zbsSwvdkiKoOUhEcikKU
=30Zj
-----END PGP SIGNATURE-----

--gPQW1Pk7T/0rhUBV--
