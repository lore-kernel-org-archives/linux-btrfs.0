Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49427 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbeAPFUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 00:20:30 -0500
Subject: Re: invalid files names, btrfs check can't repair it
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
Message-ID: <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
Date: Tue, 16 Jan 2018 13:19:50 +0800
MIME-Version: 1.0
In-Reply-To: <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dkzyxnSQD257vKYThRgMca8nALAjD0u7d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dkzyxnSQD257vKYThRgMca8nALAjD0u7d
Content-Type: multipart/mixed; boundary="k0cIxOvhYyILM7FZnFqEMBnGP9P5g60m4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Message-ID: <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
In-Reply-To: <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>

--k0cIxOvhYyILM7FZnFqEMBnGP9P5g60m4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8816=E6=97=A5 12:51, Qu Wenruo wrote:
> Now the problems are all located:
>=20
> For file "2f3f379b2a3d7499471edb74869efe-1948311.d", it's the problem o=
f
> its DIR_ITEM has wrong type:
>=20
> ------
>         item 14 key (57648595 DIR_ITEM 3363354030) itemoff 3053 itemsiz=
e 70
>                 location key (57923894 INODE_ITEM 0) type DIR_ITEM.33
>                                                           ^^^^^^^^^^^
> ------
>=20
> There is unexpected type DIR_ITEM and a special number 33 here.
>=20
> Despite that, the file is completely fine.
>=20
>=20
> For file "454bf066ddfbf42e0f3b77ea71c82f-878732.o"
> The problem is its namelen.
>=20
> ------
>         item 13 key (57648595 DIR_ITEM 3331247447) itemoff 3123 itemsiz=
e 69
>                 location key (58472210 INODE_ITEM 0) type FILE
>                 transid 89418 data_len 0 name_len 8231
>                                                   ^^^^ Insane
>                 name: 454bf066ddfbf42e0f3b77ea71c82f-878732.oq
> ------
>=20
> Despite that, it should be fine.
>=20
> I'm not 100% sure if repair can really handle it well.
> But I could craft a temporary fix based on btrfs-corrupt-block (I know
> the name is scary).
> And you may need to compile btrfs-progs with my patch.

I just assume it's fs_root, and pushed the hard-coded fix branch to my
github:
https://github.com/adam900710/btrfs-progs/tree/hard_coded_fix_for_sebasti=
an

Usage:
=2E/btrfs-corrupt-block -X <device>

Just as commit message says, if anything went wrong, it will not touch
the fs at all.
So it should be somewhat safe to use.

And if something went wrong, it will cause backtrace and abort, it's
designed and you don't need to panic:

Example: No dir_item in my btrfs
------
=2E/btrfs-corrupt-block -X /dev/data/btrfs
ERROR: corrupted DIR_ITEM not found
extent buffer leak: start 4227072 len 16384
extent_io.c:607: free_extent_buffer_internal: BUG_ON `eb->flags &
EXTENT_DIRTY` triggered, value 1
=2E/btrfs-corrupt-block(+0x251df)[0x5623e003a1df]
=2E/btrfs-corrupt-block(free_extent_buffer_nocache+0x1f)[0x5623e003aac1]
=2E/btrfs-corrupt-block(extent_io_tree_cleanup+0x6d)[0x5623e003ab33]
=2E/btrfs-corrupt-block(btrfs_cleanup_all_caches+0x76)[0x5623e0027747]
=2E/btrfs-corrupt-block(close_ctree_fs_info+0x111)[0x5623e0028027]
=2E/btrfs-corrupt-block(main+0x3f5)[0x5623e00551df]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7fdce4e0ff4a]
=2E/btrfs-corrupt-block(_start+0x2a)[0x5623e001ee3a]
Aborted (core dumped)
------

And if above error happens, please paste the error output and provide
the subvolume id.

Thanks,
Qu

>=20
> The only remaining thing I need is the subvolume id which contains the
> corrupted files.
>=20
> Since there is no other hit, I assume it's root subvolume (5), but I
> still need the extra confirm since the fix will be hard-coded.
>=20
> Thanks,
> Qu
>=20


--k0cIxOvhYyILM7FZnFqEMBnGP9P5g60m4--

--dkzyxnSQD257vKYThRgMca8nALAjD0u7d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpdi3cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiiyQgAmyrbRHBGYZ1/Or2iVH5t2kRb
reHVqqJIGOpGnGd2Hgt07feyqeyPNoaL4afRTFLbOpoTBMSl60KBIRQjH88d99tE
vN9qhkQDzlf2CSNSYZaXAwjbim/t29mCQWOJgvGD0iv4YdnqnEBVpfTtES3cTf0r
wCc16/VrjF762GRQlguXwwTDcmsLeBLsmGGmCHO0ONAybwYK43lANVqOHqhfcumb
iQOf6oqkgYEJ3IC/qBX+H+CNzd3hB1xaLtMgat+xzZqk7VarYBo6p0+P61YR9Btc
Fg/YK3nQGdyil8yaHw0p76Pd5Gd2bE9dUS029PIjGIqCvziJOvJDyy0NDM5Zcg==
=Qz/3
-----END PGP SIGNATURE-----

--dkzyxnSQD257vKYThRgMca8nALAjD0u7d--
