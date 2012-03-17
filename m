From: Skylar Burtenshaw <daninfuchs@gmail.com>
Subject: Can't mount, power failure - recoverable?
Date: Sat, 17 Mar 2012 04:24:02 +0000 (UTC)
Message-ID: <loom.20120317T051243-551@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey all. First and foremost, great work on the filesystem. Love it. That is,
until this...

AGES ago, I had a power failure. I had 22 drives in one BTRFS filesystem. I
know, dumb idea given that it's an experimental FS, but it's not important data,
just.....LOTS of it. A dozen terabytes or so.

Now when I try to mount it with all present kernels (up to 3.2.0) I get several
minutes of disk churning, and a kernel stack trace. Every tool I throw at it
fails. find-root only shows one tree (at the very end) after complaining about
blocks seeming great, but generations don't match for ages. The btrfsck from the
stable tree lists twenty "item # key" messages, then stops with "failed to find
block number 20975616" and aborts every time.

I've been sitting on this filesystem for half a year now, using my backup array,
but it's getting full. I realize I'm being very sparse on information, but I'm
not sure what you need from me.

As such, my questions are these:
1) What information do you require in order to ascertain the degree of my
problem?

2) (Once more information is obtained, of course.) Is there any hope of this
filesystem being reliably recovered? I realize that's a loaded question and that
you obviously can't give me a definite 100% answer, but I would like to know if
it's time to wipe it and start anew, or if the odds are good enough that I
should wait.

Thank you very much for your attention.

