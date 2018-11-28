Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44AFC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD1AF20832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD1AF20832
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbeK2AwD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:52:03 -0500
Received: from mout.gmx.net ([212.227.17.20]:35607 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbeK2AwD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 19:52:03 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MPZuP-1gNrMK2WZd-004mdp; Wed, 28
 Nov 2018 14:50:15 +0100
Subject: Re: [PATCH 0/9] Switch defines to enums
To:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <45dcab9e-fb88-8980-90d9-1875ea1ee992@gmx.com>
 <20181128132549.GM2842@twin.jikos.cz>
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
Message-ID: <03fc4e39-205c-9bac-33f0-cc3fb19ede6e@gmx.com>
Date:   Wed, 28 Nov 2018 21:50:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181128132549.GM2842@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wonZRvP8wpInTlmhV9dRZYmV7P5tvBC0V"
X-Provags-ID: V03:K1:pbYjGsJKLfG8xpGur7N5+W9V0WEoz3vaJY0u0r+pTENgAPhlJVr
 DatvCr7nRbhgrA6yf9pS0QRSWcGH/mqX11jopaU1BlS8wmUIWmO5xG+mXTN86lQh+qhq/Gx
 9cYI2iuhZHudgjzjYJsxPXoIP5vTJVXtCS9WZy8fUSo7lXICPaDfZbs770dcSZTqJR5y0F/
 Wgt19VWTa/lZtcF6CIc4A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LAEGcFQqpKA=:vJkEK0mjMD0rdPhF0cYPKE
 oQg6Tu8Illn4kImEBQ2NDus/QrHSxUPAM+PfxNNG5B+gYGqW0LwlajaTHVL3pbAEyLtjxtq+f
 b/d+AjKevV4zTd2xFIVMfoAd04X2lOLw86DIj5ql5HFu/FTYH5ORXYOabw2zk0PZbBNPcnMB0
 gRVI/fkipR+sgbF42rGPGfrmP0L2udyqdHsfpbCip/UfgxiROrMcjIrxuYR1ZkqmjhUdD0Pfr
 pGRbWjUmw9/aN7OEVEzSs0ZNrOcu5a1ulFjjjIfaeRmSXYwr4JwVZ4uxYWhz3PvcM2evZc9BU
 Px5u+cthbi9Ri37Su1VR1w20TEqPOU4V/hQQVRxcVu4xKfv9ewj3z/GV68Q+9nQRzfVb6qQHZ
 Y58hmZZCQF6Tn3/3C/CvW1Q8HuxZIv3qzBYHiex5zltgBfBrnnXYvWhOOBMZYZ75CCA83tLD5
 3iZ3Q0P0tTVTd+dU11d9s1KeuulPorDd19f79FK1F+8LhSOvTP50MxR29aZcYpQJowZZ371xu
 nIY1hts+TBC7jYbX4Ldl715bDCtSMHv5K4bzuSKHhujG6jL1ESdzs/6rOEO2lVitTgpSKAyy+
 5m5+mGHGt4fRwNtTtseFBSdmKmYVPxehMezJa+/nM5CwpFFHI3jUQ8GjCwTqubtcNYsR4uOAa
 VCXhYrlw2oGONmVj/BRgg8ojPMV8X6rM5jrNfBK8joisBFCFh1Jlkbu7plrv1BDy6ESH1kmnY
 PIxFrkB7n6i+WsNfm9/kQQaTLyjc2s4xNJt9BHty3ZGjshg/YnaS3XfUcGxzOfDM3F609l9ZO
 GBLWiHIHkYjBy06IiVlLM+iZiNwCp6+fnVBmKgOsnmH9nRlPOdYYq821ZVGwbKxVjQjRCuMJk
 s0Tm8s1DkpW1nb2R/cJsXfd3CoV3bBKpDvErSWYnsQ9Aiojak9yHjeFh56v8Pc
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wonZRvP8wpInTlmhV9dRZYmV7P5tvBC0V
Content-Type: multipart/mixed; boundary="iwWAiKL4VyBN51eJtPTNswMdKzk6L6tWc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <03fc4e39-205c-9bac-33f0-cc3fb19ede6e@gmx.com>
Subject: Re: [PATCH 0/9] Switch defines to enums
References: <cover.1543348078.git.dsterba@suse.com>
 <45dcab9e-fb88-8980-90d9-1875ea1ee992@gmx.com>
 <20181128132549.GM2842@twin.jikos.cz>
In-Reply-To: <20181128132549.GM2842@twin.jikos.cz>

--iwWAiKL4VyBN51eJtPTNswMdKzk6L6tWc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8B=E5=8D=889:25, David Sterba wrote:
> On Wed, Nov 28, 2018 at 09:33:50AM +0800, Qu Wenruo wrote:
>> On 2018/11/28 =E4=B8=8A=E5=8D=883:53, David Sterba wrote:
>>> This is motivated by a merging mistake that happened a few releases a=
go.
>>> Two patches updated BTRFS_FS_* flags independently to the same value,=

>>> git did not see any direct merge conflict. The two values got mixed a=
t
>>> runtime and caused crash.
>>>
>>> Update all #define sequential values, the above merging problem would=

>>> not happen as there would be a conflict and the enum value
>>> auto-increment would prevent duplicated values anyway.
>>
>> Just one small question for the bitmap usage.
>>
>> For enum we won't directly know the last number is, my concern is if
>> we're using u16 as bitmap and there is some enum over 15, will we get =
a
>> warning at compile time or some bug would just sneak into kernel?
>=20
> Do you have a concrete example where this would happen? Most bits are
> used in 'long' that should be at least 32. I'm not aware of 16bit bits
> flags.
>=20

OK, I'm too paranoid here.

The set_bit() definition needs unsigned long *, and passing a u16 * will
cause compile time warning, so it shouldn't be a problem.

And for enum over 63, reviewers will definitely complain anyway.

Thanks,
Qu


--iwWAiKL4VyBN51eJtPTNswMdKzk6L6tWc--

--wonZRvP8wpInTlmhV9dRZYmV7P5tvBC0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv+nQ4ACgkQwj2R86El
/qj0FQf+JdVAIsJsdqJT8Ul/jVuxBMomy1JxnfNI4F8ViiLioRBpiKouU22Dv28m
ET303+qhluRsyZxjpcMiiiVOkI8IMReOlA27A/9sAVkmP///GNj+j6bDNfMj0vn9
53yhR5Bq4H9P6uQdPb8lFxrPDTMtSSJBFKUCEPkMtuSOmJ8uxor0MZBK4QAahSfK
ZOabbweEz3g0Yft4ESoD/Xj72/lKDweUiQwJKFkwM+zQWQCijK7LfjezBorFMYqv
L1e9ZQDEt217YyDJzop0L+IkNXZlUyI/hHAc2bSF8h8JS3YiM7bUJc/YGPRdKCqd
9TKi2BXyH/uZsFog9KvNuhA2SdPFMw==
=USxY
-----END PGP SIGNATURE-----

--wonZRvP8wpInTlmhV9dRZYmV7P5tvBC0V--
