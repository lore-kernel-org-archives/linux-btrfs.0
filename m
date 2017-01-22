Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.somenet.org ([213.143.98.34]:37174 "EHLO mail.somenet.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdAVVvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Jan 2017 16:51:33 -0500
To: linux-btrfs@vger.kernel.org
From: Jan Vales <jan@jvales.net>
Subject: RAID56 status?
Message-ID: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
Date: Sun, 22 Jan 2017 22:22:11 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F586R2Swkw29HsSQOfVTUhD9IUHjPmOAM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F586R2Swkw29HsSQOfVTUhD9IUHjPmOAM
Content-Type: multipart/mixed; boundary="UtJEvwkHLNKlTuBoM2SvFxee5Ax35CfUW";
 protected-headers="v1"
From: Jan Vales <jan@jvales.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
Subject: RAID56 status?

--UtJEvwkHLNKlTuBoM2SvFxee5Ax35CfUW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi there!

Im using btrfs since like 2.28 on my laptop without too many problems.

Now im thinking of going further and go for btrfs raid6 on my pc.
I dont mind to restore backups once in a while, but it should not be
like on a weekly basis.

Therefore my question: whats the status of raid5/6 is in btrfs?
Is it somehow "production"-ready by now?

As in: if used on / on my pc ... do you expect it to brick itself, if
the fs fills up, or a power cycle happens, or some other somehow common
error-case to a point where i will need to restore backups?

regards,
Jan Vales
--
I only read plaintext emails.

Someone @ irc://irc.fsinf.at:6667/tuwien
webIRC: https://frost.fsinf.at/iris/


--UtJEvwkHLNKlTuBoM2SvFxee5Ax35CfUW--

--F586R2Swkw29HsSQOfVTUhD9IUHjPmOAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYhSKGAAoJEERD22thjA7qqjYQAMtX4LVOMlGjJ7O6hNWZw3WU
J3Q8h2Z+8bTFLb0e9PeIGeQ1HhHffHbYecBheMxJxX9T9XMGRpAeFfeYeqY0Ap0G
bFhb8uDaBt2308MnfbxFtVmFhB3cuMvF2TO18Q8ovCDK7AvIx6txvwpJwcIr9RHo
h23tZiKjcnmj+bUNkBxhG+BGzfZqXDzkzSoxiwP3AjpddS9DBJNlaAEv4Kc2rl9c
VRNlW23Z2bsdKqyPlLLvHV7dWJA4pBSHYsxBFLlFZdnqL0m9mgmE7Q1ZVkQCerrQ
ehg48aTgOw6q5haJVAY/Mqnp1kmZ8xH2mQR9/slkqqCqabXO1U6RiB2lDzxw/Fdu
KNKDQmCwWryLdJyDFEum0rIlW5xQlhEanl/mArjBojXfb7rXnzng6xZtBvJZAwaC
u/gaoy76J0ebGJEFRrhZ/MuTsFfHl30Iv5Er/42UfrhEMb/d3QAIrsP2G4cyF754
hlaVlQyuHQjDR+XL1P9I3Cr2WCZh+sjrlMFOuCe0xbzErGZWgz0TBDiasJ9pMaxz
mxFHvaV3KnbGWrxfvdlEwx8CHJN5+qCFXUycq5YRPLTUTBcEHcV4j0U/FLCVFSVw
8UMaUTdn240cGUW2dnLpBIIYzKPBrMetBCo8XUaaWjE5ZoiHX7eszBFHVyvHVHjJ
EjK4fak7Eh44vKoRgf6c
=JaAe
-----END PGP SIGNATURE-----

--F586R2Swkw29HsSQOfVTUhD9IUHjPmOAM--
