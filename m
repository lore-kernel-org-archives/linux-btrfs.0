Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773D1C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 13:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46AE52075A
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 13:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfBVNcN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:32:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:54784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbfBVNcM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 08:32:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3ADAAE6E;
        Fri, 22 Feb 2019 13:32:08 +0000 (UTC)
Subject: Re: [PATCH 0/5] Unify the return value of alloc/clone_extent_buffer()
To:     Nikolay Borisov <n.borisov.lkml@gmail.com>,
        linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <b676a401-2eeb-f105-d363-742137a13ded@gmail.com>
 <b132529d-1246-4cb4-202a-37bf84e7ba43@suse.de>
 <7845f981-dbc3-6160-a329-33f0014ba973@gmail.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <1afaf198-afc7-ed19-51bd-09ea1eb2ac45@suse.de>
Date:   Fri, 22 Feb 2019 21:31:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <7845f981-dbc3-6160-a329-33f0014ba973@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vOWHtzh5RQ9XGszB2g8Pg68Rs6KQ1HyTP"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vOWHtzh5RQ9XGszB2g8Pg68Rs6KQ1HyTP
Content-Type: multipart/mixed; boundary="xls5GH9yAyDkiOmuW9Wusmo5hHkB4WqXv";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dan.carpenter@oracle.com
Message-ID: <1afaf198-afc7-ed19-51bd-09ea1eb2ac45@suse.de>
Subject: Re: [PATCH 0/5] Unify the return value of alloc/clone_extent_buffer()
References: <20190222101645.4403-1-wqu@suse.com>
 <b676a401-2eeb-f105-d363-742137a13ded@gmail.com>
 <b132529d-1246-4cb4-202a-37bf84e7ba43@suse.de>
 <7845f981-dbc3-6160-a329-33f0014ba973@gmail.com>
In-Reply-To: <7845f981-dbc3-6160-a329-33f0014ba973@gmail.com>

--xls5GH9yAyDkiOmuW9Wusmo5hHkB4WqXv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/22 =E4=B8=8B=E5=8D=889:29, Nikolay Borisov wrote:
>=20
>=20
> On 22.02.19 =D0=B3. 15:02 =D1=87., Qu Wenruo wrote:
>>
>>
>> On 2019/2/22 =E4=B8=8B=E5=8D=888:54, Nikolay Borisov wrote:
>>>
>>>
>>> On 22.02.19 =D0=B3. 12:16 =D1=87., Qu Wenruo wrote:
>>>> This patchset can be fetched from github:
>>>> https://github.com/adam900710/linux/tree/cleanup_alloc_extent_buffer=

>>>> Which is based on v5.0-rc7
>>>>
>>>> There are 5 extent buffer alloc functions in btrfs:
>>>> __alloc_extent_buffer();
>>>> alloc_extent_buffer();
>>>> __alloc_dummy_extent_buffer();
>>>> alloc_dummy_extent_buffer();
>>>> alloc_test_extent_buffer();
>>>>
>>>> However their return value is not unified for failure mode:
>>>> __alloc_extent_buffer()		Never fail
>>>> alloc_extent_buffer()		PTR_ERR()
>>>> __alloc_dummy_extent_buffer()	NULL
>>>
>>> This function can never return NULL, if __alloc_extent_buffer cannot
>>> fail then the only error this function returns is ERR_PTR(ENOMEM);
>>
>> Nope.
>>
>>         for (i =3D 0; i < num_pages; i++) {
>>                 eb->pages[i] =3D alloc_page(GFP_NOFS);
>>                 if (!eb->pages[i])
>>                         goto err; <<< Page alloc failure here
>>         }
>> ...
>> err:
>>         for (; i > 0; i--)
>>                 __free_page(eb->pages[i - 1]);
>>         __free_extent_buffer(eb);
>>         return NULL; << We got NULL.
>=20
> Right, I was looking at the code AFTER having applied your patches. So =
I
> agree with yout. However, the ordering of your patches and the
> changelogs make it rather hard to understand. What I'd suggest regardin=
g
> the changelogs is - forget about unification, just say what you are
> doing, which is always ensuring that an error is returned from
> __alloc_extent_buffer in one patch - this should involve both changes t=
o
> __alloc_extent_buffer as well as it's (in)direct callers. Then you do
> the same for other function. Otherwise review is somewhat hindered.

Makes sense.

I'll reword and reorder the patches.

Thanks,
Qu

>=20
>> }
>>
>> For __alloc_dummy_extent_buffer, that's the only failure case.
>>
>> And I'm interested how did you get the PTR_ERR() case?
>>
>>>
>>>> alloc_dummy_extent_buffer()	NULL
>>> Same thing applies to this function
>>
>> Nope.
>>
>>>
>>>> alloc_test_extent_buffer()	NULL
>>>
>>> Same thing for this function, if we return exists then we must have
>>> found it by find_extent_buffer hence it cannot be null. Otherwise we
>>> return eb as allocated from alloc_dummy_extent_buffer. So how can nul=
l
>>> be returned?
>>
>> And nope.
>>
>>>
>>> To me it really seems none of the function could return a NULL value,=
 no?
>>
>> Your misunderstand of __alloc_dummy_extent_buffer() makes the call cha=
in
>> all wrong.
>>
>> Thanks,
>> Qu
>>
>>>
>>>>
>>>> This causes some wrapper function to have 2 failure modes, like
>>>> btrfs_find_create_tree_block() can return NULL or PTR_ERR(-ENOMEM) f=
or
>>>> its failure.
>>>>
>>>> This inconsistent behavior is making static checker and reader crazy=
=2E
>>>>
>>>> This patchset will unify the failure more of above 5 functions to
>>>> PTR_ERR().
>>>>
>>>> Qu Wenruo (5):
>>>>   btrfs: extent_io: Add comment about the return value of
>>>>     alloc_extent_buffer()
>>>>   btrfs: extent_io: Unify the return value of __alloc_extent_buffer(=
)
>>>>     with alloc_extent_buffer()
>>>>   btrfs: extent_io: Unify the return value of
>>>>     alloc_dummy_extent_buffer() with alloc_extent_buffer()
>>>>   btrfs: extent_io: Unify the return value of alloc_test_extent_buff=
er()
>>>>     with alloc_extent_buffer()
>>>>   btrfs: extent_io: Unify the return value of
>>>>     btrfs_clone_extent_buffer() with alloc_extent_buffer()
>>>>
>>>>  fs/btrfs/backref.c                     |  8 ++--
>>>>  fs/btrfs/ctree.c                       | 16 ++++----
>>>>  fs/btrfs/extent_io.c                   | 56 +++++++++++++++++------=
---
>>>>  fs/btrfs/qgroup.c                      |  5 ++-
>>>>  fs/btrfs/tests/extent-buffer-tests.c   |  6 ++-
>>>>  fs/btrfs/tests/extent-io-tests.c       |  4 +-
>>>>  fs/btrfs/tests/free-space-tree-tests.c |  3 +-
>>>>  fs/btrfs/tests/inode-tests.c           |  6 ++-
>>>>  fs/btrfs/tests/qgroup-tests.c          |  3 +-
>>>>  9 files changed, 68 insertions(+), 39 deletions(-)
>>>>
>>>
>>


--xls5GH9yAyDkiOmuW9Wusmo5hHkB4WqXv--

--vOWHtzh5RQ9XGszB2g8Pg68Rs6KQ1HyTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxv+bEACgkQwj2R86El
/qh1uwgAkS9ctXsIdCk+E3YPz9otNReuMPa+qgSdV6UqEi6wgeU2CBVWoo/lCoKu
WJj5CiT/XC34L47HlfI+mdZEpdq9cAg+XsRpXxEunUqakAXAs8ABNGXxL8OL90qS
QggZGrE9HbXSa1Vtw8mYWwFYg+w8jYM/ZuLzKmPgjJPVALHSsZ4ImvlnNP5ut/C0
vdH77YJ5X+QYqvoXJB8tFENB24ofDrTHOsbvjjPuGjlba20dI7VXqWsK8rg7oG1q
ZojNF9G7e6k6OgxzQnvWHx9gxqPfhwAgbQiO298YVCmpf0a4KJ/H8wN26qmsh0cP
xlxEnHKog/2trlEeXSzdpM3PzIxuAw==
=a5da
-----END PGP SIGNATURE-----

--vOWHtzh5RQ9XGszB2g8Pg68Rs6KQ1HyTP--
