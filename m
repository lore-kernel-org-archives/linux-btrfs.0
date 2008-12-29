From: Chris Samuel <chris@csamuel.org>
Subject: Re: multiple device usage
Date: Mon, 29 Dec 2008 23:52:29 +1100
Message-ID: <200812292352.33059.chris@csamuel.org>
References: <556243856@web.de> <200812292232.08037.chris@csamuel.org> <3d0408630812290433r7f2bb07cue3239c8acf958bb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1324315.X8rPFgaIUn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630812290433r7f2bb07cue3239c8acf958bb3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1324315.X8rPFgaIUn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Yan,

On Mon, 29 Dec 2008 11:33:18 pm Yan Zheng wrote:

> 2008/12/29 Chris Samuel <chris@csamuel.org>:
>
> > The rebalancing code does appear (from a naive read of the code) to be
> > able to rebalance over stripes, but I have no idea if the disk format
> > currently supports changing that on the fly.
>
> The rebalancing moves data/metadata to newly created chunks. If there
> are two devices, the new chunks will be set up as RAID-1 by default.

Very interesting!  I didn't realise that - I was presuming that the=20
BTRFS_BLOCK_GROUP_RAID1 ioctl needed to be passed through (as at mkfs time)=
 to=20
change it into a RAID1 array.

Could you point me at the code where this change is detected please ?   Jus=
t=20
so I can try and wrap my mind around it!

> > Again it would appear that you need to have two partitions and that btr=
fs
> > cannot (at present) keep multiple data stripes on the same partition.
>
> Yes. I think this is due to performance reason.

Understood.

> Changing the code to support data duplication in single spindle configura=
tion
> is easy.

OK, that's encouraging (though for my immediate purposes creating two=20
partitions is fine, but it might make life easier for others).

Again thanks so much for the response!

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart1324315.X8rPFgaIUn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVjIEY1yjaOTJg85AQJtbggAuaeiOn3s/0eMFINgKKNiK9tp7Y9K09kd
B2rKH8Ep2AjmGDQssDOb128dZI16ZeMEx9oZaNcUwf9IbD+41V/NbMqoLRxUV7I0
RX3BQ5yZ7aDfKUMKa0UfJhOvDflBTa7ABnAaBqKoW1QSALGtGsDIRImKCJ4gVXD3
X2NqLvtHbj1XvlzKmDaZDj8XxVdkrwUq4VXgtFTchJ7tDceHFhpudvlWHmwtH/sX
09en4ydQFa+QB0E/l9bnOmwtda8uBmUFqK7LRjwqmhe42dY4cANWR70bdOhnFZLW
V6HpTdaw/SXdNrYgIhNI5EATg432UnZGK3C9il0IHmwBbYs+x8ReFw==
=0bfP
-----END PGP SIGNATURE-----

--nextPart1324315.X8rPFgaIUn--
