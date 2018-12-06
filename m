Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6F6C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 22:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8014B20878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 22:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8014B20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbeLFWvh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 17:51:37 -0500
Received: from mout.gmx.net ([212.227.17.20]:36853 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbeLFWvh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 17:51:37 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MOkQc-1gb6Ea3iIY-006A6X; Thu, 06
 Dec 2018 23:51:27 +0100
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181206193511.GF23615@twin.jikos.cz>
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
Message-ID: <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
Date:   Fri, 7 Dec 2018 06:51:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181206193511.GF23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x1ZJgyf5SZeGbAsFDbytLJIMEUjy7hnUl"
X-Provags-ID: V03:K1:TBmktzAvCao0ivPZA2IyTfXi47EeXddDqrzuXb0dj9m+Lw67Ncy
 fmjNJ+99A7pPBfBIyPTKrzmn+y3VKbsWayXUxBA1/td8Wsxvud5yEjfv6GxSbYjAxI4jdZ9
 /2z/s1T0tR0xqYJUTZVZR/Zvd2UivVd/fYacNSW84z9kC0bRC+7UVCL3prJgVFVYWctL2xy
 ixOPyHSU0aBrL+LibSmOQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MuGwmtbPTFc=:7CN25DryoAIUdMQzPKoRl5
 i0ojpzjwCqyXnkAahBTIqPtetMaAOem3bRXWpN2QG4E8LCXQeFIjGesbF/9a2Lfsj6DeifS3k
 ujQrOfgR8ZyED6NAPUre+/kRh4LIB3R5MKAbOij/83kUTrPY8YpGCu5o2SAkqPIZI1gMMk9pe
 t/M0nVYmJlyIGMp/CG9UsrQRCUaYZRzuVYY1Mske4oOMRD5C5aBq2E9scjLyJp8qHomwwehZv
 G3iO8VBGIvnUCc3D7OLIfkyXNz5pXXSH9yhxAIKvXsssdA86Xg6RNhfcy4QSICV19D4tzFlon
 uVGa50rVsuOQiTOiSBBWvAegpgJv9B0UkKKKshS7UiQ95fWq/s6y3S7jBuFe4LIczqqBgmHb9
 fpCnaW31Vg5ewCX81vJHd2SDrfymhPrwrOnqTf6eBNzL0GceWio9WlR/bwjZKkK+K4b8cTr0G
 kt6wG3fYJH9ZAzgffDZV8AmID8q3d8Gl2xo1FV+kpdrd1O8vY/HcV+Y5Jz6VwYFVPA9nFnLaH
 N6kKjXq32W8h/A1Mr+2IawqFXKd16ISjhjtaApVw640pC2VN4jqufB3ibcjJ+o1sV+dcYDmqj
 q+CZAENdNbmF/k91JY5X/pv0c5e5/ltY+/ilH3wma9ZKp2QFI5TTTEnOsFtvgBYVQZb81lX3y
 OPlfmLMQ0Han4l+O2cfcNUmIazoJJiNCaKM/S5xL+6xA6nNqoUcjPhLc/xsgxL6o2l4ZMunG5
 djwxsGz1BlaHLHmseI0/zC7LMjKYKXOSY1LtrhfBDbXknmL2oML71ixRCG3M7q5hcNGKgzPEf
 HGRlPJ4wU17BKs2mEyM5X1TpMpmQR48Hwdw4DSJqJUnsSEkjzxmrbzZjDdU0kIDrqA8o7RTkT
 0DEhb+hNDrjEp9xMPHfKINuo21KRzRXbD+f9ZzDE9Bh0xF4LvtVUi6eGFBWJLx
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x1ZJgyf5SZeGbAsFDbytLJIMEUjy7hnUl
Content-Type: multipart/mixed; boundary="kiv5sWcLeyDi8l56pcrEifGT1TNop8Ym8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181206193511.GF23615@twin.jikos.cz>
In-Reply-To: <20181206193511.GF23615@twin.jikos.cz>

--kiv5sWcLeyDi8l56pcrEifGT1TNop8Ym8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/7 =E4=B8=8A=E5=8D=883:35, David Sterba wrote:
> On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
>> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
>>> This patchset can be fetched from github:
>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_rebas=
ed
>>>
>>> Which is based on v4.20-rc1.
>>
>> Thanks, I'll add it to for-next soon.
>=20
> The branch was there for some time but not for at least a week (my
> mistake I did not notice in time). I've rebased it on top of recent
> misc-next, but without the delayed refs patchset from Josef.
>=20
> At the moment I'm considering it for merge to 4.21, there's still some
> time to pull it out in case it shows up to be too problematic. I'm
> mostly worried about the unknown interactions with the enospc updates o=
r

For that part, I don't think it would have some obvious problem for
enospc updates.

As the user-noticeable effect is the delay of reloc tree deletion.

Despite that, it's mostly transparent to extent allocation.

> generally because of lack of qgroup and reloc code reviews.

That's the biggest problem.

However most of the current qgroup + balance optimization is done inside
qgroup code (to skip certain qgroup record), if we're going to hit some
problem then this patchset would have the highest possibility to hit
problem.

Later patches will just keep tweaking qgroup to without affecting any
other parts mostly.

So I'm fine if you decide to pull it out for now.

Thanks,
Qu

>=20
> I'm going to do some testing of the rebased branch before I add it to
> for-next. The branch is ext/qu/qgroup-delay-scan in my devel repos,
> plase check if everyghing is still ok there. Thanks.
>=20


--kiv5sWcLeyDi8l56pcrEifGT1TNop8Ym8--

--x1ZJgyf5SZeGbAsFDbytLJIMEUjy7hnUl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwJp+oACgkQwj2R86El
/qiLqQf/f0vkTPYxKU+xQ9af6NL7FCHctdvy8DIanaMZ3ugKLhRnVXo9zyRORmaX
7onWoc/oCnXKaPmtI9HypFREIhO+uNarucVT8gWeeyDJoI105hOE9GgaGQWs4Mio
QcABAGEaX87Ux4UwGMyt+XMfwyzSDMsIu/jdKRn0NiMHKnpOC8vXVnAWB+TRcCGI
w58xtEtzXOw/6yGd95hQkUcPxL1h3e/r9lHcN+yeHJ3m3OZ2Dai8KGTJBU+vi57m
l/rfJ1s26ZXc4hJhuIOjLN0p/TlHChVqtRKFtIVEqLK8Wn4CqwwaB/v0qd1Mvuy7
pzVBM6NTK60CW2AThfqfKvdx60uxog==
=pxsF
-----END PGP SIGNATURE-----

--x1ZJgyf5SZeGbAsFDbytLJIMEUjy7hnUl--
