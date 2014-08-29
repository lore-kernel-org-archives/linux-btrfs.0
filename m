Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35021 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaH2QYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 12:24:25 -0400
Date: Fri, 29 Aug 2014 17:24:21 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Putting very big and small files in one subvolume?
Message-ID: <20140829162421.GF5781@carfax.org.uk>
References: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com>
 <CAH-HCWXr=FYr9xcXutoa9mHn7or5GDMy+jxEy0EsCX6ANdG1Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fWddYNRDgTk9wQGZ"
In-Reply-To: <CAH-HCWXr=FYr9xcXutoa9mHn7or5GDMy+jxEy0EsCX6ANdG1Xg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fWddYNRDgTk9wQGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2014 at 09:34:54PM +0530, Shriramana Sharma wrote:
> On 8/17/14, Shriramana Sharma <samjnaa@gmail.com> wrote:
> > Hello. One more Q re generic BTRFS behaviour.
> > https://btrfs.wiki.kernel.org/index.php/Main_Page specifically
> > advertises BTRFS's "Space-efficient packing of small files".
> 
> Hello. I realized that while I got lots of interesting advice on how
> to best layout my FS on multiple devices/FSs, I would like to
> specifically know how exactly the above works (in not-too-technical
> terms) so I'd like to decide for myself if the above feature of BTRFS
> would suit my particular purpose.

   In brief: For small files (typically under about 3.5k), the FS can
put the file's data in the metadata -- specifically, the extent tree
-- so that the data is directly available without a second seek to
find it.

   The longer version: btrfs has a number of B-trees in its metadata.
These are trees with a high fan-out (from memory, it's something like
30-240 children each, depending on the block size), and with the
actual data being stored at the leaves of the tree. Each leaf of the
tree is a fixed size, depending on the options passed to mkfs.
Typically 4k-32k.

   The data in the trees is stored as a key and a value -- the tree
indexes the keys efficiently, and stores the values (usually some data
structure like an inode or file extent information) in the same leaf
node as the key -- keys at the front of the leaf, data at the back.

   The extent tree keeps track of the contiguous byte sequences of
each file, and where those sequences can be found on the FS. To read a
file, the FS looks up the file's extents in the extent tree, and then
has to go and find the data that it points to. This involves an extra
read of the disk, which is slow. However, the metadata tree leaf is
already in RAM (because the FS has just read it). So, for performance
and space efficiency reasons, it can optionally store data for small
files as part of the "value" component of the key/value pair for the
file's extent. This means that the file's data is available
immediately, without the extra disk read.

   Drawbacks -- metadata on btrfs is usually DUP, which means two
copies, so storing lots of medium-small files (2k-4k) will take up
more space than it would otherwise, because you're storing two copies
and not saving enough space to make it worthwhile. It also makes it
harder to calculate the "used" vs "free" values for df.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great films about cricket: Umpire of the Rising Sun ---       

--fWddYNRDgTk9wQGZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVACpNVheFHXiqx3kAQKpQA/8DHvqa7cGUiVXHABFgIVBRyr58wzIT19Y
5qbQyBsZ0j82N/hTW6TnMxYFQOHq/U5UuPCLYU/bo8ruA5NXzGtj/DgwxTe7BT/x
0lkiisPk/zWjW04gFpKYUMfdGM5bYBtxNcYsfKxLdU8Hihk6xKtk3XCYPM8wji4H
wrWWFUZ/GnStBsYLvXQukd5XleZACOEIan0JnPkPxAym8Bbj6mOBA9UBUW5E/3tY
DG5BqYabzp/8Br7Z9bk6Y3VmtDNUyyuX+21m4oY1Zl3ebJ3yoeUp3dAgw22AjoZF
5lt+v7agp4zfsrfFo/1b79VVL8oEKXk0OWCriBudjGaS6umxByD8YqHo8ZyQHQK6
aFYk+tkwtXEe+zDy5Tw/AD7yUg8OxlLSFC/ojhCmGjrk+mZ7iKNFIpygLTxgzBht
z4JSz64HgZEk1lKnva/WjsN8xVKuv3Pe2aiA/P2Y5mbKUun5N3Boeu4wVzF1Us81
v7QvtkOAYJeuUF75JF2VlJtdgyvSqwsijOSJ8RTPoeUopiERL8o2xjUqFcar22Zp
ezVNn/PD1GL1xK36c1qM80i2PCRnkvT5WYXTYd48BHzy/d2DOvWDd7ai1HtATtYz
tukrXONMOghsvHp7Lh7J8TlP1Izf8/ivr7oc8O+EvVeFYzJkl42gskUqAZBQKnFS
57OuVCWqOvM=
=lF/I
-----END PGP SIGNATURE-----

--fWddYNRDgTk9wQGZ--
