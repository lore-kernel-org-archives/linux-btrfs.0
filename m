Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1253 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932114AbaH1Cqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 22:46:34 -0400
Message-ID: <1409193972.2879.2.camel@localhost.localdomain>
Subject: Re: fs corruption report
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Zooko Wilcox-OHearn <zooko@leastauthority.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 28 Aug 2014 10:46:12 +0800
In-Reply-To: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW，there is a develop branch from the btrfs-progs's maintainer David:
http://github.com/kdave/btrfs-progs.git

Maybe you'd like to try it, it may make some differences.

-Gui

On Mon, 2014-08-25 at 05:08 +0000, Zooko Wilcox-OHearn wrote:
> Dear people of linux-btrfs:
> 
> Thank you for btrfs! It is a beautiful thing. I say that in spite of
> the fact that it seems to have failed and eaten some of my data.
> 
> I'm writing with two purposes: to get help and advice in recovering my
> data, to help debug the software.
> 
> I was running linux 3.12.26 and btrfsprogs 3.14, and I started getting
> error messages like these in my syslog:
> 
> syslog.7:Aug 16 02:32:35 spark kernel: [48524.140611] btrfs no csum
> found for inode 15537898 start 4096
> 
> It happened only for one of the three partitions on this SSD, and
> smartctl indicated no problem with the disk:
> 
> SMART overall-health self-assessment test result: PASSED
> …
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed without error       00%      6406         -
> # 2  Extended captive    Completed without error       00%      6405         -
> 
> I upgraded my kernel to 3.16.1 and tried the various techniques
> suggested in https://btrfs.wiki.kernel.org/index.php/Btrfsck and
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ , including
> `btrfsck check --repair --init-csum-tree`. This didn't fix it.
> 
> I made an image of the filesystem in case someone wants to diagnose it
> (78 MB), and I also a made a dd copy of the affected partition.
> 
> The `btrfs restore` command aborts even though I've passed the -i
> flag. In fact, I see that on subsequent runs it aborts at different
> places.
> 
> Looking at the source code
> (http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/tree/cmds-restore.c?id=c17d0a73c11d7cdbdf1582408ec6d168876160ea#n819)
> I don't see how -6 from decompress could cause it to stop when I have
> set `ignore_errors`, so next I ran it under valgrind.
> 
> Aha. When it is run under valgrind it consistently stops (killing
> valgrind, in fact!) in the same way on every run.
> 
> Here's the tail of stdout and stderr when it aborted when run under valgrind:
> 
> Restoring ./sda6-btrfs-restore-3/@home/zooko/.mozilla/firefox/ltjwtkwe.ketotic.org/thumbnails/188888af64f6d2871b0f24e325d8a298.png
> Restoring ./sda6-btrfs-restofailed to inflate: -6
> 
> Full valgrind outputs from such a run is attached to this letter.
> 
> I've spent a little time looking at the stack traces in the valgrind
> log, and I *guess* that there is corruption such that the
> decompression fails, and I guess it would be possible to make
> cmds-restore handle corrupted compressedtext better, so that it would
> end up skipping whatever files and directories were unrestorable due
> to corruption. However, I don't immediately see how to proceed.
> 
> Regards,
> 
> Zooko Wilcox-O'Hearn
> 
> Founder, CEO, and Customer Support Rep
> https://LeastAuthority.com
> Freedom matters.


