Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD9FC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08D5F206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfAHLqP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:46:15 -0500
Received: from mout.gmx.net ([212.227.17.22]:41389 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfAHLqO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:46:14 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Mcyxq-1gz3RB25kQ-00ICRA; Tue, 08
 Jan 2019 12:46:04 +0100
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev
 extent
To:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
References: <20190108060818.9517-1-wqu@suse.com>
 <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
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
Message-ID: <4957e8e9-c065-a62e-136d-cda7b5e3b927@gmx.com>
Date:   Tue, 8 Jan 2019 19:45:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v6ARgJJMYXsJzmZoHJTjtk1lYZkm8SB7n"
X-Provags-ID: V03:K1:XxloNdRYqaWd6SLQ1EvQfTE5LmZKd0HhML+hfHFVl5+g2LH83Cf
 gR3enT0AceuKaiRti6aKDE44A3cXElYLcwSrGMv5oCYqZzPf9OtRI4e+1RrKq8fqcmvuqEG
 1DlnwE66dSHGG8fAqkhxbYbQkX/1Kdhrjn7OojVaxg3nazodvB5JBVIk7HBkhcHeIHWtXKN
 luz95d2ahCOij7BPwM5dg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8dGmbdz0vGw=:GocVYc9a8tfBchevJY80uq
 DIu+InY2IihiZ0M1mNB7cOb75RKAQqvcGfgHW73PV6Fi8FdJrhkBcbH0b4ZcJJjZvyMld/xLe
 S5Ammv6UyFIPzZ3xS0hEpbg9WC8htkOiyrP39K0Cd3ipyesWP+sUDeQJ1IP+9Z0/2uNftEDw4
 pC5i4xLu0dy85eBgxfdNv9zanTqN9O6mxtIHe1G9LhpqxnoYRzh6ePF/EtQVPQBj8IYEyxiwR
 aT1uR+xDh/Txbrdhnp+SN81tXd0xe3X1nRbzrrLhWOzrOKed7UIzGSa4pyQYW4QaYOURcSxf/
 pZyQqo8o1qQX4/o8fWqC2AIVczCX8HMqOPFrYkhcBLnDIDImVJnYY91TvwEPAW+bdfxLbDUN9
 KjxMYVEj/buDw+OrEGCRWzbU6dB3lw8vJhCs0KSjSgpGR1gndHfzGXvdHPSQ33ssNWZWgng9n
 Crez2EaqTNz+2GThDwLnS+3TtT+C1/X4Z2shHWGS7J0snxDmkFadhnnCgE8wCGzrpHI+dtBEq
 2ZpWOpKuGbp4aki8lG94LvJ1auT74Xtb+3qp2CV0pSQlAQwJHGark66K4CIemLzHSpmMgch03
 8xj+GEoOklYk1fQ+RcB/QdpCbvTf4gA90gS9VjaV1KocsGBbd+L4iOG2Uy33HT43rxPmsAzcd
 ixsU96BDeDMTid1UN74DYjfnroN/L+gzRqOVXxF3K5iERuMFC3J33WWugEUW5tpsNIgNM0F4o
 o+pezWKHodatuUen5nab/+KAnOsnfe7V4BEXfE2zqjsU66Oat8ivF0Bxbg/DW+7SSrthk8S/C
 03kgMWnXFO6ZXorGtAqi0GvNeEeSKE7rHn6JrHXD/7ZVgj2ymp2YWQnb/2xkbpJ7IzF9BvwVT
 vxGUjjv5uQ0cJkUJ7YuM9cV/hamuEYusgdoK+cf2oN7zATgP7gopRrz9qjV/Yu
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v6ARgJJMYXsJzmZoHJTjtk1lYZkm8SB7n
Content-Type: multipart/mixed; boundary="FgkezBe6e8oTczwz7tQsdjmjNkPPqEWbz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
 Filipe Manana <fdmanana@suse.com>
Message-ID: <4957e8e9-c065-a62e-136d-cda7b5e3b927@gmx.com>
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev
 extent
References: <20190108060818.9517-1-wqu@suse.com>
 <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>
In-Reply-To: <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>

--FgkezBe6e8oTczwz7tQsdjmjNkPPqEWbz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/8 =E4=B8=8B=E5=8D=887:16, Filipe Manana wrote:
> On Tue, Jan 8, 2019 at 6:11 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> [BUG]
>> Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
>> message:
>>
>>   BTRFS error (device dm-6): dev extent devid 1 physical offset 136314=
88 len 8388608 is beyond device boundary 0
>>   BTRFS error (device dm-6): failed to verify dev extents against chun=
ks: -117
>>   BTRFS error (device dm-6): open_ctree failed
>>
>> [CAUSE]
>> Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent=

>> mapping check") introduced strict check on dev extents.
>>
>> We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and
>> only dependent on @devid to find the real device.
>>
>> For seed devices, we call clone_fs_devices() in open_seed_devices() to=

>> allow us search seed devices directly.
>>
>> However clone_fs_devices() just populates devices with devid and dev
>> uuid, without populating other essential members, like disk_total_byte=
s.
>>
>> This makes any device returned by btrfs_find_device(fs_info, devid,
>> NULL, NULL) is just a dummy, with 0 disk_total_bytes, and any dev
>> extents on the seed device will not pass the device boundary check.
>>
>> [FIX]
>> This patch will try to verify the device returned by btrfs_find_device=
()
>> and if it's a dummy then re-search in seed devices.
>>
>> Reported-by: Filipe Manana <fdmanana@suse.com>
>> Fixes: cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent=
 mapping check")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/volumes.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 2576b1a379c9..3e4f8f88353e 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -7825,6 +7825,18 @@ static int verify_one_dev_extent(struct btrfs_f=
s_info *fs_info,
>>                 ret =3D -EUCLEAN;
>>                 goto out;
>>         }
>> +
>> +       /* It's possible this device is a dummy for seed device */
>> +       if (dev->disk_total_bytes =3D=3D 0) {
>> +               dev =3D find_device(fs_info->fs_devices->seed, devid, =
NULL);
>> +               if (!dev) {
>> +                       btrfs_err(fs_info, "failed to find seed devid =
%llu",
>> +                                 devid);
>> +                       ret =3D -EUCLEAN;
>> +                       goto out;
>> +               }
>> +       }
>=20
> Why just not pass the FSID (can be taken from fs_info->super_copy) to
> the previous call to btrfs_find_device()?
> It's a lot simpler.

Then btrfs_find_device() will just return NULL.
We still need to verify the dev extent of the seed device not to exceed
seed device boundary.

What we need is device uuid, however we can't easily get that dev uuid
from dev extent item.

Thanks,
Qu

>=20
>> +
>>         if (physical_offset + physical_len > dev->disk_total_bytes) {
>>                 btrfs_err(fs_info,
>>  "dev extent devid %llu physical offset %llu len %llu is beyond device=
 boundary %llu",
>> --
>> 2.20.1
>>
>=20
>=20


--FgkezBe6e8oTczwz7tQsdjmjNkPPqEWbz--

--v6ARgJJMYXsJzmZoHJTjtk1lYZkm8SB7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw0jXYACgkQwj2R86El
/qhZ8wgAmLBnMxJ0FepNxrvSZmT7aqTuIeDNClQ97B8tHp4vMqDK4mkGLddUKM0J
eHkBdDjXPsHQUPb2iu3aDCPBnS73n4amfOj8a1bt1eXU6TaKUeVynmLi/d5ShTVm
FL+FocIeQHDL7zx5BoLAtelPWCMoTZhBlp5X4Hb9cGqixyn8dQWrR5p2idP9GZS7
4natwXI7wFfvs1pXj7558dS4ww9t+FpAf+0f5UIGpJYmeUIyFOzaQVFgqjvtgo4v
fOyIu4cYKo5ELK/L3IpA2kcYkNdCC4BkVMFKoFqhUV1pLBWLGuzIW9OonMCQpBr0
yhvK32AcTELpyQasPiCo6OF9jSXslA==
=zYVH
-----END PGP SIGNATURE-----

--v6ARgJJMYXsJzmZoHJTjtk1lYZkm8SB7n--
