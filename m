Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7A3C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 20:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7353420644
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 20:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7353420644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=t-5.eu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbeJLD7y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:59:54 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:38253 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbeJLD7y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:59:54 -0400
Received: by mail-ed1-f46.google.com with SMTP id c1-v6so9507432ede.5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date:from
         :to:subject:message-id:user-agent;
        bh=gAXYGGc9s+6H6BMn2G0bAZpBYcedTGd2B3kBUJtpVc4=;
        b=IsWOrm/dBQRHfOGpglX8LgfcXYMOO23HCgvs+fkqhTXWZ2g6sWtHB0oszzoa9PCYif
         sWCFNDOI5eE0l6XlOMf+R2pClueCrF2W2OCX0jU0V0pvrpvYLkQi2NwjGu90QMXNUJzM
         oZWran0NgzAefkc6p3HqgA9KgDfPKcYClQt+eVEJ3+o57l+AuXZR0IaSv0FW6bheEcc2
         cYHXkrgRnAMOxqKaLvyUtwhMa5+vedXS4W/8nRlYdEnjrESYt0/x4dlyLqU032NQLTIF
         Anhenw8tIovBJ+Xyai/eSDjL76+xg9kEj7+JO8goL7agTKXLLhHNhRHktWK44FsMDiJU
         hBvg==
X-Gm-Message-State: ABuFfoiUa6wNqp5nTS6LrrWXMIxvAPr10YmUzNjC3tAKJTVoXWiJLRsO
        sNC4/owMdsuXJ9Clyn5/lRuvWfXY
X-Google-Smtp-Source: ACcGV61BjtqAzVdozU2F8VWPiNHWsEBYq1WMjk7olYB1RpE1CMpXU0NRX49DjdM5aFN/TBLuz4iI7Q==
X-Received: by 2002:a50:86fd:: with SMTP id 58-v6mr5218421edu.15.1539289858339;
        Thu, 11 Oct 2018 13:30:58 -0700 (PDT)
Received: from t-5.eu (p5B2838F0.dip0.t-ipconnect.de. [91.40.56.240])
        by smtp.gmail.com with ESMTPSA id i19-v6sm5100487ejv.73.2018.10.11.13.30.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 13:30:57 -0700 (PDT)
Received: from t-5.eu (localhost [127.0.0.1])
        by t-5.eu (Postfix) with ESMTP id 5B2021AC499
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 22:30:56 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 11 Oct 2018 22:30:56 +0200
From:   =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To:     linux-btrfs@vger.kernel.org
Subject: errors reported by btrfs-check
Message-ID: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
X-Sender: t-5@t-5.eu
User-Agent: Roundcube Webmail/1.3.6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!

I just did a btrfs check on my laptop's btrfs filesystem while i was
on the usb stick rescue system.

the following errors where reported:
root@mint:/home/mint# btrfs check /dev/mapper/sda3crypt
Checking filesystem on /dev/mapper/sda3crypt
UUID: a914c141-72bf-448b-847f-d64ee82d8b7b
checking extents
checking free space cache
checking fs roots
root 258 inode 3082368 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 258 inode 3082370 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 258 inode 3082371 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 258 inode 3082373 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 258 inode 3082414 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 258 inode 3082415 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 258 inode 3082421 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
root 1387 inode 3082368 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1387 inode 3082370 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1387 inode 3082371 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1387 inode 3082372 errors 100, file extent discount
Found file extent holes:
	start: 8192, len: 4096
	start: 16384, len: 4096
	start: 24576, len: 4096
	start: 32768, len: 4096
	start: 40960, len: 4096
	start: 49152, len: 20480
	start: 73728, len: 4096
	start: 81920, len: 4096
	start: 90112, len: 8192
root 1387 inode 3082373 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1387 inode 3082374 errors 100, file extent discount
Found file extent holes:
	start: 8192, len: 4096
	start: 16384, len: 20480
	start: 40960, len: 12288
	start: 57344, len: 4096
	start: 65536, len: 8192
root 1387 inode 3082380 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 233472
root 1387 inode 3082386 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
root 1387 inode 3082398 errors 100, file extent discount
Found file extent holes:
	start: 20480, len: 16384
root 1387 inode 3082414 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1387 inode 3082415 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1387 inode 3082421 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
root 1391 inode 3082368 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1391 inode 3082370 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1391 inode 3082371 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1391 inode 3082373 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1391 inode 3082386 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
root 1391 inode 3082414 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1391 inode 3082415 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1391 inode 3082421 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
root 1394 inode 3082368 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1394 inode 3082370 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1394 inode 3082371 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1394 inode 3082373 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1394 inode 3082386 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
root 1394 inode 3082414 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1394 inode 3082415 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 8192
root 1394 inode 3082421 errors 100, file extent discount
Found file extent holes:
	start: 0, len: 4096
ERROR: errors found in fs roots
found 469458231296 bytes used, error(s) found
total csum bytes: 451180560
total tree bytes: 4558831616
total fs tree bytes: 3802955776
total extent tree bytes: 245055488
btree space waste bytes: 842802897
file data blocks allocated: 9656815640576
  referenced 929225080832

Scrub completes ok though.

I'm prepared to wipe the fs if needed, more than one backup is ready :)

I wanted to ask here first if I should attempt a repair.

Best regards,
Jürgen
-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
