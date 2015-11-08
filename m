Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:32863 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbKHV23 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Nov 2015 16:28:29 -0500
Received: by ykdv3 with SMTP id v3so147362336ykd.0
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 13:28:27 -0800 (PST)
MIME-Version: 1.0
From: Glen H <glen.hertz@gmail.com>
Date: Sun, 8 Nov 2015 16:28:08 -0500
Message-ID: <CABtZWNH4rzzTtBwvt6Xs+nf=8aiJrbsCAVZB3QzPEnEfi-Cs5A@mail.gmail.com>
Subject: btrfs-progs send | receive error: no such file or directory
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I really enjoy the features of btrfs but send|receive is failing me so
my backups are not working.  I'm using "btrbk" to backup my drives
(all local) and one of the three subvolumes errors out.  When I run
this command from the terminal it errors out:

> btrfs send /mnt/ssd/_btrbk_snap/@.20151108 | btrfs receive /mnt/backup2tb/
At subvol /mnt/ssd/_btrbk_snap/@.20151108
At subvol @.20151108
ERROR: send ioctl failed with -2: No such file or directory
ERROR: unexpected EOF in stream.

The source is an SSD drive and the subvolume is a readonly snapshot of
@.  I have two other source subvolumes on another rotational disk that
send|receive fine to the same target drive (/mnt/backup2tb) .  There
is plenty of space on the backup drive.

The error happens after 110 seconds and the @.20151108 is 25GB.  If
the error happened at the end of the transfer it would be transferring
at a rate of about 220MB/s.  Since the receiving side is a slower
rotational drive with a benchmarked write speed of 170MB/s I think the
error is happening 80% of the way through the transfer.

For versions, I'm using:

- kernel  3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8 10:21:08
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

- Linux Mint 17.2 (based on Ubuntu 14.04) which has a stock kernel of
3.17 (but I upgraded to 3.19).

- btrfs-progs 3.19, 3.19.1 and 4.3 (all fail with the same error).

I have high hopes for btrfs and want to help to make it better as an
end user.  When you have time can you please investigate this about a
possible resolution?  I can provide more details if needed.  I
appreciate the help.

Thanks,

Glen
