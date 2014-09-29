Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31931 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbaI2Bik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 21:38:40 -0400
Message-ID: <5428B81E.2090708@cn.fujitsu.com>
Date: Mon, 29 Sep 2014 09:38:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Daniel Holth <dholth@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: bad areas cause btrfs segfault
References: <CAG8k2+6MZHDH6Fb=RPW3=L1h63nk8SOWkZJ6JDR_aTZRWDP1wQ@mail.gmail.com>
In-Reply-To: <CAG8k2+6MZHDH6Fb=RPW3=L1h63nk8SOWkZJ6JDR_aTZRWDP1wQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This bug seems to be one reported bug before:
http://article.gmane.org/gmane.comp.file-systems.btrfs/33270

And Chris has already updated the 3.13 stable branch to fix the bug.

If it is OK for you, updating kernel to 3.14 would be a solution.
(Since from 3.15, the new btrfs workqueue implementation caused some 
bug, and will be fixed in 3.17,
3.15~3.16 is not recommended)

Thanks
Qu
-------- Original Message --------
Subject: bad areas cause btrfs segfault
From: Daniel Holth <dholth@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年09月29日 09:11
> I've got a couple of directories that cause a btrfs segfault. First
> one happened at the end of July and I just renamed it to get it out of
> my way (can't delete it without crashing); the second one just
> happened and I'll be discarding the filesystem.
>
> This "crash when touched" behavior is frustrating because it makes it
> iffy to back up everything else. Usually about the second attempt to
> touch the bad directory requires a reboot.
>
> Instead, I would prefer that the filesystem not crash the whole system
> when it encounters a corrupted area.
>
> I've tried "btrfs scrub" and "btrfs check" but they don't find
> anything wrong. I guess the next step would be "btrfs restore", but I
> think I have a good enough backup made with a normal copy skipping the
> two corrupted directories.
>
> Here's my info.
>
> $   uname -a
> Linux cardamom 3.13.0-36-generic #63-Ubuntu SMP Wed Sep 3 21:30:07 UTC
> 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> $   btrfs --version
> Btrfs v3.12
>
> $   btrfs fi show
> Btrfs v3.12
>
> $   btrfs fi df /home # Replace /home with the mount point of your
> btrfs-filesystem
> Data, single: total=110.01GiB, used=108.09GiB
> System, DUP: total=8.00MiB, used=20.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=3.00GiB, used=2.31GiB
> Metadata, single: total=8.00MiB, used=0.00

