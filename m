From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Tue, 6 Dec 2011 06:23:23 -0500
Message-ID: <20111206112322.GA10836@infradead.org>
References: <4EDDA9B3.60508@cn.fujitsu.com>
 <20111206095923.GB9138@infradead.org>
 <4EDDF740.6060100@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EDDF740.6060100@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2011 at 07:06:40PM +0800, Miao Xie wrote:
> > I can't see why you need the writeout when the trylocks fails.  Umount
> > needs to take care of writing out all pending file data anyway, so doing
> > it from the cleaner thread in addition doesn't sound like it would help.
> 
> umount invokes sync_fs() and write out all the dirty file data. For the
> other file systems, its OK because the file system does not introduce dirty pages
> by itself. But btrfs is different. Its automatic defragment will make lots of dirty
> pages after sync_fs() and reserve lots of meta-data space for those pages.
> And then the cleaner thread may find there is no enough space to reserve, it must
> sync the dirty file data and release the reserved space which is for the dirty
> file data.

I think the safest way to fix is is to write out all dirty data again
once the cleaner thread has been safely stopped.

