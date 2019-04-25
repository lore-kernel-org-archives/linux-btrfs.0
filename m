Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDAEC43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 17:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DE1D206A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 17:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IqzvXmTP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfDYR4D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 13:56:03 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:37044 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfDYR4D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 13:56:03 -0400
Received: by mail-lj1-f176.google.com with SMTP id v13so458598ljk.4
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 10:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YOMbeq+7Us/cFuC3g3eOtoXdgWSuMvO4z4oB4FS3U8A=;
        b=IqzvXmTPFIH8pWzqwx3osLvqdT71a+46aKwcBOSMyeS0MC0UEd6Jjg1fh7fQbLyp2c
         VfeVQtkFsPuli1UGJKuE9I2fpGAVoC+JHJJGLUkdi7dZrMj85nV5NmnjJa2zSyBQbinl
         ityF9mm9iOMpw6UywQRa9TaQEt6AvNAC13AV724r6WEqxyt/hmrJGqh5DhnkPGLwe3XK
         wQ4hYVmx6lOWg+YrcHs2O18O0oA18FsDOdewzxk6uFOK8RQ8rip4h318jlm5Vmmexcrf
         40HNaxdO9RsL4BFD/WOYYEjNNua9BQ0vUkflXnCDfni0gnZjgKiQ+qw6H5Sst1uHpU59
         4UfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YOMbeq+7Us/cFuC3g3eOtoXdgWSuMvO4z4oB4FS3U8A=;
        b=BDxEMr26sDoDdJQ/Kl6dtGXH4/IhsFgSKB94WqZ3Vbu/DXHfOkwHgxylVKALQnAo7E
         qoKLhUAfXunfzkRhAIXF5vx8AO9OjfxiS7/zrc9WDncIjIEUI++dFdvAzghK2lFpbSlq
         AIGGkt7DIdn/pQcvKkvh1o0B6d2N+RDrgsWpPY/t2/WWmcY72tup+FprqVIx02pqFjKX
         IUSQrOWWwVKCKLDSzjR6LgNb+g8+bEyT1qbJECHpqa8pGK1MB4DNWWM8vezQXRiv/7zF
         FAOe9kfe+nXbWUAkSeH2vPGCGNU0iWZH51kWCepQ0nuMN9GN3xGxe5jNbvoBNxj5NEt9
         E+6A==
X-Gm-Message-State: APjAAAVdEerOQaNoBaxn/bZj0DhZp3kaQOLlbj1PYs4jrL9OuBypVt3h
        LLMXdsE/LAM/MwRKwODPK9QWJPBw
X-Google-Smtp-Source: APXvYqx3qwRNT74u10TpBbyduludGMA4tn+uij2X1P4cjvHMqT0yQhuViYKgt7eu+0DjG7pFYibV9A==
X-Received: by 2002:a2e:7a03:: with SMTP id v3mr11443344ljc.142.1556214960928;
        Thu, 25 Apr 2019 10:56:00 -0700 (PDT)
Received: from [192.168.1.5] ([109.252.90.193])
        by smtp.gmail.com with ESMTPSA id y20sm1312962ljh.27.2019.04.25.10.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 10:56:00 -0700 (PDT)
Subject: Re: Some file lost when send back snapshot.
To:     MASAKI Haruka <reasonset@inflaton.co.jp>,
        linux-btrfs@vger.kernel.org
References: <20190425223457.5a7dfd20@hydrangea>
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
Message-ID: <aa5623ca-e1c2-4499-75ee-be818acf3333@gmail.com>
Date:   Thu, 25 Apr 2019 20:55:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425223457.5a7dfd20@hydrangea>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

25.04.2019 16:34, MASAKI Haruka пишет:
> I send snapshot from backup volume, and send new snaopshot to backup volume,
> and some file lost in received volume.
> 
> In detail:
> 
> 1. Host A has new Btrfs volume and Host B have two backuped readonly subvolumes (190312-010100, 190315-001000).
> 2. Host B send 190315-001000 subvolume to Host A.
> 3. Host A completely received (all files exist.)
> 4. Host B took new readonly snapshot "back1" on 190315-001000 (all files exist.)
> 5. Host B send back1 with `-p 190315-001000` to Host A (some file lost.)
> 6. Host B took new read-writable snapshot "world" on back1 (all files exist.)
> 7. Host B modified world.
> 8. Host B took new readonly snapshot "back2" on world (all files exist.)
> 9. Host B send back2 with `-p 190315-001000` to Host A (some file lost.)
> 10. Deleted received snapshot and Host B send back2 with `-p back1` to Host A (some file lost.)
> 

Please show

1. Full protocol of commands you executed (commands and their output),
e.g. captured using script.
2. Commands used to determine missing files on both source and receive
sides.
3. Listing of subvolumes on both source and receive sides with

btrfs sub li -Rqu /mount/point

> Kernel
> 5.0.5-1-MANJARO
> 
> Btrfs progs
> btrfs-progs 4.20.2-1
> 
> 
> What I should do?
> 
> Thanks.
> 
> 
> 
> Masaki Haruka
> 

