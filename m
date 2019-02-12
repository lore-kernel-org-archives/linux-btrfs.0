Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE54C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 381A8222C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rUS2aN+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbfBLS63 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:58:29 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46397 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfBLS62 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 13:58:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id v16so3145630ljg.13
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 10:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=cp8WdWkaP+/Y/LhFVr/oUPTQGekF3i1RE2sA9sdZgiw=;
        b=rUS2aN+ASb7xkAwmSLSbybRLzYq+7qYo+OBM5tanyfmtnHKy75JAcpeOsdGFjglOvZ
         Ej0ov3gAcF7Pglsz0zunI1mYsVdk9b0Yy3fv23Jk4HC/Lkn9VCFZhjMZgzIDalASyNBa
         fYJHlwXRZnPkxVpgglqUsiT9g9J6o4RjrbnCxZ23HFEHYntZgPNGelr6ylPKjk/E0x/w
         JLVj8dTbDJG7ocJY4LlF449VX0Nzzj0ahmCb7vUCSM1ymfNSmMR0veftcUs/G8GCgdhS
         2xBYKe+tWsbdLbT942mqumnGlKKAntjxVZT36xbttv05IGpCrwMlW12YIPDklnJOtSly
         FKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=cp8WdWkaP+/Y/LhFVr/oUPTQGekF3i1RE2sA9sdZgiw=;
        b=NuazNla2CYHa+7wLvCGwJCCCUhnk+qTiCxG1bml6levIuYg5Tumje8dZ9P4PR7Kx9/
         Mxzl/hHS14u9OEVBMtq6Xa1NbajvVhxvt4SgARiPqzNnb9yybyeHfru3ebG16u+ZF7NK
         BgIhM1vPjkFqnA0d1IkUe/5lmMuMYDyLLycPr52OjfJgZeS+WZ+5NCfgPineiOzVut3V
         GjpOZ9G4ZJBMjMTRmnRp+ePdNe5b4j/jEPPtl7RyqrrjXJoukzO/p+I8K25BPryL/nW+
         FqY6MbgG7QWslv22Q1qhEWmHEhMd5MBmnS4h3P8hnK4G6p6SM20ospWwGNR1RD5yy642
         AVGQ==
X-Gm-Message-State: AHQUAuZ0aZzCv9YOj3K4rOAW+XuD2kvutTmcZojKFCDksQEPSzHPrMCX
        bNqCz6msOiREc4fxvQBLKT2sKZxUouQ=
X-Google-Smtp-Source: AHgI3Iak38rImM3htfwiV7Zzp96nJbM+5ZS28fpK8aXzb4AtTuqOnUUiqKwpx5TMBRBUc9MaLrN8Gw==
X-Received: by 2002:a2e:9a16:: with SMTP id o22-v6mr3286746lji.112.1549997905173;
        Tue, 12 Feb 2019 10:58:25 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id d25sm1200498lji.9.2019.02.12.10.58.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 10:58:24 -0800 (PST)
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Filipe Manana <fdmanana@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBDxiRwwRBAC3CN9wdwpVEqUGmSoqF8tWVIT4P/bLCSZLkinSZ2drsblKpdG7x+guxwts
 +LgI8qjf/q5Lah1TwOqzDvjHYJ1wbBauxZ03nDzSLUhD4Ms1IsqlIwyTLumQs4vcQdvLxjFs
 G70aDglgUSBogtaIEsiYZXl4X0j3L9fVstuz4/wXtwCg1cN/yv/eBC0tkcM1nsJXQrC5Ay8D
 /1aA5qPticLBpmEBxqkf0EMHuzyrFlqVw1tUjZ+Ep2LMlem8malPvfdZKEZ71W1a/XbRn8FE
 SOp0tUa5GwdoDXgEp1CJUn+WLurR0KPDf01E4j/PHHAoABgrqcOTcIVoNpv2gNiBySVsNGzF
 XTeY/Yd6vQclkqjBYONGN3r9R8bWA/0Y1j4XK61qjowRk3Iy8sBggM3PmmNRUJYgroerpcAr
 2byz6wTsb3U7OzUZ1Llgisk5Qum0RN77m3I37FXlIhCmSEY7KZVzGNW3blugLHcfw/HuCB7R
 1w5qiLWKK6eCQHL+BZwiU8hX3dtTq9d7WhRW5nsVPEaPqudQfMSi/Ux1kc0mQW5kcmVpIEJv
 cnplbmtvdiA8YXJ2aWRqYWFyQGdtYWlsLmNvbT7CZQQTEQIAJQIbAwYLCQgHAwIGFQgCCQoL
 BBYCAwECHgECF4AFAliWAiQCGQEACgkQR6LMutpd94wFGwCeNuQnMDxve/Fo3EvYIkAOn+zE
 21cAnRCQTXd1hTgcRHfpArEd/Rcb5+SczsBNBDxiRyQQBACQtME33UHfFOCApLki4kLFrIw1
 5A5asua10jm5It+hxzI9jDR9/bNEKDTKSciHnM7aRUggLwTt+6CXkMy8an+tVqGL/MvDc4/R
 KKlZxj39xP7wVXdt8y1ciY4ZqqZf3tmmSN9DlLcZJIOT82DaJZuvr7UJ7rLzBFbAUh4yRKaN
 nwADBwQAjNvMr/KBcGsV/UvxZSm/mdpvUPtcw9qmbxCrqFQoB6TmoZ7F6wp/rL3TkQ5UElPR
 gsG12+Dk9GgRhnnxTHCFgN1qTiZNX4YIFpNrd0au3W/Xko79L0c4/49ten5OrFI/psx53fhY
 vLYfkJnc62h8hiNeM6kqYa/x0BEddu92ZG7CRgQYEQIABgUCPGJHJAAKCRBHosy62l33jMhd
 AJ48P7WDvKLQQ5MKnn2D/TI337uA/gCgn5mnvm4SBctbhaSBgckRmgSxfwQ=
Message-ID: <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
Date:   Tue, 12 Feb 2019 21:58:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190212165916.GA23918@hungrycats.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="cjIJjGUFkiW9PqrwHFVlgYAlZIIOIzPDk"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cjIJjGUFkiW9PqrwHFVlgYAlZIIOIzPDk
Content-Type: multipart/mixed; boundary="T0vWXCs7NOkvgcrxxemuGSlclTP9OR8A8";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
 Filipe Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
In-Reply-To: <20190212165916.GA23918@hungrycats.org>

--T0vWXCs7NOkvgcrxxemuGSlclTP9OR8A8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

12.02.2019 20:01, Zygo Blaxell =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Tue, Feb 12, 2019 at 03:35:37PM +0000, Filipe Manana wrote:
>> On Tue, Feb 12, 2019 at 3:11 AM Zygo Blaxell
>> <ce3g8jdj@umail.furryterror.org> wrote:
>>>
>>> Still reproducible on 4.20.7.
>>
>> I tried your reproducer when you first reported it, on different
>> machines with different kernel versions.
>=20
> That would have been useful to know last August...  :-/
>=20
>> Never managed to reproduce it, nor see anything obviously wrong in
>> relevant code paths.
>=20
> I built a fresh VM running Debian stretch and
> reproduced the issue immediately.  Mount options are
> "rw,noatime,compress=3Dzlib,space_cache,subvolid=3D5,subvol=3D/".  Kern=
el is
> Debian's "4.9.0-8-amd64" but the bug is old enough that kernel version
> probably doesn't matter.
>=20
> I don't have any configuration that can't reproduce this issue, so I do=
n't
> know how to help you.  I've tested AMD and Intel CPUs, VM, baremetal,
> hardware ranging in age from 0 to 9 years.  Locally built kernels from
> 4.1 to 4.20 and the stock Debian kernel (4.9).  SSDs and spinning rust.=

> All of these reproduce the issue immediately--wrong sha1sum appears in
> the first 10 loops.
>=20
> What is your test environment?  I can try that here.
>=20
>>>
>>> The behavior is slightly different on current kernels (4.20.7, 4.14.9=
6)
>>> which makes the problem a bit more difficult to detect.
>>>
>>>         # repro-hole-corruption-test
>>>         i: 91, status: 0, bytes_deduped: 131072
>>>         i: 92, status: 0, bytes_deduped: 131072
>>>         i: 93, status: 0, bytes_deduped: 131072
>>>         i: 94, status: 0, bytes_deduped: 131072
>>>         i: 95, status: 0, bytes_deduped: 131072
>>>         i: 96, status: 0, bytes_deduped: 131072
>>>         i: 97, status: 0, bytes_deduped: 131072
>>>         i: 98, status: 0, bytes_deduped: 131072
>>>         i: 99, status: 0, bytes_deduped: 131072
>>>         13107200 total bytes deduped in this operation
>>>         am: 4.8 MiB (4964352 bytes) converted to sparse holes.
>>>         94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>


I get the same result on Ubunut 18.04 using distro packages and 4.18 hwe
kernel.

root@bor-Latitude-E5450:/var/tmp# dd if=3D/dev/zero of=3Dloop bs=3D1M cou=
nt=3D200
200+0 =D0=B7=D0=B0=D0=BF=D0=B8=D1=81=D0=B5=D0=B9 =D0=BF=D0=BE=D0=BB=D1=83=
=D1=87=D0=B5=D0=BD=D0=BE
200+0 =D0=B7=D0=B0=D0=BF=D0=B8=D1=81=D0=B5=D0=B9 =D0=BE=D1=82=D0=BF=D1=80=
=D0=B0=D0=B2=D0=BB=D0=B5=D0=BD=D0=BE
209715200 bytes (210 MB, 200 MiB) copied, 0,125205 s, 1,7 GB/s
root@bor-Latitude-E5450:/var/tmp# mkfs.btrfs loop
btrfs-progs v4.15.1
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               b1f1111e-2d65-484a-9ab3-e00feaac2048
Node size:          16384
Sector size:        4096
Filesystem size:    200.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              32.00MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   200.00MiB  loop

root@bor-Latitude-E5450:/var/tmp# mount -t btrfs -o
loop,rw,noatime,compress=3Dzlib,space_cache,subvolid=3D5,subvol=3D/ ./loo=
p
=2E/loopmnt
root@bor-Latitude-E5450:/var/tmp# cd -
/var/tmp/loopmnt
root@bor-Latitude-E5450:/var/tmp/loopmnt# ../repro-hole-corruption-test
i: 91, status: 0, bytes_deduped: 131072
i: 92, status: 0, bytes_deduped: 131072
i: 93, status: 0, bytes_deduped: 131072
i: 94, status: 0, bytes_deduped: 131072
i: 95, status: 0, bytes_deduped: 131072
i: 96, status: 0, bytes_deduped: 131072
i: 97, status: 0, bytes_deduped: 131072
i: 98, status: 0, bytes_deduped: 131072
i: 99, status: 0, bytes_deduped: 131072
13107200 total bytes deduped in this operation
am: 4,8 MiB (4964352 bytes) converted to sparse holes.
94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
^Croot@bor-Latitude-E5450:/var/tmp/loopmnt#


>>> The sha1sum seems stable after the first drop_caches--until a second
>>> process tries to read the test file:
>>>
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>         # cat am > /dev/null              (in another shell)
>>>         19294e695272c42edb89ceee24bb08c13473140a am
>>>         6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>
>>> On Wed, Aug 22, 2018 at 11:11:25PM -0400, Zygo Blaxell wrote:
>>>> This is a repro script for a btrfs bug that causes corrupted data re=
ads
>>>> when reading a mix of compressed extents and holes.  The bug is
>>>> reproducible on at least kernels v4.1..v4.18.
>>>>
>>>> Some more observations and background follow, but first here is the
>>>> script and some sample output:
>>>>
>>>>       root@rescue:/test# cat repro-hole-corruption-test
>>>>       #!/bin/bash
>>>>
>>>>       # Write a 4096 byte block of something
>>>>       block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
>>>>
>>>>       # Here is some test data with holes in it:
>>>>       for y in $(seq 0 100); do
>>>>               for x in 0 1; do
>>>>                       block 0;
>>>>                       block 21;
>>>>                       block 0;
>>>>                       block 22;
>>>>                       block 0;
>>>>                       block 0;
>>>>                       block 43;
>>>>                       block 44;
>>>>                       block 0;
>>>>                       block 0;
>>>>                       block 61;
>>>>                       block 62;
>>>>                       block 63;
>>>>                       block 64;
>>>>                       block 65;
>>>>                       block 66;
>>>>               done
>>>>       done > am
>>>>       sync
>>>>
>>>>       # Now replace those 101 distinct extents with 101 references t=
o the first extent
>>>>       btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am $=
((x * 131072)); done) 2>&1 | tail
>>>>
>>>>       # Punch holes into the extent refs
>>>>       fallocate -v -d am
>>>>
>>>>       # Do some other stuff on the machine while this runs, and watc=
h the sha1sums change!
>>>>       while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1,=
2,3}; sleep 1; done
>>>>
>>>>       root@rescue:/test# ./repro-hole-corruption-test
>>>>       i: 91, status: 0, bytes_deduped: 131072
>>>>       i: 92, status: 0, bytes_deduped: 131072
>>>>       i: 93, status: 0, bytes_deduped: 131072
>>>>       i: 94, status: 0, bytes_deduped: 131072
>>>>       i: 95, status: 0, bytes_deduped: 131072
>>>>       i: 96, status: 0, bytes_deduped: 131072
>>>>       i: 97, status: 0, bytes_deduped: 131072
>>>>       i: 98, status: 0, bytes_deduped: 131072
>>>>       i: 99, status: 0, bytes_deduped: 131072
>>>>       13107200 total bytes deduped in this operation
>>>>       am: 4.8 MiB (4964352 bytes) converted to sparse holes.
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       072a152355788c767b97e4e4c0e4567720988b84 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       bf00d862c6ad436a1be2be606a8ab88d22166b89 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       0d44cdf030fb149e103cfdc164da3da2b7474c17 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       60831f0e7ffe4b49722612c18685c09f4583b1df am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       a19662b294a3ccdf35dbb18fdd72c62018526d7d am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>>>       ^C
>>>>
>>>> Corruption occurs most often when there is a sequence like this in a=
 file:
>>>>
>>>>       ref 1: hole
>>>>       ref 2: extent A, offset 0
>>>>       ref 3: hole
>>>>       ref 4: extent A, offset 8192
>>>>
>>>> This scenario typically arises due to hole-punching or deduplication=
=2E
>>>> Hole-punching replaces one extent ref with two references to the sam=
e
>>>> extent with a hole between them, so:
>>>>
>>>>       ref 1:  extent A, offset 0, length 16384
>>>>
>>>> becomes:
>>>>
>>>>       ref 1:  extent A, offset 0, length 4096
>>>>       ref 2:  hole, length 8192
>>>>       ref 3:  extent A, offset 12288, length 4096
>>>>
>>>> Deduplication replaces two distinct extent refs surrounding a hole w=
ith
>>>> two references to one of the duplicate extents, turning this:
>>>>
>>>>       ref 1:  extent A, offset 0, length 4096
>>>>       ref 2:  hole, length 8192
>>>>       ref 3:  extent B, offset 0, length 4096
>>>>
>>>> into this:
>>>>
>>>>       ref 1:  extent A, offset 0, length 4096
>>>>       ref 2:  hole, length 8192
>>>>       ref 3:  extent A, offset 0, length 4096
>>>>
>>>> Compression is required (zlib, zstd, or lzo) for corruption to occur=
=2E
>>>> I am not able to reproduce the issue with an uncompressed extent nor=

>>>> have I observed any such corruption in the wild.
>>>>
>>>> The presence or absence of the no-holes filesystem feature has no ef=
fect.
>>>>
>>>> Ordinary writes can lead to pairs of extent references to the same e=
xtent
>>>> separated by a reference to a different extent; however, in this cas=
e
>>>> there is data to be read from a real extent, instead of pages that h=
ave
>>>> to be zero filled from a hole.  If ordinary non-hole writes could tr=
igger
>>>> this bug, every page-oriented database engine would be crashing all =
the
>>>> time on btrfs with compression enabled, and it's unlikely that would=
 not
>>>> have been noticed between 2015 and now.  An ordinary write that spli=
ts
>>>> an extent ref would look like this:
>>>>
>>>>       ref 1:  extent A, offset 0, length 4096
>>>>       ref 2:  extent C, offset 0, length 8192
>>>>       ref 3:  extent A, offset 12288, length 4096
>>>>
>>>> Sparse writes can lead to pairs of extent references surrounding a h=
ole;
>>>> however, in this case the extent references will point to different
>>>> extents, avoiding the bug.  If a sparse write could trigger the bug,=

>>>> the rsync -S option and qemu/kvm 'raw' disk image files (among many
>>>> other tools that produce sparse files) would be unusable, and it's
>>>> unlikely that would not have been noticed between 2015 and now eithe=
r.
>>>> Sparse writes look like this:
>>>>
>>>>       ref 1:  extent A, offset 0, length 4096
>>>>       ref 2:  hole, length 8192
>>>>       ref 3:  extent B, offset 0, length 4096
>>>>
>>>> The pattern or timing of read() calls seems to be relevant.  It is v=
ery
>>>> hard to see the corruption when reading files with 'hd', but 'cat | =
hd'
>>>> will see the corruption just fine.  Similar problems exist with 'cmp=
'
>>>> but not 'sha1sum'.  Two processes reading the same file at the same =
time
>>>> seem to trigger the corruption very frequently.
>>>>
>>>> Some patterns of holes and data produce corruption faster than other=
s.
>>>> The pattern generated by the script above is based on instances of
>>>> corruption I've found in the wild, and has a much better repro rate =
than
>>>> random holes.
>>>>
>>>> The corruption occurs during reads, after csum verification and befo=
re
>>>> decompression, so btrfs detects no csum failures.  The data on disk
>>>> seems to be OK and could be read correctly once the kernel bug is fi=
xed.
>>>> Repeated reads do eventually return correct data, but there is no wa=
y
>>>> for userspace to distinguish between corrupt and correct data reliab=
ly.
>>>>
>>>> The corrupted data is usually data replaced by a hole or a copy of o=
ther
>>>> blocks in the same extent.
>>>>
>>>> The behavior is similar to some earlier bugs related to holes and
>>>> Compressed data in btrfs, but it's new and not fixed yet--hence,
>>>> "2018 edition."
>>>
>>>
>>
>>
>> --=20
>> Filipe David Manana,
>>
>> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 y=
ou're right.=E2=80=9D
>>



--T0vWXCs7NOkvgcrxxemuGSlclTP9OR8A8--

--cjIJjGUFkiW9PqrwHFVlgYAlZIIOIzPDk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTsPDUXSW5c6iqbJulHosy62l33jAUCXGMXTgAKCRBHosy62l33
jE2kAKCiMhrswVC6BpHZa49WhqMYlrQhcwCeK3sT6bESfYT+ul1wyFCTWKYEqyQ=
=UICd
-----END PGP SIGNATURE-----

--cjIJjGUFkiW9PqrwHFVlgYAlZIIOIzPDk--
