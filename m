From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Re: immutable (WORM) file system
Date: Wed, 14 Mar 2012 11:58:46 +0000
Message-ID: <9F3580FC-CAAB-4DDA-97BF-5A081E27BCCE@gmail.com>
References: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com> <20120312234039.GA13695@twin.jikos.cz> <201203131117.16977.chris@csamuel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-19--915675407"
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203131117.16977.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-19--915675407
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

I'm sure the OP's idea was to allow one to write onto the FS, and have =
Btrfs dealing with the internal requirements of not allowing further =
modifications on what exists on the FS. Transparently and without any =
user-level intervention.

The thing is that, the complexity will always depend on the wanted =
semantics. If one wants to simply allow 'new files', I believe it should =
be rather easy to implements, but that leads me to questioning "why =
Btrfs?".

OTH, if one does want to allow appending onto a file, but making sure =
new appends (e.g., those between open() and close()) create a new =
version of the said file, then Btrfs could work for that: append, set =
new extents RO, snapshot. Although this may not be as simple, it sure =
looks quite interesting :-)

I guess I'll be on the lookout for further developments on this thread! =
(if any)

Cheers,
Joao


On Mar 13, 2012, at 12:17 AM, Chris Samuel wrote:

> On Tuesday 13 March 2012 10:40:39 David Sterba wrote:
>=20
>> (I just know that the flag is there and is related to the question,
>> haven't tested it myself and do not know what was the original
>> intention.)
>=20
> Not sure it helps, but the commits for these were:
>=20
> commit fdebe2bd70047e057827cba85ba31b2545e31900
> Author: Yan <yanzheng@21cn.com>
> Date:   Mon Jan 14 13:26:08 2008 -0500
>=20
>    Btrfs: Add readonly inode flag
>=20
>    This patch adds readonly inode flag support.  A file with this flag
>    can't be modified, but can be deleted.
>=20
>    Signed-off-by: Chris Mason <chris.mason@oracle.com>
>=20
> and..
>=20
> commit cb6db4e57632ba8589cc2f9fe1d0aa9116b87ab8
> Author: Jeff Mahoney <jeffm@suse.de>
> Date:   Mon Aug 15 17:27:21 2011 +0000
> Author: Jeff Mahoney <jeffm@suse.de>
> Date:   Mon Aug 15 17:27:21 2011 +0000
>=20
>    btrfs: btrfs_permission's RO check shouldn't apply to device nodes
>=20
>    This patch tightens the read-only access checks in btrfs_permission =
to
>     match the constraints in inode_permission. Currently, even though =
the
>     device node itself will be unmodified, read-write access to device =
nodes
>     is denied to when the device node resides on a read-only subvolume =
or a
>     is a file that has been marked read-only by the btrfs conversion =
utility.
>=20
>     With this patch applied, the check only affects regular files,
>     directories, and symlinks. It also restructures the code a bit so =
that
>     we don't duplicate the MAY_WRITE check for both tests.
>=20
>    Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>    Signed-off-by: Chris Mason <chris.mason@oracle.com>
>=20
> --=20
> Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
>=20
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-19--915675407
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJPYIf7AAoJEJ9vvxhHfCblX2EH/0l3LvAiijaEdI8c5kdzeYnA
bNOhbzgC/nT2xXQWgQo2zDlGBgB96T6QT/QyLO8nfbLA5jAXBgg2SBUHK5cXvoR/
I+QqST2j/UmyHWYPzQUDif2oDxi4zDlzr5Aq8hyKbnsoU/X5PZn3exNAdAR3TciD
tH+2Eu9eCGqdYQpM8+ZOKDbu+X2bqnfIrVY8dptk2Zf6GyK9Y/etxBiDnMhmOSBc
V/Zagvs2lpzIGUlHFlsfZ9HyxeIiJxjYmIdM+f4AZo8h8gUNn653xvyzp3tdBAre
rByaiMod4Rx9daAO4XS094iuW3WBN6Q/wNnuftklqRITKkI1s93pYRZy5gXbc6Y=
=cmBu
-----END PGP SIGNATURE-----

--Apple-Mail-19--915675407--
