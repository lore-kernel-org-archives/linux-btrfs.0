Return-Path: <SRS0=5FUL=OL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C8FC04EB8
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 20:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B950320851
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 20:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/7yLz7H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B950320851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbeLBUaU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 15:30:20 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:38698 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbeLBUaT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2018 15:30:19 -0500
Received: by mail-lj1-f170.google.com with SMTP id c19-v6so9421601lja.5
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Dec 2018 12:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ceoPc8XDsOMG+IuqF6F2KANBFNjRa9a/a4gfEPKEiPE=;
        b=J/7yLz7HgEAXM4MoTx+07ha12xDl/7x3vVV19uatE7rIwhx6DEDJ2IHF1L3Bi9Yv+t
         notqcZT0J6U72cUQUdfjohA3erZs0V2SlnVMD9ir5Lr/WaK7W0oVHjjTL1ciKbkyWD7b
         a+B453BSyC5ce7uy/byIB0wRcAr4legjFKSgBe7TNws6CnxQF0nzWP1BfhvMgrKVJZT2
         TA4KbmnxwstYgjw+eKfcUz7QEgkRmOjurOBybBi06GlCBji6mrchSkoVzweZN+yS14R8
         wn8wF3i7Vwcj/QD/ym0vKhunvwx3AzalTCC8UomqcrVOtJG1Ofs19qPrs5t9SMSndHZp
         mE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ceoPc8XDsOMG+IuqF6F2KANBFNjRa9a/a4gfEPKEiPE=;
        b=ElBtbatIIylR14GsNV/yikLP9b2ahqbDE1VsnIACycw+ZG6b2TBfP4KMzs5+hWgBit
         exG9DBD3Oi1qGqwbvv+OUp3NfP0z0LKHeVAZ792fAtK2cag2MK46g3usUtGF0JZhotp0
         rG+iws4UsQ/1TaZvUychNnW9oN/AvVxfsn8monFVq75k5N3gX41LJ1lp5R7ZLIUunkce
         hnNUp1m4tRlks74h164zMd/GZWUZN9XpthfVkwjgIa+8o1roAoimkg8f1fEVE6VjpLp2
         tdTjvMkMu38nLq6SR5MRPduuhV5GWSgNRQ8ZMHROICeHEcS7PYrKK9GreHL/nVWFvHHm
         7Tgg==
X-Gm-Message-State: AA+aEWYQCloAS83Q9e8rdCtFW/9j6j7Lk7geUMvmwiutlpUEDgGvQY7C
        KsgEnaMejJOBNdLFVzwu+emf5H6p
X-Google-Smtp-Source: AFSGD/UHq3wWr/qjqEOriH6nqXnlNa8xGhKQddhpSNlmNPq5DocT4wjsGdv4vD9GUhflrdUhKKBaVw==
X-Received: by 2002:a2e:9ad0:: with SMTP id p16-v6mr9114181ljj.102.1543782616904;
        Sun, 02 Dec 2018 12:30:16 -0800 (PST)
Received: from [192.168.1.4] (109-252-55-124.nat.spd-mgts.ru. [109.252.55.124])
        by smtp.gmail.com with ESMTPSA id g15sm1965875lfb.1.2018.12.02.12.30.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Dec 2018 12:30:16 -0800 (PST)
Subject: Re: Need help with potential ~45TB dataloss
To:     Patrick Dijkgraaf <bolderbast@duckstad.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
 <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
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
Message-ID: <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>
Date:   Sun, 2 Dec 2018 23:30:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

02.12.2018 23:14, Patrick Dijkgraaf пишет:
> I have some additional info.
> 
> I found the reason the FS got corrupted. It was a single failing drive,
> which caused the entire cabinet (containing 7 drives) to reset. So the
> FS suddenly lost 7 drives.
> 

This remains mystery for me. btrfs is marketed to be always consistent
on disk - you either have previous full transaction or current full
transaction. If current transaction was interrupted the promise is you
are left with previous valid consistent transaction.

Obviously this is not what happens in practice. Which nullifies the main
selling point of btrfs.

Unless this is expected behavior, it sounds like some barriers are
missing and summary data is updated before (and without waiting for)
subordinate data. And if it is expected behavior ...

> I have removed the failed drive, so the RAID is now degraded. I hope
> the data is still recoverable... ☹
> 

