Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B6FC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D230D2087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:22:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D230D2087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbeLDMWO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:22:14 -0500
Received: from mout.gmx.net ([212.227.17.20]:56735 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbeLDMWO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 07:22:14 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M2XkX-1hKCQq0BRF-00sMeN; Tue, 04
 Dec 2018 13:21:59 +0100
Subject: Re: [PATCH 2/9] btrfs-progs: fix gcc8 default build warning caused by
 '-Wformat-truncation'
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Su Yanjun <suyj.fnst@cn.fujitsu.com>
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-3-wqu@suse.com> <20181204111018.GI17773@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <e65ec19d-4e02-3cb5-b85b-8bdf3b8991dd@gmx.com>
Date:   Tue, 4 Dec 2018 20:21:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181204111018.GI17773@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HhY8jMAZj6wVEMxRvzCQhGhyzjEoeMaMS"
X-Provags-ID: V03:K1:RriQ1DVegZH2/lSuPaPXhbRmbN9qMOPi/9K7HZUAB/NOuX9Lotm
 Fg7iItGJmoxwB1fTwGHQz7HQIHadixEFudgK2Bvu7DhrI3EKth9kMH+aY9XJZeqIf5K3phr
 N7svA7teqmHVWfxCaJGVhrMOOVynnV1QOsKxuv/oeBoR8uNwuQrcqfNbjJp+PuwCstbBqwn
 PUJtBYqZQY9dDgWmK1OdA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sdxwNwzQbos=:7urZTj4o5pjrvoNyTQo0+3
 Rn3wsWUJ4svoiowtufSSLGs/Im7X01sLpg401rC/ccMjk5HMvi7zm1raqd9Q0xQ6AwH180uww
 UN+HJ+cq3his8YzosPtCH5zWXbUjQsmy3Ic5MMqhZcRnTad96PmEuhjvY/UNsZ88OY48yuNQN
 vjsEa2tm9cqlkoE+FDBWS2He5hHYXjjdJo8wSlkq/HwCQiTfuoNZ7mijLdpPOuZzSaTuJK/+M
 c5j7JjSusZPeUFLCLvBPVPqniXsbXOel8wLG39dEZe2nb3vV0frtXH4rGGQpG1AeZ/PV63h3L
 x/MARAJlD758xBpqlZ5nMojOhK/zkqRRbhsxM4uh4O3l/naSDD9reRMwMXaxvPPxCq2nrrcs4
 iqKfgWx3RtZzjjjj6fzbB1DsqviwLDc58T+7Qzd3ZcWkGi2lYkJlr5LpxOxu4KRbm/CsxyK7f
 JotXsjQI8a6jwAjeSXOdmUSCSf6Znsb9t/ikoOpVWb3vylsCtqOwTy8HsJv2ZJsp8d6vK/Iy9
 YoSoKaNrcZf3L4Vtp3YxeoTARevGaxsVvxO2e0PKIWethW5K7+v91tbVHBw5t1BrGL7dGmPaj
 uhGU7ut5WvjYJnGAs1/Y/jPlYZY6Hqu5u8EFTyEYynzmkMZsxDZ4NkOwJQOyrrZu0rtTnPOKs
 cFFeXA63ME+gb1MVa6W5oB8XD/8XosEZNRdgc7Jd7qxyjzL9UFxURziDT1WfgFmarETcn3L/F
 JDlPiqwvg6oeJafwfc2zku0YQY8FWYC1F9YUYEpqJ6u2UiEX83WxGcFkIK6/+rYdiCDQjpqIg
 nb1sWFHTc5OG/4se5k1ODdUx+MmVL7WRDOWGhFWiMcZt6m+k/OopAkQm0AhjfH8Bf0HYq77XZ
 wz0fdGjK2BLr09fDhiBfRkqX36nQpDCzy+fWWownpbu/gLjs7RrJydRZ2o13L7
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HhY8jMAZj6wVEMxRvzCQhGhyzjEoeMaMS
Content-Type: multipart/mixed; boundary="NHQXX0VSZkMYtJOPTnFAm5PbXjXNZgDiz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Su Yanjun <suyj.fnst@cn.fujitsu.com>
Message-ID: <e65ec19d-4e02-3cb5-b85b-8bdf3b8991dd@gmx.com>
Subject: Re: [PATCH 2/9] btrfs-progs: fix gcc8 default build warning caused by
 '-Wformat-truncation'
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-3-wqu@suse.com> <20181204111018.GI17773@twin.jikos.cz>
In-Reply-To: <20181204111018.GI17773@twin.jikos.cz>

--NHQXX0VSZkMYtJOPTnFAm5PbXjXNZgDiz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8B=E5=8D=887:10, David Sterba wrote:
> On Fri, Nov 16, 2018 at 03:54:19PM +0800, Qu Wenruo wrote:
>> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>
>> When using gcc8 compiles utils.c, it complains as below:
>>
>> utils.c:852:45: warning: '%s' directive output may be truncated writin=
g
>> up to 4095 bytes into a region of size 4084 [-Wformat-truncation=3D]
>>    snprintf(path, sizeof(path), "/dev/mapper/%s", name);
>>                                              ^~   ~~~~
>> In file included from /usr/include/stdio.h:873,
>>                  from utils.c:20:
>> /usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk'
>> output between 13 and 4108 bytes into a destination of size 4096
>>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,=

>>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=

>>         __bos (__s), __fmt, __va_arg_pack ());
>>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> This isn't a type of warning we care about, particularly when PATH_MAX=

>> is much less than either.
>>
>> Using the GCC option -Wno-format-truncation to disable this for defaul=
t
>> build.
>>
>> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>> [Use cc-disable-warning to fix the not working CFLAGS setting in confi=
gure.ac]
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  Makefile           | 1 +
>>  Makefile.extrawarn | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index f4ab14ea74c8..252299f8869f 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -49,6 +49,7 @@ CSCOPE_CMD :=3D cscope -u -b -c -q
>>  include Makefile.extrawarn
>> =20
>>  EXTRA_CFLAGS :=3D
>> +EXTRA_CFLAGS +=3D $(call cc-disable-warning, format-truncation)
>=20
> Please don't touch EXTRA_CFLAGS, this is for users who want to override=

> any defaults that are set by build. This should go to CFLAGS.
>=20
>>  EXTRA_LDFLAGS :=3D
>> =20
>>  DEBUG_CFLAGS_DEFAULT =3D -O0 -U_FORTIFY_SOURCE -ggdb3
>> diff --git a/Makefile.extrawarn b/Makefile.extrawarn
>> index 5849036fd166..bbb2d5173846 100644
>> --- a/Makefile.extrawarn
>> +++ b/Makefile.extrawarn
>> @@ -53,6 +53,7 @@ warning-1 +=3D -Wold-style-definition
>>  warning-1 +=3D $(call cc-option, -Wmissing-include-dirs)
>>  warning-1 +=3D $(call cc-option, -Wunused-but-set-variable)
>>  warning-1 +=3D $(call cc-disable-warning, missing-field-initializers)=

>> +warning-1 +=3D $(call cc-disable-warning, format-truncation)
>=20
> It's ok to disable for W=3D1 but eg. the W=3D3 level could take all
> previously disabled warnings.

Any guide on the warning disabling?

IMHO the format-truncation used in any snprintf()-like functions are
really more or less expected, just like missing-field-initializers.

THanks,
Qu

>=20
>> =20
>>  warning-2 :=3D -Waggregate-return
>>  warning-2 +=3D -Wcast-align
>> --=20
>> 2.19.1


--NHQXX0VSZkMYtJOPTnFAm5PbXjXNZgDiz--

--HhY8jMAZj6wVEMxRvzCQhGhyzjEoeMaMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwGcVcACgkQwj2R86El
/qgF7wf/SKLgXMj8+A7d0IhGjJ8nDuX8AybpWGt+BgTsQYCukBRFW5YsKqfzIVef
RrUDZbF+sMpf3IFsGUoN8myOQg13GkBZ82/QbmQr4ZT5WmDWidG5nGxPZC+HLZym
6c5AhFM42rBS20f36GbzQXiIjpXrgB0GPabnkCdVVAijVwfpHw0yA4ejZUVr0VV2
pqsVcsjz+5am1IMOhMT9Jjl0OuFwmGUBGBJyNXhC9mCxcOYr98oL9H8YyLBxzHEb
8+VV93IUt7JRzL4yDHqrUSndimkapjkl0iXgroFMaspgtoKDt8CanDvi+3tZqCqq
576G6BiwyBpcwug8EgRNGZNRtGtgFQ==
=g7eQ
-----END PGP SIGNATURE-----

--HhY8jMAZj6wVEMxRvzCQhGhyzjEoeMaMS--
