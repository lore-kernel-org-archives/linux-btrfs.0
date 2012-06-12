Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.ru ([50.31.253.214]:45159 "EHLO rin.romanrm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2FLHdR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 03:33:17 -0400
Date: Tue, 12 Jun 2012 13:33:11 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Alex <alex@bpmit.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: KVM on top of BTRFS
Message-ID: <20120612133311.58af9d8f@natsu>
In-Reply-To: <loom.20120612T013031-188@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com>
	<loom.20120612T013031-188@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Wol01BS=lEwxdTkcj2RU/mg"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Wol01BS=lEwxdTkcj2RU/mg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jun 2012 23:53:34 +0000 (UTC)
Alex <alex@bpmit.com> wrote:

> Running KVM image files on btrfs as of yesterday.
> Used mkfs.btrfs -l 32k -n 32k to create and default options only (no mount
> options bar defaults, so no compression (just asking for trouble!), or
> autodefrag). 3.4.1 official Debian AMD64 kernel. Multi-subvol including r=
oot
> with set-default enacted. 32k's adopted per Chris's post.
>=20
> Install:
> virt-install --connect qemu:///system -n china -r 256 --disk
> path=3D/var/lib/libvirt/images/china.img,size=3D4 -c
> /home/alex/debian-testing-amd64-CD-1.iso --vnc --noautoconsole --os-type =
linux
> --os-variant debianwheezy --accelerate --network=3Dbridge:br0 --hvm=20
>=20
> This runs much slower than expected - have done many debian bare minimum
> installs like this before. Can't hear any disk thrashing. Doesn't appear =
to be
> CPU or memory bound - will double check.


=46rom man kvm:

           cache=3Dcache
               cache is "none", "writeback", "unsafe", "directsync" or
               "writethrough" and controls how the host cache is used to
               access block data.

The default setting is writethrough, can you try writeback, then unsafe, to
see if they help increase performance in your case? AFAIK the default setti=
ng
may cause KVM to call sync a bit too often, and sync can be slow on btrfs.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/Wol01BS=lEwxdTkcj2RU/mg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/W8LgACgkQTLKSvz+PZwj9IwCdFJAe75j5KVqgnRNiuqw/XpTB
MzoAnjRnYtd+1WGH7ridT9Yj6qurjDSB
=Ei7K
-----END PGP SIGNATURE-----

--Sig_/Wol01BS=lEwxdTkcj2RU/mg--
