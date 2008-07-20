From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Problem during implementing NFS support
Date: Sun, 20 Jul 2008 13:08:16 -0700
Message-ID: <1216584496.2475.198.camel@shinybook.infradead.org>
References: <200807210041.10609.balajirrao@gmail.com>
	 <1216572230.2475.106.camel@shinybook.infradead.org>
	 <200807210106.56056.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200807210106.56056.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 01:06 +0530, Balaji Rao wrote:
> The idea of the patch seems correct to me, that once we "own" the
> lock, an attempt to take it again should be a nop.

Well, kind of correct. There are potentially race conditions with the
handling of f->readdir_process, but given that we only ever really
compare it to 'current', it's actually going to turn out OK in practice.
You won't ever actually get a false negative (and deadlock) or a false
positive (and go through lookup() without locking), as far as I can
tell.

But still, it's ugly as sin and I'd much rather come up with a _proper_
fix in the VFS. I was looking at it at one point, and didn't actually
apply that patch to the JFFS2 tree.

Since general btrfs work is now more of a priority for me than getting
JFFS2 to be NFS-exportable was, I think I'll pick up where I left off
with that.

In the meantime, we have an evil hack which at least ought to work for
now.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

-- 
dwmw2

