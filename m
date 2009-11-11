From: Sage Weil <sage@newdream.net>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 14:22:26 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0911111132150.28467@cobra.newdream.net>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
 <20091111145435.GB5566@think> <4AFB00DE.9070101@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	hch@lst.de
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AFB00DE.9070101@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 11 Nov 2009, Zach Brown wrote:
> > I like this much more than providing a journal start/stop to userland.
> > If we can get Christoph to ack the exports we can work on the interface
> > in general.
> 
> I'll note, briefly, that it seems dangerous to call right into the sys_
> functions instead of going through the architecture's syscall number
> dispatching path.  Do you know if the syscalls you're calling have
> compat wrappers on some architectures for some userspace abis?
> 
> With that out of the way, though, I'll get on to my bigger point.
> 
> This interface for specifying an array of syscalls to call looks a whole
> lot like the work that fs/aio.c, syslets, and acall have all done.  The
> flags for stopping processing of the array based on errors from the
> syscalls are remarkably similar to Ingo's atom structs.

Yeah, I think both syslets (with atoms) and acall provide a much more 
elegant interface than what I've described.  (I should have looked at them 
more closely before; I didn't care about being asynchronous.)  The only 
real requirement for the atomic user transactions is that the batch of 
operations not be interrupted by SIGKILL or seg fault (at least for the 
calls that are being used).

> So maybe there's an opportunity for a generic syscall for processing
> batches of syscalls.  Maybe you'll bracket some of them with btrfs
> ioctls for flagging the task_struct as being in a btrfs transaction, but
> maybe you'll also flag some for concurrent acall processing or nutty
> syslet thread spawning if they block.

Right.  In my case running things asynchronously isn't strictly necessary.  
And it seems like the asynchrony and batching (in both syslets and acall) 
are somewhat orthogonal.  Maybe the async part should really be completely 
independent, and not, say, a flag?

	sys_batch(a vector/graph of ops)

and then

	sys_acall(a single call)
or	sys_syslet(a single call)	

Both Ingo's atoms or the simpler acall op vector would suffice in my 
case.  Even current acall() would do; the thread overhead won't be 
sigficant over the relatively slow fs transactions.

sage
