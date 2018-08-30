Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:39215 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbeH3GOq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 02:14:46 -0400
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo <wqu@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
 <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
 <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
 <4ada2ba5-0ba9-2e59-470d-5284a013d03a@gmx.com>
 <b4ea89fd-7cb0-6d8e-a60a-d90d3b22d3e0@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f2cc308b-bac4-f352-ffb8-71ea292f8173@gmx.com>
Date: Thu, 30 Aug 2018 10:14:44 +0800
MIME-Version: 1.0
In-Reply-To: <b4ea89fd-7cb0-6d8e-a60a-d90d3b22d3e0@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JewX1m1wu9y0Ot2X5vj6llaRb2VXluMYn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JewX1m1wu9y0Ot2X5vj6llaRb2VXluMYn
Content-Type: multipart/mixed; boundary="hURhMkdpTAxfIIrCsKKM0wzcr6anXsobn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.de>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <f2cc308b-bac4-f352-ffb8-71ea292f8173@gmx.com>
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
 <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
 <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
 <4ada2ba5-0ba9-2e59-470d-5284a013d03a@gmx.com>
 <b4ea89fd-7cb0-6d8e-a60a-d90d3b22d3e0@jp.fujitsu.com>
In-Reply-To: <b4ea89fd-7cb0-6d8e-a60a-d90d3b22d3e0@jp.fujitsu.com>

--hURhMkdpTAxfIIrCsKKM0wzcr6anXsobn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/30 =E4=B8=8A=E5=8D=889:57, Misono Tomohiro wrote:
> On 2018/08/28 14:21, Qu Wenruo wrote:
>> On 2018/8/24 =E4=B8=8B=E5=8D=884:09, Misono Tomohiro wrote:
>> [snip]
>>>>
>>>> BTW, what's the possibility of such problem in your test environment=
?
>>>
>>> It's like one in several times.
>>> It may depend on hardware performance? (the machine is not so fast),
>>>
>>> I also noticed following warning happens too (not always):
>>>
>>
>> After digging into the case, it's more complex than just my patch.
>>
>> Firstly, we lacks a lot of underflow check when modifying bytes_may_us=
e.
>> So we need to do all the underflow detection for every modifier of
>> bytes_may_use.
>>
>> Secondly, btrfs_cross_ref_exist() check makes NODATACOW check in
>> __btrfs_buffered_write() unreliable.
>>
>> For the following case, at __btrfs_buffered_write() time we're pretty
>> sure we could do NODATACOW, but at sync time, due to cloned range,
>> btrfs_cross_ref_exist() would detect reflinked prealloc extent, then
>> falls back to CoW, and finally cause bytes_may_use underflow:
>>
>> ---
>> mkfs.btrfs -f $dev > $full_log
>>
>> mount $dev $mnt -o nospace_cache
>> btrfs quota enable $mnt
>> btrfs quota rescan -w $mnt
>>
>> xfs_io -f -c "falloc 0 2M" $mnt/file1 > /dev/null
>> xfs_io -c "pwrite -b 1M 0 1M" $mnt/file1 > /dev/null
>> xfs_io -c "reflink $mnt/file1 1M 4M 1M" $mnt/file1 > /dev/null
>> sync
>> ----
>=20
> Thanks for the explanation. I will try to understand the relevant code.=


Feel free to ask if there is anything I forgot to explain.

>=20
>>
>> Even without my patch, the "pwrite" command is still CoWed, which coul=
d
>> be avoided.
>> And that's the reason my patch is causing the underflow.
>>
>> To fix this, we need more accurate btrfs_cross_ref_exist() check, not
>> only for @disk_bytenr but also check @len.
>>
>> Or we could try to flush the whole inode in clone_range() so we could =
go
>> through NOCOW routine before clone really happens.
>=20
> So as your RFC patch does not work, the option is first one?

Yes, and it may be more complex to do that, while even fixed we could
only get diminishing return.

Thanks,
Qu

>=20
> Thanks,
> Misono
>=20
>>
>> Thanks,
>> Qu
>>
>=20


--hURhMkdpTAxfIIrCsKKM0wzcr6anXsobn--

--JewX1m1wu9y0Ot2X5vj6llaRb2VXluMYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluHUxQACgkQwj2R86El
/qgoRAgAgV4mcTRsF7xWZpkiCrZqiHmq0hl9y/qnJommoT7f89D1bQfuAnKX3yEx
Js2mGXVCkeMpuQLLqFsOIqVPuwZaaqBXkQv4B/yzDCJ7xum9wGd6z6vq3B646mkE
4SLcnaMWc8v0DDKGX0BXHTApD86zMw2cROm/SEKQiGmNgra4+TornQPUKKy8tAgg
M/cMgZaV1EquAezLIKvx+rm6QVWx8/PKz6cYNsQu5v4/yfrlz6hie0+1M6wOCife
YZJXym3g/2ueHkQva5x8822dBe/LztQ6kERGO0emgM+d1RxZ+MhE/wlqBIsG+6nN
VKs215x+FpE6YppkAJJeTsuyq8EPXQ==
=UD0m
-----END PGP SIGNATURE-----

--JewX1m1wu9y0Ot2X5vj6llaRb2VXluMYn--
