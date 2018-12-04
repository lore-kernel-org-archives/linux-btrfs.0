Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC07C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2592082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:22:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF2592082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbeLDKWf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:22:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:37856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbeLDKWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 05:22:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95F70AE8A
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 10:22:31 +0000 (UTC)
Subject: Re: [PATCH v2 1/5] btrfs-progs: image: Refactor fixup_devices() to
 fixup_chunks_and_devices()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-2-wqu@suse.com> <20181204102005.GF17773@twin.jikos.cz>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
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
Message-ID: <c64ba9b7-0350-3cb4-3aab-e2dae4415043@suse.de>
Date:   Tue, 4 Dec 2018 18:22:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181204102005.GF17773@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XSQ5Qbd1klFfSFKGpj8EsAGHkjp4Wqbx8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XSQ5Qbd1klFfSFKGpj8EsAGHkjp4Wqbx8
Content-Type: multipart/mixed; boundary="KtA7q5rZlBdcWI1o2mwIGJEczkUWp6Xfo";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c64ba9b7-0350-3cb4-3aab-e2dae4415043@suse.de>
Subject: Re: [PATCH v2 1/5] btrfs-progs: image: Refactor fixup_devices() to
 fixup_chunks_and_devices()
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-2-wqu@suse.com> <20181204102005.GF17773@twin.jikos.cz>
In-Reply-To: <20181204102005.GF17773@twin.jikos.cz>

--KtA7q5rZlBdcWI1o2mwIGJEczkUWp6Xfo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/4 =E4=B8=8B=E5=8D=886:20, David Sterba wrote:
> On Tue, Nov 27, 2018 at 04:38:24PM +0800, Qu Wenruo wrote:
>> +error:
>> +	error(
>> +"failed to fix chunks and devices mapping, the fs may not be mountabl=
e: %s",
>> +		strerror(-ret));
>=20
> Recently the sterror(error code) have been converted to %m, so I change=
d
> this to
>=20
> 	errno =3D -ret
> 	error("... %m");
>=20

Thanks for mentioning this.

I'll use this format for later patches.

Thanks,
Qu


--KtA7q5rZlBdcWI1o2mwIGJEczkUWp6Xfo--

--XSQ5Qbd1klFfSFKGpj8EsAGHkjp4Wqbx8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwGVWQACgkQwj2R86El
/qiAVggAsg2XaAmXVlNDywCockoojt4Yvd8cQmO2+1yuAPP2wQzwXqgxQktKUhOZ
TfAR06OMeu49REZ7WFHNoLxei3SXkckt46YMHp2Ke8zfKPvOIiKyFvr4NstMHLg1
y21glmOpMYY3dCB1cDV1lAuWjtrNEY9i4GJ1ThVL2kVid3fLIFDg3rGxllGKndms
mUIdMb++ejHquwU56J6jKfWdPJcKXgXNe9cQ/JPfIapqZex4C5AsQonh9HHRyiHf
Gor8OvR101CaT0+cWntBv7/TB1jqL+ynV3b7dXwcQzTaQ+gNa8XyVadyXvQNnH42
6atM1SKBl4ChdArcjIN2fHsXLn6w0Q==
=bShl
-----END PGP SIGNATURE-----

--XSQ5Qbd1klFfSFKGpj8EsAGHkjp4Wqbx8--
