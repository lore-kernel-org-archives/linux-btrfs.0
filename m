Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CABC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 05:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD53223CB
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 05:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BD53223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbeKOPbj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 10:31:39 -0500
Received: from mout.gmx.net ([212.227.17.20]:35845 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbeKOPbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 10:31:39 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ls8Qd-1fKnF23V6N-013sSk; Thu, 15
 Nov 2018 06:23:37 +0100
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181113170724.GE24115@twin.jikos.cz>
 <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
 <20181114190520.GJ24115@twin.jikos.cz>
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
Message-ID: <ecdd1309-fe6b-0c73-b898-d08ff7c48a21@gmx.com>
Date:   Thu, 15 Nov 2018 13:23:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181114190520.GJ24115@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iA81KyOByBiTGGGIACQBfieOcPbNAVOND"
X-Provags-ID: V03:K1:G7LeSg84cCTPIRBh0zASUFdygdQPmXydO0nYVbIBkHogyBIK4xs
 J9qmoR8N9VIGme3Y38gaJSKRsrHaJro/RGeCEaqdDuApnlbO7a8+3tVQzDmtX+bi8Mn+1GT
 EG7fLJHFo53ViTlboeCMsmLOczlr238RyElmkrd6LtousCRXuY/R76HxGNVaDUojMydMbU5
 8gF4EwxCHG/CrUqodADGA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:cowIM2Ds3LY=:i7TxRf14rpDCNK9JiwAAQF
 m3cz5ADI+B5Gzmptai1b4f1W2P1Aw4KcuucAK0tgzke8GGOSLp8Moc+HiROXBCzyNsBwCu1fK
 lKtRY8jUxBqSknwPlm59LuV6kmJAckBOaw+PVHS7Mzt+0n2I8DW++S7v/bwNRVKzOVxIcfd1t
 36HPjef+CKVpG8Rw3z3PzHXvyEXCVyCa7QJISpR+hW9qO8V8Im+NJZb26nBAgytFaPBy1SOvx
 1wiS0FR2LYmJuTegBd0NUKF+6aj7yO4170HTmaQqRJELwiNpSz8iLEKznZ+yRVKSmn+rSwB10
 82p4C32KJ4ANGcCrqj6coYOL4weo5hrb3vgYbf3CE56KrQLCsKEo6jm14UHoQFgkh+YB1aS0b
 8Q9tL80hiCy5wphJGq8XNGr4qCRv48afD0Fe8dW+TxhBpT/MyMYQwi7xkFjU0BJyV1Yja+nUM
 JAsqxCI92/g+nQjB33YdThIhaxn9Ra3kgLp3+/oWnBPpbD/fYcrvIzSEIW7pgSpWFn/qKeiGl
 /IMq/JSsZGOcuqC+7mpgiMFMQQ+DCrTY686vyvrUeh5nZyBpYdCK3xXxndzAc6xj5lGWoKaqR
 iEKrQ964NOVaRdjcpDHg88UagnUOpJKWRn92+j/Cow/9awb+mw3Als7Z7505+ExPNSAwbVJNc
 3FwAgorDiHvHwkvDhI8r3N8GBOTtbxE6oe/wMOq5SMli+00caBQQkfTib57koRYM5ZiLSyNHq
 3pRafNp5hcONkgmsGoX7Vcd91VJUV9Qi+2VV6g0hVN2HCf/QWSdYN7Ujyuas94xyvwepyEkCj
 GHa9Q6C01FXdJmI8UTxGnCVXNy2AjnUku3RNPur0Bu5uE8V1kh1+aTxOXLiJI/DZtppEiWld0
 zeGOTMBmP2qolJuYFACf8wUkDY/u/pgu59KFU0VliP/9L8DYc9sZFGKM2wEEMy
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iA81KyOByBiTGGGIACQBfieOcPbNAVOND
Content-Type: multipart/mixed; boundary="xrh378ZjB2buzOGGS5g0Ms5wkVXDVWQvG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ecdd1309-fe6b-0c73-b898-d08ff7c48a21@gmx.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181113170724.GE24115@twin.jikos.cz>
 <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
 <20181114190520.GJ24115@twin.jikos.cz>
In-Reply-To: <20181114190520.GJ24115@twin.jikos.cz>

--xrh378ZjB2buzOGGS5g0Ms5wkVXDVWQvG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/15 =E4=B8=8A=E5=8D=883:05, David Sterba wrote:
> On Tue, Nov 13, 2018 at 05:58:14PM +0000, Filipe Manana wrote:
>> That's the infinite loop issue fixed by one of the patches submitted
>> for 4.20-rc2:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?h=3Dv4.20-rc2&id=3D11023d3f5fdf89bba5e1142127701ca6e6014587
>>
>> The branch you used for testing doesn't have that fix?
>=20
> That explains it, thanks.  The branch was based on 4.20-rc1 as I took i=
t
> from Qu's repository but did not check the base.

BTW should I always rebase my patches to misc-next or misc-4.20?

IMHO based on -rc tags should make it easier for David to rebase/apply,
but if it's causing problem like this, I could definitely go misc-* based=
=2E

Thanks,
Qu


--xrh378ZjB2buzOGGS5g0Ms5wkVXDVWQvG--

--iA81KyOByBiTGGGIACQBfieOcPbNAVOND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvtAs4ACgkQwj2R86El
/qiPmQgAjkw/slCzdCRxqoeMuz6fXyEWJ0N7Ts+Mfub0uUMVp08LMRDiq+NPvhLG
4b8rW/ar9Vgc5eiKxHs2FXDvk3gOj+9tpYs0aBxpqJIqtPfEcyIg9G2uNcVBSSs5
rSSAJ8ZyWf33euZWxoNczaZO9TaDkfwuOuHAJUmVE1T+38nNZnxPzHbyA1mMWuzu
ceAPEO3ivFTuRpJRXY9wn+EA1SerFzhwQGyhuDBiuMALI5Bf+0/fj0cMVu//hFpI
S3R7RR7fAhtZiu/4as86uMMnfmZOW+ODlCEJj/+ACJijIq9leurM21tWAzUKaHj4
ioVMx2w4hV9gK4EUVqevmoWWmw7zAQ==
=43EL
-----END PGP SIGNATURE-----

--iA81KyOByBiTGGGIACQBfieOcPbNAVOND--
