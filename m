Return-Path: <SRS0=p5gK=R3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DF7C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 11:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DAFE222C9
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 11:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hAG7vI1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfCXLYO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Mar 2019 07:24:14 -0400
Received: from mout.gmx.net ([212.227.15.18]:45661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfCXLYO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Mar 2019 07:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553426651;
        bh=wPjmPh6xImJTFC1m1ubR98Av1CTzPtrcawHa3HFtUQY=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=hAG7vI1dX6fg1E51mnDowKKHufQZbk8QEGwDT2MurPy7aeuVE/4KIXDDreFTtOajm
         tI/ipYm/Gs0vRudkqj5FI6LMtLYIzFoV6kWQ4dNF3bWRVaYbukyRZBQnf0+4/xlzgW
         yXyfk4e/9S3sCQkPQtBJczMXgOn2eYudiT3u55Bk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M3RVA-1gqUJe0pf6-00r1HM; Sun, 24
 Mar 2019 12:24:11 +0100
Subject: Re: Fwd: Fw: kernel oops when mounting btrfs
To:     Thorsten Hirsch <t.hirsch@web.de>, linux-btrfs@vger.kernel.org
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
 <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
 <CAH+WbHyQTxbz5inf31AgmAG1BvVWyTAExn3Nf_qvvEQWzZ0tHA@mail.gmail.com>
 <4dc0ed1a-3f90-56a2-b526-c26cb78d7932@gmx.com>
 <CAH+WbHw1cm96YNjVhmdFP4qZ_HR3mzfmojna=d-MeydCtunG1g@mail.gmail.com>
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
Message-ID: <51fe1fbc-2687-b108-047a-7db5217bef99@gmx.com>
Date:   Sun, 24 Mar 2019 19:24:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAH+WbHw1cm96YNjVhmdFP4qZ_HR3mzfmojna=d-MeydCtunG1g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qo0ZXFbBZ3z4IfBid0wxcentddpZPPfw7"
X-Provags-ID: V03:K1:nxwsWvJhR+hkbcaCrmzom9+v+zZgRjhrB7jr76MkIipBy2yV1NO
 u+tSHAMe3q1Pg9lsTtcPbis8IXyoL4DwY4wQL9i5Knm4EnTZItC1lSM7aWjjUSPuKIPgTBQ
 nFh7Uz0fEY2PfISnj9bzTfW42c/1rVTtttkmRKcHlovrp66Abg7SLCzY8Mu2bWF1HUerMFf
 XGqWEk7WfNDwd38iKeGzQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zoyGZoY9pwU=:Xw1zb+scMYG9qEnas4yZy9
 0iV5CNBVXw5m+tWf1WdLWCmBnDYr2R2Z1AE7PxZpyzDlX5Nvwn5IX9bwZuDFIpD+aLMjE9FWg
 6ijpFqboMbBLboZ4y6S/brr0M1cHvzXle+lWWCvWJxNLqjr+UKmw+J3D26vQ3oJMltABjBNMc
 6/wWyWice/9L/kzYBN7JuRtrm+S89zbgNqw9C8QcbH4PIbB/NkPWz4nUYF6NgULQlHhJP4qoJ
 jgzLcYIqvkfjT2/kMEQx0hVAKv6U8KKplJ7TMwqxCxp5qlnxbPNv05bLEEGIzahRs9w+hsyLT
 TCQWx0+xGKVGtiv4eH8xXMxOXYWakv8PtCtOpNFua0l9Mk8tmf7devNfug24tExmBwFhfx7Br
 L3GGKPcSKwbK8qWdPve0TwvP1UC1MWJ4eZeI8KXfoX4MX+wQxfVaXYmY4awtVSs0TyJHEicu/
 c8h63MYV+B8jFC47wS4vJgr2b3f9x8MYI6bPFD9CUveFOnkS2qETddD7hs2nH8RtnUdxIkJUE
 edWmdrjBWaoYDP8VDqF7sPzOWuPlAy8wVDb4FQvexpuxU7wp+kROiDB4tin4CKAhWON/LaeO3
 5r3mjxPvx/V+NdfYxdRLbMC56GcaMepTP1lQq7TSdXjpvZckVfZwPBNgv61mGNdSRMsrfjBfG
 gKHYaaXztz7AXRViOl1WaG99IenicgrqPZuBj1eQP0D/SkyD2RoY/O4HIFGvXQEv0hE7nKw7H
 q/Sbpig1SZJdug0ORR0jDsJdiszYmK56CwkauEuCsDO+pExEchzAMo3Too9HJGFdg3S+Cv37d
 XyZPkLwXuJjHboB1PPj5mr0Nn8XCemigl68vV5GazJaRCuq019lAjiW8ALCno2+++lKeUTV1p
 lzIO3pAt2UqWS6atKGy2P+PXjOZX/a2fNxZ3ZUETWflQKHmiT9adiCzWOwc703
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qo0ZXFbBZ3z4IfBid0wxcentddpZPPfw7
Content-Type: multipart/mixed; boundary="BElRS0HjHgPCiYee25UXlCIiQvd9GNFVb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Thorsten Hirsch <t.hirsch@web.de>, linux-btrfs@vger.kernel.org
Message-ID: <51fe1fbc-2687-b108-047a-7db5217bef99@gmx.com>
Subject: Re: Fwd: Fw: kernel oops when mounting btrfs
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
 <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
 <CAH+WbHyQTxbz5inf31AgmAG1BvVWyTAExn3Nf_qvvEQWzZ0tHA@mail.gmail.com>
 <4dc0ed1a-3f90-56a2-b526-c26cb78d7932@gmx.com>
 <CAH+WbHw1cm96YNjVhmdFP4qZ_HR3mzfmojna=d-MeydCtunG1g@mail.gmail.com>
In-Reply-To: <CAH+WbHw1cm96YNjVhmdFP4qZ_HR3mzfmojna=d-MeydCtunG1g@mail.gmail.com>

--BElRS0HjHgPCiYee25UXlCIiQvd9GNFVb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/24 =E4=B8=8B=E5=8D=886:49, Thorsten Hirsch wrote:
> Hi Qu,
>=20
> thank you once again for your advice. I could indeed recover all my
> data, even the snapshots docker had created. Everything's working as
> if nothing had ever happened. Here's what I've did in the end:
>=20
> btrfs recover <src> <dest> worked flawless, but only recovered some dat=
a.
> mount -o ro,notreelog,nologreplay was the only way to mount the broken
> partition and it showed me a lot more data than btrfs recover could
> recover. However when trying to access these additional files I had
> input/output errors.

This means some csum tree got corrupted.

I have seen several reports about csum and extent tree corruption, so
it's quite possible.

>=20
> btrfs recover -sxmS <src> <dest> was the magic command that recovered
> all my data (which I could "cp -a" back to my device after creating a
> new btrfs file system). After reading the help of btrfs-recover it's
> obvious that the arguments are required, but in the btrfs wiki it says
> "If you're really lucky, this might be enough"[1] describing the
> command w/o arguments. I think this is misleading. The arguments are
> always necessary if you want to recover all your data. Well, at least
> I think the wiki page makes mores sense if the arguments were
> included.

After looking into the man page, I strongly believe that file
owner/mode/symlink related things should be the default value.

At least we should enhance either the manpage or btrfs-restore.

Thanks,
Qu

>=20
> If there's anything I can provide to help you improve btrfs or its
> recovery tools please don't hesitate to ask. Although I don't have an
> image of the broken partition, at least I still have the core dump of
> "btrfs check --clear-space-cache v1".
>=20
> [1] https://btrfs.wiki.kernel.org/index.php/Restore
>=20
> Thorsten Hirsch
>=20
> P.S.: btrfs check --repair was of no use. It crashed almost
> immediately. I tried it only after recovering all my data, to see if
> it would've helped as well.
>=20
> Am Sa., 23. M=C3=A4rz 2019 um 14:57 Uhr schrieb Qu Wenruo <quwenruo.btr=
fs@gmx.com>:
>>
>>
>>
>> On 2019/3/23 =E4=B8=8B=E5=8D=886:48, Thorsten Hirsch wrote:
>>> Hi Qu,
>>>
>>> sorry for this direct reply. I've been trying to answer to the mailin=
g
>>> list since yesterday, but my mails seem to get dropped. So please see=

>>> my answer to your mail enclosed.
>>>
>>> Thorsten
>>>
>>>
>>> ---------- Forwarded message ---------
>>> From: Thorsten Hirsch <t.hirsch@web.de>
>>> Date: Sa., 23. M=C3=A4rz 2019 um 09:29 Uhr
>>> Subject: Re: Fw: kernel oops when mounting btrfs
>>> To: <linux-btrfs@vger.kernel.org>
>>>
>>>
>>> Hi Qu,
>>>
>>> thank you, but unfortunately that didn't work out so well. The tree
>>> dump was no problem [1], but clearing the space cache resulted in a
>>> core dump. Now btrfs check --readonly reports some errors. I attached=

>>> the output of these commands.
>>>
>>> Thorsten
>>>
>>> [1] https://gist.github.com/thorstenhirsch/65d4308ce54729c902cb09c0d4=
ad2baf
>>
>> This explains why a lot of things doesn't go correct.
>>
>> The inode item of your free space cache tree is wrong.
>> According to my experimental with latest kernel, it looks like some
>> older kernel is the culprit.
>>
>> Your free space cache inode lacks the correct mode.
>> Normally the mode should be 0100600. But your fs only has 0, and kerne=
l
>> panics for that reason.
>>
>>>
>>> # btrfs check --clear-space-cache v1 /dev/nvme0n1p3
>>> Opening filesystem to check...
>>> Checking filesystem on /dev/nvme0n1p3
>>> UUID: 4284a794-ad75-450d-b023-ebc5e75f31f5
>>> Failed to find [544448348160, 168, 16384]
>>
>> Then this means something bad happened in extent tree.
>>
>>> btrfs unable to find ref byte nr 544448364544 parent 0 root 2  owner =
0 offset 0
>>> transaction.c:195: btrfs_commit_transaction: BUG_ON `ret` triggered, =
value -5
>>> btrfs(+0x3be68)[0x556936269e68]
>>> btrfs(btrfs_commit_transaction+0x12a)[0x55693626a2ec]
>>> btrfs(btrfs_clear_free_space_cache+0x32a)[0x55693625fecf]
>>> btrfs(+0x4be5b)[0x556936279e5b]
>>> btrfs(cmd_check+0x5c2)[0x556936284d86]
>>> btrfs(main+0x1f6)[0x556936241ef6]
>>> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xeb)[0x7fb9a7911b6=
b]
>>> btrfs(_start+0x2a)[0x556936241f3a]
>>> Aborted (core dumped)
>>>
>>>
>>> # btrfs check --readonly /dev/nvme0n1p3
>>> Opening filesystem to check...
>>> parent transid verify failed on 419860414464 wanted 30188 found 30105=

>>> parent transid verify failed on 419860414464 wanted 30188 found 30105=

>>
>> So extent tree get corrupted in that repair attempt, which looks prett=
y
>> strange, as aborted transaction shouldn't cause any impact on the
>> existing fs.
>>
>> I'm afraid you can only try btrfs check --repair.
>>
>> If no good result, then I'm afraid you have to go to salvage the data,=

>> which I believe over 99% of your data should be safe.
>>
>> To salvage the data, either use btrfs-restore, or you my experimental
>> 'skip_bg' kernel patches:
>> https://github.com/adam900710/linux/tree/rescue_options
>>
>> The 'skip_bg' kernel patches introduce a new mount option,
>> 'ro,rescue=3Dskip_bg', which can skip the whole (corrupted) extent tre=
e,
>> and since you have all trees consistent but extent tree, you have all
>> the readonly btrfs features, like subvolume list, csum check.
>>
>> Thanks,
>> Qu
>>


--BElRS0HjHgPCiYee25UXlCIiQvd9GNFVb--

--qo0ZXFbBZ3z4IfBid0wxcentddpZPPfw7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyXaNQACgkQwj2R86El
/qg+8wf/el6KnzOyYHNRcoW4DHC/BGIs90jsY1vSxmZWQU0jN40O38oACEofKPiD
fxCDzuO0lQGDzF85u2LjCrNUIoI+i+Q5hcmyohBrgu1/hhEoLbyknnZxoXRVo4Vv
9Ez07zVGEejLrWPFoirdQOb3wjE+eX8z2e+SUd2vmtMjt2c5/9NTrNkzQPbWHWpn
mJ5ycdyB985Jr9shlrp5PzjbzWizSq7S4PsruH84u65081YcU31eioPn3SphSsl1
1VHexWy1W9qlSokWbeCLqeSUw8vN9y+qZgDVPeNS9R/E3m1PWvQVQATWPw0ZxgPS
OoQAoZv1JWkyqQfyOj8CA4QcUm+P2Q==
=7tLC
-----END PGP SIGNATURE-----

--qo0ZXFbBZ3z4IfBid0wxcentddpZPPfw7--
