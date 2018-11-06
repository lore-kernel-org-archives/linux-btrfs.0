Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EA7C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 08:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17C720862
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 08:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D17C720862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbeKFRru (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 12:47:50 -0500
Received: from mout.gmx.net ([212.227.17.20]:47055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbeKFRrt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 12:47:49 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LoJDJ-1frDTL19Mf-00gIXI; Tue, 06
 Nov 2018 09:23:43 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LoJDJ-1frDTL19Mf-00gIXI; Tue, 06
 Nov 2018 09:23:43 +0100
Subject: Re: btrfs partition is broken, cannot restore anything
To:     Attila Vangel <vangel.attila@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
 <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com>
 <CAGSQd2-fUDpbBqN-0dAtLg=LBh7mDhHmxg59LGE6tXsRZJ-HAw@mail.gmail.com>
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
Message-ID: <3740e1fd-9078-0655-3fdf-32d8faeafb12@gmx.com>
Date:   Tue, 6 Nov 2018 16:22:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAGSQd2-fUDpbBqN-0dAtLg=LBh7mDhHmxg59LGE6tXsRZJ-HAw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UXz2ZPlbmJw2zrJFctVxBuN9T1lBQalxH"
X-Provags-ID: V03:K1:8n1sORLVzJ1QRD8k6rzUnlaLfNb+yAj2MH+d/pXX+9DMAyNKNNe
 YRiazqKHbccsj7WYnRPeMUXs2g5JpJJuI3wsVp2klaK+nYW94jQTlRC0cUX2zsw9PnLKiju
 2h5DloZsM37QVM4M5ytBj63mwpNLKtjssGMaTdiwaBMejqczlBnMKUonnSEYF2Ae6eVMFed
 /2nPt41Dzjp2oDQY4KsqQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:L2CZAO6unLU=:bEjFICTIhJ9V/krXT0USOy
 dCEMwpd0HiUfPDlkYfHIw9wqP0cDOEZg6HSaThwbwS1fwuvnFX/GqZwPbQsbWQsJBMWHrlKrC
 MDsLpjBNRBZH1LxD0Eyqgg9D9UoE41x3Xdbt3z5H3w7kUyEdSa7PfDYnNxLYr2zd4ulOt3fpZ
 iltUQb2t+Dr0T3bSWq47n+cWJPmmd+XJgpDBI4Do5/o3OwuZShRXPYcppJ4BN0mbqYYI5FE8Z
 +bNXxx9T7lgtMFhWu19bjTKOTGz41VKnOrjm+VEBsDmUIq7vcHREIk9j3adbV3m3jf39jkZ0i
 8ykLT2P4XkSOD5cppskMKkCYdQh3bV6IN7JZ3svfb63wuxL4iDtuRgdk7V3FyqtqqSE3CU3zA
 yajYIYEXIlYnVc04drrEh974BN6Hl/gh9tH27fT3IDFNwadGOxTbQcF85j7d4w69PAGghAHb1
 1oU1Qq6WxVwyt2wlUbERoMhS0Rm4XsF9B6BE1iM+OyXcF7IGlKGCJPol89TiTcNN12LV2kZ/u
 VTTUTqHYMwhzgqGBMstGOF7AK+KJEeqtpMFvCu75mVu64PsxZG1o21n1k1ndd9NhSlIxpzGSP
 5+zv9Kl5D8S5NlxrBRAjKIaA4FNRGHrJgdGVaPvTnHv1PAO6Iez2SNOnZpcNVmon9e9UR02y3
 u6PKfeM0F7qoOSph5vjKiUsfwmz2dJ1xfZCZ+uDZNnZppaGyOiURCyCij17UzRCYz7zp7fpR5
 VOfi/BzpogKumsTW2c2Lfa0TtIrlciLOw3+wSa7HWIjfR89IRbx/9fbQvYLWCWrGhlMeuqT0J
 ltCOblT0lSjPG8YmXuEIP2w4woHH7M3wcPVVWzT0Pvsa4URL9bhLXA8xQyPeaNg/ZnD27SbzZ
 +Jz+08codO0ivmseaMHTo4SJHJ1EG2h+PAQOpR92fLcxV95kNBM47d0xl52zgG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UXz2ZPlbmJw2zrJFctVxBuN9T1lBQalxH
Content-Type: multipart/mixed; boundary="xnBqhHXRIQ3uwWhzg3WBni4TBoxWFVZJ6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Attila Vangel <vangel.attila@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <3740e1fd-9078-0655-3fdf-32d8faeafb12@gmx.com>
Subject: Re: btrfs partition is broken, cannot restore anything
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
 <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com>
 <CAGSQd2-fUDpbBqN-0dAtLg=LBh7mDhHmxg59LGE6tXsRZJ-HAw@mail.gmail.com>
In-Reply-To: <CAGSQd2-fUDpbBqN-0dAtLg=LBh7mDhHmxg59LGE6tXsRZJ-HAw@mail.gmail.com>

--xnBqhHXRIQ3uwWhzg3WBni4TBoxWFVZJ6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/6 =E4=B8=8B=E5=8D=884:17, Attila Vangel wrote:
> Hi Qu,
>=20
> Thanks again for the help.
> In my case:
>=20
> $ sudo btrfs check /dev/nvme0n1p2
> Opening filesystem to check...
> checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
> checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
> bad tree block 18811453440, bytenr mismatch, want=3D18811453440, have=3D=
0
> ERROR: cannot open file system

As expected, since extent tree is corrupted, btrfs check can't do much he=
lp.

This is definitely something we could enhance, although it will take a
long time for btrfs-progs to handle such case, then some super hard
kernel mount option for kernel to do pure RO mount.

>=20
> (same with --mode=3Dlowmem).
>=20
> However "btrfs restore" seems to work! (did not have time for the
> actual run yet)
>=20
> What confused me about "btrds restore" is when I ran a dry run, it
> just output about a dozen errors about some files, and I thought
> that's it, no files can be restored.
> Today I tried it with other options, especially -v shown me that the
> majority of the files can be restored. I consider myself an
> intermediate GNU plus Linux user, yet given the stressful situation
> and being a first time user (btrfs n00b) I missed experimenting with
> the -v option.
>=20
> So I propose that "btrs restore" should always print a summary line at
> the end to make it more user friendly (e.g. for the first time users).
> Something like this:
>=20
> x files restored in y directories[, total size of files is z <human
> readable unit e.g. GB>]. Use -v command line option for more
> information.
>=20
> The part in square bracket is optional / nice to have, might be useful
> e.g. to estimate the required free space in the target filesystem.

Nice idea. Maybe we could enhance btrfs-restore to that direction.

Thanks,
Qu

>=20
> Cheers,
> Attila
>=20
> On Tue, Nov 6, 2018 at 2:28 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>
>>
>>
>> On 2018/11/6 =E4=B8=8A=E5=8D=882:01, Attila Vangel wrote:
>>> Hi,
>>>
>>> TL;DR: I want to save data from my unmountable btrfs partition.
>>> I saw some commands in another thread "Salvage files from broken btrf=
s".
>>> I use the most recent Manjaro live (kernel: 4.19.0-3-MANJARO,
>>> btrfs-progs 4.17.1-1) to execute these commands.
>>>
>>> $ sudo mount -o ro,nologreplay /dev/nvme0n1p2 /mnt
>>> mount: /mnt: wrong fs type, bad option, bad superblock on
>>> /dev/nvme0n1p2, missing codepage or helper program, or other error.
>>>
>>> Corresponding lines from dmesg:
>>>
>>> [ 1517.772302] BTRFS info (device nvme0n1p2): disabling log replay at=
 mount time
>>> [ 1517.772307] BTRFS info (device nvme0n1p2): disk space caching is e=
nabled
>>> [ 1517.772310] BTRFS info (device nvme0n1p2): has skinny extents
>>> [ 1517.793414] BTRFS error (device nvme0n1p2): bad tree block start,
>>> want 18811453440 have 0
>>> [ 1517.793430] BTRFS error (device nvme0n1p2): failed to read block g=
roups: -5
>>> [ 1517.808619] BTRFS error (device nvme0n1p2): open_ctree failed
>>
>> Extent tree corrupted.
>>
>> If it's the only problem, btrfs-restore should be able to salvage data=
=2E
>>
>>>
>>> $ sudo btrfs-find-root /dev/nvme0n1p2
>>
>> No, that's not what you need.
>>
>>> Superblock thinks the generation is 220524
>>> Superblock thinks the level is 1
>>> Found tree root at 25018368 gen 220524 level 1
>>> Well block 4243456(gen: 220520 level: 1) seems good, but
>>> generation/level doesn't match, want gen: 220524 level: 1
>>> Well block 5259264(gen: 220519 level: 1) seems good, but
>>> generation/level doesn't match, want gen: 220524 level: 1
>>> Well block 4866048(gen: 220518 level: 0) seems good, but
>>> generation/level doesn't match, want gen: 220524 level: 1
>>>
>>> $ sudo btrfs ins dump-super -Ffa /dev/nvme0n1p2
>>> superblock: bytenr=3D65536, device=3D/dev/nvme0n1p2
>> [snip]
>>>
>>> If I understood correctly, somehow it is possible to use this data to=

>>> parametrize btrfs restore to save the files from the partition.
>>
>> None of the output is really helpful.
>>
>> In your case, your extent tree is corrupted, thus kernel will refuse t=
o
>> mount (even RO).
>>
>> You should run "btrfs check" on the fs to see if btrfs can check fs tr=
ee.
>> If not, then go directly to "btrfs restore".
>>
>> Thanks,
>> Qu
>>
>>> Could you please help how to do it in this case? I am not familiar
>>> with these technical terms in the outputs.
>>> Thanks in advance!
>>>
>>> Cheers,
>>> Attila
>>>
>>> On Thu, Nov 1, 2018 at 8:40 PM Attila Vangel <vangel.attila@gmail.com=
> wrote:
>>>>
>>>> Hi,
>>>>
>>>> Somehow my btrfs partition got broken. I use Arch, so my kernel is
>>>> quite new (4.18.x).
>>>> I don't remember exactly the sequence of events. At some point it wa=
s
>>>> accessible in read-only, but unfortunately I did not take backup
>>>> immediately. dmesg log from that time:
>>>>
>>>> [ 62.602388] BTRFS warning (device nvme0n1p2): block group
>>>> 103923318784 has wrong amount of free space
>>>> [ 62.602390] BTRFS warning (device nvme0n1p2): failed to load free
>>>> space cache for block group 103923318784, rebuilding it now
>>>> [ 108.039188] BTRFS error (device nvme0n1p2): bad tree block start 0=
 18812026880
>>>> [ 108.039227] BTRFS: error (device nvme0n1p2) in
>>>> __btrfs_free_extent:7010: errno=3D-5 IO failure
>>>> [ 108.039241] BTRFS info (device nvme0n1p2): forced readonly
>>>> [ 108.039250] BTRFS: error (device nvme0n1p2) in
>>>> btrfs_run_delayed_refs:3076: errno=3D-5 IO failure
>>>>
>>>> At the next reboot it failed to mount. Problem may have been that at=

>>>> some point I booted to another distro with older kernel (4.15.x,
>>>> 4.14.52) and unfortunately attempted some checks/repairs (?) e.g. fr=
om
>>>> gparted, and at that time I did not know it could be destructive.
>>>>
>>>> Anyway, currently it fails to mount (even with ro and/or recovery),
>>>> btrfs check results in "checksum verify failed" and "bad tree block"=

>>>> errors, btrfs restore resulted in "We have looped trying to restore
>>>> files in" errors for a dozen of paths then exit.
>>>>
>>>> Is there some hope to save data from the filesystem, and if so, how?=

>>>>
>>>> BTW I checked some diagnostics commands regarding my SSD with the nv=
me
>>>> client and from that it seems there are no hardware problems.
>>>>
>>>> Your help is highly appreciated.
>>>>
>>>> Cheers,
>>>> Attila
>>


--xnBqhHXRIQ3uwWhzg3WBni4TBoxWFVZJ6--

--UXz2ZPlbmJw2zrJFctVxBuN9T1lBQalxH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvhT2IACgkQwj2R86El
/qj+0Af/VQ5HvRQaC1Jx8NlpKmSV9zSDcjgxafT0GjqlqxnJGxdxDEwHMAXomUgS
1EljkfumgUdXPQCQtIwKTLk1/nQUBMPXqtC/bcyjC89w4J/i8ivfoV0nfNFPtnWK
pShgXvgtZFKW+bY98tHRuchoW075PqxJ48O1uo4X0BAkXxzXmoSoOhb76GJcnUCJ
MYnd5L0rrbSBZH4gVu+BtsxMy621NGqsrDvmk+6DFqdalTnD3iSr8eJfls0yjva1
nDNSfMBn+2Ht64AKcKNbYcM6u9VKzUuItPLJVmLEEusM1/O9QjCNUZ7c1KX3Mg1J
zHZ9AkiS0tVbSb7oD5ROH9TbQLrKCA==
=RZsG
-----END PGP SIGNATURE-----

--UXz2ZPlbmJw2zrJFctVxBuN9T1lBQalxH--
