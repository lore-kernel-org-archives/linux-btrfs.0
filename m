Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50296 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdHDHoq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 03:44:46 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id CA1A920409
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Aug 2017 07:44:45 +0000 (UTC)
Date: Fri, 4 Aug 2017 12:44:44 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: SQLite Re: csum errors on top of dm-crypt
Message-ID: <20170804124444.6d102183@natsu>
In-Reply-To: <20170804121858.1c860065@natsu>
References: <20170804121858.1c860065@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 4 Aug 2017 12:18:58 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> What I find weird is why the expected csum is the same on all of these.
> Any idea what this might point to as the cause?
> 
> What is 0x98f94189, is it not a csum of a block of zeroes by any chance?

It does seem to be something of that sort, as it appears in
https://www.spinics.net/lists/linux-btrfs/msg67281.html 
(though as factual csum, not the expected one).

> a few files turned out to be unreadable

Actually, turns out ALL of those are sqlite files(!)

.mozilla/firefox/.../places.sqlite <- 4 instances (for 4 users)
.moonchild productions/pale moon/.../urlclassifier3.sqlite
.config/chromium/Default/Application Cache/Cache/data_3 <- twice (for 2 users)
.config/chromium/Default/History
.config/chromium/Default/Top Sites

nothing else affected.

Forgot to mention that the kernel version is 4.9.40.

-- 
With respect,
Roman
