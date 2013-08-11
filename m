Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34671 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3HKSxD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 14:53:03 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so6073126pbc.30
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Aug 2013 11:53:01 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 11 Aug 2013 21:53:01 +0300
Message-ID: <CAELSAVaZNofc+g8jgvbkiL7dmzv9jiFtYtNxDR1+UkLZyaCMmg@mail.gmail.com>
Subject: Possible bug in send/receive with simple reproducer
From: Emil Karlson <jekarlson@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings

Send fails for me unexpectedly:

I get:
ERROR: rename o262-5-0 -> snapshots failed. No such file or directory

reproducer ( http://users.tkk.fi/~jkarlson/files/test4.txt  ):

for i in 1 2; do
  mkdir /mnt/$i
  truncate -s 4G /mnt/$i.img
  mkfs.btrfs /mnt/$i.img
  mount -o loop /mnt/$i.img /mnt/$i
done

mkdir /mnt/1/testdir
mkdir /mnt/1/testdir/1/
mkdir /mnt/1/testdir/2/
dd if=/dev/urandom  of=/mnt/1/testdir/aa count=16
dd if=/dev/urandom  of=/mnt/1/testdir/bb count=16

mkdir /mnt/1/snapshots
btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup2
btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup3
btrfs send /mnt/1/snapshots/backup3/ | btrfs receive /mnt/2/

umount /mnt/{1,2}; rm /mnt/{1,2}.img; rmdir /mnt/{1,2}

Best Regards
-Emil
