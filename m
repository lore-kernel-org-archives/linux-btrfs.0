Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2048BC46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 16:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B916C2085B
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 16:50:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9B+cv+6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B916C2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbeJ1BcS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 21:32:18 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33338 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728839AbeJ1BcS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 21:32:18 -0400
Received: by mail-lf1-f46.google.com with SMTP id w16-v6so3147506lfc.0
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2018 09:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieLAXZJ0y3kdh/iUY8FLZobkR5b8K4nSMsiy1B3g46o=;
        b=L9B+cv+60JfLXI2ceafk5FxHWvssKTg5QtybLGALZhRrZjFZpIM/e0pD4rKVUDDHR5
         93udF4CW0sobdM6eMAuLe7eiwLc9Y7GFcjOaRKM1xLLFDwkJEH3F+8iUwat+AfqkaNqp
         xNz+uJssKm/5gYAc8TPpBA5uuDp+cpIgFIt7nQDjxl45opFQntjMl0Z7qsxKORJOzlp6
         A85Rh+bWTrkPTITKrnXxG3DKxMaliOvsRYoaviP4DLCXwzKi9uPiQuB3u6rUuE8Y0a6a
         uZP2TO282Qv9/BlayeVNkdq58E8sS/cRfRGOGNZhxDuKJiu9srBOgIJjSE7x6XqhLLLk
         K0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ieLAXZJ0y3kdh/iUY8FLZobkR5b8K4nSMsiy1B3g46o=;
        b=jNpCPgpaBtJ4z2xO1CkUF6FvXmDyf+4+U4I3LHHhyD4Ge7OtKnZ2iLohvN4mcy02/D
         tJeuVlr9eopVPqSTnPZdKTG886th9RxHXpPh4cgiNZ2p3dbRfMZYxrF/gZS5gVhz5OTK
         /tL/sCjQm74Kc7L2k1b3x7tp73Pah2jJJT6IDemRxjERP1DIbLHq0QYDmOcEhv8SxuTo
         MTxX7Y10HRpHpgRnx5V9HyKrWydY/CjI5ZL/z3Y5QyKHnborpMAS7aFp3MMfhrTn4PWI
         VX/ivEBPR0zN5EBZFxJ878NtiqjlDFo7vx1ya3vOy1DtpB8u/vEPusrdWJus1MspD+XL
         mb8w==
X-Gm-Message-State: AGRZ1gKRO5p7awhEd1B2bqW7yHWhvvNBGyd0xAyGh1sm/tw2PHuNpS2Y
        3Lplbm5dnDhbpXenrGQ4IN8+QpfV
X-Google-Smtp-Source: AJdET5fVB9bVSrMY15j0Aem7aXZJEOiOtwLNsfWvwELpbOLdfvsVI3rXuHcnRLSHSp7t29WINXLULg==
X-Received: by 2002:a19:73d8:: with SMTP id h85mr4565163lfk.69.1540659042138;
        Sat, 27 Oct 2018 09:50:42 -0700 (PDT)
Received: from [192.168.1.4] (109-252-55-124.nat.spd-mgts.ru. [109.252.55.124])
        by smtp.gmail.com with ESMTPSA id 12-v6sm2122423ljj.82.2018.10.27.09.50.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Oct 2018 09:50:41 -0700 (PDT)
Subject: Re: FS_IOC_FIEMAP fe_physical discrepancies on btrfs
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-btrfs@vger.kernel.org
References: <20181027154555.GH16768@wantstofly.org>
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
Message-ID: <c8252c1b-abdb-1278-eec3-6fe0f5f69929@gmail.com>
Date:   Sat, 27 Oct 2018 19:50:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181027154555.GH16768@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

27.10.2018 18:45, Lennert Buytenhek пишет:
> Hello!
> 
> FS_IOC_FIEMAP on btrfs seems to be returning fe_physical values that
> don't always correspond to the actual on-disk data locations.  For some
> files the values match, but e.g. for this file:
> 
> # filefrag -v foo
> Filesystem type is: 9123683e
> File size of foo is 4096 (1 block of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..       0:    5774454..   5774454:      1:             last,eof
> foo: 1 extent found
> #
> 
> The file data is actually on disk not in block 5774454 (0x581c76), but
> in block 6038646 (0x5c2476), an offset of +0x40800.  Is this expected
> behavior?  Googling didn't turn up much, apologies if this is an FAQ. :(
> 
> (This is on 4.18.16-200.fc28.x86_64, the current Fedora 28 kernel.)
> 

My understanding is that it returns logical block address in btrfs
address space. btrfs can span multiple devices so you will need to
convert extent address to (device,offset) pair if necessary.
