Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:37455 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbcATSql (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 13:46:41 -0500
Date: Wed, 20 Jan 2016 23:46:38 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
Message-ID: <20160120234638.39695c15@natsu>
In-Reply-To: <569FC3C1.2000804@redhat.com>
References: <20160120030223.22cc3ae0@natsu>
 <569EB653.9080700@redhat.com>
 <20160120040302.308f054e@natsu>
 <1185704624.11958670.1453278484410.JavaMail.zimbra@redhat.com>
 <20160120185810.2c566f98@natsu>
 <569FC3C1.2000804@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DITwwXDIBfyrRFXqPM62JrP"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/DITwwXDIBfyrRFXqPM62JrP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jan 2016 18:28:33 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> >> Also, can you find the value of the "FUA" file in sysfs (e.g.
> >> with "cat /sys/block/sda/device/scsi_disk/*/FUA")?
> >=20
> > It is 0 both in IDE and SCSI modes.
>=20
> And in the host?

On the host the backing block device for the host filesystem is an MD RAID6=
, it
does not have the FUA setting. For the actual sdX disks, it's all 0 as well.

As I said this might be not KVM-specific, but rather a Btrfs-only related
issue. That KVM with IDE doesn't show the problem, might be a coincidence s=
ince
as you mentioned it doesn't load the disks as heavily.

If you're interested in my reproducer outside of KVM, I started a new threa=
d:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/52369

--=20
With respect,
Roman

--Sig_/DITwwXDIBfyrRFXqPM62JrP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaf1g4ACgkQTLKSvz+PZwicHwCeNmklGrC5qVrUDJibP0prakVN
T0YAn0T6lRdCjCcFy0WSHCiVWTcyr0I0
=W2Ep
-----END PGP SIGNATURE-----

--Sig_/DITwwXDIBfyrRFXqPM62JrP--
