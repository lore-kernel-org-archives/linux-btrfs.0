Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B9CC43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 20:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 347C120863
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 20:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PI/mLeKA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbfCBU20 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Mar 2019 15:28:26 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:45449 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfCBU20 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2019 15:28:26 -0500
Received: by mail-lf1-f48.google.com with SMTP id f16so837146lfk.12
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Mar 2019 12:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KhhAbfmvEumvG9QS6qn7T9Sl80anipRbPGPSlCD07hI=;
        b=PI/mLeKACj5yD2r19zZvmkclan3teJ92GpMmTw9XxvFUqftwcV3U0tX/954QYKaTgl
         +w8vckQR3KzuAd5joWmW4c6ieT0BGsh1mVxRslt8nOccKo0+0UfMdrZMsFizOghIc7Ti
         wn1C8fYrpb4dpWZ8GjUJCpuxUdpkvMqAB08kUrKvcY3mbYqPqBjiMDm+scS1dwvdSQRQ
         vhYKX4CLQMAA8uIznsKO6vPx6J7llHVlYUvlN4vXz/cYHRZ2W1+O55mmI906Tad6VLma
         ONhKnLK1eMkrdiFRxotIcT/gjTtE6gHEm8qP97QF9ep4y2nS07DJZRfTB/sK3d9ZVVjn
         8SUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KhhAbfmvEumvG9QS6qn7T9Sl80anipRbPGPSlCD07hI=;
        b=AWoLniP1jbI0QDKzHEVwmNBYe4Yx+bFXUz96xRBmQymejt182VfT4w55UQg94KaV7a
         B1sdcmIq2CPzlMdGa//B8Hlb8jyABV/0rsU+cCb6en6iTkvzhckz/CGAb7JfJ7WVDpU+
         XI9IIxOSkWI5zxzqGe6kP3lk9ju8LTpqUwVJKc01+W6XXRbPxILrMrMmPsfM1Ft7RVLy
         cJNHDAfP9PeXlM/pAzLsFwAQ9yJa5Qtw1Dnmk7tgbLdj0nM/oCYOXFMDLstjvl1ffZt+
         biNxJxKEyk5NFF6p7W6wRi/pL4FzZWMmeMVwLtXM8wfPMIx3NhucYa82B2GA+PqMRB1r
         DnBg==
X-Gm-Message-State: APjAAAWnribhs3yBDM4UWJN9OxgcgcDHoha1LS1lLenQMvZBd/pc+npn
        X1Gl1e9RAKVyZysVx6j5CwBzFNZH
X-Google-Smtp-Source: APXvYqw5/NsEM7xneHdMisRXVW6zV0WC+8frUbUichyPU79wD94BW3jO/FgthBaSO9H9hs2Fww/LXw==
X-Received: by 2002:a19:e05e:: with SMTP id g30mr6153357lfj.167.1551558503405;
        Sat, 02 Mar 2019 12:28:23 -0800 (PST)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id b18sm413185lfj.80.2019.03.02.12.28.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Mar 2019 12:28:22 -0800 (PST)
Subject: Re: Announcing the btrfs-list tool
To:     =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>,
        linux-btrfs@vger.kernel.org
References: <535a7ce9be6696815eb4413fd0f2ed17@lesimple.fr>
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
Message-ID: <50cc3b27-e780-6c94-1602-2970b1a867eb@gmail.com>
Date:   Sat, 2 Mar 2019 23:28:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <535a7ce9be6696815eb4413fd0f2ed17@lesimple.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

02.03.2019 22:06, Stéphane Lesimple пишет:
> Hi!
> 
> I've been using btrfs as my main NAS filesystem for a bunch of years
> now, and I always found that managing dozens of subvolumes having dozens
> of snapshots each was not really straightforward, especially when trying
> to get an overview of "what's taking space on my filesystem". I was
> missing the niceness of the "zfs list" command, which does that quite well.
> 
> So I've started to write a wrapper around btrfs qgroup show and btrfs fi
> df (then btrfs fi usage when it got out), to implement this broad
> overview of my filesystem I was missing so much.
> Adding some features along the way, I thought that after all it might
> also be useful to others than me!
> 
> As stdout is better than a thousand words, here's for example how it can
> show you a complex hierarchy of intricated snapshots:
> 
> root@nas:~# btrfs-list /mnt/a
> NAME                                       TYPE     REFER      USED
> MOUNTPOINT
> 4582dacf                                     fs         -     0.00 
> (1002.88M free)
>    [main]                               mainvol    16.00k    16.00k /mnt/a
>    sub1                                  subvol    16.00k    16.00k
>       sub1/.snap1                          snap    16.00k    16.00k
>       sub1/.snap2                          snap    16.00k    16.00k
>       sub1/subsub1                         snap    16.00k    16.00k
>          sub1/subsub1/.snap3               snap    16.00k    16.00k
>          sub1/subsub1/subsubsub1           snap    16.00k    16.00k
>             sub1/subsub1/subsubsubsub1     snap    16.00k    16.00k
> 
> 

btrfs does not have anything resembling USED in zfs, so I'm afraid this
will be confusing to anyone coming from zfs. In zfs datasets are
hierarchical (including snapshots) so USED on every level is exactly the
amount of space that will become available in parent dataset if this one
is destroyed. This does not matter much without quota (as all datasets
share one common pool of free space) but becomes quite visible as soon
as you restrict dataset space consumption. In btrfs every subvolume is
independent; what you show as USED is exclusive space; deleting
subvolume does not mean its exclusively consumed space will be now
accounted as available in another subvolume.

Showing hierarchical list with USED column creates false expectations;
I'd rather call it EXCL to make its meaning clear.

That said, tool that lists qgroups with volume names is surely welcome.

> Or how it can help you find big snapshots that you might want to get rid
> of if you're running out of space:
> 
> root@nas:~# btrfs-list --snap-min-used 4G --snap-only /tank
> NAME                                                          TYPE    
> REFER      USED MOUNTPOINT
>       backups/.snaps/skyline/20130213_231649_lastskyline    rosnap   
> 22.52G    19.58G
>       backups/.snaps/box/20171231_221207_monthly.12         rosnap   
> 88.73G     4.96G
>       backups/.snaps/box/20180130_221209_monthly.11         rosnap   
> 91.25G     4.90G
>       backups/.snaps/box/20180307_154215_monthly.10         rosnap   
> 96.28G    10.72G
>       backups/.snaps/box/20190120_193004_weekly.3           rosnap   
> 56.45G     4.25G
>       backups/.snaps/nasroot/20180122_091325_monthly.12     rosnap   
> 34.65G    10.79G
>       backups/.snaps/nasroot/20180221_092311_monthly.11     rosnap   
> 31.96G     4.98G
>       backups/.snaps/nasroot/20180323_092734_monthly.10     rosnap   
> 33.69G     7.05G
>       backups/.snaps/nasroot/20180820_205559_monthly.5      rosnap   
> 31.74G     5.37G
>       .syncthing-bkp                                        rosnap   
> 40.48G     8.15G
> 
> Want to give it a try? Here you are:
> https://github.com/speed47/btrfs-list
> 
> There are a couple snapshots there too, to give you a rough idea of how
> it looks like (yes, it also has nice colors)
> 
> Happy btrfs weekend!
> 

