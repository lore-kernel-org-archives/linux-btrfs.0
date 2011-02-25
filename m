From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Re: Comparing snapshots?
Date: Fri, 25 Feb 2011 19:32:23 +0000
Message-ID: <6D8C263D-FCFC-49EE-AC28-8D821C3340CA@gmail.com>
References: <20110225095916.GA7609@suse.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-255-380079958"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110225095916.GA7609@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-255-380079958
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

Hello,

Please note that my experience with btrfs is both recent and, above all, =
very small. However, I've been wondering about the same issue for a =
different purpose and your question intrigues me.

However, and I may be off-base here, I think that wouldn't be trivial to =
achieve.=20

Even if one would be able to differ the metadata changes between both =
snapshots, the problem would still be present regarding finding the =
changed data. It would be possible to check for changed extents, at =
least by comparing extent checksums, but I don't think it would be =
trivial to discover where (exactly) the extent was modified.

I would recommend using the generation fields, whenever applicable, but =
I believe these are private to each subvolume/snapshot.


Anyway, I wonder if keeping a data structure (I would go with a tree) =
containing metadata regarding the changed files, within the file system, =
could be a plausible solution, but I'm in no condition =
(btrfs-knowledge-wise) to make such statement.


Cheers.

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20





On Feb 25, 2011, at 9:59 AM, Arvin Schnell wrote:

> Hi,
>=20
> for a backup program I have to find all differing files
> (including metadata) in two snapshots taken from the same
> subvolume.
>=20
> Having looked at the find-new command I thought about this
> process:
>=20
> 1. Get the two transids when the two snapshots were created.
>=20
> 2. Query modifications to the original subvolume between the two
>   transids.
>=20
> Is the general process corrent or have I overseen something?
>=20
> AFAIS the btrfs tool does not provide the required
> information/commands. Would it be possible to add those?
>=20
> Thanks in advance,
>  Arvin
>=20
> --=20
> Arvin Schnell, <aschnell@suse.de>
> Senior Software Engineer, Research & Development
> SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail-255-380079958
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJNaAPNAAoJEJ9vvxhHfCblIuAH/24aObhz6cVy1u9UnCqH9nBN
655v/C9RwdwO11N9ZXF7BzeMGHOhf6kXwwHwqXDaSc6MpIU+aB7f4nBc7ExsOUFu
3/LaePrPxaL/ruaLqNsG2sXEC/ncQboq3rMtnPgZJB5YVmIglVAhlB/EdZmDxY8C
vHuzqysqs7ybDr/khxkioDMCxqEqCcZdjCdTWqspgoXFXgZSDk3zUAjEMLS5Tkw9
IrsgLbVvvRu91aF/Upz5Xy4+vXNjmcYg5AP+IwfahYpHp3KfQS4Peq7U22eauXoD
jdi21lT/tqxAks+LaGhDLsj3zD0xFSCZzLyv5L0Q8knSLFaw+3MHvqtCG1fRADA=
=V3Mw
-----END PGP SIGNATURE-----

--Apple-Mail-255-380079958--
