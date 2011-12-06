From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Tue, 6 Dec 2011 04:59:23 -0500
Message-ID: <20111206095923.GB9138@infradead.org>
References: <4EDDA9B3.60508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EDDA9B3.60508@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2011 at 01:35:47PM +0800, Miao Xie wrote:
> The reason the deadlock is that:
>   Task					Btrfs-cleaner
>   umount()
>     down_write(&s->s_umount)
>     close_ctree()
>       wait for the end of
>       btrfs-cleaner
> 					start_transaction
> 					  reserve space
> 					    shrink_delalloc()
> 					      writeback_inodes_sb_nr_if_idle()
> 						down_read(&sb->s_umount)
> So, the deadlock has happened.
> 
> We fix it by trying to lock >s_umount, if _trylock_ fails, it means the fs
> is on remounting or umounting. At this time, we will use the sync function of
> btrfs to sync all the delalloc file. It may waste lots of time, but as a
> corner case, we needn't care.

I can't see why you need the writeout when the trylocks fails.  Umount
needs to take care of writing out all pending file data anyway, so doing
it from the cleaner thread in addition doesn't sound like it would help.

So I'd rather suggest to move the trylock into
writeback_inodes_sb_nr_if_idle, and while you're at it also rewrite
writeback_inodes_sb_if_idle that ext4 is using to sit on top of
writeback_inodes_sb_nr_if_idle to share that logic, and drop the
unused writeback_inodes_sb_nr export.
