Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:65418 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3EETQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 15:16:48 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so3475221iec.29
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 12:16:48 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Date: Sun, 5 May 2013 19:16:27 +0000
Message-ID: <CAAr69zaPjT=yez5FbHYd8JdieuQS9e9-EE4N-u0HkfLKU2yQpg@mail.gmail.com>
Subject: Kernel bug at extent-tree.c:5446
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

When I tried to recover my partition from the space cache bug (see
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24360.html
), I issued the command `mount -o clear_cache -t btrfs /dev/sda7
/aaa/aaa`. After 10 minutes the mount command segfaulted. I cloned the
latest btrfs-progs from Josef's Github account and ran the `btrfsck
--repair` twice on the partition.

Then I tried to mount under my normal openSUSE system (with kernel
3.9) and the following BUG appeared during the boot-up process: Kernel
bug at extent-tree.c:5446
The picture I've taken: www.morrohun.hu/temp/btrfs/IMG_1770.JPG

I tried to boot in an openSUSE Rescue CD, an Ubuntu Live CD, but just
a SystemRescueCD was actually working, but I can't reach my partition.
Even though I was able to make an image by `btrfs-image -c9 -t8` and
I'll send you the link if it's requested.

Best regards,

Ákos Szőts
