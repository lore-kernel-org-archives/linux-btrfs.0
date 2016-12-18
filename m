Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i4.italiaonline.it ([212.48.25.216]:36117 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753043AbcLRUjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 15:39:41 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sun, 18 Dec 2016 21:39:32 +0100
Message-ID: <3349060.f6sEu1BO2o@exnet.gdb.it>
In-Reply-To: <CAJCQCtRmmMc3QwhFAkGqFPLc1_C4VpZCei_cevncUJduTJmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Chris Murphy Sun, 18 Dec 2016 12:12:42 -0800

> I'd say backup the volume conventionally to get important data
> secured. Then use btrfs check --repair to fix the problems with the
> file system, and then try the btrfs send receive again.


> It most certainly is a bug, but it's not clear to me what the cause
> is; other than the kernel isn't handling the problem on-disk
> gracefully. Maybe repair will fix it. Another possibility is to move
> to kernel 4.9.0 and see if it still reproduces. Per usual, there's a
> ton of bug fixes in each kernel release.

> Otherwise I'm out of ideas.

> Chris Murphy


Thanks for the reply.


I have three partitions that receive the same snapshots (and a separate backup 
for important data).

The damaged filesystems do not lose data, but only (!) waste time.

The repair attempts have only worsened the problem.


I understand the software development problems.
I would just like to be able to help you to find the problem.


Have a nice day


gdb


