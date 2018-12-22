Return-Path: <SRS0=C3Cz=O7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98724C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 18:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F0F820874
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 18:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aX9c+ufJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbeLVSFR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:05:17 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:34843 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730265AbeLVSFR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 13:05:17 -0500
Received: by mail-lj1-f169.google.com with SMTP id x85-v6so7487578ljb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Dec 2018 10:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09EdPCJ2mnPGJ2bgXUYZ/uE+qIO6JRCQ3HWe1XPEDyc=;
        b=aX9c+ufJcXWdv6HXgh8qIhYb9meXyq8/OoNolnv+nHsU7ukVP1TC5NVatno5f/zwwX
         h+bEGkG1kpySrFNC1evj4bVTO9WYZc03aYaTrmjI6XWm/ZvmSziclF6JNsji9U4VWjqn
         xyBuiJY5gIy6OLBD7URgxcHErjLyIwKNNy1Uof6TvdWAm7ENoNduecwqImq0G3egw41T
         zEzdQdi2RZ8yLX7HyrWoviBQJ/bUZMxZNlpj2s99tG1SvM6DfdbWIVB+5FqOaF5j+PO5
         LF9vliaYXfURkTOjGxcLf1KgM38TiWIXbyENWYl558e0O7Md1WC6tZSpnoeNHSw4++v9
         gX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=09EdPCJ2mnPGJ2bgXUYZ/uE+qIO6JRCQ3HWe1XPEDyc=;
        b=eU7583chvYEH5pCVHJi2nZX4ymv/I0YSyJk8lhts1AitydieMWrBds4b9vufAyIF3q
         rwXmMTMTjp1F5WXdTWwUZ+Pur7WT86zlux36LPEYGB9eaWyu3Of9uFqEllRupmPkzf9x
         Jrwu99aO3IiFo83TLJ0hHUsZRvnkJ8l5c6Z9OcmxMCHIN0/d8x0fU3JhgacFnzselhKP
         63ukcGtqdXLb20K5BYGAj5Az7vYNAkcMVLPIAio/T3P6d0Qk+nT85qyXNWh+P2gF9aPN
         NhlfVfkDzDpN4E+6r/SdP7mYqIVwhyX/iSUealwvoib0Ji1KbYMEDbQdg58I77h5KTOW
         9XRQ==
X-Gm-Message-State: AJcUukcHAahOQjmzfsgfNxCUCKA++U/2q+XMkaKlwfRS37emZeu+wBE9
        2Pfa8iasq1vD0ojAKn2Byki/2rNzayU=
X-Google-Smtp-Source: AFSGD/Xzcwz2BhQelOF6WfIrnzSzdY7MloEAS365yUBj9hAXOuxjA9fU3ZnNUVbF7wty4Qh/TYYOVQ==
X-Received: by 2002:a2e:8045:: with SMTP id p5-v6mr2983567ljg.87.1545451660137;
        Fri, 21 Dec 2018 20:07:40 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id s3-v6sm5060950lje.73.2018.12.21.20.07.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Dec 2018 20:07:39 -0800 (PST)
Subject: Re: Defining quota on /home
To:     c.monty@web.de, linux-btrfs@vger.kernel.org
References: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>
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
Message-ID: <cfc09121-778c-b386-c190-eec987f9768e@gmail.com>
Date:   Sat, 22 Dec 2018 07:07:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

21.12.2018 17:22, c.monty@web.de пишет:
> Hi,
>  
> I have defined a quota on home with these steps:
> 1. btrfs quota enable /home
> 2. btrfs qgroup limit 150G /home
>  
> Now I can verify the corresponding setting:
> btrfs qgroup show -reF /home
> WARNING: Qgroup data inconsistent, rescan recommended
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> 0/279         1.79GiB      1.79GiB    150.00GiB         none
> 255/279       1.79GiB      1.79GiB         none         none
>  
> However I don't understand the line with qgroupid 0/279?!?
>  

This is default quota group created automatically for each subvolume. Or
do you mean 255/279?

> I have created another quota earlier for /var/log, and there's no second line in output of btrfs qgroup show:
> btrfs qgroup show -reF /var/log
> WARNING: Qgroup data inconsistent, rescan recommended
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> 0/275        56.52MiB     56.52MiB      5.00GiB         none
>  
> The following subvolumes do exist:
>  btrfs su li /
> ID 257 gen 134 top level 5 path @
> ID 258 gen 36271 top level 257 path @/.snapshots
> ID 259 gen 36312 top level 258 path @/.snapshots/1/snapshot
> ID 260 gen 33772 top level 257 path @/boot/grub2/i386-pc
> ID 261 gen 33772 top level 257 path @/boot/grub2/x86_64-efi
> ID 262 gen 36311 top level 257 path @/opt
> ID 263 gen 33772 top level 257 path @/srv
> ID 264 gen 36312 top level 257 path @/tmp
> ID 265 gen 35961 top level 257 path @/usr/local
> ID 266 gen 36310 top level 257 path @/var/cache
> ID 267 gen 33772 top level 257 path @/var/crash
> ID 268 gen 33772 top level 257 path @/var/lib/libvirt/images
> ID 269 gen 33772 top level 257 path @/var/lib/machines
> ID 270 gen 33772 top level 257 path @/var/lib/mailman
> ID 271 gen 33772 top level 257 path @/var/lib/mariadb
> ID 272 gen 33772 top level 257 path @/var/lib/mysql
> ID 273 gen 33772 top level 257 path @/var/lib/named
> ID 274 gen 33772 top level 257 path @/var/lib/pgsql
> ID 275 gen 36312 top level 257 path @/var/log
> ID 276 gen 33772 top level 257 path @/var/opt
> ID 277 gen 36312 top level 257 path @/var/spool
> ID 278 gen 36309 top level 257 path @/var/tmp
> ID 279 gen 36311 top level 257 path @/home
> ID 280 gen 36311 top level 257 path @/usr/sap
> ID 308 gen 17373 top level 258 path @/.snapshots/19/snapshot
> ID 309 gen 17373 top level 258 path @/.snapshots/20/snapshot
> ID 315 gen 17373 top level 258 path @/.snapshots/25/snapshot
>  
> This is the additional information demanded when asking a support question:
> 
> lvevm117:~ # uname -a
> Linux lvevm117 4.4.162-94.72-default #1 SMP Mon Nov 12 18:57:45 UTC 2018 (9de753f) x86_64 x86_64 x86_64 GNU/Linux
>  
> lvevm117:~ # btrfs --version
> btrfs-progs v4.5.3+20160729
>  
> lvevm117:~ # btrfs fi show
> Label: none  uuid: fbe2e4f1-2ccd-44df-bc35-790c5e019d66
>         Total devices 1 FS bytes used 8.78GiB
>         devid    1 size 198.84GiB used 23.07GiB path /dev/sda3
>  
> lvevm117:~ # btrfs fi df /
> Data, single: total=20.01GiB, used=8.37GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=1.50GiB, used=414.19MiB
> GlobalReserve, single: total=27.38MiB, used=0.00B
>  
>  
> THX
> 

