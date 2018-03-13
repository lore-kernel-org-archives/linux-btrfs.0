Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54221 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751089AbeCMFE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 01:04:57 -0400
Subject: Re: Btrfs broken in massive transfar
To: MASAKI haruka <yek@reasonset.net>
Cc: linux-btrfs@vger.kernel.org
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
 <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
 <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com>
Date: Tue, 13 Mar 2018 13:04:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lakTBZnXYneJbTBnTIEuulb489ircWMp0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lakTBZnXYneJbTBnTIEuulb489ircWMp0
Content-Type: multipart/mixed; boundary="y2Z3aYIkmsBpKPUY3dFYEQp9Mtju5tQcx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: MASAKI haruka <yek@reasonset.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com>
Subject: Re: Btrfs broken in massive transfar
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
 <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
 <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
In-Reply-To: <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>

--y2Z3aYIkmsBpKPUY3dFYEQp9Mtju5tQcx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 12:19, MASAKI haruka wrote:
> *Now* I tried with Linux 4.14 and 4.15.
> I experienced same probrem and reported in 2014 with Linux 3.9 and 3.10=
=2E (Perchance, actually the kernel was newer than 3.10, anyway I experie=
nced same probrem with old 3.x kernel.)

Then kernel message please.

Especially for the readonly case.

And "btrfs check" output please.

Thanks,
Qu


>=20
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 05:57, MASAKI haruka wrote:
>>> I'm trying to clone 18TiB data between btrfs,
>>> but it will crash anyway.
>>>
>>> This probrem is occured even how to clone (btrfs send/receive, rsync =
or cp.)
>>> I experienced same probrem in Linux 3.9 and Linux 3.10.
>>
>> Did you really mean *3*.9 and *3*.10?
>>
>> That's too old for btrfs usage IIRC.
>>
>> It would be *4*.9 or *4*.10 for a relative new kernel for btrfs.
>>
>> Would you please try some latest mainline kernel again?
>>
>>>
>>> What happen:
>>>
>>> 1. Failed to write because I/O error (read only filesystem)
>>> 2. writing to the btrfs succeeds and fails randomly.
>>> 3. The btrfs unable to unmount (resource is busy.) Unable to umount e=
ven forcely, so cannot halt.
>>>
>>> Example:
>>> ---
>>> mkfile o7784-11-0
>>> rename o7784-11-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1P=
h5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
>>> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK=
3/XDGOWpbx,5zYWEi0L5LHdWBo
>>> truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAo=
IK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw size=3D1073698824
>>> chown .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3=
/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - uid=3D1000, gid=3D10=
00
>>> chmod .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3=
/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - mode=3D0600
>>> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK=
3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
>>> mkfile o7785-12-0
>>> rename o7785-12-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1P=
h5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X
>>> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK=
3/XDGOWpbx,5zYWEi0L5LHdWBo
>>> truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAo=
IK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X size=3D864067592
>>> ERROR: truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYN=
OcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X failed: Inpu=
t/output error
>>> btrfs send 180310235348  0.09s user 11.98s system 16% cpu 1:14.42 tot=
al
>>> ---
>>
>> In that case, we need kernel message to investigate.
>> (And of course, please use at least 4.x kernel)
>>
>> Thanks,
>> Qu
>>
>>>
>>> Tries:
>>> 1.
>>> Connect between host A (btrfs, 4disks) and B with socat (TCP).
>>> Host B write to iSCSI disk (btrfs, single).
>>> clone with btrfs send/receive. Linux 4.15.
>>> -> Crashed at transfarred 1.78TB
>>>
>>> 2.
>>> Delete snapshot and retry.
>>> Connect between host A and B with SSH and socat (UNIX).
>>> Host B write to iSCSI disk (btrfs, single).
>>> clone with btrfs send/receive. Linux 4.15.
>>> -> Crashed at transfarred 90GB
>>>
>>> 3.
>>> Recreate btrfs.
>>> Host A write to iSCSI disk.
>>> clone with btrfs send/receive. Linux 4.15.
>>> -> Crashed at transfarred 260GB
>>>
>>> 4.
>>> Recreate btrfs.
>>> Original disk attach to other computer (having more resource.)
>>> clone with btrfs send/receive. Linux 4.15.
>>> -> Crashed at transfarred 120GB
>>>
>>> 5.
>>> Recreate btrfs.
>>> Clone with rsync. Linux 4.15.
>>> -> Crashed at transfarred 100GB
>>>
>>> 6.
>>> Recreate btrfs.
>>> Try with Linux 4.14, btrfs send/receive.
>>> -> Crashed at transfarred 3.98TB
>>>
>>> 7.
>>> Recreate btrfs.
>>> Connect between host and NAS (iSCSI) with GbE cable directly.
>>> Mounted with options relatime, spase_cache, compress=3Dlzo.
>>> clone with btrfs send/receive. Linux 4.14.
>>> -> Crashed at transfarred 2.13TB
>>>
>>
>=20
>=20


--y2Z3aYIkmsBpKPUY3dFYEQp9Mtju5tQcx--

--lakTBZnXYneJbTBnTIEuulb489ircWMp0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqnW+gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgrxgf+K+jUDQVrOreoV3YRoTPtII7j
TwB3PEC/gUnBaKoFyPHJ2dcmtUvuazcyHoorYY8NFnvQEcUnaWu9r4Ec/yZSLA3l
Lj+z+MsvsdZLvKuBA2htSs2XZCso1jyFXOZCGHrb1XMLuHa/k9EgBpj8hfbOqKGS
ql1T032W4VrVdrIV8QPhfXnMbvM8GSTI2vD6WbAazDWR/HnfLTVMbMnjGNt3TBoN
fjT3XzGwTFxWHT4CLggsIy53VTUx44aH417NRSz8dtCwtpyOvGsPefnYlLrw9Pxb
sXYwaJ2mIpgo48h631S8ZGA3x5Vtsc63bqMQgeIxWlkjVDwscAmrcLoR136qrw==
=gDjF
-----END PGP SIGNATURE-----

--lakTBZnXYneJbTBnTIEuulb489ircWMp0--
