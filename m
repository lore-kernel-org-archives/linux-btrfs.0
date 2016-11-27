Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i4.italiaonline.it ([212.48.25.213]:53540 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751532AbcK0SS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 13:18:57 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sun, 27 Nov 2016 19:18:38 +0100
Message-ID: <1606562.nMLPFcA8R6@exnet.gdb.it>
In-Reply-To: <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <5108140.l7kIxhTaVr@exnet.gdb.it> <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have reinstalled from scratch my system (for remote receiving of the 
snapshot).
Now it uses the 4.8.8-100.fc23.x86_64 kernel, and now I have a separate 
partition for '''possible dangerous''' test.

I do not remember the exact sequence that caused the corruption of the file 
system, but now it worked without problem.

If I have problems again, I will update the btrfs-tools and I will try to fix.

P.S The silent and unrecoverable corruption are not entirely friendly ( :) ).

Thank you for answer.

Gdb


> I haven't seen this with 4.7.10. I suggest running 'btrfs check'
> (without repair) using a recent btrfs-progs. You can find 4.8.3 in
> koji, just download the appropriate rpm, and 'dnf update *rpm'
> 
> As for kernel, Fedora 23 has 4.8.8 in updates (stable) and 4.8.10 is
> in updates-testing, I suggest moving to one of those.
> 
> 
> Chris Murphy

