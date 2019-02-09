Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5EDC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 15:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27AF821773
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 15:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sIC2/HgG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfBIPgm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:36:42 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:33357 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfBIPgl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 10:36:41 -0500
Received: by mail-lj1-f171.google.com with SMTP id f24-v6so5482218ljk.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2019 07:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mKHYB2+fpN9vEarh6ZbNY3YX4tRD5/t4EYV5C0nCFww=;
        b=sIC2/HgGqKk722FnxTt1+R4QUnV8HYXKTIBXPgde0Bmw+d+LPGuNalmdBWrfA4pj2o
         gMN0fvlvXwr66UJpmx+TaFJDwZwyddEWThlx+oRgUen06YYYVAHchLyO4o0RrxW33XrD
         Utbb0HPaPycmbT5U1dIZ6C+jL0QSFOEzzvYhs/qfLd4bPEZYeBEInJdjDQXrSROWNjeh
         nzhAHKH4CK0CaXyqEzMltDKyaq5FfS8X/9prBKiQN0i3LJp/sYmIe0rwPgqo/H4c8c76
         vPT30eccYgrcDhF2j3QTBM70YrbCirR2LbXGgnvhIYCTpQ6V5vkDNbnk6rEVAiWfHpzX
         P+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mKHYB2+fpN9vEarh6ZbNY3YX4tRD5/t4EYV5C0nCFww=;
        b=qubEqn4hhHkQMCfbVSoHchhwAUmnWb15L5GH3gZCuSg9F41DGqfaXpXq1XuQuUv113
         Xxx8tmFxrejWKyzOfKka0skL5uJMOWTMIn/srlmlLx/4zHu99IBOxyMTklc29fxMxE/5
         2J+bWKOMAtcjl0wR9N8z5pSumIKfpu5rdLdFu4GhMwr926v6ETHS5EHqBQB3WLrGvdyn
         HCgA9TNRdBL0AmcnpyXKU2srWhSltEEkgMkUTQ9JGm5JUAJce2Gy5JCbVyP631GKzjRN
         oEkC5lE7h+wE8roRpFI5k9EhYBor0o32l/5P6/IK3F/F8Gk8U7hQRqHdu3GPrNCu6Jom
         cvng==
X-Gm-Message-State: AHQUAuYjvME4InMZoqVJ9LOv7fpDNPdEGjFB/AWd6L1j88G2ii9ENcox
        NwRt0KYhuU0jH9LLnHzD2OAuH8b3
X-Google-Smtp-Source: AHgI3IbogK59DjR40XModcMOAKV/vmyndwrWbl56GEPG/oSgEZvo/Lj2I2t2rUaip30B1vS+QTqdxg==
X-Received: by 2002:a2e:6109:: with SMTP id v9-v6mr16505180ljb.126.1549726599477;
        Sat, 09 Feb 2019 07:36:39 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id m21sm1130669lfl.97.2019.02.09.07.36.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 07:36:38 -0800 (PST)
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
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
Message-ID: <b89f4970-c750-81d9-5eec-44a0ff14c4e1@gmail.com>
Date:   Sat, 9 Feb 2019 18:36:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

09.02.2019 13:36, Jakob Schöttl пишет:
>   btrfs filesystem show   # to get devid of device 2

Funny because for me it just says "Some devices missing" without giving
exact device id. May be has been fixed in recent versions but for a long
time it really annoyed me.

OK, when I just unplug device it does not say it - but it also does not
say *which* device is missing, it happily continues to show old device
names at the time of mount, be they actually present or not.

I always wondered how users are supposed to know which device to replace.
