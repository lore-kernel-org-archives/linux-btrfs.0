Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:52090 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbcATN6Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 08:58:16 -0500
Date: Wed, 20 Jan 2016 18:58:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120185810.2c566f98@natsu>
In-Reply-To: <1185704624.11958670.1453278484410.JavaMail.zimbra@redhat.com>
References: <20160120030223.22cc3ae0@natsu>
	<569EB653.9080700@redhat.com>
	<20160120040302.308f054e@natsu>
	<1185704624.11958670.1453278484410.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FV.UX2Fq6t49rfNqAZuBWSo"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/FV.UX2Fq6t49rfNqAZuBWSo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jan 2016 03:28:04 -0500 (EST)
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Can you reproduce it on the host without QEMU in the middle?

I did not try to stress-test this on purpose yet, but this is an actively u=
sed
system which is snapshotting its /home, VMs and root subvolumes every hour,=
 so
far no lock-ups of any other application than KVM, and with KVM it's trivia=
lly
easy to hit, in fact first two lockups occured in the first two hours of us=
ing
the kernel 4.4.0 at the hourly snapshots...

> Also, can you find the value of the "FUA" file in sysfs (e.g. with
> "cat /sys/block/sda/device/scsi_disk/*/FUA")?

It is 0 both in IDE and SCSI modes.

Since you mentioned queue depth, I tried setting this on SCSI:

echo 1 > /sys/block/sda/device/queue_depth

(was 128 by default). Does not solve the issue and doesn't seem to make it =
any
harder to hit.

Couple more details about the locked-up state:

- 0.0% "wa" state in 'top', so there's doesn't seem to be any disk activity

- I can disconnect and then successfully reconnect to the VNC port of the
  locked-up QEMU/KVM process (!), so it looks like it's not entirely dead, =
but
  just the virtualization part(?)

--=20
With respect,
Roman

--Sig_/FV.UX2Fq6t49rfNqAZuBWSo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlafknIACgkQTLKSvz+PZwjJyACaAvZpAe6luaXRR/bxeEvEXaIZ
DV4AniyvqgZDj5vL9BvqJ8x8qFDkft4K
=wiFi
-----END PGP SIGNATURE-----

--Sig_/FV.UX2Fq6t49rfNqAZuBWSo--
