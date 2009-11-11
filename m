From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 10:22:22 -0800
Message-ID: <4AFB00DE.9070101@oracle.com>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net> <20091111145435.GB5566@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	hch@lst.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091111145435.GB5566@think>
List-ID: <linux-btrfs.vger.kernel.org>


> I like this much more than providing a journal start/stop to userland.
> If we can get Christoph to ack the exports we can work on the interface
> in general.

I'll note, briefly, that it seems dangerous to call right into the sys_
functions instead of going through the architecture's syscall number
dispatching path.  Do you know if the syscalls you're calling have
compat wrappers on some architectures for some userspace abis?

With that out of the way, though, I'll get on to my bigger point.

This interface for specifying an array of syscalls to call looks a whole
lot like the work that fs/aio.c, syslets, and acall have all done.  The
flags for stopping processing of the array based on errors from the
syscalls are remarkably similar to Ingo's atom structs.

So maybe there's an opportunity for a generic syscall for processing
batches of syscalls.  Maybe you'll bracket some of them with btrfs
ioctls for flagging the task_struct as being in a btrfs transaction, but
maybe you'll also flag some for concurrent acall processing or nutty
syslet thread spawning if they block.

It'll probably take some work to be able to call syscall handlers from C
on all architectures, and we'd have to be really careful about the
semantics if we start mixing btrfs ioctls and async flags, but it just
might be worth it.

- z
