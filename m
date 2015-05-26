Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hmm.wantstofly.org ([148.251.232.15]:53107 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbEZRmG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 13:42:06 -0400
Date: Tue, 26 May 2015 20:36:34 +0300
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-btrfs@vger.kernel.org
Subject: intermittent -ENOSPC errors on btrfs filesystem with 170G free
Message-ID: <20150526173634.GU11340@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

The btrfs filesystem on my newly installed laptop has managed to
hose itself rather thoroughly, and it's now in a state where it
works okay if you don't write too much to it, but if you do, it
starts returning -ENOSPC on a random subset of your filesystem
operations until you let it cool down again.

This was a fresh Fedora 21 install, upgraded to F22, installed
about a month ago, with a ~250G btrfs filesystem on a 256G SSD,
and this system has only even run 4.0, and it has never had more
than ~60G on it.  It's currently running:

# uname -a
Linux foobox 4.0.1-300.fc22.x86_64 #1 SMP Wed Apr 29 15:48:25 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.0

# btrfs fi show
Label: 'foobox'  uuid: [...]
        Total devices 1 FS bytes used 58.87GiB
        devid    1 size 229.97GiB used 229.97GiB path /dev/[...]

# btrfs fi df /
Data, single: total=227.94GiB, used=58.16GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.00GiB, used=730.80MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=256.00MiB, used=0.00B

There's zero btrfs related messages in the logs, or anything disk or
filesystem related, except a whole bunch of:

[1843230.259205] systemd-journald[692]: /var/log/journal/5997c521ad1f4293842511a8ae54ff19/system.journal: IO error, rotating.
[1843230.290505] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/system.journal: No space left on device
[1843230.315511] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/user-1000.journal: No space left on device
[1843230.348163] systemd-journald[692]: Failed to write entry (23 items, 626 bytes) despite vacuuming, ignoring: Bad message
[1843230.372496] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/system.journal: No space left on device
[1843230.385662] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/user-1000.journal: No space left on device
[1843230.385750] systemd-journald[692]: Failed to write entry (23 items, 585 bytes), ignoring: Bad message
[1848548.026408] systemd-journald[692]: Failed to sync system journal: Input/output error
[1848642.374799] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/system.journal: No space left on device
[1848642.392197] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/user-1000.journal: No space left on device
[1848642.392433] systemd-journald[692]: Failed to write entry (21 items, 796 bytes), ignoring: Bad message
[1848642.405032] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/system.journal: No space left on device
[1848642.416944] systemd-journald[692]: Failed to rotate /var/log/journal/5997c521ad1f4293842511a8ae54ff19/user-1000.journal: No space left on device

This is with ~170G free.

It's currently still in a funky state:

[root@foobox lib]# df /
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/dm-0      241145856 62743256 178027464  27% /
[root@foobox lib]# pwd
/var/lib
[root@foobox lib]# touch foo
[root@foobox lib]# rm -f foo
[root@foobox lib]# ls -ald abrt
drwxr-xr-x. 1 root root 56 May 21 10:02 abrt
[root@foobox lib]# mv abrt abrt2
mv: cannot move ‘abrt’ to ‘abrt2’: No space left on device
[root@foobox lib]# 

Any tests anyone wants to run on this before I wipe and reinstall
the box?


cheers,
Lennert
