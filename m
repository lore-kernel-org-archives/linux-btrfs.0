Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4A5C43218
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 20:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAEFF2064A
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 20:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhfgpXpv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfD1UO1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 16:14:27 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:34669 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfD1UO1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 16:14:27 -0400
Received: by mail-lf1-f46.google.com with SMTP id h5so6368723lfm.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2019 13:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/K1WtVImn2Gk01ausbJzLuFFpfrFFzdp6g39tf957g=;
        b=LhfgpXpv3EkPBAQdWWML+XF+hiND0Xi7Wvq/A5U+CfyaINWXKr5D6l8bBD1KfbjWQu
         CypyQXJsLyP+PcTB8drFQtmwXVg69t7bd9U5vA9g/kWXC9sZum3shhUcTRiTK+5XEBLq
         QkXDn3P2IciY6G7Hajl2ASetOxS9yqD4TmfqxRomEm90nkvVwh//sRM/X8j0Tyr2C7bA
         u5wT6Ys/dUPROeqgZs8nDp8+mLZjEQNkEJyNZK+fRy5h68u3p8QbuyV9n41Q92gGOti5
         R6R0kqVD31bSjCfCE6gy62RcYU9u7xw1rtXQuRBGWgKb5aWgWRSDd54DW/P+cAl6Mcgh
         HA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F/K1WtVImn2Gk01ausbJzLuFFpfrFFzdp6g39tf957g=;
        b=iHpEmRKus/L5eQtsPahlnz75YAIncjm7mjykqIwsgj6M+r0b9MXTJd6sqaOIaw9dVA
         wSYM1Q++TpB2CuarQ2ggJlupMgsz2af7pmPXgYO849o6K3dPZxknbvEVdB35ldQBxfSX
         iHmGaVzGBqo/eFVhszczMpGxOi1v3+/5NfN4VgmfNdrr1bp4M9U1+GYrsXTAJGPbfb/B
         GcYccfjNsbWyff+zHo+ltlUN0DYE7JLQMDIsVNfFgSNIdb8N4DpswvQMqD/1zhl81i28
         Z7tlwTIrzJW4blCRsLNjd6UHmdLS/l5/EQurcM6JBF5JwqKudH0uMrIinx9fMjdrufw0
         Um+A==
X-Gm-Message-State: APjAAAWmdCM6q6b9FsPZq6J4XLMbXvM3T7+eNfxLWi5TbUr5ofkeVs9j
        2kBhrPuV6lsd1Wa4Lej/pLiZlbdR
X-Google-Smtp-Source: APXvYqwdfupXj41MnTXxcnn53+D5btSoi7G1169pqtL9RLTUXIfowlGunkb6FrN+vCwKMLWzmlyFwg==
X-Received: by 2002:ac2:482e:: with SMTP id 14mr28027115lft.1.1556482464762;
        Sun, 28 Apr 2019 13:14:24 -0700 (PDT)
Received: from [192.168.1.5] (109-252-90-193.nat.spd-mgts.ru. [109.252.90.193])
        by smtp.gmail.com with ESMTPSA id p25sm5309783ljg.9.2019.04.28.13.14.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 13:14:24 -0700 (PDT)
Subject: Re: Migration to BTRFS
To:     Hendrik Friedel <hendrik@friedels.name>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
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
Message-ID: <0f1a1f40-c951-05dc-f9fd-d6de5884f782@gmail.com>
Date:   Sun, 28 Apr 2019 23:14:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <emb78b630a-c045-4f12-8945-66a237852402@ryzen>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

28.04.2019 22:35, Hendrik Friedel пишет:
> Hello,
> 
> I intend to move to BTRFS and of course I have some data already.
> I currently have several single 4TB drives and I would like to move the
> Data onto new drives (2*8TB). I need no raid, as I prefer a backup.
> Nevertheless, having raid nice for availability. So why not in the end.
> I currently use ~6TB, so it may work, but I would be able to remove the
> redundancy later.
> 
> So, if I understand correctly, today I want
> -m raid1 -d raid1
> 
> whereas later, I want
> -m raid1 -d single
> 
> What is very important to me is, that with one failing drive, I have no
> risk of losing the whole filesystem, but only losing the affected drive.
> Is that possible with both of these variants?
> 

With "single" data profile you won't lose filesystem, but you will
irretrievably lose any data on the missing drive. Also "single" profile
does not support auto-healing (repairing of bad copy from good copy). If
this is acceptable to you, then yes, both variants will do what you want.

> Is it possible to move between the two (doing a balance, of course?

Yes as long as you have sufficient free space for target profile.

> Any other thoughts/recommendations?
> 

As of today there is no provision for automatic mounting of incomplete
multi-device btrfs in degraded mode. Actually, with systemd it is flat
impossible to mount incomplete btrfs because standard framework only
proceeds to mount it after all devices have been seen. As long as you do
not use systemd in initramfs you may be able to boot by passing suitable
root mount flags on kernel command line.
