From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Re: Snapshot reconciliation
Date: Tue, 28 Jun 2011 18:55:41 +0100
Message-ID: <C1956DA1-A928-40BC-B01F-5798E4C55E96@gmail.com>
References: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com> <BANLkTikgueaxBXMhK1T4dKwMhLTsGn8Mag@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-2-264060145"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@xtfx.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikgueaxBXMhK1T4dKwMhLTsGn8Mag@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-2-264060145
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

On Jun 28, 2011, at 4:07 PM, C Anthony Risinger wrote:

> 2011/6/28 Jo=E3o Eduardo Lu=EDs <jecluis@gmail.com>:
>> Hello.
>>=20
>> Can anyone think of a simple way to copy a set of pages from a given =
file (which may or may not be scattered throughout multiple extents) =
from a snapshot to correct pages within another file on another =
snapshot?
>>=20
>> This might sound silly, but the whole purpose is to create some sort =
of reconciliation method between divergent snapshots taken from the same =
original subvolume.
>=20
> generic deduplication?
>=20

I'm not sure if deduplication is what I'm looking for.

What I actually want to achieve is to reconstruct a file's data from two =
diverging files. I.e., two snapshots are taken from the same subvolume =
and, in each snapshot, a given file A is written to. Assuming different =
blocks were written on, and no expected semantics are violated, what I =
aim to achieve is the correct reconciliation of file A in one of the =
snapshots.

Maybe this could be achieved by using deduplication. I'll look into =
those patches. Even if they are not completely useful, they very well =
contain some neat concept that may be used to solve this little puzzle =
of mine. :-)

Thanks.

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-2-264060145
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJOChWjAAoJEJ9vvxhHfCblGEsH/2z52hNs/W4A8x0p2D4rzukb
omD5ASR8E6lkFI/Yk2yTGwEpgdI0Nz6dyMBaAiBVYRiMKxZtqdh2TDYxqp42g4L9
pUGoxR2bev6Gkhp/zd025T/JZUwkPzKABJmbhJxSxA6H92rQq3nRCBPn8bpderBm
PN5QgvBBZ1alV2i8BcBvytHAPdA/75zkpP6U0qH1xIV/KfBlnS7BmDolMoN8tn7g
dFnkbFM/8UJjwdN1nbd0wYBd7rjiLMCMBSmsjk3aTo7Ltuzo0pYN0RUYChO96Ogo
x2tMyu3W79nyUR9KB6OqakKLyUnb/6HEoOWhFdHdjDB3Q9m5bZ6twGXMqAt6y3M=
=ZYoB
-----END PGP SIGNATURE-----

--Apple-Mail-2-264060145--
