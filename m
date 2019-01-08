Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3337C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 13:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3523206B6
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 13:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfAHNTg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:19:36 -0500
Received: from mout.gmx.net ([212.227.17.20]:58759 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfAHNTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 08:19:36 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIPhr-1ginE800Cd-0048Uq; Tue, 08
 Jan 2019 14:19:28 +0100
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev
 extent
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
References: <20190108060818.9517-1-wqu@suse.com>
 <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>
 <4957e8e9-c065-a62e-136d-cda7b5e3b927@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <8f2ab7c5-deb7-30d3-0900-7068a3c26d67@gmx.com>
Date:   Tue, 8 Jan 2019 21:19:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4957e8e9-c065-a62e-136d-cda7b5e3b927@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KydCIRcr4q8EdCmSt2zOhQRp4ZbfuAKPF"
X-Provags-ID: V03:K1:2AS5NoFNvJIGiVECusziEGBk36SlW3f9+SkzixwABa7tQxPtaas
 z9Vql2PVTLPtRJwHpm4YT/+yVP+YMHuQXKDlnf85L1QWLKl/IMl4x/bZLj34k3N4hqnRLs5
 5BYj2djMTIdWVpTJ7hFBogc00ffrj9jIPClsH7ZaqNwcyIYtSpV3QBnoVgwBdO4BMzo0gdD
 po5P+T0NIGm0p43bb79Sg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bGBPOcKgPEw=:+rAPHbNBg54FaA6Md/Ispk
 Gcy+9FB3kfzLA6yJO+vmvSP6PZ8pX5FL4Lf0ongYQRpKD69FxWeUAziJslFd85GKbE52IqyOU
 CzZWu4OlZVbgb3yS4nl9AR3kmRUpOOJOBqQgw24VvNWHsjfqNeMmFI/kzyBn42ePouAbWanrS
 UuyEZg4vA4/KVYL37+sMS1CfwRcy0wQ1V++mqzVdFvhJpT8XAx1uwWeYJ46Cdt1f/11Q7tbhF
 lr2iA9JhgfYUd+s/pj1K0ApS+7YSt7PyHvqEQ8Mor6x1+eLnslE5L4idF45JEEWAPeGhOF1y1
 I3syhairRptuIGcTXO0JROImahzQsybljrqjpMsagrSIa8HFsJLDZaG/DuIVym+BnyiMQdXUc
 qtpQZz9CzEI92mzDmM1E50WPew/h+aDBRqtQrQCnGTj1DJr1AqdniN3IDBp4FiAa0Bmeccvry
 RfZOjG/mX2BlkolX3XJj0m5Fw8u2C83XlGE2Dobvxx3yWk/SQouOFiMgH1jQyUlKRStl5ekZ0
 kamD7Xdt1dtM6dI55h3tMM68VR0UeZHD8CcTxfDAef15IozuVk6Z5lGSIW/G1KLr9FL7XpNP3
 PYA4wnlQiXh4IYtNf/t/JunDSD1KCpdienocY864baFLDPmtWHZJd/TXpVzW+ewI2Fx7IIZbo
 UMVDs7UMCAcebdAnqKgoTVJ8ZuBfm7C0DKL9qc0Cd4Iif/l4gyvOyF8W4N0dBlSictaLo3CvC
 ZJXG90SVTwFVpcZhBOr1SqAZE53E/lF39wBdb45nDgnygoLdFFXfYQzkXYB6qp4v3rP7RxHH9
 /oMqxLSafRSdBnxJlCHarD7nR4ARn2J3jO2njTW/ghTsdWMJlIWA9aRGrNYB9HBMEbxka8vlW
 xDTbCBirmu7FUQJVnfsVU4fwY33J2CRMG3KV44+ymlo5eQXMqaknlZJ/0q63AF
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KydCIRcr4q8EdCmSt2zOhQRp4ZbfuAKPF
Content-Type: multipart/mixed; boundary="PHwbiF389HSTo17tlvEbzoYBNNGG7KmWP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
 Filipe Manana <fdmanana@suse.com>
Message-ID: <8f2ab7c5-deb7-30d3-0900-7068a3c26d67@gmx.com>
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev
 extent
References: <20190108060818.9517-1-wqu@suse.com>
 <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>
 <4957e8e9-c065-a62e-136d-cda7b5e3b927@gmx.com>
In-Reply-To: <4957e8e9-c065-a62e-136d-cda7b5e3b927@gmx.com>

--PHwbiF389HSTo17tlvEbzoYBNNGG7KmWP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/8 =E4=B8=8B=E5=8D=887:45, Qu Wenruo wrote:
>=20
>=20
> On 2019/1/8 =E4=B8=8B=E5=8D=887:16, Filipe Manana wrote:
>> On Tue, Jan 8, 2019 at 6:11 AM Qu Wenruo <wqu@suse.com> wrote:
>>>
>>> [BUG]
>>> Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
>>> message:
>>>
>>>   BTRFS error (device dm-6): dev extent devid 1 physical offset 13631=
488 len 8388608 is beyond device boundary 0
>>>   BTRFS error (device dm-6): failed to verify dev extents against chu=
nks: -117
>>>   BTRFS error (device dm-6): open_ctree failed
>>>
>>> [CAUSE]
>>> Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev exten=
t
>>> mapping check") introduced strict check on dev extents.
>>>
>>> We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and=

>>> only dependent on @devid to find the real device.
>>>
>>> For seed devices, we call clone_fs_devices() in open_seed_devices() t=
o
>>> allow us search seed devices directly.
>>>
>>> However clone_fs_devices() just populates devices with devid and dev
>>> uuid, without populating other essential members, like disk_total_byt=
es.
>>>
>>> This makes any device returned by btrfs_find_device(fs_info, devid,
>>> NULL, NULL) is just a dummy, with 0 disk_total_bytes, and any dev
>>> extents on the seed device will not pass the device boundary check.
>>>
>>> [FIX]
>>> This patch will try to verify the device returned by btrfs_find_devic=
e()
>>> and if it's a dummy then re-search in seed devices.
>>>
>>> Reported-by: Filipe Manana <fdmanana@suse.com>
>>> Fixes: cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev exten=
t mapping check")
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/volumes.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 2576b1a379c9..3e4f8f88353e 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -7825,6 +7825,18 @@ static int verify_one_dev_extent(struct btrfs_=
fs_info *fs_info,
>>>                 ret =3D -EUCLEAN;
>>>                 goto out;
>>>         }
>>> +
>>> +       /* It's possible this device is a dummy for seed device */
>>> +       if (dev->disk_total_bytes =3D=3D 0) {
>>> +               dev =3D find_device(fs_info->fs_devices->seed, devid,=
 NULL);
>>> +               if (!dev) {
>>> +                       btrfs_err(fs_info, "failed to find seed devid=
 %llu",
>>> +                                 devid);
>>> +                       ret =3D -EUCLEAN;
>>> +                       goto out;
>>> +               }
>>> +       }
>>
>> Why just not pass the FSID (can be taken from fs_info->super_copy) to
>> the previous call to btrfs_find_device()?
>> It's a lot simpler.
>=20
> Then btrfs_find_device() will just return NULL.
> We still need to verify the dev extent of the seed device not to exceed=

> seed device boundary.

OK, it's not the case. Even we can pass correct dev uuid into
btrfs_find_device(), it will still give us the dummy device, with 0
disk_total_bytes.

The problem is, we have a screwed up fs_info->fs_devices for seed device
from the very beginning.

For a seeding fs, devid 1 is seed device and devid 2 is real rw device.
Then our fs_devices looks like:

fs_info->fs_devices
|- devices
|  |- devid 1
|  |  dummy, devid 1 dev uuid, any else is unpopulated
|  |  created by open_seed_devices()-> clone_fs_devices()
|  |- devid 2
|     real one, devid 2 dev uuid, everything is good
|- seeding
   |- devices
      |- devid 1
         real seed device.

So, at btrfs_find_device() call time, we must pass the *seeding* fsid,
to locate the real seed device.
Or we can only get a dummy.

This patch is just a quick and dirty fix.

The correct way to fix is to not screw up fs_devices any more with such
meaningless dummy in fs_devices.
Especially when btrfs_find_device() has already handled such case.

I don't understand why we do such meaningless clone_fs_devices() call,
but I don't think the proper fix may catch the v5.0 window.

Thanks,
Qu


>=20
> What we need is device uuid, however we can't easily get that dev uuid
> from dev extent item.
>=20
> Thanks,
> Qu
>=20
>>
>>> +
>>>         if (physical_offset + physical_len > dev->disk_total_bytes) {=

>>>                 btrfs_err(fs_info,
>>>  "dev extent devid %llu physical offset %llu len %llu is beyond devic=
e boundary %llu",
>>> --
>>> 2.20.1
>>>
>>
>>
>=20


--PHwbiF389HSTo17tlvEbzoYBNNGG7KmWP--

--KydCIRcr4q8EdCmSt2zOhQRp4ZbfuAKPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw0o1gACgkQwj2R86El
/qg9nAf/XLFrayMfUjJwhAypBsQruPmW4XRPyDJWSR6uC80MgsjftSDim87RFuDh
qLNOcUPsM61rvFadB75UR12DL1H1c6nxAdzddRUZNlJO8hFxdS9xBrCFdsrQuoef
Y92AGEHYE6Rb3MXptDTClkEYHXvFPrjL6vT9W0CyBU+YYGrsxbQhvjo2MObfXPPm
L/g0eBefHl2A5ShvoTfrKvtgGW9Xs0uhKwv2nGMBxiK/fVi8LVVYSL7nRquzh1Ik
43HMz2Iqz/9KGpHdB5J+emsUrZgO/pmz8g2Ly1oygikRXSZDGjG/2GUVkbz/byVn
393Ns8B55XBuFz1/wmh9v6Jjmco8cg==
=PfoS
-----END PGP SIGNATURE-----

--KydCIRcr4q8EdCmSt2zOhQRp4ZbfuAKPF--
