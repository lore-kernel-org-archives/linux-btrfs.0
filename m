From: Chris Samuel <chris@csamuel.org>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Wed, 28 Jul 2010 22:28:19 +1000
Message-ID: <201007282228.23360.chris@csamuel.org>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com> <201007280110.46059.diegocg@gmail.com> <AANLkTi=x9q1XOu_6F2hOv_ZPoM+McKz9Nv2Q5GZNfa4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18833409.WfW9mxhoo8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Ben Chociej <bchociej@gmail.com>, diegocg@gmail.com,
	chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=x9q1XOu_6F2hOv_ZPoM+McKz9Nv2Q5GZNfa4a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart18833409.WfW9mxhoo8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Jul 2010 09:18:23 am Ben Chociej wrote:

> Yes, that's correct. It's likely not going to be a cache in the
> traditional sense, since the entire capacity of both HDD and SSD would
> be available.

To me that sounds like an HSM type arrangement, with most frequently used d=
ata=20
on the highest performing media and less frequently touched data getting=20
shunted down the chain to SAS, SATA and then tape and/or MAID type devices.

Certainly interesting from my HPC point of view in that I can see it being=
=20
useful to parallel filesystems like Ceph if this "just happens".

I guess real HSM devotees would want policies for migration downstream.. ;-)

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart18833409.WfW9mxhoo8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATFAiZI1yjaOTJg85AQKgIAgAmSg0l/BcxEJEUTLWmZbKecFUdmbanuFM
ugN4G6xY/VItX5HIJmNfLtorciSBMCmHTtFelKs/FPTRIozIv3Pe7/8AZl0rCi+0
RiM+S2D15oIFyLYOKlxzh0TK4NjS+kW/Xa1xLlNdQtW77jtLZqJaSldK1n15X0Ls
YwTdPRp63R3TfWqLkuPpN+M0aJmo5YfkKDyUDukSs/dEinVRQEKQZ2+oyie92Gd+
ZbIeXKJX2q1SZ6oM+4+oiL5R6sXESdEJ5IjqhkXE0FAOcPqyigPrum/pPUtymZa6
3iBbS38lwiYNDSCR6PbccRUsvstG6tFGtne+JP+dcqP4JWpJKiQriQ==
=HETq
-----END PGP SIGNATURE-----

--nextPart18833409.WfW9mxhoo8--
