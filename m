Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A6CC282DA
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 11:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0342073F
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 11:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=brunner-ninja.20150623.gappssmtp.com header.i=@brunner-ninja.20150623.gappssmtp.com header.b="J2+g0vuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfDOLo3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:44:29 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37023 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfDOLo2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 07:44:28 -0400
Received: by mail-wm1-f41.google.com with SMTP id v14so20026503wmf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 04:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brunner-ninja.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=rOKjsVOFEF/jR/DY1gC1Emw+/TXPB+nBnE/dqnrPePA=;
        b=J2+g0vuve6eQCg+emN83kyiI1XGNKg8z2pAfQDVc4T+wlfADC2zaCtoKf2GepQ8MDV
         YlVsZxb/CoCng55DeICb5g2ElLd/nCAReLnB+6Badv1v0AZ63dMunkTMppQOTEAT6czd
         Ld/FtIUxQfcFpaMFJHeiPO9DkOoeIiMqbyEYyVB6zs3UUPCcOiblWeIoBTsrZmk/gCJR
         ENJei4ezxqE5vvxpTaRcDUmk3gZ27Ex1wiypRwkeYWcCDyZBjE8NlTaguwk9q8S+JxWE
         KtHJRPsoEQnpY69Tr6LN75fr59eTj2HzYLDOLOdQYZgfm28NXmvLCdPOm12jPUZMyNgu
         PnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=rOKjsVOFEF/jR/DY1gC1Emw+/TXPB+nBnE/dqnrPePA=;
        b=FH+Yrs5bvyO9hDRbT2iSxBNAFmZgJc/ms0wcQ7clCxraCCVDr/yPnjwiFSNsh3FN7w
         xRGn1A0a40NsupELD8W1U5GgnWsriZQaWR4B9LJbBvlvkXCaQEqchFbXPQ4Jr9SEWgBh
         URyLApM4ggqjNJQD29GKk3ybhL/yKc9yEDbZCj7soJG+3xDxuZ3J+s8LM1FHXCXLq71L
         2d43s2Z5b7IyC6fqcXqRnnC0Sv36GNqzhW8tsmrrlAC9R0vp+yf+598y3/pljU/J4BoY
         pNFMNOODJITRXBaFjcxWmyp5v6+8k0dRfq9GQptY8jQwQPqY4VnXaXt5nrz1NbLoMXA8
         qkqg==
X-Gm-Message-State: APjAAAXvEySTysJY3nNOxktL3+fYJdT7P4y+/cvRAAjTgUyS7PKPPh/P
        ZDcfBqa1YxBZ6tRRoB3yTAQZGTsPDXvKrDC0KB9xTyY1
X-Google-Smtp-Source: APXvYqzlduw29OMt+3GPthE/P0HobhHKslSwzI4BinP3ZhDQkEkKm4H5Zdpw9GRHXu2hK5X2D8+WH7cWBBLPkfDb8sw=
X-Received: by 2002:a1c:96d5:: with SMTP id y204mr21528830wmd.22.1555328667049;
 Mon, 15 Apr 2019 04:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
In-Reply-To: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
From:   Daniel Brunner <daniel@brunner.ninja>
Date:   Mon, 15 Apr 2019 13:44:16 +0200
Message-ID: <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
Subject: Corrupted files support needed
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

after normal a reboot I noticed that many files fail to open / read
(Input/Output error). I don't really have a backup of it (only
snapshots which also seem to be corrupted too).
The machine is remote, I can only ssh into it (at the moment). The
raid consists of 8x 10TB drives.

System & Metadata is RAID1
Data is RAID6

kernel is the most recent from arch linux repositories:
5.0.7-arch1-1-ARCH #1 SMP PREEMPT Mon Apr 8 10:37:08 UTC 2019 x86_64 GNU/Linux

Disk layout & usage:
https://0x0.st/zNBl.log

Output of btrfs check:
https://0x0.st/zNJs.log

Kernel messages:
http://cwillu.com:8080/84.115.44.105/2

btrfs scrub is running but it seems like it will take weeks to finish...

Do you think my data is gone or is there anything I can try? An rsync
is already running, but every 5th file fails to read.

Best regards,
Daniel
