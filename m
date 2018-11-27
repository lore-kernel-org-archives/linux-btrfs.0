Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E0C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254B320989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 254B320989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbeK1BPF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 20:15:05 -0500
Received: from mout.gmx.net ([212.227.17.21]:51567 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbeK1BPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 20:15:04 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MV6PJ-1ftEZx4629-00YThf; Tue, 27
 Nov 2018 15:16:58 +0100
Subject: Re: Linux-next regression?
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     linux-btrfs@vger.kernel.org
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com> <20181127141144.GA23269@glet>
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
Message-ID: <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com>
Date:   Tue, 27 Nov 2018 22:16:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181127141144.GA23269@glet>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dQwRI7S8G2YUmrSSUjd4LOhdp46XOgqyJ"
X-Provags-ID: V03:K1:RgawI87bynf46gf4XG6qJxhPiDa4n9jzlzn4ercff8ux6GpdiFv
 KyB5J6h+aSZXEvGhX04D82IS4oE91vkIdYq/G2ZLU9cbxHD6iMHuVtk7WJen8Q8wtxRcvz2
 8QA7mtXssSu4WnvRBzLfQMeV82eM0YTMusxzSzgbETMwdNble3TRckfdxZWfzWZjBttvhvF
 p9p5An9Iv0Sro1J4bv/lw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nzgEQEiYmYI=:Bf74XuolYipzQ20IsNQNVW
 e6A5il5BUJEOKv5ypmJBdpXK/nnBqIi7oIZr55WXMjH5uWqQnyx1PcbNBuqjfCeumMbshXBdY
 8/FIs3rekFTVLkSBRHDTSkgBtqUEXyVUqX+WUNIEIDdHWu1ObWJJRgp1TYUYTAiZ8VS+4+e6l
 yNygRw8SXQErcu/J+Oc8+Imoihjse8NtCWuGxq3IA4ykedK7UpuuUCReeZC1P0LB23QRlR+/m
 ki42eHn+pGEA9JtYuDUl5wOcQn/ZjaTWVVpTRhGJ4yPFxeNVnZbHMabFIwd95sf2SYGK8RJHr
 P5rmz1lzTCpiFFGLZVjparBjTtw/it3qGyXakWI8QPngDVjU8KkKHtKSfAIwwGKDIU4B+mNYE
 iYS6cwryqNSK5m9w4Z9jxHIga1Rd70Kp5/PFk/z+eHkdcLRQRTAHlijMGQ0i4pGifz5dCpe2V
 sLh/7LJK++cegN+YWM7tK1RBYUhXvZDNAKwYEGQWqnL9r6m0fOdU2t9FI2VWOHOmMegXeLezZ
 4gqLMKVxWkte7q+Vjm9TudyhfKtCfLx7lQIb+KxSGmmUZ8V+l41DBCG3a0womt5O0whUtstvN
 HDzjBvQcyZMUa0gEBDo4NFXoJQGdTa3rPyWPDeOP5q2/oTgY5YchjZdRyuWeVg2Il9ReudWLx
 Mtg+0TenJkhm4uKfCFxgLWyISG2JfReJoD2Qp7aYvaDT3RG2hRtNgZigvqpaZg7xQClcUnzTg
 1KMQoxZGH1YcgnYnmcxxxYMJ2wQ6j72OSekVCLmr4jvUYvZgAojoRfGhFjpwpTjomrd/b4kav
 RTytc3AYXmoD53j2LRktIZx3g+hTPtauOMGx5Gwl4HyUhlmhBGHK5i+qv2me0z23Z+8x0lrEG
 J0QoUNkxlGaJfazzbt/cwav7eYkImbdoxuS9WSwFE=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dQwRI7S8G2YUmrSSUjd4LOhdp46XOgqyJ
Content-Type: multipart/mixed; boundary="23e5MDq7RhiN9RsYsJWueoKseRmIaS0qR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com>
Subject: Re: Linux-next regression?
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com> <20181127141144.GA23269@glet>
In-Reply-To: <20181127141144.GA23269@glet>

--23e5MDq7RhiN9RsYsJWueoKseRmIaS0qR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/27 =E4=B8=8B=E5=8D=8810:11, Andrea Gelmini wrote:
> On Tue, Nov 27, 2018 at 09:13:02AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/11/26 =E4=B8=8B=E5=8D=8811:01, Andrea Gelmini wrote:
>>>   One question: I can completely trust the ok return status of scrub?=
 I know is made for this, but shit happens...
>>
>> No, scrub only checks csum of data and tree blocks, it doesn't ensure
>> the content of tree blocks are OK.
>=20
> Hi Qu,
>   and thanks a lot, really. Your answers are always the best: short,
>   detailed and very kind. You rock.
>=20
>   I'm going to send a patch to propose to add your explanation above
>   on the relative man page, if you agree.
>=20
>> For comprehensive check, go "btrfs check --readonly".
>=20
>   I'll do it.
>=20
>   At the moment I just compared the file existance between my laptop an=
d
>   latest backup. Everything is fine.
>=20
>>
>> However I don't think it's something "btrfs check --readonly" would
>> report, but some strange behavior, maybe from LVM or cryptsetup.
>=20
>   Well, I'm using this setup with ext4 and xfs, on same machine, withou=
t
>   troubles.

Then it indeed looks like something goes wrong in linux-next.

I would recommend to do a bisect if possible.

As you compared all your data with laptop, it ensures your csum/file
trees are OK, thus no corruption in that trees.
But still something doesn't look right for extent tree only.

But it's less a concerning problem since it doesn't reach latest RC, so
if you could reproduce it stably, I'd recommend to do a bisect.

Thanks,
Qu

>   I've got files checksummed on the backup machine, so I can be sure ab=
out
>   comparing integrity.
>=20
> Anyway, thanks a lot again,
> Andrea
>=20


--23e5MDq7RhiN9RsYsJWueoKseRmIaS0qR--

--dQwRI7S8G2YUmrSSUjd4LOhdp46XOgqyJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv9UdQACgkQwj2R86El
/qhRkwf/ZlZGUWT44oB4ELfD7yTJDcJfQAIacIFO9cRXn4hX4RhHp0H+URyhBPCN
mf7Dw+D5qstZfZR65JKGtwrijiEZFyibOuSggpPQ4thnyx2jssIw9dkN2IE9V2k0
FOU2CFftFHFwwa+BtasB1dNfKSoDeXgFRQGe+My2aBBB0Cuc39Mf5lXSxVbi9o8k
yFQA+SeXXC21c9x8GjbQjvPnV6n46W3NKKnOy5kQwm5AdYezQA9FOT2fTs6XTY/V
tDnPj3BOeA6ND3xfifVcDLzItO20KyR4C3Lz7xOp/9OxWhmc5sxjJLHlqjViAhlu
/p1d+uBseQYb0qUFO7ehmn6o2xWxZQ==
=kFuk
-----END PGP SIGNATURE-----

--dQwRI7S8G2YUmrSSUjd4LOhdp46XOgqyJ--
