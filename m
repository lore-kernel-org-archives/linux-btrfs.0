Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197BAC04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 05:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CA220851
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 05:58:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7CA220851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbeLCF7C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 00:59:02 -0500
Received: from mout.gmx.net ([212.227.17.22]:33961 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbeLCF7B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 00:59:01 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MQih7-1gvRQA2UCT-00U6nz; Mon, 03
 Dec 2018 06:58:48 +0100
Subject: Re: Need help with potential ~45TB dataloss
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Patrick Dijkgraaf <bolderbast@duckstad.net>,
        linux-btrfs@vger.kernel.org
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
 <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>
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
Message-ID: <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
Date:   Mon, 3 Dec 2018 13:58:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mB2SR6cLb5zPRoJE1XK4SrCZmSLB9J48k"
X-Provags-ID: V03:K1:HMXXM3OgJR6pX62yS7Qy9coR96NRr+IGCNT7a5MFUeEQpw+os00
 NXwpJH8UQWeBvmzI9Vn4JbPGt0JdEFkb3F+yOykphFKMNhlNMldWPYS+k5g8TwD2NllaI1G
 JY5wCCpNW+Ao8F6HaDkyrNOMDOdeQ/6l3mbZudXKqGMD0mbkEhC87fJ9ulxzdK3dS1Pl/PV
 +NaxyajahzgPajzyrq/DQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:apvR87KauK4=:ZTpe9aYFcwpkRQDRPlnu9f
 O/zvMOZAxtEn8+nJP2Od4fZRxAB0dSJGosMz1wqXhDa+oOpKQa6ly8VqUFjSWb5kqd9a+nb/x
 fQcMHfF692szCZHn+BgGH2Znk1mYy4paXole1Eiw3oQWHsQSv713ynMfcTmFOOGSVXWDpcNvP
 vjfKnrHGS5Bk1vr2W6ys6KEVPEKpuw37BskQrI/vjTaZjDc3weYx4/SLdSIAz/M7HweAFk54W
 XyPaW0vT/5MV3sImxGHIJB8BcA3xhdX4epqTSxZD87xhK2whty/z9wpLIT/r3/wniad8RQq4d
 R5xCYmCnsS6KyE8u/LnpbDbv3XGGYQ4UHtdHvTfP+ewKI5EsaUU/jogPV1Hc21KeMHcjiJNfI
 jWA0uVHLDHLDwaWAgDfjFXO8OS0XG0xvcBpPwg5DWUGyjesUseBlzu7B5wA7T9/IwZIqz7aBQ
 O1j7tb6eAoYOLjUBCJN9vgfD3eA9SE3LdYMW7VinlEqa3QjMAy99Q+f/X6tRtNci23f5+euAI
 TYreB4mE8lTJ3IFyn/h33wiB2p/NTMfrZN2VX+CvnJflAVSl1iCvpKPjqZORmx8V92S2pEmF9
 U7EwU95ehASSQoSHbsc7Ln+lp72ehZIh4xyRR26DKWp27evIFi0wdOf2drOiddqndEANG23mM
 ztogNzfsGoTKRMKXLSSVn3MlwAQoWVIgMaYVYPYIz/AHhWWWeO0pSk1LHvm/fg36+aocS5Jkk
 7Qf4oykZu3rn0RRGs1zeFCslEUJ2I12t9CahMZPBeo/Msu3YN+uIblsXgYjBPyLLxIZvDXaQJ
 nOeDcG7aMBQK3kI1NoOZFzUYPDel8pvWOOe2FC5SfrepPCQQWcZH6sclkmlKAekPojkE/Vb9+
 xl11HFp/EvWauh4ZKpsWDT0xiuMEiBpAM8R72E2uigtBB1MHWJnqE9GyiIKua5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mB2SR6cLb5zPRoJE1XK4SrCZmSLB9J48k
Content-Type: multipart/mixed; boundary="Qa8DMbcRZcapIHrt1w5YsPyBnD334HU2T";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
 Patrick Dijkgraaf <bolderbast@duckstad.net>, linux-btrfs@vger.kernel.org
Message-ID: <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
Subject: Re: Need help with potential ~45TB dataloss
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
 <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>
In-Reply-To: <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>

--Qa8DMbcRZcapIHrt1w5YsPyBnD334HU2T
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/3 =E4=B8=8A=E5=8D=884:30, Andrei Borzenkov wrote:
> 02.12.2018 23:14, Patrick Dijkgraaf =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> I have some additional info.
>>
>> I found the reason the FS got corrupted. It was a single failing drive=
,
>> which caused the entire cabinet (containing 7 drives) to reset. So the=

>> FS suddenly lost 7 drives.
>>
>=20
> This remains mystery for me. btrfs is marketed to be always consistent
> on disk - you either have previous full transaction or current full
> transaction. If current transaction was interrupted the promise is you
> are left with previous valid consistent transaction.
>=20
> Obviously this is not what happens in practice. Which nullifies the mai=
n
> selling point of btrfs.
>=20
> Unless this is expected behavior, it sounds like some barriers are
> missing and summary data is updated before (and without waiting for)
> subordinate data. And if it is expected behavior ...

There are one (unfortunately) known problem for RAID5/6 and one special
problem for RAID6.

The common problem is write hole.
For a RAID5 stripe like:
        Disk 1      |        Disk 2        |       Disk 3
---------------------------------------------------------------
        DATA1       |        DATA2         |       PARITY

If we have written something into DATA1, but powerloss happened before
we update PARITY in disk 3.
In this case, we can't tolerant Disk 2 loss, since DATA1 doesn't match
PARAITY anymore.

Without the ability to know what exactly block we have written, for
write hole problem exists for any parity based solution, including BTRFS
RAID5/6.

=46rom the guys in the mail list, other RAID5/6 implementations have thei=
r
own record of which block is updated on-disk, and for powerloss case
they will rebuild involved stripes.

Since btrfs doesn't has such ability, we need to scrub the whole fs to
regain the disk loss tolerance (and hope there will not be another power
loss during it)


The RAID6 special problem is the missing of rebuilt retry logic.
(Not any more after 4.16 kernel, but still missing btrfs-progs support)

For a RAID6 stripe like:
    Disk 1     |    Disk 2      |     Disk 3     |    Disk 4
----------------------------------------------------------------
    DATA1      |    DATA2       |       P        |      Q

If data read from DATA1 failed, we have 3 ways to rebuild the data:
1) Using DATA2 and P (just as RAID5)
2) Using P and Q
3) Using DATA2 and Q

However until 4.16 we won't retry all possible ways to build it.
(Thanks Liu for solving this problem).

Thanks,
Qu

>=20
>> I have removed the failed drive, so the RAID is now degraded. I hope
>> the data is still recoverable... =E2=98=B9
>>
>=20


--Qa8DMbcRZcapIHrt1w5YsPyBnD334HU2T--

--mB2SR6cLb5zPRoJE1XK4SrCZmSLB9J48k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwExhQACgkQwj2R86El
/qgvKggAgSypXnbtLuXxgPpjOHaOfArUOnjOcvhEqHfJMv0aitrcORYXNsHXBKI3
MiHEaAARQ68R9zOSTO4TkxzQYBWRIpXR0E6rBsUihtrvIHwYlxWpkqL5agRkkbcp
WB3zssebnpMIw9MW2OlvV5zju5XshJjFVLxcYZO18FzulbT9lyNaxHS9tRSIECPr
OyBTBLhTIvsKyl3ezirANR155kqm5UlomGIJrR3VFBa70+R2Wh59/iZSJsswH82u
W6Xea0JYUrF43b7/6sg8D/A/Uk/4YsBY4DEUeSfgsT6OsYfHD15Usc3PE31LdKSm
yyK0RnfcVU9MiI6gh4qHOnUfQ1ImHQ==
=MhOR
-----END PGP SIGNATURE-----

--mB2SR6cLb5zPRoJE1XK4SrCZmSLB9J48k--
