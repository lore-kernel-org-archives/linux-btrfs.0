Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35807 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756159AbcIAVDM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 17:03:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bfXjL-00051K-8l
        for linux-btrfs@vger.kernel.org; Thu, 01 Sep 2016 21:32:55 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re:
Date: Thu, 1 Sep 2016 21:32:37 +0200
Message-ID: <20160901213237.4f46ab5c@jupiter.sol.kaishome.de>
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
        <57C79C15.4020508@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wvf.wCTc1shy=FbHRSO3SqG"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/wvf.wCTc1shy=FbHRSO3SqG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Wed, 31 Aug 2016 23:10:13 -0400
schrieb Jeff Mahoney <jeffm@suse.com>:

> On 8/31/16 10:02 PM, Fennec Fox wrote:
> > Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37
> > UTC 2016 x86_64 GNU/Linux
> > btrfs-progs v4.7
> >=20
> > Data, single: total=3D30.01GiB, used=3D18.95GiB
> > System, single: total=3D4.00MiB, used=3D16.00KiB
> > Metadata, single: total=3D1.01GiB, used=3D422.17MiB
> > GlobalReserve, single: total=3D144.00MiB, used=3D0.00B
> >=20
> > {02:50} Wed Aug 31
> > [fennectech@Titanium ~]$  sudo fstrim -v /
> > [sudo] password for fennectech:
> > Sorry, try again.
> > [sudo] password for fennectech:
> > /: 99.8 GiB (107167244288 bytes) trimmed
> >=20
> > {03:08} Wed Aug 31
> > [fennectech@Titanium ~]$  sudo fstrim -v /
> > [sudo] password for fennectech:
> > /: 99.9 GiB (107262181376 bytes) trimmed
> >=20
> >   I ran these commands minutes after echother ane each time it is
> > trimming the entire free space
> >=20
> > Anyone else seen this?   the filesystem is the root FS and is
> > compressed=20
>=20
> Yes.  It's working as intended.  We don't track what space has already
> been trimmed anywhere, so it trims all unallocated space.

I wonder, does it work in a multi device scenario? When btrfs pools
multiple devices together?

I ask because fstrim seems to always report the estimated free space,
not the raw free space, as trimmed.

OTOH, this may simply be because btrfs reports 1.08 TiB unallocated
while fstrim reports 1.2 TB trimmed (and not TiB) - which when
"converted" (1.08 * 1024^4 / 1000^4 ~=3D 1.18) perfectly rounds to 1.2.
Coincidence is free estimated space is 1.19 TiB for me (which would also
round to 1.2) and these numbers, as they are in the TB range, won't
change so fast for me.


--=20
Regards,
Kai

Replies to list-only preferred.

--Sig_/wvf.wCTc1shy=FbHRSO3SqG
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfIglYACgkQ+D7cQ/kIzAWUGQCggJ6dwkM+4hvkB3zXKdDGohVS
OAIAn15scDuE0YIfAGNR9K3rQP2byRdH
=TtRW
-----END PGP SIGNATURE-----

--Sig_/wvf.wCTc1shy=FbHRSO3SqG--


