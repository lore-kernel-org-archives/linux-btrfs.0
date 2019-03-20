Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7E5C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29A802183E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="bMjhwYhc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfCTGUF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:20:05 -0400
Received: from mout.gmx.net ([212.227.17.20]:33583 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfCTGUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553062798;
        bh=dGEuoq6JfPpgfbCzex+3n37q/UU+/wFvFUZVCUqx+oE=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=bMjhwYhcOTf3kIIrh6gJdcmFdcELy0JgfQCskqIHlH9CDPhZheKbkHYyCM0P7/FEq
         aO2n2cST4a8IoAQrrGCGTop5jxoRtuRYyRi4o3M0y1yYsCRmQDFSDguZzZXHQWMfEo
         Ebl7HbTjAell2+piQSJ071tRPqvZLFEnT60q4dT8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MWTSA-1hVB943ym2-00Xa5I; Wed, 20
 Mar 2019 07:19:57 +0100
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
Message-ID: <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
Date:   Wed, 20 Mar 2019 14:19:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G4ycZPYiioLUWHn7K7n93MNqHrVlQlLDb"
X-Provags-ID: V03:K1:/Ch/Ku5kKcnegj7suhvW2B9K3HZ3m2PPv4AjLek5aVZQiJC6gr4
 rZCJziIRl74AkcNPiV8e9z5ZxaVAfn3nNtNPNI5WDx+NMlNuyda2H/9HdjBHQKBgsDd7i5k
 Tv42i6Z1ECelVbfMWt9HBXZMqt1l3a6eQ3BZyPwouqUWR3DIhlaASSGtbPZJnVunEV8vkaT
 WnW0NEr9M14WpyWtKAmJg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sYVpQJm+4DI=:0Vf6CMHm/69AapTeYj+tF/
 DCcq2mzorlLRUrlt5uo/13PUjPNC0bIsARp1/ZmbgNaxBrffYf1QYqB0UZI/WVIVBuovEJd1u
 jW0LxIUDlMqoIO09GkTIdli4C/ZFWw2d/kUd/bejK9jyPtVE70yYUXKgwOSpGUVNfvxGRVMvL
 P9V2iM3JwB4m8tkrQfqS9TD/FK4qmSxNQC53DpZbYcEcmk6wJJ9u77zTLj3qEUyXfXj+f6B5k
 bsjHhtkx5YlfjgACrlcctEZtn5gTLGlpTHKn8DPJS7h48EjsRhIj1hKZQ2vv4yV7Hg92d6SWG
 ghAo75hsbLY0RoICBNxKkEzkldWY2IDu14B9/x9sGUOXRCe4gxbhiY0vVFTDhxuds8+JiGMcj
 Kj7GE9msQrV4xb5OpHwtkjNtrPMOJKiSU23NTOwFhMYVQOAC3V0XGvoTmi1Gz97n6pYXJHq7v
 pnkzrZ5v53TwSiyEkQy/BQHDYQNNxoaTWQLrfBDw91QYcfaS6GoHKo1HaIhS1yjnCYGw9IUFC
 97nre/HoFDezX2dinBNOOHSjXrqr9oQQ7gHlxYWsaZ3qIDBYsbCyy+98SRnr2VrJxDxhq8e/K
 VOIHAMDNrfmghnTcpCJQKTBU4q7l3NFv8BY44vXYh2LAl287EKt8SceL6QorFxQ5cfIq8pW3+
 P8ntmAQl11sSb9G/EAdGUcjwLR05u3hHFCW+ZjOpx/4USY7ow0Kin6KQhBrkQKah8/q7GGkka
 FZiD+rNkH9sKaaWQ0gVtovNSltevpcxoVoZvL7+oNQU7NwP/0Oa2ID8KFxmNucl4he76dI93w
 ffgIrjZLOAJjtetIRNFxgXfh2eciN98OUUeIo0l8/u1L+HBvu2r3QiBm1Asuvniu58j41eBOl
 DWz0MgBfnDt5bvw16RHmUmdZxYFAAx3XRBbmkj4Otz/QWSG96qhdee0ZOhdwKL
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G4ycZPYiioLUWHn7K7n93MNqHrVlQlLDb
Content-Type: multipart/mixed; boundary="IeIPFSbOHqllQQRX0heVvxi7FqxWIkglg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
In-Reply-To: <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>

--IeIPFSbOHqllQQRX0heVvxi7FqxWIkglg
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

Yes, that's the basis of your patch.
And I totally agree this part, since it's not only transid, but eb's
content is also checked almost bit by bit.

So the idea is OK, for mirror based profile.

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

For the generation part, it's the generation when data is written to disk=
=2E

Truncation/nocow overwrite shouldn't really change the generation of
existing file extents.

So I'm afraid you can't use that generation to do the check.

Thanks,
Qu

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


--IeIPFSbOHqllQQRX0heVvxi7FqxWIkglg--

--G4ycZPYiioLUWHn7K7n93MNqHrVlQlLDb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyR24gACgkQwj2R86El
/qgXCwgAlFF8KdGVayHSfgklXpeAYgub0LVoqyWqRsqWTXu39Q1IlBx1P8AAyfYf
2CxSeD0sdBrgjYpNAA9e2aeH026M5lfTu9NVpruuRdK2Hg5PmEuJpAhExlmiJNF6
FHsnOZF19M63GnhIjdtt1Xc25Ynynb1TfbcoMoZjtqW8k20xu1LUYoFCneNfFfU8
ymsc+K/5AJpltg1J4nVQtYWoXdKH3Ftbp8aPyDVswxcX57QrfNIJXYzgWr7Va4C2
jBPnMsOtjWAsgf6DiaR0vWGYUo4hH4/YLcMrFbQLDqUv62aTlrAeKpS/hzioIHpY
lz2wkvyobAfrow5vtwF/SDgGEUp0hQ==
=c3u3
-----END PGP SIGNATURE-----

--G4ycZPYiioLUWHn7K7n93MNqHrVlQlLDb--
