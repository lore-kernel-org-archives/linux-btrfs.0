Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EDFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 11:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C669B206DD
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 11:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOEAGSKJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfDALzs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:55:48 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40361 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDALzs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 07:55:48 -0400
Received: by mail-it1-f196.google.com with SMTP id y63so14699064itb.5;
        Mon, 01 Apr 2019 04:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GAtnZVsq43buRcawG33U5wTp9JD/QYMtT4DBSiQC68E=;
        b=aOEAGSKJkbtgSpEnHJtmQCp0S4SVECQ/lc7GQZSk9uQWL0UFOLD4/jyHG7NIfk39Ku
         RZsrioWnK5sv6mkGGbgz5LDGLdF7weziQPsucQgTBiTqfxCUt8bx1unpmxks1Y6FCYLD
         Bkd+/ZlSVAFC58mQwSM/MORT12WhSlNubn7nwwCfF/79jQmF1hjLPACrC26MrChLcPfz
         migKlvDkcoLqVqYked5AANW7uG8seZpMV+CkCDV0x+G1iMdDrFwuQ4cDyf6JXLUx3d+S
         JfIonoEVPCTlbFOMrcpMwGFJMwgvfbXhkC8V9zxHrnV6Yt1eyBEYOJwYYJdTulTHBSN6
         jb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GAtnZVsq43buRcawG33U5wTp9JD/QYMtT4DBSiQC68E=;
        b=bl3ypj0Qc+a4KfTmPJb3v7oR/cmasi1kBNiUyozt28NwFC3e8c7dB6KQyFdeKJNix0
         Tcr7v8XDjcAjuWWo5w8mXseKcwCCaSUNKyn9Yf5O81ud9nw5t4/cDL5bCtOwklkAODH7
         N0otzGaMb/D9j27RTqZSQzRujM/BHp8jix+seVClQ1ztn6G1ARLO8zJKlV83M3fp1lLF
         wKbmeLDZX+2Pj47SK3hUdY//CDaLxjKmC0Q4XoBIPKJXKZS0h56z1zzIrur0CJefZ8be
         4KUUnpqImW+vUmv9nBnBeyd02ggc//3cveU8+BWvBmSSUHTCUlI4mF2u+LntXISFzjMV
         ymXQ==
X-Gm-Message-State: APjAAAX7YZnwmmHefuLPbZVn/u5OOVa1FUYDNgsvx4ibsOr1Bk2D+CLO
        6fJmvP0Wl7Wz6EGt8MQ1cmrkPH9YXZM=
X-Google-Smtp-Source: APXvYqwxv+P3h7Y8MrvaFyoRezq2n43YtPX4pZ77qPnb/Q+K1C6Iyf24DOTkD2co+2UnMOi0jHzpCg==
X-Received: by 2002:a02:3506:: with SMTP id k6mr18954109jaa.41.1554119747211;
        Mon, 01 Apr 2019 04:55:47 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f204sm5596421itc.26.2019.04.01.04.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2019 04:55:46 -0700 (PDT)
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Alberto Bursi <alberto.bursi@outlook.it>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5f58328a-8b9a-3a78-0e2f-45e1e1e62685@gmail.com>
Date:   Mon, 1 Apr 2019 07:55:42 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-03-31 07:27, Alberto Bursi wrote:
> 
> On 30/03/19 13:31, Qu Wenruo wrote:
>> Hi,
>>
>> I'm wondering if it's possible that certain physical device doesn't
>> handle flush correctly.
>>
>> E.g. some vendor does some complex logical in their hdd controller to
>> skip certain flush request (but not all, obviously) to improve performance?
>>
>> Do anyone see such reports?
>>
>> And if proves to happened before, how do we users detect such problem?
>>
>> Can we just check the flush time against the write before flush call?
>> E.g. write X random blocks into that device, call fsync() on it, check
>> the execution time. Repeat Y times, and compare the avg/std.
>> And change X to 2X/4X/..., repeat above check.
>>
>> Thanks,
>> Qu
>>
>>
> 
> Afaik HDDs and SSDs do lie to fsync()
> 
> unless the write cache is turned off with hdparm,
Nope, not the case on modern Linux.  The issue here was that Linux did 
not issue a FLUSH bio as part of the completion of an fsync() system 
call, and problem has long-since been fixed (and wasn't actually the 
disk lying, but the kernel).
> 
> hdparm -W0 /dev/sda
> 
> similarly to RAID controllers.
And most RAID controllers don't actually lie either.  The SCSI and ATA 
standards both count a write that is stored in a _non-volatile_ cache as 
completed, and any halfway-decent RAID controller will be using some 
form of non-volatile storage for it's cache (classically battery-backed 
SRAM, but there's been some shift to NOR or NAND flash storage recently, 
and I've seen a couple of really expensive ones using more-exotic 
non-volatile storage technologies).
> 
> see below
> 
> https://brad.livejournal.com/2116715.html
> 
> https://queue.acm.org/detail.cfm?id=2367378
