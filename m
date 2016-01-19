Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:40871 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbcASXDJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 18:03:09 -0500
Date: Wed, 20 Jan 2016 04:03:02 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120040302.308f054e@natsu>
In-Reply-To: <569EB653.9080700@redhat.com>
References: <20160120030223.22cc3ae0@natsu>
	<569EB653.9080700@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nENwCuKKhzYVi.SkW5VIFZT"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/nENwCuKKhzYVi.SkW5VIFZT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 19 Jan 2016 23:18:59 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> So this is kernel 4.4 on the host, and virtio-scsi in the guest.  What
> about virtio-blk in the guest?

Tried with:

  -device virtio-blk-pci,drive=3Dhd,scsi=3Doff

it locks up as well.

In fact turns out it's not 100% lock-up, more like 50-80% chance.

But it certainly happens if I trigger heavy disk activity in the guest:

  while true; do dd if=3D/dev/zero of=3Dzerofile count=3D1024 bs=3D1M; sync=
; done

...at the same time repeatedly snapshotting the subvolume on the host.

Could not trigger it even once with IDE so far.

> > -drive
> > if=3Dnone,id=3Dhd,cache=3Dwriteback,aio=3Dthreads,format=3Draw,file=3D$=
NAME.img,discard=3Dunmap,detect-zeroes=3Dunmap
> > \
>=20
> So you're snapshotting the subvolume that includes $NAME.img?

Yes


--=20
With respect,
Roman

--Sig_/nENwCuKKhzYVi.SkW5VIFZT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaewKYACgkQTLKSvz+PZwiZKgCffrz2+Na7DWheWjSrt9gWQef1
6NQAnixZXnHB+1QvZ6JnmB+g+XDT6hQz
=qfn8
-----END PGP SIGNATURE-----

--Sig_/nENwCuKKhzYVi.SkW5VIFZT--
