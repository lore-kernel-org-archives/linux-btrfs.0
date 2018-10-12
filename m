Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A82FC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 10:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9FB42086A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 10:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9FB42086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=t-5.eu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbeJLRgh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:36:37 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43444 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbeJLRgh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 13:36:37 -0400
Received: by mail-ed1-f65.google.com with SMTP id y20-v6so10958661eds.10
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 03:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date:from
         :to:cc:subject:in-reply-to:references:message-id:user-agent;
        bh=ojxcug2f21dfAaFnzrXP8hqj7N3Pbi7OvFSUye/ZmJc=;
        b=PVOnIS79lfskvgC5UpE67oqnVZTDHBm+Po54Lc48dodyJc/F+SuIrhNwEwHCCd5dxF
         ZK6yCUfwk+c4BMPHaqKB11Sip8J1DWLz67STKQ4/bdA6tnv5e62efrB1XEs2FDHdMUd4
         eaFpQl2PS3sU/fI/6+B7RYWzl6pQMM/LWOoVl/iwugtX6miDFNCeOjy2Z0b/bRCKAm6o
         OrXI0R0UZHipayw6VnVNuJz4FN6aE89Z/lpr/eYYP66vD9Z9DCUsCaKyZqiLPhZkvRbB
         SdXIKlhR493QojJr/em33AwmBZMrHpVraR1Wkuv5p0CWakT9WuUF6WgZ88dpwQsG2X2S
         i9dw==
X-Gm-Message-State: ABuFfoi7mqXTRUAc5cfbgoDbPVrjWARiTfSMTxUMPAB8SVm2DsYaFQNX
        lL8WHbvFW4/Y0wJQ7g4UHHY=
X-Google-Smtp-Source: ACcGV61VhMnaDeeCclzTZpGRw2kaEM4BZHqXTXgSdpUIIFZ9R1HXxAmY6U0Tzfv0h8G51AzSUqGt+Q==
X-Received: by 2002:a50:8fa4:: with SMTP id y33-v6mr8141712edy.131.1539338696628;
        Fri, 12 Oct 2018 03:04:56 -0700 (PDT)
Received: from t-5.eu (p5B283B56.dip0.t-ipconnect.de. [91.40.59.86])
        by smtp.gmail.com with ESMTPSA id b14-v6sm407124edc.17.2018.10.12.03.04.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:04:55 -0700 (PDT)
Received: from t-5.eu (localhost [127.0.0.1])
        by t-5.eu (Postfix) with ESMTP id 944531AD420;
        Fri, 12 Oct 2018 12:04:54 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 12 Oct 2018 10:04:54 +0000
From:   =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: errors reported by btrfs-check
In-Reply-To: <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
 <2e6c6c01-5b29-ebdb-e0d7-ebf85e4993dd@gmx.com>
Message-ID: <be6da685dcf872fcb60b6258a6f20ceb@t-5.eu>
X-Sender: t-5@t-5.eu
User-Agent: Roundcube Webmail/1.3.6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am 12.10.2018 01:56, schrieb Qu Wenruo:
> On 2018/10/12 上午4:30, Jürgen Herrmann wrote:
>> Hi!
>> 
>> I just did a btrfs check on my laptop's btrfs filesystem while i was
>> on the usb stick rescue system.
>> 
>> the following errors where reported:
>> root@mint:/home/mint# btrfs check /dev/mapper/sda3crypt
>> Checking filesystem on /dev/mapper/sda3crypt
>> UUID: a914c141-72bf-448b-847f-d64ee82d8b7b
>> checking extents
>> checking free space cache
>> checking fs roots
>> root 258 inode 3082368 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 258 inode 3082370 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 258 inode 3082371 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 258 inode 3082373 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 258 inode 3082414 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 258 inode 3082415 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 258 inode 3082421 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> root 1387 inode 3082368 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1387 inode 3082370 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1387 inode 3082371 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1387 inode 3082372 errors 100, file extent discount
>> Found file extent holes:
>>     start: 8192, len: 4096
>>     start: 16384, len: 4096
>>     start: 24576, len: 4096
>>     start: 32768, len: 4096
>>     start: 40960, len: 4096
>>     start: 49152, len: 20480
>>     start: 73728, len: 4096
>>     start: 81920, len: 4096
>>     start: 90112, len: 8192
>> root 1387 inode 3082373 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1387 inode 3082374 errors 100, file extent discount
>> Found file extent holes:
>>     start: 8192, len: 4096
>>     start: 16384, len: 20480
>>     start: 40960, len: 12288
>>     start: 57344, len: 4096
>>     start: 65536, len: 8192
>> root 1387 inode 3082380 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 233472
>> root 1387 inode 3082386 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> root 1387 inode 3082398 errors 100, file extent discount
>> Found file extent holes:
>>     start: 20480, len: 16384
>> root 1387 inode 3082414 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1387 inode 3082415 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1387 inode 3082421 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> root 1391 inode 3082368 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1391 inode 3082370 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1391 inode 3082371 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1391 inode 3082373 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1391 inode 3082386 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> root 1391 inode 3082414 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1391 inode 3082415 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1391 inode 3082421 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> root 1394 inode 3082368 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1394 inode 3082370 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1394 inode 3082371 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1394 inode 3082373 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1394 inode 3082386 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> root 1394 inode 3082414 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1394 inode 3082415 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 8192
>> root 1394 inode 3082421 errors 100, file extent discount
>> Found file extent holes:
>>     start: 0, len: 4096
>> ERROR: errors found in fs roots
>> found 469458231296 bytes used, error(s) found
>> total csum bytes: 451180560
>> total tree bytes: 4558831616
>> total fs tree bytes: 3802955776
>> total extent tree bytes: 245055488
>> btree space waste bytes: 842802897
>> file data blocks allocated: 9656815640576
>>  referenced 929225080832
>> 
>> Scrub completes ok though.
>> 
>> I'm prepared to wipe the fs if needed, more than one backup is ready 
>> :)
> 
> No need. File extent discount is not a big problem.
> 
> It only means btrfs lacks some hole file extent to fill the hole.
> 
> It can be "fixed" easily by enabling no_holes features:
> 
> # btrfstune -n <device>
> 
>> 
>> I wanted to ask here first if I should attempt a repair.
> 
> And of course, btrfs check --repair should be able to fix it.
> 
> Thanks,
> Qu
> 
>> 
>> Best regards,
>> Jürgen

Hi there!

I ran btrfs check --repair on the filesystem. I dont' have this log 
anymore,
as it was then sitting on the repaired fs), which is now dead.
after repairing it I could still mount the fs.

as my btrfs send problem still persists (another thread), I decided to 
run check
again... this time i saved the logs to a different partition as it was 
more
convenient at that time. here's the output:

Checking filesystem on /dev/mapper/sda3c
UUID: a914c141-72bf-448b-847f-d64ee82d8b7b
[1/7] checking root items
Fixed 0 roots.
[2/7] checking extents
No device size related problem found
[3/7] checking free space cache
cache and super generation don't match, space cache will be invalidated
[4/7] checking fs roots
root 1387 inode 3082380 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 233472
ERROR: errors found in fs roots
found 470636822528 bytes used, error(s) found
total csum bytes: 452176524
total tree bytes: 4579753984
total fs tree bytes: 3822665728
total extent tree bytes: 245301248
btree space waste bytes: 847442809
file data blocks allocated: 9670623588352
  referenced 932405829632

I did a repair once again but the error did not go away.

after rebooting the fs is no longer mountable:
mint@mint:/tmp$ sudo /tmp/btrfs check /dev/mapper/sda3c
Opening filesystem to check...
parent transid verify failed on 166475366400 wanted 127054 found 127060
parent transid verify failed on 166475366400 wanted 127054 found 127060
Ignoring transid failure
ERROR: child eb corrupted: parent bytenr=166456229888 item=22 parent 
level=2 child level=0
ERROR: cannot open file system

If anyone wants me to help debugging this issue you will have to respond
fast, because i need my laptop back in working condition and will soon
nuke the fs. after all I will try one more time with a freshly formatted
btrfs partition. if i still get these kinds of errors i will have to 
move back to
the tried and true xfs :/

best regards,
Jürgen
-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
