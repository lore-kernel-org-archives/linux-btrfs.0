Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57751 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbdCCLmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 06:42:47 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M2Ldk-1cTKtT0SxA-00s8BM for
 <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 12:26:11 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Fri, 03 Mar 2017 12:26:03 +0100
Message-ID: <3531381.depUXnaGdq@thetick>
In-Reply-To: <e98d69c5-ac5e-d5b6-d7af-eb9c33975734@cn.fujitsu.com>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <1689223.KKWey1OxT2@thetick> <e98d69c5-ac5e-d5b6-d7af-eb9c33975734@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1713036.9y5nx11lnv"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1713036.9y5nx11lnv
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Friday 03 March 2017 09:09:57 Qu Wenruo wrote:
> At 03/02/2017 05:44 PM, Marc Joliet wrote:
> > On Wednesday 01 March 2017 19:14:07 Marc Joliet wrote:
> >> In any
> >> case, I started btrfs-check on the device itself.
> >=20
> > OK, it's still running, but the output so far is:
> >=20
> > # btrfs check --mode=3Dlowmem --progress /dev/sdb2
> > Checking filesystem on /dev/sdb2
> > UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
> > ERROR: shared extent[3826242740224 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3826442825728 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3826744471552 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827106349056 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827141001216 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827150958592 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827251724288 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827433795584 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827536166912 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827536183296 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3827621646336 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3828179406848 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3828267970560 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3828284530688 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3828714246144 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3828794187776 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3829161340928 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3829373693952 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3830252130304 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3830421159936 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3830439141376 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3830441398272 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3830785138688 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831099297792 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831128768512 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831371513856 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831535570944 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831591952384 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831799398400 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831829250048 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3831829512192 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832011440128 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832011767808 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832023920640 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832024678400 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832027316224 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832028762112 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832030236672 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832030330880 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832161079296 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832164904960 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832164945920 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3832613765120 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3833727565824 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3833914073088 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3833929310208 4096] lost its parent (parent:
> > 3827251183616, level: 0)
> > ERROR: shared extent[3833930141696 4096] lost its parent (parent:
> > 3827251183616, level: 0)
>=20
> The "shared extent lost its parent" is all about the same extent,
> 3827251183616.
>=20
> It would be nice if you could paste the output of btrfs-debug-tree -b=

> 3827251183616 to check what tree it belongs to.

# btrfs-debug-tree -b 3827251183616 /dev/sdb2=20
btrfs-progs v4.9
leaf 3827251183616 items 33 free space 1712 generation 291223 owner 2
fs uuid f97b3cda-15e8-418b-bb9b-235391ef2a38
chunk uuid 1cee580c-3442-4717-9300-8514dd8ff297
        item 0 key (3988449177600 EXTENT_ITEM 8192) itemoff 3942 itemsi=
ze 53
                extent refs 1 gen 271366 flags DATA
                extent data backref root 32126 objectid 1921863 offset=20=

302157824 count 1
        item 1 key (3988449185792 EXTENT_ITEM 4096) itemoff 3889 itemsi=
ze 53
                extent refs 1 gen 271366 flags DATA
                extent data backref root 32126 objectid 1921863 offset=20=

302534656 count 1
        item 2 key (3988449189888 EXTENT_ITEM 4096) itemoff 3852 itemsi=
ze 37
                extent refs 1 gen 244831 flags DATA
                shared data backref parent 4691081252864 count 1
        item 3 key (3988449193984 EXTENT_ITEM 8192) itemoff 3815 itemsi=
ze 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644000256 count 1
        item 4 key (3988449202176 EXTENT_ITEM 4096) itemoff 3778 itemsi=
ze 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644000256 count 1
        item 5 key (3988449206272 EXTENT_ITEM 4096) itemoff 3741 itemsi=
ze 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644000256 count 1
        item 6 key (3988449210368 EXTENT_ITEM 4096) itemoff 3688 itemsi=
ze 53
                extent refs 1 gen 288553 flags DATA
                extent data backref root 33295 objectid 1921863 offset=20=

233136128 count 1
        item 7 key (3988449214464 EXTENT_ITEM 8192) itemoff 3635 itemsi=
ze 53
                extent refs 1 gen 283033 flags DATA
                extent data backref root 32994 objectid 1921863 offset=20=

694497280 count 1
        item 8 key (3988449222656 EXTENT_ITEM 4096) itemoff 3598 itemsi=
ze 37
                extent refs 1 gen 279261 flags DATA
                shared data backref parent 3829567111168 count 1
        item 9 key (3988449226752 EXTENT_ITEM 12288) itemoff 3545 items=
ize 53
                extent refs 1 gen 283033 flags DATA
                extent data backref root 32994 objectid 1921863 offset=20=

694648832 count 1
        item 10 key (3988449239040 EXTENT_ITEM 4096) itemoff 3508 items=
ize 37
                extent refs 1 gen 244831 flags DATA
                shared data backref parent 4691081252864 count 1
        item 11 key (3988449243136 EXTENT_ITEM 16384) itemoff 3426 item=
size 82
                extent refs 3 gen 287487 flags DATA
                extent data backref root 33204 objectid 214635 offset 3=
89120=20
count 1
                extent data backref root 33205 objectid 214635 offset 3=
89120=20
count 2
        item 12 key (3988449259520 EXTENT_ITEM 4096) itemoff 3389 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644000256 count 1
        item 13 key (3988449263616 EXTENT_ITEM 4096) itemoff 3352 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644016640 count 1
        item 14 key (3988449267712 EXTENT_ITEM 4096) itemoff 3315 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644016640 count 1
        item 15 key (3988449271808 EXTENT_ITEM 4096) itemoff 3278 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644045312 count 1
        item 16 key (3988449275904 EXTENT_ITEM 8192) itemoff 3225 items=
ize 53
                extent refs 1 gen 291191 flags DATA
                extent data backref root 33530 objectid 1277577 offset=20=

392007680 count 1
        item 17 key (3988449284096 EXTENT_ITEM 8192) itemoff 3188 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644016640 count 1
        item 18 key (3988449292288 EXTENT_ITEM 8192) itemoff 3135 items=
ize 53
                extent refs 1 gen 287570 flags DATA
                extent data backref root 33214 objectid 211018 offset 1=
31072=20
count 1
        item 19 key (3988449300480 EXTENT_ITEM 8192) itemoff 3098 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644016640 count 1
        item 20 key (3988449308672 EXTENT_ITEM 4096) itemoff 3061 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644045312 count 1
        item 21 key (3988449312768 EXTENT_ITEM 4096) itemoff 3024 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644045312 count 1
        item 22 key (3988449316864 EXTENT_ITEM 8192) itemoff 2987 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644053504 count 1
        item 23 key (3988449325056 EXTENT_ITEM 8192) itemoff 2934 items=
ize 53
                extent refs 1 gen 287571 flags DATA
                extent data backref root 33214 objectid 212344 offset 1=
31072=20
count 1
        item 24 key (3988449333248 EXTENT_ITEM 4096) itemoff 2897 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644053504 count 1
        item 25 key (3988449337344 EXTENT_ITEM 4096) itemoff 2860 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644053504 count 1
        item 26 key (3988449341440 EXTENT_ITEM 20480) itemoff 2807 item=
size 53
                extent refs 1 gen 291191 flags DATA
                extent data backref root 33530 objectid 1277577 offset=20=

391614464 count 1
        item 27 key (3988449361920 EXTENT_ITEM 4096) itemoff 2754 items=
ize 53
                extent refs 1 gen 291191 flags DATA
                extent data backref root 33530 objectid 1277577 offset=20=

392032256 count 1
        item 28 key (3988449366016 EXTENT_ITEM 8192) itemoff 2701 items=
ize 53
                extent refs 1 gen 288553 flags DATA
                extent data backref root 33295 objectid 1921863 offset=20=

233062400 count 1
        item 29 key (3988449374208 EXTENT_ITEM 4096) itemoff 2664 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644053504 count 1
        item 30 key (3988449378304 EXTENT_ITEM 4096) itemoff 2627 items=
ize 37
                extent refs 1 gen 154664 flags DATA
                shared data backref parent 4607644053504 count 1
        item 31 key (3988449382400 EXTENT_ITEM 8192) itemoff 2590 items=
ize 37
                extent refs 1 gen 154663 flags DATA
                shared data backref parent 4607644053504 count 1
        item 32 key (3988449390592 EXTENT_ITEM 8192) itemoff 2537 items=
ize 53
                extent refs 1 gen 271366 flags DATA
                extent data backref root 32126 objectid 1921863 offset=20=

302276608 count 1

> > ERROR: extent[3837768077312, 24576] referencer count mismatch (root=
:
> > 33174,
> > owner: 1277577, offset: 4767744) wanted: 1, have: 0
> > [snip many more referencer count mismatches]
> > ERROR: extent[3878247383040, 8192] referencer count mismatch (root:=
 33495,
> > owner: 2688918, offset: 3874816) wanted: 2, have: 3
>=20
> That's a little dangerous now.
>=20
> Some *DATA* extent even lost its referencer now.
>=20
> For example, data extent at 3837768077312, length 24K exists on disk,=

> but no one is referring to it.
>=20
> At least the good news is, these just mean there is some extra space
> taken on disk, but not vice verse.
>=20
> > ERROR: block group[3879328546816 1073741824] used 1072840704 but ex=
tent
> > items used 1129164800
> > ERROR: extent[3879516581888, 40960] referencer count mismatch (root=
:
> > 33530,
> > owner: 1277577, offset: 23461888) wanted: 1, have: 0
> > [snip many more referencer count mismatches]
> > ERROR: extent[3951758860288, 16384] referencer count mismatch (root=
:
> > 33189,
> > owner: 1277577, offset: 519880704) wanted: 1, have: 0
> >=20
> > This is 56=09lines of output, the unabridged output contains enough=

> > "referencer count mismatches" to fill 1329 lines of output.  Could =
that
> > be because there are deleted snapshots that btrfs-cleaner hasn't be=
en
> > able to clean up?
> Ah, this makes sense.
>=20
> But normally cleaner should cleanup subvolume tree block and modify
> extent tree.
> How did you stop btrfs-cleaner?

See the log I posted on 28th February.  The file system gets forced RO =
due to=20
"Transaction aborted (error -2)" errors.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1713036.9y5nx11lnv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAli5UssACgkQv9DmhiyI
ePQFYQ/+NaYw/02nYZllMPcWXHGtJl+mqqPPU298BzjqfRD9l/eXeAJIiSLa1FWC
ir7zlNd+rg04bZTRCLMcEuYL6wRhj+TljJN8Htql0MJ6lG3mkhN7dahCfmdzaYn6
eK/Ky0Lp0JRhrj4bdQV8SzB9QFQ8D+rahppFTUIqDn3X2NZuSvBv8W58UCUGhzuv
t0+B6Xwdj6V7gssV1RzqysAWusr8sPPTLrpu19LoZSXoS/gP0DexaDtm+UCC9qvO
l49J1n6Sy64iwR5j+qajX3XiKe2iXiy4K9ZlQ1FpVUc83a8JsMx+X/KoO4dxeAVX
JEMf3R6YzYva9ZDdjX6DLq5zowqsO013CIx2NvqeLcT387fFBO7iYLzef2bSNgWu
n4MWH/+ofCgIRzLQjGP1W171GH0kFNOseaOmGuvMJA0iWPF4b6XcbXgYnwudZLI7
CULQy9srKsP0odx4bOTZ0x1fyQCbXBLAmZ2B/j4RZuaPPH098NNua5Lye20IOK99
990bgjeIQ6Zpajr96RRrsEwTNzVQJxeIoReoLumr6HdQGnp+UPksB4HOZ2pouqXB
NaSbEqczdsMxHbFbiDxVnkJIGoX9H2sEv3HBptc5EeBdwBUb+P7PKrhRYVHQA2P5
zZ3CFliYtqFJ7IeXDpBmleMdal6U7nIUSGno5wsSoPLDAaY9su8=
=3m0P
-----END PGP SIGNATURE-----

--nextPart1713036.9y5nx11lnv--

