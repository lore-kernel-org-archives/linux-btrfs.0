Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa66.mailout.artfiles.de ([212.72.176.66]:41864 "EHLO
	mailout-afa66.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbcHMP43 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Aug 2016 11:56:29 -0400
Received: from [88.70.41.116] (helo=discus.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1bYb1u-0002ud-KJ
	for linux-btrfs@vger.kernel.org; Sat, 13 Aug 2016 17:39:22 +0200
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Likelihood of read error, recover device failure raid10
Date: Sat, 13 Aug 2016 17:39:18 +0200
Message-ID: <2336793.AMaAIAxWk4@discus>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2053457.9v2q7TCjBG"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2053457.9v2q7TCjBG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I have two questions

1) Layout of raid10 in btrfs
btrfs pools all devices and than stripes and mirrors across this pool. Is it 
therefore correct, that a raid10 layout consisting of 4 devices a,b,c,d is 
_not_

              raid0
       |---------------|
------------      -------------
|a|  |b|      |c|  |d|
   raid1            raid1

Rather, there is no clear distinction of device level between two devices 
which form a raid1 set which are than paired by raid0, but simply, each bit is 
mirrored across two different devices. Is this correct?

2) Recover raid10 from a failed disk
Raid10 inherits its redundancy from the raid1 scheme. If I build a raid10 from 
n devices, each bit is mirrored across two devices. Therefore, in order to 
restore a raid10 from a single failed device, I need to read the amount of 
data worth this device from the remaining n-1 devices. In case, the amount of 
data on the failed disk is in the order of the number of bits for which I can 
expect an unrecoverable read error from a device, I will most likely not be 
able to recover from the disk failure. Is this conclusion correct, or am I am 
missing something here.

Thanks,
Wolfgang
--nextPart2053457.9v2q7TCjBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXrz8mAAoJEGZtonfLCdqhuOkQAJKCPmk52fK8uL+5QAk5p92s
JtVj0hyhbrM4M/YedUkFfAEXhdh8GA7Owr+al9O1FRxjriGham2Lej5JaN/kZ+/s
NJkR1hesUFsfwAL6z3E0ZXNIMH1NP5IUVPsNcv90+dTvrrbv332hScTf6Klc7yc+
blO4LNqwF/k120+Kgm8d2xOolwkc+9kfi+TM+ntGtvcQVGltVjQcjwmeJ2+olpTg
MzwAW6sU73MB76Fo8nFtxygCySz//d/l4ePy61shXUWiQIjaIAG3bmf5y4e84hDh
5tnLinj4wOHSxXliCNMjL5RN94bt6+OwTJK0pmhpSx+5Hf8LUTJKeVxkcmKorYFF
3TOaPuJsp26H/eqF36e5WSnJ6jBKaJGKazWvX42QyFxYuuBqd0qXdeoEloWmTyLa
ebz48IUWMMoT/Vx5XXwfBWkm/V3crOP1ua96QCISp7SB2Xy5IXR9Ju7NEx5/npIx
+vNSevrbPdTCMaf0OYyd/h1oVGsPuMSmHRbgN1BxYFvfHr6G3fjH77iRw3iIUA+y
dY+q1MDG/xPpKo/OCNO8t+Hss8DeXQ7j/N2UWHSdLorS6/VOdRrNKfH7/IiL+I73
B10KoFmWSniJxRGb901ND6YGFxb/qViZISfm+L7CMZqZXhC/9WZ0hyxotRRMvpsz
DXTdqyULQZ4IpSqevhON
=8FdV
-----END PGP SIGNATURE-----

--nextPart2053457.9v2q7TCjBG--

