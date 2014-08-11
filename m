Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([5.39.87.147]:56466 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaHKTOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 15:14:05 -0400
Date: Tue, 12 Aug 2014 01:14:01 +0600
From: Roman Mamedov <rm@romanrm.net>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Large files, nodatacow and fragmentation
Message-ID: <20140812011401.568c16e6@natsu>
In-Reply-To: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NqqeJN9t1VkhLIgMdoc.jOa"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/NqqeJN9t1VkhLIgMdoc.jOa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Aug 2014 11:36:46 -0700
"G. Richard Bellamy" <rbellamy@pteradigm.com> wrote:

> I've been playing with btrfs as a backing store for my KVM images.
>=20
> I've used 'chattr +C' on the directory where those images are stored.
>=20
> You can see my recipe below [1]. I've read the gotchas found here [2]
>=20
> I'm having continuing performance issues inside the Guest VM that is
> created inside the btrfs subvolume, using a qcow2 format. I'm having a
> hard time determining whether the issues are related to KVM or btrfs,
> or if this is even a reasonable topic of discussion.
>=20
> I've seen the comments on this list saying that if I want a COW
> filesystem with sparse files, that I'd be better off with ZFS. I'd
> like to use an in-tree COW filesystem, but if it's just not gonna
> happen yet with btrfs, I guess that's just the way it is.
>=20
> That being said, how would I determine what the root issue is?
> Specifically, the qcow2 file in question seems to have increasing
> fragmentation, even with the No_COW attr.

First of all, why do you require a COW filesystem in the first place... if =
all
you do is just use it in a NoCOW mode?

Second, why qcow2? It can also have internal fragmentation which is unlikel=
y to
do anything good for performance.

Try RAW format images; to reduce the space requirements, with the latest
Qemu/KVM you can pass-through TRIM command from inside the VM guest (at lea=
st
in the IDE controller mode) so that the backing filesystem will unmap areas
that are no longer in use inside the VM, in effect "re-sparsifying" the ima=
ge.
This is VERY nifty. But yeah this can cause some fragmentation even with No=
COW.

In my personal use case NoCOW is only utilized partly, because all subvolum=
es
with running VMs are being snapshotted about every 30 minutes, and those
snapshots are kept for two weeks. The performance is passable; at least when
using KVM's "cache=3Dwriteback" mode (or less safer ones).

--=20
With respect,
Roman

--Sig_/NqqeJN9t1VkhLIgMdoc.jOa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPpFfkACgkQTLKSvz+PZwgfDgCgg9lvMvZWrClhyMfzeaOX+IfP
VG8AoIeew/iUWLPLdxpBuS9lQO6Em1Nh
=Eneo
-----END PGP SIGNATURE-----

--Sig_/NqqeJN9t1VkhLIgMdoc.jOa--
