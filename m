Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50264 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbdHDHTA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 03:19:00 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id 86AA820409
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Aug 2017 07:18:59 +0000 (UTC)
Date: Fri, 4 Aug 2017 12:18:58 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: csum errors on top of dm-crypt
Message-ID: <20170804121858.1c860065@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've migrated my home dir to a luks dm-crypt device some time ago, and today
during a scheduled backup a few files turned out to be unreadable, with csum
errors from Btrfs in dmesg.

What I find weird is why the expected csum is the same on all of these.
Any idea what this might point to as the cause?

What is 0x98f94189, is it not a csum of a block of zeroes by any chance?

(I use a patch from Qu Wenruo to improve the error reporting).

[483575.992252] BTRFS warning (device dm-1): csum failed root 5 ino 481 off 888832 csum 0xe2a2e6eb expected csum 0x98f94189 mirror 1
[483575.994518] BTRFS warning (device dm-1): csum failed root 5 ino 481 off 888832 csum 0xe2a2e6eb expected csum 0x98f94189 mirror 1
[483575.995640] BTRFS warning (device dm-1): csum failed root 5 ino 481 off 2785280 csum 0x7f97f4a6 expected csum 0x98f94189 mirror 1
[483575.996599] BTRFS warning (device dm-1): csum failed root 5 ino 481 off 1736704 csum 0x7476ddf8 expected csum 0x98f94189 mirror 1
[483585.020047] BTRFS warning (device dm-1): csum failed root 5 ino 6172 off 1011712 csum 0xbadf2d3e expected csum 0x98f94189 mirror 1
[483585.023036] BTRFS warning (device dm-1): csum failed root 5 ino 6172 off 1011712 csum 0xbadf2d3e expected csum 0x98f94189 mirror 1
[483585.023702] BTRFS warning (device dm-1): csum failed root 5 ino 6172 off 1900544 csum 0x26c571dc expected csum 0x98f94189 mirror 1
[483585.023761] BTRFS warning (device dm-1): csum failed root 5 ino 6172 off 2949120 csum 0x27726fbe expected csum 0x98f94189 mirror 1
[483599.026289] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17645568 csum 0xdd5bf4de expected csum 0x98f94189 mirror 1
[483599.027425] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17465344 csum 0x42bf4f44 expected csum 0x98f94189 mirror 1
[483599.032396] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17465344 csum 0x42bf4f44 expected csum 0x98f94189 mirror 1
[483599.092709] BTRFS warning (device dm-1): csum failed root 5 ino 15002 off 1110016 csum 0xbca8fc65 expected csum 0x98f94189 mirror 1
[483599.093080] BTRFS warning (device dm-1): csum failed root 5 ino 15002 off 1110016 csum 0xbca8fc65 expected csum 0x98f94189 mirror 1
[483599.093242] BTRFS warning (device dm-1): csum failed root 5 ino 15002 off 1736704 csum 0x1d4087fc expected csum 0x98f94189 mirror 1
[483627.708625] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 2613248 csum 0xe1952338 expected csum 0x98f94189 mirror 1
[483627.709459] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 2613248 csum 0xe1952338 expected csum 0x98f94189 mirror 1
[483627.709799] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 2965504 csum 0xfaff212d expected csum 0x98f94189 mirror 1
[483634.462684] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 5062656 csum 0x8c7df392 expected csum 0x98f94189 mirror 1
[483634.462703] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 4108288 csum 0x6005cecd expected csum 0x98f94189 mirror 1
[483634.466602] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 7159808 csum 0xfc06d954 expected csum 0x98f94189 mirror 1
[483634.466604] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 6111232 csum 0xc802b3b4 expected csum 0x98f94189 mirror 1
[483634.470118] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 4108288 csum 0x6005cecd expected csum 0x98f94189 mirror 1
[483634.470257] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 10305536 csum 0x3d8c1843 expected csum 0x98f94189 mirror 1
[483634.471085] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 9256960 csum 0xba3fede3 expected csum 0x98f94189 mirror 1
[483634.471128] BTRFS warning (device dm-1): csum failed root 5 ino 30602 off 8302592 csum 0x7de15198 expected csum 0x98f94189 mirror 1
[484152.178497] BTRFS warning (device dm-1): csum failed root 5 ino 142886 off 1163264 csum 0x341f3c2a expected csum 0x98f94189 mirror 1
[484152.180422] BTRFS warning (device dm-1): csum failed root 5 ino 142886 off 1736704 csum 0xf01ac658 expected csum 0x98f94189 mirror 1
[484152.181598] BTRFS warning (device dm-1): csum failed root 5 ino 142886 off 1163264 csum 0x341f3c2a expected csum 0x98f94189 mirror 1
[484152.182242] BTRFS warning (device dm-1): csum failed root 5 ino 142886 off 2785280 csum 0xc78988ec expected csum 0x98f94189 mirror 1
[484158.569489] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 2138112 csum 0xab34e90e expected csum 0x98f94189 mirror 1
[484158.571885] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 2785280 csum 0xd611911e expected csum 0x98f94189 mirror 1
[484158.575191] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 3833856 csum 0x6277c8a6 expected csum 0x98f94189 mirror 1
[484158.575620] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 4882432 csum 0x3293c3e7 expected csum 0x98f94189 mirror 1
[484158.578637] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 2138112 csum 0xab34e90e expected csum 0x98f94189 mirror 1
[484158.578809] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 5931008 csum 0x7b207454 expected csum 0x98f94189 mirror 1
[484158.579378] BTRFS warning (device dm-1): csum failed root 5 ino 143605 off 6979584 csum 0x3e4c20b1 expected csum 0x98f94189 mirror 1
[484179.161936] BTRFS warning (device dm-1): csum failed root 5 ino 148141 off 1597440 csum 0xe09ddaf4 expected csum 0x98f94189 mirror 1
[484179.162971] BTRFS warning (device dm-1): csum failed root 5 ino 148141 off 1597440 csum 0xe09ddaf4 expected csum 0x98f94189 mirror 1
[484179.163579] BTRFS warning (device dm-1): csum failed root 5 ino 148141 off 1916928 csum 0x41bc845f expected csum 0x98f94189 mirror 1
[484179.164969] BTRFS warning (device dm-1): csum failed root 5 ino 148141 off 2965504 csum 0xeaed1447 expected csum 0x98f94189 mirror 1
[484207.644192] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17719296 csum 0x81fdcb1d expected csum 0x98f94189 mirror 1
[484207.644811] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17465344 csum 0x42bf4f44 expected csum 0x98f94189 mirror 1
[484207.645299] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17817600 csum 0x2ca66e22 expected csum 0x98f94189 mirror 1
[484207.646050] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 18464768 csum 0xa4a38789 expected csum 0x98f94189 mirror 1
[484207.650299] BTRFS warning (device dm-1): csum failed root 5 ino 14988 off 17465344 csum 0x42bf4f44 expected csum 0x98f94189 mirror 1
[484208.299535] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 2633728 csum 0x83df51e8 expected csum 0x98f94189 mirror 1
[484208.301079] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 2613248 csum 0xe1952338 expected csum 0x98f94189 mirror 1
[484208.301110] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 3309568 csum 0x3b7a72b5 expected csum 0x98f94189 mirror 1
[484208.301832] BTRFS warning (device dm-1): csum failed root 5 ino 29039 off 2613248 csum 0xe1952338 expected csum 0x98f94189 mirror 1


-- 
With respect,
Roman
