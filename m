Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297EFC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 07:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D546020700
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 07:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="fVf90RmA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbfDEHVU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 03:21:20 -0400
Received: from mout.gmx.net ([212.227.15.15]:47663 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfDEHVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 03:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554448878;
        bh=6ijOL0ShknbbrAHiThubARRP5qSmAccaoOarLV8H65c=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fVf90RmAvRQLuozIac4VR4wmg42z4w5IFIZt4Mrr1RNjueHeRItNzlUoW5kggWdvO
         3aQkUVCiJcGby70vjv5v/gi8O02e+fNBkWhV2VwTVlS8z/rY/RwLUJk9kxNv+8Si9o
         HDTnHQ0g7SYqi0Cf9QQbMDN5H9xaTO5c6FGQ+/bc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MKYLf-1hAOCk0C3T-001zd7; Fri, 05
 Apr 2019 09:16:01 +0200
Subject: Re: btrfs balance hangs
To:     Zirconium Hacker <jared.e.vb@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
 <CAJCQCtRbRc-KDwrprBY1O3gczydCBujd9qsM5b4+5zTLmnr82A@mail.gmail.com>
 <CALsQ4_x-VViOA5Cu4vJTqmx3xSospmiEdsEcDDBcj=uvZUmrVQ@mail.gmail.com>
 <CAJCQCtSA=f+XWy8KzpzGdpjyaBsDOT5G+aC5FU9G2Fyi-sMvrQ@mail.gmail.com>
 <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>
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
Message-ID: <59080b24-a005-8066-c7c5-b2108e23dbbb@gmx.com>
Date:   Fri, 5 Apr 2019 15:15:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="luXNWoNUXSUXLl9BWdk91AdZBUpJgOtT5"
X-Provags-ID: V03:K1:V2pD0wn8xdS7qCkqN0qzQlIsc083prkFWPBF8dxxNdIBkY5Gpdo
 WVZLm/hu0BC7flUVHY7QlaJ4ym00ph4TrA73P8jJWILSIrfB0FQQ9AAmhSTFNpvWqjETk9z
 6+gEpTFiEPNJx+xGFZJgcDtF3nia/nAoQ9Oq7oLG4GQlBme3ZrEMrSVMBrw9AJ8UJv0VR2A
 K1ovzjiw2spXR4cZiOFvA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:e1Z/B1kU2fY=:z6u+PgA/Z2jyOanG3e6jpQ
 A6lopyjqrSLIwfVuFX29mHil4dJfT/dNQZr2wB2axaPMwyNdRCmKaD783Z4wYIGtAwn4cuM1S
 cJ97ACAvxMRPmpiAEbGu7g8YMi2SjyNLjRMUWAZrWhWXbUq+nsxjP1myZ3+2V2SSXB/8YfGdo
 UnV8JRS4ewGzL7/tLjKWEZ4zPIlyt7XWHcd10pkeF3GnKDVtZeSweI1I2N88t+WW1AZwrezkN
 cFFqwl9MdrXkNYBuvmbWmxzgzWB10uKDTSEBBbHcXXiRwFjShdM0Cpg1fscsbumVjlrKI7qnb
 5+ndV4a2ZionPY5NbcS/q5VRz+BoeHjYvar9rfPXuVlk+1HmZMa4ZiQ7AeTRFtn/3X0fEL8re
 czl8GdO0HsJf65P3jOaR2csMHnDG4GQ8BWRGividzeQtQBHzBiPJbrRGUnuuyk+R3TBxgYEZm
 FGQn/ndL4R6+CN/V4Yk++ed2sVm3vGH5miRufEhAvSNvFNe672X6xjXwb07wdCwD3A37cKdvh
 m+wi0n5FhKqzIY1DNiQtrxrvcSQ/wNa+vMerBIqG90/w++qu6o5HD+GRWV+tKcnIZa5OqZ82W
 q4kclQG15LIT+0VKC6tKX1VRTy5FUqi3+iHp4XS09aOcyaj0zglPPPRsnCMjKv3Ajo+h0Fl47
 uHLVCRGO1K6aytY4xOd+ImeTPH+h9+MKgSCT1ptgkvTQI6jVj/uH/C88y1hVDOtVPc0YQES+X
 S6OUS/ZTfR7pdG0Im9ly3rTD+5DVt+GkG74xLZzGjxUqzkuezdIC3U26hNsEVx7Nqj9DnbQ6p
 1qUdxO0OxFnyq56CRtE2znLiRNwgqKLrRCzUSJGbLdI3DkUkB0jC0QXUtgkYNxgjE9pKR4SqA
 MVo5Ur1+12BFVE4i2YE/EsjQv1+jjsSwDm8Nrxz6CxuTTbP0Vwcy8fc55PqHt1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--luXNWoNUXSUXLl9BWdk91AdZBUpJgOtT5
Content-Type: multipart/mixed; boundary="WIRVftn4GKRtQYh0ApGuDoSi2GMOBNfWx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zirconium Hacker <jared.e.vb@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <59080b24-a005-8066-c7c5-b2108e23dbbb@gmx.com>
Subject: Re: btrfs balance hangs
References: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
 <CAJCQCtRbRc-KDwrprBY1O3gczydCBujd9qsM5b4+5zTLmnr82A@mail.gmail.com>
 <CALsQ4_x-VViOA5Cu4vJTqmx3xSospmiEdsEcDDBcj=uvZUmrVQ@mail.gmail.com>
 <CAJCQCtSA=f+XWy8KzpzGdpjyaBsDOT5G+aC5FU9G2Fyi-sMvrQ@mail.gmail.com>
 <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>
In-Reply-To: <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>

--WIRVftn4GKRtQYh0ApGuDoSi2GMOBNfWx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/5 =E4=B8=8B=E5=8D=881:24, Zirconium Hacker wrote:
> I've actually had a check running for the past 10 hours or so.
> It got far enough, so I stopped it.  The output is attached.
>=20

Unfortunately, your fs indeed get corrupted, but only in extent tree.

You should be able to mount the fs in RO mode and copy out the data.

But I'm surprised that balance by somehow corrupted the metadata CoW.

Would you mind to paste the output of the following command?

# btrfs ins dump-super /dev/sdh1
# btrfs ins dump-tree -b 2629033574400 /dev/sdh1

If the output of the 2nd command contains filenames, feel free to remove
filenames.
I'm just interested in which tree btrfs is trying to write into existing
tree blocks, maybe it has some clue (e.g log tree/reloc tree).

Thanks,
Qu


--WIRVftn4GKRtQYh0ApGuDoSi2GMOBNfWx--

--luXNWoNUXSUXLl9BWdk91AdZBUpJgOtT5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlynAK0ACgkQwj2R86El
/qgUNQf+PdOk6GZL311tmSKE36OAuDffvpzJOeFodqiSb9nv9u1INjQ72LyoP25I
qu+7blnHhlMpeq+ETbNuhBXEHr2TN5tc1OgkikjQfNqW0HnCuWSy/nsOr1AW/6rC
AstiOJoId5OKNYqQDjWGfGlut2P6vW8T4KEXZMPVmrbQU4QASntlGEwMpHBHitmS
i8kKFyih2CXjqZe768Wfeshw0Drz7/DY2+0CHh8qZFBHWRTubPDGVs0BJgsSd9hM
crHbaAb5Fdd6mnSaDuQrN6CAHh2wUOOYMJ+w7MYQjNRi1LSEiDCepQgcEHjeRuh4
owlm3uZkejwGA4aImFm4vugRtLJtZQ==
=loMk
-----END PGP SIGNATURE-----

--luXNWoNUXSUXLl9BWdk91AdZBUpJgOtT5--
