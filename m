Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52499C10F00
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20213222DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnGZYpsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733028AbfBPUIO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 15:08:14 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:44801 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfBPUIO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 15:08:14 -0500
Received: by mail-lj1-f178.google.com with SMTP id q128so11119942ljb.11
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 12:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZOxZ49sx3l+UuQeI+YkdJMZsx+/Tra12T/X988M546M=;
        b=XnGZYpsrhx/rLx8lWj1kYbPRSGSNy5hLAOAwzZn9WiSReELGCQBDTSdnIEK8v3TKa0
         tPtUqCl0ABzrT9tqAuxjLJPR7h8NQAQJIQ1Tl85CogM4dAVkMm2UcKbyKiYoI1/mr8SI
         +pHgOztOcl4vBLI5YCtImfp2461/uXT5ZsUZ0YMfGPtr+LKLBcyXtVpwPKoK7n7EXHnA
         w5/mWjL18Uv9M8sS2rBpkwjLAZIG6EppfoDEWZesXYFWRzq5/MawcmyAYYHOOQZu46bm
         Vcsf7htjIEcbpmcoij0YJ95bmh2VdXgSew1iPdt5jengj6ARHzcydtu1aKtedUQE5BIV
         H1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZOxZ49sx3l+UuQeI+YkdJMZsx+/Tra12T/X988M546M=;
        b=VRPctWfdPQH09zIJHIwJqca6K86kV9t7nfTHXLCdiYDPIaLIEzSj8Ijv5gkw3IyKE+
         o8WzxlpQvPqKV3uNWhrgRiUYOgGxC4YAfyv1BfXrkuiG9asgs01ggf2KSdWjU6uCcLRk
         sVDAk/eu8kxGxPj8I6Oi2utqg0OcQuC5q2d+LYyq6XGff62tlEwQKHXYhfEWRPhBL2wW
         Oco5x6hTzNmnyzK9HgT3UIU3Fve5jTLK43mElmgyRRC6XvhrL47ISml5TRbeyBs1vh9K
         sbXFHc8xjBAK1V9/6t0o1q839RSPgmE0jib1l6YYsV8ComajlbvLklYqir/pn4rRbmha
         sC+w==
X-Gm-Message-State: AHQUAua1/6t5QHbdZ8bcVKVrT0fW/kF+et/5+Pkmhhpl4kBvBrh2g4YG
        gTC6MxpZ3mcE0Pn/P6wAWgR3sTk8
X-Google-Smtp-Source: AHgI3Iapv5mljCiI7GLVsDuYCVd3SGAtPqPUU40bHh4r2KUSo3RCPXxdai1DNPE12kcw3+DTsnh8Rg==
X-Received: by 2002:a2e:2d4:: with SMTP id y81-v6mr9377152lje.62.1550347691588;
        Sat, 16 Feb 2019 12:08:11 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id b191sm2417930lfd.56.2019.02.16.12.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 12:08:10 -0800 (PST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
        linux-btrfs@vger.kernel.org
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
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
Message-ID: <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
Date:   Sat, 16 Feb 2019 23:08:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

14.02.2019 14:37, André Malm пишет:
> Hello,
> 
> I'm not sure this is the right forum to ask on but I'll try and if its
> not I do apologize. I have also created a stack overflow question
> without success (
> https://stackoverflow.com/questions/54634703/btrfs-send-with-parent-different-size-depending-on-source-of-files
> ) but ill paste the question here too. Thank you.
> 
> What i'm trying to achieve is sending only the diff of the parent with
> btrfs send -p
> 
> Running this will produce a file 'out' with size 639 bytes, i.e only
> diff sent.
> 
> ====================================================
> 
> btrfs subvolume create A
> btrfs subvolume create B
> mkdir A/dir
> 
> dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=40K
> cp --reflink=always A/dir/server.jar B/server.jar
> 
> btrfs subvolume snapshot -r A a
> btrfs subvolume snapshot -r B b
> btrfs send -p a b > out
> 
> ====================================================
> 
> However if I change the dd command to wget like this:
> 
> ====================================================
> 
> btrfs subvolume create A
> btrfs subvolume create B
> mkdir A/dir
> 
> wget -O A/dir/server.jar
> https://launcher.mojang.com/v1/objects/20c069d373e77265aaeeedb733f7051e294325a3/server.jar
> 
> cp --reflink=always A/dir/server.jar B/server.jar
> 
> btrfs subvolume snapshot -r A a
> btrfs subvolume snapshot -r B b
> btrfs send -p a b > out
> 
> ====================================================
> 
> 
> The 'out' file is 34M, which is the full size.
> 
> What causes this?
> 
> 

File size of "real" server.jar is not exact multiple of btrfs block size
(4096) which causes the last extent to be "incomplete". btrfs won't
clone extent in this case. You can trivially reproduce it by using the
same size in the first case (although exact extent distribution may be
different of course, in the worst case you get single extent which is
sent in full):



dd if=/dev/urandom of=A/dir/server.jar bs=1024 count=34625
