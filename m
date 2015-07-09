Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa65.mailout.artfiles.de ([212.72.176.65]:55638 "EHLO
	mailout-afa65.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbbGIVzM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 17:55:12 -0400
Received: from [47.69.40.123] (helo=discus.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1ZDJSs-0006EV-0u
	for linux-btrfs@vger.kernel.org; Thu, 09 Jul 2015 23:34:42 +0200
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: linux-btrfs@vger.kernel.org
Subject: Concurrent write access
Date: Thu, 09 Jul 2015 23:34:40 +0200
Message-ID: <2035607.hrq9oNetle@discus>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4314683.4xueFkaVQx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4314683.4xueFkaVQx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I have a btrfs raid10 which is connected to a server hosting multiple virtual 
machine. Does btrfs support connecting the same subvolumes of the same raid to 
multiple virtual machines for concurrent read and write? The situation would 
be the same as, say, mounting user homes from the same nfs share on different 
machines.


Thanks,
Wolfgang
--nextPart4314683.4xueFkaVQx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVnujwAAoJEGZtonfLCdqh1x8P/2ZQouqYTFmBj6J0BZK240Zd
QihNAVOVYy08rMt4Ms3217tjVPHnFXY/UoYO2iGx7c+rqe3gOSmEvelc+BJAmOkb
y+RymOsuAl84WOmIJghJZ+e62mPaAqCHcFPSvrmjKPPEvufkMgRGfudaQgmtDT1F
UChwXySCcH5/renOAbmBr4rOnoVTr6RzgcLt6ib3fHKRTXiPkdjE2JGGDyU/Zv0x
dBR3125n/J13zO/VCGJxIPQxDDdA5MO4AriXMh9jjoMDkFPvbQhDw9JmpHP+2rzo
IX5fDFwzOi38nRgqYnTU34+L6lL2su4GQIEJBJtDKvyCOJmUZ0G5GIvU5kf60dxB
/myCuScCZ89XnahKzX1NBuQogxYLyAnPWKXU6vo9CM1xQ3KbNZAOAUSINg+Un8ah
8FPKGEGuVR1+RFLluQJgpRYqNtVdh9kXNoRFSig5F9PyjQqGJ8YMsevLZCKUiBi1
p7ZauaXSKs0Uh8mupz5dt6OUQi3ZR1bEwrj0+c/+ENb63JNva9OZCslQRUxko/Ts
JgB6kbU+PoIpsphX/Hx9UnnB77A3rDMWx2N389E62mYTRCMrRcKBNAcQAV+BH7at
fmP1HQX/xKhqdqjU6uDSNM7F3fFAK/l5xQ/7oRNsyXjChWimMWoiw+60SjbiUjiT
L52MqWKUXfPjDQUg85Kt
=FtSR
-----END PGP SIGNATURE-----

--nextPart4314683.4xueFkaVQx--

