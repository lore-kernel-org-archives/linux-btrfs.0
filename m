Return-Path: <SRS0=+2iJ=SX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62BDC10F14
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Apr 2019 04:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87FC32087B
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Apr 2019 04:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ok2JnBcs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfDUEkF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Apr 2019 00:40:05 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:46765 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfDUEkF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Apr 2019 00:40:05 -0400
Received: by mail-lj1-f169.google.com with SMTP id h21so7660213ljk.13
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 21:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GkGLgxdL/6NA9WjzuvdED02yF5J/v67fzfv2kWzYyWM=;
        b=ok2JnBcsNxu+ULLWqE8wI+8IqXRZzzB9wLd1s3rHEN49T44PmBlFnAfmb38/dl6yj2
         YfYMbB/CEZZvW8b+S2ziSjD38Wy2XFez2eV0NzXiPRQQuGo35MrCV+QKi1crUCoXEmS1
         kxR/TqY6n/p5xYMx6zG60iwuv/YDxQuSGvSXf+X6Uhp3UpircS2otfQZAOXjIotN/vwS
         0JwKrUQiSY6GiY+YiJ700juHZg1LtwCK4P6lGWonoVUFePfOWiQADJ9tiWznZJHggZFT
         GfIfTtov5QSg9I7cDIoruoSlkVw9X9N2du4VQ4oLuZ3hNxSBPwG2ENbJoLWr1sQWsoQW
         +sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GkGLgxdL/6NA9WjzuvdED02yF5J/v67fzfv2kWzYyWM=;
        b=cmF+M30zp98PjuuaH+74EVui1sC5RkJp0vZoDZyzI16P0cSCY5U4bI+xJkN4z7OOYU
         Y2DVgFh8pJeLI/AdKUUM2iTAppWdbhGHc4Rt8VxBK6xkXshJl+u1RD37T6bqZeQF/dXx
         6ocRjVZ+0VyidR8CQ8BNpxL0onQrSTI+5ynNjwfbs04J5l93jGJpKrPuAMhveb8wdFCA
         d1XJ7Fedx7k6f28a23K7Wgj7ha+vewVhezaTQ33UgL0eivd9EHCmzpCWnJ2iOVSrrAfz
         SY3Gu0qY1n8WmmwTOuFf06N629I6Hg5RdVD7GTbxeS10E+oA4KUxpvoQP9d/hfsQLRvz
         VELg==
X-Gm-Message-State: APjAAAUd9Xg0rsfn7Z99Zp4a5nJ4FmYZt9MRJZiK7G1oBZpPk0AE9fGt
        EDGqVOHxeP4CvWV6dC7TW3nH+K2b
X-Google-Smtp-Source: APXvYqy/RGqTDK5YjxmsynB9PBpTdZKleS2evfsNaNwFrC62t9PNR5pJqvMToF2b6Sb2tk3/H073lQ==
X-Received: by 2002:a2e:8108:: with SMTP id d8mr5769963ljg.57.1555821602644;
        Sat, 20 Apr 2019 21:40:02 -0700 (PDT)
Received: from [192.168.1.5] ([109.252.90.193])
        by smtp.gmail.com with ESMTPSA id 63sm2268933lfz.2.2019.04.20.21.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Apr 2019 21:40:00 -0700 (PDT)
Subject: Re: BTRFS Raid 5 Space missing - ideas ?
To:     Adam Borowski <kilobyte@angband.pl>,
        Juergen Sauer <juergen.sauer@automatix.de>
Cc:     linux-btrfs@vger.kernel.org
References: <cac3618d-8153-66c1-446a-0040b7142c6a@automatix.de>
 <20190420201913.GA3306@angband.pl>
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
Message-ID: <02b7c96d-8ac6-ec2d-e2b8-8fa46d4e310b@gmail.com>
Date:   Sun, 21 Apr 2019 07:39:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190420201913.GA3306@angband.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

20.04.2019 23:19, Adam Borowski пишет:
> On Sat, Apr 20, 2019 at 12:46:16PM +0200, Juergen Sauer wrote:
>> I wish a happy Easer Days before :)
> 
> Same to you!
> 
>> During my tests with BTRFS as Raid5 setup, I found a courious little
>> "problem".
> 
>>         Total devices 3 FS bytes used 9.98TiB
>>         devid    1 size 9.09TiB used 4.99TiB path /dev/sdb1
>>         devid    2 size 5.46TiB used 4.99TiB path /dev/sdc1
>>         devid    3 size 5.46TiB used 4.99TiB path /dev/sde1
> 
>> All patitioins sdb1 sdc1 sde1 are the same size: 9.0 TiB. But BTRFS ist
>> not using the bigger space on sdc1, sde1, there is only 5.46 TiB used,
>> even there are 9.0 Tib Avaible, so 4.0 TiB are unused.
> 
> It's working as expected: while btrfs does RAID per block group rather than
> per whole block device, there's no way to place a raid5 block group in a way
> that doesn't require at least 3 devices.  This means with a 3-disk setup the
> space utilized will be only as big as the smallest one.
> 

But as reported, all drives were replaced by larger ones but only one
drive shows increased size: "All patitioins sdb1 sdc1 sde1 are the same
size".
