Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36944 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751529AbcJOW2c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 18:28:32 -0400
Date: Sat, 15 Oct 2016 18:28:30 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
Message-ID: <20161015222830.GB21290@hungrycats.org>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
 <CAJCQCtRQpDiHh4bnm5H0dVkCt+JNLYBu23O_Z6ddpo550e2ngw@mail.gmail.com>
 <57FDAF92.8040707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ATYltwmfWCpDp8Ax"
In-Reply-To: <57FDAF92.8040707@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ATYltwmfWCpDp8Ax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 11:35:46AM +0800, Wang Xiaoguang wrote:
> hi,
>=20
> On 10/11/2016 11:49 PM, Chris Murphy wrote:
> >On Tue, Oct 11, 2016 at 12:47 AM, Wang Xiaoguang
> ><wangxg.fnst@cn.fujitsu.com> wrote:
> >>If we use mount option "-o max_inline=3Dsectorsize", say 4096, indeed
> >>even for a fresh fs, say nodesize is 16k, we can not make the first
> >>4k data completely inline, I found this conditon causing this issue:
> >>   !compressed_size && (actual_end & (root->sectorsize - 1)) =3D=3D 0
> >>
> >>If it retuns true, we'll not make data inline. For 4k sectorsize,
> >>0~4094 dara range, we can make it inline, but 0~4095, it can not.
> >>I don't think this limition is useful, so here remove it which will
> >>make max inline data can be equal to sectorsize.
> >>
> >>Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> >>---
> >>  fs/btrfs/inode.c | 2 --
> >>  1 file changed, 2 deletions(-)
> >>
> >>diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >>index ea15520..c0db393 100644
> >>--- a/fs/btrfs/inode.c
> >>+++ b/fs/btrfs/inode.c
> >>@@ -267,8 +267,6 @@ static noinline int cow_file_range_inline(struct bt=
rfs_root *root,
> >>         if (start > 0 ||
> >>             actual_end > root->sectorsize ||
> >>             data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
> >>-           (!compressed_size &&
> >>-           (actual_end & (root->sectorsize - 1)) =3D=3D 0) ||
> >>             end + 1 < isize ||
> >>             data_len > root->fs_info->max_inline) {
> >>                 return 1;
> >>--
> >>2.9.0
> >
> >Before making any further changes to inline data, does it make sense
> >to find the source of corruption Zygo has been experiencing? That's in
> >the "btrfs rare silent data corruption with kernel data leak" thread.
> Yes, agree.
> Also Zygo has sent a patch to fix that bug this morning :)

FWIW I don't see any connection between this and the problem I found.
A page-sized inline extent wouldn't have any room for uninitialized
bytes.  If anthing, it's the one rare case that already worked.  ;)

> Regards,
> XIaoguang Wang
>=20
> >
> >
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ATYltwmfWCpDp8Ax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgCrY4ACgkQgfmLGlazG5wsLQCgybT3wk+cOBbcSTSNW38zTQEv
kk0AoNEIPbLpZVV6KEQnV+lD4fUgK5Xj
=M5mx
-----END PGP SIGNATURE-----

--ATYltwmfWCpDp8Ax--
