Return-Path: <SRS0=OwOL=RT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B56C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 06:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1B9218D0
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 06:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4O0dBAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbfCPGHX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 02:07:23 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:32840 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfCPGHW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 02:07:22 -0400
Received: by mail-lf1-f49.google.com with SMTP id v14so7801881lfi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2019 23:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1+6AtlZauxAjxSKAfLjJvObWPl67R/oqOzFkL9EgTNU=;
        b=e4O0dBAEKui1X3qyccEtxCXSh4dnUPTca8jmrMgoaFUjxioGBHmA4vQM2GDjdPAveA
         HA71aJVvoKiIkLI3Ef08MwJ/cwNrm6DVEQTaRqn2vuoTb28tsS1uwNQtlufQNGan4V26
         s4/OXF2zUCyzxNG5KMyshkFvkm4UOyTZ1M4b8yqQd+S7Nh5TZXFgaPBdj+eGAoAwQmde
         CA3tUrd2SAno6wy2LqIhGq/U2U6oLjuJky0Wr2mTYg92+LTOVPIVnCQWHH8LmVy06+Bb
         yUtvF68RTvnGmg5ErX25R6hZUz+AGho06MckJOUS2ofHZbA7lz7mC+IRQJjZuXRBoKvA
         9tYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1+6AtlZauxAjxSKAfLjJvObWPl67R/oqOzFkL9EgTNU=;
        b=msN3AiFA7BYLbrxT9fd+uwJjvJRCPEJln4jaVep1eC4lzNGyR4wFBajohS8jsGiMIo
         c/4qUuXZTiVbGUVXmCS6+l15AZh5OMDa1/HkOSq7VzmkyT4mPGLjVD7cRkOJNCBlG5Uq
         dns3McZv8FZeVeRY8st0Fxh6JAtnbH9eOMyGQCFDvGSfn4Z8XJL4lgZ4x+ji/yhd1m+n
         YH0ARkFIKCblESLcgnQ+aSM1IBafZJ3mfhnMIr6qP3do4E+KCS6yTQ8fB/BiHxaPPvsL
         jPsMSuIMcczx1e7wsIuJ6J+Awysx6CV1V1mYhbovHGJf7/hS+yezRegXoLdlA2GJqf+B
         Mumw==
X-Gm-Message-State: APjAAAUngUv0f+FFTYLM4sJ0u/AoaMebRjmdxZbUDRg4UR32bj+7Zz29
        FOMfiFItxxo5MLPjaXMuGnRSvcwg39k=
X-Google-Smtp-Source: APXvYqz1oYo9Si0IrmuNy1rwORRhkvnHjIFfzAlvV8yh9L2+2UYORN3yBjh3fC0iTLWH+ga4sGlfKw==
X-Received: by 2002:ac2:4563:: with SMTP id k3mr3687671lfm.101.1552716440062;
        Fri, 15 Mar 2019 23:07:20 -0700 (PDT)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id b15sm837554ljj.70.2019.03.15.23.07.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 23:07:18 -0700 (PDT)
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
To:     Hans van Kranenburg <hans@knorrie.org>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        =?UTF-8?Q?Jakub_Hus=c3=a1k?= <jakub@husak.pro>
Cc:     linux-btrfs@vger.kernel.org
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
 <20190315180123.GJ9995@hungrycats.org>
 <3dce71e1-6caa-59ad-1765-6a29c7dd774f@knorrie.org>
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
Message-ID: <aa4fc47e-2eee-de11-c73f-00d947f96dbf@gmail.com>
Date:   Sat, 16 Mar 2019 09:07:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <3dce71e1-6caa-59ad-1765-6a29c7dd774f@knorrie.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

15.03.2019 23:31, Hans van Kranenburg пишет:
...
>>
>>>> If so, shouldn't it be really balancing (spreading) the data among all
>>>> the drives to use all the IOPS capacity, even when the raid5 redundancy
>>>> constraint is currently satisfied?
>>
>> btrfs divides the disks into chunks first, then spreads the data across
>> the chunks.  The chunk allocation behavior spreads chunks across all the
>> disks.  When you are adding a disk to raid5, you have to redistribute all
>> the old data across all the disks to get balanced IOPS and space usage,
>> hence the full balance requirement.
>>
>> If you don't do a full balance, it will eventually allocate data on
>> all disks, but it will run out of space on sdb, sdc, and sde first,
>> and then be unable to use the remaining 2TB+ on sdd.
> 
> Also, if you have a lot of empty space in the current allocations, btrfs
> balance has the tendency to first start packing everything together
> before allocating new (4 disk wide) block groups.
> 
> This is annoying, because it can result in moving the same data multiple
> times during balance (into empty space of another existing block group,
> and then when that one has its turn again etc).
> > So you want to get rid of empty space in existing block groups as soon
> as possible. btrfs-balance-least-used can do this, (also an example from
> python-btrfs), by doing them in order of most empty one first.
> 

But if I understand the above correctly it will still attempt to move
data in next most empty chunks first. Is there any way to force
allocation of new chunks? Or, better, force usage of chunks with given
stripe width as balance target?

This thread actually made me wonder - is there any guarantee (or even
tentative promise) about RAID stripe width from btrfs at all? Is it
possible that RAID5 degrades to mirror by itself due to unfortunate
space distribution?
