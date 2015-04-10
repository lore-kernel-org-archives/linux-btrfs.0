Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbbDJAmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 20:42:32 -0400
Date: Fri, 10 Apr 2015 10:42:21 +1000
From: NeilBrown <neilb@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>, linux-btrfs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
Message-ID: <20150410104221.0d156c74@notabene.brown>
In-Reply-To: <20150409235234.GJ13731@dastard>
References: <20150409174916.5a2efef5@notabene.brown>
	<29536.1428571388@warthog.procyon.org.uk>
	<20150409235234.GJ13731@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//sIrGayHR=+4EOFiBJkYHL="; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//sIrGayHR=+4EOFiBJkYHL=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2015 09:52:34 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Apr 09, 2015 at 10:23:08AM +0100, David Howells wrote:
> > NeilBrown <neilb@suse.de> wrote:
> >=20
> > >  Is there a better way?  Could a better way be created?  Maybe
> > >  SEEK_DATA_RELIABLE ??
> >=20
> > fiemap() maybe?
>=20
> fiemap is not reliable for mapping holes - it returns extent info,
> not whether there is data in a range. i.e. there can be data over a
> hole (e.g. delayed allocation) and fiemap will return it as a hole.
> cp made this mistake back when fiemap was first introduced,
> resulting in corrupt file copies.

I assumed from the doco that FIEMAP_EXTENT_DELALLOC would get returned in
this case.  I guess not?

>=20
> SEEK_HOLE/SEEK_DATA is what you want, as they are page cache
> coherent, not extent based operations. And, really if you need it to
> really be able to find real holes, then a superblock flag might be a
> better way of marking filesystems with the required capability.

btrfs seems to use the same underlying functionality for both fiemap and
SEEK_HOLE/SEEK_DATA...

But yes: a new fs_flags flag is probably the go.

Thanks,
NeilBrown

>=20
> Cheers,
>=20
> Dave.


--Sig_//sIrGayHR=+4EOFiBJkYHL=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSccbTnsnt1WYoG5AQICqQ//er21NCQl/3yQJ3Pya1rlx9TxnLueCDaN
s5VfKq+acDmE2NHfzmFWrLAjT/qn8QV3N0kb2NupIoZU5O2Cc9vldgK1T4OBfQME
GtU6hch++x/n9IeaHjheTmfQKKFVlmtZlaxWI7iEvMLbL+dDetwEfkBHnKN+675y
tqFEwTUyWZ7u1HvaBGQuybFTSw5tT4S4Z+UmYFW/guT+jEABxnk5YV5Dc1z5ucj4
Ihorqeso9OSmbixHA8qi/JyW7Ckjm5kYryH9GhtaA77GJV+4UF9qJxu5oWvfc06g
Q1LV+Uop8USRAxrIG7ag7x6eziXohkD8jNLLD9ClUXqwq7K7HRHF3pVEwHgwYukR
BlZnCav2COJkDlpvDTxEvsR8aQ/Rxks++EApBtT3z+lgc5bKzlTUJgIHrMP2iOAf
LnN2Tn29Ns6GE+ismcOsnhA/j96Vn9qn0JG2tBQ8wyHs9YxiEqKATN3XbJjAp3Sp
vNV0RVeYA5yOCl/k6IQ9byL5cyHVNYk1NoybXr6+7+9cahqWYEh6/mtgZZrT4E+q
ENvV+XEsLihKOFlrS4GSVzJuHFwDKUIie4XLjUMw18aCH9TSdUzR1VTC6ZbVvBZu
p/kYo6gCFkwRc06GQN0Qcwc4M6r+99cFMXe2pQikoWulVOE5FiRO9hutY0LT5TBi
0Bsk9vaOsxA=
=KjRX
-----END PGP SIGNATURE-----

--Sig_//sIrGayHR=+4EOFiBJkYHL=--
