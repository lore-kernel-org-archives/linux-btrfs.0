Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6136DC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D7121A4C
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:27:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzjQmA4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733095AbfBPU07 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 15:26:59 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37882 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbfBPU07 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 15:26:59 -0500
Received: by mail-lf1-f67.google.com with SMTP id n23so9626930lfl.4
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 12:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w7A1ULhi8mYjDUFmeUGSQ0XGjd6I1ZNBCfoIxbwTC0s=;
        b=OzjQmA4H8uROU//SrlLlKT4tC7GR2DnxDtjV9Z5dLgC6Vf/BkrHKysFaLA48uteds1
         k/CN3tt4RpiQ0RVIO2fOnKIC1qO70rjk+vAZnax2UNbW3iw8pzfOgirm01gNOOxgskVv
         Uez4DfwLbzr6le+sMJOv+lVCZyKD7CSNcGNj9SERltWEf2Y3u2toQvuqpiiEM2jHHrwB
         VddF3KEgFIiyjgzRDF7HjEGPLmWEYz5S8cvqUHB1yMIM6ETDTra9FApZiG+So9ib0f6c
         9oGRB3gXlpAw1hsBG05SvbJ/14uz5uDaPEFKVfGqUtUffv6X/4r5EE3McL9D8HBmESMe
         DXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w7A1ULhi8mYjDUFmeUGSQ0XGjd6I1ZNBCfoIxbwTC0s=;
        b=Ki5pgzMyBd+ViFeqn8juSAnHZZLQXJaPGTqkVPJbi95FhkAuMJePyug+6v38R4onV/
         11e845srHksvUPSXUe039AfPLCxgYTnMqQj83LsXXCNV/tHOpGYtbJMTJ5GaDjOyIKlR
         KCVvu/e/YavX4ZtpZ+lqp8i+vun7UXC7pUzSgVA3jsderpxG+pOz6XeWxZzb0A/jzvBY
         MLYpUEaXiXQENIICY6oc2lotymNeSSFUng+4dyJLa1ysKDfaDg256OCzmotnvD36F/vk
         +q4KSbDROAahXT65D8X7EHLLsS0GGVsDXk2/oUclazMaKuCvIQjt/FR2TU4+QsyVShVF
         xF4Q==
X-Gm-Message-State: AHQUAuZuQCnX8lhXh2u1OpO28lkOdS+x5webAUg/BIuAZA57DnwzT564
        A3jcYfDfG4X6iGmjC73vW1dKXLck
X-Google-Smtp-Source: AHgI3IawcQaXrn3BlcNjBjAIvVimF58UhOgCxWx0RPKRWeWueSfdSZ2jQyXn3JrIWkgNtvWHhZcQcw==
X-Received: by 2002:ac2:43aa:: with SMTP id t10mr9916932lfl.107.1550348815834;
        Sat, 16 Feb 2019 12:26:55 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id 15-v6sm2557612lje.18.2019.02.16.12.26.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 12:26:54 -0800 (PST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <1c6a1abb-1e6e-504a-b51c-0da580c49d66@gmail.com>
 <CAJCQCtTO0-WG+mHHvsUdQBJhuQ63dPkBqJP96vz7CU4jGF+hxA@mail.gmail.com>
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
Message-ID: <1cd9e028-931d-0ca3-8ece-710a039c552b@gmail.com>
Date:   Sat, 16 Feb 2019 23:26:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTO0-WG+mHHvsUdQBJhuQ63dPkBqJP96vz7CU4jGF+hxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

15.02.2019 22:11, Chris Murphy пишет:
...
>>>
>>> It doesn't work this way.
>>
>> It works exactly this way.
> 
> Unproven. And in fact we have an example where it does not work, hence
> the point of the thread!
> 
> The proven way it works, is as I've described, and many emails over a
> decade on this list, inferred from the man page, and the step by step
> recipe on the Wiki.
> 

Oh well.

10:~ # mkfs -t btrfs -f /dev/sdb1
btrfs-progs v4.20.1
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               c8dd61f1-bf32-449b-a154-3380cf4348b5
Node size:          16384
Sector size:        4096
Filesystem size:    1023.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              51.12MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1  1023.00MiB  /dev/sdb1

10:~ # mount -t btrfs /dev/sdb1 /mnt
10:~ # cd /mnt
10:/mnt # btrfs su cr A
Create subvolume './A'
10:/mnt # mkdir A/dir
10:/mnt # dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=40K
40960+0 records in
40960+0 records out
41943040 bytes (42 MB, 40 MiB) copied, 0.380302 s, 110 MB/s
10:/mnt # btrfs su sn -r A a1
Create a readonly snapshot of 'A' in './a1'
10:/mnt # cp --reflink=always A/dir/server.jar A/server.jar
10:/mnt # btrfs su sn -r A a2
Create a readonly snapshot of 'A' in './a2'
10:/mnt # btrfs send -p a1 a2 > out
At subvol a2
10:/mnt # ll -sh out
4.0K -rw-r--r-- 1 root root 567 Feb 16 23:15 out
10:/mnt # cd
10:~ # umount /mnt
10:~ # mkfs -t btrfs -f /dev/sdc1
btrfs-progs v4.20.1
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               a2d85827-116a-4dee-874c-d3b180728613
Node size:          16384
Sector size:        4096
Filesystem size:    1023.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              51.12MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1  1023.00MiB  /dev/sdc1

10:~ # mount -t btrfs /dev/sdc1 /mnt
10:~ # cd /mnt
10:/mnt # btrfs su cr A
Create subvolume './A'
10:/mnt # mkdir A/dir
10:/mnt # dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=34625
34625+0 records in
34625+0 records out
35456000 bytes (35 MB, 34 MiB) copied, 0.31223 s, 114 MB/s
10:/mnt # btrfs su sn -r A a1
Create a readonly snapshot of 'A' in './a1'
10:/mnt # cp --reflink=always A/dir/server.jar A/server.jar
10:/mnt # btrfs su sn -r A a2
Create a readonly snapshot of 'A' in './a2'
10:/mnt # btrfs send -p a1 a2 > out
At subvol a2
10:/mnt # ll -sh out
34M -rw-r--r-- 1 root root 34M Feb 16 23:17 out
10:/mnt #


>>> The gist is that you would keep changing A,
>>> and take additional snapshots of A, such as a.1 a.2 a.3, and you can
>>> do incremental send with 'btrfs send -p a.1 a.2' which describes the
>>> difference between those two snapshots of A at their respective
>>> moments in time. You could also do 'btrfs send -p a.2 a.3' or even
>>> 'btrfs send -p a.1 a.3'
>>>
>>
>> That it is intended to be used this way does not mean it is restricted
>> to this way technically. Whether it should have been restricted is
>> another question.
> 
> That's fair. But also the alternative cannot be stated to "work
> exactly this way" when this very thread starts with two examples
> leading to different and therefore unexpected results, differing only
> in how the file was created: dd vs wget
> 

It is not the *only* difference between two examples.

> And no one can explain that. 

I just sent explanation why it happens.

...
>>
>> No. By using "-p" you designate subvolume which must be used as base to
>> apply differential (I explicitly does not use "incremental") stream on
>> remote side. Nothing more. Whether it should have different semantic is
>> subject to discussion, but it does not do what you wish it to do.
> 
> man page and wiki use incremental - and linguistically incremental !=
> differential, increment is a subset of difference.
> 

btrfs send computes differential stream. Whether it will be
"incremental" or not depends on how you are using it.

> Difference suggests the order does not matter. Increment suggests it
> does matter.
> 
> btrfs sub create A
> cp somestuff A
> btrfs sub snap -r A a.1
> cp morestuff A
> btrfs sub snap -r A a.2
> 
> The normal case of send is:
> 
> btrfs send -p a.1 a.2
> 
> However, is it valid to do?
> 
> btrfs send -p a.2 a1
> 

Of course it is. Stream contains differences between the first and the
second stream, where order does matter. "Incremental" implies temporal
ordering between two snapshots which does not exist on "btrfs send"
level and must be ensured by tools that use "btrfs send/receive". There
is no inherent parent/child or temporal relationship implied by "btrfs
send" itself. "btrfs send" *will* compute differences from a.1 to a.2
although a.2 is newer than a.1; it is up to you to ensure you apply this
stream to correct base on destination.
