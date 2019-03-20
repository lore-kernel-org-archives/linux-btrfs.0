Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A285C10F05
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F5762184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="e3J5QzFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfCTG1z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:27:55 -0400
Received: from mout.gmx.net ([212.227.17.22]:42677 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfCTG1y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553063267;
        bh=o+pfgLG9p0C1D2MNBT/AXpOd17hnQTAQ+Fjwt9WgI+M=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=e3J5QzFmDohFWI/LuM2LUCJU65rYe1+7lyuBl7ryombu0VPTMRTA7MyhIdDp4d2vN
         YoHuzJtk/aog9ekobxVesVMOBpLh9MQqPOHNSA3CzYxcsN2rFut74oKnT9XocL0dq3
         JmGCWzYePvrNN7ivjTnd124WPW5qieRU+RR5wHgU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LaoMe-1giBUw2ZsO-00kPwO; Wed, 20
 Mar 2019 07:27:47 +0100
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
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
Message-ID: <541e2efd-ae4f-bc06-1d08-46f55208a095@gmx.com>
Date:   Wed, 20 Mar 2019 14:27:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JezoqIzEtKWIdA2JWpE5yzYgz3WuFXq8a"
X-Provags-ID: V03:K1:aiHF1c6CjxR+GtD0kSxJZfxVNPhMM0IN3pJWwxt3E1ZzudZmPpg
 wpnjFfBHZJgN117uoH9pVxBVfYmkDsZXh785Om4nB/5DwZj6c9h0a+GsHJkhFGkHBAHS3Sr
 owYStOrqipAF3dJsxVcogf4DNPrJtzt0lFtcpBkt9Qk4759gkHvAV9v2i2g70uY3rPXaGAR
 rxg/3ab7l5JZ8YAqKd3hg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4mrxroFa3kA=:LCDbvIFXSckelY8x4rWLEy
 8E+ZFIF2NMOG6I5KUMXiaDdsd5sF3cdtsWhdtBjA++3sYiLOlCwsaRv1Yo6NjJkSNpXkLJ18K
 +LraFzKbWtvBogDM9PQkgtkaUbNqqRx4z3ba3/Xub/tWu05zlFyM7a7gUvE03aOf5YgEXjKMA
 O040Ib1L2jF0Q+JAU5kJerQ7ctb1i6oxXyDzYOJK2x1Iyn9D9WcLcYcGvJeeu3NHTq2Ze29F+
 mdp+IeVPnnBHnxVW6hylv9vdNf7jjxPSgg7EsWFVs5Jd2wEcECjzcWhHpea4gKjQTyFY0/4ae
 lHbR3C2qcy59L/KJTYpPZyRz03QOtDklG52iAeFKMhUVhoXnAn94rws/53LYRNr3sE6WjtyLK
 Hn1Dt4o5YGNMy3fas6GnIkSOjpw5rMVBnHBlszaEu6Ykrf9Zn2inZ03IDVPeC4hkPJ/fsVcM6
 0MH3hInZvJ4IqlNWrQoGMKq37ZQPFaf6kPwsKtL/gfFz1FdprPNmOPdu8377O/2NeuY69tw7T
 AOMUn+z2ch3K8w+GbzVi5lpem9EeG210Qs7Up26w7aWrZpsqvVrm1pETwPsPAa9/Ro9oKr9UM
 P/56rS3jqzYHCQ8JX1Xw8x0bTtjjXDCTTsVd8uwRNI2ks3PoxV7GWlXnYHvgQBmy8qblHqph0
 AS5bhIWax80shyr696G1RkbsniwbQxEUnmEOOZeP5i9Hq7dBcj90x8jQxq6Kpp/qeOXstLlb4
 4QDaZIjJZVcd/sZCcsxBbmVP3vhrgfq7u+4rwaTRN3kUltKR3Neq35YPichkOQQS2SboPg7Dy
 whohXBFJVEhZwwZqf42PHbLZl7HHewvABuX12SZbeQDzbyzX7Y1nD/FJhr1OCuJz0QAUn6040
 EznTTDI0xuIf/WJKmHabX+Jbrrmb9JgyKly8tP0sA1ZaGygucYgwF8JkHSZ3ka
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JezoqIzEtKWIdA2JWpE5yzYgz3WuFXq8a
Content-Type: multipart/mixed; boundary="Fwmj289uiGvso4F8HXQelggjaQckZjZ1k";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <541e2efd-ae4f-bc06-1d08-46f55208a095@gmx.com>
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
In-Reply-To: <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>

--Fwmj289uiGvso4F8HXQelggjaQckZjZ1k
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8B=E5=8D=881:47, Anand Jain wrote:
>=20
>=20
>>>>> A tree based integrity verification
>>>>> =C2=A0=C2=A0 is important for all data, which is missing.
>>>>> =C2=A0=C2=A0 =C2=A0 Fix:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 In this RFC patch it proposes to use same =
disk from with the
>>>>> metadata
>>>>> =C2=A0=C2=A0 is read to read the data.
>>>>
>>>> The obvious problem I found is, the idea only works for RAID1/10.
>>>>
>>>> For striped profile it makes no sense, or even have a worse chance t=
o
>>>> get stale data.
>>>>
>>>>
>>>> To me, the idea of using possible better mirror makes some sense, bu=
t
>>>> very profile limited.
>>>
>>> =C2=A0=C2=A0Yep. This problem and fix is only for the mirror based pr=
ofiles
>>> =C2=A0=C2=A0such as raid1/raid10.
>>
>> Then current implementation lacks such check.
>>
>> Further more, data and metadata can lie in different chunks and have
>> different chunk types.
>=20
> =C2=A0Right. Current tests for this RFC were only for raid1.
>=20
> =C2=A0But the final patch can fix that.
>=20
> =C2=A0In fact current patch works for all the cases except for the case=
 of
> =C2=A0replace is running and mix of metadata:raid1 and data:raid56
>=20
> =C2=A0We need some cleanups in mirror_num, basically we need to bring i=
t
> =C2=A0under #define. and handle it accordingly in __btrfs_map_block()


Wait for a minute.

There is a hidden pitfall from the very beginning.

Consider such chunk layout:
Chunk A Type DATA|RAID1
Stripe 1: Dev 1
Stripe 2: Dev 2

Chunk B Type METADATA|RAID1
Stripe 1: Dev 2
Stripe 2: Dev 1

Then when we found stale metadata in chunk B mirror 1, caused by dev 2,
then your patch consider device 2 stale, and try to use mirror num 2 to
read from data chunk.

However in data chunk, mirror num 2 means it's still from device 2, and
we get stale data.

So the eb->mirror_num can still map to bad/stale device, due to the
flexibility provided by btrfs per-chunk mapping.

Thanks,
Qu

>=20
>>>> Another idea I get inspired from the idea is, make it more generic s=
o
>>>> that bad/stale device get a lower priority.
>>>
>>> =C2=A0=C2=A0When it comes to reading junk data, its not about the pri=
ority its
>>> =C2=A0=C2=A0about the eliminating. When the problem is only few block=
s, I am
>>> =C2=A0=C2=A0against making the whole disk as bad.
>>>
>>>> Although it suffers the same problem as I described.
>>>>
>>>> To make the point short, the use case looks very limited.
>>>
>>> =C2=A0=C2=A0It applies to raid1/raid10 with nodatacow (which implies =
nodatasum).
>>> =C2=A0=C2=A0In my understanding that's not rare.
>>>
>>> =C2=A0=C2=A0Any comments on the fix offered here?
>>
>> The implementation part is, is eb->read_mirror reliable?
>>
>> E.g. if the data and the eb are in different chunks, and the stale
>> happens in the chunk of eb but not in the data chunk?
>=20
>=20
> =C2=A0eb and regular data are indeed in different chunks always. But eb=

> =C2=A0can never be stale as there is parent transid which is verified a=
gainst
> =C2=A0the read eb. However we do not have such a check for the data (th=
is is
> =C2=A0the core of the issue here) and so we return the junk data silent=
ly.
>=20
> =C2=A0Also any idea why the generation number for the extent data is no=
t
> =C2=A0incremented [2] when -o nodatacow and notrunc option is used, is =
it
> =C2=A0a bug? the dump-tree is taken with the script as below [1]
> =C2=A0(this corruption is seen with or without generation number is
> =C2=A0being incremented, but as another way to fix for the corruption w=
e can
> =C2=A0verify the inode EXTENT_DATA generation from the same disk from w=
hich
> =C2=A0the data is read).
>=20
> [1]
> =C2=A0umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb && \
> =C2=A0mount -o notreelog,max_inline=3D0,nodatasum /dev/sdb /btrfs && \
> =C2=A0echo 1st write: && \
> =C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=3D4096 co=
unt=3D1
> conv=3Dfsync,notrunc && sync && \
> =C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item"=
 && \
> =C2=A0echo --- && \
> =C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_DATA" &&=
 \
> =C2=A0echo 2nd write: && \
> =C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=3D4096 co=
unt=3D1
> conv=3Dfsync,notrunc && sync && \
> =C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) item"=
 && \
> =C2=A0echo --- && \
> =C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_DATA"
>=20
>=20
> 1st write:
> =C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 15881 ite=
msize 160
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid 6 size =
4096 nbytes 4096
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 100644 li=
nks 1 uid 0 gid 0 rdev 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 1 flags 0x3(NODATAS=
UM|NODATACOW)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.163985452 (=
2019-03-20 13:07:40)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.163985452 (=
2019-03-20 13:07:40)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.163985452 (=
2019-03-20 13:07:40)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.163985452 (=
2019-03-20 13:07:40)
> ---
> =C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff 15813 it=
emsize 53
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 (regular=
)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byte 136314=
88 nr 4096
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0 nr 4096=
 ram 4096
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0 (none)
> 2nd write:
> =C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 15881 ite=
msize 160
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid 7 size =
4096 nbytes 4096
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 100644 li=
nks 1 uid 0 gid 0 rdev 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 2 flags 0x3(NODATAS=
UM|NODATACOW)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.163985452 (=
2019-03-20 13:07:40)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.189985450 (=
2019-03-20 13:07:40)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.189985450 (=
2019-03-20 13:07:40)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.163985452 (=
2019-03-20 13:07:40)
> ---
> =C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff 15813 it=
emsize 53
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 (regular=
)=C2=A0=C2=A0 <----- [2]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byte 136314=
88 nr 4096
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0 nr 4096=
 ram 4096
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0 (none)
>=20
>=20
> Thanks, Anand


--Fwmj289uiGvso4F8HXQelggjaQckZjZ1k--

--JezoqIzEtKWIdA2JWpE5yzYgz3WuFXq8a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyR3V8ACgkQwj2R86El
/qinOQgAkglnx6geW0+u6ghzmL4RAd4Oo0SHbzlbdLHvZ5k8P0lEQk2c1W7pAJWp
JpbRaCy4LoCvHm/9wwFfE2ELzD8Dj3TyeEqErcDVHIlFGOASxxqeSSEFuL5l9Y4J
OSY91z2biAtsSO0wHlmugFG5xHKaiBSv6KmqIUxZ8yK+R3UgIZcM5q2CzeyKTpdS
GNCGpZcu3fHhZ2HAf7V+AwfrRRTfUSDD/ENAn7wfeKJRInHpm4gLG6rblfG0XKWL
Ib5AxKkzRfqnGmJTGmP2PBd0D3gq3J3yImbtjtT0Pyk4GUlZ8mD617gnOE+liznc
fBMMfdLyIUnTLRCPhsCsdKRsIFSdvw==
=t0UP
-----END PGP SIGNATURE-----

--JezoqIzEtKWIdA2JWpE5yzYgz3WuFXq8a--
