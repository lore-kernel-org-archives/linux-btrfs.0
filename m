Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34156 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbbBBFu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 00:50:26 -0500
Received: by mail-ob0-f177.google.com with SMTP id wp18so11299714obc.8
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Feb 2015 21:50:25 -0800 (PST)
MIME-Version: 1.0
From: Victor Hooi <victorhooi@gmail.com>
Date: Mon, 2 Feb 2015 16:50:05 +1100
Message-ID: <CAMnnoUKpF+WxAwcbLLCaj04rt4970QcAGvhW2iKd9614wnbgiA@mail.gmail.com>
Subject: Unclean shutdown, BTRFS will not mount after - what things to try in
 what order?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a Ubuntu 14.10 server that has a BTRFS root filesystem.

There was a power outage, and the server will not boot afterwards.

We went into rescue mode, and / didn't mount there, in the
/var/log/syslog we see:

BTRFS: read error corrected: ino 1 of 398856193 (dev /dev/sda1 sector 795400)
<repeated twice more with different innodes and sectors>
parent transid verify failed on 397688832 wanted 901 found 408
<repeated once more with different numbers>
BTRFS: Failed to read block groups: -5
rescue: mount: mounting /dev/sda1 on /target failed: Invalid argument
rescue-mode: mount '/dev/sda1' /target failed
BTRFS: open_ctree failed

I've been reading through pages like
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ, and apparently
there's a few things to try (e.g. mounting with -o recovery,
btrfs-zero-log etc), and also using btrfs-restore.

However, I'm wondering if the above specific error messages shed any
light on what happened?

Is there any metadata, or anything I can grab from the disks which
would help diagnose it?
