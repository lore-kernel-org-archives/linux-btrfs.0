From: Chris Samuel <chris@csamuel.org>
Subject: Re: multiple device usage
Date: Mon, 29 Dec 2008 22:32:05 +1100
Message-ID: <200812292232.08037.chris@csamuel.org>
References: <556243856@web.de> <200812271745.45860.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3619674.p0qQbBbAGG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200812271745.45860.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3619674.p0qQbBbAGG
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 27 Dec 2008 5:45:42 pm Chris Samuel wrote:

> I'll add two questions that're not answered by the Wiki too.. :-)

Looking at the source implies to me:

> 1) If you add a second disk to an existing btrfs filesystem, can you get =
it
> to set it up as a RAID-1 arrangement rather than just rebalancing the
> metadata and then striping ?

No, you can't, the data stripe numbers seem to be set at mkfs time.

The rebalancing code does appear (from a naive read of the code) to be able=
 to=20
rebalance over stripes, but I have no idea if the disk format currently=20
supports changing that on the fly.

> 2) With the concerns that people have about SSD reliability (hi Val :-) !)
> would it make sense to set up two equal sized partitions on the SSD and u=
se
> RAID-1 across them, or can you tell btrfs to keep multiple copies of the
> data, a la ZFS ?

Again it would appear that you need to have two partitions and that btrfs=20
cannot (at present) keep multiple data stripes on the same partition.

Could someone who actually knows the code to comment on whether my inferenc=
es=20
are accurate or not please ?  :-)

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart3619674.p0qQbBbAGG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVi1OI1yjaOTJg85AQL8WQf/WazkAo5RHlU/+LC04XCL7bcL0Bfw2VBN
N5ECqmMzZ7iqRQn+J1XUVqEzKM9IHLf6xav0i1JWdGFKb6SA456UYnNJGf1b2ruy
tiT+KH0w7BnJS1WiocLPTwvVUOXBRsM6LbQ19w5U+PxhoJKJLA+4eCesao5aA6DR
N38T0M9tjRSKXOGFYrx9aIlgvunmNfvr+Cw7hRWxRCQRGtz3c7QyI4F5PY2ueUgS
Mly3uG3gtxfeZoVc37RvEbGGf5X+3Lynzfk/nGrIFZG7kOkMGB5m7LSeIh6tnTso
WxV7uTydRQuDa2y+J1mJOm33LYhS/ciy854qr9akH6bbU8eyWC7e0g==
=ADSb
-----END PGP SIGNATURE-----

--nextPart3619674.p0qQbBbAGG--
