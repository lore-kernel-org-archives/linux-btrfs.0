Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56097 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdLJXuH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 18:50:07 -0500
Subject: Re: Chunk-Recovery fails with alignment error
To: Benjamin Beichler <hadrian2002@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
 <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com>
 <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
 <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
 <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com>
 <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
 <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4b8d8cfe-de39-b587-075a-65a502bf5e08@gmx.com>
Date: Mon, 11 Dec 2017 07:50:00 +0800
MIME-Version: 1.0
In-Reply-To: <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="54cPn5un7WTcuHec3VuvXWCuIo00XIn6b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--54cPn5un7WTcuHec3VuvXWCuIo00XIn6b
Content-Type: multipart/mixed; boundary="4lShjtXLIShqQBcGu4ude7w03DqvTuLQ6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Benjamin Beichler <hadrian2002@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <4b8d8cfe-de39-b587-075a-65a502bf5e08@gmx.com>
Subject: Re: Chunk-Recovery fails with alignment error
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com>
 <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com>
 <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
 <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
 <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com>
 <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
 <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>
In-Reply-To: <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com>

--4lShjtXLIShqQBcGu4ude7w03DqvTuLQ6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8811=E6=97=A5 05:16, Benjamin Beichler wrote:
> The patch let the chunk-recover be successful. But I'm no lucky man,
> the recovered chunk tree does not work or other metadata is also
> broken.
>=20
> Mounting the system is not successful (dmesg):
> BTRFS critical (device dm-0): corrupt node, invalid item slot:
> block=3D16384, root=3D1, slot=3D0
> BTRFS error (device dm-0): failed to read chunk root
> BTRFS error (device dm-0): open_ctree failed

For this error, you could apply this diff to by-pass it:

------
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index ce4ed6ec8f39..355220e21c2e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -413,12 +413,6 @@ int btrfs_check_node(struct btrfs_root *root,
struct extent_buffer *node)
                btrfs_node_key_to_cpu(node, &key, slot);
                btrfs_node_key_to_cpu(node, &next_key, slot + 1);

-               if (!bytenr) {
-                       generic_err(root, node, slot,
-                               "invalid NULL node pointer");
-                       ret =3D -EUCLEAN;
-                       goto out;
-               }
                if (!IS_ALIGNED(bytenr, root->fs_info->sectorsize)) {
                        generic_err(root, node, slot,
                        "unaligned pointer, have %llu should be aligned
to %u",
------

Thanks,
Qu

>=20
> Therefore I tried a btrfs check --repair, this time without error:
> https://gist.github.com/anonymous/5cf7ad9e187032d2c94db4f91bb62c24
>=20
> Then I tried btrfs check --init-extent-tree and this produces much
> output. I put the beginning into here:
> https://gist.github.com/anonymous/70e2482646a8235ee2327105d920dadd
> From a fast view, the messages keep to be similar to the last of the
> gist, but the messages in the beginning are not repeating. If it helps
> I have complete compressed log.
>=20
> Then I tried a btrfs recover to get files, but for many files (also
> improtant data, but I filtered the output) I get outputs like in:
> https://gist.github.com/anonymous/1cc7f7ab5af33e76d0bf80960bb300eb
>=20
> Any new suggestions?
>=20


--4lShjtXLIShqQBcGu4ude7w03DqvTuLQ6--

--54cPn5un7WTcuHec3VuvXWCuIo00XIn6b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlotyCgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj+lQgAjLYyHnMGVFJmXKh3QbRvjgPQ
oX4jIu0hu+Tber5rzNCh2gabtcDeSAfaSAkfMmpvhlJtn5GUVFzoQ4iisP+8qSz2
Kn3KBrnC1PByVFcnjfJy4PI/1NUscLnxTVBpFsLYe1yir2Ewzr4xu8bJFz9RDZXL
2InFTL7XOeFWjgFeeMdO10K4vr6ZJJjHOzoG/etuJOp43iBE8+c/XtERYKzGnCa4
+PFpzI09DARUFY2ksaCx8kIme0C/Qcnk9+3ZLg/HZWhGSVZ2sJt9tSvglRo+brrm
O1hgg9NJow5/4VflsIF6BeFlUhqEru1G4kXY6pe1cy1Vl8Ugl0v57oJpoybyKA==
=isJm
-----END PGP SIGNATURE-----

--54cPn5un7WTcuHec3VuvXWCuIo00XIn6b--
