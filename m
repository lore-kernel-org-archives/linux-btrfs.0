Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57540 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751800AbdKUBQt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 20:16:49 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
 <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
Date: Tue, 21 Nov 2017 09:16:43 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TKwB7KVAsIQ95RVuAxhXNBWBXWIfw7vBJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TKwB7KVAsIQ95RVuAxhXNBWBXWIfw7vBJ
Content-Type: multipart/mixed; boundary="jFTdXxrJvF69niCBkSGqvgguF7pwVfUAS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
 <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
In-Reply-To: <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>

--jFTdXxrJvF69niCBkSGqvgguF7pwVfUAS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 06:23, Chris Murphy wrote:
> On Sun, Nov 19, 2017 at 7:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8820=E6=97=A5 10:24, Chris Murphy wrote:
>>> On Sun, Nov 19, 2017 at 7:13 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2017=E5=B9=B411=E6=9C=8819=E6=97=A5 14:17, Chris Murphy wrote:
>>>>> fstrim should trim free space, but it only trims unallocated. This =
is
>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>>>>> behaved this way with 4.12 also.
>>>>
>>>> Tested with 4.14-rc7, can't reproduce it.
>>>
>>> $ sudo btrfs fi us /
>>> Overall:
>>>     Device size:          70.00GiB
>>>     Device allocated:          31.03GiB
>>>     Device unallocated:          38.97GiB
>>>     Device missing:             0.00B
>>>     Used:              22.12GiB
>>>     Free (estimated):          47.62GiB    (min: 47.62GiB)
>>> ...snip...
>>>
>>> $ sudo fstrim -v /
>>> /: 39 GiB (41841328128 bytes) trimmed
>>>
>>> Then I run btrfs-debug -b / and find the least used block group, at 8=
% usage;
>>>
>>> block group offset   174202028032 len 1073741824 used   89206784
>>> chunk_objectid 256 flags 1 usage 0.08
>>>
>>> And balance that block group:
>>>
>>> $ sudo btrfs balance start -dvrange=3D174202028032..174202028033 -dli=
mit=3D1 /
>>> Done, had to relocate 1 out of 32 chunks
>>>
>>> And trim again:
>>>
>>> /: 39 GiB (41841328128 bytes) trimmed
>>>
>>>
>>>> Any special mount options or setup?
>>>> (BTW, I also tried space_cache=3Dv2 and default v1, no obvious diffe=
rence)
>>>
>>>
>>> /dev/nvme0n1p8 on / type btrfs
>>> (rw,relatime,seclabel,ssd,space_cache,subvolid=3D333,subvol=3D/root27=
)
>>
>> Nothing special at all.
>>
>> And unfortunately, no trace point inside btrfs_trim_block_group() at a=
ll.
>>
>> But a quick glance shows me that, the loop to iterate existing block
>> groups to trim free space inside them has a return value overwrite bug=
=2E
>>
>> So only unallocated space get trimmed.
>>
>> Would you please try this diff to get the return value?
>>
>> ------
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 309a109069f1..dbec05dc8810 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10983,12 +10983,12 @@ int btrfs_trim_fs(struct btrfs_fs_info
>> *fs_info, struct fstrim_range *range)
>>                                 ret =3D cache_block_group(cache, 0);
>>                                 if (ret) {
>>                                         btrfs_put_block_group(cache);
>> -                                       break;
>> +                                       goto out;
>>                                 }
>>                                 ret =3D wait_block_group_cache_done(ca=
che);
>>                                 if (ret) {
>>                                         btrfs_put_block_group(cache);
>> -                                       break;
>> +                                       goto out;
>>                                 }
>>                         }
>>                         ret =3D btrfs_trim_block_group(cache,
>> @@ -11000,7 +11000,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_inf=
o,
>> struct fstrim_range *range)
>>                         trimmed +=3D group_trimmed;
>>                         if (ret) {
>>                                 btrfs_put_block_group(cache);
>> -                               break;
>> +                               goto out;
>>                         }
>>                 }
>>
>> @@ -11019,6 +11019,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_inf=
o,
>> struct fstrim_range *range)
>>         }
>>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>
>> +out:
>>         range->len =3D trimmed;
>>         return ret;
>>  }
>> ------
>=20
> This won't apply on tag v4.14 for some reason.
>=20
> [chris@f27s linux]$ git apply -v ~/qutrim1.patch
> Checking patch fs/btrfs/extent-tree.c...
> error: while searching for:
>                                ret =3D cache_block_group(cache, 0);
>                                if (ret) {
>                                        btrfs_put_block_group(cache);
>                                        break;
>                                }
>                                ret =3D wait_block_group_cache_done(cach=
e);
>                                if (ret) {
>                                        btrfs_put_block_group(cache);
>                                        break;
>                                }
>                        }
>                        ret =3D btrfs_trim_block_group(cache,
>=20
> error: patch failed: fs/btrfs/extent-tree.c:10983
> error: fs/btrfs/extent-tree.c: patch does not apply
> [chris@f27s linux]$
>=20
>=20
> If I do it manually (just adding the goto and build it, reboot, I
> still get the same result for fstrim and nothing in dmesg.

Sorry, that diff will not output extra info. Just to abort the process
and return true error code.

I have update the patch to output more verbose output.
You could find it in patchwork:
https://patchwork.kernel.org/patch/10065991/

Thanks,
Qu


--jFTdXxrJvF69niCBkSGqvgguF7pwVfUAS--

--TKwB7KVAsIQ95RVuAxhXNBWBXWIfw7vBJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloTfnwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjSCQf8DW+/uBKO1Whk27lI301F8nEd
WjNlQR+TQDqolujO7i2TlVKI8FESkVHkv7KXV1hmLDEz85WkNeKPqf+E3ZY3pxFt
sBAyFYUJfcbKUYsQu0ajoWNSU/F5sQrYPHg6fYjGWuicUKn7dfYqpPg/LDOTjh7I
V/78Zc+5IJOGicnDGgdvHAyytWLrhdlK6exSe/dG6sp2liqjeHbz3u8jER29MckV
tahisi6Tozp5ySIuvv12V1jKYFZotSh54UZF5q8twwzoVMiLlnLURRwresKuu9tw
zp1Yg72fytKDrhch+hO0H1pL7nYYtqICp/z8y3bvV1hcDffNWlPQ9/3VKulN4A==
=Wz5p
-----END PGP SIGNATURE-----

--TKwB7KVAsIQ95RVuAxhXNBWBXWIfw7vBJ--
