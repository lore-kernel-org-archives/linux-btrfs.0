From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Problem with latest for-linus branch
Date: Mon, 30 May 2011 06:41:08 -0400
Message-ID: <1306751696-sup-7618@shiny>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com> <1306620858-sup-7865@shiny> <BANLkTi=FPw7RwkPW0zpD05YRtt19NrZ-5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTi=FPw7RwkPW0zpD05YRtt19NrZ-5A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrea Gelmini's message of 2011-05-30 06:13:47 -0400:
> 2011/5/29 Chris Mason <chris.mason@oracle.com>:
> > Thanks, could you please send in the photos of the oops when you get
> > chance.
> 
> Well, I retested everything compiling with frame pointers, so:
> a) partition is mounted with this flags:
> defaults,ssd,noacl,space_cache (at the beginning I also used
> compress);
> b) vanilla kernel .38 and .39 are working good;
> c) latest Linus tree (commit: bd1bfe40ac6bdf9593da29b822bc301b77a97d6a
> the one before 3.0-rc1,
>    so in the photos you can find it as .39g+), it goes up, but after a
> while of intense i/o working thread (it's a specific
>    kernel thread of btrfs, I guess btrfs-ino-cache, but I could be
> wrong) the system freeze. Well, if i/o keep working enough time,
>    I can even touch and unlink files, or read files already present,
> or do something like /usr/bin/find; these
>    photos are here: http://ooops.lugbs.linux.it/linusgit
> d) rebooting with .39 doesn't work. It crashes at mount time.
>    The photos are here: http://ooops.lugbs.linux.it/2.6.39
> e) booting with 2.6.38.7 solves the problem, giving this info:
> [   20.273822] Btrfs loaded
> [   20.387795] device label home devid 1 transid 4595 /dev/mapper/VG-home
> [   20.388269] btrfs: use ssd allocation scheme
> [   20.388277] btrfs: enabling disk space caching
> [   25.025873] btrfs: unlinked 5 orphans
> [   25.025876] btrfs: truncated 3 orphans
> f) by the way, bisect.jpg is the photo I took when I sent first email.
> 
> These photos are terrible, but I guess they're good enough to read 'em.
> Anyway, these are multiple shoots of same screen, of course.

These are perfect, thank you.  We're failing to write out the inode
cache.  Since you're on a 32 bit machine, I'm guessing that we failed to
kmap something properly.

Could you please do gdb fs/btrfs/btrfs.ko, and then at the gdb prompt:

gdb> list *__btrfs_write_out_cache+0x43a

And send the output here?  This corresponds to where you were crashing
in the kernel you oops in your linusgit directory.

If this doesn't work, you might need to recompile with
CONFIG_DEBUG_INFO=y.  You won't need to trigger the crash again,
just do the gdb command on the new .ko.

If you don't have btrfs compiled as a module, use gdb vmlinux instead of
gdb fs/btrfs/btrfs.ko

-chris
