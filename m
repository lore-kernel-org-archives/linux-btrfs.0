Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D5BC10F11
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 02:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 338FE2077C
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 02:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="aAiR6N7t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfDWCQj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 22:16:39 -0400
Received: from mout.gmx.net ([212.227.17.22]:49539 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729734AbfDWCQi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 22:16:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555985796;
        bh=hSr7PyVzWj1llUr902untT+WK3f6rHgnWi4Cgpq4r9A=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=aAiR6N7tfY5OC/5gM1pXUKSHklaYcPKAxCrHk3yZBeFdxtW6R9yD99DwS9oh6mTaz
         PyAQckOpe5elqYmD8Hs7t7w7lNaQQPaAiuSxuT/LxG2z6uDQFQsrzbMeMg3LdkATJK
         WlbYsChb/hbJYgTz/n0RxSwdPn5EPTVvRpWFIwtY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M4GND-1h0x7I20SB-00rlbn; Tue, 23
 Apr 2019 04:16:36 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
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
Message-ID: <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
Date:   Tue, 23 Apr 2019 10:16:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3vUfvTV8i9WvNtVdUbzgO9SoxLK5LRPpn"
X-Provags-ID: V03:K1:zD/5ackTTpPbXbgoxaXe4SNh43obMXYmKTUn+StXFL72Zk0WQbw
 5HteSffjxPOYtpEU888R5B9vCvglOmM95/YTHF07SvsaUAy/j8hjpqucg2ROiL8LSpZoXPB
 keeuB1fLXSrlDH6C3E3upXULcCnY6bt/NexYETjhTbzhyROxUPhO/Cgktvw2hSKONw6VYHh
 icO1928HkuUqTvUgRAqMQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SWX5VW4qxdo=:uMMDt09ycB0zSp6pkEc6VO
 aPrNr6oaTF9InMPNy3H1t79cwDjMns43+L3PTwI6+utqhuaCCzpf96pW729D+8I8xlvdMgrXI
 /8Ezq0SGHT1klGF1vmo+RLQ8YQqiKdDttN62WFZSatkIq1RFnkaMuL9fxoJMQSkQqdZGHI3Jy
 ooZzAsGz7Bf3XSwrT8rUbUyobGoXImOuDxyTDUlE0AoiJ146lOqM8GP6hek9JTpWocyO+b9lY
 Iu/3Mtc47oZJF2ch/U4syHOPalhWj8aM8TdH+otXqfbfZgQaPrAPWa7qnurBZ2jzC/9rnpLdW
 3dOiR76JCZh28Nx713eT0+MO/bLGP5ON/1vvsIEv3zWP7vfirJpHAis1/LtEbjJo7X7MKz16J
 lsWEjgX5HAUH45g6rBuBgyOBzPhEeVW5M4QK/W+ovk8OZFvd0vzaw3LRwOxiuZbvJKBv+leOD
 Tcjy9fxqF03gKeAapc9y5FR4RuZvFZzjyg0miBLPQsYtnp+86MHfB8wUad8kbbq1u/cl52eDV
 RYMsRzd1J0ziWx4Un23fgc8GB8YZmLHMj9tw7NuDL/qCbWwupxDuGfYFdWbbWz/9d11Df5049
 vVwsgX/uod/8NrGBcBBYAsxSbjdmLE2ORcAOlXD9umxv3kmLJIl+FOugn5I8D08Hg1qkBF1hy
 CYO/O3Mpi9wXlYi1jfoEUEB2vx2oQCvJ5vf5gyeD6jvMuK6SLXn0nm1wWSCUGZbgayYWQtX3V
 E9CMLtWpPVxoFFxKpBs2Io/aYb34gjrYbXfU09zrtjUMjkh06i3sFAymSSHHJQWroBe3IVcfb
 kj0EfEoOU2inPSFG0RORhSBeuhRHaAv4DCijqTXz1z9k2ZZretHO9dLxsjk8xZ393PsOIG+tS
 qXCJkyLWDMllJl2YVZKMw+vKPkEMngTtxYlRKIhu6IKGdPl+We6MzIEy2JT+7n
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3vUfvTV8i9WvNtVdUbzgO9SoxLK5LRPpn
Content-Type: multipart/mixed; boundary="FpBBE7U6X3rmkGCpLaEggWM2r1eEFappS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jakob Unterwurzacher <jakobunt@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
In-Reply-To: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>

--FpBBE7U6X3rmkGCpLaEggWM2r1eEFappS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
> I have a user who is reporting ENOSPC errors when running gocryptfs on
> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395 )=
=2E
>=20
> What is interesting is that the error gets thrown at write time. This
> is not supposed to happen, because gocryptfs does
>=20
>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
>=20
> before writing.
>=20
> I wrote a minimal reproducer in C: https://github.com/rfjakob/fallocate=
_write
> This is what it looks like on ext4:
>=20
>     $ ../fallocate_write/fallocate_write
>     reading from /dev/urandom
>     writing to ./blob.379Q8P
>     writing blocks of 132096 bytes each
>     [...]
>     fallocate failed: No space left on device
>=20
> On btrfs, it will instead look like this:
>=20
>     [...]
>     pwrite failed: No space left on device
>=20
> Is this a bug in btrfs' fallocate implementation or am I reading the
> guarantees that fallocate gives me wrong?

Since v4.7, this commit changed the how btrfs do NodataCOW check:
c6887cd11149 ("Btrfs: don't do nocow check unless we have to").

Before that commit, btrfs always check if they need to reserve space for
COW, while after that patch, btrfs never checks unless we have no space.

However this screws up other nodatacow space check.
And due to its age and deep changeset, it's pretty hard to fix it.
I have tried several times, but it will only cause more problems.

So I'm afraid it's a known problem and not something we can fix very soon=
=2E

Thanks,
Qu

>=20
> Thanks!
> Jakob
>=20


--FpBBE7U6X3rmkGCpLaEggWM2r1eEFappS--

--3vUfvTV8i9WvNtVdUbzgO9SoxLK5LRPpn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly+dYAACgkQwj2R86El
/qjb2wf/eIBoexPuFxr5Q7F3NcEwHCIFU7dWi99nEiHMgTKoAgHzKbaNgTxvj2ON
6hjI/MwIELbzXC24V0BF5W7J4/OOlAz9qGmc1bZ39G6EPP2bdKOksrOkMtBbaRzF
SsfpYwgSNg23/snnKsxD0I2O6le6FkLtx108dMgaqOtUP0mtajFk8X4wQIRJKcY8
/4AFC5ioOjO694cuywMhKGQyTzx72za80sydAQviSIqDDH8IhaNVtydWI+P7vFNE
JZ7IZtVU4OWXEEUQsolMBeKTVmFR17X30kkoSNNkrHdGIz1tBluAZb2wQaTS9mOZ
JSg0L+jrWqWLN/JFwuXjVlMciHtahA==
=lKTC
-----END PGP SIGNATURE-----

--3vUfvTV8i9WvNtVdUbzgO9SoxLK5LRPpn--
