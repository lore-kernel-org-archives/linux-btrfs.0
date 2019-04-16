Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A790C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 00:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00DD620830
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 00:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ax8uceOR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfDPATo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 20:19:44 -0400
Received: from mout.gmx.net ([212.227.15.19]:59711 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfDPATn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 20:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555373978;
        bh=7WBkz0XrwJaBxRlI2S5aqWByhF5SM3IxoumuTTYMQFw=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=ax8uceORcnijiBvvAWdTzoSA++l0DlLZFm2wVE3hQ0B/mlo2w3Q2z5CI/UVVrG/Uy
         /fQ/a431mgvHJk+svDC4LVrlpvnnD9lH8C6Lm+cmJ+orj1TfMYe/4dJBfoqnh2BiMX
         nms3EAsb/R5aFDaoImvJc3NluDaArqTNzzu35CFs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N95e9-1gkmZa2qHP-0163d4; Tue, 16
 Apr 2019 02:19:38 +0200
Subject: Re: [PULL REQUEST] btrfs-progs updates, the main part
To:     dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <48f7ce97-b1cb-b7f8-5b4d-33c8e3737fcf@gmx.com>
 <20190415162727.GB22216@twin.jikos.cz>
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
Message-ID: <d6db1caf-cbc9-3229-13b2-aab6a3750a38@gmx.com>
Date:   Tue, 16 Apr 2019 08:19:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415162727.GB22216@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FegjSx4EKNvqCrkmEgv8nvB3vZTXDjxI1"
X-Provags-ID: V03:K1:7Fl24WLvi2uPAWxtbn0ShfS3AA08cQ0vKeUf+KS7eD1D31GfhtC
 bJTigVU5eX3Ro31DQmTPvbjN1zrCyqDeHd/QVDjqke1a9i9cLmBk4Zng96LHvT78PgTvlvd
 kJVgLfmh5+zGwAnIioLGSRICa8/rAeHMIjtv7a6oBlKx3qtnm3NlX6aA1EPORBXx2Qkc71n
 RBGBnfY+owgylj8i9Q1zA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fk9KKCF3c78=:1vxXJ4kVUgjKri1DATs2Fk
 wBw6yHQkxEMDzUko4LEDsnD2OmqalwkMAhVgFWBI5nIjbjDjSY6fISYNqac+KjSAt3on7iFHu
 UxKdNT74LFep7xwmEtqnasOfAgwOZvAGGAEPtXBOuYQhuZiHTu1xwXW+7ve319FcPjzXrTUAq
 4ghzZZlfrXaYk0PUSfsY2dQu0Fe16sHCjdgXkkDqa1qBQ8o4aNse+/O9gq9+wllfwDEfuIdb3
 WQYEcioHeDbyO1/dQM9J1xD6irZRcu8rtersohwcSj+HBAgVvgTEWFpjS+UM/dOEzlUnwHG3b
 Mcze7kC6Vx6WyLP0oAjgKq9qBGaUXmLcitm6XG00LT5yjU1HDgTerv6gjrn6v7Y51cNTm0HtS
 VEjWAHs31fhH1x+OqbjgKeKnZPQhT2n7EfBQh/k9JrGs9MINOjbIsa3NXWTsUnyThGXUOfB4f
 1wJlh24gEmbvRMZeDKE4nds3OtiCVVp6Q6OOizV6Rt3xHH7RylpxA0+8YHZ6BkF9YKugpgKIZ
 RJhh3QomEcyY4UkJCjYqLhasnnf+hVLgf7iz/ViugDejnu5ml8pvLvEYur0KVLxuS2OBKCDTR
 lN/lEW/zaRWqmz8CHVmdaMrW2iM7r+RTypfAHNjL4zI6JoZpF0crr9WbPkaMT/Vegc3VGCGKE
 7iYvDstXmI8sB0ZWc9HPslK3P8cNNk+amiFAICfAre0BgISGUwQ+sUpu27FR5G3QQe+qWEIzn
 HBkMN8P/ZT8qhdNgS32pJztyo2ya90AR99TYChGRA72jvET0TbN3u1IAL0zmY+rxV0+M9HkUo
 X9cJIO7lFW25gKIDaPMKMBldbderOZIISQsMvUe82FuORqkfNkEyKW8SDZrddQYcoXiN+CTq9
 hOYEBN4dKIIrJXeF0dAEMLLROrJnqSQEXutNLTAQm8fRaLOpmIBGiM5gcBDOMh
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FegjSx4EKNvqCrkmEgv8nvB3vZTXDjxI1
Content-Type: multipart/mixed; boundary="7E11nxEtzbgvEjJnH1ggbUPq1Uwk5ZrH3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <d6db1caf-cbc9-3229-13b2-aab6a3750a38@gmx.com>
Subject: Re: [PULL REQUEST] btrfs-progs updates, the main part
References: <48f7ce97-b1cb-b7f8-5b4d-33c8e3737fcf@gmx.com>
 <20190415162727.GB22216@twin.jikos.cz>
In-Reply-To: <20190415162727.GB22216@twin.jikos.cz>

--7E11nxEtzbgvEjJnH1ggbUPq1Uwk5ZrH3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/16 =E4=B8=8A=E5=8D=8812:27, David Sterba wrote:
> On Thu, Apr 11, 2019 at 01:54:44PM +0800, Qu Wenruo wrote:
>> Here is my pull request for the btrfs-progs:
>> https://github.com/adam900710/btrfs-progs/tree/for_devel
>>
>> The basis is the following commit from your devel branch:
>> commit a8389337c5a0e7c3fb32ff91d557889c036da73a
>> Author: Adam Borowski <kilobyte@angband.pl>
>> Date:   Mon Feb 25 19:16:44 2019 +0100
>>
>>     btrfs-progs: defrag: open files RO on new enough kernels
>=20
> Please rebase the branch on top of current devel, with "btrfs-progs:
> Remove get_argv0_buf". I had a few patches merged but the branch was no=
t
> public so there's some duplication.
>=20
>> This branch drops the following commit in your devel branch:
>> commit 4e8eb31f048f3fe9a68aacb58e4c0714df25b5c4 (david/devel)
>> Author: Qu Wenruo <wqu@suse.com>
>> Date:   Fri Sep 14 15:49:44 2018 +0800
>>
>>     btrfs-progs: Do metadata preallocation as long as we're not
>> modifying extent tree
>=20
> This fixes issue #123, is there another fix?=20

Not yet, the reason is known but new fix is still under development.
Discarding it at least won't cause new problem.


>I'll drop the patch from
> devel as it fails the test so the revert won't be needed.
>=20
>> Due to test failure on looping chunk allocation.
>>
>> The branch passes all selftests, except misc/035 which is a known prob=
lem.
>>
>> This pull request include the following features:
>>
>> Core change:
>> - check --repair
>>   * Flush/FUA support to avoid breaking metadata CoW
>>       Now btrfs-progs crashing or transaction aborted won't cause
>>       new transid error.
>> - device scan:
>>   * Add the ability to forget a device
>>
>> Fixes and Enhancement:
>> - generic
>>   * Try best copy when reading tree blocks.
>>   * Skip unnecessary retry when one tree block copy fails.
>>   * Avoid back tree block to populate tree block cache.
>> - check
>>   * File extents repair no longer relies data in extent tree.
>>   * New ability to check and repair free space cache invalid inode mod=
e.
>>   * Update backup roots when commit transaction.
>> - mkfs:
>>   * Enlarge metadata chunk size to follow kernel size.
>> - defrag
>>   * open file in RO for newer kernel.
>> - gitignore
>>   * Ignore hidden files.
>> - qgroup report
>>   * Handle unrecognized sort string.
>> - receive
>>   * New quite mode.
>> - Misc
>>   * More cleanup for fs_info <-> root parameters.
>=20
> Nice, I'll put it to the merge commit once the branch is ready.
>=20
[snip]
>>   btrfs-progs: qgroup show: report errors while parsing sort string
>>   btrfs-progs: qgroup show: report unrecognized format of sort string
>>   btrfs-progs: qgoup: propagate errors from
>>     btrfs_qgroup_parse_sort_string
>=20
> For pull-based workflows there are some things that I'd require, based
> on what I do for kernel patches, so let's use this one to set the
> expectations:
>=20
> The excerpt above from the shortlog (and other commits) was not intende=
d
> to be pulled, so it should not be in the shortlog.

Got it.

>=20
> Please note that all patches need to have signed-off-by by the
> committer. This is not true for

Just one minor question, if I'm the author, no need for another SoB line
right?

>=20
> - btrfs-progs: fsck-test: enable lowmem repair for case 001
> - btrfs-progs: tests: add case for inode lose one file extent
>=20
> The commits that do revert do not need the 'btrfs-progs:' prefix,
> without it it's obvious in the patch subject list that those are
> exceptions.
>=20
> One thing that I edit in almost all commit is the order of tags, briefl=
y
> documented at
> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Ordering

Oh, this is indeed different from my understand.

Especially for the reviewed-by and tested-by tags.

I'll definitely reorder those in next update.

Thanks,
Qu
>=20
> I don't require a signed tag to pull as the amount of pull requests is
> not going to be high, review is feasible for me.
>=20
> One thing that might be new for you is that you'll be the first get
> blamed for everything what's in the branch you send to pull, then the
> original authors :) It's good to favor quality over quantity.
>=20
> There's probably more of lower importance, we'll find out along the way=
=2E
>=20


--7E11nxEtzbgvEjJnH1ggbUPq1Uwk5ZrH3--

--FegjSx4EKNvqCrkmEgv8nvB3vZTXDjxI1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly1H5YACgkQwj2R86El
/qiH8QgAoajOnXyYRHpNbyrp1b6xhY9r2zL6qRGaTux1agT61993rpjq3gFXPdaR
ILc9CiGlFA/DYGAfXlp4bshr43kO7T9Wj2tvxBv4b+IYneRFvujj1R4usuHriOFQ
dGWj68oRpd47DMMS1htWABSqn5yd1GqajrdypIWhpFWMLLThpqCzN7g4MJ2heZxn
XIHem97zAB8jSQXrv6Ux4Babie89mYO3DGMY1LFNp3TV4Lo0fLNfBJpIunKe0A/3
1fS3H6IkKBrBmLyxp4nAzvmToWSnEmfI8haQBnl9n47BW6T28ZFNP2xTcfLGlWvr
Q5BKdWrDXACQS75+U1xAC0vpUPmvBw==
=TXZN
-----END PGP SIGNATURE-----

--FegjSx4EKNvqCrkmEgv8nvB3vZTXDjxI1--
