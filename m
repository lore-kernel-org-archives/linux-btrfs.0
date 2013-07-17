Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52514 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3GQWS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 18:18:27 -0400
Received: by mail-ea0-f178.google.com with SMTP id l15so1362753eak.9
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 15:18:25 -0700 (PDT)
Received: from [192.168.3.130] ([194.9.67.191])
        by mx.google.com with ESMTPSA id o5sm14271942eef.5.2013.07.17.15.18.24
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 17 Jul 2013 15:18:24 -0700 (PDT)
Message-ID: <51E7182F.9020009@statystyka.net>
Date: Thu, 18 Jul 2013 00:18:23 +0200
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: What is the current status of defragmentation?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today I booted my linux-mint 14 into the latest 3.10.1 kernel to
defragment the root btrfs filesystem on my ASUS N56VZ laptop with hybrid
Seagate Momentus XT disk. I did something like

   find / -exec btrfs filesystem defrag {}

To my amazement it didn't really made a lot of I/O (the HDD LED wasn't
blinking). Confident that at the beginning the defragmentation is
CPU-bound (like it sometimes is for instance in case of O&O Defrag on
Windows world), I let it go on, and I switched myself to my other
chores. After a few minutes my system froze. I was barely able to switch
to text terminal and login, but I couldn't reach bash prompt; it looked
like the OS couln't perform any I/O on the disk. At the end, the system
responded to SysRq REISUB combination though; Unfortunately I can't
reproduce exactly what I typed in, because the command was not logged to
the bash history...).

It clearly showed me, that defragmenting the filesystem is not that
trivial, as it is for ext4. So I have quesions:

* Is the defragmentation of the whole filesystem supported at all? I
can't find a single reference that it is, and a syntax of btrfs-progs
suggest that it isn't. If supported, under what conditions? Like what %
of free space should be available?

* How to check the level of defragmentation, and what are the reasonable
threshold values, that should indicate the desktop filesystem needs
defragmenting? I know, that everyone's millage my vary; I just want to
know some values as a point-of-reference.

* What is the recommended command, that would efficiently defragment the
whole file system, preferably with some sort of progress indication?
Does this command

find / -type f -o -type d -print0 | xargs --null --no-run-if-empty btrfs
filesystem defragment -cv

look like a reasonable idiom for defragmenting the whole filesystem?

Thank you for your help,

Adam Ryczkowski

