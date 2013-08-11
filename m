Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:32823 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab3HKTIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 15:08:13 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so564056pdj.29
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Aug 2013 12:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAELSAVaZNofc+g8jgvbkiL7dmzv9jiFtYtNxDR1+UkLZyaCMmg@mail.gmail.com>
References: <CAELSAVaZNofc+g8jgvbkiL7dmzv9jiFtYtNxDR1+UkLZyaCMmg@mail.gmail.com>
Date: Sun, 11 Aug 2013 22:08:12 +0300
Message-ID: <CAELSAVZYqyV=Exc6V1BS9yhA6gzh3XS6ag8PKVq5FpNNOieccg@mail.gmail.com>
Subject: Re: Possible bug in send/receive with simple reproducer
From: Emil Karlson <jekarlson@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 11, 2013 at 9:53 PM, Emil Karlson <jekarlson@gmail.com> wrote:
> Greetings
>
> Send fails for me unexpectedly:
>
> I get:
> ERROR: rename o262-5-0 -> snapshots failed. No such file or directory
>
> reproducer ( http://users.tkk.fi/~jkarlson/files/test4.txt  ):
>
> for i in 1 2; do
>   mkdir /mnt/$i
>   truncate -s 4G /mnt/$i.img
>   mkfs.btrfs /mnt/$i.img
>   mount -o loop /mnt/$i.img /mnt/$i
> done
>
> mkdir /mnt/1/testdir
> mkdir /mnt/1/testdir/1/
> mkdir /mnt/1/testdir/2/
> dd if=/dev/urandom  of=/mnt/1/testdir/aa count=16
> dd if=/dev/urandom  of=/mnt/1/testdir/bb count=16
>
> mkdir /mnt/1/snapshots
> btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup2
> btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup3
> btrfs send /mnt/1/snapshots/backup3/ | btrfs receive /mnt/2/
>
> umount /mnt/{1,2}; rm /mnt/{1,2}.img; rmdir /mnt/{1,2}
>
> Best Regards
> -Emil

Kernel version is 3.11-rc4 with "Btrfs: check our parent dir when
doing a compare send V2" and a few other patches.
