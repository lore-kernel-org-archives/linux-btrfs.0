Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ED8C65C30
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 228FA20882
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 228FA20882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbeJGNc5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 09:32:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:43907 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbeJGNc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 09:32:57 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPDaC-1g4eoL0EBk-004WgU; Sun, 07
 Oct 2018 08:26:41 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPDaC-1g4eoL0EBk-004WgU; Sun, 07
 Oct 2018 08:26:41 +0200
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
To:     evan d <forumscollective@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
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
Message-ID: <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
Date:   Sun, 7 Oct 2018 14:26:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fe6ACkAzwEcIkE9bwYUSMevJB2UKZgNcA"
X-Provags-ID: V03:K1:0psW1uR0GL5VjWc0Pm8TI9cebJFgMJUGG7jMnmsIRmBW8Su/3Bd
 hJ3lhALJxftGVTzp2GRlbYKbHPto6LigAX8RuFCLxbG4ahInPk9bYgsrYLhnFV4gPnw94Ec
 Yu0u7H/1ME8RJqQDiDNXsxTlQiFpNuQ7Qs2c4Ua4A3/xK2H2eSDzeq9rncFSt9mKKVrVYMA
 iTYkWDNAQ0Qk3c1AjG3Gw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:u9UFyYKnw1A=:w4E12bjf7e0aQH5x3KaKqp
 3onfFVoNbXdump1ymXre10dBvg/BHIOCf9q7a+apnbqblbTL7QQ3qkzoR4YP/GcR8db9iAYxq
 6YIwFkXg28jBnW/Fc9HQkb4VTBLrKsIrliuf+iY2qYyLyNOcZRVPbjEkVdNoJ81p87Dz3f8Wc
 PkfYhKaoTdS+Bcaq9Ff4Zz00iMIXZ7qcSECZcM5++hnJ0X+P6AALyG/TIjq/aVVIiF0U83/W6
 09G94/Wyl2/ER5LvfwbbbdFd//LrRlSEFkVnBmfiW8sQ5gSjUedYWTB/cYttdNIkm4f+21M9z
 Rb3RueTfiQ/9mAWQclhRQWapCJUywdqALYgv0IOPoXvl32hFigU3H87AeYORAxMU+MrKZj9RI
 avxsEXDck9vQNTJY55+L1ii+j8amDWaH/xmaCvV+M6MrebkIq6D/X1h29aFeFS1/ecFHaxaB6
 nH0/bdXvBLfdPNYzObrx7FNTBjLyP/L5xbe3loCdZOkpSswTwgh8dSxYdvaBH40O2qr9yNOKR
 Vi5YUySQ+ufaEV/vcPUC2oqX7O+CVQ6oL+qWvBIyc9/xFn35V0SaoMHBvn+PpU8kmqh7KmEIE
 arIc/c3MTapjTH3YosaNGTg5KRR9rtV+bDCR463/Plz1L+U+t3soee9jD3JjlMXjkeI7maHDQ
 MoFWzFE3DFyrnePbytQWrNQGqS+bgkCUiEh/HCdWNXYwDGaiRIwuPaonW/oofarM0ItnMaJUP
 Ue7ZUb3sNB+Z2gJUQUZ85OPofeSyqGMSGyAZu/GyrkaLdpDxXhUe85pG0ikux3ScNxiNvmKnu
 yq1nRQE/1MEEeUhJwxuTW9jtoYPeA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fe6ACkAzwEcIkE9bwYUSMevJB2UKZgNcA
Content-Type: multipart/mixed; boundary="g4jlecV2RWJ0iW57u6ycE3fv2u5huZwLB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: evan d <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com>
 <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
In-Reply-To: <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>

--g4jlecV2RWJ0iW57u6ycE3fv2u5huZwLB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/7 =E4=B8=8B=E5=8D=882:10, evan d wrote:
>> Please try "btrfs ins dump-super -fFa" on these two disks.
>>
>> If it's only the primary superblock corrupted, the backup should be go=
od.
>>
>> If backup is also corrupted, either it has some offset or the whole da=
ta
>> is corrupted.
>=20
> # btrfs ins dump-super -fFa /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum_type 0 (crc32c)
> csum_size 4
> csum 0x00000000 [DON'T MATCH]
> bytenr 0
> flags 0x0
> magic ........ [DON'T MATCH]
[snip]
> superblock: bytenr=3D274877906944, device=3D/dev/sdb
> ---------------------------------------------------------
> csum_type 26294 (INVALID)
> csum_size 32
> csum 0x05401fa3a3e8cd64075ce9fdbb9e60a01d58061a3cff3bc0235d18912ab755a2=

> [UNKNOWN CSUM TYPE OR SIZE]
> bytenr 7401042280310172376
> flags 0x5a8a759265673a05
> ( WRITTEN |
>   METADUMP |
>   unknown flag: 0x5a8a759065673a04 )
> magic .~...6.. [DON'T MATCH]
[snip]

None of your super blocks has correct magic.

This means either your whole disk get corrupted, or something introduced
some offset.

Please try the following commands to dump more data around super blocks,
so we could be able to find the possible offset:

# dd if=3D/dev/sdb of=3Dpossible_sb_range.raw bs=3D1M count=3D128
# grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.

For a valid btrfs without any offset, the result should look like:
65600:_BHRfS_M
67108928:_BHRfS_M

If your result doesn't look like this but still has two similar hits,
then you could calculate the offset, and use dm-linear to remap the disk
and try to recover the fs.

Thanks,
Qu


--g4jlecV2RWJ0iW57u6ycE3fv2u5huZwLB--

--fe6ACkAzwEcIkE9bwYUSMevJB2UKZgNcA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu5px0ACgkQwj2R86El
/qh9nwgAlwCQb/s+xlmihPIgOW+5An242JIPWLWIlRLX0hW/X7mMooXardoSe4sX
Ai3NTyGyTOp+Su1ypKt9Q7gtQAgE2gyTDHVCLFlvmoBSnC6o7XhZ1Q+XCezxZkbB
WnU+x8hMEeCV/UBeei+Ji9XoulwrbnxfczhGwFZjyoIe5/VCWjzUuFrJkyRYbic1
IQxnZby3v1hzFe4GL0xcXNrlZZGnQ/rOvNK2ppsqhPgmI9AZYMk6l6XiObIcpYbM
QV2BYr6hKrcXj1JTR4XgawyKh8vx5Ij2Gb7DRRQ4nDAmKtZAgT+NunaXkRjBrWBc
n3gzpXjvwjFNUxn+AuJQ3Ysaxbp7Bg==
=Ljr7
-----END PGP SIGNATURE-----

--fe6ACkAzwEcIkE9bwYUSMevJB2UKZgNcA--
