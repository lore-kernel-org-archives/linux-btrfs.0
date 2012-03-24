From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: scrub to delete files
Date: Sat, 24 Mar 2012 11:12:00 +0000 (UTC)
Message-ID: <jkka60$qin$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a (rather historical btrfs) filesystem running here.
When I run scrub, I get a lot of messages like :
btrfs: checksum error at logical 2153033760768 on dev /dev/md2, sector 
492918400, root 5232, inode 3360637, offset 217088, length 4096, links 1 
(path: ....)

and

btrfs: unable to fixup (regular) error at logical 2154979917824

Is there a way how to have scrub delete the broken files?
What to do with the unable to fixup messages?

Thank you

Lubos

