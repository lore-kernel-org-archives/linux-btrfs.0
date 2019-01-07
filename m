Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DDEC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 06:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E54C2085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 06:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfAGGxV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 01:53:21 -0500
Received: from mout.gmx.net ([212.227.17.20]:41323 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfAGGxU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 01:53:20 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lp3Qu-1hC8d109IK-00erYZ; Mon, 07
 Jan 2019 07:53:12 +0100
Subject: Re: [PATCH 0/4] btrfs-progs: check: Add repair support for mismatch
 dir item hash
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20181025074449.32469-1-wqu@suse.com>
 <40066cc8-e631-2ceb-6dc3-01795778a2fd@gmx.com>
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
Message-ID: <74d1406c-57f9-84d3-ef65-595ddfc72d88@gmx.com>
Date:   Mon, 7 Jan 2019 14:53:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <40066cc8-e631-2ceb-6dc3-01795778a2fd@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Pp5vOSnFThGZpYAAllu0V5Z2BjnC20NWP"
X-Provags-ID: V03:K1:e6QAyUbwKl5TdkiRLHWF6X/niaFEIruSFS6KfEE3ykuyXZ4h5wj
 Ent2guiNKquogf6Xu8tPuYxJkCAV4wVSk/u/jWG7sadU1YYWozRr4wUYOCwmeam3l2GCfyz
 y625uJk9B0Rc1q67Ji/qCuV1ZU3aktzq7vAo0iLXVgiecCQuB6FIOT0cBYP2jFfU+nTHqwj
 v1ZmwvqhYxfGUN9Euo6zA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xIwv9Xg07fI=:sCfZ3udzIqj37dXEOri72N
 dQpWh4mQkacA4WzYWMW84Lyb1FLVSy4xJ6M8VBFOwwzPdbxlT2zP/pwj8gm9LQSLQ/0xP5SpR
 XAESEypHM1SwSgA/yGl2SZnRjJj2KLhWrxkAZuEeKX2vjvSG4ksSW1DKhF3aLmuz4dyvG1ldf
 jreQidE549XG4WWRNHB1sacfwgd/Ax5I6/MbguETO8rgNEN/IGwcWA40txyaRHBPQpL43d0Q9
 F8f5906CRonCRdfvu2oG7TaZE0jStKjqX+BgFiYGjZEAa0KEyC++0+X8nYwyhThJmqosbfzwO
 QgDnNfqAngR7xdRyyicQ1+PqV1v5H8AwRr4VLE4ANHj7TA8nlEnG+SNWY+wZbqCLV9ggBxz1x
 iRXpxWu8+/LRayWYcry5HYoHNWTjBnopf/PsAH6gvJlRt9/YF4RRoi4G5vh841yJgtLoiOgb6
 vG9TbMMycaSm5W9DYxgRe3omsgJDzcHonX8oo12A4ay/uFx87kGbyRqR86ThlkeQMW1J5YLDn
 h+W+uEXp92089mtFrohUL1oW9adGlB3T9LfQ3XMOS81J208okSp7HyMm56UvifP5n831TzLSZ
 sHXPWASd+v0Viacst8F01UUC3bmrXAikjfMqeHqK2HmxXQOpE691k+CHpC1aCm5i17+Xv+Sy3
 iQ1r6pedldxRETnzE4vjUUB6/twKakI0V7j6DHQbHWEK1xqMbwSznsXBS6rQobMml9mQWMpcC
 Mg0YNO9HzBrl9BQiekqX5b2+pAcgVgGer8aZl/8USuSs49xUoYmjsZYwjb+J3TbnHBuXf7rE/
 2qmxMky50GtW39e2ODKG05eoYpaDiT1jOjVkrpj4smjtQuN8n7C8j4h7MWi5GAzexzxvtfMao
 bPzfrNR+v9A55TCmLosiuxwhNLjjKKTdwwdEZwQEyvbktm8qD7On+OdCSROjGQ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pp5vOSnFThGZpYAAllu0V5Z2BjnC20NWP
Content-Type: multipart/mixed; boundary="CEbZYoGKcav2TXbaJbF1vvH9N7lZ3vk2S";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.cz>
Message-ID: <74d1406c-57f9-84d3-ef65-595ddfc72d88@gmx.com>
Subject: Re: [PATCH 0/4] btrfs-progs: check: Add repair support for mismatch
 dir item hash
References: <20181025074449.32469-1-wqu@suse.com>
 <40066cc8-e631-2ceb-6dc3-01795778a2fd@gmx.com>
In-Reply-To: <40066cc8-e631-2ceb-6dc3-01795778a2fd@gmx.com>

--CEbZYoGKcav2TXbaJbF1vvH9N7lZ3vk2S
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/7 =E4=B8=8B=E5=8D=882:51, Qu Wenruo wrote:
> Hi David,
>=20
> Would you please consider merging this patchset?

My fault, already in devel branch.

Thanks,
Qu

>=20
> There are at least 2 user reporting latest kernel tree checker refuse t=
o
> mount their fs, and this patch is needed to allow btrfs-progs to fix th=
e fs.
>=20
> Thanks,
> Qu
>=20
> On 2018/10/25 =E4=B8=8B=E5=8D=883:44, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/btrfs-progs/tree/repair_bad_dir_item_has=
h
>>
>> This is still based on the latest stable v4.17.1 branch (which is alre=
ady a
>> little old now)
>>
>> We have report from suse bugzilla where user report latest kernel refu=
se
>> to mount the fs.
>>
>> The problem turns out to be that some old kernel (around Jan 2017) has=
 a
>> bug that could leads to corrupted dir item with mismatch hash.
>>
>> This patchset will allow btrfs check --repair to repair such problem.
>>
>> Qu Wenruo (4):
>>   btrfs-progs: lowmem check: Add ability to repair dir item with
>>     mismatch hash
>>   btrfs-progs: original check: Use mismatch_dir_hash_record to record
>>     bad dir items
>>   btrfs-progs: original check: Add ability to repair dir item with
>>     invalid hash
>>   btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to
>>     verify if btrfs-check can also repair it
>>
>>  check/main.c                                  | 121 +++++++++++++++++=
-
>>  check/mode-common.c                           |  51 ++++++++
>>  check/mode-common.h                           |   5 +-
>>  check/mode-lowmem.c                           |  46 ++++++-
>>  check/mode-lowmem.h                           |   1 +
>>  check/mode-original.h                         |  14 ++
>>  ctree.h                                       |   3 +
>>  dir-item.c                                    |   6 +-
>>  .../026-bad-dir-item-name/description.txt     |  41 ++++++
>>  .../fsck-tests/026-bad-dir-item-name/test.sh  |  13 --
>>  10 files changed, 272 insertions(+), 29 deletions(-)
>>  create mode 100644 tests/fsck-tests/026-bad-dir-item-name/description=
=2Etxt
>>  delete mode 100755 tests/fsck-tests/026-bad-dir-item-name/test.sh
>>
>=20


--CEbZYoGKcav2TXbaJbF1vvH9N7lZ3vk2S--

--Pp5vOSnFThGZpYAAllu0V5Z2BjnC20NWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwy908ACgkQwj2R86El
/qia3Af/ayL39rWQ7gEYLMKdyCRGXGfEXrjQNRF1lQoCkHsiJ+Cy1isHvt3pmxZ7
z4EmFYfxdIaIWXHGgTp41aeTwTciA9RV39VKIcKBFCFxQE829CSALcyhsQA6/Tl3
1Ccghs6QfPFh1pXh0qFcYya20Ah9pSW/2Mpz5FQtoyhJ9+GJajc2Fcibn5i4CiTj
zbHqAwlhpgbKVei5o14YbPlPP+x7rerGAnTSF/yHiqccsvTXj6cdLx4vxyrvmcPQ
l+xLeSVPWm8+LOZC9EgNjiy3NnDdmBa75XrUXWEc51EXeHmcTiJ9MUkjKLa6OOZj
TGtEyZnndgmP2DpSNiXdTipfMbXVPw==
=KQp6
-----END PGP SIGNATURE-----

--Pp5vOSnFThGZpYAAllu0V5Z2BjnC20NWP--
