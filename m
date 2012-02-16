From: "Norbert Scheibner" <scno@gmx.net>
Subject: btrsfck shows errors...
Date: Thu, 16 Feb 2012 18:58:53 +0100
Message-ID: <20120216175853.19050@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Gl=C3=BCck Auf!
On kernel 3.2 with btrfs-progs-dangerdonteveruse-62b7993.
I have these subvolumes on a working fs on 1 TB hdd:

ID 257 top level 5 path system-backup-20110803-182701-monthly
ID 481 top level 5 path system-backup-20110901-040001-monthly
ID 809 top level 5 path system-backup-20111001-040001-monthly
ID 864 top level 5 path system-backup-20111101-040001-monthly
ID 928 top level 5 path system-backup-20111201-040001-monthly
ID 1404 top level 5 path system-backup-20120101-155108-monthly
ID 1431 top level 5 path system-backup-20120201-040001-monthly
ID 1432 top level 5 path system-backup-20120202-040001
ID 1433 top level 5 path system-backup-20120203-040001
ID 1723 top level 5 path system-backup
ID 2373 top level 5 path system-backup-20120210-040001
ID 2378 top level 5 path system-backup-20120211-040001
ID 2383 top level 5 path system-backup-20120212-040002
ID 2391 top level 5 path system-backup-20120213-040001
ID 2398 top level 5 path system-backup-20120214-040001
ID 2401 top level 5 path system-backup-20120215-040001

btrsfsck shows:
checking extents
checking fs roots
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
root 257 inode 18446744073709551604 errors 2000
root 257 inode 18446744073709551605 errors 1
root 481 inode 610772 errors 400
root 481 inode 18446744073709551604 errors 2000
root 481 inode 18446744073709551605 errors 1
root 809 inode 610772 errors 400
root 809 inode 18446744073709551604 errors 2000
root 809 inode 18446744073709551605 errors 1
root 864 inode 610772 errors 400
root 864 inode 18446744073709551604 errors 2000
root 864 inode 18446744073709551605 errors 1
root 928 inode 610772 errors 400
root 928 inode 18446744073709551604 errors 2000
root 928 inode 18446744073709551605 errors 1
root 1404 inode 610772 errors 400
root 1404 inode 18446744073709551604 errors 2000
root 1404 inode 18446744073709551605 errors 1
root 1431 inode 610772 errors 400
root 1431 inode 18446744073709551604 errors 2000
root 1431 inode 18446744073709551605 errors 1
root 1432 inode 610772 errors 400
root 1432 inode 18446744073709551604 errors 2000
root 1432 inode 18446744073709551605 errors 1
root 1433 inode 610772 errors 400
root 1433 inode 18446744073709551604 errors 2000
root 1433 inode 18446744073709551605 errors 1
root 1723 inode 610772 errors 400
root 1723 inode 18446744073709551604 errors 2000
root 1723 inode 18446744073709551605 errors 1
root 2373 inode 610772 errors 400
root 2373 inode 18446744073709551604 errors 2000
root 2373 inode 18446744073709551605 errors 1
root 2378 inode 610772 errors 400
root 2378 inode 18446744073709551604 errors 2000
root 2378 inode 18446744073709551605 errors 1
root 2383 inode 610772 errors 400
root 2383 inode 18446744073709551604 errors 2000
root 2383 inode 18446744073709551605 errors 1
root 2391 inode 610772 errors 400
root 2391 inode 18446744073709551604 errors 2000
root 2391 inode 18446744073709551605 errors 1
root 2398 inode 610772 errors 400
root 2398 inode 18446744073709551604 errors 2000
root 2398 inode 18446744073709551605 errors 1
root 2401 inode 610772 errors 400
root 2401 inode 18446744073709551604 errors 2000
root 2401 inode 18446744073709551605 errors 1
found 683579826176 bytes used err is 1
total csum bytes: 664064404
total tree bytes: 3535802368
total fs tree bytes: 2500636672
btree space waste bytes: 958368184
file data blocks allocated: 763722764288
 referenced 763722764288

I already tried scrub and balance, both worked, but
the errors are still there. It's the same fs I
mentioned in my post from Thu, 09 Feb 2012 18:42:32
+0100.

Is there anything I can do to repair that fs now or do
I have to wait for a really working btrfsck?

Cheers
      Norbert
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
