Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631DDC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 09:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C1220693
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 09:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="N+6zM5wJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfDOJDl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:03:41 -0400
Received: from mout.gmx.net ([212.227.17.22]:48507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfDOJDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 05:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555319016;
        bh=N9GIQ4JRr3L4LmFUW0R1uuP09eoizJbXqXHr1GJdWtQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=N+6zM5wJS2NIEM1fuOjYycE3AkUFR1V1AQAHJq4evBJygWA8h2lyaBMBv18J1QyCT
         bpRSlQz8hxCqvaHK4YgqG8KKov9lR8v/gELg/SCas+BQDRh9dMdfVlc7yJojM2GjEU
         wLT2ZCwK5irC8M3dh36TEqy06iqVZ/H719JMBk/s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LkTSx-1gjuxg30RP-00cN7n; Mon, 15
 Apr 2019 11:03:36 +0200
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190415082900.2023-1-fdmanana@kernel.org>
 <3b22cc0c-7152-8345-e766-d439e9c34d00@gmx.com>
 <CAL3q7H7mt=o=fMYC7YbhQ3Co_w=ESmOjw37v3G4zfoqKj0m3Lw@mail.gmail.com>
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
Message-ID: <bf9e9227-1284-3510-38b9-86db945584e7@gmx.com>
Date:   Mon, 15 Apr 2019 17:03:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7mt=o=fMYC7YbhQ3Co_w=ESmOjw37v3G4zfoqKj0m3Lw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8ktuN0OjXa5rJxEagnU7O6S94Xa7wvKnA"
X-Provags-ID: V03:K1:R0yiAN3fOQOQvnA84nm5L181s686CHJEWUkyFYv+JtJsNzTOv9q
 SAfoalqR48+hQxufuFFR4u10W51dfddosbfbzq3EJMheQsHfYXJFUz78gg5DAmNV+eSL6Q2
 fYLExlKOF9Do9rLC9RgzJ3oB6a2M7dWxzFivw51UmRy4Vn7txy76YSVurcnr2eqgoCJE07k
 6wYosOdI4f1EFiZvpooqw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Kk0w1pgT084=:lie3a5TYryUGFjdb/dK2uR
 +Mg+Y4VA2/9lj1TIqPj1QZQWPZehhqDnVlYi61WOG3BslGF5FfNwz7Uakwu7tRaC+ytB2WVBj
 QYAB3bf4mIjcf7JhFcW6NJ0mdgJWtruqBGovwXWsx3U+Kk6ET2MAf/aOVGDj/HHdC70NyQV8y
 dZ83FRjFFD1Bxi3AColJwFIP8Ai2CHgS0xDATTA2ptYFOG/7MHHwIfUzxblIO/hH7ZRtfqi1y
 WzNJAuDrVdwLF49qSroxqvDyUCUZmNgMB0rqCYURmglsKb1wJuX3j6zFVBWlBcoT9uUfFm02Z
 vu3yGKdR3OXasaX7aTo6uUsdmA9H3gDTn76p+73Huuf4HhX0Tr7w4jmw/SEaGDs5AUwy6dDis
 yFobQUQ+L0KeSEr7lBvbmB76Q7tCa3kv/JATZywdsBiOm9dhbGKFU4MPIJ0iO/l2Y+de4WjIB
 O3kph8H30x6bYmoKJqEQvOrsRzBfkKBolwhggeaPgAL4jptfIyw1YTdBsqWuw69B1bGvw06vp
 4nYZxW1BXDb4j9CvBAbMBBazwxNKTvruQTDEsexRb/wpyjbeN8i77Wj3K8/SyPNlA+h8Ru1MY
 HORjYpMEvzENylKUcWMrEOFA7tVlPdYcFJlYJff2y6LL54tVmS+/2Gosj/JORkd6gYeP1FDqb
 7TC+E8tD9ElhgQxghb8JIPgR94a++60PkEHN6sczjqcdvekVbYMhI07Gu2+PWFb5mPSwCU0MC
 OEzI+Dtb+oGXldz70mEkczJaK2NsYGOR/kslsqwf9kwCnzNmVfqKVvoyxL7KmHaVQ6dFtPC4a
 pcP0bIn0C25LoRSEinVuOravNkRDA0q4cUQ1oURK1l+maIznaWXgt69ZRAcfUH6zdIDhDRDsc
 KwACtVGaYUxcMaWjVZ9xCKhT2CCjfkjbv5MfhnHTN6xOoFFY2U4bzMFzkmS6Rr
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8ktuN0OjXa5rJxEagnU7O6S94Xa7wvKnA
Content-Type: multipart/mixed; boundary="ulcMocJH37zA0vjZMXlNIlfoHqSfPqvlB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <bf9e9227-1284-3510-38b9-86db945584e7@gmx.com>
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
References: <20190415082900.2023-1-fdmanana@kernel.org>
 <3b22cc0c-7152-8345-e766-d439e9c34d00@gmx.com>
 <CAL3q7H7mt=o=fMYC7YbhQ3Co_w=ESmOjw37v3G4zfoqKj0m3Lw@mail.gmail.com>
In-Reply-To: <CAL3q7H7mt=o=fMYC7YbhQ3Co_w=ESmOjw37v3G4zfoqKj0m3Lw@mail.gmail.com>

--ulcMocJH37zA0vjZMXlNIlfoHqSfPqvlB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


[snip]
>>
>> My concern is, if at this timing there is no running transaction, so w=
e
>> continue with trans =3D=3D NULL.
>>
>> But before we continue, some one started a transaction and
>> increased/decreased the extent reference number, this doesn't look as =
safe.
>=20
> So?
>=20
> If an extent is not shared but right before btrfs_check_shared()
> returns it becomes shared? We will report it as not shared.
> It's the same type of "problem".

Well, even if btrfs_check_shared() just return 1 no brain, it won't
cause any problem.
Just make nodatacow not that nodatacow.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
>>
>> Or did I miss something?
>>
>> Thanks,
>> Qu
>>>               trans =3D NULL;
>>>               down_read(&fs_info->commit_root_sem);
>>>       } else {
>>> @@ -1523,6 +1527,7 @@ int btrfs_check_shared(struct btrfs_root *root,=
 u64 inum, u64 bytenr)
>>>       } else {
>>>               up_read(&fs_info->commit_root_sem);
>>>       }
>>> +out:
>>>       ulist_free(tmp);
>>>       ulist_free(roots);
>>>       return ret;
>>>
>>


--ulcMocJH37zA0vjZMXlNIlfoHqSfPqvlB--

--8ktuN0OjXa5rJxEagnU7O6S94Xa7wvKnA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly0SOQACgkQwj2R86El
/qjCqAf/cMzyW9siVRTursrtNTWn3cSa5hG/w7qwH0sXCCG8eXiqE/xeAJJYRC4d
bOEAqTpEFNq7bHKJivvdSZNEPHndikcKkdEXPP7owcCo41QMdO98mA12AZQg6u4u
KpnhIZhp9gQaQ00yS9m8ASCNsjyBQez6gfuCTXCM2SxC3yrszyeOysDOT1i5u4F8
3gpzE+2gLnR9vSOJgCikDAqE+UyivkWX29/9qAR3Y3ZiHsP7B63XZeB/PtDIDpDB
M06lU09eTptiMTONgugPzvlyrhwyFDSTmpc8/WRWt6BoIXktDdv+YavxZ/CEjwG4
VbRANK9uuSKVyeOCkTUVypdhQd20qA==
=YDLd
-----END PGP SIGNATURE-----

--8ktuN0OjXa5rJxEagnU7O6S94Xa7wvKnA--
