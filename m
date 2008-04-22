From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Tue, 22 Apr 2008 13:48:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804221338250.23551@cobra.newdream.net>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
 <200804221632.34654.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804221632.34654.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Apr 2008, Chris Mason wrote:
> I'm definitely willing to include it for you to experiment with.  Holding a 
> transaction from userland can indeed lead to deadlock, but in this case your 
> userland basically owns the server anyway.  I'm worried about some nasty 
> corner cases still, but btrfs is blissfully ignoring those right now anyway.
> 
> One problem will be operations that are basically boundless (truncating a 
> file, large writes).  Eventually the ENOSPC support will hook into the 
> transaction system to make sure a given operation reserves enough free space.
> 
> With your ioctls, the "do a bunch of stuff" will need to honor the same 
> accounting rules as the kernel code (which don't exist yet).

So, if the transaction start ioctl made a space reservation, and if _all_ 
fs ops were wrapped by such reservations, that should avoid ENOSPC, yeah?

That's doesn't really help with the memory pressure issue, though.  :(

> I thought your original plan was to do all of this from userland (without a 
> kernel filesystem at all)?  The btrfs progs share most of the same code with 
> the kernel, so with a little love to the transaction and IO subsystems, you'd 
> be able to use it as a library style DB.

Yeah...  The issue is just that "a little love" is significantly more love 
than this handful of ioctls, and I'm a little wary of getting into it.  
That does seem like a better long term solution, though.

sage
