Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D8CC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 12:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F198C2081C
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 12:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F198C2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbeKIVmc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:42:32 -0500
Received: from mout.gmx.net ([212.227.17.21]:56865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbeKIVmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 16:42:32 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M82zV-1fYT0Q22Ft-00vfHm; Fri, 09
 Nov 2018 13:02:08 +0100
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108131750.27833-1-fdmanana@kernel.org>
 <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
 <e65de2b0-a331-4965-44f7-d7f2fc4ccc79@gmx.com>
 <CAL3q7H5qC9xuf224NP2s8pizf2FULQQyVEJR_bUTS45-v7EC9w@mail.gmail.com>
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
Message-ID: <10b0424b-4e68-e985-6d74-ac4a76cc1f8e@gmx.com>
Date:   Fri, 9 Nov 2018 20:02:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5qC9xuf224NP2s8pizf2FULQQyVEJR_bUTS45-v7EC9w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2SIh3FJ3JLULsvdF68NAkmbQ74XvA8jyK"
X-Provags-ID: V03:K1:FWxkHP7JEsw8+PyilLof7k2I7s40FtpgFciAZjwqsO7U2J3TYEz
 KJCwY1Ts+5fGO/RBoSkHDB1+wsSC0SWL3V+KuBUdSl/YpyYxjDsVh7/ATLrIABB5sfzKRUN
 f1jq3aYLc12KOsLyYAPW+PLJKmGb08LOTTKUeoIs7crON9kWsi8ifCTJy4WFsMen9jbXtKo
 8YY0JlfJBVx84YhQ3Kujg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:g79vHnh/9R8=:KJvu8le0nVPeV/K/ZsJ17w
 CjAG6mJWVExiZCyW/NzTLXl2fhIMfltU97/2BSL/C9tIyD8rU1WqllXxYsq8kMgo4G+c3XDdK
 YELCyQyvrA16g/V6vLpfSxofNxDkZyRHyd5D6VSuadl8L5a18ERs7IQ+FCc/xRIbz5/OYl415
 82ZeHq+xSTfAlKQaSluQmqJeJj9QdILftbxv/JiCEkNox+uWG2I5zl5J/C7kP+4xWTWyumC5m
 C5mAft4lA3zaFybUurQ6l51+HYLQiED/JY4/ngsHEx+22aZtujAExhnxt7+sRQppq0+GSExqr
 Di0t/Fofa7VS9PhNbrN97iGX/DrnjzaiqpQD6ZVFw5bgN4D6o3uMw5PZlPZRi8D77vYreG27p
 4OX7hp29BltXw1/QJMO+A3e8oIGD9DBt7fVwTIIXNcCg22fhBNPx96DsWg5JEhFcUJ+o5iWWu
 KnRSNFVEjyIqxchB7+K/AMBvDZc25VfHoXbtxNfdMA8v/pghNKrll6fU0iAqv9USZGdCgPJ1p
 qVZgWOUmCgaa5dKZg9u0AZH0OQ9jzycOiCbK8dDT80j98ANcLlcGLV91T+etPoNbaPrPOTPD7
 87ztYbng9dwi5i3tkqID6sftX0Iq8eHQGG+UbBhBrk3UBY5//mKRY6OBdoUdHhu78ir+MnOq5
 Hoa8/fTdhIbvdpxiN0t7kafuH3Eks635SFl3+8Zdr+s9w1fmX9ivY6OkiXsaVZi2DUZ60aCwB
 r2MQfdLIz/II6HoGCu8atTk7Rsdbp7P6qaQ7afNMpUNfijRkwlCu5H98JziPAA6SakE5aqIPI
 ofN2DcND12qzYh+EWgnMNOmTAYiZR5ULMZt8sup1/DSZ5H32gnmmeLVq+20uQ3EAUCS44vvjB
 YLBdjkdEAmRY0tm6okRNfxacXvcpqVEDALAtfsRAY7F8NU0JjxZBBX90X6R8mh
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2SIh3FJ3JLULsvdF68NAkmbQ74XvA8jyK
Content-Type: multipart/mixed; boundary="hT3cEGfsgNZOFTJnX08VO68ToGRwUFNT5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <10b0424b-4e68-e985-6d74-ac4a76cc1f8e@gmx.com>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
References: <20181108131750.27833-1-fdmanana@kernel.org>
 <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
 <e65de2b0-a331-4965-44f7-d7f2fc4ccc79@gmx.com>
 <CAL3q7H5qC9xuf224NP2s8pizf2FULQQyVEJR_bUTS45-v7EC9w@mail.gmail.com>
In-Reply-To: <CAL3q7H5qC9xuf224NP2s8pizf2FULQQyVEJR_bUTS45-v7EC9w@mail.gmail.com>

--hT3cEGfsgNZOFTJnX08VO68ToGRwUFNT5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/9 =E4=B8=8B=E5=8D=886:21, Filipe Manana wrote:
> On Fri, Nov 9, 2018 at 12:27 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
>>
>>
>> On 2018/11/8 =E4=B8=8B=E5=8D=8810:48, Filipe Manana wrote:
>>> On Thu, Nov 8, 2018 at 2:37 PM Filipe Manana <fdmanana@kernel.org> wr=
ote:
>>>>
>>>> On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>>>>
>>>>>
>>>>>
>>>>> On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
>>>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>>>
>>>>>> When creating a block group we don't need to set the log for full =
commit
>>>>>> if the new block group is not used for data. Logged items can only=
 point
>>>>>> to logical addresses of data block groups (through file extent ite=
ms) so
>>>>>> there is no need to for the next fsync to fallback to a transactio=
n commit
>>>>>> if the new block group is for metadata.
>>>>>
>>>>> Is it possible for the log tree blocks to be allocated in that new =
block
>>>>> group?
>>>>
>>>> Yes.
>>>
>>> Now I realize what might be your concern, and this would cause troubl=
e.
>>> Surprised this didn't trigger any problem and I had this (together
>>> with other changes) running tests for some weeks already.
>>
>> Maybe it's related metadata chunk pre-allocation so it will be super
>> hard to hit in normal case, or some extent allocation policy preventin=
g
>> us from allocating tree block of newly created bg.
>=20
> No, I don't think we have such kind of policy, would have noticed it
> over the years if we did have one.
> Metadata chunk allocation just happens much less frequently for
> workloads the tests exercised.

Then smaller fs along with 4K nodesize would help, but I'm still not
sure if we could hit such case.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>>>> ---
>>>>>>  fs/btrfs/extent-tree.c | 3 ++-
>>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>>> index 577878324799..588fbd1606fb 100644
>>>>>> --- a/fs/btrfs/extent-tree.c
>>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>>> @@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_tr=
ans_handle *trans, u64 bytes_used,
>>>>>>       struct btrfs_block_group_cache *cache;
>>>>>>       int ret;
>>>>>>
>>>>>> -     btrfs_set_log_full_commit(fs_info, trans);
>>>>>> +     if (type & BTRFS_BLOCK_GROUP_DATA)
>>>>>> +             btrfs_set_log_full_commit(fs_info, trans);
>>>>>>
>>>>>>       cache =3D btrfs_create_block_group_cache(fs_info, chunk_offs=
et, size);
>>>>>>       if (!cache)
>>>>>>
>>>>>
>>


--hT3cEGfsgNZOFTJnX08VO68ToGRwUFNT5--

--2SIh3FJ3JLULsvdF68NAkmbQ74XvA8jyK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvldzoACgkQwj2R86El
/qjJIQf/WjHo+TqUXF96JBR7a0BS9qxmQPvVLYK6y8gcHLL+QR3o5+xGbp/lc0ok
duqZECNJiLaTpZTuMVteKKzKekmG+tp7YnSizqQEeCcgJSNiTsNEsm09dTIs93Ba
J2biTxjG8WYzT9J1RpyQCqtRBJlL1mNj0Sn9ZJsvmxxHE9eqMUd4BbVmwf/FMqYu
+on876MD6c0jWoRUxu5mH2N/w/2jxXyfuc9MffkhbjdtDYmId7RhZZBo4/Dw3ay/
jaii9/NHIdN7RxseQaMV33uS+LUV3YgHHumwC3dgAP8jdyxUBMTQzoppaA5lL8I/
dWbgBsMDhl/HQFnh3spLN9BLXuoWrA==
=88Nd
-----END PGP SIGNATURE-----

--2SIh3FJ3JLULsvdF68NAkmbQ74XvA8jyK--
