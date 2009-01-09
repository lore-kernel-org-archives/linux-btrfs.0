From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 12:29:18 -0700
Message-ID: <20090109192918.GE6936@parisc-linux.org>
References: <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org> <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain> <20090109185509.GJ26290@one.firstfloor.org> <alpine.LFD.2.00.0901091045090.6528@localhost.localdomain> <20090109193506.GL26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090109193506.GL26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2009 at 08:35:06PM +0100, Andi Kleen wrote:
> - Also inline everything static that is only called once
> [on the theory that this shrinks code size which is true
> according to my measurements]
> 
> -fno-inline-functions-called once disables this new rule.
> It's very well and clearly defined.

It's also not necessarily what we want.  For example, in fs/direct-io.c,
we have:

static ssize_t
direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
        const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
        unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
        struct dio *dio)
{
[150 lines]
}

ssize_t
__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
        struct block_device *bdev, const struct iovec *iov, loff_t offset, 
        unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
        int dio_lock_type)
{
[100 lines]
        retval = direct_io_worker(rw, iocb, inode, iov, offset,
                                nr_segs, blkbits, get_block, end_io, dio);
[10 lines]
}

Now, I'm not going to argue the directIO code is a shining example of
how we want things to look, but we don't really want ten arguments
being marshalled into a function call; we want gcc to inline the
direct_io_worker() and do its best to optimise the whole thing.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
