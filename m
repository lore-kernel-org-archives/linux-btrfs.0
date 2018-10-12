Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F68C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 10:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDEE2077C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 10:35:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FDEE2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=t-5.eu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbeJLSHI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:07:08 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:35665 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeJLSHI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 14:07:08 -0400
Received: by mail-ed1-f44.google.com with SMTP id y19-v6so11052034edd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 03:35:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date:from
         :to:cc:subject:in-reply-to:references:message-id:user-agent;
        bh=UBlxppyEe5uulhaH1nT6CWTyiKZnbbt4P3OvQ8KhviU=;
        b=tN3GQpImWQSU5qbZHPGa5tDktOcCsSlAABW/VyCbO9C0Oap5Tmo7+qmh9pBf4SqMvA
         UYDsm+OK4u7QiGtrSkxacqosNBlsvI7E+M1KHC1cI8DCArJWEsB1tiKFizBSfqH18nmX
         H9L+E4zVeUt5It6I8SfgxDErD5YqAM9BvHLOJGu420YI3/nLRV/3Nvs3jME7EfqnaXd1
         yZc+tT/d1WCU22eNkB7VLMDGkwV/rqSYxkoqS4n8R+zn91oEiB2MfxJsID7GVeiEhBOC
         vFQywTDR+l8PAH1toFtjC1a/wssP7iyN565dawEzU16Z7Lowrt9muCjulM7lkcZA0wUs
         +Rbw==
X-Gm-Message-State: ABuFfoh6iG5+tGEztxiFQJHvYScUWaO+VPzlglWsEjfFkaRAh6Eei4gh
        7ACnvW6DOCQozu6cr2Cq0ryQBUED
X-Google-Smtp-Source: ACcGV63pOO8zF/u5iEIWG2WxhDTCuC6VC/0JcbidFYXS5ATmsX2bc9x8mgwKWOi+t6S06E3+06u1zg==
X-Received: by 2002:a50:b519:: with SMTP id y25-v6mr8219227edd.24.1539340520821;
        Fri, 12 Oct 2018 03:35:20 -0700 (PDT)
Received: from t-5.eu (p5B283B56.dip0.t-ipconnect.de. [91.40.59.86])
        by smtp.gmail.com with ESMTPSA id l42-v6sm450252edb.24.2018.10.12.03.35.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:35:20 -0700 (PDT)
Received: from t-5.eu (localhost [127.0.0.1])
        by t-5.eu (Postfix) with ESMTP id 092571AD5BD;
        Fri, 12 Oct 2018 12:35:19 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 12 Oct 2018 10:35:18 +0000
From:   =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: errors reported by btrfs-check
In-Reply-To: <979a7a81-6ffc-b0b9-abf4-1ad1ecfcbcd2@gmx.com>
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
 <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
 <979a7a81-6ffc-b0b9-abf4-1ad1ecfcbcd2@gmx.com>
Message-ID: <1707cc15134893e4518115cf9ab42df3@t-5.eu>
X-Sender: t-5@t-5.eu
User-Agent: Roundcube Webmail/1.3.6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 12.10.2018 10:19, schrieb Qu Wenruo:

[snip]

> Please run the following command:
> 
> # btrfs ins dump-tree --follow -b 166456229888
> 
> It could be caused by the fact that btrfs-progs --repair doesn't handle
> log tree well.
> 
> If that's the case, "btrfs rescue zero-log" should help.
> 
> But anyway, feel free to re-create the fs if zero-log doesn't help.
> 
> Thanks,
> Qu

First of all, thanks for your help!

Did that:

root@mint:/home/mint# /tmp/btrfs ins dump-tree --follow -b 166456229888 
/dev/mapper/sda3c  > /tmp/btrfs-ins.txt
parent transid verify failed on 166475366400 wanted 127054 found 127060
Ignoring transid failure
WARNING: eb corrupted: parent bytenr 166456229888 slot 22 level 2 child 
bytenr 166475366400 level has 0 expect 1, skipping the slot

The created btrfs-ins.txt is ~300MB in size, so i did not attach that 
here. do you need id? then I can upload it to my owncloud and post a 
link here.

after that i tried to zero the log:
parent transid verify failed on 166475366400 wanted 127054 found 127060
parent transid verify failed on 166475366400 wanted 127054 found 127060
Ignoring transid failure
ERROR: child eb corrupted: parent bytenr=166456229888 item=22 parent 
level=2 child level=0
ERROR: could not open ctree

mounting is still not possible:
[ 2726.355134] BTRFS info (device dm-0): disk space caching is enabled
[ 2726.355138] BTRFS info (device dm-0): has skinny extents
[ 2726.395638] BTRFS error (device dm-0): parent transid verify failed 
on 166475366400 wanted 127054 found 127060
[ 2726.395647] BTRFS error (device dm-0): failed to read block groups: 
-5
[ 2726.451907] BTRFS error (device dm-0): open_ctree failed

Anything left to try?

Best regards,
Jürgen
-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
