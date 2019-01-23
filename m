Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F51BC282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 18:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D73BA21019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 18:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfTBsNqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfAWSRK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 13:17:10 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:33237 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfAWSRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:17:08 -0500
Received: by mail-lj1-f178.google.com with SMTP id v1-v6so2843753ljd.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 10:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8MYcVyw9bfv8y76m5YNPhrPUTMaOk8CCevseOYvlH8=;
        b=YfTBsNqYhGL4DSFIfL6s7uAtcrUu2flDj6B7Bze+X9+zWtAtcBEuGLOBmZj+seFSxB
         lwD+fP2uyUO243TSTM8oqG7teAnGWIL6OARPagH6QpCsVkNAamFJvVsgT4bwYdhl2uZg
         H/WljCXQf+ORKBr3y8hM6iVFAXHNVzJArKx62YTjU2TZm7Af4HQNFjewrkRkp8jFw7Kt
         +lyXlwbAFJiMYz+ooLYe7lfdF4d8hC7gnGU4WAe0fk7CcTto6XnJCOMARZzSmOqWDSoc
         4h+Yu+UpKA/D9Rk6p9jejVyTPJAtvYo/R5Gb9Yfy2GBo18sM9mMeytnq+E3bhB+fyM24
         pZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=x8MYcVyw9bfv8y76m5YNPhrPUTMaOk8CCevseOYvlH8=;
        b=Aug3d07yF8dyGZW1Ym8ivn+UmaWivKzO7oHDfwhsTETMbEpBvyyNKO1gOnb69IvLa6
         n3XKq2VgVS3TboJIGos8IPFnoKMM1mHACEFjhSX6YGMZwds03ahy/0IHAWY/ipxHHmc6
         grz+GMmIYitYPvsBQsukbkBoOKt6nyVM0Oy4ZhZPuOPiagJO5xfJd4XaD2q77rHdcAbW
         l3PqA2WAjpcfkpkEdHVT1dwhuwAJgcVR6axHVcGFMyP6cERZYn1P7bnST1LHQ+dRneEP
         pL8H7Kj5lOOz+cn52za5Ek5N/UFFDLge+FfQshBjYsGvzzqFcyLROM7k7WVamenNDakc
         Gbnw==
X-Gm-Message-State: AJcUukfo58lmFeYUZaPJI4MPT+Fcw4aU8UrUWhS+E0uHzL8toby1nayx
        Fl93B7KSTByk9pqv4SRn+iRtoJIcs+Y=
X-Google-Smtp-Source: ALg8bN5Y5dJHB+GgrB7oSo1C6EPPznM76uYcTZpH+nQEkQWE8+tAQ6E94t6DJ3vp2db4mogxq/S9Rw==
X-Received: by 2002:a2e:93d7:: with SMTP id p23-v6mr2888033ljh.22.1548267425255;
        Wed, 23 Jan 2019 10:17:05 -0800 (PST)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id e5-v6sm618565ljj.91.2019.01.23.10.17.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 10:17:03 -0800 (PST)
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Dennis Katsonis <dennisk@netspace.net.au>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <b36e4ef6-6f07-1430-45a0-df9d44d472fe@netspace.net.au>
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
Message-ID: <e5f6086e-83cd-f104-3bb5-c5819790ae4f@gmail.com>
Date:   Wed, 23 Jan 2019 21:17:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <b36e4ef6-6f07-1430-45a0-df9d44d472fe@netspace.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

23.01.2019 16:52, Dennis Katsonis пишет:
> On 1/23/19 10:25 PM, Andrei Borzenkov wrote:
>> On Wed, Jan 23, 2019 at 1:45 PM Dennis Katsonis <dennisk@netspace.net.au> wrote:
>>> I think my previous e-mail did not go through.  Basically, if it is
>>> assumed that a btrfs-receive operation will result in a subvolume which
>>> matches the source file for file, then this assumption or expectation
>>> won't be met if one deletes files from the subvolume at the receiving
>>> end which is going to be referred to as the parent.
>>>
>>
>> This is oxymoron. btrfs send/receive apply to read-only subvolumes.
>> You are not able to modify them. 
> 
> 
>>
>>> This can happen inadvertently,
>>
>> It cannot. You do not inadvertently make subvolume read-write. 
> It's not the individual steps which happen inadvertently, its that
> particular workflow which can happen (i.e.; someone decides to play
> around with a replicated snapshot, and flips the ro bit to do so).  Any
> subsequent children sent later won't be true replicates on the receiving
> end.
> 
> They would have to either make a habit of not flipping that ro bit at
> all (there is nothing to say don't do it, and there are valid reasons to
> do so) or anticipate they may need that subvolume as a parent anytime in
> the future and that parents must be the same on both ends (there is
> nothing which states that parents have to be identical on both ends for
> btrfs-receive to operate).

You cannot have your cake and eat it. Either you want it to be fool
proof or you want extreme flexibility. In the former case it must block
certain dangerous actions. In the latter case it is up to you - you got
what you asked for.

>  If they do modify ANY subvolume created by
> btrfs-receive, they must remember in the future somehow never to use
> them as parents.
> 

Both NetApp and ZFS distinguish between read-only snapshots and
read-write clones. If you want to obtain read-write access to data in
snapshot you clone it. May be we should at least think about why this
workflow did not change in 25+ years.

Problem discussed in this thread simply cannot happen there.
