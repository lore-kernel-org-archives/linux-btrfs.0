Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C0FC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 07:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AB7E20823
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 07:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfBVH1a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:27:30 -0500
Received: from mout.gmx.net ([212.227.17.20]:58145 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbfBVH1a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 02:27:30 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MTBfe-1gV4F73dn4-00S40G; Fri, 22
 Feb 2019 08:26:33 +0100
Subject: Re: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs
 selftest
To:     Dan Carpenter <dan.carpenter@oracle.com>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190222005350.7535-1-wqu@suse.com> <20190222070022.GE1711@kadam>
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
Message-ID: <64279f3f-7223-cd5e-ad7b-4486ce104a6e@gmx.com>
Date:   Fri, 22 Feb 2019 15:26:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190222070022.GE1711@kadam>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kqym5Nw9y4B4sWKWUf204lGRwlI49XFdx"
X-Provags-ID: V03:K1:YKek4pYQThzU32YRLL+9KklaleTW6Fd8yI33W/lhN/mrDq1Ronh
 vS8gRDs8Vl7YyA9+kQd0yw+j1LQTfQUxKmc9wsn0LUk/xj3wD81ZxD4/mS30RFGC3FyfJ9t
 4wxe0VLigz9SvrzCrHr57Bdakaw0wRYi3Wy6IBQdHnKSXM6a/aJmMZAF1A63wBt9lnoodHq
 MkVgjwajOH8AW7nO0Pz/Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:M28suwljLSs=:t++Kd0K+17SNF/d+G7lol0
 Tbw+2UEkcZjTjisCMHECdx6ceHnaTThZkqy+RCK9f5+h6IZz2UeqhaW08eD5Qw9NhiN/n6DX7
 BVnLFBJIuM415+EEIa8D3f4VjMRwZILXLpAwgPd3itY1OTyt+sGn6RF5mrIY61yvCk0fu1TRZ
 DvcxLoXQcT6/Ro/SZcX08Vt56VaD7QAiWJzJG6H4PO9ai0i3PLmgyvzZJwAD4SDPCzwdxZa9s
 5c0uXQYSFI1SCHzn/g7cj/KAitLuRy0Ub5JPpAxnWZOH7UwUjr0iBI0frgGwAhZZFb5aTwtld
 /n36sYJ+qbs1JwdVr7M9j4op1dHuFpRGD71jIccX7sOsdGy811vpDWFm+fA2ZBYnVXow/pNS9
 8GxoNOHQs3UFPkrM2xO0xnYIlGMe0NLmmXXptgIZcTeK8wlyrmvh2LrTBmCJQlYrAJR8/cEvP
 D/DGGcvLRKJsJCSvObcl0iI+Nydg9bmHaxr/a5sJD153niDzw/ycYP9gLy8WsLUCYX0indovu
 7cKv57g/Sq2bgsNheGQlkzZW5zzeQp3XoyXooVt0VNVKEHOchocB+Brnlo3rRC722qUJDp5af
 YnT+lsQwgNcGmWlzn+V1DTs7QTKkbu/gehccrWryrGUva6nUfnmCe5yUwfu5B/AU7k3PaVRK/
 fOHGs0r8k+7ig87YVtsG27RAWDdb1kOtcQ6QJOj7/NKD0mRPnClyTnvfZmlkx0ReixzjsiRjE
 IliPPiDoMX9ErDi3vDRpU8PjuEV3tabcemw2pFOQlcCzxJJQDpeBIrmA5WKZhdB/57B/2FMKP
 r1vOP8N2J8zveaiJeDT7Dt9no5HRf6qzVW0EjFAPwJ57Ao01+bFXos6n6It+HLu2RFccDmUFB
 Q5gPfj9tLvJMbWCdxiO8ekC9YOzkKOEghPeJKiqhBPskoWu2EhM21ywmk4Ty7+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kqym5Nw9y4B4sWKWUf204lGRwlI49XFdx
Content-Type: multipart/mixed; boundary="MknpInfcAycvOyGOjgLn7bY382T4y8hlJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <64279f3f-7223-cd5e-ad7b-4486ce104a6e@gmx.com>
Subject: Re: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs
 selftest
References: <20190222005350.7535-1-wqu@suse.com> <20190222070022.GE1711@kadam>
In-Reply-To: <20190222070022.GE1711@kadam>

--MknpInfcAycvOyGOjgLn7bY382T4y8hlJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/22 =E4=B8=8B=E5=8D=883:00, Dan Carpenter wrote:
> I'm sorry, I feel bad for passing this work on to you when you didn't
> introduce the problems at all.

No problem at all.

Who doesn't like to send out clean up patches?

>=20
> I think you're doing to the right thing to change it all to error
> pointers, and most of callers expect that but there are a couple that
> need to be changed:  btrfs_test_qgroups() and run_test().
Thanks for pointing them all.

I'll double check the call chains in next version.

Thanks,
Qu

>=20
> regards,
> dan carpenter
>=20
>=20


--MknpInfcAycvOyGOjgLn7bY382T4y8hlJ--

--kqym5Nw9y4B4sWKWUf204lGRwlI49XFdx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxvpBkACgkQwj2R86El
/qjURQf+N3PWisQxgczD/d8YqrocJIWxq7I9zftquk6XFfGG66RhbFlNjNoddW8Z
OfMVneD/7IdSGMwTOExqD9Nj40rRslqrH/4alH6KBy/LiWXbeDcRSv/QKHYO5o2O
Pdiu0F9t0RNK4YsR/UYabqrxPCUJW7VixTfbRMv3RQJVJGj8N8EcIgqdGHftLMBJ
WoMal5wx4Gms4HnSvmfVnnRkNqeg9SRk8+dONLw/RCvaiXVXse1hQwJJbgCuBvic
iMyVS7Ewdzgn5t5yqNCle0OhTADFReGTpEpW2KyLs1DCoCm/qvT6zolkoS4U5usQ
83zvGGOor0dJG3B909UkQIomsKTK0A==
=PKgy
-----END PGP SIGNATURE-----

--kqym5Nw9y4B4sWKWUf204lGRwlI49XFdx--
