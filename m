Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47478 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaAAGBR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 01:01:17 -0500
Received: by mail-ie0-f170.google.com with SMTP id qd12so13782154ieb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 22:01:16 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 1 Jan 2014 14:01:16 +0800
Message-ID: <CAM6NUi5hmX3vwPsG1rOQbCH+KNS=P927Hxbhc8Vt8bu1qCv6pw@mail.gmail.com>
Subject: btrfs corruption after resuming from suspend to disk
From: Nicolas Boichat <nicolas@boichat.ch>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been running btrfs for less than a month now, on my /home
directory. Not sure if it is relevant, but I had a number of kernel
panics over that month (unrelated to btrfs). Yesterday, upon resuming
from suspend to disk, the partition was remounted as read-only, so I
rebooted, hoping to fix the problem.

Since then, I'm unable to mount the partition.

System log after resuming from suspend to disk:
https://gist.github.com/anonymous/8193563

I tried a number of repair commands, see the output there:
https://gist.github.com/drinkcat/8193276

I also tried git://repo.or.cz/btrfs-progs-unstable/devel.git, branch
integration-20131219, without success (./btrfs rescue chunk-recover -v
/dev/sdb3 does not throw any errors though, but that doesn't fix the
filesystem).

I'm going to reformat the partition, but I kept a disk image just
after the first reboot, so I can try out other commands/newer version
of the tools (and I wouldn't mind recovering some files). I'm also
hanging out on #btrfs (nick: drinkcat).

Thank you!

Nicolas
