Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:43295 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbeIKHko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 03:40:44 -0400
Subject: Re: [PATCH v2 0/5] btrfs: qgroup: Skip unrelated tree blocks for
 balance
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180907093235.28254-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <365a6700-4a69-4997-1546-b90710d9d8d3@gmx.com>
Date: Tue, 11 Sep 2018 10:43:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180907093235.28254-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MhJv52BIfKKgAbEjxy6ikzPGVfIQftQml"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MhJv52BIfKKgAbEjxy6ikzPGVfIQftQml
Content-Type: multipart/mixed; boundary="NGSVrAWL79Z3sSKeJHo3N0oCQHowymzon";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <365a6700-4a69-4997-1546-b90710d9d8d3@gmx.com>
Subject: Re: [PATCH v2 0/5] btrfs: qgroup: Skip unrelated tree blocks for
 balance
References: <20180907093235.28254-1-wqu@suse.com>
In-Reply-To: <20180907093235.28254-1-wqu@suse.com>

--NGSVrAWL79Z3sSKeJHo3N0oCQHowymzon
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/7 =E4=B8=8B=E5=8D=885:32, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
> The base commit is v4.19-rc1 tag.
>=20
> There are a lot of reports of system hang for balance on quota enabled
> fs.
> It's most obvious for large fs.
>=20
> The hang is caused by tons of unmodified extents marked as qgroup dirty=
=2E
> Such unmodified/unrelated sources include:
> 1) Unmodified subtree
> 2) Subtree drop for reloc tree
> (BTW, other sources includes unmodified file extent items)
>=20
> E.g.
> OO =3D Old tree blocks from file tree
> NN =3D New tree blocks from reloc tree
>=20
>         file tree                              reloc tree
>            OO (a)                                  NN (a)
>           /  \                                    /  \
>     (b) OO    OO (c)                        (b) NN    NN (c)
>        / \   / \                               / \   / \
>      OO  OO OO  OO                           OO  OO OO  NN
>     (d) (e) (f) (g)                         (d) (e) (f) (g)
>=20
> In above case, balance will modify nodeptr in OO(a) to point NN(b) and
> NN(c), and modify NN(a) to point to OO(B) and OO(c).
>=20
> Before this patch, quota will mark the whole subtree from its parent
> down to the leaves as dirty.
> So btrfs quota need to trace all tree block from (a) to (g).
>=20
> However tree blocks (d) (e) (f) are shared between both trees, thus
> there is no need to trace those 3 tree blocks.
>=20
> This patchset will change how this work by only tracing modified tree
> blocks in reloc tree, and their counter parts in file tree.
>=20
> Nodeptr swap will happen for tree blocks (b) and (c) in both tree.
>=20
> For tree block (b), in reloc tree we could find that all its
> children's generation is smaller than last_snapshot, thus no need to
> trace them, only need to trace NN(b), and its counter part OO(b).
>=20
> For tree block (c), in reloc tree, we find its child NN(g) need
> tracing, and for tree block NN(g), there is no child need to trace.
>=20
> So for subtree starting at tree block NN(c), we need to trace NN(c) and=

> NN(g), along with its counter part OO(c) and OO(c).
>=20
> With this patch, we could skip tree blocks OO(d)~OO(f) in above example=
,
> thus reduce some some overhead caused by qgroup.
>=20
> The improvement is mostly related to metadata relocation.
> If there is some high level tree blocks get relocated but its children =
are
> still unmodified, we could save a lot of time.
>=20
> Even for the worst case, it should be no worse than original full
> subtree marking method.
>=20
> Real world case benchmark is under way.

Did a small scale test. (With latest submitted patch "btrfs:
delayed-ref: Introduce new parameter for btrfs_add_delayed_tree_ref() to
reduce unnecessary qgroup tracing")

4K nodesize fs (to bump tree sizes), around 4G data copied from /usr and
/lib (so number of files should be large enough).

The VM has unsafe cache mode for its qcow2 file, and the backing device
is a SAMSUNG 850 evo sata SSD. (Host has enough RAM so most IO should be
as fast as RAM speed).

The for metadata only balance:

                     | Before          | After       | Diff
-------------------------------------------------------------------------=
-
relocated extents    | 21112           | 22916       | +8.5%
qgroup dirty extents | 213831          | 140731      | -30.0%
time (sys)           | 7.828s          | 5.818s      | -25.7%
time (real)          | 10.004s         | 7.768s      | -22.3%

I'll report back with even larger fs with more subvolumes/snapshots.

Thanks,
Qu

>=20
> Changelog:
> v2:
>   Rename "tree reloc tree" to "reloc tree".
>   Add patch "Don't trace subtree if we're dropping reloc tree" into the=

>   patchset.
>   Fix wrong btrfs_bin_search() call, which leads to unexpected ENOENT
>   error for btrfs_qgroup_trace_extent_swap(). Now use dst_path->slots[]=

>   directly.
>=20
> Qu Wenruo (5):
>   btrfs: qgroup: Introduce trace event to analyse the number of dirty
>     extents accounted
>   btrfs: qgroup: Introduce function to trace two swaped extents
>   btrfs: qgroup: Introduce function to find all new tree blocks of relo=
c
>     tree
>   btrfs: qgroup: Use generation aware subtree swap to mark dirty extent=
s
>   btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
>=20
>  fs/btrfs/extent-tree.c       |   8 +-
>  fs/btrfs/qgroup.c            | 338 +++++++++++++++++++++++++++++++++++=

>  fs/btrfs/qgroup.h            |  10 ++
>  fs/btrfs/relocation.c        |  11 +-
>  include/trace/events/btrfs.h |  21 +++
>  5 files changed, 379 insertions(+), 9 deletions(-)
>=20


--NGSVrAWL79Z3sSKeJHo3N0oCQHowymzon--

--MhJv52BIfKKgAbEjxy6ikzPGVfIQftQml
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluXK9QACgkQwj2R86El
/qj9vwf9EeUV123eBGfGBT94Uy4o5TACiZxRUmKLLWYvRSVyQBCgRJgcDsSgh24O
NTDiBoaWbFhOTn/1qHmgwrKf5lTD9E4DiqmvKZPLTXxfz4sBhtfnommkqLidr4XK
QggGacY2hxXK9cOzm4byXgmJTqro477x1XE9R57k9VcdR1/JJKZON8aTerD1eGqN
R1lYbwb/R7Xrkj2rZ5bVPn/S4ml2uswSvzzWGn/Bw7vy665WJLP0f8jrUb2fiFmG
2ytJb/DX3g8QvRZmnHUBG6in8m9/WNsAae353DPoa0Qv0q28VGMtdlv6XfN1u67q
iFVunrYl+GNUUH0Mw71rc9GEAEtHqg==
=/J5/
-----END PGP SIGNATURE-----

--MhJv52BIfKKgAbEjxy6ikzPGVfIQftQml--
