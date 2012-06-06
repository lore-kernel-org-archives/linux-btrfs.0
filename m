Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41311 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2FFNPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 09:15:00 -0400
Date: Wed, 6 Jun 2012 14:14:58 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: New btrfs-progs integration branch
Message-ID: <20120606131458.GN15986@carfax.org.uk>
References: <20120605190921.GM15986@carfax.org.uk>
 <CAMlaX89CXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWbmMdDzzl2TXAgx"
In-Reply-To: <CAMlaX89CXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uWbmMdDzzl2TXAgx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 06, 2012 at 01:48:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 05.06.12:
> 
> >    The branch is fetchable with git from:
> 
> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> > integration-20120605
> 
> There seems to be a bug inside:
> 
> [...]
> 
> gcc -g -O0 -o btrfsck btrfsck.o ctree.o disk-io.o radix-tree.o extent- 
> tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o  
> inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o  
> utils.o btrfs-list.o btrfslabel.o repair.o  -luuid
> 
> gcc -g -O0 -o btrfs-convert ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o repair.o convert.o -lext2fs -lcom_err  -luuid
> 
> gcc   convert.o   -o convert
> convert.o: In function `btrfs_item_key':
> /tmp/btrfs-progs-unstable/ctree.h:1404: undefined reference to `read_extent_buffer'
> convert.o: In function `btrfs_dir_item_key':
> /tmp/btrfs-progs-unstable/ctree.h:1437: undefined reference to `read_extent_buffer'
> convert.o: In function `btrfs_del_item':

   Odd. I've just tried this on a clean clone of my repo, and it's
building fine. It's declared in extent_io.h, and defined in
extent_io.c.

   However, it does look like there's a problem with the make process:
my Makefile says:

btrfs-convert: $(objects) convert.o
        $(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)

... which seems to be what the second line you quoted is doing.
However, the third line with the problem looks like something out of
date. Possibly a mis-merge?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I ---  
                       know a hawk from a handsaw.                       

--uWbmMdDzzl2TXAgx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz1fSIKyzvlFcI40RAoxiAKCK/iesUY9wbClUIlIByqkYX8+DkgCg0v5x
5CqGO9wY9x2Cc26bg+FUM5o=
=ALmi
-----END PGP SIGNATURE-----

--uWbmMdDzzl2TXAgx--
