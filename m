From: Bernhard Rosenkranzer <bernhard.rosenkranzer@linaro.org>
Subject: infinite loop when remounting a btrfs root filesystem read-write
Date: Wed, 6 Jul 2011 02:10:10 +0200
Message-ID: <CAJcDVWNPpdifd4sKvVX5BaZ+f_M6QOiujvyC6UkBYfr+L_bqSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I've run into a severe problem with a btrfs root filesystem (this is
on 2.6.39, but other kernel versions seem to behave the same).
The filesystem mounts read-only fine, but trying to mount it
read-write causes an infinite loop inside the kernel, causing an
infinite repetition of the message

inode 57783233 still on the orphan list

in printk output.

To make things worse, btrfsck doesn't help - it runs for a couple of
minutes, prints a couple of errors, then aborts after saying

failed to find block number 1974534356992

There appears to be a bad block on the harddisk, but I doubt that sort
of overreaction is intended.
Is there any way to recover this filesystem short of rsync-ing it to a
different box while mounted read-only and reinstalling?

Thanks,
bero
