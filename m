Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D3DC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07A2920866
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfAPBw5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:52:57 -0500
Received: from mout.gmx.net ([212.227.15.19]:51391 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbfAPBw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:52:57 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MEXHd-1gUVPp1dNJ-00Fnhs; Wed, 16
 Jan 2019 02:52:53 +0100
Subject: Re: BTRFS critical corrupt leaf bad key order
To:     Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
 <CAJCQCtQCwGzuoTc5ZaE-EsbrhjT3yXQ=GKSdjr2ywT375=C_nA@mail.gmail.com>
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
Message-ID: <833145b2-c3cb-78f0-f31e-d8ce32c4c18a@gmx.com>
Date:   Wed, 16 Jan 2019 09:52:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQCwGzuoTc5ZaE-EsbrhjT3yXQ=GKSdjr2ywT375=C_nA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nTm4v62xnAduyOTj6xMRTx8KhiajQFENm"
X-Provags-ID: V03:K1:bi3tYoCAH4adsvdaFPpKTUrLIBh1MfmP78E6SEmOutDf5/jUmCE
 DCg/7jXf41LqdIParCLZgPkwbSo9NZoQu0PPyF5arbJ4iGs3/OdW9ramKXcU+ozki5s3Bfp
 sb1To/le/ZEcfhCCcIZZO2WdG2S/4V8U2F3+AOie1QXQ6w7gyhIFS5BwFxQZ2oCeNH3Juf6
 eEoOiPSxhlOAzL8p/2ROA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:e4YKAJeX4IY=:nn6ouzfFlpWLe96YqRREra
 jyt2b4jNHejLfqtuOVol1DPWvvkm37aISllmt1M4fmmHFsYUz2lZYx4/WnIMP9p3IMfWXmCTa
 HpRLJxRA3aMK0q9v3y54EPAzVa5TaVEYx55uZhB15HhLQ5lsse+4z8KZfODSDlrUqK8xkokTr
 mh2FiFTp8AiX2sy7qk1cm+3ljIB3XMCJqiwSJATJ+3FBpYtDrEQ/iaCsjb2aVeVa5A7GV3x9B
 91SpKaDIPRtR7ZaUgh1uZTyCCzT5mIgLRndAxYQ9pLlbc2edowMmQ9rNrEFMD0NrVERmbPlsR
 IMq537HdlmFowAGFeUjx5Z+//xpB1EInOuN9ppKx9/jDlppXxJuLdQILiq8b6IoVIdEKuHjN/
 4i3UbR05gC/5h6Y7wSGcVIsI33eMO0j29r4ZzEoYWrZeG9zBKw9/Gt4M7PTq1m8PfvybmyFWh
 kuW0O3wMwt1BH8bgq3TCYxe0+CIU4r7DGSIRzXFwucNdj1rnvdL04m2UWoX0LuspyoQPCnYH9
 /Gt/fQbVBEXcvsgPq8ZNsNLaubX9fLUAJk8Jhj+UpuaKMi3ZNlBit1SNmdxz9err6sjedMFjU
 B47n8+ACJ6yKhvl3O1/waQv258BamQmVD8aO1adSJ4HTR9NJ2htGzGrlAmjOigWt8qmxjs3uC
 tQi6qZbN2ONEcoIaAGiVX82QPSKGf7r1BIbKqxD/Sv8LU1aNFAnew02RUWHs5ClpPeO30iRd2
 kByX+tJWxZwaPl4v1JQAmullPYjiSoVjVxXy6J/AoCaA6oWUVbhzOvJtht9m7AHwBMv4LoHPf
 6sMB60Xpwn9WiJ7Qb49scyIRj4ZUuMYUJvThQdpZwBYTe0y1yJCr84Dg4sDUy6faCUZSIXkzD
 YhiLyUDqvpouEeeHEjFTyIiZGWd+flAYxeS3DXM3oTN0TZ+vURD5DdDHueadKC
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nTm4v62xnAduyOTj6xMRTx8KhiajQFENm
Content-Type: multipart/mixed; boundary="4D4HbHWqSEwT6KFePFD1jHkMPCvStx18r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <833145b2-c3cb-78f0-f31e-d8ce32c4c18a@gmx.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
 <CAJCQCtQCwGzuoTc5ZaE-EsbrhjT3yXQ=GKSdjr2ywT375=C_nA@mail.gmail.com>
In-Reply-To: <CAJCQCtQCwGzuoTc5ZaE-EsbrhjT3yXQ=GKSdjr2ywT375=C_nA@mail.gmail.com>

--4D4HbHWqSEwT6KFePFD1jHkMPCvStx18r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8A=E5=8D=889:38, Chris Murphy wrote:
> On Tue, Jan 15, 2019 at 5:04 AM David Sterba <dsterba@suse.cz> wrote:
>>
>> On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
>>> Super nice move, it shows the corruption and the cause.
>>>
>>>       item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 items=
ize 33
>>>       item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 item=
size 42
>>>       item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 items=
ize 33
>>
>> The key order is the most frequent and also very reliable report of th=
e
>> memory bitlips. I think we should add an unconditional check before a
>> leaf or node is written so we catch such errors before the bad data hi=
t
>> the disk.
>>
>> This seems to happen way too often, I believe the check overhead would=

>> be acceptable and at least give early warning.
>=20
> What about out of tree or proprietary modules tainting the kernel?

For XPS13 there is no dedicated GPU on board, so no NVidia bullsh*t.
And I don't really think it's proprietary modules.


> Or
> other corruptions we see that aren't key order related, like the
> several recent "unable to find ref byte" reports?

I'm not super clear on extent tree corruption. but I really don't think
they are the same bug.

> Are these memory
> corruption related, or are they non-Btrfs bugs causing such
> corruption? Does it make any sense for users who are running
> proprietary or out of tree kernels to run with slub_debug=3DF or even
> FZP and possibly get a better idea what category the corruption is in?

Anyway, I'm working on the idea David mentioned.
Hopes soon we will get a more early detection to get some clue.

>=20
> I guess what I'm getting at is, users get a corrupt file system, they
> can't repair it (honestly the tools are not good enough, and aren't
> user friendly),

Definitely.

> so we tell them OK just start over with a new file
> system. It would be better if there's some additional advice to give
> them to try and find out what caused the corruption to begin with,
> rather than just start over and maybe run into the same problem again.

Obviously, current tree checker is already too late for such case.
But if we catch them just before writing to disk, then it'll be much bett=
er.
User won't get a corrupted fs, and we will get a clue, then everyone is
happy.

Thanks,
Qu

>=20
>=20


--4D4HbHWqSEwT6KFePFD1jHkMPCvStx18r--

--nTm4v62xnAduyOTj6xMRTx8KhiajQFENm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw+jnAACgkQwj2R86El
/qhrGwgAq6nFayvNhJDmDUw9Ir0sa0g9dhFouZvR6JqRBeA67EnrzoVeJU3TghR1
NdtcFeMuiN5oCfhlGZQwqhNQSrWfm7nYSsaFCR0NIzHNc5oLL+oz0iXAZCylxfsV
IG8src4e6i+40noz8Bqr6mW7DOfXfy9k+M9RK9QGJD0y9vpaONftEIbQ7PY/ROi8
JSjgjoWR+CP7JJMRf///RzevS3jeN20O9ccpvrTOOUbKw6/ibgWn2Qsa95CpsmYi
KQfE5/+b5F8mqA18Mex6RSb0aGwKqzxPe284pFkn0r7Ylc2nSLX5p+b+qtMaMLX2
gyM+HxPsglXsOcjZtyk3nVoHgQkGFg==
=XS3y
-----END PGP SIGNATURE-----

--nTm4v62xnAduyOTj6xMRTx8KhiajQFENm--
