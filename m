Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B53AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 18:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C80C205C9
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 18:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cx9vGeYb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfCLSBt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:01:49 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:46251 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729074AbfCLSAw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 14:00:52 -0400
Received: by mail-lj1-f173.google.com with SMTP id v16so3114096ljg.13
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4rD+2OcWJWWBMvRWvH3Gs94JJ2Ywd+fm53tTmHY9JqI=;
        b=cx9vGeYbEefTFq7gq7/u5pjZKj+KHeK12sLGbQ8FAoyiKQLm6Hr1nWEqJKkPcHBpsg
         U5PvCY1txNJr23bYjZqM5zr7uSH3OqpxwE2Mqovjk1owAU6QyR1/uv+gb2YoepAt6N21
         E0wHK3EpjlfKQAA4Z3Oipwmse/36Hxu8X279P4Acn9hRL2EhIt5zOMqK2uLn/jsenk7x
         4BdOqyfEb7mvpYb7pRu43EVskanDkVFtmf+nQSe0vimgMjVoUgajpkmTNN2DP8iuf/Ll
         R2v3NV1yXNCVGqs+gAUBtGxKbNu8xzaAQUeiMOPW/q5Hj3jK6RGiyGsusFJ/m1aloh45
         g+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4rD+2OcWJWWBMvRWvH3Gs94JJ2Ywd+fm53tTmHY9JqI=;
        b=L4AJagQMHk5Rc/UtK6m3f6rGAgIS52EGZUtAmXoNmfrDZJiK/4BdWWqenXrabhUug+
         Dpe2SNdlJbR6vrh3Wgry23OpXEKzKKqaKCjFEpLxhqbMv/NTtvoAVO9putENVyrEMNDd
         20kAn6+i5vOG1QMKVYpMObJSMW19BMaUT0mf9u91WgYngbrC7mMzcD4j57rajtnnV+rS
         8VJx7M4qBX8wOfCimr18GJ4sEf81jyjUmnH3vZ7IyOWTDXeSlskCVV03obwF+udIu30w
         xZDD0i0y8rS6gCd7LNuU5ypWb9wQUEEowHLJSDRVhdGgCpu7eccCu0aajfN2Y8CIE5gK
         rb0w==
X-Gm-Message-State: APjAAAUhbMMH1iYrgPqeq8f/KdPq4FmLyG17e/UXKU4+irLxUFFIj5KU
        PdXowgyKOR2MUPHboZwRy4fRF7qtHLo=
X-Google-Smtp-Source: APXvYqz4Ng2DFQxdUBhOzcdXqm/TgF5ufSUSmXqbgIqHuF70dwXxXACUkM0HTUxMaxPyBCTHPvQa8g==
X-Received: by 2002:a2e:8659:: with SMTP id i25mr20660598ljj.110.1552413650250;
        Tue, 12 Mar 2019 11:00:50 -0700 (PDT)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id v9sm312063lfe.33.2019.03.12.11.00.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 11:00:49 -0700 (PDT)
Subject: Re: Allow sending of rw-subvols if file system is mounted ro
To:     Martin Raiber <martin@urbackup.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <0102016972971d54-e7d79438-f177-48d2-ac42-55f162b6b63f-000000@eu-west-1.amazonses.com>
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
Message-ID: <4f6e2661-e828-7a58-0256-d08e1ad40df8@gmail.com>
Date:   Tue, 12 Mar 2019 21:00:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <0102016972971d54-e7d79438-f177-48d2-ac42-55f162b6b63f-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

12.03.2019 18:48, Martin Raiber пишет:
> Hi,
> 
> I know there are corner cases that probably make this difficult (such as
> remounting the file system rw while a send is in progress), but it would
> be nice if one could send all subvolumes as long as a file system is
> mounted read-only (pretend every subvol ist read-only if the file system
> is mounted read-only).
> 

It is possible to mount top level read-only and still mount subvolume
read-write.

> Background/use case:
> 
> Through no fault of btrfs, metadata got damaged, which makes a file
> system go read-only after a while and I'd like to btrfs send/receive the
> subvolumes and snapshots that are still readable to another btrfs file
> system (btrfs send/receive being the only option that does this somewhat
> efficiently). Only I cannot send the subvolumes that are not set to
> read-only prior to the file system going read-only.
> I patched the kernel and btrfs-tools (just commenting the checks out) to
> support this in my case, but it would be great if this would be possible
> without patching.
> 
> Regards,
> Martin Raiber
> 

