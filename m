Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from untroubled.org ([69.5.1.51]:56954 "HELO untroubled.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S940706AbdAFWn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Jan 2017 17:43:27 -0500
Date: Fri, 6 Jan 2017 16:43:06 -0600
From: Bruce Guenter <bruce@untroubled.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume delete --commit-after doesn't wait for deletions
Message-ID: <20170106224306.GA8756@untroubled.org>
References: <20170105014656.GA19542@untroubled.org>
 <495af306-19bc-6af1-4411-e2eefe143891@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
In-Reply-To: <495af306-19bc-6af1-4411-e2eefe143891@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 05, 2017 at 10:03:17AM +0800, Qu Wenruo wrote:
> To wait the deletion finish, please use "btrfs filesystem sync".

That doesn't entirely work either. It does appear to wait for something,
but disk space available continues to increase after it exits.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYcB15AAoJEFFRvcnBTTxnpkIQAIiEieP/EQjf+Ak+fJhvR+Id
Gdr2uRsOnx6lkNHNCVh7at2G4je54A1IX8557GhDR3/8uOXZ09cWm8Qk0MNfMjU4
O1VL2fhgss3X8e949jklufbYYc/G8gjvDW5OLSdw0Ohexs0ufxYuYQkET+kGTrbR
swWVXo7yUzwhyzUe48GeA34gy0HONPkjEotA+807NdD1kiAYlt2+DUPEIC3dABKI
BoKY/iucF9x5eCps1KhZdClZ87719e4otUy3n1RbBi/p5E/cMVdGPJRllycffh/K
8C59AWSaTi/l+Qv/sllaj0Kpmz/g3GK23DxW4SsQM3J9AcQ2qJErpkZtlM7jgHL0
v0OpLS+Kzpgd/Nv5WGL28Pcr67FUBudhp176gy0inH3JdAiNpzq0WX0Ls8tzLdU+
8v1iyy36GYy9KJA+y4aO+6qdedEewuK7XNYjBBuenyBbr4/EtCphNjYUuPRCijnq
ERwrbtsYBMNIZXoiZjdT2LjPSuBv1sn74vJJh4K4qstEo7sDpMNKKiHTGwi5AwYJ
UK9Tu+2fg0MS/UHAoeTG7xUb294ZyA0gPcbowOVbyvOLt7A8TNphIIdKaY3PYTcx
vz3vZQwEoxsBpIF/UZe56W0DwPm5OQ5PA0YAugfxXwKFFb89qRn2MpRbEG0boLxL
UgP6qyuEoOl/sAoZtHqd
=Kl1f
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
