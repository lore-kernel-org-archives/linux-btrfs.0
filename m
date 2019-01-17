Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FEBC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53132205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfAQOMd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:12:33 -0500
Received: from mout.gmx.net ([212.227.15.19]:55457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfAQOMd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 09:12:33 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lz3nU-1hEuqa1FJY-014CRr; Thu, 17
 Jan 2019 15:12:31 +0100
Subject: Re: issue mounting volume
To:     Christian Schneider <christian@ch-sc.de>,
        linux-btrfs@vger.kernel.org
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
 <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
 <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>
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
Message-ID: <6c33c8a0-2dd0-c43f-3ddc-5f24ed609a43@gmx.com>
Date:   Thu, 17 Jan 2019 22:12:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="agGVbSujZMvK289r0hXbjZ8xqj9GEYKDX"
X-Provags-ID: V03:K1:1UtCdy54zOD0pfOnJS5siUkJrgIR/ZaCmBgneVarPG+Px2EYQGH
 Twrmj5p0dyK8jh3sTXDePk5bq7cz1hh8ZTOIGtz6SwROnc6SYwUkcuCJ325r5KpX1xLtKbG
 m5TWZ6v6VHg47oblPXkLFHWH8oQwGElYDekKlKa2cH2dV1LnHXjQVn6exlJdnfnkI0Zl4oK
 yGVL3QncCoca884Q8uk0g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:O+HtfdR56mY=:MpqjA0p0w8GiAbBbfUiGnG
 S0Eqf56ebMBZ3NNGzz6XgAJfxz3YEXK575EtOXer7niNMba1h3GR/+BF9BvoqWqjzBxQEKfK3
 6XTjpanAednBDCmFffAbPLcMUATSx6gt/Nvqvib6u0zb0XiCtfsZovoAbMwXdtj1v1dUjzepH
 OZaJIPDHN09bEecGHLt5ZsyG8Tudc20XdYoBNCF2QrUMNM8DoXDvL1zu1cu+M0/8npH6Nm78g
 U/sQQqZhGHcARzZ49T+9IGrnDV072G6F47Ms8COt214PTzCKDL4J/KU6Bp3aTK4lsUCXYYQU+
 uWVuV6Uz0H4mB7nvA14HXP43urYYeE4Wl4xsBQJmbp1kSOtEYWcgipQWOyDeWf3L88DAC2tCJ
 CUFV5/+OL8EURz7spWVbHVgfS3YBGdeHEalVh8uLfSe7rElgqopmMgpRidSevho59iRz1QauA
 gFLX3ek9+r1widlO1w3YSYs0azGCSEtsJFKsRBSzu1UQyZgW8AE+gpvwmUyN2RLLpJEC7uHZ4
 v0WjSwGxYabVb60sqASMwhqoCb+vGVzNJrJwEfjn8mwpLrGZhJSwe1gmWldaEpnnhU9OgeXcH
 rMPQMxdWPboFDt7na49GVIRJAPmctHNJ6lgm+Oq/PPSZinK9wdiiydddKYr6ohEyH+8tFVj/l
 Gvfm4i3TdcmyqQI+47NEe2Z4tY92rftRzUD8fA2wf20qZOd80qiTmMfkz5aki8jJG0TsYQ4C6
 49JpFI8525RFGowmMzZ/hnc72qQz2gETLvhi7aKpvlfKLOjPLNmJqAfKXYJDTuzfQZYxGsY8i
 AxD2lLhz+5vByQMGQ/hHSDcH7wB8aRaLvcfpwhbtbXoy89ytAipZRuy4vtc0a901tJJOUFTmv
 j95vJw+2CfdcyBtb4te/PprhJSefCCFZcEEJm5OtAyTo5KY7EGes5sgOv46h9o
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--agGVbSujZMvK289r0hXbjZ8xqj9GEYKDX
Content-Type: multipart/mixed; boundary="egny2LKpsf8CX1MjUKHBD3GtZgtlEPxBX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christian Schneider <christian@ch-sc.de>, linux-btrfs@vger.kernel.org
Message-ID: <6c33c8a0-2dd0-c43f-3ddc-5f24ed609a43@gmx.com>
Subject: Re: issue mounting volume
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
 <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
 <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>
In-Reply-To: <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>

--egny2LKpsf8CX1MjUKHBD3GtZgtlEPxBX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/17 =E4=B8=8B=E5=8D=889:54, Christian Schneider wrote:
>>>
>>> Do you know, which kernel is needed as base for the patch? Can I appl=
y
>>> it to 4.19 or do I need more recent? If you don't know, I can just tr=
y
>>> it out.
>>
>> My base is v5.0-rc1.
>>
>> Although I think there shouldn't be too many conflicts for older kerne=
ls.
>>
> I could apply the patch on 4.19, but compilation failed. So I went
> straight to master, where it worked, and I could even mount the fs now.=

>=20
> Your patch also has a positive impact on free space:
>=20
> =C2=A0df -h /home
> Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% Mou=
nted on
> /dev/md42=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7.3T=C2=A0 1.9T=C2=A0 1.8=
P=C2=A0=C2=A0 1% /home
>=20
> 1.8PB available space should be enough for the next few years :D
>=20
> Thank you very much so far!!!
>=20
> So, for further steps: As far as I understood, no possibility to repair=

> the fs?

Unfortunately, no possibility.

The corruption of extent tree is pretty nasty.
Your metadata CoW is completely broken.
It really doesn't make much sense to repair, and I don't really believe
the repaired result could be any good.

> I just get the data I can and create it new?

Yep.

And just a general tip, for any unexpected power loss, do a btrfs check
--readonly before doing RW mount.

It would help us to detect and locate possible cause of any corruption
before it cause more damage.

Thanks,
Qu

>=20
> BR, CHristian


--egny2LKpsf8CX1MjUKHBD3GtZgtlEPxBX--

--agGVbSujZMvK289r0hXbjZ8xqj9GEYKDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxAjUcACgkQwj2R86El
/qgQNwf9FBsdE+Vi8itC5vKXdLDr5FWp8jmiBtH2m6kQwoPKCEgEPfNRMKxQANw6
tH3aYhNSyI928rbMlXeIu3O3aisO4V4Mry9TF9ko4QDrIXE9Yhhfz07g8Y18flwe
yIMidSSsMvQ2BnfjydHUB5RGOlX/4Einfj3lm1R11r5tYfkj/hYxeT7QjQyYSWqa
R+irpaoZ3bFAePR2LSECC00l8e2l1RK6oScAm4Ebdb3ZHLqHX8f/HOq31XrFJax6
ht6kfuuOmBeyrM8PtDf1++ao0rtcznh9Etn2CB9zD/aXOmUpIxhh32k4XT56h/LH
emPlXpqcokN4ACCxhtzUV5GXLRuX3g==
=HV+X
-----END PGP SIGNATURE-----

--agGVbSujZMvK289r0hXbjZ8xqj9GEYKDX--
