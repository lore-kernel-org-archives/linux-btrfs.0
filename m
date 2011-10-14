From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Fri, 14 Oct 2011 18:26:15 +0100
Message-ID: <1318613175.2300.8.camel@picard>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
	 <20111013162104.GG21931@carfax.org.uk>
	 <CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com>
	 <CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
	 <4E9743A8.1050806@electric-spoon.com>
	 <CAJ1PRS=d4Ly3p-t1L9-wXcaHA=zw05Lu=84+=AnF+77HJJLvfg@mail.gmail.com>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-G7Wnrq8DUkl/Qqn+lsyG"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=d4Ly3p-t1L9-wXcaHA=zw05Lu=84+=AnF+77HJJLvfg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-G7Wnrq8DUkl/Qqn+lsyG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-10-13 at 23:03 +0200, krzf83@gmail.com wrote:
>=20
> > If you delete a large number of files, then there is no avoiding the
> > fact that a lot of metadata needs to be updated. In this respect
> btrfs
> > is unlikely to be significantly faster than any other filing system.
>=20
> Are you sure? That would mean that instant deletion of subvolume in
> btrfs is actualy taking ??SAME?? time and io power in BACKGROUND like
> deleting by rm -rf in any filesystem.
> Common misconception would be that subvolume deletion is much more
> efficient and near zero time consuming. I think it is very important
> to clear that up.=20

I may be wrong but it may not be necessary true - the fs may optimize
the deletion so for example if 2 files shares the same extend it is
updated once (it may be beneficial as cost of I/O is bigger then cost of
CPU).

Additionally it means that the btrfs does things asynchronously and we
don't need to wait for all cleanup (I assume that it is as soon as the
deletion is commited to log). Therefore if deletion takes 100 ms of i/o
and 10 ms of cpu on other fs and 100 ms of i/o and 20 ms of cpu on btrfs
the following code takes 210 ms vs. 120 ms on btrfs in very simplified
model.

unlink("/btrfs/file");
busy_wait(100); // Simulates 100 ms computation

Regards

PS. I'm not btrfs developer but I see at least potential advantages of
asynchronous deletion (or split deletion in 2-phases). I don't know how
much is implemented.

--=-G7Wnrq8DUkl/Qqn+lsyG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOmHC7AAoJEJIdee2Vr4aPnT8QAKNvewilDq9cJGBtUFrs1Yen
B3JUVIWq7yZlFTpp1xuq2XE6fI5Nu/VezBm9a8PWzuGIINJk2NJD/g/ALNB2OZe3
RsKd6ZCy6/Bm3n2bDcBnSvWUyRhYnkKHNu+RlzzlzpK6jAiMHyepTLusSmegnOLt
QMHdHsVPs67b0v7hNKdXu672fGYMjDClsnC6X5FqHZH+rMZQXRnE9N7qvUQgaIaK
MOJdE473V8REpXuriIpo/gr9LS9g7uZRRQqzO2iZjDf0CeBPRQq0kwfdY1x/xPMA
mWQ6XlFbV/e9h5oene2hg7IEimoNbfygsgg93jVidFPkjo2TJ5PnpR8kDG56s6qr
PnfT/XbNqO/mNLGbbsKy+eYB53GunfCCjkbNwikz9zHOwYfIxgmk30ITuBywrfKD
Ex5o4uzRUUEsfpFmZH18gOpY9UDHgU+E5+35tP2/jusM7g8JEFRJZvcMGQ8sMWoR
9U4EpM34vaqykEd+oPtzbib93LHGjKVvw2binIbYhJHyMW9zNfnev+rNk6qxpgJ8
Ko0VRU0KXzqfargXFwREfTRecuOp8+VeZBnEUQUq+Mp7Cl2inuDir0waZDWBL/bp
hdQCoJmIZlXG8ShFLOx1S/1B735hPqh54Oz4lHfEt0N2L0nPOfRK9ZvsxB2pI2Qz
gmjpZpncBKjr5bqDWzxT
=HtsU
-----END PGP SIGNATURE-----

--=-G7Wnrq8DUkl/Qqn+lsyG--


