From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 11:32:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804251127290.23551@cobra.newdream.net>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
 <200804250941.35343.chris.mason@oracle.com> <48120BE2.2080207@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48120BE2.2080207@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Apr 2008, Zach Brown wrote:
> We still have the same inode, and it has the same size, but its extent
> items look very different.  The extent for the first 64k looks much the
> same.  It references the old 64m extent on disk.  But see the 'nr
> 65536', it only maps 64k of that 64m into the file.  Then we have the 4k
> extent that we just wrote.  Then we have another reference to that 64m
> extent but for the remaining data after the new 4k.

Is there anything in the defragger (or whatever) that looks for minimally 
referenced extents?  Once can imagine a situation where only a small piece 
of a large extent is remains referenced, but that information is buried in 
the forward reference(s).

> debug-tree is fantastic, but it can be kind of intimidating if you don't
> already know what all the numbers mean :).  Reducing the barrier to

Yep.  Although in my case, the biggest stumbling block was realizing that 
the key type

> 	item 3 key (258 12 0) itemoff 2652 itemsize 41
                        ^^
is in printed in hex for some reason.  Der.

sage
