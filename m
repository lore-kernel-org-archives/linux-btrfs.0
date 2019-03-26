Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9131DC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 03:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A0322075C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 03:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r1VfFJmh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbfCZDr5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 23:47:57 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:38254 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730972AbfCZDr4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 23:47:56 -0400
Received: by mail-lf1-f47.google.com with SMTP id a6so7585914lfl.5
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 20:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O93fj8TdUsXRgHqztb7l0gO6N1E9+TwYf9TPsX/a2Pw=;
        b=r1VfFJmhNVAR2eHIWjT7hOCFyIRYq10lC1bEhEChIrnHTW55vOXYccDQ2SS+pYfQfx
         5gKGQu1owvyykd1bhSMt35e6QrRN5Pxs7oxRpp78IGQi4t8jM0iUS7g0zuWuSHFk5ocN
         GYZRf0skf4aBrkBiFvs1SBGxF8MFqpc9EATJLSMLf74tmjYmci5r9dXx6aKGeas/I2Ir
         rfRi6cUO3oQRymUfV4++GhAgDMZ2ilwerPhbVFGDYkh8HfTdO0Kk4fTlzU8MtEUReJRc
         3Bsqw5+iqZA68KUjHflzYodKPi5PjEJnXYvJWXXl7ifEk3k+I71eouiUcFeBAgNcaQmg
         t/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=O93fj8TdUsXRgHqztb7l0gO6N1E9+TwYf9TPsX/a2Pw=;
        b=Mcob8C+/NR4pqI8nkGjp1ixDISQPvRAKqpIuO7d24qI0IAW1UaPNDjwpSGeZqSAzRw
         kqAxsqtbWMXtQJOnLI4Mmx35jwL+kKBY2KeJbV5g5C8XL5On53xRJ7jn93yfZpa0YTYe
         HI9XU/ZgKaFbqhvFYO0lLXpmDHVdLEya1GKaKeGTQtkMXqrKTMI0rbgS7+1D9BjFtjNv
         DE5mx4gHT2hwBce9XGiXVtbSiFQsfGwjp8TV7EMgAFoQnjxA4Ds6iNElQaYwgqYkn/Dn
         Rb07WSeW3+0nIVaW7+sai6obghAmFaI8lpIIHA2Cm+/yB18xWBeWbfBAIOgyHNMm4myl
         mYfQ==
X-Gm-Message-State: APjAAAWBNtuaQP4XiCd1om5XS16d/XgRug3rDVQEe/MT8vDsOix17rzB
        OjiNqZdEwF8rf0K0ytIZkSJOC5kxPko=
X-Google-Smtp-Source: APXvYqweUZHNzLWoOzeVUIDQ1BUnOmq4IbsfiMVY43rEhxzhqhZPjbOa/uFZG6dsWaNHcfds4yRclg==
X-Received: by 2002:a19:95cf:: with SMTP id x198mr13928289lfd.73.1553572074592;
        Mon, 25 Mar 2019 20:47:54 -0700 (PDT)
Received: from [192.168.1.5] (109-252-90-78.nat.spd-mgts.ru. [109.252.90.78])
        by smtp.gmail.com with ESMTPSA id t14sm3690963lfl.38.2019.03.25.20.47.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 20:47:53 -0700 (PDT)
Subject: Re: parent transid verify failed / FS wont mount / help please!
To:     berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
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
Message-ID: <597b7e4e-25ce-1f40-75df-bfcbb41e5d2e@gmail.com>
Date:   Tue, 26 Mar 2019 06:47:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

26.03.2019 1:26, berodual_xyz пишет:
> Dear all,
> 
> on a large btrfs based filesystem (multi-device raid0 - all devices okay, nodatacow,nodatasum...) I experienced severe filesystem corruption, most likely due to a hard reset with inflight data.
> The system cannot mount (also not with "ro,nologreplay" / "nospace_cache" etc.).
> 
> Running "btrfs restore" I got a reasonable amount of data backed up, but a large chunk is missing.
> 

You may be interested in

https://lore.kernel.org/linux-btrfs/CAH+WbHw1cm96YNjVhmdFP4qZ_HR3mzfmojna=d-MeydCtunG1g@mail.gmail.com/

