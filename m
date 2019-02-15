Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA7BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 17:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F81121927
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 17:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szPwJ+JM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfBORp5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 12:45:57 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:35758 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfBORp5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 12:45:57 -0500
Received: by mail-lj1-f176.google.com with SMTP id j13-v6so9106492ljc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 09:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7T4FkPL2nb7dRLsfTVI8SInUfd5yU6Upcieyj2eCVF0=;
        b=szPwJ+JMfVTAYIaHL6Pjkcg5DGK8OzgTFdNNSdB9xL771ORcHyocWnvdXC1/+tiF9C
         0oy+JZfTV++O9MpUArirQbz3c/jEWnYvbW+eAc/9r9qRWPZN7aIXmSJQl+mOlhUT0aaz
         gxwR8xMdI8DCwXpa58aXW3DyMELzbhKlYSifO6SO6bbcLOly1kDQUAUhXhvpjAgqsUJu
         T9zMx/2nee2qngDVWlrHIwpJQHNSPJgLTlc/MivcAaaeQUfaXNLu671rPhe1EOLUdcYU
         obgiSkSI4DoPGVN7yJJRZyRkDg09ZgYsTDn+zyoPPSFzedXECuaSXyoX3ojPqFfBjfkz
         /niA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7T4FkPL2nb7dRLsfTVI8SInUfd5yU6Upcieyj2eCVF0=;
        b=MGZ/Mb7gvvMZ71qBl9GM2o+uMeLSRDwVvJAIsM612l3D9oni/UVkiCJMrrIm55U+/P
         XjE85NR2AStHhPhwSzEH4bgG/b/8l5jlWNIIh7XvSRyQiCtQdBEyehxvBQUWXc2FJLih
         EShjE6gJ0Z2gak1CAN/2ow3Sc8oTkKFGSeblD3Wq9xwj3E5xQk6qXkhiE4J9r7NCdcov
         0fSjimYvWfrGmTC5ykiIQJs74Da9GjyiYZnGMAH21S65NVAaGETuw/iK9M6R2xEFvz71
         iJ3e5StbzStmqLoyh6QCCytBtEPgT1tB/pWNv5Ug4yTgKvgNFTURusljHrVT6YmuZ06r
         V19A==
X-Gm-Message-State: AHQUAuY+pVAVin+cEmTGgAsXloQITEmOQZ8Gp8vnaCxz/o0InEWDPaUj
        ohFq2X0FJL4ju+LGX+ALCcMLqVLenhM=
X-Google-Smtp-Source: AHgI3IZOgoslTWczlHAyOzbT+Snlzsdn7rWpjPNGzn4ackI2uBVKTJRLanuMaXkwDFzOrYt1w2526A==
X-Received: by 2002:a2e:b1ca:: with SMTP id e10-v6mr6370482lja.16.1550252753914;
        Fri, 15 Feb 2019 09:45:53 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id h85-v6sm1409468ljf.68.2019.02.15.09.45.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 09:45:52 -0800 (PST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
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
Message-ID: <1c6a1abb-1e6e-504a-b51c-0da580c49d66@gmail.com>
Date:   Fri, 15 Feb 2019 20:45:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

15.02.2019 1:37, Chris Murphy пишет:
> On Thu, Feb 14, 2019 at 4:37 AM André Malm <admin@sheepa.org> wrote:
>>
>> Hello,
>>
>> I'm not sure this is the right forum to ask on but I'll try and if its
>> not I do apologize. I have also created a stack overflow question
>> without success (
>> https://stackoverflow.com/questions/54634703/btrfs-send-with-parent-different-size-depending-on-source-of-files
>> ) but ill paste the question here too. Thank you.
>>
>> What i'm trying to achieve is sending only the diff of the parent with
>> btrfs send -p
>>
>> Running this will produce a file 'out' with size 639 bytes, i.e only
>> diff sent.
>>
>> ====================================================
>>
>> btrfs subvolume create A
>> btrfs subvolume create B
>> mkdir A/dir
>>
>> dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=40K
>> cp --reflink=always A/dir/server.jar B/server.jar
>>
>> btrfs subvolume snapshot -r A a
>> btrfs subvolume snapshot -r B b
>> btrfs send -p a b > out
> 
> It doesn't work this way.

It works exactly this way.

> The snapshots a and b are not based on the
> same underlying subvolume.

So what? What prevents you from computing differences between two
subvolumes? That is real question.

> The gist is that you would keep changing A,
> and take additional snapshots of A, such as a.1 a.2 a.3, and you can
> do incremental send with 'btrfs send -p a.1 a.2' which describes the
> difference between those two snapshots of A at their respective
> moments in time. You could also do 'btrfs send -p a.2 a.3' or even
> 'btrfs send -p a.1 a.3'
> 

That it is intended to be used this way does not mean it is restricted
to this way technically. Whether it should have been restricted is
another question.

> But as there's no relationship between snapshots a and b, I consider
> it a bug/missing error handling feature, that btrfs send doesn't fail
> in this case. By using -p you're claiming there is a parent-child
> relationship between a and b, but there plainly isn't.
> 

No. By using "-p" you designate subvolume which must be used as base to
apply differential (I explicitly does not use "incremental") stream on
remote side. Nothing more. Whether it should have different semantic is
subject to discussion, but it does not do what you wish it to do.

> Read this:
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Doing_it_by_hand.2C_step_by_step
> 
> Depending on your use case if you can describe it, might be tolerated
> with some adjustments by using the -c clone option instead.
> 

The only difference is that "-c" in absence of explicit "-p" attempts to
auto-detect the "best" "base" subvolume - but it selects between
subvolumes given with "-c" options so "-c" with single subvolume is
entirely equivalent to "-p".
