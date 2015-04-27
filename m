Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbbD0Flo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 01:41:44 -0400
Date: Mon, 27 Apr 2015 15:41:33 +1000
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Message-ID: <20150427154133.65f58366@notabene.brown>
In-Reply-To: <20150420094855.GA21116@infradead.org>
References: <20150420193347.29378d69@notabene.brown>
	<20150420052752.26554.13596.stgit@notabene.brown>
	<20150420052558.26554.97143.stgit@notabene.brown>
	<30419.1429519662@warthog.procyon.org.uk>
	<31824.1429523209@warthog.procyon.org.uk>
	<20150420094855.GA21116@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/sn6fG6xQ5woy/dSUdoBnjGM"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/sn6fG6xQ5woy/dSUdoBnjGM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Apr 2015 02:48:55 -0700 Christoph Hellwig <hch@infradead.org>
wrote:

> On Mon, Apr 20, 2015 at 10:46:49AM +0100, David Howells wrote:
> > NeilBrown <neilb@suse.de> wrote:
> >=20
> > > Missing patch 2 of the 3-patch series?
> >=20
> > Yes. :-)
> >=20
> > Do ext4 and xfs support this, do you know?
>=20
> Yes.  As do f2fs, ocfs2, gfs2, ceph and NFSv4.2

Are you sure about NFSv4.2?

I see that it *can* report holes, but is there any guarantee that if you
create a new file and write only the 5th block, then READ_PLUS will reliably
report that the first 4 block are holes??

Because if it doesn't guarantee that, then NFSv4.2 doesn't fit the with the
others where SEEK_HOLE reliable reports holes.
On the other hand if NFSv4.2 *does* guarantee that then the current READ_PL=
US
server patches are broken because they just use vfs_llseek and assume that
trust what it says.

It would be really nice if SEEK_{DATA,HOLE} either reported holes reliably =
or
returned ENXIO, but I guess there was a goo reason not to do that.

Thanks,
NeilBrown

--Sig_/sn6fG6xQ5woy/dSUdoBnjGM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT3MDTnsnt1WYoG5AQLgIhAAhU7L2vJz6/vekVjSX9d1R59Awzpxpfqd
n8MpqPNHVkkg8y/aCMA6QkOmAhFsvFrXOm88Gkh/3NYhcTa7hYodrgSxKPnD6wuR
q09r6YB+zYEEQZdTCaiLioOXmCyldn3/HR+BDEnCDmdUqRgf6PdM2dd3pcaYhYH9
dgVaeKgidpqyJOO8RlyzqAGBu6NGbzktIW7bPYbObUYoUiMN6jEeDo8BJ42y8aCC
PwtH3K+W5lY2/Wng4Xm5+NZ/GGFifhkdnKghjqR6cVHMQlKsNGci+VqwIGK9CapV
YoQ0k4aB4WBDXJe+6EPIG+HG8nugmtLSZG+09/iJj9UiPl2IeCRKiaFVllgJDiFX
GmwRWq4Qo1jlmE8RlMsso5hELwz/4xcmDuQRSuTF8PeXchwEXg+I8GXRy3EQAImK
NIu6inzAEWHSJeqEpjjCgYpRN1P9xpKUls2kr17Edno+0aVPtc65oooFnGzcxWYu
MnIhUzvb/bzhaeXyRdvgNkwqfiXz0u5yx2KlN/w/LAxbxYPj35vMOl8waDZzA/eh
0cC1MdjYA06CCA9Hjl+lxGRal7AvZmF87EoYJqsfFtD0Nygu2iRUkzAlsdoO0CUR
4oQpn4QLwCXsknB3sXgL+LZZWiVWljhgo8gRnI+MhQvfYQEiVBv9hNzITcwP5a2s
X5/rzDm+oHc=
=Ao0v
-----END PGP SIGNATURE-----

--Sig_/sn6fG6xQ5woy/dSUdoBnjGM--
