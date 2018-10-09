Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4552BC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 17:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF56121479
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 17:25:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/YbnQvv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF56121479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbeJJAnt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 20:43:49 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:42205 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeJJAnt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 20:43:49 -0400
Received: by mail-lf1-f54.google.com with SMTP id s10-v6so1862030lfc.9
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 10:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l4+Nj76VupP5I0YFklHfUD0z0S/2JBAqB596na35Qio=;
        b=f/YbnQvvO5ODueY5o7gUvyaEsPlqWaItVeCnteVAUSI7jcyi7G3vzZtsRcXAIIDC62
         AcLQdMh/nYEeVuaWMqIkz7RwGA0y+jqNpjz7xyw5WgbKpIrtNUdUGmdTouytL2Z0KN6k
         Y7KoaISM+7TXxeSWy5Ovaz+Da3W86fXbnCNLuT63Um3u3jYB2CjsFfoQhFYcugwdhWG0
         MxW6u5/zjeTtUPEp97VzYwBJLIO1BMTmcj7gv/v68DyvFknGz4cDHbwPAwNPPfcGZx1D
         TespfmGAnZt/cWoLrbRvpbXTyCmtqMZimYSz3g+Cybo5yEbPOu1i8hW5rupB9I5VSx4r
         JxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=l4+Nj76VupP5I0YFklHfUD0z0S/2JBAqB596na35Qio=;
        b=LAFori0i9HHxscvtxJ+DkW3KtzcoK3rKKu39llHW7IymXAGEQQbKz87X6LBxyue/65
         eAXrBFXNmnYhffMIpReOTE+KVjZyytcYfDht8wMTLdWMldJv2dxnN+gt2lv5JCiv8gl3
         nJVtAU3/272WNbCQyUQmEYgSCCnezLx3ILqRIBNFJHnesMUh0aWytJBrvyPM92VxqYkP
         V4wre3G/Ft0rMt0u1B/Qz3GxxRfglY0gR8lIR+nnuKlN7tqKKYZFeMcnfv2tCbQnZxJ1
         d0oLYLO14nBXrOf+DggUeMmOIh+IZibb0YrtZgVwTHICkf2pfRn8+OjTblKoo+rlnWv2
         d1kw==
X-Gm-Message-State: ABuFfogNmR18HxCeZp/e4K+FupuKUK2TsPH9GQ7MDNi1HSq1mFyJ0ssl
        REgQw/hjn6DHCorXea+DLl6IJxcsfng=
X-Google-Smtp-Source: ACcGV61YSYJeFt1JmujROQX2rv9zj344yiMDJVHO/36zjr3gW45GzR2kG7s5WA5fv+U9WsmoaPTNXA==
X-Received: by 2002:a19:c44f:: with SMTP id u76-v6mr13939265lff.141.1539105946536;
        Tue, 09 Oct 2018 10:25:46 -0700 (PDT)
Received: from [192.168.1.4] (109-252-55-124.nat.spd-mgts.ru. [109.252.55.124])
        by smtp.gmail.com with ESMTPSA id z3-v6sm4843457ljb.71.2018.10.09.10.25.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Oct 2018 10:25:45 -0700 (PDT)
Subject: Re: CoW behavior when writing same content
To:     Chris Murphy <lists@colorremedies.com>,
        "Gervais, Francois" <FGervais@distech-controls.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <BN6PR01MB2531060A61AD3B85A93DF82CF3E70@BN6PR01MB2531.prod.exchangelabs.com>
 <CAJCQCtTAu8qrcB7cd3dKGstgSd32UjkWB5jZc5jbRJ0KXmHgRQ@mail.gmail.com>
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
Message-ID: <7ea431d5-2966-f0e5-9dec-882e46743a69@gmail.com>
Date:   Tue, 9 Oct 2018 20:25:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTAu8qrcB7cd3dKGstgSd32UjkWB5jZc5jbRJ0KXmHgRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

09.10.2018 18:52, Chris Murphy пишет:
> On Tue, Oct 9, 2018 at 8:48 AM, Gervais, Francois
> <FGervais@distech-controls.com> wrote:
>> Hi,
>>
>> If I have a snapshot where I overwrite a big file but which only a
>> small portion of it is different, will the whole file be rewritten in
>> the snapshot? Or only the different part of the file?
> 

If you overwrite the whole file, the whole file will be overwritten.

> Depends on how the application modifies files. Many applications write
> out a whole new file with a pseudorandom filename, fsync, then rename.
> 
>>
>> Something like:
>>
>> $ dd if=/dev/urandom of=/big_file bs=1M count=1024
>> $ cp /big_file root/
>> $ btrfs sub snap root snapshot
>> $ cp /big_file snapshot/
>>

And which portion of these three files is different? They must be
identical. Not that it really matters, but that does not match your
question.

>> In this case is root/big_file and snapshot/big_file still share the same data?
> 
> You'll be left with three files. /big_file and root/big_file will
> share extents,

How comes they share extents? This requires --reflink, is it default now?

> and snapshot/big_file will have its own extents. You'd
> need to copy with --reflink for snapshot/big_file to have shared
> extents with /big_file - or deduplicate.
> 
This still overwrites the whole file in the sense original file content
of "snapshot/big_file" is lost. That new content happens to be identical
and that new content will probably be reflinked does not change the fact
that original file is gone.
