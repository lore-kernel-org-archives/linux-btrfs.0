Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A0DC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 022332081B
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:10:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 022332081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbeLDOKe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:10:34 -0500
Received: from mout.gmx.net ([212.227.17.22]:50511 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbeLDOKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 09:10:34 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M4ScS-1hQQG94BBc-00ygcd; Tue, 04
 Dec 2018 15:10:23 +0100
Subject: Re: [PATCH] btrfs: tree-checker: Don't check max block group size as
 current max chunk size limit is unreliable
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20181123010636.19363-1-wqu@suse.com>
 <3cd7ba2f-377f-604e-5996-fbf5086b9843@gmx.com>
 <20181204135253.GR17773@twin.jikos.cz>
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
Message-ID: <0280e21f-e274-2f00-1743-cd250abf6d30@gmx.com>
Date:   Tue, 4 Dec 2018 22:10:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181204135253.GR17773@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Zzsp9XT9MNtJCq4JV0j14YK1pUXbBSG1G"
X-Provags-ID: V03:K1:pVyI/6yEQkI7szEZ5CtZMxg2kEyGBIynfU9rPDXMg2MAmPbJEWf
 zurx5YYEpynpOCWknpxBkJQJ6lbZ7iHthWWCOJWQazeLcG5a+su6b6uO2jULFN9U9OZv0eG
 5rHaUwEIRkLlsmNvMyJvriUp2Xn52xCqWyw+fd42smT8VreogzaBIbicjP3M2LqLbdF390r
 okGEvRSasS37/2PTQaguQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ud+CJCiSzbQ=:zJcOBGF8q3vzJ2oBJQPye+
 jKRs05/P0iu1vw6h7zYVnzQZnfIn74vUhI2uJkhJWX67ZDVx05MQecrM65d88awJk9tUlVjJk
 E+zp4Vnzr/X0EptywGAqDpX5aSoR8oEuYIzTYY0Xpg89PqQjvbj5EoQHebDX3ZLrvjoLLQPOF
 g5y+AGSAxW31AnhuoS+moLGGpg3+SHpGvWv2cGNhF6EOjFnh/YywL4HWtQ9LiMJL3rJWUH9EZ
 YGzlQqrAx/d2nVsZtR0R9ClR2Z0YstCzUxJGHo95HnOfNIy09RoQita+ycSUEY2fyw7Dlfylq
 n3lStDM9g9DjR1c/ihtzq7W62akRWHIXM4f6T9HsucWhzvo6KUYVFU3d9psVbChTqI5KhiZd6
 xiijeKYzs8JZIt8xS+hlMchhFzzC/ejjyoSOJPyZpR8y0CW/3khnIT13kf1ZMEzsE4OqejJJv
 tqx+OFM7W2QSkTeqZnkJfHV2ffWSRfXsJjCN++nGgaHRbbAfa4ZZPKwNpqwo8Kirb1AVd5CNd
 HLWgVm5s+Fj67P2qQG7QsS6RLREp1Z+vASjNSfkqxOfKYeXChhmnsSsU1vy4nWOfTqHVcejbV
 2ijI52jFQ85qD6otpH/SMERfr/y0XTe+Djq1MZgFODu8h+UsBQuB4Kgi0wPRNy/WkQ/5Bz4og
 S+atlRs+0wsBSVwq9RM3H/XBEXw3HVBeim22iHQ0YibEGCIiq7+HlVI81NNcMwm6MQfd6nK7g
 9BgxqC990AdUtuQ8AqNWuqgZECyhtbpPuROddPIRpVYwivGm/KEDYRYJpHMUGa6U0ircTdieh
 qO1obqzAaC42gGlgNrhpMDUwroIJlCGLACEikJIrB0on9ufzZHK8ZWjQSmjMIkmfk60uTQMKr
 IFYGMBqeMeilrl9DPNqgz19C8mFfWhPcpVL4zbBEnM4pCwceW4vCYi1MZWsXFL
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Zzsp9XT9MNtJCq4JV0j14YK1pUXbBSG1G
Content-Type: multipart/mixed; boundary="Z5wlxarM9sQ627XtPsrE6b1dhMMc3snO2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <0280e21f-e274-2f00-1743-cd250abf6d30@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: Don't check max block group size as
 current max chunk size limit is unreliable
References: <20181123010636.19363-1-wqu@suse.com>
 <3cd7ba2f-377f-604e-5996-fbf5086b9843@gmx.com>
 <20181204135253.GR17773@twin.jikos.cz>
In-Reply-To: <20181204135253.GR17773@twin.jikos.cz>

--Z5wlxarM9sQ627XtPsrE6b1dhMMc3snO2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8B=E5=8D=889:52, David Sterba wrote:
> On Tue, Dec 04, 2018 at 06:15:13PM +0800, Qu Wenruo wrote:
>> Gentle ping.
>>
>> Please put this patch into current release as the new block group size=

>> limit check introduced in v4.19 is causing at least 2 reports in mail =
list.
>=20
> BTW, if there's an urgent fix or patch that should be considered for
> current devel cycle, please note that in the subject like
>=20
>   [PATCH for 4.20-rc] btrfs: ...
>=20
> to make it more visible.
>=20

Great thanks for this hint!

Just forgot we have such tag.

Thanks,
Qu


--Z5wlxarM9sQ627XtPsrE6b1dhMMc3snO2--

--Zzsp9XT9MNtJCq4JV0j14YK1pUXbBSG1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwGiscACgkQwj2R86El
/qgoiAf/Ti2LzbaCrSkfvWWKHsYAPGXd6kKJcwO1nLVNwztC27HL82tTibeWo+mI
INqqSGYQzlrOqxDsMcOsa/ScfrHz/b8JQPJnS0HXBP9828HcY3KPVR4yaeyrVYfm
gxwvl1JqLwPDNG+DnI2Wu8/8/DNdnjzsfVtqh9WZWoUlMWGSk4ZmBcVLHzmqc9c7
oBVJX2LTNySW202gD17yGd74L4GSjnYVjPN8lSW7WDs9z07De5MBA4lafVeKh0Hb
z0QpgJv13LW5E94sJZxIZ25NypYPaAUoH/FBuHeocMPm/0ijeQuvIucS7L3y5G4+
PPb3u6BjzpJZ2VM2waW9PeXjVclxqA==
=7ayE
-----END PGP SIGNATURE-----

--Zzsp9XT9MNtJCq4JV0j14YK1pUXbBSG1G--
