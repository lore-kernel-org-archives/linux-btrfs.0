Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-88-32.dynamic.qsc.de ([92.195.88.32]:48849 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbCHPnX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Mar 2015 11:43:23 -0400
Received: from [192.168.178.21] (unknown [92.195.88.32])
	by richtercloud.de (Postfix) with ESMTPSA id 0ED298286B
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Mar 2015 15:34:25 +0000 (UTC)
Message-ID: <54FC6BFC.8090505@richtercloud.de>
Date: Sun, 08 Mar 2015 16:34:20 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Explain the precedence of btrfs properties over mount options
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="G0CAr9011KUO5vxCXr7fCIwHQiJceLMGe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G0CAr9011KUO5vxCXr7fCIwHQiJceLMGe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
The manpage of `btrfs property` would be a good place to explain the
precedence of properties over mount options, e.g. what happens when the
mount option `compress` is set to `zlib` and the property for same
subvolume is set to `""` (indicating no compression as you know)? What
happens when `compress-force` mount option is specified which doesn't
have an equivalent in properties?

Best regards,
Kalle


--G0CAr9011KUO5vxCXr7fCIwHQiJceLMGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJU/Gv8AAoJEGadKJ8eJ7ZG4zMH/iyEMEayODyD+9FUAybiztFF
zkuNAAQ1KRkxR5DSHb6glnDPDIiOeYb6IIGP83TfMd1rCadJZGX/BtkgbqZUp0li
4LLWc8ypeS4p5oCHHL/RtsRoVX80GhSUrtIW48+XnO+epPUu1LnaqvhmKExqm06f
qaQZ7SXLWq50biKCvsRABF/JAHywQDEh155w/vEa/IiroFPzF71YOaqNRIrKrLs4
NKLmP622oL7wH2NLjBreJSgrODMOzxR9ALWxyXo5bH8K8xNc0BJixEdW08Xc8Mjh
r1lw99nnmRtr0tUJlWDVeiLUbqLcncF6hcUQz4UgcAZfbN9rbGY9a2ZpsnE2B9k=
=GKmE
-----END PGP SIGNATURE-----

--G0CAr9011KUO5vxCXr7fCIwHQiJceLMGe--
