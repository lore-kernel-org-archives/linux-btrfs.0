From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Can't mount, power failure - recoverable?
Date: Sat, 17 Mar 2012 08:18:32 -0400
Message-ID: <20120317121832.GF19217@shiny>
References: <loom.20120317T051243-551@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Skylar Burtenshaw <daninfuchs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120317T051243-551@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 17, 2012 at 04:24:02AM +0000, Skylar Burtenshaw wrote:
> Hey all. First and foremost, great work on the filesystem. Love it. That is,
> until this...
> 
> AGES ago, I had a power failure. I had 22 drives in one BTRFS filesystem. I
> know, dumb idea given that it's an experimental FS, but it's not important data,
> just.....LOTS of it. A dozen terabytes or so.

Which kernel was used during the power outage?  If 3.2 or higher you may
be able to mount -o recovery

> 
> Now when I try to mount it with all present kernels (up to 3.2.0) I get several
> minutes of disk churning, and a kernel stack trace. Every tool I throw at it
> fails. find-root only shows one tree (at the very end) after complaining about
> blocks seeming great, but generations don't match for ages. The btrfsck from the
> stable tree lists twenty "item # key" messages, then stops with "failed to find
> block number 20975616" and aborts every time.

We'll definitely need the stack trace, and the tool output.  From there
I'll ask for more.

-chris
