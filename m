Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32226C4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFCCB2064A
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFCCB2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbeJKUNJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:13:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:39719 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbeJKUNJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 16:13:09 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LbdiB-1fPk9V1M5b-00l9xj; Thu, 11
 Oct 2018 14:45:59 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LbdiB-1fPk9V1M5b-00l9xj; Thu, 11
 Oct 2018 14:45:59 +0200
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com> <20181011123151.GP29418@twin.jikos.cz>
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
Message-ID: <ba395b06-ff1a-1926-5339-3a2927e3af0f@gmx.com>
Date:   Thu, 11 Oct 2018 20:45:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181011123151.GP29418@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ptS3S2hNH1VnDP48Ym9J7Ab2NAxiNNixT"
X-Provags-ID: V03:K1:khHs8DspzxSdIOj0/eps7kv1XTaohe7n4QQCPgZ9oeRPeKpidTC
 E8F1Bbq2GbzKr0MxxVyjLxQABQvmysHi6sokMGP31kDS79CowwL5V1zORqWh/nk6F9t4rDe
 AFX8/ybsHx/F2fMQfLmdgj9mDatARkGkQnDphlzo6ZV/5XtP4ITbAVfLlPyhTCHFwRnGn/K
 laNTUjd7xC2YbDH+jylEQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:+aYSMpi7lko=:dOLHjpdNeyAeGYJveJe/zo
 u7/YQJWR313I4nUaZFYZwkOE0nw4UX64/6SJoOxPgcHKYzpNgxk5DWI8Zr6ZYGUYvno9stz/6
 Fu9tqiue5estZQN/9hcADw83s6AV+mEkqbvDZOSiVI5xIAi8mG5x+IbNuxm8xvnPeetiMsHWo
 XQ9kuxyYsi0Hxslbds7kRTsKdd03Lq13OOShSsmuBpvNEv8DVJoxFwmuU6CgC3C8ASS0Fyb4d
 sQ9XxXUa9+AVBDIesqXldmPGsO8zTbpvVyAwzMy3kMG0PCEHwy1E6OJP+pMBOqGofSOFex2FN
 TxA5JWHyMYiTmu+ZDQYEjzpm5ffaeb/QVFI45qyvk2MUpWZtJyemku8LpA3jwdqGIBHgyiE3b
 cg4cbNLRm2fy0V2Z8yu/dHlDZMc5YwcXU7guSJn+wxZvR8F2C4TSr/zHqboPZQ/yledQDmseE
 k1z+T9H0TKPuMQNQ/yqdtHnjOhhcYBJU0AlukBGgW2sXATNCytBWn0nAX3z60XTg/5XbUhH1G
 hmxjIrqjtl1GsyMZtADGgse2LMtNypFQkmDXsUdJl9qZ5Qttz3mbi9TQPC6Db0rjIQjGW3qGP
 7zapH1GypAzanMTjjLlhW5bg2yZSkj6nba81RbK+LVqDylwkm5fbeoaNIzAENRI/StdNVi+7A
 dYANDoawiCHVfC/9rEygCFINSTEPHqYa0isNBR+gZ2CuiJcTk2338WwTKVSLEer4iKQpHOlRM
 81k3kSedfG1cglu0DN03q5neuuQvDeDhLVOjPNIvYZ4F+MU9216+xlvK2ZU38+7TxoHlu0pLD
 AAcjvrdgl2K0bBb4mbjC5AiyRJQdg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ptS3S2hNH1VnDP48Ym9J7Ab2NAxiNNixT
Content-Type: multipart/mixed; boundary="O9tUCGE5CdC6W9LtjIVpR1RSQzTFBp2W0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ba395b06-ff1a-1926-5339-3a2927e3af0f@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com> <20181011123151.GP29418@twin.jikos.cz>
In-Reply-To: <20181011123151.GP29418@twin.jikos.cz>

--O9tUCGE5CdC6W9LtjIVpR1RSQzTFBp2W0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/11 =E4=B8=8B=E5=8D=888:31, David Sterba wrote:
> On Thu, Oct 04, 2018 at 01:49:49PM +0800, Qu Wenruo wrote:
>> We have btrfs_super_block::log_root_transid to record the transid of l=
og
>> tree root.
>>
>> However it's never populated and it's always 0, just as the following
>> dump-super:
>>  log_root                30572544
>>  log_root_transid        0
>>  log_root_level          0
>>
>> This patch will populate it with log tree root correctly, so the resul=
t
>> will be:
>>  log_root                30572544
>>  log_root_transid        6
>>  log_root_level          0
>>
>> This won't affect current kernel behavior or btrfs check result as we
>> already expect log tree root generation always to be super block
>> genration + 1.
>>
>> But it could be later used to detect log tree corruption early.
>=20
> The backward compatibility seems to be ok in general, I found one
> scenario where the check will fail:
>=20
> * mount with unpatched kernel, log_root_transid =3D 0
> * mount with patched kernel, log_root_transid 100, generation 101
> * mount with unpatched kernel, log_root_transid 100 (unchanged), genera=
tion 201
> * mount with patched kernel -> check fails

Indeed, this is a problem I missed.

It provides the old principle, if we're going to change how kernel
use/interprete a on-disk memeber, we have to introduce a new
incompatible flag.

Please just drop the series of patch.

Thanks,
Qu
>=20
> So the problem is when log_root_transid is not 0 and changes out of syn=
c
> with the generation. The above sequence of kernels can simply happen
> when switching between old stable and current releases.
>=20


--O9tUCGE5CdC6W9LtjIVpR1RSQzTFBp2W0--

--ptS3S2hNH1VnDP48Ym9J7Ab2NAxiNNixT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu/RgAACgkQwj2R86El
/qgCTwf+NAiaVhKtKikteZpdepMA1yJjyzV/HVKgpLzqmUkh8kZlAZ5fMTiRaK4o
FZnaFuLV0tl2IXOSz3sBUymQBH0vRdjzwFafZppyHpvkgjZs3FMxVD7q86HTH80r
wG9lGfja3JR5A0+EVSRdV1JJlcyYEQoESHFqZ1siZVhpNYriQ+9hcp+AeXWLCx9d
/d4RX6eCvoqDDP9YbiRuNsTrcx+8cK0abqXyKgeX1eMOKRNU+DAUJNVZ73bW9zDJ
nsq1tiEtgmu43u0s719nwqe5Xb4G1kaNHPuZ+m6gxA6quR4x1AvuGGgWtaKFiaHg
hWoTe8U0ClkSMnceYlo/w/+CUPDqew==
=n3Ox
-----END PGP SIGNATURE-----

--ptS3S2hNH1VnDP48Ym9J7Ab2NAxiNNixT--
