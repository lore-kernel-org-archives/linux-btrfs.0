Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C68C10F06
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 12:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E942D20989
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 12:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CqX9jRGI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfCaMVv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 08:21:51 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:33989 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfCaMVu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 08:21:50 -0400
Received: by mail-lj1-f176.google.com with SMTP id j89so5644305ljb.1;
        Sun, 31 Mar 2019 05:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vb8ji+z2/qKt5D5DeFedtohmqm5g/R2LEzauO++lqbY=;
        b=CqX9jRGIeQByR5reKIxOwGdfbNw5ziaLzNYfhOtkVN9+VPoVLAhm6ZL/ieKEXUM33t
         32kG5JnQzhH0e6NL1WSmUqFdGgeXPmp/9LxsT/TKGB/huu8Phzz/xVpyzGdRo6e8UATj
         4JRalZFnxkvyFv1kPHtyer0SWVkSv6gFJFYHaE11uMllmW6+RT+skYANebdzEwwzfEae
         Y/e932+3ZCJ0oEBGFUYYCz7iQ6f7BZJqefiyP7z9WSvpwTrbcCyWUTuAVWsKgV4DJrxa
         aBnE6vW2j5IHZujlOopgNdvQyFHq9j3ZxxgJsZb6TfSrJBR4uxGBYT/DEB3ywmjjSYdo
         kvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vb8ji+z2/qKt5D5DeFedtohmqm5g/R2LEzauO++lqbY=;
        b=A01HVtoP6y6b8Jc2iYYsdvdxnnXmQOL5brGrSJr8pynbDiSwjkDw7zMVMA2RB4s9gg
         40wZwTtTYLb5PpYG2sYVl/eJHDaPNJz4ZLIbJm1A2poSGCLtMQw66ZhY1t9ciivJuMww
         mj1dPMbL1h86MouIZSK1gNHsvMBOYY2hRnd2oRqKMEAMRQ0AA+0Z6mqVN4yfpHgDpH+s
         FGcD292LO6/ouCUGmOR2BzzD3zMCD9XDXih+sNrX7CWBpnDLQw479cpMyzOQ7Nyynvjg
         Th+c+zxQ/w3P3srNTqaNJ7vUyE1srBC+TT5aZpv1vi1wDZmrGOtZsZT+VYQClf3xlEWX
         sXGw==
X-Gm-Message-State: APjAAAUKDI48bjuxTZX4CHwTRGqx91ebHOgG2Msh9G16AxQo1xBmLL9J
        Nqz2M2cJ5PgubOwDg/h2QA19Lv6Z
X-Google-Smtp-Source: APXvYqym9kULuR1pBcuL6VUA5NG6BL224DK16AEOOTTi3i3ssrylc7TyiCvV8re8RHR+ecSXbG2OuA==
X-Received: by 2002:a2e:a284:: with SMTP id k4mr28744509lja.99.1554034908257;
        Sun, 31 Mar 2019 05:21:48 -0700 (PDT)
Received: from [192.168.1.5] ([109.252.90.193])
        by smtp.gmail.com with ESMTPSA id t28sm1589795lje.9.2019.03.31.05.21.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 Mar 2019 05:21:47 -0700 (PDT)
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Alberto Bursi <alberto.bursi@outlook.it>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
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
Message-ID: <8faff75a-21bb-b21b-b19b-fd5aad002b88@gmail.com>
Date:   Sun, 31 Mar 2019 15:21:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

31.03.2019 14:27, Alberto Bursi пишет:
> 
> On 30/03/19 13:31, Qu Wenruo wrote:
>> Hi,
>>
>> I'm wondering if it's possible that certain physical device doesn't
>> handle flush correctly.
>>
>> E.g. some vendor does some complex logical in their hdd controller to
>> skip certain flush request (but not all, obviously) to improve performance?
>>
>> Do anyone see such reports?
>>
>> And if proves to happened before, how do we users detect such problem?
>>
>> Can we just check the flush time against the write before flush call?
>> E.g. write X random blocks into that device, call fsync() on it, check
>> the execution time. Repeat Y times, and compare the avg/std.
>> And change X to 2X/4X/..., repeat above check.
>>
>> Thanks,
>> Qu
>>
>>
> 
> Afaik HDDs and SSDs do lie to fsync()
> 
> unless the write cache is turned off with hdparm,

I know at least one case of SSD that are claimed to flush cache in case
of power loss. I can dig up details if anyone is interested.

> 
> hdparm -W0 /dev/sda
> 
> similarly to RAID controllers.
> 
> see below
> 
> https://brad.livejournal.com/2116715.html
> 
> https://queue.acm.org/detail.cfm?id=2367378
> 
> 
> -
> 

