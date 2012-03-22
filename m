From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/2] Btrfs: fix deadlock on umount by umount_prepare
 interface
Date: Thu, 22 Mar 2012 15:39:36 +1100
Message-ID: <20120322043936.GD3592@dastard>
References: <4F6A98CD.5090701@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F6A98CD.5090701@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2012 at 11:13:17AM +0800, Miao Xie wrote:
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

Every time a deadlock involving writeback_inodes_sb...if_idle()
comes up, I give the same response. If the s_umount is write locked,
then the sb is not idle. IOWs, writeback_inodes_sb...if_idle()
should be doing down_read_trylock(), not down_read().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
