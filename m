From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: Problem with latest for-linus branch
Date: Mon, 30 May 2011 12:13:47 +0200
Message-ID: <BANLkTi=FPw7RwkPW0zpD05YRtt19NrZ-5A@mail.gmail.com>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
	<1306620858-sup-7865@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306620858-sup-7865@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/29 Chris Mason <chris.mason@oracle.com>:
> Thanks, could you please send in the photos of the oops when you get
> chance.

Well, I retested everything compiling with frame pointers, so:
a) partition is mounted with this flags:
defaults,ssd,noacl,space_cache (at the beginning I also used
compress);
b) vanilla kernel .38 and .39 are working good;
c) latest Linus tree (commit: bd1bfe40ac6bdf9593da29b822bc301b77a97d6a
the one before 3.0-rc1,
   so in the photos you can find it as .39g+), it goes up, but after a
while of intense i/o working thread (it's a specific
   kernel thread of btrfs, I guess btrfs-ino-cache, but I could be
wrong) the system freeze. Well, if i/o keep working enough time,
   I can even touch and unlink files, or read files already present,
or do something like /usr/bin/find; these
   photos are here: http://ooops.lugbs.linux.it/linusgit
d) rebooting with .39 doesn't work. It crashes at mount time.
   The photos are here: http://ooops.lugbs.linux.it/2.6.39
e) booting with 2.6.38.7 solves the problem, giving this info:
[   20.273822] Btrfs loaded
[   20.387795] device label home devid 1 transid 4595 /dev/mapper/VG-home
[   20.388269] btrfs: use ssd allocation scheme
[   20.388277] btrfs: enabling disk space caching
[   25.025873] btrfs: unlinked 5 orphans
[   25.025876] btrfs: truncated 3 orphans
f) by the way, bisect.jpg is the photo I took when I sent first email.

These photos are terrible, but I guess they're good enough to read 'em.
Anyway, these are multiple shoots of same screen, of course.

Thanks a lot for your time,
Andrea
