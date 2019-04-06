Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F5DC282DA
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 23:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091E920896
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 23:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MO2tA0Tj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDFXSm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 19:18:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:44959 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfDFXSm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 19:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554592718;
        bh=B6KcveXKITGCk3FcNGiAjVYtnU1w3JBCRA0GBQ1Vrr8=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=MO2tA0TjbcHx3FKCwpS6sDBMrd7qfqfG47eduHKsCjaXNe9+huCBGSSz3zUyXTFGn
         OLrII8V4xC0h87hIyzwJDotYoaxZ9Awt94ce84x+ygrrU9oZlZN/2A+hGLyODsPXmu
         DEOzSX4mIJkSvpikmOLEKYeWYzbswwUgeU0FrUI8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MQu9K-1hLCpn1QGk-00UNZf; Sun, 07
 Apr 2019 01:18:38 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
Date:   Sun, 7 Apr 2019 07:18:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IBr5dmp7Z629CCciSV2hWK0towvvuG762h5STCDYbRPbqHHdooP
 mK7TvppURwvqg71uQJLEXWpGHKDo9R0Vm5V4vDfhUrkaLkVcJgNufhk+hv5hIso/YKb3OES
 0DTfFUxG9vq++GZWNiWOq4WJsayJ6qw7P+mAjTfjzPLwOWv8alzIgHXGtWcysz4qzW3cD1s
 v9O/8qwLjylTpsyFKaIsA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MI7dT6q/9Mc=:bFuLtbJ2BvVgiJ/gXjLx+3
 SPYL6RqgzE3REtV2QCFI+Is/vOTvbEOnnUqSLDabySMyOTidLeHJngX+1Zle+/w+6sOfQVS8N
 n0pbBjviPgnQeVjPK45HQ1tNppERxo+VvJTYyTt24z2A1olm8K36zejzvUWT7oigMP06H9Gwj
 Dl/0oii9oLbhYC3cxso5xfdkJvOlo28yd+zwuEZfxtnufg5a30bqhfhiUPEtS3ew/koyhhCmz
 9dqXntobK0C/UnaIHiusW5DXO+KNLejrb4oGgfP1stvj8IUXGYGJH8mbxGjph5JLI10zlQdmz
 Z0GmfH530pb1ZpMGWhLhvFV7agl/cXYX2ysx7pygq12LI2US3osrZcjlAwXnTPGaCHO+mOv+Z
 9vv1rAbrw6l9jZAA9FYgM1JZXW73/W/mLbRGs9V+DPXwvhkEbKfKjOWL5uxqMg2VZquzCbaVz
 ByB0NLAVmnFqGhAjKhhu7EkBQEBf0xB952IPO54/rW2SUkrfIjQhXUvgukasnzo6hDbYiEDvr
 MMDhmX78WpRt8q6HhbtLSdKtl7Oj3Pqs5Jocrp7rGz3HhGCfy85P1eNQh6tBQhJuCI1SPhEqC
 OXMRKmmt3Ikh89wXtcYEl4zmzySmqZa9iMgFIBSO+MKWzV1A3S0nGNbkRAWpe4q1VlIfGSTXh
 RbTrPuWyEKuB4FZ2f+IzQymXPf9IPAvI+K/xsk1RLupJVqSmdlpbyGD9jc0ePEKj7MwyuWfmj
 L66bAU0BAzqaxg6pI5YWIpoMX9Lg3+/1HBlLwYq0EaCSIjL3RcdzoWhGhpFOcVbw/9Im/5YK4
 tVji9Td9B5VKJusa+9uDrHvorbJmX+RGC2TQPasv9ir83XL7ZvVXoUTeClL4R6QNqYkDF883B
 n1a7kXaoGNuxeM5TP04Qbs7gth3WOCabTyhpRofgnaDCzm2PkyMus7+ciSkjAql6XN3OUAwmb
 ZhCcytioQMA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/6 =E4=B8=8B=E5=8D=8810:19, Nik. wrote:
>
>
> 2019-04-06 15:22, Qu Wenruo:
>>
>>
>> On 2019/4/6 =E4=B8=8B=E5=8D=889:20, Nik. wrote:
>>>
>>>
>>> 2019-04-06 11:06, Qu Wenruo:
>>>>>>
>>>>>> Please try again, and sorry for the inconvenience. Hopes this is th=
e
>>>>>> last try.
>>>>>
>>>>> #sudo ./btrfs-corrupt-block -X /dev/md0
>>>>> old offset=3D131072 len=3D0
>>>>> new offset=3D0 len=3D0
>>>>
>>>> My bad, the first fix is bad, leading the bad result.
>>>>
>>>> (And that's why we need to review patches)
>>>>
>>>> Fortunately we have everything we need to manually set the value, no
>>>> magic any more.
>>>
>>> So I gues the next steps were git fetch, make and run again the above
>>> two commands:
>>>
>>> #git fetch
>>> =C2=A0From https://github.com/adam900710/btrfs-progs
>>> =C2=A0=C2=A0+ c7bfe8cc...a8c26abd dirty_fix_for_nik -> origin/dirty_fi=
x_for_nik
>>> (forced update)
>>
>> It looks like you haven't checked out to the correct branch.
>>
>> You could use command 'git checkout origin/dirty_fix_for_nik' to change
>> to the latest branch.
>
> Sorry about this. Once again:
>
> #git checkout origin/dirty_fix_for_nik
> HEAD is now at a8c26abd btrfs-progs: corrupt-block: Manually fix bit
> flip for Nik.
> # make
> =C2=A0=C2=A0=C2=A0 [PY]=C2=A0=C2=A0=C2=A0=C2=A0 libbtrfsutil
>
> #./btrfs-corrupt-block -X /dev/md0
> old offset=3D0 len=3D0
> new offset=3D14966 len=3D37
> Successfully repair tree block at 1894009225216
>
> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,
> missing codepage or helper program, or other error.
>
> root@bach:~# dmesg|tail
> ...
> [59138.540585] BTRFS info (device md0): disk space caching is enabled
> [59138.697727] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,
> flush 0, corrupt 2181, gen 0
> [59139.944682] BTRFS critical (device md0): corrupt leaf: root=3D1
> block=3D1894009225216 slot=3D83, bad key order, prev (564984271564800 16=
8
> 962560) current (2034319192064 168 262144)

Now it's a different problem at different slot.

slot 82 has key (0x201d9a6cf7000, 168, 962560)
slot 83 has key (0x001d9a6df7000, 168, 262144)

You have 2 bits flipped just in one tree block!

Anyway, I have updated the branch, and please try it again.

Thanks,
Qu


> [59139.945109] BTRFS error (device md0): failed to read block groups: -5
> [59139.984122] BTRFS error (device md0): open_ctree failed
>
> Kind regards,
> Nik.
> --
>
>> Thanks,
>> Qu
>>
>>> #make
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [PY]=C2=A0=C2=A0=C2=A0=C2=A0 libbtrfsutil
>>>
>>> #./btrfs-corrupt-block -X /dev/md0
>>> old offset=3D0 len=3D0
>>> new offset=3D0 len=3D0
>>> Successfully repair tree block at 1894009225216
>>>
>>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0=
,
>>> missing codepage or helper program, or other error.
>>>
>>> # dmesg|tail
>>> ...
>>> [56146.672395] BTRFS info (device md0): disk space caching is enabled
>>> [56146.841632] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0=
,
>>> flush 0, corrupt 2181, gen 0
>>> [56148.097242] BTRFS critical (device md0): corrupt leaf: root=3D1
>>> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect 15=
003
>>> [56148.097583] BTRFS error (device md0): failed to read block groups: =
-5
>>> [56148.140137] BTRFS error (device md0): open_ctree failed
>>>
>>> If the above steps were wrong - please, correct!
>>>
>>>> The only uncertain part is the size.
>>>> If mount still fails, dmesg will tell me the size I need.
>>>>
>>>>
>>>>> Successfully repair tree block at 1894009225216
>>>>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>>>>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on
>>>>> /dev/md0,
>>>>> missing codepage or helper program, or other error.
>>>>> root@bach:~# dmesg|tail
>>>>> ...
>>>>> [39342.860715] BTRFS info (device md0): disk space caching is enable=
d
>>>>> [39342.933380] BTRFS info (device md0): bdev /dev/md0 errs: wr 0,
>>>>> rd 0,
>>>>> flush 0, corrupt 2181, gen 0
>>>>> [39344.197411] BTRFS critical (device md0): corrupt leaf: root=3D1
>>>>> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect =
15003
>>>>> [39344.197915] BTRFS error (device md0): failed to read block
>>>>> groups: -5
>>>>> [39344.248137] BTRFS error (device md0): open_ctree failed
>>>>>
>>>>> Sorry, I forgot to tell: this and previous attempt were with kernel
>>>>> 4.15.0-47-generic.
>>>>
>>>> As long as it can output above message, the kernel version doesn't ma=
ke
>>>> much difference.
>>>>
>>>>
>>>>> My Ubuntu 18.04 LTS is having enormous problems with
>>>>> Kernel 5.0.2 - very long boot; network, login and other services
>>>>> cycling
>>>>> trough "start, timeout, fail, stop" again and again, etc. If kernel
>>>>> 5 is
>>>>> important I will need time to get it right (maybe even assistance fr=
om
>>>>> another(?) developer group).
>>>>> Actually with 5.0.2 each boot sends me an email about an empty and n=
ot
>>>>> automatically mounted btrfs filesystem with raid1 profile, consistin=
g
>>>>> from two devices (sdb and sdi):
>>>>>
>>>>> kernel: [=C2=A0=C2=A0=C2=A0 9.625619] BTRFS: device fsid
>>>>> 05bd214a-8961-4165-9205-a5089a65b59b devid 2 transid 832 /dev/sdi
>>>>>
>>>>> Scrubbing it finishes almost immediately (see below), but during nex=
t
>>>>> boot the email comes again:
>>>>>
>>>>> #btrfs scrub status /mnt/b
>>>>> scrub status for 05bd214a-8961-4165-9205-a5089a65b59b
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scrub started=
 at Sat Apr=C2=A0 6 10:42:15 2019 and finished after
>>>>> 00:00:00
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total bytes s=
crubbed: 1.51MiB with 0 errors
>>>>>
>>>>> Should I be worried about it?
>>>>
>>>> You could try btrfs check --readonly and see what's going on.
>>>> If btrfs check --readonly is OK, then it should be mostly OK.
>>>
>>> Then it seems to be ok, thank you!
>>>
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>>
>>>>> Kind regards,
>>>>> Nik.
>>>>> --=C2=A0
>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>>
>>>>>>> Thank you.
>>>>>>> Nik.
>>>>>>> --=C2=A0
>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Actually there was one warning during make, I don't know of it i=
s
>>>>>>>>> relevant:
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=
=A0=C2=A0 check/main.o
>>>>>>>>> check/main.c: In function =E2=80=98try_repair_inode=E2=80=99:
>>>>>>>>> check/main.c:2688:5: warning: =E2=80=98ret=E2=80=99 may be used =
uninitialized in
>>>>>>>>> this
>>>>>>>>> function [-Wmaybe-uninitialized]
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret) {
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>>>>>>>> check/main.c:2666:6: note: =E2=80=98ret=E2=80=99 was declared he=
re
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
>>>>>>>>>
>>>>>>>>> The previous steps were as follow (output ommited, since nothing
>>>>>>>>> unexpected happened):
>>>>>>>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>>>>>>>> https://github.com/adam900710/btrfs-progs.git
>>>>>>>>> #cd btrfs-progs/
>>>>>>>>> #./autogen.sh
>>>>>>>>> #./configure --disable-documentation --disable-convert
>>>>>>>>> #make
>>>>>>>>>
>>>>>>>>> Did I got the right branch? Or miss any step?
>>>>>>>>>
>>>>>>>>> Kind regards,
>>>>>>>>> Nik.
>>>>>>>>> --=C2=A0
>>>>>>>>>
>>>>>>>>>> If everything goes correctly, it should output something like:
>>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Successfully repaired tree=
 block at 1894009225216
>>>>>>>>>> (And please ignore any grammar error in my code)
>>>>>>>>>>
>>>>>>>>>> After that, please run a "btrfs check --readonly" to ensure no
>>>>>>>>>> other
>>>>>>>>>> bit
>>>>>>>>>> flip in your fs.
>>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Qu
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Hope this is ok.
>>>>>>>>>>>
>>>>>>>>>>> Regards,
>>>>>>>>>>> Nik.
>>>>>>>>>>> -
>>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>>
