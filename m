Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176C0C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0A0218C3
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gpnt1UhV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbfBPUc5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 15:32:57 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:46668 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733204AbfBPUc5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 15:32:57 -0500
Received: by mail-lj1-f173.google.com with SMTP id v16so11151341ljg.13
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 12:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2llRr+zJG/5sUVDzSOWYHM9ei2GI8gA+hxLqKKpvtJw=;
        b=Gpnt1UhVrvehi/eG/B3kXaiGZq+fuiWsTF+9nrxme6F2Bs800rlykFBqSSgam93TkM
         21HJx4PvonUSqHLrC+rXq3i6wgDq2WtyBGvrkaJ2HMUsieJnfHXr5SpWMAApcoGvwmCY
         h8KI1rY6bDKzy3BGKxwq3x5Sjb22DCqyy6az3+QPS3ouEJTRwy1ySCujnY5leYGTYGxy
         zjwuX3fArAlo+Q2NIv8AdkmSU+tXYXdRwuu/5RxA4jxEYgi+yZllQsZ3hK/roM2sBDir
         px4qZEdhQL9BYf8h4771ECZ/+slGR79l/En6txRT+q9Ijhzne+/yV3+ETmAV3gHhqTJf
         Tm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2llRr+zJG/5sUVDzSOWYHM9ei2GI8gA+hxLqKKpvtJw=;
        b=pqjK1TohvCs3mQQstRSwtoncQXe0Pa/16PtVE9jxmROmEeefqxawj2YZkforqkTigU
         pKYa8vxCV8uCxkL5DA6eHeUz81LvOGYlnJCEiwGMnwntfM/arwj3pn5kjaR47ph+nT14
         9TbDFt8vK9t1PymFYu3ufT/PzmIHP5WqcZx+YwSpLo0Y8l2uI/yKolzCZ/kqWiX0SCzQ
         Jm6k0Lw6C2i+ZzMLMWBjkJ7rMFDDcrtP1r8ehuolIYHUa8o8QIY9fD7HYIz+dcuPHhZJ
         sNDWpXT6Yc6IhDnOaQmq2N3Sb8AhTyoGyubV1AaG/mCmw1OkxZVJTRnHRfuRmKR/R2fe
         Kgmw==
X-Gm-Message-State: AHQUAuaTBWldaMDOzX3zbAAj1sYJRrQOYXgp9l4lmg6LiIfSCEyfXsx2
        AuoBoKTRVSf54AHFRS7ezUBEGp1o
X-Google-Smtp-Source: AHgI3IZi8ODVfOBBClk5KG1dkQTn32K6i2+fQxYjipZIWsvbkY9SEC78qNi+s3LL8yJREqBPkRwBEw==
X-Received: by 2002:a2e:96c9:: with SMTP id d9mr8688275ljj.133.1550349174768;
        Sat, 16 Feb 2019 12:32:54 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id z17sm2568759lfh.9.2019.02.16.12.32.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 12:32:54 -0800 (PST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
From:   Andrei Borzenkov <arvidjaar@gmail.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <1c6a1abb-1e6e-504a-b51c-0da580c49d66@gmail.com>
 <CAJCQCtTO0-WG+mHHvsUdQBJhuQ63dPkBqJP96vz7CU4jGF+hxA@mail.gmail.com>
 <1cd9e028-931d-0ca3-8ece-710a039c552b@gmail.com>
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
Message-ID: <bf5aa831-1501-2348-3542-aa388858be21@gmail.com>
Date:   Sat, 16 Feb 2019 23:32:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1cd9e028-931d-0ca3-8ece-710a039c552b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

16.02.2019 23:26, Andrei Borzenkov пишет:
...
>> Difference suggests the order does not matter. Increment suggests it
>> does matter.
>>
>> btrfs sub create A
>> cp somestuff A
>> btrfs sub snap -r A a.1
>> cp morestuff A
>> btrfs sub snap -r A a.2
>>
>> The normal case of send is:
>>
>> btrfs send -p a.1 a.2
>>
>> However, is it valid to do?
>>
>> btrfs send -p a.2 a1
>>
> 
> Of course it is. Stream contains differences between the first and the
> second stream, where order does matter. "Incremental" implies temporal
> ordering between two snapshots which does not exist on "btrfs send"
> level and must be ensured by tools that use "btrfs send/receive". There
> is no inherent parent/child or temporal relationship implied by "btrfs
> send" itself. "btrfs send" *will* compute differences from a.1 to a.2
> although a.2 is newer than a.1; it is up to you to ensure you apply this
> stream to correct base on destination.
> 

And BTW your example can actually be useful to revert (roll back)
content of volume to previous snapshot.
