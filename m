From: Daniel Poelzleithner <poelzi@poelzi.org>
Subject: Re: flush-btrfs-1 hangs when building openwrt
Date: Tue, 25 Jan 2011 22:16:33 +0100
Message-ID: <4D3F3DB1.8040803@poelzi.org>
References: <4D3E8EF5.1050008@poelzi.org> <20110125153055.GA2598@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E72E86742AFA77A6FFDDB22"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110125153055.GA2598@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E72E86742AFA77A6FFDDB22
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2011 04:30 PM, Josef Bacik wrote:

> How about sysrq+w when it's hanging. =20

Shows nothing.

> Also could you give the exact steps to
> reproduce?  I went to the openwrt site to try and build, but it seems l=
ike
> theres alot of moving parts.  If you can just tell me what to download =
and what
> you run to reproduce I can try and reproduce locally.  Thanks,

mkdir /btrfs/with/lots/of/space
cd /btrfs/with/lots/of/space
git clone git://nbd.name/openwrt.git
cd openwrt
wget
https://gist.github.com/raw/794593/b9e7e7b6dce71093a653953d7e39c94a6ffa45=
28/gistfile1.txt
-O .config

make
# take a nap, will take quite some time on the first run
If you prefere seeing output, which slows things down do

make V=3D99

instead. I skipped the packages repo here, because I don't think it will
make a difference. It hanges in the final steps of creating the image.

kind regards
 Daniel


--------------enig8E72E86742AFA77A6FFDDB22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNPz22AAoJEFYpgV2Roepc310QAJuYFqNmqScKB8CU+q2HjWje
DkMtSnJBBoPB9JSfsp3ZP1oNO57xBiCNidDZuut0ce9RN1WiBsBAJYNO0OM6Tv/8
Sm+8r1LfwPD2j+o2fGez6K/BrJgHn9GDTbDzq3N/o7JQH78YJkd6lBYE2pqKh9VT
T3QcuLH/xDViRsk37aLAal8V9L6k/KmbIjoVPtmqPpjUBwL+mMsbEfrWC1BrePYp
MOTiBQ8+pbT1HoaXket1W8Ukq7UJkjsPCtPkl2QFWIPlK2EiJfIdiReQsxTldGOv
nG9LoL6R0rYujAVzyEwNMv/q5iDF1i8LNULk45UFY0mpB0yzgtKtG0HYHzy8TiMO
nY8f7YHHIDeqd6t7qn82dcUmQpZOa7bAi6t5xVyGWheb7Lr40ymg+rR1rQpRd2TT
XbqO/qqkmYqnGGmtK3NQjcLgedR2c7tlBDsAkddVYwXpDxe3lYIbsC4rslcg0IYC
3jlCqv9R3IZjNi0ucHU4tfirS+UW+mS+hwiL9uQVGifZUL7SPykHpZZ6XduyStuL
dZ6ERFdPkNLEHEAvfVcwqfM1pou9yecsLp/ToPaiN+z0xPcBPDKIx8Pu8V4JSzCD
J4Q+rAddlHwszUFa5V1yQMRTW8Q6Lditc8w82mJk1VCFqFAIp7h7vStGYdWv8nth
yqBw7Fc3fMl2NVu3otFO
=aaHO
-----END PGP SIGNATURE-----

--------------enig8E72E86742AFA77A6FFDDB22--
