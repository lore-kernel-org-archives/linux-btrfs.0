Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8631C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 12:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E544214AE
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 12:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="FEFomVWQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfDWMM6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 08:12:58 -0400
Received: from mout.gmx.net ([212.227.17.22]:36661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfDWMM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 08:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556021572;
        bh=+Mx0eEky0/LMVkge2fPqP9YqmvEjX1Bm4zBYxeXYrrM=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=FEFomVWQGeU8FnAWDcloHptutwk5ZBha1PbqqvsawLXvpyS+ZkeS23mTLg2Aoet0n
         FRyfqH0pfedpLhDgJ1lxXfQFbUqilfXa9Jmjthc2zee2bJjHj20XSJ9LDMnpDbOBxx
         Vg4L3ZofUiwTpPsGJZ/s+vRfnybXRkIfKYAFJnaA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lskr7-1gqHZF0A37-012FZh; Tue, 23
 Apr 2019 14:12:52 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
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
Message-ID: <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
Date:   Tue, 23 Apr 2019 20:12:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423113302.GS20156@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1NSDDD2NzzqlQ51F4ieaz3ns6xdBR7LMO"
X-Provags-ID: V03:K1:uMiXBfnks6j6epiyfC6HNyEwRkDhWdVAidWjItN0hHQpz7azuj2
 rdGpD5FioEgmYfvKGg56NJ0CSy7drT8suvltVaLZuwUqzhNdMeaOombT7xaMcA0IyQSJl2U
 ohXx3i07+f5ep0+nej5t5UMY3LcAxjK1QUAzwbqBZ05A2ohINhHSxPA5EENc2P5Ew3MaSXI
 r4sQi/Op+ZolFV8IdRiIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BNrHffoxdMk=:osMFb+fTMAI4crfhNU1qC6
 /wIyDglCrYPZWETTVu2C3owOx9VBHziTSECkQN+++FQ5Jm9+4x9awC1wD/ajsXOXg4qXMWuwX
 wFveyfswcqOi4H1xM2tA1PsrHQVV/qA0QwooJ762fDaEXr0BRMHxAhTRTAjA0YPQFdLq/9bs8
 mJjbHx9/Ph9cLDbHavS3FFnyQnLLIAH4t0l/QFhlGFJThRxU3gtxdShSfcPB/A+LBlfc4ccU0
 qmHkLqQMRsRhTFLup96P3jcsRr4ud5y3CjicCoTFKD13YQPK4RMeYpUKIJClxR5dK7QNufmda
 IbN2Ht6CqpGQlGW6wdPRNQ6TvS4Vf8/2Wi/COQVHw1pS0jr0gvokkde/ZaEGRlhhaK2XE48Xd
 2Y6smiRNzirQ5iWNLYJuvBmHwwedy77Oq9/EVmwSFUHhP/3uaj/vIA4k22crg/phHcPQEa0XR
 oSks/VNuhQuf3aeQRidAd/OquJsHxPelF3ZCW5WcPP80yunCpEvUE+n9KhA5PtRilbcqBse4K
 mYbte+vowXMsdHm89rSBfao8NeJmsfb7JGjEFdX/5SQcE0U8VBZq0JG014r5Qjvv90AMpvVK6
 Vvp45z6zJfKkOr84P8Qhv31ys9p7lGokrRWCVnlOi4JbFFvCzoGHEBqhOFe4PU6HCIJ751TVD
 KS/s2adOB8orTQtCCEV1G/CrLjuMaZjIOHE/XyYeKIz63OK8gt3GXVs9b3WnBehcuGhrrNpDM
 9iyCO8YYhY16a9y85AjYF/KB9d9UcGICdmfzqLFSorVwvHq163iaTtdPKLrLkI3RVF2VBvQ/X
 OO9RxfUuM3ondhCYmC6KO7Mom+OgS9wCNr6Om7oa6QLVjUWjpO3HSApzbXgj3/M71NdAOg5gu
 cMuyuNSxJZC5WJJ/21+SAOGxh/HmTGdBY27SX65ljntwJnuy5ppeEw2MXdKfeE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1NSDDD2NzzqlQ51F4ieaz3ns6xdBR7LMO
Content-Type: multipart/mixed; boundary="JA28Yj4IPgontlvOshIIikMDccIRSdvF5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
In-Reply-To: <20190423113302.GS20156@twin.jikos.cz>

--JA28Yj4IPgontlvOshIIikMDccIRSdvF5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/23 =E4=B8=8B=E5=8D=887:33, David Sterba wrote:
> On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
>> On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
>>> I have a user who is reporting ENOSPC errors when running gocryptfs o=
n
>>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395=
 ).
>>>
>>> What is interesting is that the error gets thrown at write time. This=

>>> is not supposed to happen, because gocryptfs does
>>>
>>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
>>>
>>> before writing.
>>>
>>> I wrote a minimal reproducer in C: https://github.com/rfjakob/falloca=
te_write
>>> This is what it looks like on ext4:
>>>
>>>     $ ../fallocate_write/fallocate_write
>>>     reading from /dev/urandom
>>>     writing to ./blob.379Q8P
>>>     writing blocks of 132096 bytes each
>>>     [...]
>>>     fallocate failed: No space left on device
>>>
>>> On btrfs, it will instead look like this:
>>>
>>>     [...]
>>>     pwrite failed: No space left on device
>>>
>>> Is this a bug in btrfs' fallocate implementation or am I reading the
>>> guarantees that fallocate gives me wrong?
>>
>> Since v4.7, this commit changed the how btrfs do NodataCOW check:
>> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
>>
>> Before that commit, btrfs always check if they need to reserve space f=
or
>> COW, while after that patch, btrfs never checks unless we have no spac=
e.
>>
>> However this screws up other nodatacow space check.
>> And due to its age and deep changeset, it's pretty hard to fix it.
>> I have tried several times, but it will only cause more problems.
>=20
> What if the commit is reverted, if the problem is otherwise hard to fix=
?

Tried reverted, but all other problems came up.

E.g. reserved space underflow.

I'll find the old thread and retry again.

Thanks,
Qu

> This seems to break the semantics of fallocate so the performance shoul=
d
> not the main concern here.
>=20


--JA28Yj4IPgontlvOshIIikMDccIRSdvF5--

--1NSDDD2NzzqlQ51F4ieaz3ns6xdBR7LMO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly/AToACgkQwj2R86El
/qhSbAf/S1kSEDzWi8mTMmNXMhF6Weku8u35eMqHE6Z3StQ2+zwo6HWiFg307KWh
Ij7H2B08tkVqHvGdq/CDZwR6DhxlGsF71sLwRey8oDrp5yF4PVb+OwXlpfKIBY86
U/Ji+DWnggQU4E4uUl6M2bdTJ0tFLRJwD1BMoPmzURo2hhq7Zm1mSZxDf4dMUj9v
DDaoJKwgw9MIBsvIPcgADNaOCUYcdKxIlaDDNaXI92mf0PU7LDdAu+wo/4aqfBLO
Il6dfdDrL09gupX0j+iAfkSTxju+Ri7iz5tnnBcpvkgUbCi7FbY4DFpHqmUQ9csv
NRhDHaQzfFRQODh5DEl/HES3WjhClw==
=521o
-----END PGP SIGNATURE-----

--1NSDDD2NzzqlQ51F4ieaz3ns6xdBR7LMO--
