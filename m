Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C05C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 04:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A87720818
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 04:51:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKJCYgXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfBHEvJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 23:51:09 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:42513 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfBHEvJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 23:51:09 -0500
Received: by mail-lj1-f177.google.com with SMTP id l15-v6so1850760lja.9
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 20:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dy73i52i0lR2JGx//asIIfdlltjkhQ8UZXdDZrurjpI=;
        b=bKJCYgXCDK0RlHqX/X5i3Lktaw5bw11BE2FOLMb0y9PUPpzo+TfGU9CeCSbJOeR+su
         eAPcejlouFzQOd4VcgLZ+y5pow934rrXaL2iM6mePOErVpWliWHCqGJHUBBxDaZnlMEW
         j+Z27GRlzMlEHEOerrXhKPI4kgwnRsGdOM6wAgewTTVxMgKD5mx+3S+zZ1y+iuvaatnT
         p1BDq2kgX65OenffVz1qziJ2PhVdtbDfYsxG4hZVsis00an2B+E4mFobBSZf4kJUl55r
         pJkK1lvbvFbMdtu4rEJ2tEfeRWrBXib5FrRM9Za/QI09TEdipEIGFvIi1lq5APB+GZYp
         eoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Dy73i52i0lR2JGx//asIIfdlltjkhQ8UZXdDZrurjpI=;
        b=P7l6bDnqT0a4i+jnp2GjnsKrkxmIv3NwR5KNXIRbh5EF3cQkbV47OFrQpKsROlwFAm
         KB3O5UXuSYS3K92K0AlOPu3WxTFYTmeWvqScI6U1S5wMrsRxrNsdExPAWJf7WxMkQnSt
         CxWIbGZo5PgbBPZ5JFI6MDj6W7YUFUzaXiSfHVDCMxrqJ9wA7JcitjFb9o4nBY4+a+Zj
         tCAjP8uzbnRk+dYpEI8gjJqmJoTB7d39l5YU5q2wuLoDAW9hn2Bz6SUvsaZAE5DTvgz8
         d+cawEvwhgnkHa9Icr9qOfWfHHlAqeLH+5wbCO+DoWZNHSYUFNWQf4Y2m8qw0CRz2IDq
         s2Xg==
X-Gm-Message-State: AHQUAuZa/0NJZh9vOvBujj8xz5bNLuYOqN9I8hc1dpbnZlrXsdFRLy2m
        RXd8ONMa/4tuHPSgPTf9/n1SzzqSVSE=
X-Google-Smtp-Source: AHgI3IbGbhIP4oBwfhWqOpnsRPu3B7szRCfdScO6vvCaoDvJkSx6S3iGeNevrOAK8Pit+EWKOK0zDw==
X-Received: by 2002:a2e:b1ca:: with SMTP id e10-v6mr12054114lja.16.1549601467159;
        Thu, 07 Feb 2019 20:51:07 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id 12-v6sm158334ljs.29.2019.02.07.20.51.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 20:51:05 -0800 (PST)
Subject: Re: btrfs as / filesystem in RAID1
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        waxhead@dirtcellar.net, Stefan K <shadow_7@gmx.net>,
        linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
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
Message-ID: <df1bde98-8849-581a-8f96-3a2045fe6274@gmail.com>
Date:   Fri, 8 Feb 2019 07:51:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

07.02.2019 22:39, Austin S. Hemmelgarn пишет:
> The issue with systemd is that if you pass 'degraded' on most systemd
> systems,  and devices are missing when the system tries to mount the
> volume, systemd won't mount it because it doesn't see all the devices.
> It doesn't even _try_ to mount it because it doesn't see all the
> devices.  Changing to degraded by default won't fix this, because it's a
> systemd problem.
> 

Oh no, not again. It was discussed millions of times already - systemd
is using information that btrfs provides.

> The same issue also makes it a serious pain in the arse to recover
> degraded BTRFS volumes on systemd systems, because if the volume is
> supposed to mount normally on that system, systemd will unmount it if it
> doesn't see all the devices, regardless of how it got mounted in the
> first place.
> 

*That* would be systemd issue indeed. If someone can reliably reproduce
it, systemd bug report would certainly be in order.

