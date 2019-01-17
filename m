Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F17C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 19:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E19F20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 19:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTc6EXnB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfAQTRr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:17:47 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:35417 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfAQTRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 14:17:47 -0500
Received: by mail-lj1-f174.google.com with SMTP id x85-v6so9570570ljb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 11:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nOQlFeynQwBMySSNv0yBn4gLzdQ7V7BIXwhO+tl9spg=;
        b=gTc6EXnBHlFBUT0SZR1AxtKrzyTiHuM8/n0v4NYPauAvXiyaE9+xrTkHl4ItZb/GCc
         0xfmczrNp7auY2XWWThsIomTD1ZbZx/6+3JZPNN+kWyyBePZmB3u/xsL4FLK9fG+5gUE
         Bqbbv+lESXcWaPI7zKatCRzHKE5d2wSYOZ84Vfk/bjlmhez6RaaAnES3pYLug2DJtLfg
         o19CmKv4NMhhByFXLjqqJC1bPvCsuXUb92DX+vF415aaUAKohz2XOx0kemNAVfqD+QZI
         q/vwDbPGRwelGtf0q3RI7eI5CN3LExwaCntRQBklbqwtwtKCoCAqNXsCmeq0wDO3A26D
         7OOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nOQlFeynQwBMySSNv0yBn4gLzdQ7V7BIXwhO+tl9spg=;
        b=mvtQH5JjacvuyYgoOfSIJXtzB0tWv42ZzKnzGYz3jZ0f7Pr4ytykAFD3570OYlLnT+
         tHlJ1JC6K+vRbgQ6IUY7e5HvwIs5VIZ9K/MwwMb6yptB4dFkuNud8rnhsIiL5665VL5H
         r+X5u6+KYNa18NQsmjSL44zbBrm4OOJDcS6tHE3rnDWn4P8jZDiybZcnor4EmwbA2t3r
         CSRP1qizpYLhEvhyGgShARQX9O8l0N83hLLb+SwKAytW7qag3PZr/O1DgDvvL98xF1iG
         02TIzlr9KldNVAqf5MNVaIQVU/X3d0olnyxStnmIEb7b4bXZNJzck3PqTPsFmFRs7QTr
         YWVw==
X-Gm-Message-State: AJcUukcjFMfYQ3g/PkLYadD16PX6WZ9wuxUSuMNDA1rHP3Npef+zDXE0
        gwa6c6we50a8zpQAkr5UrMqtRSMrAjs=
X-Google-Smtp-Source: ALg8bN495/za/i5t5jtQqmNIl706gnicXx0cZHFAcILx4/2rCJHcEsbxwyR6FJqUcutfuSP1NXnwBg==
X-Received: by 2002:a2e:2c02:: with SMTP id s2-v6mr10681761ljs.118.1547752664928;
        Thu, 17 Jan 2019 11:17:44 -0800 (PST)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id z6sm437357lfd.50.2019.01.17.11.17.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 11:17:44 -0800 (PST)
Subject: Re: question about creating a raid10
To:     Chris Murphy <lists@colorremedies.com>, Stefan K <shadow_7@gmx.net>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <3318002.5e9V1lv8s4@t460-skr>
 <20190116144208.GI5134@carfax.org.uk> <1980543.jviTh1pdNs@t460-skr>
 <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
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
Message-ID: <6c54fec6-065c-3a50-9bf8-499866cb4e9b@gmail.com>
Date:   Thu, 17 Jan 2019 22:17:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

16.01.2019 21:15, Chris Murphy пишет:
> 
> Btrfs raid10 really should not be called raid10. It sets up the wrong
> user expectation entirely. It's more like raid0+1,

It is actually more like RAID-1E which is supported by some hardware
RAID HBA. The difference is that RAID-1E is usually using strict
sequential block placement algorithm and assumes disks of equal size,
while btrfs raid10 is more flexible in selecting where next mirror pair
is allocated.
