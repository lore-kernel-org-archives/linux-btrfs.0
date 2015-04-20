Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbbDTJeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 05:34:00 -0400
Date: Mon, 20 Apr 2015 19:33:47 +1000
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Chris Mason <clm@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Message-ID: <20150420193347.29378d69@notabene.brown>
In-Reply-To: <30419.1429519662@warthog.procyon.org.uk>
References: <20150420052752.26554.13596.stgit@notabene.brown>
	<20150420052558.26554.97143.stgit@notabene.brown>
	<30419.1429519662@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WX_OKL6q19f.scbF/x.jlj7"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/WX_OKL6q19f.scbF/x.jlj7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Apr 2015 09:47:42 +0100 David Howells <dhowells@redhat.com> wrot=
e:

> NeilBrown <neilb@suse.de> wrote:
>=20
> > +	.fs_flags	=3D FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA |
> > +			  FS_SUPPORTS_SEEK_HOLE,
>=20
> I must be missing something:
>=20
> 	warthog>git merge linus/master
> 	Already up-to-date.
> 	warthog>stg id
> 	09d51602cf84a1264946711dd4ea0dddbac599a1
> 	warthog>grep -r FS_SUPPORTS_SEEK_HOLE include/
> 	warthog1>git grep FS_SUPPORTS_SEEK_HOLE
> 	warthog1>
>=20

Missing patch 2 of the 3-patch series?

NeilBrown

--Sig_/WX_OKL6q19f.scbF/x.jlj7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTTH/Dnsnt1WYoG5AQLLMw/9FDfcFWzmddOm68aU8u1L+mQLCp2xzh83
DmXymsd1gokfbCIRC3zI69SOPLmsED5mpUbuSqt/mAabVqXzBFg+TphzvEokuIhW
u1wwLno/2qqipmTTR28wswu5JbTnMWT32kBkvMr6GFt0uDQ1sLjdxHIGnhDTh3ax
rrmCV6f01Iu0zZigM37M7TdbqvFpyKB2L+BKYVK4G8Qdoaz34WYfTGvGwVPQEKve
+HtcU6vV2o1P8n1q4OiwkzOssOzTRCjg2IOIMkrKTdHTdqUAQ6JJrOAmhfs2xE5U
rCi4m2ag9zKzcBPIw1j+lJu1bc+qeWgxgodv/CBZq7fND8NYsuFGlVNBSj5u0HtQ
LBCNqg4F03TdzK7rpynvk+yxJv5AHtHYOcBznb1irhRQn2wkP2fQSdtOv3QBn4aj
JOyGKoK3Ftq0ELTK0ogDZVxyoDLL4ex0cxyrjCW2Ly/ksi6yrxCsvNC8gAEqHp3S
3K5dVwwL8UbsJ28o6Qqcy76T4A4V0OS9D6U7pdpb1MMpzGz7Q1VbwfLuKsttXcwM
8Q6+e7lqK0RI67SOeHynxFHWavlxWLw/2Z7zfMhkrw+3Xv0oFI/9Y5CnZEfa1jf+
MCNQhr1xkjHv/q2h1piKg6jy/U2jQmjo+cxRtyO9zIikVHmq4dtBJUo0bU+FMYnD
8W2BQNeEBHY=
=9sP/
-----END PGP SIGNATURE-----

--Sig_/WX_OKL6q19f.scbF/x.jlj7--
