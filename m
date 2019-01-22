Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45218C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8E421019
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ealILtRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfAVR5X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:57:23 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:41482 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfAVR5W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 12:57:22 -0500
Received: by mail-lf1-f54.google.com with SMTP id c16so18740477lfj.8
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 09:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EGdLBqYUWSiHd9sJj6i5EK3cWoOGWiwqIJhnU0q9+bI=;
        b=ealILtRbEqH1zD6HR0oKNi78kw3KdnVuUp4D0YHByDSqxeKHcap0Sxi69hM4g1G9KN
         dp8/0PNHR3+zk6Bx2hvcIfe3SCeHroV/SKHFqw8XmENEx2f8O3sgqYVrbP5GogXRklUO
         kVS7mYhGOIziMFPJap60IMPSmjhuZvzM8u3t3Th2bVj2pjw3AG8IXpHeQXXB3KR1T6GP
         FOfK7faxbAwn2QOQohgds05NaRIqr5sKwZwfiomyaqwx8Q0YyGDbs6CrxD+fqCpyrtxD
         1gZHHLcVWJ7+yyFF6tjI10TIj5G0F3V5RqDfOaTY27k7Pn8qTBkGgR8ePca/AUGWVUR4
         6i0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EGdLBqYUWSiHd9sJj6i5EK3cWoOGWiwqIJhnU0q9+bI=;
        b=jaVK016c8M+1LGYLivK2sXhN4nPQSJynK16N4gm3sqnz9l5nl0D8fejYUe7QZfzD71
         ax2JTYno77D6sdWhYG4A/RgP7j06KnZGTRzv5btN8/SM36xsoWfYHtuxNtyFM/H4U9df
         akhyizmsZUUo6CW5EV1C4XvNIHEL1GDo03y1DfgNbLa8Wo0L3PJhApA2OBgvm0hbxQap
         HJjc1v5ZFWiEAvLYdLYVU8ICnqGDEzN3VbVA05398+baLExX4ib2bEMtUBqtVwJOIl7z
         NGEyBub7aYgzj66QO+RX9Bw44GDSTm1HcA5H66w3+1cv6H7ZfR0rUGEpbeaq38/qSxs8
         Ibkw==
X-Gm-Message-State: AJcUukfhdo8dLkH2VLQjQZGwLNdkQawvIposrM22l4SH7+ZwTK2SD8sT
        xLz1tjpTrSEFX6Mqu0l9yDWtKeOZ8EY=
X-Google-Smtp-Source: ALg8bN5TrijfnS8HqxWsdEd1BcwGR+CbBK/FqeGjfZuB0EDIvLW+/LvSzwZOnyKpPmCJnvV4TNc47w==
X-Received: by 2002:a19:4345:: with SMTP id m5mr1573398lfj.142.1548179838977;
        Tue, 22 Jan 2019 09:57:18 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id h22-v6sm112495ljg.24.2019.01.22.09.57.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 09:57:17 -0800 (PST)
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Chris Murphy <lists@colorremedies.com>,
        Remi Gauvin <remi@georgianit.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
 <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com>
 <CAJCQCtTeiWKnBM5+7L+1PSqL+4aXLyYeK3A=GEyk6=gr1DUj0w@mail.gmail.com>
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
Message-ID: <72d097cf-e4b9-80bf-556d-422767ee0376@gmail.com>
Date:   Tue, 22 Jan 2019 20:57:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTeiWKnBM5+7L+1PSqL+4aXLyYeK3A=GEyk6=gr1DUj0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

22.01.2019 9:28, Chris Murphy пишет:
> On Mon, Jan 21, 2019 at 11:00 PM Remi Gauvin <remi@georgianit.com> wrote:
>>
>> On 2019-01-21 11:54 p.m., Chris Murphy wrote:
>> #
>>>
>>> I expect the last command to fail because 1.ro1 is not the parent of
>>> 2.ro2. The command completes, and 2.ro2 is on the destination, and at
>>> least in this simple example it contains the expected files. However
>>> 'btrfs show' indicates that the "parent UUID" of 2.ro2 is the "UUID"
>>> of 1.ro1, which is definitely wrong. So it's a legit bug, not just a
>>> cosmetic problem due to lack of error checking.
>>>
>>
>>
>> This is, as far as I understand, exactly how it's *supposed* to work, at
>> least, as documented.  The only relationship needed between a "parent"
>> snapshot, and the snapshot you're sending, is that the parent already
>> exists on the destination.
> 
> I disagree. From the man page:
> 
>        -p <parent>
>            send an incremental stream from parent to subvol
> 
> You have to understand that the send and receive commands is a
> unidirectional stream. The receive command can't talk to the send
> side. It can only pass or fail. So to get the correct incremental send
> stream, the send command must be correctly formed based on specific
> parent child relationship.
> 

"Parent" is too ambiguous in btrfs as it is used to denote completely
independent things. Snapshot parent-child relationship is unrelated to
"parent" as used in "btrfs send".

Subvolume referred to by "btrfs send -p" is used as base to compute
changes against. Nothing more nothing less. There is no implication that
subvolume that is being transferred is snapshot of subvolume referred to
by -p argument. Actually the most common scheme is - you have base
subvolume "base"m you periodically create snapshots from these subvolume
as "btrfs sub snap -r base snap1", "btrfs sub snap -r base snap2" etc
and then do incremental transfer between each snapshots as "btrfs send
-p snap1 snap2" etc. Neither of "snapX" is snapshot of another "snapX".
You have fan-out structure on source and linear structure on destination.

> 
>>  Your example would be completely
>> counter-productive, since there is no data shared between the two, but
>> perfectly legitimate.  1.ro1 is the parent of 2.ro2 because *you
>> explicitly told it to*.
> 
> It's not legitimate, it's a mistake by the user. The actual stream
> ends up being a full send of 2.ro2, rather than an incremental, and
> then on the destination 2.ro2 ends up showing a parent UUID for a
> subvolume that's totally unrelated. It's just not sane.
> 
> 

It is still entirely legal operation. The result will be full
replication stream of 2.ro2 + additional instructions to delete content
of (clone of) 1.ro1 on destination.

"Related" is in the eye of the beholder. Clone subvolume, delete content
of clone, reflink content of another volume into clone. Are original
subvolume and clone related now? Clone still have parent UUID ...
