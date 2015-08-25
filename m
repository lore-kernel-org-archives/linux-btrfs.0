Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:43778 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbHYQNX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 12:13:23 -0400
Date: Tue, 25 Aug 2015 21:13:18 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Vincent Olivier" <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Response to Bcachefs Claims
Message-ID: <20150825211318.4599ca6c@natsu>
In-Reply-To: <1440516154.040713246@apps.rackspace.com>
References: <1440516154.040713246@apps.rackspace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_eOOrzUXKkl.2hAG.Cz6z=G"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/_eOOrzUXKkl.2hAG.Cz6z=G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Aug 2015 11:22:34 -0400 (EDT)
"Vincent Olivier" <vincent@up4.com> wrote:

> "UUID=3D" won't work for unknown reasons (haven't got a reply on this, ma=
ybe
> it's the same as "LABEL=3D"). And I will use /dev/* in fstab for stability
> reasons.=20

Take a look at the contents of /dev/disk/by-id/, specifically ata-*
These symlinks are made from HDD model and serial numbers, so can be relied=
 on
to remain stable, no matter in which order your HDDs appear in the system.
Maybe these will come handy for your fstab, I used them a lot and still do,
especially for swap partitions.

--=20
With respect,
Roman

--Sig_/_eOOrzUXKkl.2hAG.Cz6z=G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlXclB4ACgkQTLKSvz+PZwilYwCfZ0Tvrb7HvmXR2E6DhFgm084g
DhUAn0/SUVeUtwH7PdAazMDcV9marajp
=GaoR
-----END PGP SIGNATURE-----

--Sig_/_eOOrzUXKkl.2hAG.Cz6z=G--
