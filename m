Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A31C10F05
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FFCF208E4
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 12:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y4GNetfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfDAME4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:04:56 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51193 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfDAME4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 08:04:56 -0400
Received: by mail-it1-f194.google.com with SMTP id q14so1876007itk.0;
        Mon, 01 Apr 2019 05:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FWmZ6v+E+z/q2UJ7igejy84L4+s8W8RrVDxcjfEt8Ro=;
        b=Y4GNetfnT5A4+itBpz6MO+5Zc1PVEosltmydrRiJp4C4ZGniRSRPf8RiG68wjaK1TU
         H4NGvlJKHEf7iAZJeKjf2+0JK+7jXHsuS4FDnuc1YIBg29VlT+30xmoT8j1Ll0lGFieZ
         ZZxKi2PgLfKew/dQ1zdeUJdLda1fBO744odPa4s3kL16Yb/KhdQPrKCKbqVrtOLawSp2
         SrGLAdbFggJwAhKCN3FC/8xnlcEzSlDzW4B+1uRFwNw/+dQsgvZ3lfsOVSVk3iiU2zvU
         oYLJuun227bIf0pjTOd74hScGlKgNGp0+rTPrhTv8TmZr0pbQoK0C5bTXifnS77ohet4
         dPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FWmZ6v+E+z/q2UJ7igejy84L4+s8W8RrVDxcjfEt8Ro=;
        b=fA9lEX0ji8CbYvnDPIUSOJ9mO+6utYGWD+wTBtRl1dHvsKV+uGHZf7hnbJHVtojWoY
         iGbq3I9KAbzn/11I0NT+cVcEmhJb+31yVqbdRijHjuOrhq0dSAThNvzxsPe7Un+6Ja0Y
         x0D9LzgVbeONdeUBWrtOay1OQ4SyCoISJ4u0adXJT+SjtZhZjn9MOQHg3I+12u0czMzH
         Fhdcu9ZdkRkULtYKLV0rhW0d5c27EbVzkeOKa1GTlJc9oQCCqguG3TMSsXWeuHEUlc3q
         iAoF0be+XueX3fifwiOInfTzWhjGWbsi6BqkCbP5HzS2YmdoiyBCvFFX/C6xom0EwBM1
         m88g==
X-Gm-Message-State: APjAAAUKDlTPyccZuXXWpy8asK/qyrBWU03Zh5avON3oTOG/QYoqVh5B
        NItcBPGKIBIjkSev4XcZC3Pltl74WrZqlg==
X-Google-Smtp-Source: APXvYqzbbwn1jjBVyblnA2jvWnghLkgC+6MnWzi6BJC4FzV4VnZ4474bkip4RANtyckG5bGuQsuVJA==
X-Received: by 2002:a02:ab90:: with SMTP id t16mr43897334jan.135.1554120295027;
        Mon, 01 Apr 2019 05:04:55 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id n4sm4260109ioh.52.2019.04.01.05.04.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2019 05:04:54 -0700 (PDT)
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e6f92cc0-de85-32b1-3cbb-5f380bce6c41@gmail.com>
Date:   Mon, 1 Apr 2019 08:04:51 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-03-30 08:31, Qu Wenruo wrote:
> Hi,
> 
> I'm wondering if it's possible that certain physical device doesn't
> handle flush correctly.
> 
> E.g. some vendor does some complex logical in their hdd controller to
> skip certain flush request (but not all, obviously) to improve performance?
> 
> Do anyone see such reports?
Some OCZ SSD's had issues that could be explained by this type of 
behavior (and the associated data-loss problems are part of why they 
don't make SSD's any more).

Other than that, I know of no modern _physical_ hardware that does this 
(I've got  5.25 inch full-height SCSI-2 disks that have this issue at 
work, and am really glad we have no systems that use them anymore).  It 
is, however, pretty easy to configure _virtual_ disk drives to behave 
like this.
> 
> And if proves to happened before, how do we users detect such problem?
There's unfortunately no good way to do so unless you can get the disk 
to drop it's write cache without writing out it's contents.  Assuming 
you can do that, the trivial test is to write a block, issue a FLUSH, 
force drop the cache, and then read-back the block that was written. 
There were some old SCSI disks that actually let you do this by issuing 
some extended SCSI commands, but I don't know of any ATA disks where 
this was ever possible, and most modern SCSI disks won't let you do it 
unless you flash custom firmware to allow for it.

Of course, you can always test with throw-away data by manually inducing 
power failures, but that's tedious and hard on the hardware.
> 
> Can we just check the flush time against the write before flush call?
> E.g. write X random blocks into that device, call fsync() on it, check
> the execution time. Repeat Y times, and compare the avg/std.
> And change X to 2X/4X/..., repeat above check.
> 
> Thanks,
> Qu
> 
> 

