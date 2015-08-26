Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:46433 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbbHZLu3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 07:50:29 -0400
Date: Wed, 26 Aug 2015 16:50:24 +0500
From: Roman Mamedov <rm@romanrm.net>
To: George Duffield <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Understanding BTRFS storage
Message-ID: <20150826165024.05af044f@natsu>
In-Reply-To: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H=KSd+EtaHwz_5ISj.BLvD3"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/H=KSd+EtaHwz_5ISj.BLvD3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Aug 2015 10:56:03 +0200
George Duffield <forumscollective@gmail.com> wrote:

> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
> solution that will involve duplicating a data store on a second
> machine for backup purposes (the machine is only powered up for
> backups).

What do you want to achieve by switching? As Btrfs RAID5/6 is not safe yet,=
 do
you also plan to migrate to RAID10, losing in storage efficiency?

Why not use Btrfs in single-device mode on top of your mdadm RAID5/6? Can e=
ven
migrate without moving any data if you currently use Ext4, as it can be
converted to Btrfs in-place.

--=20
With respect,
Roman

--Sig_/H=KSd+EtaHwz_5ISj.BLvD3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlXdqAAACgkQTLKSvz+PZwiY9wCcCMu57M/UB8aYETk0nwym7c7L
F3AAmwaeXafytTtMMbFlb5C7RJkNIgeu
=NIL2
-----END PGP SIGNATURE-----

--Sig_/H=KSd+EtaHwz_5ISj.BLvD3--
