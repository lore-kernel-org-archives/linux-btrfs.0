Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66641C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 09:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345322073F
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 09:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GC9pGTAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfDOJJa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:09:30 -0400
Received: from mout.gmx.net ([212.227.17.20]:40855 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfDOJJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 05:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555319340;
        bh=xk1DFZpQMJw5qRQjdWNHLH3GCnx2/R9BJ/WRvE+5tCk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=GC9pGTAX/vkTU9MhMVSbPc9H3QjyOZOXhNotLOf6C+3PVbvP2rpOUljxgUbpaNPn6
         wfaB0UGp6TpiH6KSK/oLhDuElr7QZO6QdNkNFS5UUCq5R+lUYwbI5YUfglrLxS4glC
         5gKvnRDOWosyfqByDvSth3aofeGDZVWnxL5w93j0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIzGn-1hIQa22dQn-002TVz; Mon, 15
 Apr 2019 11:09:00 +0200
Subject: Re: [PATCH v2.1 1/3] btrfs: Remove "recovery" mount option
To:     Johannes Thumshirn <jthumshirn@suse.de>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190415053608.29003-1-wqu@suse.com>
 <20190415053608.29003-2-wqu@suse.com> <20190415090557.GB7586@linux-x5ow.site>
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
Message-ID: <ae61b9b7-254d-0e58-9350-b822312e3f11@gmx.com>
Date:   Mon, 15 Apr 2019 17:08:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415090557.GB7586@linux-x5ow.site>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9JCZDmv3awm0VK8HELfEpdJmO1OdHBLyQ"
X-Provags-ID: V03:K1:lTREkpD0BMQuTFsfwNXoI84C0B+ziJMxfQg1Ov6VQQWY32NafBO
 hgVZ6sOfyUPPJgQ5U6qQj89tlYgmPc8MylEwjDRq9Vva3x0G9NXAhkO8/tjKplxFqxrx1sH
 YUCHAQ/xPtt5IR0d8qG3REqrmzX0/WSUFNmZXcttnWCDObv2xxt7mLJKW4RnoY1MYKfWzId
 NgYfLZTT8pMC1V8QndJag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:azX2fn/EbEU=:U9HMlFUhH8mEAeBHavGdTs
 aWepX8kJlUVtMcaz1mrUG8GzA6VYg80p5Xd441TixAlVnV+lrjgO6Xt1iMcBJGDe7WiGQ9nsn
 gOfv05Q/KUP1a3x78qiqj43PEK2ChbgrM8HGL18M1SfI39dtIhUpQ+21k7xFa5XnK/jpIb86h
 fzjZWrO5Yss0ax9LF2KhxSIQ7adKrW5lqRp/SvPAtmH/zp7AZT16wbP1tpj2FswtMkT3bSeUG
 CxWmiJwKLGsGculxO9X3hPg+/jH91tmMVqZrlr74+GETAVOY7yNDSQdcmCCgSN+xJCdbcXcf6
 byyyhkeVFyb1LxDobPRarUOEE1BSQvhttmHly3ZKB7zgXxENpuIvQ75HjmLtKgDksT6ZQhJzw
 eLUIgK5pXCEiFYy9FgXTJW8JQsgsoDKbJNmSvGZZnMIdOtyLp7URnxHn0vDvWYOIY0ZyJS+P8
 WRTePSL5YafqbSew+ymUrohQlfgKLqMDSezcJk90mOEOZP/BcoKsXhdfbJBWkAyHSNeo/BXDd
 60xSC0bTmPDRGlWsvrKr0juOtvCUpAt7G5g6qYaMRJQPAJyh5pYUT3+2mAongGJIJeZmnyCac
 mwJ5GxGXuOJfH1sf9DzpVeh+aUQxg2ZuqVwlk15DtVH7NSRpQ+pk5ulPw4jZwjYwkZgknMlIh
 u17OGB8cZR9r+0V9jAz3+zpoiVYhNqjq5gmK4cus13wWOIAFBSFBzrRJii4mqT6dAhs4Ynx2Y
 O9wEwigDGKNUEzcaKWjOsn+VAtNQ2Xq40aLQMhtM5ApimOKKZUIQMxVoKHP/IjQKyqzpNiPgB
 t3JEnq8d0NZ2ISMDg2B0WXgspDCl8uXuE7lCm3kej/elU7725tqR+Tnwm2BCfM3j17RYkoyrx
 vNLGwQsY64/BW3Wg2GNWvMc3vCWfHgFSFEGuj7yyopUmBiNwH1OnoTQ55N5Bb6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9JCZDmv3awm0VK8HELfEpdJmO1OdHBLyQ
Content-Type: multipart/mixed; boundary="0dy9raYBQ1T6CecZMirS9wYobPOFqshkb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Thumshirn <jthumshirn@suse.de>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ae61b9b7-254d-0e58-9350-b822312e3f11@gmx.com>
Subject: Re: [PATCH v2.1 1/3] btrfs: Remove "recovery" mount option
References: <20190415053608.29003-1-wqu@suse.com>
 <20190415053608.29003-2-wqu@suse.com> <20190415090557.GB7586@linux-x5ow.site>
In-Reply-To: <20190415090557.GB7586@linux-x5ow.site>

--0dy9raYBQ1T6CecZMirS9wYobPOFqshkb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/15 =E4=B8=8B=E5=8D=885:05, Johannes Thumshirn wrote:
> On Mon, Apr 15, 2019 at 01:36:06PM +0800, Qu Wenruo wrote:
>> Commit 8dcddfa048de ("btrfs: Introduce new mount option usebackuproot =
to
>> replace recovery") deprecates "recovery" mount option in 2016, and it
>> has been 3 years, it should be OK to remove "recovery" mount option.
>>
>> As we're even going to deprecate the successor, "usebackuproot" mount
>> option, there isn't really much need to keep the original option.
>=20
> Has it been documented somewhere, when the mount option is due to be fi=
nally
> removed?

It is mentioned as deprecated in btrfs(5):
       recovery
           (since: 3.2, default: off, deprecated since: 4.5)

               Note
               this option has been replaced by usebackuproot and should =
not
               be used but will work on 4.5+ kernels.


The removal date is not mentioned though.

Thanks,
Qu


--0dy9raYBQ1T6CecZMirS9wYobPOFqshkb--

--9JCZDmv3awm0VK8HELfEpdJmO1OdHBLyQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly0SicACgkQwj2R86El
/qiNFAf+I490mf+oLTZ+9pjWhWvTE5/2BVZurbCNZ8YBnxeVrwdp9phDfg95yI6H
IIxFXvQ687RWpWERw4wPHG9ZNFSpilBpWz4g9NhBd72I3XxdIRAW4Hcn17g92k6a
zShTig9PH0hhzNBhPkrg7TpWKruGporlkjWH1WnKYQz8try6szGScCiVnQ9xO+DH
CPIJcKGQUeFBsVR4XDhQIj0A7BG4An2/iUIa/OCiw1PEYAdrDJHOIaEQgIoDtzjR
dcrHuVAN+wLybrpYxUzX8gUPqdjp5ZIaxraRyGul+e7ONOwjnvdlgFwo6QKVI6N9
0Yr3PRCt2fbja+U6kIPZhg+ShauLmA==
=uaMq
-----END PGP SIGNATURE-----

--9JCZDmv3awm0VK8HELfEpdJmO1OdHBLyQ--
