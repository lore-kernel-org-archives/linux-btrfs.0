Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19132C282DA
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 05:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA16E21871
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 05:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dyW3Co2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfDFFFk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 01:05:40 -0400
Received: from mout.gmx.net ([212.227.17.21]:37005 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbfDFFFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 01:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554527126;
        bh=yYPcca++Mfz2O+GKhxO8EU0OCLJtX4IMFtIF18iuLUM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dyW3Co2k1XIcZWIFCBpBbc+zDDm9ZgCFUuuSYU7+wm6rWm4hvBCEBj9n1VM8MV0dU
         Z2TS2UwlcFlKTDgI9W65kbRR1GWCfSHt6Lo8aFJ665i6iz+xaAiCOKEci2dLKy8HXk
         pMvPzrpzQ0SwMr8/Gf4LYijklPS81PunW3Ise3kY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MJGFi-1hAzct2HO6-002kht; Sat, 06
 Apr 2019 07:05:26 +0200
Subject: Re: [PATCH 2/2] btrfs: Add error string for EUCLEAN
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190406031426.22436-1-wqu@suse.com>
 <20190406031426.22436-2-wqu@suse.com> <20190406045008.GE1177@magnolia>
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
Message-ID: <02797135-0903-4d4d-67a1-469a13e20397@gmx.com>
Date:   Sat, 6 Apr 2019 13:05:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190406045008.GE1177@magnolia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yTSSloOMLYS5AQH4jD6jlwZPIjn29aXGc"
X-Provags-ID: V03:K1:2hylOcFYgRghBhTibzjugiy5J2YN2sG6Z1WiqLX8xlwXzJPZG3t
 EHfHJLRckO8MzTmRvMqN238MGUBEKmmQ3pLaOyeCP0GXic87zkOwzYRUVgdPDmj/nr+o2kC
 2uidVUXZd1U+u8R2HJRNt7fnKsTECrmCAW/wbjUHhTXn7kK4oNlKkplaT8znjzwfuEMlHV9
 13g8LhoLngj3iFrScg+eA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:487tpBpLW0g=:zvcoQ3yfv9DDZA6d8zqgCf
 u4CEH+v+M9q0W8nKmHuZtPt8lMJLjszI5ofuxBy8suiN+NAIC7/ax516oeai5zh1Fst71hl8k
 ePt4qTwbqRTE7sbmGsrPJNPNj0Lq04DuKS99NtDNE/pOhnETiEZ/jJ1e6JUvEyvb12uKhN1g4
 wrfeTSMmgy13v7fMPwUN0DodhZfWT+CSzCGA4KcsMlhyCSw2g5JWS2CYYAvD1niHVsCc3aoHf
 B1pW+5hVZ0/VGCoYXBLqpdpdbfFWg/cczfIQ1qPa0sQwjRHrOt3O2u2PeBaygxjorftNOjxxw
 FYQVlqymVa2rriVFMiPP/gcRG4gXxk3fPvpHv0goDSYj6DUidtM8lPRRIpEnEWuvtiFjR5/7e
 kbeQAmhl3ivpRUBf6a4jhpy2nvYHVcBZBYocFYZb0x4bgwYbMBkdmwUYDFh+R5RPUPe/poS7v
 fbj6AYqqTCFI8DNJbkCABZBl4Zv85ZPNHF5sN5vPd/GoPpBd0LJ/fC6E/WiMBh7K6aALv5etX
 3ujlvFZzaRPdMRSdbPm0H7B9gHe1tgp5wnAllBwg6RL2LBw6Zv8kOKoxfLOqkKwuir+0Dv4Z2
 lbND+MvZXxDvvjAKPT7CJ616w2x27u+6MvkgkyK4qWO3doy7msD3pp9cgnT1LiVBc16rhwONk
 ffug2k1/17r/7Piyz4FfzYSKUlI+A2Nnyo7eOo40kYAXwHY9QdCwQjZVjmtybDvkTD9o41K6D
 /oR81i8WiZlKwp5rW8+fWOLFtlh34UiCiLmcUa0tlPlQRNSNRWY9zoQzqZBM8uU6GPoO8Uzat
 o9MPCWdwNb19+X4hdF0boRM6tvDL9R1jHXYnAD/ltAOz0Fgat9L9aPCxCoUNMa1dwlrOariK4
 YHY5LH5+2tgbpk3EKxXj/Xez49JOs8MddQzndR2tC6S0kH9UIDEODBwqjUcKcq
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yTSSloOMLYS5AQH4jD6jlwZPIjn29aXGc
Content-Type: multipart/mixed; boundary="8nDXvpMAsL2EgVod5cXBTOywmJs4qoybA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Message-ID: <02797135-0903-4d4d-67a1-469a13e20397@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: Add error string for EUCLEAN
References: <20190406031426.22436-1-wqu@suse.com>
 <20190406031426.22436-2-wqu@suse.com> <20190406045008.GE1177@magnolia>
In-Reply-To: <20190406045008.GE1177@magnolia>

--8nDXvpMAsL2EgVod5cXBTOywmJs4qoybA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8B=E5=8D=8812:50, Darrick J. Wong wrote:
> On Sat, Apr 06, 2019 at 11:14:26AM +0800, Qu Wenruo wrote:
>> Since we're going to support write time tree checker, it's possible th=
at
>> transaction get aborted due to tree-checker, also due to new
>> BLK_STS_SELFTEST bit, we can distinguish real EIO error and EUCLEAN
>> error.
>>
>> Now add error string for EUCLEAN too.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/super.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 120e4340792a..a4cbbd7861d3 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -86,6 +86,9 @@ const char *btrfs_decode_error(int errno)
>>  	case -ENOENT:
>>  		errstr =3D "No such entry";
>>  		break;
>> +	case -EUCLEAN:
>> +		errstr =3D "Selftest failure";
>> +		break;
>=20
> EUCLEAN usually spits out "Structure needs cleaning" in userspace (and
> ext4 & xfs have been using it for years to complain about corrupt data)=
,
> so why diverge here?

Because the original "structure needs cleaning" doesn't really show the
meaning we're using.

We really means, something wrong happened, thus I prefer something like
selftest failure.

And, the idea of adding -EUCLEAN, is to replace the original "unknown"
output, if you're sticking with the original error string, we still need
that branch.

>=20
> Wait... does "tree-checker" mean online metadata checking, and 'selftes=
t
> failure' is what gets spit out when it finds some metadata it doesn't
> like?

Yep.

Thanks,
Qu

>=20
> --D
>=20
>>  	}
>> =20
>>  	return errstr;
>> --=20
>> 2.21.0
>>


--8nDXvpMAsL2EgVod5cXBTOywmJs4qoybA--

--yTSSloOMLYS5AQH4jD6jlwZPIjn29aXGc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoM48ACgkQwj2R86El
/qg6Wwf+LeifDOI+vYhG58UBYMoGvQi9aXVKBmRRhBwvIP3ejZ+VwqaGmygr3msc
tYSWHmt5hTIBzYll2J8lt2kEUPRCV+BaoA0wk7TvBfBK4jW6u2EPXk33zewG4AbQ
5q2XaitaOF1PD/6rgW6O4zysHJMOdv6UWqIdeZQ9KXe+3A8OFDHFamVRYSpUs9AA
NqJkPalLZ9rB1KxiRTfTULj7wApyW8JNZvuv342DTKDqIrh23XVev0lwGb1BmTpr
5uY479smv76RfCj+IeubTWwwOnMPjSKNKDA0dVlf9694y76YZO+3TFZJp+Yes6bD
eV5IJTHVZoTn1LqUq0OFE8v0M3dEzA==
=HHIB
-----END PGP SIGNATURE-----

--yTSSloOMLYS5AQH4jD6jlwZPIjn29aXGc--
