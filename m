From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: boot problem
Date: Fri, 9 Jul 2010 15:06:07 +0000 (UTC)
Message-ID: <i17dsv$eq3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I added another device to the / filesystem
(btrfs device add).

Now I can't boot off it, even though kernel sees both devices
(sda2, sdb2).

Am I screwed or is there any way how to convince the kernel 
to assemble the / filesystem?

Thank you

Lubos

