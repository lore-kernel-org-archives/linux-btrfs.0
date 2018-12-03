Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A16C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 00:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D5320892
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 00:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7D5320892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbeLCAfw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 19:35:52 -0500
Received: from mout.gmx.net ([212.227.15.15]:49473 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbeLCAfv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Dec 2018 19:35:51 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LuP5z-1hSyTB2c9n-011kmP; Mon, 03
 Dec 2018 01:35:35 +0100
Subject: Re: Need help with potential ~45TB dataloss
To:     Patrick Dijkgraaf <bolderbast@duckstad.net>,
        linux-btrfs@vger.kernel.org
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
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
Message-ID: <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
Date:   Mon, 3 Dec 2018 08:35:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SJXSyvEUrBk0BIMLj4eR09z5tGYo37qfd"
X-Provags-ID: V03:K1:jPnxag0HXTQByb6gnrea9zQxSZ9LqaEON4e5ZxDFkO/l1TA9RsB
 tyxqx5FWL4XgT5I8BITVd3JMUr0AUKww0J+9vO++nToV4iRCHTYwhPG0hX3KbtG/xI+QcJ2
 gvQ+zJA+u0jmQZQ0IXSEqw0FxCWGBIoG8pgI+iKSJTgXuVHaRDMVZ3EaQjx/FC2oEUYSRDg
 lbRbAF8fHWtUh5lfuCQHw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Cubha0BINPs=:mH2kSlFfLw7FE2uYP6APeD
 aGQ5Z89zPOA4cE8lzR9ujmwoeMGlyMggp7/BB0nVFZT872niWXhSMU3lrkcMGM+YVhcP7lrhj
 aGDXrmXSoYC9Bt67Co5CngSKPMD5izgZ/O6U0Yc1ZIj/bcmIux+OXTsiTPvfm78EIt/Q9T3rb
 6K8tJJV18Ui6gfidkgfHb8DlNAezYE359qmhcbKrKT0nNiP0dr/3pJk63jICnRFDjlbvIofbl
 FgICpkLMpb7dtlssgPNa3Rf5TWNflE0JJXtu8oRnFIoJBe+JPX9VLndj/BRuA49OLDmIJwy28
 XQQ2p78FTtgmEZh2Htiiluf80QyMhsFOwqvkUVIjmMqYkyG0n6N4vj2krmpnPdBxaWVgBbViR
 yHeWNfolClZUevF8/Mil6PQkR42zm10H5BJh6xwlJfLYph+SLZK2jpAjMAHudp674OmqB8h5k
 sZjv0U/pUK5mlmzEb6DIkrCWVmma8EmhLY6BmoeOrwggA1xzAkenl1zHNoOq/V8EEtKOyRO51
 9ycujo9Tb9z2mUwTpbqeZUpOdHZPaZds5gl4KMGTb2c4P6yu1Ce48kPo5tSFhw+AFoSM0lKsy
 jGiPdV9OfqIe3RxWI/bYsuDH5PibIq+PE11LHF8Duwok6KHHv18JMQXUiKXZzQ/1Qzsrysms0
 wTiCeVS3pxvllLiYD9fRNbeBLIfx/EWkNfaQPdnLJUwGMHL4DAc05+CY1GjKOWnDQv1ChnM9t
 cdfpzh5HUyBkWzYBm2W0MSwIIO4wn77KP9hyAqMgJr2FnckqU4kkF/GKhno3+Vh5qydXDjloZ
 5oLga3ccgce5b64ixDRkn+MmfETt0j/0PajoqhC4fPG5V67OeA1iiLktpHJMX6Ch4vRBbprjC
 g3aFqL3F7NPkSZkcDL/aBtBrUsyt2H+1oX2So9GGe/9+EQRrRL0lOgIJDxW0Jc
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SJXSyvEUrBk0BIMLj4eR09z5tGYo37qfd
Content-Type: multipart/mixed; boundary="JYWRQAdgSHZS4wAnXvatamsVgs2TgYwHW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Patrick Dijkgraaf <bolderbast@duckstad.net>, linux-btrfs@vger.kernel.org
Message-ID: <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
Subject: Re: Need help with potential ~45TB dataloss
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
In-Reply-To: <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>

--JYWRQAdgSHZS4wAnXvatamsVgs2TgYwHW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/2 =E4=B8=8B=E5=8D=885:03, Patrick Dijkgraaf wrote:
> Hi Qu,
>=20
> Thanks for helping me!
>=20
> Please see the reponses in-line.
> Any suggestions based on this?
>=20
> Thanks!
>=20
>=20
> On Sat, 2018-12-01 at 07:57 +0800, Qu Wenruo wrote:
>> On 2018/11/30 =E4=B8=8B=E5=8D=889:53, Patrick Dijkgraaf wrote:
>>> Hi all,
>>>
>>> I have been a happy BTRFS user for quite some time. But now I'm
>>> facing
>>> a potential ~45TB dataloss... :-(
>>> I hope someone can help!
>>>
>>> I have Server A and Server B. Both having a 20-devices BTRFS RAID6
>>> filesystem. Because of known RAID5/6 risks, Server B was a backup
>>> of
>>> Server A.
>>> After applying updates to server B and reboot, the FS would not
>>> mount
>>> anymore. Because it was "just" a backup. I decided to recreate the
>>> FS
>>> and perform a new backup. Later, I discovered that the FS was not
>>> broken, but I faced this issue:=20
>>> https://patchwork.kernel.org/patch/10694997/
>>>
>>
>> Sorry for the inconvenience.
>>
>> I didn't realize the max_chunk_size limit isn't reliable at that
>> timing.
>=20
> No problem, I should not have jumped to the conclusion to recreate the
> backup volume.
>=20
>>> Anyway, the FS was already recreated, so I needed to do a new
>>> backup.
>>> During the backup (using rsync -vah), Server A (the source)
>>> encountered
>>> an I/O error and my rsync failed. In an attempt to "quick fix" the
>>> issue, I rebooted Server A after which the FS would not mount
>>> anymore.
>>
>> Did you have any dmesg about that IO error?
>=20
> Yes there was. But I omitted capturing it... The system is now rebooted=

> and I can't retrieve it anymore. :-(
>=20
>> And how is the reboot scheduled? Forced power off or normal reboot
>> command?
>=20
> The system was rebooted using a normal reboot command.

Then the problem is pretty serious.

Possibly already corrupted before.

>=20
>>> I documented what I have tried, below. I have not yet tried
>>> anything
>>> except what is shown, because I am afraid of causing more harm to
>>> the FS.
>>
>> Pretty clever, no btrfs check --repair is a pretty good move.
>>
>>> I hope somebody here can give me advice on how to (hopefully)
>>> retrieve my data...
>>>
>>> Thanks in advance!
>>>
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>>> [root@cornelis ~]# btrfs fi show
>>> Label: 'cornelis-btrfs'  uuid: ac643516-670e-40f3-aa4c-f329fc3795fd
>>> 	Total devices 1 FS bytes used 463.92GiB
>>> 	devid    1 size 800.00GiB used 493.02GiB path
>>> /dev/mapper/cornelis-cornelis--btrfs
>>>
>>> Label: 'data'  uuid: 4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
>>> 	Total devices 20 FS bytes used 44.85TiB
>>> 	devid    1 size 3.64TiB used 3.64TiB path /dev/sdn2
>>> 	devid    2 size 3.64TiB used 3.64TiB path /dev/sdp2
>>> 	devid    3 size 3.64TiB used 3.64TiB path /dev/sdu2
>>> 	devid    4 size 3.64TiB used 3.64TiB path /dev/sdx2
>>> 	devid    5 size 3.64TiB used 3.64TiB path /dev/sdh2
>>> 	devid    6 size 3.64TiB used 3.64TiB path /dev/sdg2
>>> 	devid    7 size 3.64TiB used 3.64TiB path /dev/sdm2
>>> 	devid    8 size 3.64TiB used 3.64TiB path /dev/sdw2
>>> 	devid    9 size 3.64TiB used 3.64TiB path /dev/sdj2
>>> 	devid   10 size 3.64TiB used 3.64TiB path /dev/sdt2
>>> 	devid   11 size 3.64TiB used 3.64TiB path /dev/sdk2
>>> 	devid   12 size 3.64TiB used 3.64TiB path /dev/sdq2
>>> 	devid   13 size 3.64TiB used 3.64TiB path /dev/sds2
>>> 	devid   14 size 3.64TiB used 3.64TiB path /dev/sdf2
>>> 	devid   15 size 7.28TiB used 588.80GiB path /dev/sdr2
>>> 	devid   16 size 7.28TiB used 588.80GiB path /dev/sdo2
>>> 	devid   17 size 7.28TiB used 588.80GiB path /dev/sdv2
>>> 	devid   18 size 7.28TiB used 588.80GiB path /dev/sdi2
>>> 	devid   19 size 7.28TiB used 588.80GiB path /dev/sdl2
>>> 	devid   20 size 7.28TiB used 588.80GiB path /dev/sde2
>>>
>>> [root@cornelis ~]# mount /dev/sdn2 /mnt/data
>>> mount: /mnt/data: wrong fs type, bad option, bad superblock on
>>> /dev/sdn2, missing codepage or helper program, or other error.
>>
>> What is the dmesg of the mount failure?
>=20
> [Sun Dec  2 09:41:08 2018] BTRFS info (device sdn2): disk space caching=

> is enabled
> [Sun Dec  2 09:41:08 2018] BTRFS info (device sdn2): has skinny extents=

> [Sun Dec  2 09:41:08 2018] BTRFS error (device sdn2): parent transid
> verify failed on 46451963543552 wanted 114401 found 114173
> [Sun Dec  2 09:41:08 2018] BTRFS critical (device sdn2): corrupt leaf:
> root=3D2 block=3D46451963543552 slot=3D0, unexpected item end, have
> 1387359977 expect 16283

OK, this shows that one of the copy has mismatched generation while the
other copy is completely corrupted.

> [Sun Dec  2 09:41:08 2018] BTRFS warning (device sdn2): failed to read
> tree root
> [Sun Dec  2 09:41:08 2018] BTRFS error (device sdn2): open_ctree failed=

>=20
>> And have you tried -o ro,degraded ?
>=20
> Tried it just now, gives the exact same error.
>=20
>>> [root@cornelis ~]# btrfs check /dev/sdn2
>>> Opening filesystem to check...
>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>> 114173
>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>> 114173
>>> checksum verify failed on 46451963543552 found A8F2A769 wanted
>>> 4C111ADF
>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>> 8B07ABE4
>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>> 8B07ABE4
>>> bad tree block 46451963543552, bytenr mismatch,
>>> want=3D46451963543552,
>>> have=3D75208089814272
>>> Couldn't read tree root
>>
>> Would you please also paste the output of "btrfs ins dump-super
>> /dev/sdn2" ?
>=20
> [root@cornelis ~]# btrfs ins dump-super /dev/sdn2
> superblock: bytenr=3D65536, device=3D/dev/sdn2
> ---------------------------------------------------------
> csum_type		0 (crc32c)
> csum_size		4
> csum			0x51725c39 [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
> label			data
> generation		114401
> root			46451963543552

The bytenr matches with the dmesg, so it's tree root node corrupted.

> sys_array_size		513
> chunk_root_generation	112769
> root_level		1
> chunk_root		22085632
> chunk_root_level	1
> log_root		46451935461376
> log_root_transid	0
> log_root_level		0
> total_bytes		104020314161152
> bytes_used		49308554543104
> sectorsize		4096
> nodesize		16384
> leafsize (deprecated)		16384
> stripesize		4096
> root_dir		6
> num_devices		20
> compat_flags		0x0
> compat_ro_flags		0x0
> incompat_flags		0x1e1
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  RAID56 |
> 			  SKINNY_METADATA )
> cache_generation	114401
> uuid_tree_generation	114401
> dev_item.uuid		c6b44903-e849-4403-98c4-f3ba4d0b3fc3
> dev_item.fsid		4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5 [match]
> dev_item.type		0
> dev_item.total_bytes	4000783007744
> dev_item.bytes_used	4000781959168
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		1
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
>=20
>> It looks like your tree root (or at least some tree root nodes/leaves
>> get corrupted)
>>
>>> ERROR: cannot open file system
>>
>> And since it's your tree root corrupted, you could also try
>> "btrfs-find-root <device>" to try to get a good old copy of your tree
>> root.
>=20
> The output is rather long. I pasted it here:=20
> https://pastebin.com/FkyBLgj9
> I'm unsure what to look for in this output?

This shows all the candidates of the older tree root bytenr.

We could use it to try to recover.

You could then try the following command and see if btrfs check can go
further.

 # btrfs check -r 45462239363072 <device>


And the following dump could also help:

 # btrfs ins dump-tree -b 45462239363072 --follow

Thanks,
Qu

>=20
>> But I suspect the corruption happens before you noticed, thus the old
>> tree root may not help much.
>>
>> Also, the output of "btrfs ins dump-tree -t root <device>" will help.
>=20
> Here it is:
>=20
> [root@cornelis ~]# btrfs ins dump-tree -t root /dev/sdn2
> btrfs-progs v4.19=20
> parent transid verify failed on 46451963543552 wanted 114401 found
> 114173
> parent transid verify failed on 46451963543552 wanted 114401 found
> 114173
> checksum verify failed on 46451963543552 found A8F2A769 wanted 4C111ADF=

> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4=

> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4=

> bad tree block 46451963543552, bytenr mismatch, want=3D46451963543552,
> have=3D75208089814272
> Couldn't read tree root
> ERROR: unable to open /dev/sdn2
>=20
>> Thanks,
>> Qu
>=20
> No, thank YOU! :-)
>=20
>>> [root@cornelis ~]# btrfs restore /dev/sdn2 /mnt/data/
>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>> 114173
>>> parent transid verify failed on 46451963543552 wanted 114401 found
>>> 114173
>>> checksum verify failed on 46451963543552 found A8F2A769 wanted
>>> 4C111ADF
>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>> 8B07ABE4
>>> checksum verify failed on 46451963543552 found 32153BE8 wanted
>>> 8B07ABE4
>>> bad tree block 46451963543552, bytenr mismatch,
>>> want=3D46451963543552,
>>> have=3D75208089814272
>>> Couldn't read tree root
>>> Could not open root, trying backup super
>>> warning, device 14 is missing
>>> warning, device 13 is missing
>>> warning, device 12 is missing
>>> warning, device 11 is missing
>>> warning, device 10 is missing
>>> warning, device 9 is missing
>>> warning, device 8 is missing
>>> warning, device 7 is missing
>>> warning, device 6 is missing
>>> warning, device 5 is missing
>>> warning, device 4 is missing
>>> warning, device 3 is missing
>>> warning, device 2 is missing
>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>> bad tree block 22085632, bytenr mismatch, want=3D22085632,
>>> have=3D1147797504
>>> ERROR: cannot read chunk root
>>> Could not open root, trying backup super
>>> warning, device 14 is missing
>>> warning, device 13 is missing
>>> warning, device 12 is missing
>>> warning, device 11 is missing
>>> warning, device 10 is missing
>>> warning, device 9 is missing
>>> warning, device 8 is missing
>>> warning, device 7 is missing
>>> warning, device 6 is missing
>>> warning, device 5 is missing
>>> warning, device 4 is missing
>>> warning, device 3 is missing
>>> warning, device 2 is missing
>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
>>> bad tree block 22085632, bytenr mismatch, want=3D22085632,
>>> have=3D1147797504
>>> ERROR: cannot read chunk root
>>> Could not open root, trying backup super
>>>
>>> [root@cornelis ~]# uname -r
>>> 4.18.16-arch1-1-ARCH
>>>
>>> [root@cornelis ~]# btrfs --version
>>> btrfs-progs v4.19
>>>


--JYWRQAdgSHZS4wAnXvatamsVgs2TgYwHW--

--SJXSyvEUrBk0BIMLj4eR09z5tGYo37qfd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwEelIACgkQwj2R86El
/qhwawf/W5NO1N/l3uFVf8yGMO2W+qiTwGDpe2hEA7Hd1JjQ6h3rrITzou6ghBIO
aoF0OOzm4pKqRZZhJQhZDXxOHYVkZOgh9doMg5GAVTNyFuvEDqHSwmZG3aPHrGb5
NNLMkxtVHV2bLWxvnIHOqx19/SJgivx4vmNq1ydpSkEC0/K4UQ5mWh/gGfp8IBe6
dDmyDvYv2Xl+ulN5tG/BauAWOrMGRe/okwLPevlSxEzbX0o4DptOn2tbyzda3ZoV
ncIjR0SG8lg8vOZLI30YUVYbJEJ3JNn1I6ULjlEsN1QcrK15e5NFbDOxagfKv04r
yc1C+b82jhxJbufLj9FXeojCb02ldw==
=3Q9s
-----END PGP SIGNATURE-----

--SJXSyvEUrBk0BIMLj4eR09z5tGYo37qfd--
