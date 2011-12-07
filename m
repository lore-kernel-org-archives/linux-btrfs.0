From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing
 umount
Date: Wed, 7 Dec 2011 13:11:58 +0200
Message-ID: <20111207111158.GA4929@zambezi.lan>
References: <4EDDA9B3.60508@cn.fujitsu.com>
 <20111206095923.GB9138@infradead.org>
 <4EDDF740.6060100@cn.fujitsu.com>
 <20111206112322.GA10836@infradead.org>
 <20111206213611.GB4029@shiny>
 <4EDED007.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	viro <viro@zeniv.linux.org.uk>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EDED007.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 07, 2011 at 10:31:35AM +0800, Miao Xie wrote:
> On tue, 6 Dec 2011 16:36:11 -0500, Chris Mason wrote:
> > On Tue, Dec 06, 2011 at 06:23:23AM -0500, Christoph Hellwig wrote:
> >> On Tue, Dec 06, 2011 at 07:06:40PM +0800, Miao Xie wrote:
> >>>> I can't see why you need the writeout when the trylocks fails.  Umount
> >>>> needs to take care of writing out all pending file data anyway, so doing
> >>>> it from the cleaner thread in addition doesn't sound like it would help.
> >>>
> >>> umount invokes sync_fs() and write out all the dirty file data. For the
> >>> other file systems, its OK because the file system does not introduce dirty pages
> >>> by itself. But btrfs is different. Its automatic defragment will make lots of dirty
> >>> pages after sync_fs() and reserve lots of meta-data space for those pages.
> >>> And then the cleaner thread may find there is no enough space to reserve, it must
> >>> sync the dirty file data and release the reserved space which is for the dirty
> >>> file data.
> >>
> >> I think the safest way to fix is is to write out all dirty data again
> >> once the cleaner thread has been safely stopped.
> >>
> > 
> > Said another way we want to stop the autodefrag code before the unmount
> > is ready to continue.  We also want to stop balancing, scrub etc.
> 
> But there is no good interface to do it before umount gets s_umount lock.
> I think trylock(in writeback_inodes_sb_nr_if_idle()) + dirty data flush
> can help us to fix the bug perfectly.

But it won't fix the umount while balancing family of deadlocks (they
are really of the same nature, vfs grabs s_umount mutex and we need it
to proceed).  (Balance cancelling code is part of restriper patches,
it's just a hook in close_ctree() that waits until we are done
relocating a chunk - very similar to cleaner wait)

One example would be that balancing code while dirtying pages calls
balance_dirty_pages_ratelimited() for each dirtied page, as it should.
And if balance_dirty_pages() then decides to initiate writeback we are
stuck schedule()ing forever, because writeback can't proceed w/o
read-taking s_umount mutex which is fully held by vfs - it just skips
the relocation inode.

Thanks,

		Ilya
