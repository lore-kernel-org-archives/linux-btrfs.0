Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61939 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752330AbdKUE3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 23:29:30 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
 <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
 <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com>
Date: Tue, 21 Nov 2017 12:29:24 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f6EVdbUss6DtGAub2xRbTeKVfdheuJikr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f6EVdbUss6DtGAub2xRbTeKVfdheuJikr
Content-Type: multipart/mixed; boundary="ctsPUEpHmehDqnip1pFBentc0hMeCQXJa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
 <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
 <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
In-Reply-To: <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>

--ctsPUEpHmehDqnip1pFBentc0hMeCQXJa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 12:06, Chris Murphy wrote:
> On Mon, Nov 20, 2017 at 6:16 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 06:23, Chris Murphy wrote:
>>> On Sun, Nov 19, 2017 at 7:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2017=E5=B9=B411=E6=9C=8820=E6=97=A5 10:24, Chris Murphy wrote:
>>>>> On Sun, Nov 19, 2017 at 7:13 PM, Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>>>>>>
>>>>>>
>>>>>> On 2017=E5=B9=B411=E6=9C=8819=E6=97=A5 14:17, Chris Murphy wrote:
>>>>>>> fstrim should trim free space, but it only trims unallocated. Thi=
s is
>>>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it=

>>>>>>> behaved this way with 4.12 also.
>>>>>>
>>>>>> Tested with 4.14-rc7, can't reproduce it.
>>>>>
>>>>> $ sudo btrfs fi us /
>>>>> Overall:
>>>>>     Device size:          70.00GiB
>>>>>     Device allocated:          31.03GiB
>>>>>     Device unallocated:          38.97GiB
>>>>>     Device missing:             0.00B
>>>>>     Used:              22.12GiB
>>>>>     Free (estimated):          47.62GiB    (min: 47.62GiB)
>>>>> ...snip...
>>>>>
>>>>> $ sudo fstrim -v /
>>>>> /: 39 GiB (41841328128 bytes) trimmed
>>>>>
>>>>> Then I run btrfs-debug -b / and find the least used block group, at=
 8% usage;
>>>>>
>>>>> block group offset   174202028032 len 1073741824 used   89206784
>>>>> chunk_objectid 256 flags 1 usage 0.08
>>>>>
>>>>> And balance that block group:
>>>>>
>>>>> $ sudo btrfs balance start -dvrange=3D174202028032..174202028033 -d=
limit=3D1 /
>>>>> Done, had to relocate 1 out of 32 chunks
>>>>>
>>>>> And trim again:
>>>>>
>>>>> /: 39 GiB (41841328128 bytes) trimmed
>>>>>
>>>>>
>>>>>> Any special mount options or setup?
>>>>>> (BTW, I also tried space_cache=3Dv2 and default v1, no obvious dif=
ference)
>>>>>
>>>>>
>>>>> /dev/nvme0n1p8 on / type btrfs
>>>>> (rw,relatime,seclabel,ssd,space_cache,subvolid=3D333,subvol=3D/root=
27)
>>>>
>>>> Nothing special at all.
>>>>
>>>> And unfortunately, no trace point inside btrfs_trim_block_group() at=
 all.
>>>>
>>>> But a quick glance shows me that, the loop to iterate existing block=

>>>> groups to trim free space inside them has a return value overwrite b=
ug.
>>>>
>>>> So only unallocated space get trimmed.
>>>>
>>>> Would you please try this diff to get the return value?
>>>>
>>>> ------
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 309a109069f1..dbec05dc8810 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -10983,12 +10983,12 @@ int btrfs_trim_fs(struct btrfs_fs_info
>>>> *fs_info, struct fstrim_range *range)
>>>>                                 ret =3D cache_block_group(cache, 0);=

>>>>                                 if (ret) {
>>>>                                         btrfs_put_block_group(cache)=
;
>>>> -                                       break;
>>>> +                                       goto out;
>>>>                                 }
>>>>                                 ret =3D wait_block_group_cache_done(=
cache);
>>>>                                 if (ret) {
>>>>                                         btrfs_put_block_group(cache)=
;
>>>> -                                       break;
>>>> +                                       goto out;
>>>>                                 }
>>>>                         }
>>>>                         ret =3D btrfs_trim_block_group(cache,
>>>> @@ -11000,7 +11000,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_i=
nfo,
>>>> struct fstrim_range *range)
>>>>                         trimmed +=3D group_trimmed;
>>>>                         if (ret) {
>>>>                                 btrfs_put_block_group(cache);
>>>> -                               break;
>>>> +                               goto out;
>>>>                         }
>>>>                 }
>>>>
>>>> @@ -11019,6 +11019,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_i=
nfo,
>>>> struct fstrim_range *range)
>>>>         }
>>>>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>>>
>>>> +out:
>>>>         range->len =3D trimmed;
>>>>         return ret;
>>>>  }
>>>> ------
>>>
>>> This won't apply on tag v4.14 for some reason.
>>>
>>> [chris@f27s linux]$ git apply -v ~/qutrim1.patch
>>> Checking patch fs/btrfs/extent-tree.c...
>>> error: while searching for:
>>>                                ret =3D cache_block_group(cache, 0);
>>>                                if (ret) {
>>>                                        btrfs_put_block_group(cache);
>>>                                        break;
>>>                                }
>>>                                ret =3D wait_block_group_cache_done(ca=
che);
>>>                                if (ret) {
>>>                                        btrfs_put_block_group(cache);
>>>                                        break;
>>>                                }
>>>                        }
>>>                        ret =3D btrfs_trim_block_group(cache,
>>>
>>> error: patch failed: fs/btrfs/extent-tree.c:10983
>>> error: fs/btrfs/extent-tree.c: patch does not apply
>>> [chris@f27s linux]$
>>>
>>>
>>> If I do it manually (just adding the goto and build it, reboot, I
>>> still get the same result for fstrim and nothing in dmesg.
>>
>> Sorry, that diff will not output extra info. Just to abort the process=

>> and return true error code.
>=20
> OK? It didn't seem to do that either. I see no change.
>=20
>=20
>>
>> I have update the patch to output more verbose output.
>> You could find it in patchwork:
>> https://patchwork.kernel.org/patch/10065991/
>=20
> Patch applies on v4.14.0, and still nothing in dmesg, or in user space
> when issuing fstrim.
>=20
> # fstrim -v /
> /: 38 GiB (40767586304 bytes) trimmed
> # dmesg | grep -i btrfs
> [    2.745902] btrfs: loading out-of-tree module taints kernel.
> [    2.749905] Btrfs loaded, crc32c=3Dcrc32c-intel
> [    2.751072] BTRFS: device label fedora devid 1 transid 252048 /dev/n=
vme0n1p8
> [    4.295891] BTRFS info (device nvme0n1p8): disk space caching is ena=
bled
> [    4.295892] BTRFS info (device nvme0n1p8): has skinny extents
> [    4.307326] BTRFS info (device nvme0n1p8): enabling ssd optimization=
s
> [    4.959467] BTRFS info (device nvme0n1p8): disk space caching is ena=
bled
> [root@f27h ~]#
>=20
>=20
> Pretty sure the patch is applied because of the first message about
> the out of tree module, which I do not get with Fedora kernels.

So that's not something wrong happened to make you skip trimming one
chunk, but something else just skipped the block group trimming.

And I don't think DEBUG config is related to this.

I doubt if it's the @fstrim_range passed in has something strange that
prevent us from trimming block groups.

Would you please try this diff based on the patch from patchwork?

------
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f830aa91ac3d..a4bf29a4a860 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10972,6 +10972,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
struct fstrim_range *range)
        int dev_ret =3D 0;
        int ret =3D 0;

+       btrfs_info(fs_info, "trimming btrfs, start=3D%llu len=3D%llu
minlen=3D%llu",
+                  range->start, range->len, range->minlen);
        /*
         * try to trim all FS space, our block group may start from
non-zero.
         */
@@ -10981,6 +10983,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
struct fstrim_range *range)
                cache =3D btrfs_lookup_block_group(fs_info, range->start)=
;

        for (; cache; cache =3D next_block_group(fs_info, cache)) {
+               btrfs_info(fs_info, "bg start=3D%llu len=3D%llu",
+                          cache->key.objectid, cache->key.offset);
                if (cache->key.objectid >=3D (range->start + range->len))=
 {
                        btrfs_put_block_group(cache);
                        break;
@@ -11045,6 +11049,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
struct fstrim_range *range)
        mutex_unlock(&fs_info->fs_devices->device_list_mutex);

        range->len =3D trimmed;
+       btrfs_info(fs_info, "trimming done");
        if (bg_ret)
                return bg_ret;
        return dev_ret;

------

Thanks,
Qu


--ctsPUEpHmehDqnip1pFBentc0hMeCQXJa--

--f6EVdbUss6DtGAub2xRbTeKVfdheuJikr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloTq6QXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh/8Af/bRkPKdUYW87ItkCOQmDYznOA
YBRbOBrWPyDuODh/l+dcwvf7LwcqjpwaqscaVe3uHLSa8E0zuhQz8710w3T2Fp3o
p05hZE2HN+H04vd5b2eF6+gI3DYxGQopY4DfsV8ZXW+sNfO7bFfHDvkSECCD1YAC
evugrsGyRWwfTkZnwXkXLCYwP/mpaQk5Nky9lsjMmnphiOzIOJtj3IO0rtJnnvmo
MgdNP0yMaZMJBw+XyCX0ZeLafuMK3K9g0/fiJ9rOb3N89DY4OsNN/xxw1pY23tR+
b6YBdBR26N2AkeCybKZfyETmknf4HfDAAIvZ/XlOvEL+AKbHz5GOS4Ohw3P6ZA==
=xc5/
-----END PGP SIGNATURE-----

--f6EVdbUss6DtGAub2xRbTeKVfdheuJikr--
