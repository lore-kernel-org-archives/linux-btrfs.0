Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:37688 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278AbcASWCd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 17:02:33 -0500
Date: Wed, 20 Jan 2016 03:02:23 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120030223.22cc3ae0@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aomX.ifxo8iYNcor3u+Aza2"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/aomX.ifxo8iYNcor3u+Aza2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I'm facing a strange issue:

Starting with the kernel 4.4.0, a KVM guest stored on a Btrfs filesystem,
if it's using the "virtio-scsi" disk backend, will hard lock-up instantly,
as soon as the Btrfs subvolume which contains its backing file is snapshott=
ed.

There's nothing in dmesg neither on the guest, nor on the host;
the KVM process can be killed from the host just fine and then restarted,
so it doesn't seem to be a kernel-side deadlock of any sort.

KVM disk controller which exhibits the problem:

 -device virtio-scsi-pci,id=3Dscsi -device scsi-hd,drive=3Dhd \

The alternative which works fine:

 -device ide-hd,drive=3Dhd,bus=3Dide.0 \

The disk device line is common to both cases:

 -drive if=3Dnone,id=3Dhd,cache=3Dwriteback,aio=3Dthreads,format=3Draw,file=
=3D$NAME.img,discard=3Dunmap,detect-zeroes=3Dunmap \

Also tried aio=3Dnative with the problematic variant, no change.

Both variants work fine and unaffected by snapshotting on kernel 3.18.25.

Any ideas?

--=20
With respect,
Roman

--Sig_/aomX.ifxo8iYNcor3u+Aza2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaesm8ACgkQTLKSvz+PZwiiVgCfdspZSMiq+OTWObfrOIgAq/9u
jdYAn0NRvOPDeqFAmNvr1EE6+DOYCFWy
=92+3
-----END PGP SIGNATURE-----

--Sig_/aomX.ifxo8iYNcor3u+Aza2--
