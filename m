Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47561 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933129AbdCKOzL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Mar 2017 09:55:11 -0500
Received: from sam-laptop (unknown [88.97.13.253])
        by mail.messagingengine.com (Postfix) with ESMTPA id C51957E41F
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Mar 2017 09:54:51 -0500 (EST)
Message-ID: <1489244085.6022.8.camel@sent.com>
Subject: btrfs send non-root
From: Sam Bull <sam.hacking@sent.com>
To: linux-btrfs@vger.kernel.org
Date: Sat, 11 Mar 2017 14:54:45 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-1GbKhSPVYYfxr7azJo1I"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-1GbKhSPVYYfxr7azJo1I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm getting an error when trying to send a subvolume. I only seem to be
able to do this as root. The subvolume was created by the user account,
and not root. Could anybody shed some light on why this is failing? Is
there a way to get it working?

$ btrfs send /var/spool/backups/hacking/2017-03-10 > something
ERROR: cannot open '/': Operation not permitted

Also appears I cannot even use btrfs subvolume show:

$ btrfs subvolume show /var/spool/backups/hacking/2017-03-10
ERROR: can't perform the search - Operation not permitted
ERROR: can't find 'var/spool/backups/hacking/2017-03-10'

$ sudo btrfs subvolume show /var/spool/backups/hacking/2017-03-10
/var/spool/backups/hacking/2017-03-10
	Name:=C2=A0			2017-03-10
	UUID:=C2=A0			c3a92646-bd6b-7a4f-ae10-
8bd12e569772
	Parent UUID:=C2=A0		38b66de9-84d3-4848-ae53-
9a2fe861618c
	Received UUID:=C2=A0		-
	Creation time:=C2=A0		2017-03-10 19:11:22 +0000
	Subvolume ID:=C2=A0		564
	Generation:=C2=A0		753377
	Gen at creation:=C2=A0	753377
	Parent ID:=C2=A0		257
	Top level ID:=C2=A0		257
	Flags:=C2=A0			readonly
	Snapshot(s):


$ uname -a
Linux sam-laptop 4.4.0-66-generic #87-Ubuntu SMP Fri Mar 3 15:29:05 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.4
--=-1GbKhSPVYYfxr7azJo1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljED7UACgkQX+kozZYmzivMjwCgzlqIbf4ZrVunKDSrN28ZTNnB
5ZcAoIe+e0SX8HGH7QyfD3Bl2FZcXBem
=MQS2
-----END PGP SIGNATURE-----

--=-1GbKhSPVYYfxr7azJo1I--

