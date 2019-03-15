Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F2EC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 03:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9712077B
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 03:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0Vs6TZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfCOD7i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:59:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46127 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfCOD7h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 23:59:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id z26so6479137lja.13
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 20:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hbFo7BpvqFY42rms9dpQJmYcmhWMoN6ABLqL7i6FwuA=;
        b=m0Vs6TZ1OmeuGtKbo6X6RR4N6wDJlTEGKUoO7ntNdomst1FiVTLdQfJPRSjejBvT6J
         kLPtNSfyVLK701fNWgdP/lOEiGQaxbfOQ8ig9FxHUk6sXuE3A/P3DoyRPtT8S6ZZMCUJ
         HfGGSx3OteeiBlL0ika/f7Y6F207htbFaQFVQHPPI3L4hObS4Vnn7oTyfS2Hlsf3a5zP
         209j1Gom5CPiTAkx3AyQc3PiEdhUWP/HzwN7wE4o2pk+auCiXyVjhZq1BKAWU4+yzXId
         2JW7ODWhTakyEykwBDUWLvcwWScYx/JnGw8LsDlK4n0JSE7ULYHBeYJ+LbK7Ws7fp/2N
         AMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hbFo7BpvqFY42rms9dpQJmYcmhWMoN6ABLqL7i6FwuA=;
        b=fECTVQPUgUVyCx6EMD7FwmY22cOu0XUGutRBSbDQAzDLiSshKi2eIcBTatrdM4/RpX
         xNHAFpnvNcpP/MxL76c3Q941AeeRfRGFqzR1bFNFIdPfGQZhYUAyreLR/+a4xMcuRsct
         Jn9qenFQcp01ZgFUK0glTnqngBym2Vszexu/Adm89NSr+WivohdanlNBXA4AZlqgBLEo
         WGFeGQB+KrNndEZk6SRJkwzCbSK34tu1OnGkOqlcqi9qfFU148XsDyxRk38VJTM6fLpY
         6dEW5BM4HV3ITtBuuY7GZVNb5kiAJ0Bk51tsO3NxCUqOySESYMN/b0NVe43i8Qtwr58g
         tQvQ==
X-Gm-Message-State: APjAAAUgYGEDUiJD7PKdLFHd5KjLFeLqZbaZBSFuJ11uDGTRi89r0h3p
        jAuL6S0qnGSSQpiWyludb49pahtY7YA=
X-Google-Smtp-Source: APXvYqyKrgrGS9jm/eEnTbadBgPahMpCutFhGdwWPuWt/HhxjWwuMN4owl3k+C5df0T1QpX7gVdCzw==
X-Received: by 2002:a2e:965a:: with SMTP id z26mr691917ljh.59.1552622375209;
        Thu, 14 Mar 2019 20:59:35 -0700 (PDT)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id d23sm185892lfc.11.2019.03.14.20.59.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 20:59:33 -0700 (PDT)
Subject: Re: mounting raid1 btrfs - occasional devid missing / open_ctree
 failed
To:     Michal Soltys <soltys@ziu.info>,
        Hans van Kranenburg <hans@knorrie.org>,
        linux-btrfs@vger.kernel.org
References: <b6e6db9d-c81a-498b-508e-581f924ff573@ziu.info>
 <eb16d309-7e81-8afb-ae2c-bd93862e1ace@knorrie.org>
 <ff6e0ace-72fb-0dc0-8fdb-8e12b2907680@ziu.info>
 <964e3bcd-730a-c186-c0e1-cd538a3c0e83@ziu.info>
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
Message-ID: <49202dac-6ae2-b49f-f946-a64dce3115a3@gmail.com>
Date:   Fri, 15 Mar 2019 06:59:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <964e3bcd-730a-c186-c0e1-cd538a3c0e83@ziu.info>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

14.03.2019 19:17, Michal Soltys пишет:
> On 3/14/19 5:09 PM, Michal Soltys wrote:
>> On 3/14/19 4:57 PM, Hans van Kranenburg wrote:
>>> On 3/14/19 4:44 PM, Michal Soltys wrote:
>>>>
>>>> <cut>
>>>>
>>>> Occasionally, during reboots (all of them clean of course) I get:
>>>>
>>>> devid 2 uuid <uuid> is missing
>>>> failed to ready system array: -2
>>>> open_ctree faield
>>>>
>>>> Which drops me into initramfs commandline.
>>>
>>> It might try to mount before all disks are visible. This can happen when
>>> e.g. a raid controller needs a little bit more time to initialize.
>>>
>>> Try adding rootdelay=10 to your linux command line, or any other number,
>>> and then look at logging when booting (so no quiet on your linux command
>>> line).
>>>
>>
>> It remains unmountable from initramfs's commandline with both disks
>> (partitions) present. Filesystem is mounted formally via uuid, so it
>> needs both disks present before udev/blkid can pick the correct devices.
>>
> 
> E.g.
> 
> mount /dev/sdr2 /newroot -> fails
> mount /dev/sds2 /newroot -> ok
> umount /newroot
> mount /dev/sdr2 /newroot -> ok
> 

This implies that neither device was scanned with equivalent of "btrfs
device scan". After attempt to mount both partitions kernel is aware of
them and from now on it succeeds.

What "dmesg | grep -i btrfs" shows before and after these commands?

>>>> When that happens, one of the partitions is mountable, the other is
>>>> not.
>>>> Mounting the filesystem via the "good" one also fixes the "bad" one.
>>>>
>>>> Tested with 4.20.11 and 5.0.2 kernels.
>>>>
>>>> Any idea what could be wrong ?
>>>> Does btrfs require full umount via pivoted initramfs during shutdown ?
>>> Hans
>>>
>>
>>
> 

