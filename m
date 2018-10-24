Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD14CC67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98960207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgPdx8eu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98960207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbeJXNUV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 09:20:21 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44582 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbeJXNUU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 09:20:20 -0400
Received: by mail-lf1-f67.google.com with SMTP id m18-v6so2885803lfl.11
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 21:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ca3QL15ZmVMZeWTr+zYDUodAGeAyx0eLglAOSK65KFI=;
        b=bgPdx8euFJLW7ZeDoLGL+X1mOLteMd2/tdXdXv1VJaZFB6yUY3ssDpuePoeJm2iVPo
         0B9WNQjyETtFya0mDmn60PfyR2NBFgA7i1OgrqbKnFtRp5sSjOXGvz+o2uI4oomXrDgI
         SLOr8vMy5UuU9PB/Wz1/Ddv1uIqd4nPjBva01pvdS1CC02kQGoeEdYPKnJt5agEOZ6Ax
         aS2iSrgm+9in+i7y5fpnXd8woa/nZCGU0rb999Vy/UNV1xkdiLLzYI6nPfj24k4mjv/Z
         4c6E8/o7aF+nKrYGbRdSj4hVaDOkE69BIhOtzE7+1qR5tJ6YWoyqdXk8jEOIHCGY/ypl
         lG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ca3QL15ZmVMZeWTr+zYDUodAGeAyx0eLglAOSK65KFI=;
        b=V90W/YR3dBlZrjq91GD9lWv7Ty66KuZvgGWAPmmEXhvah3g+aatKnwjp8SkjOiM9mQ
         MCK8mv0LQyObyc/xWFJiMP6Lux52W3H4ggohUI57fBfsftOn2e5dJg+JS8n1NpQSXkgG
         5tOs+HngBi4afIVvt55pC28tzzbdwGmiSEgwlwnwUO2wYM5p3wXa9WwM4ykcuLnPR/c/
         Fgtw8e63gAJ0saSDgxsddYzYcg9jfFJ3y6v4I44FvuyhKs6+wjTMLZIvWmlkDrre87PZ
         DIPd0hXKdj7bs6FDJ+WQKydYOn4OegmcEsssW4eUW6s0HtY4ym0eUEAJtNhZuFxfxTKu
         zTMw==
X-Gm-Message-State: ABuFfoh8Wlfsl4cUF2dDLpBrDRv/ogWmP+X5AlviOV/ZDnUnPRR4Z9mq
        OAh9OaDnMMd7+s1lXNbtv1NdnsTAdo4=
X-Google-Smtp-Source: ACcGV60pI4kZPoKxzP0uQJ3hTmnyvBIa/3VV39wUzJNAsQpQ1F0bGKHofzdAD6KiVLKp605SprIEuw==
X-Received: by 2002:a19:5186:: with SMTP id g6mr13446958lfl.143.1540356831918;
        Tue, 23 Oct 2018 21:53:51 -0700 (PDT)
Received: from [192.168.1.4] ([109.252.55.124])
        by smtp.gmail.com with ESMTPSA id c22sm407201lfd.88.2018.10.23.21.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 21:53:50 -0700 (PDT)
Subject: Re: Have 15GB missing in btrfs filesystem.
To:     Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
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
Message-ID: <d057f534-df7f-d1bc-bdef-9b794aaf3492@gmail.com>
Date:   Wed, 24 Oct 2018 07:53:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

24.10.2018 3:36, Marc MERLIN пишет:
> Normally when btrfs fi show will show lost space because 
> your trees aren't balanced.
> Balance usually reclaims that space, or most of it.
> In this case, not so much.
> 
> kernel 4.17.6:
> 
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 186.89GiB
> 	devid    1 size 228.67GiB used 207.60GiB path /dev/mapper/pool1
> 
> Ok, I have 21GB between used by FS and used in block layer.
> 
> saruman:/mnt/btrfs_pool1# btrfs balance start -dusage=40 -v .
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=40
> Done, had to relocate 1 out of 210 chunks
> saruman:/mnt/btrfs_pool1# btrfs balance start -musage=60 -v .
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=60
>   SYSTEM (flags 0x2): balancing, usage=60
> Done, had to relocate 4 out of 209 chunks
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 186.91GiB
> 	devid    1 size 228.67GiB used 205.60GiB path /dev/mapper/pool1
> 
> That didn't help much, delta is now 19GB
> 
> saruman:/mnt/btrfs_pool1# btrfs balance start -dusage=80 -v .
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=80
> Done, had to relocate 8 out of 207 chunks
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 187.03GiB
> 	devid    1 size 228.67GiB used 201.54GiB path /dev/mapper/pool1
> 
> Ok, now delta is 14GB
> 
> saruman:/mnt/btrfs_pool1# btrfs balance start -musage=80 -v .
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=80
>   SYSTEM (flags 0x2): balancing, usage=80
> Done, had to relocate 5 out of 202 chunks
> saruman:/mnt/btrfs_pool1# btrfs fi show .
> Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> 	Total devices 1 FS bytes used 188.24GiB
> 	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1
> 
> and it's back to 15GB :-/
> 
> How can I get 188.24 and 203.54 to converge further? Where is all that
> space gone?
> 

Most likely this is due to partially used extents which has been
explained more than once on this list. When large extent is partially
overwritten, extent is not physically split - it remains allocated in
full but only part of it is referenced. Balance does not change it (at
least that is my understanding) - it moves extents, but here we have
internal fragmentation inside of extent. Defragmentation should rewrite
files, but if you have snapshots, it is unclear if there will be any gain.

I wonder if there is any tool that can compute physical vs. logical
space consumption (i.e. how much space in extent is actually
referenced). Should be possible using python-btrfs but probably time
consuming as it needs to walk each extent.
