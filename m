Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:34893 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbcLRUM1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 15:12:27 -0500
Received: by mail-yb0-f182.google.com with SMTP id d128so52399355ybh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Dec 2016 12:12:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9712851.I7FUyRd5GC@exnet.gdb.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
 <2329571.vMCvUE5AeF@exnet.gdb.it> <9712851.I7FUyRd5GC@exnet.gdb.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 18 Dec 2016 13:12:26 -0700
Message-ID: <CAJCQCtRmmMc3QwhFA+kGqFPLc1_C4VpZ+Cei_cevncUJduTJmg@mail.gmail.com>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
To: Giuseppe Della Bianca <bepi@adria.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd say backup the volume conventionally to get important data
secured. Then use btrfs check --repair to fix the problems with the
file system, and then try the btrfs send receive again.

It most certainly is a bug, but it's not clear to me what the cause
is; other than the kernel isn't handling the problem on-disk
gracefully. Maybe repair will fix it. Another possibility is to move
to kernel 4.9.0 and see if it still reproduces. Per usual, there's a
ton of bug fixes in each kernel release.

Otherwise I'm out of ideas.

Chris Murphy
