Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A37C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95B43213F2
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 04:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbeL3Eia (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 23:38:30 -0500
Received: from mout.gmx.net ([212.227.15.19]:59629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbeL3Eia (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 23:38:30 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MIdTM-1gbFwf09vM-002HNh; Sun, 30
 Dec 2018 05:38:26 +0100
Subject: Re: Broken chunk tree - Was: Mount issue, mount /dev/sdc2: can't read
 superblock
To:     =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
 <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
 <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
 <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
 <07b88bad-e1fa-7485-d410-ee261ace321c@metaliza.cz>
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
Message-ID: <c9414ea9-23e7-d361-b78a-bbb4a2546b83@gmx.com>
Date:   Sun, 30 Dec 2018 12:38:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <07b88bad-e1fa-7485-d410-ee261ace321c@metaliza.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0eybpHoPWyvqnykqxnhRjkoraO2qkmuxx"
X-Provags-ID: V03:K1:ZD5YSHKz9nB+fH4L2XOohrqoGnoXtH0/35gndqfis9TAuvkQ2RX
 XXL26Re/s7A3/HVBfJK5axdfvmHrMLSZygWUUnkZoNnSwMZcpBLy9+zzhnJ/5RH9FX9aJh3
 34+9NziqZz8ojxiP7xGZyUm0C3nlWc4KLBpi1mzF/n27RC36jDLzLDQ9UOPDSItlcLKeWr4
 Y58ni5zA6LWo4VfqvQYFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8lDmerzKK/0=:2E8vCMWJdg3sXQG1H2Al1+
 jlJjfu+GoTqbnIMmtwPSQMJap0QPyHtirRzSdvmgIk/qQiIUPE92xqqLttjs/zuqWsgFkbQLE
 2orvKXUJ5rbhrEsw0qr7i7LJbMJnO1kPihPbOkUTgZOXnb++5Nt4M1Vq3vt5G2Wg7emXqR2EN
 rdBPtfGuAsRlrL0lRtDHQC5qZhdCG2E4Sl2kpDoWn8LsT1KjfnHH5Qn89t27gyNxM+P052GQ1
 XRwvfkAvveuIydojKOnKCwjNEAOIqDbkVU6Ps/9bGZHm97HCa0ULyEZikFJ9GM3A6keey1SN7
 oLpbOWXdEqbCDIDyJPdoMNjBmjvd0rBUPUZOZUBJfIdig+0FCiwoaSRG8Y0/Q6Bf2jXldIojE
 bJ1mneTs/qR1G5uC00YPqbRCeesyF5Y/Ts0TqjpeZSIFmup5fgnE5ahztJlVfjewd3z5VW+kD
 VXvMuBTRoHZj6uVOqYvQVjq8D1g0nRJQ63r9S5MyZPVoFJqj7wxImPPZRa3eeyRlAekcUIsac
 DKDidYSGES65+HF+pkZU/QI+wRLZNyI7ToMS9mAol5p0es7FuLcG2K4S9+89x6xuzRR8fnj8H
 +pQU14JSgymaU/tZM+m9OXREPSELpDwa6UKyk+O8efjfOdAr8PTtzO8j0k8d0r3VetzG6Kj1F
 y+kB3PheNOeNH2AIJkigTugCQmpXJZDnwsTmBTq9/IHjmImL4T7VwJ/G+/nEvQgT2jq881B7z
 7gm4BPlzmerNa4R5F5QwTjmYTzXs2y0vEI/6EXZPfd2m5QEJEp8ZhDGt2QtrWKTJ6/dgR9DYp
 NvrBNiptWSYAQ4eKmn25YqppSDg7g7dTzSF6R21LT1/bzQArzYoWwvqGGewUZUALBEet8ByCw
 KD1WdtQnklToAhs3LJqfjTyC+9o8GVVsPv5zClG4CN9s+etdJQMeENdpYu0W0s
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0eybpHoPWyvqnykqxnhRjkoraO2qkmuxx
Content-Type: multipart/mixed; boundary="3YxbBYN23hDvE58yV0nlO3rDujx2Ar7fS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <c9414ea9-23e7-d361-b78a-bbb4a2546b83@gmx.com>
Subject: Re: Broken chunk tree - Was: Mount issue, mount /dev/sdc2: can't read
 superblock
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
 <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
 <682fc519-49c4-8537-bd48-cff246a39092@metaliza.cz>
 <8f59acfd-4d97-86d4-2063-25213e2770d0@gmx.com>
 <07b88bad-e1fa-7485-d410-ee261ace321c@metaliza.cz>
In-Reply-To: <07b88bad-e1fa-7485-d410-ee261ace321c@metaliza.cz>

--3YxbBYN23hDvE58yV0nlO3rDujx2Ar7fS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/30 =E4=B8=8A=E5=8D=888:48, Tom=C3=A1=C5=A1 Metelka wrote:
> Ok, I've got it:-(
>=20
> But just a few questions: I've tried (with btrfs-progs v4.19.1) to
> recover files through btrfs restore -s -m -S -v -i ... and following
> events occurred:
>=20
> 1) Just 1 "hard" error:
> ERROR: cannot map block logical 117058830336 length 1073741824: -2
> Error copying data for /mnt/...
> (file which absence really doesn't pain me:-))

This means one data extent can't be recovered due to missing chunk mappin=
g.

Not impossible for heavily damaged fs, but nothing serious.

>=20
> 2) For 24 files a I got "too much loops" warning (U mean this: "if
> (loops >=3D 0 && loops++ >=3D 1024) { ..."). I've always answered yes b=
ut
> I'm afraid these files are corrupted (at least 2 of them seems corrupte=
d).
>=20
> How much bad is this?

Not sure, but I don't think store is robust enough for such case.
Maybe false alert.

> Does the error mentioned in #1 mean that it's the
> only file which is totally lost?

Not even total lost, as it's just one file extent, maybe other part is OK=
=2E

Thanks,
Qu

> I can live without those 24 + 1 files
> so if #1 and #2 would be the only errors then I could say the recovery
> was successful ... but I'm afraid things aren't such easy:-)
>=20
> Thanks
> M.
>=20
>=20
> =C2=A0 Tom=C3=A1=C5=A1 Metelka
> =C2=A0 Business & IT Analyst
>=20
> =C2=A0 Tel: +420 728 627 252
> =C2=A0 Email: tomas.metelka@metaliza.cz
>=20
>=20
>=20
> On 24. 12. 18 15:19, Qu Wenruo wrote:
>>
>>
>> On 2018/12/24 =E4=B8=8B=E5=8D=889:52, Tom=C3=A1=C5=A1 Metelka wrote:
>>> On 24. 12. 18 14:02, Qu Wenruo wrote:
>>>> btrfs check --readonly output please.
>>>>
>>>> btrfs check --readonly is always the most reliable and detailed outp=
ut
>>>> for any possible recovery.
>>>
>>> This is very weird because it prints only:
>>> ERROR: cannot open file system
>>
>> A new place to enhance ;)
>>
>>>
>>> I've tried also "btrfs check -r 75152310272" but it only says:
>>> parent transid verify failed on 75152310272 wanted 2488742 found 2488=
741
>>> parent transid verify failed on 75152310272 wanted 2488742 found 2488=
741
>>> Ignoring transid failure
>>> ERROR: cannot open file system
>>>
>>> I've tried that because:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0backup 3:
>>> =C2=A0=C2=A0backup_tree_root:=C2=A0=C2=A0=C2=A0 75152310272=C2=A0=C2=A0=
=C2=A0 gen: 2488741 level: 1
>>>
>>>> Also kernel message for the mount failure could help.
>>>
>>> Sorry, my fault, I should start from this point:
>>>
>>> Dec 23 21:59:07 tisc5 kernel: [10319.442615] BTRFS: device fsid
>>> be557007-42c9-4079-be16-568997e94cd9 devid 1 transid 2488742 /dev/loo=
p0
>>> Dec 23 22:00:49 tisc5 kernel: [10421.167028] BTRFS info (device loop0=
):
>>> disk space caching is enabled
>>> Dec 23 22:00:49 tisc5 kernel: [10421.167034] BTRFS info (device loop0=
):
>>> has skinny extents
>>> Dec 23 22:00:50 tisc5 kernel: [10421.807564] BTRFS critical (device
>>> loop0): corrupt node: root=3D1 block=3D75150311424 slot=3D245, invali=
d NULL
>>> node pointer
>> This explains the problem.
>>
>> Your root tree has one node pointer which is not correct.
>> For pointer it should never points to 0.
>>
>> This is pretty weird, at least some corruption pattern I have never se=
en.
>>
>> Since your tree root get corrupted, there isn't much thing we can do,
>> but try to use older tree roots.
>>
>> You could go try all backup roots, starting from the newest backup (wi=
th
>> highest generation), and check the backup root bytenr using:
>> # btrfs check -r <backup root bytenr> <device>
>>
>> To see which one get least error, but normally the chance is near 0.
>>
>>> Dec 23 22:00:50 tisc5 kernel: [10421.807653] BTRFS error (device loop=
0):
>>> failed to read block groups: -5
>>> Dec 23 22:00:50 tisc5 kernel: [10421.877001] BTRFS error (device loop=
0):
>>> open_ctree failed
>>>
>>>
>>> So i tried to do:
>>> 1) btrfs inspect-internal dump-super (with the snippet posted above)
>>> 2) btrfs inspect-internal dump-tree -b 75150311424
>>>
>>> And it showed (header + snippet for items 243-248):
>>> node 75150311424 level 1 items 249 free 244 generation 2488741 owner =
2
>>> fs uuid be557007-42c9-4079-be16-568997e94cd9
>>> chunk uuid dbe69c7e-2d50-4001-af31-148c5475b48b
>>> ...
>>> =C2=A0=C2=A0 key (14799519744 EXTENT_ITEM 4096) block 233423224832 (1=
4247023) gen
>>> 2484894
>>> =C2=A0=C2=A0 key (14811271168 EXTENT_ITEM 135168) block 656310272 (40=
058) gen
>>> 2488049
>>
>>
>>> =C2=A0=C2=A0 key (1505328190277054464 UNKNOWN.4 366981796979539968) b=
lock 0 (0)
>>> gen 0
>>> =C2=A0=C2=A0 key (0 UNKNOWN.0 1419267647995904) block 6468220747776 (=
394788864)
>>> gen
>>> 7786775707648
>>
>> Pretty obviously, these two nodes are garbage.
>> Something corrupted the memory at runtime, and we don't have runtime
>> check against corruption yet.
>>
>> So IMHO, I think the problem is, some kernel code, either btrfs or oth=
er
>> parts, corrupted the memory.
>> And then btrfs fails to detect it, write it back to disk, and finally
>> kernel get its chance to read the tree block from disk and finally
>> caught the problem.
>>
>> I could add such check for node, but normally it needs
>> CONFIG_BTRFS_FS_CHECK_INTEGRITY, so makes no sense for normal user.
>>
>>> =C2=A0=C2=A0 key (12884901888 EXTENT_ITEM 24576) block 816693248 (498=
47) gen
>>> 2484931
>>> =C2=A0=C2=A0 key (14902849536 EXTENT_ITEM 131072) block 75135844352 (=
4585928) gen
>>> 2488739
>>>
>>>
>>> I looked at that numbers quite a while (also in hex) trying to figure=

>>> out what has happened (bit flips (it was on SSD), byte shifts (I
>>> suspected bad CPU also ... because it has died after 2 months from
>>> that)) and tried to guess "correct" values for that items ... but no
>>> idea:-(
>>
>> I'm not that sure, unless you're super lucky (or unlucky in this case)=
,
>> or it will normally get caught by csum first.
>>
>>>
>>> So this why I have asked about that log_root and whether there is a
>>> chance to "log-replay things":-)
>>
>> For your case, definitely not related to log replay.
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>> Thanks
>>> M.
>>


--3YxbBYN23hDvE58yV0nlO3rDujx2Ar7fS--

--0eybpHoPWyvqnykqxnhRjkoraO2qkmuxx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwoS7wACgkQwj2R86El
/qjuhQf+NStN9N+PeFIG/3dhyZhi8/6nociZysHRNXIOwpPwagiIxC+1wfox/3L0
h7ycv/92HLDc7owl8BUiVMTTMO2AcWJ/h2pMAGaHqPtmhMy+hRlJuNjWZ8S6ZQsN
CoFNqH4QhWDRGdzKbnQg8Wlcc2mLv+jSXcfUiBSjuiRf6np8FVKOqnZrPEdywxnZ
Gsvgjq7nBRDYy/hWJFtNbnmEiJWyjgQZGSitYi76gbk0y3NsAXcvM8j17l9y3x+A
UpQnb+CABw9WH1UoFdosOE3qcUPQAKlxcM3nne/WG8YpjoskN0tmblnsPyFafMvq
1yHvXUXTGo7X4MSSv7QX8/oU0Ih3bQ==
=tgvA
-----END PGP SIGNATURE-----

--0eybpHoPWyvqnykqxnhRjkoraO2qkmuxx--
