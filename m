Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42948C43613
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 00:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF0E21929
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 00:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393071AbeLWAzH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 19:55:07 -0500
Received: from mout.gmx.net ([212.227.15.19]:39871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbeLWAzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 19:55:05 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPUlV-1gWjJc3AGX-004ilc; Sun, 23
 Dec 2018 01:55:02 +0100
Subject: Re: Specifying block group size
To:     Raymond Jennings <shentino@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <CAGDaZ_o0NYy4HXmE67u8HvH7Y7RwT6=GvPDrPtRbRdPzEEDHGA@mail.gmail.com>
 <20181222180438.GG30713@carfax.org.uk>
 <CAGDaZ_ozFr+2nz8oqaRAhVmyoan5uVocFqCS=rT778C8kTByJg@mail.gmail.com>
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
Message-ID: <e259f354-6907-8298-28b5-4de470678ebc@gmx.com>
Date:   Sun, 23 Dec 2018 08:54:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_ozFr+2nz8oqaRAhVmyoan5uVocFqCS=rT778C8kTByJg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3W4W2kEzOUgeXEmQxytDirPBeXzLdUhiF"
X-Provags-ID: V03:K1:P3d21a5hOms0hhEKopynD+xMccS/AtH83sKGVnjXOkkW9j5AeRs
 6qUHXw+Lrq37h+mqg/JgVvvkWik4d2gk+MmSP04OVHRKnUIYjadgkbEbV8hAZynCBntFujL
 lDpHxCpEln0bqAMKCjFA0+TUhyAQPgm5D4QV1EalNPWQq7TjcU7Wst128Nzx+6FuPB/x+CS
 0slz2edBQVFEzLkipzI4g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hX3uwtQ03Y0=:wrfixUlwRLMih2Bgr3vkm0
 CTnEbGTBYm1Iobi5oisiJDqEO23OWZBhwR9BWgG3P527N0QmAoPnCFnWrFej0PoEMB4C+LuNj
 5oYsGwj9cdEYTYBLx5IxUK70P7mjjidvsrdq+kE+t+83QnE/9v90PU5rJcRbpLu6Gqfpy/k1I
 njjJXrepp3hwwfa1MbKq6iOWfAJ7CxdugvpR6OYZVHv1ATZP5OP018vIQmp2epAihonvCfA2j
 VySlDxp9zOJnZnWDqZZTPpraweddwxGnUOxNwmbHsQ8DGk2KtI6otqdC907hWucTR48kgHqKB
 1JYTSm/WAw4lYlcbow7tBYJ5+ZujH0HjzMy+SQdwr+10krV3HCNeMZlW0YvKy1fzl7Ceag+DK
 cvSOLE8F3JxGuWRPPSFOjPRJzsXr6qKmdbJ9pUmnBJY3p7b9haBp8DYE1BvR8yACnFHh9wbJi
 Xxl1zc8Pfn4R6ZtiDVPy8cX+yPHBw5oZxk83stvnk2UgyZTFVKRzYiB/FyP1YwLtLRRCn1IV1
 exgHjSsT9jRZjT3Dm7uFSNfxCdMEkD9m2W4/Emhm1/f6wo/ra5ZtNWZbmKT0pgfr/g8b8UCUo
 lXkh9F99hZ/L95kQZtrsoGgksne91l1rlr/cE7cMbVWea3ZDjSyMk9IlIRxV21YQ2vBwEYTfE
 gKau6yEufPTEjztMQgTbhkrpPP99rZYZDCtKyue7Z7bQk+L07XoAzZZelOmKqB1Nxru9JjJpv
 aRpriHYAD654dlPjNQclmwXdAN6HSgDRrMkWfY77MY4i9rPNQjkgX9V7Bev8cvGaPjcpCD3qB
 0eLwglEAOH0Z3RZvjU4tHpUXoFmuRUGY0NaNjoB/qsC87KO8/hra5N9uNYvTI+7KEqVIvkJjc
 f7NINrKrZu7oHpjnPjbszPTDuzdMZcYi1asXxOc1AMjRh5v5aq+GZnSuOOf9qG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3W4W2kEzOUgeXEmQxytDirPBeXzLdUhiF
Content-Type: multipart/mixed; boundary="9uj3eUyW9LOvLRUEHw1aQpJozcAxATFZj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Raymond Jennings <shentino@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <e259f354-6907-8298-28b5-4de470678ebc@gmx.com>
Subject: Re: Specifying block group size
References: <CAGDaZ_o0NYy4HXmE67u8HvH7Y7RwT6=GvPDrPtRbRdPzEEDHGA@mail.gmail.com>
 <20181222180438.GG30713@carfax.org.uk>
 <CAGDaZ_ozFr+2nz8oqaRAhVmyoan5uVocFqCS=rT778C8kTByJg@mail.gmail.com>
In-Reply-To: <CAGDaZ_ozFr+2nz8oqaRAhVmyoan5uVocFqCS=rT778C8kTByJg@mail.gmail.com>

--9uj3eUyW9LOvLRUEHw1aQpJozcAxATFZj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/23 =E4=B8=8A=E5=8D=882:11, Raymond Jennings wrote:
> If the filesystem is later resized, does the (default?) chunk size
> adjust accordingly?

It depends.

Btrfs calculates chunk size based on total rw bytes (no more than 10%)
and clamp it to maximum chunk size (1G for normal data, 10G data for
large fs, 256 for metadata and 1G data for large fs).

So if you're hitting maximum chunk size already, then it will not change.=

But if you're hitting 10% limit, then it will change.

Despite that, raid profile and some other factors will also affect the
chunk size.
E.g. RAID5 with 12 disks could break the 1G/10G data chunk size limit.

Thanks,
Qu

>=20
> On Sat, Dec 22, 2018 at 10:04 AM Hugo Mills <hugo@carfax.org.uk> wrote:=

>>
>> On Fri, Dec 21, 2018 at 10:18:40PM -0800, Raymond Jennings wrote:
>>> How do I specify the size of a block group at mkfs?
>>
>>    You don't -- there's no explicit control over it. The FS will
>> decide based on the overall size of the filesystem in question.
>>
>>    Typically, data groups are made of 1 GiB chunks, and metadata
>> groups are made of 256 MiB chunks (where the RAID level will determine=

>> the number of chunks in a group and the amount of usable space of the
>> group).
>>
>>    Hugo.
>>
>>>
>>> Like, for example, saying that data groups will be 1GiB, but metadata=

>>> groups will be 1MiB?
>>>
>>> I noticed that they had different default sizes based on the profile
>>> (dup vs single vs raid)
>>
>> --
>> Hugo Mills             | Beware geeks bearing GIFs
>> hugo@... carfax.org.uk |
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |


--9uj3eUyW9LOvLRUEHw1aQpJozcAxATFZj--

--3W4W2kEzOUgeXEmQxytDirPBeXzLdUhiF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwe3OAACgkQwj2R86El
/qhnhwf/YpiNo8qtdfQxoDl12VGIA92qxXO0cFeFLjDUp9gh4ItX6Lmjwg6v56M7
rXuzm9Fh8k509k5Q977NJaPXLD4BiJFcgKYLMP+MJ4kKeGzAqnRGgMLzz55ilnYq
/LKxzJiyr1y+1TizzA11T7Pa8FJoMarKXu0R5f6DPsqQp1GCQwf+Fx7c39G+FGV9
StBB5eGDrF7mwqLVj+TSud97nKXuxE7VVI3m5u3S4vH8PY8RA/4XR5s9Uir9XsV0
WLr2tmn1lifz8n5dZLy/jX09L1Gk2Ti7Rhtowzaf8Rmmm0QL9KT/Ajtx/rOdaTiS
qbNYGTh1rN/4fmcKSczR8u/PA5INqA==
=gwnC
-----END PGP SIGNATURE-----

--3W4W2kEzOUgeXEmQxytDirPBeXzLdUhiF--
