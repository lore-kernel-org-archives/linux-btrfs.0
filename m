Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58590 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbdKTCmb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 21:42:31 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
Date: Mon, 20 Nov 2017 10:42:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k5eKlBtI0NKgoVvNSOrmTI9QWS2qsd60k"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k5eKlBtI0NKgoVvNSOrmTI9QWS2qsd60k
Content-Type: multipart/mixed; boundary="tLOCCtUFPwE7inH149JjNWTFNAsjWgu7e";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>

--tLOCCtUFPwE7inH149JjNWTFNAsjWgu7e
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8820=E6=97=A5 10:24, Chris Murphy wrote:
> On Sun, Nov 19, 2017 at 7:13 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8819=E6=97=A5 14:17, Chris Murphy wrote:
>>> fstrim should trim free space, but it only trims unallocated. This is=

>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>>> behaved this way with 4.12 also.
>>
>> Tested with 4.14-rc7, can't reproduce it.
>=20
> $ sudo btrfs fi us /
> Overall:
>     Device size:          70.00GiB
>     Device allocated:          31.03GiB
>     Device unallocated:          38.97GiB
>     Device missing:             0.00B
>     Used:              22.12GiB
>     Free (estimated):          47.62GiB    (min: 47.62GiB)
> ...snip...
>=20
> $ sudo fstrim -v /
> /: 39 GiB (41841328128 bytes) trimmed
>=20
> Then I run btrfs-debug -b / and find the least used block group, at 8% =
usage;
>=20
> block group offset   174202028032 len 1073741824 used   89206784
> chunk_objectid 256 flags 1 usage 0.08
>=20
> And balance that block group:
>=20
> $ sudo btrfs balance start -dvrange=3D174202028032..174202028033 -dlimi=
t=3D1 /
> Done, had to relocate 1 out of 32 chunks
>=20
> And trim again:
>=20
> /: 39 GiB (41841328128 bytes) trimmed
>=20
>=20
>> Any special mount options or setup?
>> (BTW, I also tried space_cache=3Dv2 and default v1, no obvious differe=
nce)
>=20
>=20
> /dev/nvme0n1p8 on / type btrfs
> (rw,relatime,seclabel,ssd,space_cache,subvolid=3D333,subvol=3D/root27)

Nothing special at all.

And unfortunately, no trace point inside btrfs_trim_block_group() at all.=


But a quick glance shows me that, the loop to iterate existing block
groups to trim free space inside them has a return value overwrite bug.

So only unallocated space get trimmed.

Would you please try this diff to get the return value?

------
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 309a109069f1..dbec05dc8810 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10983,12 +10983,12 @@ int btrfs_trim_fs(struct btrfs_fs_info
*fs_info, struct fstrim_range *range)
                                ret =3D cache_block_group(cache, 0);
                                if (ret) {
                                        btrfs_put_block_group(cache);
-                                       break;
+                                       goto out;
                                }
                                ret =3D wait_block_group_cache_done(cache=
);
                                if (ret) {
                                        btrfs_put_block_group(cache);
-                                       break;
+                                       goto out;
                                }
                        }
                        ret =3D btrfs_trim_block_group(cache,
@@ -11000,7 +11000,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
struct fstrim_range *range)
                        trimmed +=3D group_trimmed;
                        if (ret) {
                                btrfs_put_block_group(cache);
-                               break;
+                               goto out;
                        }
                }

@@ -11019,6 +11019,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
struct fstrim_range *range)
        }
        mutex_unlock(&fs_info->fs_devices->device_list_mutex);

+out:
        range->len =3D trimmed;
        return ret;
 }
------

Thanks,
Qu

>=20
>=20
> Would a strace of fstrim help?
>=20
>=20


--tLOCCtUFPwE7inH149JjNWTFNAsjWgu7e--

--k5eKlBtI0NKgoVvNSOrmTI9QWS2qsd60k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloSQQIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgkMgf/cTwotzx0m5lOfXXryCM9t7tF
2rwZ4Z7Nr2vNTAuzhgYAKgRwxHpUZ+Iizqu7sz+3oWj8tbPk5XbvXBwEYoqnsbqQ
ev9DrLInFdlzAQ4ovYu0Eps0mTOa9IAvsjQ5SXyDOwSQhASiC+q+JFBQ3NZni42Q
tbqtmohiDJKZN6+snuhN0tweC7/svBh6LpVKyL5khAVBhs03yMuaZp2iaastgXFT
Js/gn8ZbqZ0JcZ5hpVrKmzLESc1GGg7/mjTjKl51jHBXFU8/IRSWpEEQcI7PY0oz
YJiCROjnWD6BwaOVOLCgsWbMp5iS5gDV6ZeNRHYqXChKZV6AWI0gY4tiAFPGSA==
=GpYZ
-----END PGP SIGNATURE-----

--k5eKlBtI0NKgoVvNSOrmTI9QWS2qsd60k--
