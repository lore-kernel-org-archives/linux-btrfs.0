From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Copy/move btrfs volume
Date: Thu, 1 Jul 2010 10:28:36 +0000 (UTC)
Message-ID: <i0hqkk$r4h$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am testing btrfs on one of our backup servers
(many millions of files, 1.5TB size, running on (non-btrfs-provided-) 
raid5).

I am using subvolumes/snapshots with following rsync.

It works very well, but I would like to ask a question... say I would need 
to copy/move the files to different server/disk.

Normally I would do it with rsync, but I guess it will not preserve the 
subvolumes, it will also not detect that they are the same files (I guess
they are not just normal hardlinks). So I would end up with duplicated 
files.

What is the correct way to do this?

Thank you and best regards

Lubos Kolouch

