Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37051 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752531AbeFGEob (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 00:44:31 -0400
Subject: Re: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot >
 items
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <274f47db-b3cc-60fd-002b-f8c1eba29d6c@gmx.com>
Date: Thu, 7 Jun 2018 12:44:23 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J5gkkgLTEQM8EYKQvPF4mkkpfmmY860Or"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J5gkkgLTEQM8EYKQvPF4mkkpfmmY860Or
Content-Type: multipart/mixed; boundary="cOtQP5pl7aj03sZsqb8KnbwOh6tuz5rrH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <274f47db-b3cc-60fd-002b-f8c1eba29d6c@gmx.com>
Subject: Re: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot >
 items
References: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
In-Reply-To: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>

--cOtQP5pl7aj03sZsqb8KnbwOh6tuz5rrH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8807=E6=97=A5 11:33, james harvey wrote:
> =3D=3D=3D=3D=3D[ NOTE ]=3D=3D=3D=3D=3D
>=20
> I think I found a buffer over-read error that will come up other places=
, unless
> EACH caller checks bounds themselves.  See "Bonus bug, LEFT FOR READER"=
 below.
>=20
> =3D=3D=3D=3D=3D[ PROBLEM ]=3D=3D=3D=3D=3D
>=20
> Using btrfs-progs v4.16:
>=20
> No extent found at range [10955980800,10955984896)
>=20
> But, this extent exists.  btrfs-debug-tree shows:
> ...
> extent tree key (EXTENT_TREE ROOT_ITEM 0)
> ...
> leaf 316456960 items 203 free space 3697 generation 84225 owner EXTENT_=
TREE
> ...
>         item 197 key (10955931648 EXTENT_ITEM 28672) itemoff 8957 items=
ize 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 142622720 count 1
>         item 198 key (10955960320 EXTENT_ITEM 4096) itemoff 8920 itemsi=
ze 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 142622720 count 1
>         item 199 key (10955964416 EXTENT_ITEM 4096) itemoff 8883 itemsi=
ze 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 142622720 count 1
>         item 200 key (10955968512 EXTENT_ITEM 4096) itemoff 8846 itemsi=
ze 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 142622720 count 1
>         item 201 key (10955972608 EXTENT_ITEM 4096) itemoff 8809 itemsi=
ze 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 142655488 count 1
>         item 202 key (10955976704 EXTENT_ITEM 4096) itemoff 8772 itemsi=
ze 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 142655488 count 1
> ...
> leaf 316489728 items 208 free space 3387 generation 84225 owner EXTENT_=
TREE
> ...
>         item 0 key (10955980800 EXTENT_ITEM 4096) itemoff 16246 itemsiz=
e 37
>                 refs 1 gen 62656 flags DATA
>                 shared data backref parent 128958464 count 1
> ...
> checksum tree key (CSUM_TREE ROOT_ITEM 0)
> ...
>         item 412 key (EXTENT_CSUM EXTENT_CSUM 10955980800) itemoff 1064=
7
>                    itemsize 4
>                 range start 10955980800 end 10955984896 length 4096
> ....
> file tree key (3038 ROOT_ITEM 80009)
> ...
> leaf 128958464 items 37 free space 6032 generation 62656 owner FS_TREE
> ...
>         item 1 key (997645 INODE_ITEM 0) itemoff 15220 itemsize 160
>                 generation 62656 transid 62656 size 4943 nbytes 8192
>                 block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>                 sequence 5 flags 0x0(none)
>                 atime 1478246492.0 (2016-11-04 08:01:32)
>                 ctime 1478246493.129060242 (2016-11-04 08:01:33)
>                 mtime 1477487995.0 (2016-10-26 13:19:55)
>                 otime 1478246493.129060242 (2016-11-04 08:01:33)
>         item 2 key (997645 INODE_REF 299949) itemoff 15200 itemsize 20
>                 index 13 namelen 10 name: as_map.hpp
>         item 3 key (997645 EXTENT_DATA 0) itemoff 15147 itemsize 53
>                 generation 62656 type 1 (regular)
>                 extent data disk byte 10955980800 nr 4096
>                 extent data offset 0 nr 8192 ram 8192
>                 extent compression 2 (lzo)
> ...
>=20
> =3D=3D=3D=3D=3D[ CAUSE ]=3D=3D=3D=3D=3D
>=20
> In main's first call to map_one_extent(10955980800, 4096, 0):
>=20
> * btrfs_search_slot() looks for (10955980800, 0, 0), and:
> ** returns 1 because it doesn't exist
> ** sets path->slots[0] to 203 (for leaf 316456960), where it should go =
if
>    inserted (pointing after the last existing item)
> * ret is reset to 0
> * btrfs_item_key_to_cpu sets key to (10955960320, BTRFS_EXTENT_ITEM_KEY=
, 4096)
> !!! Bonus bug, LEFT FOR READER.  Why is this item #197, 5 items before =
the 203
>     given?  I think no bounds checking causes a buffer over-read here.
>     btrfs_item_key_to_cpu() calls btrfs_item_key(), which uses the macr=
o
>     read_eb_member() to call read_extent_buffer() which memcpy's using =
an out
>     of range index, at least for this leaf.

Here the key you got could be garbage.
Either the leaf has enough free space, then you got pending zero into
the key, or the leaf is full, you got some item data into the key.

Either way, the key should be read/trusted at all.

> * With (!search_forward && key.objectid > logical) being false, the cod=
e calling
>   btrfs_next_item() is not run.
> * logical is set to this too-low key.objectid
> * !ret, so set *logical_ret and *len_ret with the new values

Personally speaking, the first paragraph of dump tree could already
explain the bug pretty well.
So the explanation is a little longer here.

>=20
> Back in main:
>=20
> * ret is 0, so don't print the first error
> * ret is still 0, so don't run map_one_extent() with search_forward=3D1=

> * At the while loop, (10955960320 + 4096 >=3D 10955980800 && 1095596032=
0 <
>   10955980800 + 4096) (10955964416 >=3D 10955980800 && 10955960320 < 10=
955984896)
>   (false && true) (false), so don't call map_one_extent() with search_f=
orward=3D1
>   here, either.
> * In the while loop, now call map_one_extent() with search_forward=3D1
> * !found, so print (somewhat deceptive) error only mentioning the user-=
given
>   logical without mentioning it looked elsewhere, and give up.
>=20
> =3D=3D=3D=3D=3D[ FIX ]=3D=3D=3D=3D=3D
>=20
> btrfs-map-logical and I are not friends.  The "least code" fix for this=

> situation is this patch.
>=20
> Qu's "btrfs-progs: check: Also compare data between mirrors to detect c=
orruption
> for NODATASUM extents" uses a simpler way, which makes me wonder if tha=
t should
> just be modified to replace how btrfs-map-logical works.

That only works for certain cases.

Thus btrfs-map-logical is still a pretty handy tool for education/debug
purpose.

>  But, I'll admit I do
> not have my head around the entire way everything is done in btrfs-map-=
logical,
> and there could be reasons for it needing to be different here.
>=20
> This doesn't touch what I think is the buffer over-read error described=
 above.
>=20
> With this fix, btrfs_item_key_to_cpu() is not asked to read out of boun=
ds, so
> map_one_extent() leaves cur_logical and cur_len unmodified because they=
 don't
> need to be.  (Both the first time it's ran with search_forward=3D0, and=
 in the
> while loop when it's ran with search_forward=3D1.)
>=20
> Also updated call from btrfs_next_item() to btrfs_next_extent_item().  =
I can't
> see any reason not to, while this area's being modified.  It looks for =
both
> BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_ITEM_KEY, which is what we nee=
d.
> (Granted, inside, it's just calling btrfs_next_item().)
>=20
> Also fixed misspelling of "foward" to "forward".
>=20
> Signed-off-by: James Harvey <jamespharvey20@gmail.com>
> ---
>  btrfs-map-logical.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>=20
> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
> index 7a8bcff9..1c30b22b 100644
> --- a/btrfs-map-logical.c
> +++ b/btrfs-map-logical.c
> @@ -39,7 +39,7 @@
>  static FILE *info_file;
>=20
>  static int map_one_extent(struct btrfs_fs_info *fs_info,
> -                         u64 *logical_ret, u64 *len_ret, int search_fo=
ward)
> +                         u64 *logical_ret, u64 *len_ret, int search_fo=
rward)

OK, I checked twice and then I realized it's a typo...

Normally David would request you to split the patch, and put the typo
fix into a separate patch, to avoid jamming the real fix.

>  {
>         struct btrfs_path *path;
>         struct btrfs_key key;
> @@ -65,17 +65,25 @@ static int map_one_extent(struct btrfs_fs_info *fs_=
info,
>         BUG_ON(ret =3D=3D 0);
>         ret =3D 0;
>=20
> +       if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0])) {=

> +               ret =3D btrfs_next_leaf(fs_info->extent_root, path);
> +               if (ret !=3D 0) {
> +                       ret =3D -1;
> +                       goto out;
> +               }
> +       }
> +

Yes, we need such check especially when we search using key smaller than
what we really want.

So the fix here is correct.

And that's also why normally we search with larger key, and then use
btrfs_previous_item() to avoid such problem.


Thanks,
Qu

>  again:
>         btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> -       if ((search_foward && key.objectid < logical) ||
> -           (!search_foward && key.objectid > logical) ||
> +       if ((search_forward && key.objectid < logical) ||
> +           (!search_forward && key.objectid > logical) ||
>             (key.type !=3D BTRFS_EXTENT_ITEM_KEY &&
>              key.type !=3D BTRFS_METADATA_ITEM_KEY)) {
> -               if (!search_foward)
> +               if (!search_forward)
>                         ret =3D btrfs_previous_extent_item(fs_info->ext=
ent_root,
>                                                          path, 0);
>                 else
> -                       ret =3D btrfs_next_item(fs_info->extent_root, p=
ath);
> +                       ret =3D
> btrfs_next_extent_item(fs_info->extent_root, path);
>                 if (ret)
>                         goto out;
>                 goto again;
> --
> 2.17.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--cOtQP5pl7aj03sZsqb8KnbwOh6tuz5rrH--

--J5gkkgLTEQM8EYKQvPF4mkkpfmmY860Or
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsYuCcACgkQwj2R86El
/qj8IggAqoM7vgix+hgCSynzjJ5zEeW745b9xt6eNmBVg0iIhcuj2s4539Fet4CW
WUNcGEZ4Hooixl4QqI2vDrK0P/nW25ywBQvYG8dApcq2Fq6q2kah6jglpchj6eTN
N+ofDQSAdt9ZF94CY8Le78DE1DT4DaWzJZPwVoPOJ6i4ezu5BdjULLWQafhGnmVd
obnuez8HJnJgoGdlEtOCX4Kkh99yDAyjY5wYKhsntg3YvFoYXfAKyzK0sIQBVjrR
rWCU6iX38mzSv76z+CqPBcZBDUo1kS/VZIXkVsuGa+nuP7yVDZbvLQ3hVfQ6JloY
EwJHBglqfHj7hbh90H26Y5VpL1XfMg==
=BVlL
-----END PGP SIGNATURE-----

--J5gkkgLTEQM8EYKQvPF4mkkpfmmY860Or--
