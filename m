Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34129 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759182AbdEONJX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 09:09:23 -0400
Received: by mail-wm0-f68.google.com with SMTP id d127so28356719wmf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 May 2017 06:09:23 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Btrfs/SSD
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
Date: Mon, 15 May 2017 14:09:20 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <FA7013B1-621B-405F-B65C-236A4A33F022@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
 <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
 <20170512203644.26e068e5@jupiter.sol.kaishome.de>
 <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Traditional hard drives usually do this too these days (they've been under-provisioned since before SSD's existed), which is part of why older disks tend to be noisier and slower (the reserved space is usually at the far inside or outside of the platter, so using sectors from there to replace stuff leads to long seeks).

Not true. When HDD uses 10% (10% is just for easy example) of space as spare than aligment on disk is (US - used sector, SS - spare sector, BS - bad sector)

US US US US US US US US US SS
US US US US US US US US US SS
US US US US US US US US US SS
US US US US US US US US US SS
US US US US US US US US US SS
US US US US US US US US US SS
US US US US US US US US US SS

if failure occurs - drive actually shifts sectors up:

US US US US US US US US US SS
US US US BS BS BS US US US US
US US US US US US US US US US
US US US US US US US US US US
US US US US US US US US US SS
US US US BS US US US US US US
US US US US US US US US US SS
US US US US US US US US US SS

that strategy is in place to actually mitigate the problem that you’ve described, actually it was in place since drives were using PATA :) so if your drive get’s nosier over time it’s either a broken bearing or demagnetised arm magnet causing it to not aim propperly - so drive have to readjust position multiple times before hitting a right track 