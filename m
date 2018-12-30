Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA0CC43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 00:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11ADE20815
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 00:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbeL3AgP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 19:36:15 -0500
Received: from mout.gmx.net ([212.227.15.15]:47255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbeL3AgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 19:36:14 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LeMij-1h7XpF0t7l-00q6oC; Sun, 30
 Dec 2018 01:36:09 +0100
Subject: Re: Checksum errors
To:     Josh Holland <josh@inv.alid.pw>, linux-btrfs@vger.kernel.org
References: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>
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
Message-ID: <67b0235e-d79d-e0ff-fba6-310ad637ff98@gmx.com>
Date:   Sun, 30 Dec 2018 08:36:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kKZyl7g3F5uKh0OdYhhyOn9Jl2VsGLSZs"
X-Provags-ID: V03:K1:iUt101xEvR7G+8cKaDT+y12QkLgECS9YiaKBSJl00SBC6e6VdA/
 7pgjXIGLByqg4hhXH6P+f7S+adGKn/RNYLsuB0zxQe49+WIbwqqnJmJB5AIN8lbq8Wwem10
 gZFy7Gz+r/QKX6GX68QNm9NDhLtqy2bm1GJ618y7R1QaQczt0/hUsX2py0//4rDVQGQL5ZP
 Tn9wxHWrRrcEESySrR1nQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Bgy7hDg+ApM=:XISooOe5fL4ZWzBrjt+y41
 hZXMIKjgA/k7WV+5OlVF+M46djt6fZ29HnOVoEvs7XyJYww7juOwKsJd19n8zdBQqoIiovI7u
 3EzR9HmtBwYAJrqUspNLqm1AfidG6HMrrisVphzf75unALyhRPZFavt3uTO87BLv+GC9xp/Xl
 S9qYy3HK0U2QlwZsEKh1ZgPXvEQJJiSPCNoj3j45xfDT+6CC45YYaJaKu4UynOdyqE41v/bmU
 Vili657aba3juggyOzgI0Rix1plE3JuVjtAB1tSKH5xaFn23cz9joo/YlbY1xjUVu6Xbbqse+
 HZZF519gUnkpLTACA1hcAB2LEQNU2wSApMKhWRMjiqVSY2MH5uTcea6fc/PcDhOs0dsbTN27/
 JdEluXjkI1jbim5HBz03vdumGEzPS2ixli1eRH9q6pyojjTF83J3SVUukupZVKxhz3lboQ0xz
 2lOgbsE06Y1Enz4gFUjPVjVWlaGi4eFnP9uB0mXbWf6fimgZ7NdSl1uvmrl3v7Z+EhM4Xhwbx
 EIi058Ii0tZJGzgXg0kkEQy8c3P8ZCTcGdgOpz4x10nV6hyq4yq2lm9iAE4QdhUWSo6A5W5PH
 mUg6cplLmPPujSrRzJHSY8crPnd1bOmybA74y5qTWoHDuK6q4lgNl9AVBQGtYncckSk1l8D+W
 59tYbGsO1YwvR5P5wCLsnBq3xV71VIcsDr4FIBb19xQCs2gUx0dplLINShNBm0D6Sa+7Takna
 DrY1mh9DrYm7eQe8VSEGlMYK4Fi7ohh4Lb0ha2McOG8gCPCM6tuAzlQt0H3sjGrs7pfHSyUW6
 UfyspOr/62qA9d4GLvkWEAknWPDOIS/gIjtzpTEqQyxsMquGLzdtHT2dERRo8fDM9HtTB/YJF
 KIZzDSnvW9sJe2QGVLJeFWGU8+O9aZlBAau9LSqwz8KCQJJAijBZGE6OxKL8cR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kKZyl7g3F5uKh0OdYhhyOn9Jl2VsGLSZs
Content-Type: multipart/mixed; boundary="wsOhVAZ50sOOo0DXGCbBRtdL6wmTyrjh5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josh Holland <josh@inv.alid.pw>, linux-btrfs@vger.kernel.org
Message-ID: <67b0235e-d79d-e0ff-fba6-310ad637ff98@gmx.com>
Subject: Re: Checksum errors
References: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>
In-Reply-To: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>

--wsOhVAZ50sOOo0DXGCbBRtdL6wmTyrjh5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/30 =E4=B8=8A=E5=8D=887:56, Josh Holland wrote:
> Hi,
>=20
> My btrfs partition will not mount. I spent some time in the IRC, where =
darkling said it was due to checksum errors, but we couldn't find a solut=
ion. The kernel version is 4.19.12 and btrfsprogs are at 4.19.1. Unfortun=
ately I wasn't able to get a network connection on the computer in questi=
on, so instead of using a pastebin I shared pictures from my phone, linke=
d below.=20
>=20
> dmesg errors: https://oc.inv.alid.pw/s/ZHdJprfg4ZQmXWG

Good report, it shows the error straightforward.

One (or all) tree block of your root tree is corrupted.
Thus btrfs fails to mount.

Normally it really means some data doesn't match on disk.

It's really recommended to check the SMART info or check if your
underlying dm devices doesn't have something wrong.

> btrfs check output: https://oc.inv.alid.pw/s/JabKEqpXG3greq3

BTW, super block number starts from 0, max to 2, and your devices is not
large enough to have the 3rd super block.

Despite that, it shows the same error as kernel.

> btrfs inspect dump-super: https://oc.inv.alid.pw/s/RqKSRkg7Z7n8AyF

Since it's root tree corruption, you don't have much chance.

But you could still try to use backup roots.

You could user dump-super -f to show backup roots like:
$ btrfs ins dump-super -f <device> | grep backup_tree_root
		backup_tree_root:	30408704	gen: 400	level: 1
		backup_tree_root:	753545216	gen: 397	level: 1
		backup_tree_root:	760516608	gen: 398	level: 1
		backup_tree_root:	759857152	gen: 399	level: 1


Then try "btrfs check -r <number> <device>" to see if any of them has a
better result.

Thanks,
Qu


>=20
> I'll probably end up restoring this from my backups, but I'd prefer not=
 to have to do that unless it's really necessary. Any help is much apprec=
iated; I'll try getting the network up to paste the errors in plain text =
tomorrow, along with a full copy of dmesg.=20
>=20
> Thanks,
> Josh
>=20


--wsOhVAZ50sOOo0DXGCbBRtdL6wmTyrjh5--

--kKZyl7g3F5uKh0OdYhhyOn9Jl2VsGLSZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwoEvQACgkQwj2R86El
/qiRdAf+NPZ3vckwEAnaPlsQbwlczAZuQns3ATiCpAwh1PKGh3z5loUQrqUtOM3i
eZQFdEWaQmAxwupdVK7Nm3oiceAk8kXQVxvIcgLj18ouzLx9TqbuVA6wAF4cmtce
DSJLCqgPOWDDZZ+wtsPy0JGpNbsJX097vMVyCnK1TtG3KU2Kvw3gKPo9vXmxUdt0
EaoE2tCSZbs8t+Jq8JanTYhhj1ccFrumxctF8gt4Cq5dVGeFAnjkTLLomQuDPxpm
Sb73RwgRnvkDx1DcFYVUyMugQoVWL05D2++0cEEQ/bBwa9UoexrSSE1sDqCqOd1O
2tCKvO5EFhi3JuMqm7tfvxUlqXWk3g==
=OIX1
-----END PGP SIGNATURE-----

--kKZyl7g3F5uKh0OdYhhyOn9Jl2VsGLSZs--
