Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E31C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 12:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80AA72171F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 12:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfCMMD0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:03:26 -0400
Received: from mout.gmx.net ([212.227.15.18]:52019 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfCMMD0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 08:03:26 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LgIWi-1gixRk3YLk-00nh1E; Wed, 13
 Mar 2019 13:02:57 +0100
Subject: Re: [PATCH v5.1 10/12] btrfs: extent_io: Kill the BUG_ON() in
 extent_write_cache_pages()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-11-wqu@suse.com> <20190312003330.GY31119@twin.jikos.cz>
 <c327b20b-eb97-d1bf-6763-cf4df795f9f0@suse.de>
 <20190313113149.GB31119@twin.jikos.cz>
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
Message-ID: <1e89056b-08d0-fcd7-4586-09664e842193@gmx.com>
Date:   Wed, 13 Mar 2019 20:02:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190313113149.GB31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IyPEKH838AzcVxA9vX6I3KFLYSMlVnRgb"
X-Provags-ID: V03:K1:MPF0jZApgvEkD46FnVlMgXFrb7K1bsqcMnyo0Z+uZwr7Wgsn7Qp
 TV4H25QX0+VXGzMGsRghwdS7Lu3aExDNpe+qYzTokPrUBfFXGvwT+DPj4Gn/jCAgRzP4Yan
 v4nqJy6IkPScqVTiMTKRY+cXK4wihELizp0Uatzbi6OhT5Lll+c0XIoufHFlyoe5JU4RfpP
 wagXylfd+6E6hxLDnVtew==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aRQ4az+38Ao=:GTv6NuFbk956JNlCLqm/ZU
 +opdjLci+9rKXk1ozAACOmEzzjepbuz9NDSrHXpvIzW2fRPD+Ss7QF3AivEvHpKmLftu3xmQ0
 yZTF6MO503LL0JsyHMfei0N4/4Sr5cZwePlvZI98OfSjpnAR/BOwLQ5FCKQjfF8vYHsEZt9QL
 QTl/P0twMHtR+8506cUFpYie6+2t8rBWYDdAzbbO0YOGevqS4T+NZpiP/Wf9nfpspTndy1cQ4
 63bza46ehtMk7dsmJiU/CU8gUda7gpiaQNJayNzLCC5ZPGJSfKC4L6PTMCFmfvW1qRMFhYTe9
 UC5/yuilw+riNdRwsjpxwXTFHg8+pV+BsBXOR0HRYutq7TC/lv6svWl6OuOl6aAMZZZ5yZdeV
 3FtFYfNG6GU8cykXnDYnXCDreGWqDTiluhHQMq4CwRkxEAUHIRfirsOTWe1myJLCwMs6KhVFx
 nN1CWgPbgPQ0KSRn0V6Spc6LIO3y0KyeXaBgexpoXU8G7DM1sWvcH4dqT6jygGxEiZ/lykKZQ
 cvRTraPuHDSXGu/E8w7b2CVDU4GVC4QhyxiPrhm2Sqo1dgCsLuMhqTZBqTKpPDXCbTE6kRi3x
 LSUGvOkhzZ1/IhkVF//qzP20DJVfIGq9UkbnGeqV2Z3ylFN+Mz0towmm1H5o4EXNmMX6kmiAV
 SvoG4Zrq6aKR5w67azK3GD3xLpWaxMpaY/Ti1Sepw06lt2s10ZIGjCBtIbCF1imt3SR0aqLW8
 4EYkd1Pb8iyV1CorlFr09qv9957eTVQzI8mt+EqYBTis86QQWp9icxALWreSGDOrEQlkyyt/t
 pEdNyd1mZmnVp5iCt9RfWhP71kULspP/U/kvwDl4+o9JsAgXZOU27jyD9sEWATuyQrsGMX4aL
 smk0efxBS2xVATO4W3/oOWZZP+b8ocgUrrcegLUzNN3Rq8f+0bPGC0csjAKBx1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IyPEKH838AzcVxA9vX6I3KFLYSMlVnRgb
Content-Type: multipart/mixed; boundary="hluFxdSehCDVRUPZM6cKc2wJU4UB69BlG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <1e89056b-08d0-fcd7-4586-09664e842193@gmx.com>
Subject: Re: [PATCH v5.1 10/12] btrfs: extent_io: Kill the BUG_ON() in
 extent_write_cache_pages()
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-11-wqu@suse.com> <20190312003330.GY31119@twin.jikos.cz>
 <c327b20b-eb97-d1bf-6763-cf4df795f9f0@suse.de>
 <20190313113149.GB31119@twin.jikos.cz>
In-Reply-To: <20190313113149.GB31119@twin.jikos.cz>

--hluFxdSehCDVRUPZM6cKc2wJU4UB69BlG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/13 =E4=B8=8B=E5=8D=887:31, David Sterba wrote:
> On Tue, Mar 12, 2019 at 08:42:12AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/3/12 =E4=B8=8A=E5=8D=888:33, David Sterba wrote:
>>> On Mon, Feb 18, 2019 at 01:27:51PM +0800, Qu Wenruo wrote:
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>>>> ---
>>>>  fs/btrfs/extent_io.c | 10 ++++++++--
>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>>> index 1572e892ec7b..480e138051f0 100644
>>>> --- a/fs/btrfs/extent_io.c
>>>> +++ b/fs/btrfs/extent_io.c
>>>> @@ -3998,7 +3998,10 @@ static int extent_write_cache_pages(struct ad=
dress_space *mapping,
>>>>  			 */
>>>>  			if (!trylock_page(page)) {
>>>>  				ret =3D flush_write_bio(epd);
>>>> -				BUG_ON(ret < 0);
>>>> +				if (ret < 0) {
>>>
>>> This needs some more explanation why it's correct, there's conditiona=
l
>>> locking and writeback status manipulation. Thanks.
>>
>> Because flush_write_bio() handles the cleanup in its endio function.
>>
>> Thus we don't need extra cleanup in this case.
>=20
> Non-trivial changes need changelog, that's nothing new. Especially for
> error handling you have to provide a proof that things don't get broken=
=2E
>=20
> If you spend a week working on the code, everything is trivial, but onl=
y
> for you and for a short period of time. That's why we need good
> changelogs that make sense to other people and after a long period of
> time. Thanks.

That completely makes sense, since even myself need some time to get to
the point why the error out works.

I'll update the change log for a comprehensive call path why it works.

Thanks,
Qu


--hluFxdSehCDVRUPZM6cKc2wJU4UB69BlG--

--IyPEKH838AzcVxA9vX6I3KFLYSMlVnRgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyI8WoACgkQwj2R86El
/qhT3ggAoMCG8CfBuIiftloxLVv7R0mRqx0LqMdSBjCxD5XMGilRm/hRN6PHy5qn
OgswECBMCKJZJuakv86Q4mGspzBzV0LM7hXXqiuz6FEDR/j2pt+/LCurRIPznh3q
i4PdczYh6shkvzKJ6QGbmMfNpuZ6fAdC3fdbHXJmxa3DWXqcYBPkGSK3ZLIfqQ9y
NF27Gmc+zvquJiqPieapiXz8ib38CzZeU2bOqdpVBm77YUIpImTr3RSHcgegqrhW
RbCRyTgMtSvJzLIv8kNpQfMbZDqeUmP0SY7pZw8PJT9pfx97SEz4qt/ok6bYabtN
3GX190REJ66uDDI2Py5VBkZLbefHww==
=LIkJ
-----END PGP SIGNATURE-----

--IyPEKH838AzcVxA9vX6I3KFLYSMlVnRgb--
