Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05C8C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 01:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C68520830
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 01:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="PISW4I1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfDCBFA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 21:05:00 -0400
Received: from mout.gmx.net ([212.227.15.19]:60065 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfDCBE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 21:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554253494;
        bh=GugCdjQhuALmvqwTo8Yx6KpJDS7Stp5TBWltgQNBwcM=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=PISW4I1sJxVep+P/18QVmJFuTsZ/SS0ALKIgOIOpTQ70PxZHyidtG2dGxTZzJ0iGh
         5ipgZSNZYM882TYKjbjJ0V76RdU5NvfeiHFeB6ZH5Hp0YiGyMvZsePB+1qhGsfIVv+
         stosQG+sen5J5WfCnrjwld4LzJGo4NpjgFAnoxuM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Me86g-1hZE0w4166-00PsD0; Wed, 03
 Apr 2019 03:04:53 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
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
Message-ID: <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
Date:   Wed, 3 Apr 2019 09:04:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O4E5gESmUvkti9bA6cCR1P9TPSUsz2vQv"
X-Provags-ID: V03:K1:DxXUo4P6enK3JH64SplUDehQlkWuWsPbbH3pgmhN5OpJIxIVFdT
 9PoMnAUtRoWCiBNAXx3GQfU5w0s7VIIAIWkG3M2FTbkfXuhqpURbiJVaqkpt6wZN1AwFmVd
 KD10m3yNV0OsGVaCqUvJzO9Q1e/wL/1sJQxR8v/h6GcyLa1Ew7Yx2M4HEjjFJaLURtbm3y2
 ry1qIp7JpKkQSdQb06Znw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HbnPzA92DJM=:+8hmRXysSpAL/czZ88h2Vg
 46gk4UICOOZyBtlinDhiwxedq0Ty6p9mk5bM4A9l8Re3T+7DcMhv0y9dHKMs6eRGVFTjvAWA/
 MZOH21oU7UxnIp9xfm+3Xs+ZGKEcTHxMtaFkJRU6yn7uQQPLTw3g4Qa59rTJ1HUYMqtG4kQ3L
 c+sEX0pejJ1XJQ9Xy/ok5FvaxQtQxaL7g4uLnQDjRTjHi5VwbosC5FXXYDNENJAIgL7+F9hps
 hYmyI/ZCdSVCM+O1H47KWvtnjR6GFBjHCm82JYlClrwuNC+NaD1Zl6VexUoJNZKy2xCV7wNHY
 snzPP88WDnXB9TP7wRc8Ff9ue2pEb+cEQy158W/3KZ/0heLLpUB7eOGLvm7wDN4vTslhjsdv6
 YHuCgd1bTxRKHE9VT8PVm6U5ZG6ZLleyfzeCLgQ7ricnzsHcbkFdpoibmb67Heqytp58p2YUW
 /cCsEEnZnwJd1EOQyYX/qmbpU2SKl482GfREJWnEpjelvzKm22h5bMS3Y9lW3n57/iee19AyK
 dcgeFEAdkvfwQMWWebAnso56vWTeNaOYw4NSS3VyG202hdh0LuAuLiyk3rdES+ObBXUNwHSxM
 7b5EqnkI9rNnirT0j7epE5N1UP5tCMIk9z61cvW49Yh21XEi3L9rlit+NPmfflbC0Fym5ZN4G
 xm9LufaFRcnvng9Z8Mf0As6MStyOuRRg9Z4+7UW0zSYj+b3NZag6YmuOVYYPzfSAeO/vNqQiM
 qeiZmR1wWXhZQedhkFTA9S5FNPazd+H3QkjF9SbYSP9j7kpTBX90y8YDezdIc78+06J8Hzuyp
 E6CJrGqyFSB42ZpR0JYmgJKNzzmb5z88nJUH7NKE+u1u4kXsJBXmPgefMnnaFLiRGq7wL/uAW
 hYvZzUd1aciv7Zr9CEgiZS268iHQI22h7i8QKn+MmOJhyDVPmZ3VDRDiC6mS97
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O4E5gESmUvkti9bA6cCR1P9TPSUsz2vQv
Content-Type: multipart/mixed; boundary="v9PvAsxmCnLo6gCMch9yRawLarWPyusp9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
In-Reply-To: <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>

--v9PvAsxmCnLo6gCMch9yRawLarWPyusp9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/3 =E4=B8=8A=E5=8D=885:22, Nik. wrote:
>=20
> 2019-04-02 16:12, Qu Wenruo:
>>
>>
>> On 2019/4/2 =E4=B8=8B=E5=8D=889:59, Nik. wrote:
>>>
>>>
>>> 2019-04-02 15:24, Qu Wenruo:
>>>>
>>>>
>>>> On 2019/4/2 =E4=B8=8B=E5=8D=889:06, Nik. wrote:
>>>>>
>>>>> 2019-04-02 02:24, Qu Wenruo:
>>>>>>
>>>>>> On 2019/4/1 =E4=B8=8A=E5=8D=882:44, btrfs@avgustinov.eu wrote:
>>>>>>> Dear all,
>>>>>>>
>>>>>>>
>>>>>>> I am a big fan of btrfs, and I am using it since 2013 - in the
>>>>>>> meantime
>>>>>>> on at least four different computers. During this time, I
>>>>>>> suffered at
>>>>>>> least four bad btrfs-failures leading to unmountable, unreadable =
and
>>>>>>> unrecoverable file system. Since in three of the cases I did not
>>>>>>> manage
>>>>>>> to recover even a single file, I am beginning to lose my
>>>>>>> confidence in
>>>>>>> btrfs: for 35-years working with different computers no other fil=
e
>>>>>>> system was so bad at recovering files!
>>>>>>>
>>>>>>> Considering the importance of btrfs and keeping in mind the
>>>>>>> number of
>>>>>>> similar failures, described in countless forums on the net, I
>>>>>>> have got
>>>>>>> an idea: to donate my last two damaged filesystems for investigat=
ion
>>>>>>> purposes and thus hopefully contribute to the improvement of btrf=
s.
>>>>>>> One
>>>>>>> condition: any recovered personal data (mostly pictures and audio=

>>>>>>> files)
>>>>>>> should remain undisclosed and be deleted.
>>>>>>>
>>>>>>> Should anybody be interested in this - feel free to contact me
>>>>>>> personally (I am not reading the list regularly!), otherwise I am=

>>>>>>> going
>>>>>>> to reformat and reuse both systems in two weeks from today.
>>>>>>>
>>>>>>> Some more info:
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 - The smaller system is 83.6GB, I could =
either send you an
>>>>>>> image of
>>>>>>> this system on an unneeded hard drive or put it into a dedicated
>>>>>>> computer and give you root rights and ssh-access to it (the netwo=
rk
>>>>>>> link
>>>>>>> is 100Mb down, 50Mb up, so it should be acceptable).
>>>>>>
>>>>>> I'm a little more interested in this case, as it's easier to debug=
=2E
>>>>>>
>>>>>> However there is one requirement before debugging.
>>>>>>
>>>>>> *NO* btrfs check --repair/--init-* run at all.
>>>>>> btrfs check --repair is known to cause transid error.
>>>>>
>>>>> unfortunately, this file system was used as testbed and even
>>>>> "btrfs check --repair --check-data-csum --init-csum-tree --init-ext=
ent
>>>>> tree ..." was attempted on it.
>>>>> So I assume you are not interested.
>>>>
>>>> Then the fs can be further corrupted, so I'm not interested.
>>>>
>>>>>
>>>>> On the larger file system only "btrfs check --repair --readonly
>>>>> ..." was
>>>>> attempted (without success; most command executions were
>>>>> documented, so
>>>>> the results can be made available), no writing commands were issued=
=2E
>>>>
>>>> --repair will cause write, unless it even failed to open the
>>>> filesystem.
>>>>
>>>> If that's the case, it would be pretty interesting for me to poking
>>>> around the fs, and obviously, all read-only.
>>>>
>>>>>
>>>>>> And, I'm afraid even with some debugging, the result would be pret=
ty
>>>>>> predictable.
>>>>>
>>>>> I do not need anything from the smaller file system and have
>>>>> (hopefully
>>>>> fresh enough) backups from the bigger one.
>>>>> I would be good enough if it helps to find any bugs, which are
>>>>> still in
>>>>> the code.
>>>>>
>>>>>> It will be 90% transid error.
>>>>>> And if it's tree block from future, then it's something barrier
>>>>>> related.
>>>>>> If it's tree block from the past, then it's some tree block doesn'=
t
>>>>>> reach disk.
>>>>>>
>>>>>> We have being chasing the spectre for a long time, had several
>>>>>> assumption but never pinned it down.
>>>>>
>>>>> IMHO spectre would lead to much bigger loses - at least in my case =
it
>>>>> could have happened all four times, but it did not.
>>>>>
>>>>>> But anyway, more info is always better.
>>>>>>
>>>>>> I'd like to get the ssh access for this smaller image.
>>>>>
>>>>> If you are still interested, please advise how to create the image =
of
>>>>> the file system.
>>>>
>>>> If the larger fs really doesn't get any write (btrfs check --repair
>>>> failed to open the fs, thus have the output "cannot open file system=
"),
>>>> I'm interesting in that one.
>>>
>>> This is excerpt from the terminal log:
>>> "# btrfs check --readonly /dev/md0
>>> incorrect offsets 15003 146075
>>> ERROR: cannot open file system
>>> #"
>>
>> That's great.
>>
>> And to my surprise, this is completely different problem.
>>
>> And I believe, it will be detected by latest write time tree checker
>> patches in next kernel release.
>=20
> Is the next release going to come out in April?

Next release is v5.1, which doesn't contain all my recent tree-checker
enhancement.

So I'm afraid you need to wait for June.

>=20
>> This problem is normally caused by memory bit flip.
>=20
> Well, this system has suffered many power outages (at least 6 since
> 2013), and after each outage I had to run scrub AND nevertheless
> discovered the loss of a couple of files. I can imagine, that the power=

> supply or the mother board of this machine is not (well) designed for
> reliability, but:

Unless the PSU is so unreliable so that the VRM for memory or memory
controller doesn't get needed voltage, power outage is not related to
this case.

> =C2=A0 1) shouldn't the file system be immune to this?

If memory is corrupted, nothing can help, unless you have ECC memory.

> =C2=A0 2) Isn't is too stupid to lose terabytes of information due to a=

> flipped bit?

Depends on where the bit flip is.
If the bit flip happens at super vital tree block, like chunk tree, root
tree, then the whole fs is unable to be mounted.

Although enhanced tree-checker will be able to detect such problem and
abort write before corrupted data reach disk.
So at least with those enhancement, it should not cause such problem at a=
ll.

> The same machine has ext4 and FAT file systems, and they never have had=

> a problem or recovered automatically by means of fsck during the next
> reboot!

Then we should enhance btrfs-progs to detect bit flip.

Thanks,
Qu

>=20
>> This should ring a little alert about the problem.
>>
>> Anyway, v5.2 or v5.3 kernel would be much better to catch such problem=
s.
>=20
> This kernel isn't even scheduled, is it? Well, I am not really in a
> hurry...
>=20
>>>
>>> Btw., since the list does allow _plain_text_only, I wonder how do you=

>>> quote?
>>>
>>>> If not, then no.
>>>>
>>>>> I can imagine that it is preferable to use the
>>>>> original, but in my case it is a (not mounted) partition of a bigge=
r
>>>>> hard drive, and the other partitions are in use. The "btrfs-image"
>>>>> seems
>>>>> inappropriate to me, "dd" will probably screw things up?
>>>>
>>>> Since the fs is too large, I don't think either way is good enough.
>>>>
>>>> So in this case, the best way for me to poke around is to give me a
>>>> caged container with only read access to the larger fs.
>>>
>>> I am afraid that this machine is too weak for using containers on it
>>> (QNAP SS839Pro NAS, Intel Atom, 2GB RAM), and right now I do not have=

>>> other machine, which could accommodate five hard drives. Let me consi=
der
>>> how to organize this or give another idea. One way could be "async ss=
h"
>>> -=C2=A0 a private ssl-chat on one of my servers, so that you can writ=
e your
>>> commands there, I execute them on the machine as soon as I can and pu=
t
>>> the output back into the chat-window? Sounds silly, but could start
>>> immediately, and I have no better idea right now, sorry!
>>
>> Your btrfs check output is already good enough to locate the problem.
>>
>> The next thing would be just to help you recovery that image if that's=

>> what you need.
>=20
> Well, let me say it again: 1) I have a backup, but one is never sure
> which newest files are not in it. 2) It is much more important to be
> sure that the btrfs code is flawless and no other btrfs file system is
> in danger! I can live with some loses, but inability to recover even
> single file is not acceptable!
>=20
>> The purposed idea is not that uncommon. In fact it's just another way =
of
>> "show commands, user execute and report, developer check the output"
>> loop.
>>
>> In your case, you just need latest btrfs-progs and re-run "btrfs check=

>> --readonly" on it.
>=20
> Will try this, but have no time before tomorrow evening.
>=20
>=20
>> If it just shows the same result, meaning I can't get the info about
>> which tree block is corrupted, then you could try to mount it with -o =
ro
>> using *LATEST* kernel.
>=20
> I tried this before with the 4.15.0-46 kernel, it was impossible. Will
> try again with newer ona as soon as possible (in best case tomorrow
> evening); I will post the results.
>=20
>> Latest kernel will report anything wrong pretty vocally, in that case,=

>> dmesg would include the bytenr of corrupted tree block.
>>
>> Then I could craft needed commands to further debug the fs.
>=20
> Ok, I will try to post more info tomorrow about this time.
>=20
> Nik.
> --=20
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Thank you for trying to improve btrfs!
>>>
>>> Nik.
>>>>
>>>> Thanks,
>>>> Qu
>>>
>>> You are not from the 007 - lab, are you? ;-)
>>>
>>>>>
>>>>> Kind regards,
>>>>>
>>>>> Nik.
>>>>
>>


--v9PvAsxmCnLo6gCMch9yRawLarWPyusp9--

--O4E5gESmUvkti9bA6cCR1P9TPSUsz2vQv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlykBqsACgkQwj2R86El
/qiNhAf/XPzdk0WFo5YvgsD4gY0xRKsaakRuPcScHC2jcjDpXYYvjQggKJvozwpJ
uTa5biVLoe5gApJdGU9VVsrHBp8EkrtugDHm9hgB66NZW2TGrpRa0YX09dDN8UpB
yMl8wnUo3Z1nYM+LHeKMDpoqx7ISVRu/RXGtXWS9waroFcPcH1X1Cosu5dCx/fCN
SPHyde2iMFF6KJaTpuZ5EqQRbaDOWf2roPE1NRZkYtaqDMFPhACp1OZFRWepsJf4
zWrB/wAn99Psdb4bW2OpNYu5/vvoBVl/YWa1lJ0Jnd4ocPHbgb2+ND726LxFB2Vl
x8MXa+y/PBWpRgtFPvNL2yxJQJwlFQ==
=Tkbb
-----END PGP SIGNATURE-----

--O4E5gESmUvkti9bA6cCR1P9TPSUsz2vQv--
