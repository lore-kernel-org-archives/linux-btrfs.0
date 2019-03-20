Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C09EC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 14:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E022184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 14:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="acgCEMGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfCTOkU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:40:20 -0400
Received: from mout.gmx.net ([212.227.17.22]:57295 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfCTOkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 10:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553092812;
        bh=nmXQfHkjAtTCEE/fqtn+ALq+SfPFb32mW1btVLDKIkA=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=acgCEMGDdJaAAev444Md47oG6LZzpTJ5hXLxNbyjJ6MIP7DpcCYNhi5gx9O/1Rw9I
         0LlIHAAst7JcEd9Av48widxxTtpVznXzjFZkjyKC3X8vv8aN+Gq2LQkDwyin9XAGPS
         s71kDyXmwSyxQeIPplfTPqoPHtyfPnJ37sPlKUlM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MOOJl-1h3a7a1NmX-005tee; Wed, 20
 Mar 2019 15:40:12 +0100
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
 <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>
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
Message-ID: <0a922843-9223-5771-c6d6-16d1c2ddcc98@gmx.com>
Date:   Wed, 20 Mar 2019 22:40:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GKFwtnvFUZSrOKsWczigEB5uFgFAElozN"
X-Provags-ID: V03:K1:yUwjJDxcp7+ydOtPkGUs+4f9rCWFJDDyHjtk4YtT7p2PcCp4CsX
 G4pyf2x/ALeXs7YMMgO7NGsx9S9OM/PMdL/ElSABVNYytq51e+j7UeFuQ/JDpauGPxEn71s
 TnzCAO1Ud8t/PpNJCuMwIxHlXNbTQGmKNd7uztbi3gedLyfsU75+3aW1dAZ3pWNQgKXUnS3
 FT+RoieThNlMzfNRht/SQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:G+lisYoKiuY=:7NvBPMkBf0kC6rKIslEXTM
 aprYflidXzX2fYbDy7AbXqu9ya2PLHaWVxcl5LEEftaIS0m7XKeB2veb9jNg1qxkh87UjfLPT
 n6lI8zhAbAak53dlcU1gGHmul9T20aQqWPBILH0xQaaGu7U1LsUYg+cgWSVeceBOlGopODxyr
 TfdpwrONbfVcBKwfFyHHzGU/wkcxbAWO300piGpdZCnq7k7ojsu8TezFDwd8SwMBMDE8W8QWv
 8PIkxkbeL6uoFvqyoDf7lcH5OO799Z1AAfek/If4NQQ0xYuIH3u7gnpnBjoO3vQjKMybMZT41
 6kFOS7fWLdxm1fS0NU+/dtOFjMBUcMFGgAR6lfLXV5JITd0WI9otOfgmhG80/461zxxs3W29v
 WaY4knym0X1kLzPx9B6bj7qMq7KzCGfDNmfCdCKyrOtMRY4ZYma0qeKvJlfMWTiEObZvBCFTM
 e1Hv064Bq3Sd/LnIvlPKlJW3DLmEWSKeIISmGJBF/dRf6/qNAdRB+Bj8RG2w6i8FUBDs0iOLi
 hy/uTMMEQX3gs+n8pL695MUP4/3fQ5ELFgCjzz7p4dfLBMyHuUIRA1BFUST5oTDc66yUc/6dK
 vQySHyK8VyA0BX3LKvT5PW/map4ks7J4MLFui11NT0NbXH+j8NqyPYgnQSBjlruexPsNFy2Sr
 PTjI3EfC3f7Nn0q+YNPyyWHL66x0T2N51u3p37kOwcii4POSFt117B/VUsoOesTos8vUcTjV7
 y/sP/jsSqgAvI8gXJht5kEV4KpSRYY0N4EELRDvzUDP1/Ya16iHTBhrrNPUHgvV8l2Bh5rsRU
 EfVCZwIzPujpiwtn0Q9YzlD9gqqm86Q/eifR+Ixek+gmGAIMY0H6vBJh4bSl089ecZ1AdKVm4
 TitD9KUW1UVcUBlhY1h/JXclb6aEQK9I4ubOY0Sno/Gtb/CHHFei7ZJtfNDUE5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GKFwtnvFUZSrOKsWczigEB5uFgFAElozN
Content-Type: multipart/mixed; boundary="suofniQc0Z39jJpBoSN7jQoxTD6vpt7Wx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <0a922843-9223-5771-c6d6-16d1c2ddcc98@gmx.com>
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
 <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>
In-Reply-To: <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>

--suofniQc0Z39jJpBoSN7jQoxTD6vpt7Wx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8B=E5=8D=8810:00, Anand Jain wrote:
>=20
>>> =C2=A0=C2=A0Also any idea why the generation number for the extent da=
ta is not
>>> =C2=A0=C2=A0incremented [2] when -o nodatacow and notrunc option is u=
sed, is it
>>> =C2=A0=C2=A0a bug? the dump-tree is taken with the script as below [1=
]
>>> =C2=A0=C2=A0(this corruption is seen with or without generation numbe=
r is
>>> =C2=A0=C2=A0being incremented, but as another way to fix for the corr=
uption we can
>>> =C2=A0=C2=A0verify the inode EXTENT_DATA generation from the same dis=
k from which
>>> =C2=A0=C2=A0the data is read).
>>
>> For the generation part, it's the generation when data is written to
>> disk.
>>
>> Truncation/nocow overwrite shouldn't really change the generation of
>> existing file extents.
>>
>> So I'm afraid you can't use that generation to do the check.
>=20
> =C2=A0Any idea why it shouldn't change? Albeit there isn't new allocati=
on
> =C2=A0due to nodatacow and notrunc overwrite, but sure data is overwrit=
ten.
> =C2=A0If that's the case then I would guess there will be bug in send r=
eceive
> =C2=A0as well.

I'm not sure about the send part.

On the other hand, if btrfs is going to update the generation of
nodatacow file extent overwrite, it should cause pretty big performance
degradation.

The idea of nodatacow is to skip all the expensive csum, extent
allocation (maybe not that expensive) and the race of subvol tree.

If we're going to update file extents for such case, we're re-introduce
performance impact to users who don't want that impact at all.
I don't believe it's worthy at all.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>> Thanks,
>> Qu
>>
>>>
>>> [1]
>>> =C2=A0=C2=A0umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb =
&& \
>>> =C2=A0=C2=A0mount -o notreelog,max_inline=3D0,nodatasum /dev/sdb /btr=
fs && \
>>> =C2=A0=C2=A0echo 1st write: && \
>>> =C2=A0=C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=3D=
4096 count=3D1
>>> conv=3Dfsync,notrunc && sync && \
>>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0=
\) item" && \
>>> =C2=A0=C2=A0echo --- && \
>>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_=
DATA" && \
>>> =C2=A0=C2=A0echo 2nd write: && \
>>> =C2=A0=C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=3D=
4096 count=3D1
>>> conv=3Dfsync,notrunc && sync && \
>>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0=
\) item" && \
>>> =C2=A0=C2=A0echo --- && \
>>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_=
DATA"
>>>
>>>
>>> 1st write:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 1=
5881 itemsize 160
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid=
 6 size 4096 nbytes 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 1=
00644 links 1 uid 0 gid 0 rdev 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 1 flags 0x3=
(NODATASUM|NODATACOW)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.163=
985452 (2019-03-20 13:07:40)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.163=
985452 (2019-03-20 13:07:40)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.163=
985452 (2019-03-20 13:07:40)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.163=
985452 (2019-03-20 13:07:40)
>>> ---
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff =
15813 itemsize 53
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 =
(regular)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byt=
e 13631488 nr 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0=
 nr 4096 ram 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0=
 (none)
>>> 2nd write:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 1=
5881 itemsize 160
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid=
 7 size 4096 nbytes 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 1=
00644 links 1 uid 0 gid 0 rdev 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 2 flags 0x3=
(NODATASUM|NODATACOW)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.163=
985452 (2019-03-20 13:07:40)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.189=
985450 (2019-03-20 13:07:40)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.189=
985450 (2019-03-20 13:07:40)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.163=
985452 (2019-03-20 13:07:40)
>>> ---
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff =
15813 itemsize 53
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 =
(regular)=C2=A0=C2=A0 <----- [2]
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byt=
e 13631488 nr 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0=
 nr 4096 ram 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0=
 (none)
>>>
>>>
>>> Thanks, Anand
>>


--suofniQc0Z39jJpBoSN7jQoxTD6vpt7Wx--

--GKFwtnvFUZSrOKsWczigEB5uFgFAElozN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlySUMcACgkQwj2R86El
/qjrHgf/TLMjWbmP5OrNQzKQX+DlmQoGhJPFRmJdYYgM0c6izt6bAYxk1TyC2P3r
511kFyTfO3UfQyoxg5fkQcoO5vqvvVKRTko05vI37XkZ2HVZTMwkGUQGKmuN75xJ
HJHu3qk92PwjI+Am6pqfQKLn8mWoyFw+nP3kevil1cXZrgL6G2w+wW3lvULFVbqP
sRjpOX3CVToNBH8PM7AQoT6NqgmWfLc4XTY5gCEhQpVSLL6iWOVUCNtBK9lgHoyA
VKvlQgjFJSj1xBxzzCoUCZKKP7y9Qg/43Ba1UjbuCMbCcKJ3HDeCf4GzpmQBGMe1
kRYTKsqcEDwPioUl8Mht6VnxfUsLuw==
=/G2j
-----END PGP SIGNATURE-----

--GKFwtnvFUZSrOKsWczigEB5uFgFAElozN--
