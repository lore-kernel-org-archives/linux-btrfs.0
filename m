Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1E0C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 00:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF3A5208A3
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 00:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF3A5208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbeLCAqM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 19:46:12 -0500
Received: from mout.gmx.net ([212.227.17.20]:33515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbeLCAqM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Dec 2018 19:46:12 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MYcJi-1gyqcH02QU-00VTVQ; Mon, 03
 Dec 2018 01:45:59 +0100
Subject: Re: Need help with potential ~45TB dataloss
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     Patrick Dijkgraaf <bolderbast@duckstad.net>,
        linux-btrfs@vger.kernel.org
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
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
Message-ID: <b905e50b-bfd8-348a-992a-e8fee7785eb9@gmx.com>
Date:   Mon, 3 Dec 2018 08:45:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KZIvZgxlpYCzHwkobijh6bauSvVCwhear"
X-Provags-ID: V03:K1:KUVULzC0TQXZN0ll2nlQ9r0zQGu0HCjqL3DZF9jKFQk5C0AANLh
 7ugU7fU3QN3ljZ8VyLQAErHHqcZUv0cV///9XBWMnbRrEnEcQmS75L4iGlG/W6I9LZYqZik
 Ghj63AOiVuNpqa+Hrh6859iMDdFr00ZdbT7dAdIfROfMsWNTOAe1mksxLk+IWUu39BCm+ww
 krI3rgW51zMey+GqRUpDQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:b8aPyq0Wdhs=:1zikXQxgp0l9uECbI/PBqZ
 68oIfZvmWN2WhNJmbqTCC9k5euT1W5ygc53vJY8r/SQOEm10ArftYRM7HUEheddAAOWlWbw1p
 Z6ZIiIzPeF7WwpktuTKDvcVqHV+gTDccwczze/xxBqLqbHWeq+7a+BN7Tbw1N4x0k8FW5ZUN+
 e3E7wGQfH+SFXzQQEnpSbqBFQsxcK/W2perDEmgHBtbopOc2T8HvkPpGcQ8xmxA7mBgyO2Gzr
 +QKfBTGnu0lzIoajNut7OFn2sURyEBoS/fOMJBOb5JwesBJd8sgruvYgpE87uzKJRB/1NbaxI
 rfEjfJjVTti+Abu/qiC2bmD7IAEWCWLDO0iGjl0Ccq8lcjP+kmGPHoELff1A3u3SCqrzszxlw
 eWdQVDgQmR2BAMUkGB+o5GZXZkM/m5S3d7o8QN8Aw3opNb+tH8CUjUsXCsyUaiN8BCDVnSNK6
 QmFkY3RN9fbOc6myWOOmjuCUCpx+urqzmODdllISMVd3iQeZpDj4hAizadJcU6v0NoxRNtDxS
 Sqab6ohHLupJ8f4LDA1eVnIydpO0mcA699gTTFik6SO3skwq+YN2OC7ZzF1+1Yt//aWBAM7P7
 oMp8NL/FkePBOV00+XiX9fAR4leG1iEOetuaANicvqPXx1Fey6Gl0jdyLMqHtBRPH58Z3KlQ3
 ObnxzTnNwpUArfhp5x71Ntc+6utCgffiCIGrAbFRIByi+72JwH2G6qNRW259A1qCtxaYnDc6q
 eoxQX/l0n+1dG8yrfr5KXtq6OlJ2OLYqGoD560Grz4Iuc4PUGIdb5UiuuPGRjkOvSPMOUObrI
 jgSVHZ5Hjv0c0HZ77GeI7bxktvtfyvFxJSdl7+Tk9H8aRejUeuPdAbYCG9NxU/judIMRcgCWR
 24Pkzz6q2qmRG5CenB4uU3JhCTnM6Q4yd5yCDXSkWIrDOEcUm4fF1UUdNQLyrK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KZIvZgxlpYCzHwkobijh6bauSvVCwhear
Content-Type: multipart/mixed; boundary="S4KQjro53tFFvnVwCq8tXIx36nw6ovQ23";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Patrick Dijkgraaf <bolderbast@duckstad.net>, linux-btrfs@vger.kernel.org
Message-ID: <b905e50b-bfd8-348a-992a-e8fee7785eb9@gmx.com>
Subject: Re: Need help with potential ~45TB dataloss
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
In-Reply-To: <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>

--S4KQjro53tFFvnVwCq8tXIx36nw6ovQ23
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/3 =E4=B8=8A=E5=8D=888:35, Qu Wenruo wrote:
>=20
>=20
> On 2018/12/2 =E4=B8=8B=E5=8D=885:03, Patrick Dijkgraaf wrote:
>> Hi Qu,
>>
>> Thanks for helping me!
>>
>> Please see the reponses in-line.
>> Any suggestions based on this?
>>
>> Thanks!
>>
>>
>> On Sat, 2018-12-01 at 07:57 +0800, Qu Wenruo wrote:
>>> On 2018/11/30 =E4=B8=8B=E5=8D=889:53, Patrick Dijkgraaf wrote:
>>>> Hi all,
>>>>
>>>> I have been a happy BTRFS user for quite some time. But now I'm
>>>> facing
>>>> a potential ~45TB dataloss... :-(
>>>> I hope someone can help!
>>>>
>>>> I have Server A and Server B. Both having a 20-devices BTRFS RAID6
>>>> filesystem.

I forgot one important thing here, specially for RAID6.

If one data device corrupted, RAID6 will normally try to rebuild using
RAID5 way, and if another one disk get corrupted, it may not recover
correctly.

Current way to recover is try *all* combination.

IIRC Liu Bo tried such patch but not merged.

This means current RAID6 can only handle two missing devices at its best
condition.
But for corruption, it can only be as good as RAID5.

Thanks,
Qu

> Because of known RAID5/6 risks, Server B was a backup
>>>> of
>>>> Server A.
>>>> After applying updates to server B and reboot, the FS would not
>>>> mount
>>>> anymore. Because it was "just" a backup. I decided to recreate the
>>>> FS
>>>> and perform a new backup. Later, I discovered that the FS was not
>>>> broken, but I faced this issue:=20
>>>> https://patchwork.kernel.org/patch/10694997/
>>>>
>>>
>>> Sorry for the inconvenience.
>>>
>>> I didn't realize the max_chunk_size limit isn't reliable at that
>>> timing.
>>
>> No problem, I should not have jumped to the conclusion to recreate the=

>> backup volume.
>>
>>>> Anyway, the FS was already recreated, so I needed to do a new
>>>> backup.
>>>> During the backup (using rsync -vah), Server A (the source)
>>>> encountered
>>>> an I/O error and my rsync failed. In an attempt to "quick fix" the
>>>> issue, I rebooted Server A after which the FS would not mount
>>>> anymore.
>>>
>>> Did you have any dmesg about that IO error?
>>
>> Yes there was. But I omitted capturing it... The system is now reboote=
d
>> and I can't retrieve it anymore. :-(
>>
>>> And how is the reboot scheduled? Forced power off or normal reboot
>>> command?
>>
>> The system was rebooted using a normal reboot command.
>=20
> Then the problem is pretty serious.
>=20
> Possibly already corrupted before.
>=20
>>
>>>> I documented what I have tried, below. I have not yet tried
>>>> anything
>>>> except what is shown, because I am afraid of causing more harm to
>>>> the FS.
>>>
>>> Pretty clever, no btrfs check --repair is a pretty good move.
>>>
>>>> I hope somebody here can give me advice on how to (hopefully)
>>>> retrieve my data...
>>>>
>>>> Thanks in advance!
>>>>
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>
>>>> [root@cornelis ~]# btrfs fi show
>>>> Label: 'cornelis-btrfs'  uuid: ac643516-670e-40f3-aa4c-f329fc3795fd
>>>> 	Total devices 1 FS bytes used 463.92GiB
>>>> 	devid    1 size 800.00GiB used 493.02GiB path
>>>> /dev/mapper/cornelis-cornelis--btrfs
>>>>
>>>> Label: 'data'  uuid: 4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
>>>> 	Total devices 20 FS bytes used 44.85TiB
>>>> 	devid    1 size 3.64TiB used 3.64TiB path /dev/sdn2
>>>> 	devid    2 size 3.64TiB used 3.64TiB path /dev/sdp2
>>>> 	devid    3 size 3.64TiB used 3.64TiB path /dev/sdu2
>>>> 	devid    4 size 3.64TiB used 3.64TiB path /dev/sdx2
>>>> 	devid    5 size 3.64TiB used 3.64TiB path /dev/sdh2
>>>> 	devid    6 size 3.64TiB used 3.64TiB path /dev/sdg2
>>>> 	devid    7 size 3.64TiB used 3.64TiB path /dev/sdm2
>>>> 	devid    8 size 3.64TiB used 3.64TiB path /dev/sdw2
>>>> 	devid    9 size 3.64TiB used 3.64TiB path /dev/sdj2
>>>> 	devid   10 size 3.64TiB used 3.64TiB path /dev/sdt2
>>>> 	devid   11 size 3.64TiB used 3.64TiB path /dev/sdk2
>>>> 	devid   12 size 3.64TiB used 3.64TiB path /dev/sdq2
>>>> 	devid   13 size 3.64TiB used 3.64TiB path /dev/sds2
>>>> 	devid   14 size 3.64TiB used 3.64TiB path /dev/sdf2
>>>> 	devid   15 size 7.28TiB used 588.80GiB path /dev/sdr2
>>>> 	devid   16 size 7.28TiB used 588.80GiB path /dev/sdo2
>>>> 	devid   17 size 7.28TiB used 588.80GiB path /dev/sdv2
>>>> 	devid   18 size 7.28TiB used 588.80GiB path /dev/sdi2
>>>> 	devid   19 size 7.28TiB used 588.80GiB path /dev/sdl2
>>>> 	devid   20 size 7.28TiB used 588.80GiB path /dev/sde2
>>>>
>>>> [root@cornelis ~]# mount /dev/sdn2 /mnt/data
>>>> mount: /mnt/data: wrong fs type, bad option, bad superblock on
>>>> /dev/sdn2, missing codepage or helper program, or other error.
>>>
>>> What is the dmesg of the mount failure?
>>
>> [Sun Dec  2 09:41:08 2018] BTRFS info (device sdn2): disk space cachin=
g
>> is enabled
>> [Sun Dec  2 09:41:08 2018] BTRFS info (device sdn2): has skinny extent=
s
>> [Sun Dec  2 09:41:08 2018] BTRFS error (device sdn2): parent transid
>> verify failed on 46451963543552 wanted 114401 found 114173
>> [Sun Dec  2 09:41:08 2018] BTRFS critical (device sdn2): corrupt leaf:=

>> root=3D2 block=3D46451963543552 slot=3D0, unexpected item end, have
>> 1387359977 expect 16283
>=20
> OK, this shows that one of the copy has mismatched generation while the=

> other copy is completely corrupted.
>=20
>> [Sun Dec  2 09:41:08 2018] BTRFS warning (device sdn2): failed to read=

>> tree root
>> [Sun Dec  2 09:41:08 2018] BTRFS error (device sdn2): open_ctree faile=
d
>>
>>> And have you tried -o ro,degraded ?
>>
>> Tried it just now, gives the exact same error.
>>
>>>> [root@cornelis ~]# btrfs check /dev/sdn2
>>>> Opening filesystem to check...
>>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>>> 114173
>>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>>> 114173
>>>> checksum verify failed on 46451963543552 found A8F2A769 wanted
>>>> 4C111ADF
>>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>>> 8B07ABE4
>>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>>> 8B07ABE4
>>>> bad tree block 46451963543552, bytenr mismatch,
>>>> want=3D46451963543552,
>>>> have=3D75208089814272
>>>> Couldn't read tree root
>>>
>>> Would you please also paste the output of "btrfs ins dump-super
>>> /dev/sdn2" ?
>>
>> [root@cornelis ~]# btrfs ins dump-super /dev/sdn2
>> superblock: bytenr=3D65536, device=3D/dev/sdn2
>> ---------------------------------------------------------
>> csum_type		0 (crc32c)
>> csum_size		4
>> csum			0x51725c39 [match]
>> bytenr			65536
>> flags			0x1
>> 			( WRITTEN )
>> magic			_BHRfS_M [match]
>> fsid			4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
>> label			data
>> generation		114401
>> root			46451963543552
>=20
> The bytenr matches with the dmesg, so it's tree root node corrupted.
>=20
>> sys_array_size		513
>> chunk_root_generation	112769
>> root_level		1
>> chunk_root		22085632
>> chunk_root_level	1
>> log_root		46451935461376
>> log_root_transid	0
>> log_root_level		0
>> total_bytes		104020314161152
>> bytes_used		49308554543104
>> sectorsize		4096
>> nodesize		16384
>> leafsize (deprecated)		16384
>> stripesize		4096
>> root_dir		6
>> num_devices		20
>> compat_flags		0x0
>> compat_ro_flags		0x0
>> incompat_flags		0x1e1
>> 			( MIXED_BACKREF |
>> 			  BIG_METADATA |
>> 			  EXTENDED_IREF |
>> 			  RAID56 |
>> 			  SKINNY_METADATA )
>> cache_generation	114401
>> uuid_tree_generation	114401
>> dev_item.uuid		c6b44903-e849-4403-98c4-f3ba4d0b3fc3
>> dev_item.fsid		4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5 [match]
>> dev_item.type		0
>> dev_item.total_bytes	4000783007744
>> dev_item.bytes_used	4000781959168
>> dev_item.io_align	4096
>> dev_item.io_width	4096
>> dev_item.sector_size	4096
>> dev_item.devid		1
>> dev_item.dev_group	0
>> dev_item.seek_speed	0
>> dev_item.bandwidth	0
>> dev_item.generation	0
>>
>>> It looks like your tree root (or at least some tree root nodes/leaves=

>>> get corrupted)
>>>
>>>> ERROR: cannot open file system
>>>
>>> And since it's your tree root corrupted, you could also try
>>> "btrfs-find-root <device>" to try to get a good old copy of your tree=

>>> root.
>>
>> The output is rather long. I pasted it here:=20
>> https://pastebin.com/FkyBLgj9
>> I'm unsure what to look for in this output?
>=20
> This shows all the candidates of the older tree root bytenr.
>=20
> We could use it to try to recover.
>=20
> You could then try the following command and see if btrfs check can go
> further.
>=20
>  # btrfs check -r 45462239363072 <device>
>=20
>=20
> And the following dump could also help:
>=20
>  # btrfs ins dump-tree -b 45462239363072 --follow
>=20
> Thanks,
> Qu
>=20
>>
>>> But I suspect the corruption happens before you noticed, thus the old=

>>> tree root may not help much.
>>>
>>> Also, the output of "btrfs ins dump-tree -t root <device>" will help.=

>>
>> Here it is:
>>
>> [root@cornelis ~]# btrfs ins dump-tree -t root /dev/sdn2
>> btrfs-progs v4.19=20
>> parent transid verify failed on 46451963543552 wanted 114401 found
>> 114173
>> parent transid verify failed on 46451963543552 wanted 114401 found
>> 114173
>> checksum verify failed on 46451963543552 found A8F2A769 wanted 4C111AD=
F
>> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE=
4
>> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE=
4
>> bad tree block 46451963543552, bytenr mismatch, want=3D46451963543552,=

>> have=3D75208089814272
>> Couldn't read tree root
>> ERROR: unable to open /dev/sdn2
>>
>>> Thanks,
>>> Qu
>>
>> No, thank YOU! :-)
>>
>>>> [root@cornelis ~]# btrfs restore /dev/sdn2 /mnt/data/
>>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>>> 114173
>>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>>> 114173
>>>> checksum verify failed on 46451963543552 found A8F2A769 wanted
>>>> 4C111ADF
>>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>>> 8B07ABE4
>>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>>> 8B07ABE4
>>>> bad tree block 46451963543552, bytenr mismatch,
>>>> want=3D46451963543552,
>>>> have=3D75208089814272
>>>> Couldn't read tree root
>>>> Could not open root, trying backup super
>>>> warning, device 14 is missing
>>>> warning, device 13 is missing
>>>> warning, device 12 is missing
>>>> warning, device 11 is missing
>>>> warning, device 10 is missing
>>>> warning, device 9 is missing
>>>> warning, device 8 is missing
>>>> warning, device 7 is missing
>>>> warning, device 6 is missing
>>>> warning, device 5 is missing
>>>> warning, device 4 is missing
>>>> warning, device 3 is missing
>>>> warning, device 2 is missing
>>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>>> bad tree block 22085632, bytenr mismatch, want=3D22085632,
>>>> have=3D1147797504
>>>> ERROR: cannot read chunk root
>>>> Could not open root, trying backup super
>>>> warning, device 14 is missing
>>>> warning, device 13 is missing
>>>> warning, device 12 is missing
>>>> warning, device 11 is missing
>>>> warning, device 10 is missing
>>>> warning, device 9 is missing
>>>> warning, device 8 is missing
>>>> warning, device 7 is missing
>>>> warning, device 6 is missing
>>>> warning, device 5 is missing
>>>> warning, device 4 is missing
>>>> warning, device 3 is missing
>>>> warning, device 2 is missing
>>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>>> bad tree block 22085632, bytenr mismatch, want=3D22085632,
>>>> have=3D1147797504
>>>> ERROR: cannot read chunk root
>>>> Could not open root, trying backup super
>>>>
>>>> [root@cornelis ~]# uname -r
>>>> 4.18.16-arch1-1-ARCH
>>>>
>>>> [root@cornelis ~]# btrfs --version
>>>> btrfs-progs v4.19
>>>>
>=20


--S4KQjro53tFFvnVwCq8tXIx36nw6ovQ23--

--KZIvZgxlpYCzHwkobijh6bauSvVCwhear
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwEfMMACgkQwj2R86El
/qgvOwf/ZdEyEwOqiLRUYiGmdJM0NMJLvbAHTmhp6L3An7sx9ONiep/OrQiJSLsC
OuvFsPwlJCkAfMGlU75T0CAI0mw8/jCJwbm5VX3GBJXhiiYG5NwjOMUlOtXsnrqw
yxEPwyWJZy7FwgrLniw26pXD3GqIAzw9xhBNuILm2cVL7vo8TwAQ4bgJW3JQMe2g
15qLRBmp9vC40g0CpmDk8q/OIJZD2YD7XJulKf0AnCjx4MVKAM0HJvaRTCe4H1qp
XR8A2KnzMHvzSFyUUyEyOZOF0R8Scu6X0so2tbE+d/+3Cht6/AFtBiHvSlLn2qpi
kiUu1Sc+1RE3RJE/RvxJlZNhYfVsTQ==
=EV0A
-----END PGP SIGNATURE-----

--KZIvZgxlpYCzHwkobijh6bauSvVCwhear--
