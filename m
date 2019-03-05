Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D56C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 12:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF1D2084F
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 12:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfCEMfz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 07:35:55 -0500
Received: from mout.gmx.net ([212.227.17.22]:58689 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbfCEMfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 07:35:55 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LbR3e-1hOtWS0nKE-00kuOD; Tue, 05
 Mar 2019 13:35:47 +0100
Subject: Re: [PATCH v2] btrfs-progs: gitignore: Ignore hidden files
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190228022206.16356-1-wqu@suse.com>
 <20190305122709.GV31119@twin.jikos.cz>
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
Message-ID: <b8d87129-e7a0-7375-1bc8-32e4076ed193@gmx.com>
Date:   Tue, 5 Mar 2019 20:35:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190305122709.GV31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W87oryqoLhHTXe7M45EpmJGhU1gz47i7g"
X-Provags-ID: V03:K1:nptGYr2NY+1rcZFKgVvPEl/CR8/aDzKRNqg6dZIk7Z7A6gsdWOL
 mZqqQWbnYSUsUpvkOyJYuEkQNgp70KbaoUk2DY96LHdIE/uFTcGLAwKXFantSjgAKhK+hNd
 MrzZpOyHRHx7ZYJq0g4d1CiulZdih2qnu0Ay0m3IT8gGStIVuBtCM1nzZB/PV80HWvGqDYV
 r12Wabv05xQXb3YzVuaLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:puIW6oJDYl8=:qgDwx0RDWuRuZLDMz9ELNE
 CRs0w06uNTyS9ULWz4MHWEkULk6ZKsXCrUOVt+hFxOmdvFn6r1y/uCjkvjY0WVgzEtlnLttdP
 1qZLiUfFeGx0O6tuHp+9IhkFveaNaIng06I1YgANmVJQ9T9kJfHSaZM8OZRYdCnAhBE4/r/H4
 NpYUAR3+HMdicOR8qDwaPYz4mAMlcyV00imaY/+ewIoSxfQCDjIPkhln3/DXrt41W/vc8rjPR
 v1ejOcrRhMWWHVFJr2lMq9ApIxxR15oTgdTGUkxhnjacJnxaErbZiW+klWMo/Fuk/z08Pi+yP
 AmFDM0yzs/YbmRwViyJLTf/IA6NHJFrLQdhebxPCn4jk4KPWEOT3n34PmE3ixOYbx8eeow8qa
 u3fDxOqcCzBkk5UGPN80yl01ssdNTMStVCy4Ip9B0L5QU6ziu2FWrQ4J5Ep7mzQu+FHzpTXNE
 ceci9S9Ir9Jwf9QAHKRAhcdTHIdDA/RrOXlk6090/ck5AMPPtQzWWvTXFbitjDMruNAh9NdtX
 wS82ebevVZBGnyyF8EY2tW9G2pE1Cmgi6npGG2SkIql0u4wX63G0UML9UwCWNU7hZzZcxv5mC
 Jdr/mJg61FsXtr6z+CtvqGh/NV4OntWp2/Rxj5Rnpaw7aJmZzwLEEYMxLOiOwsYlSL7iWPz/k
 Iu9UpSd4GGtjB5uIjgYGHLx4EIkpMHEJf97h7leltR7PqNQMlUG73n8OsTbBX2gJTzrF3atML
 kfHbcvCAT+ZYgakLMJY0C+DXaOHreSJSgMqopfJceuyoQ6YVOMeUEFH7oVpmh56tMKEAfvuTT
 LIZ8pAnZp5hzL4DYY/DJB2q2K4JklTzGtWnZWa9L/q+jW3xib52GiyzrD1IDhSGNdCuW0GW4q
 xvsYVmiXN5XZIVs1RBasl7igm63pb0SGNvUnys5PVnqL2v0uLFF84BEto0GcV2
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W87oryqoLhHTXe7M45EpmJGhU1gz47i7g
Content-Type: multipart/mixed; boundary="0i3OEGkQfqXLfEC4P8ed6OR2M7D0Bu7Tr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b8d87129-e7a0-7375-1bc8-32e4076ed193@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: gitignore: Ignore hidden files
References: <20190228022206.16356-1-wqu@suse.com>
 <20190305122709.GV31119@twin.jikos.cz>
In-Reply-To: <20190305122709.GV31119@twin.jikos.cz>

--0i3OEGkQfqXLfEC4P8ed6OR2M7D0Bu7Tr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/5 =E4=B8=8B=E5=8D=888:27, David Sterba wrote:
> On Thu, Feb 28, 2019 at 10:22:06AM +0800, Qu Wenruo wrote:
>> A lot of editor/IDE related config files are dotfiles, like .vimrc
>> or .clang_complete.
>>
>> Instead of adding gitignore entry for each editor/IDE, just ignore all=

>> dotfiles.
>=20
> Fortunatelly it still works for tracked dotfiles like .travis.yml and
> .gitignore itself.

Didn't notice .travis.yml, but indeed i should notice .gitignore.

Any idea what's the correct way to handle them?
Just current .* or adding each possible dotfile?

Thanks,
Qu


--0i3OEGkQfqXLfEC4P8ed6OR2M7D0Bu7Tr--

--W87oryqoLhHTXe7M45EpmJGhU1gz47i7g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx+bRsACgkQwj2R86El
/qhc/AgAoZd7cm7dYUoPK3SaZhFOBuFuQqs1IS8tFhVDrjvnIgfn0qTwYUSVDqAr
m2LYd7MK1T8galrcYOFFcpDopsvSmJe9Ubqry5YLlJQOITT9bgOXfJX0uuO2dXHP
0A5c+PLiFcDGI5V502LC2Pg2ACjWpcVaf+ID+wi92Rv/aZNm7dQaUtP/bV98cuJF
j9Z69fnxf4QV4LN2ryYPY+LzRMxS4YzYaWxLQNcEBKqlcJKR9GbZuiZYOHfi7rtO
95tLoiCsVfaOtTcRDmBGvbrqw075zyUCKL00AbN2zwjhHMeq/q3nmf3Eplu9J5k+
gPI+aSohBUQiqjy5pKdbMzk3OVgkSQ==
=T62T
-----END PGP SIGNATURE-----

--W87oryqoLhHTXe7M45EpmJGhU1gz47i7g--
