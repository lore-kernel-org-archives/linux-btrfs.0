Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD04C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C7820839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91C7820839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbeLLNxw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:53:52 -0500
Received: from mout.gmx.net ([212.227.17.20]:47147 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbeLLNxw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:53:52 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MK3bN-1gXuQy21Kv-001NiY; Wed, 12
 Dec 2018 14:53:43 +0100
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212003953.5643-1-wqu@suse.com>
 <20181212123739.GR23615@twin.jikos.cz>
 <fde0326c-0590-eb4e-4f61-250b7e202c05@gmx.com>
 <20181212135001.GW23615@twin.jikos.cz>
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
Message-ID: <5c28c209-26c2-0235-1b30-f264dd6bebcd@gmx.com>
Date:   Wed, 12 Dec 2018 21:53:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181212135001.GW23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WPJFbwCGwK9ZfI0EXAe0FVoC5xYY9fZTD"
X-Provags-ID: V03:K1:XwDGmVPGQfmm667m/sRym96erdAsTszM2/5+l/knqyl71TahZYn
 pmz8KQApYYUwQhKGYUe8PcjMvFapXWWkvYw6KY+twMCYpc7+q7OFtIUN9NLrPhOkE90wlGI
 kJSj9CZD2BaKmCI+uFKtoUvb2B6alUpT0vyM4l+of8QZsBYHHtr64NqTV5CllLTK0RovJyN
 D9c5S0H8aOx1rVmhuSyrg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:B7+5DK/fk/U=:t3n1DVnygR4YHvyHisL9TK
 k0zdB/+RpFNz1wujVWppzPDbwWlilHml+AmU8wlBf3ABKCj4T+wie6ycmpCTNmkp3qF6vCE8e
 bffet3MZI4MTIMEPS6E6TX2UmI9KRucxxp1mS+dP3hVV2yTVYn6ItQYZqJXthCiBMW7LY+oNl
 D2NNZ6NL5wSJUDIayTPOLtPYbUDfpevxeZJqTeQNF2iUtXL28KxNg1zINStUoR9VKYQ8o8J9r
 nlaJODBR9gVbprZElu+/IXTnl0SEsXzmQzHCF5FGxfaKGm0kLnyoVxliW1Fm0oyQ1vAWJ7GP/
 Cxa1lglIKMViyV2F3wwJtblBFU00x/iQVBpjQQvOZ7cQoIjZts1pepMWsb3ZOdc2LpovuUHc1
 EOAeh2Z5VFGgCcp9CLIRzJvY47g9T0kio+NcUt6f07bJMFA6HgactCzNl8hqyTyHUDiSspTwE
 e1yJWejeZZj6HNtqAfoTBZCMHcoQH3Pn3vFwKl5p8VwGogoWOamyz3elE9bfKcIMPI+jijxD2
 Opo25UdpCGuLM0X4MumadMszEtcBhTfDo1gGOG01ELy3mzVccICkXfbsd7uJhPXvvomthpE2n
 wlurqBmtwzpB3yZXZMMOF0V7IB+P4dj7C3R6d8kKj0guC42Y14CNWNJLsIpiXGe+nZqoX89n4
 6GYm6bv+cYDOeB/mflhJkeAKDrjGM2XQ39GR5nQ+u1SpBoVQ+gc1+aBDOtXTh+LQ8Yn6O9315
 eFcWybFlOkwOMev7jHhWI5XqD+8Xb+qrdsk0grk3K1WukCJ5JC6szHT83Tvp5pVm7z68OccG4
 cKNJzCAaiheV5mihtDPVW7iLmso2HOX045vifzaJu4iYiRSXrQp+oE1yuEL4smRk3H9qADpDe
 UczQVtjR2NVK9unkoany3oKgj/7FYNJgqMDnjZflwTOnil9zLHMSuFqnNL/UcK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WPJFbwCGwK9ZfI0EXAe0FVoC5xYY9fZTD
Content-Type: multipart/mixed; boundary="AsWlgxWWEXpgCOdPPHim6wK1pVz3CjniS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5c28c209-26c2-0235-1b30-f264dd6bebcd@gmx.com>
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181212003953.5643-1-wqu@suse.com>
 <20181212123739.GR23615@twin.jikos.cz>
 <fde0326c-0590-eb4e-4f61-250b7e202c05@gmx.com>
 <20181212135001.GW23615@twin.jikos.cz>
In-Reply-To: <20181212135001.GW23615@twin.jikos.cz>

--AsWlgxWWEXpgCOdPPHim6wK1pVz3CjniS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/12 =E4=B8=8B=E5=8D=889:50, David Sterba wrote:
> On Wed, Dec 12, 2018 at 09:20:33PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/12/12 =E4=B8=8B=E5=8D=888:37, David Sterba wrote:
>>> On Wed, Dec 12, 2018 at 08:39:46AM +0800, Qu Wenruo wrote:
>>>> changelog:
>>>> v2:
>>>> - Rebase to v4.20-rc1.
>>>> - Instead commit transaction after each reloc tree merge, delay it u=
ntil
>>>>   merge_reloc_roots() finishes.
>>>> - This provides a more natural behavior, and reduce the unnecessary
>>>>   transaction commits.
>>>> v3:
>>>> - Fix backref walk deadlock by not triggering it at all.
>>>>   This also removes the need for @exec_post refactor and replace the=

>>>>   patch to allow @old_root unpopulated.
>>>> - Include the patch that fixes the unexpected data rsv free.
>>>
>>> I've tested the deadlock fix but it still locks up and there are some=

>>> lockdep warnings. I can't spend more time on that given the pre-merge=

>>> window timing so I'm going to postpone all qgruop things until the ne=
xt
>>> cycle.
>>
>> No problem.
>>
>> But would you please provide the reproducer?
>> My test script can't reproduce lockup this time.
>=20
> git://github.com/kdave/testunion
>=20
> in the directory test-subvol-qg, it needs a 15GB tarred dump of
> wikipedia, the url is in the repo. You can possibly replace it with
> something else, the scripts need tmux and maybe some other utilites. Ru=
n
> with startme script and path to fresh filesystem.
>

Just in case, the github branch name changed.
It's now "qgroup_delayed_subtree", no "_rebased" suffix.

If still lock up, then it's going to be tricky.

Thanks,
Qu


--AsWlgxWWEXpgCOdPPHim6wK1pVz3CjniS--

--WPJFbwCGwK9ZfI0EXAe0FVoC5xYY9fZTD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwREt8ACgkQwj2R86El
/qhegwf+MsIkGnWxYyGiuXKWxL6LDvpHUfflwPsPOuV4t1CCClgRQz6Ewae4+2j/
zuXTPRCLZEsMqrpcjbUfYxt6NFKaMSDcM18gggdz9MqYbN+pDF4ktbIKlLyAsjm5
9s1C6Fc6W4mEMwBEOQOt04ezxcb7gJkqUuChqlD3ZXb4N7obKFx657k7H0jKUflL
OGosknzo8lodjZCAmL5kWaiOpSAlf9ApIVS1Gt/JKo7ERcViLAvOYYjbupXMDvkR
UAVpl3RIO5yVDwZl/KYA6ft1AbSOtxfCg+y978qneVPGEwiZsN4upgOrd4NJhi1P
mMcdq9oqd1BkGihod9CgAtqhkK6XSQ==
=0VBD
-----END PGP SIGNATURE-----

--WPJFbwCGwK9ZfI0EXAe0FVoC5xYY9fZTD--
