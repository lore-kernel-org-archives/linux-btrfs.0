Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55816 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaK0UNX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 15:13:23 -0500
Date: Thu, 27 Nov 2014 15:13:16 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Andreas Dilger <adilger@dilger.ca>,
        Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>
Subject: Re: [PATCH-v4 6/7] ext4: add support for a lazytime mount option
Message-ID: <20141127201316.GE14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-7-git-send-email-tytso@mit.edu>
 <20141126224843.GG9561@dastard>
 <1A106262-D64C-4493-856F-AAAFC3BE2647@dilger.ca>
 <20141126233537.GH9561@dastard>
 <20141127132752.GF30152@quack.suse.cz>
 <20141127133227.GA11872@quack.suse.cz>
 <20141127152524.GB14091@thunk.org>
 <20141127154159.GA11922@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141127154159.GA11922@quack.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 27, 2014 at 04:41:59PM +0100, Jan Kara wrote:
>   Hum, but this puts lots of stuff under inode_hash_lock, including
> writeback list lock. I don't like this too much. I understand that getting
> handle for each inode is rather more CPU intensive but it should still be a
> clear win over the current situation and avoids entangling locks like this.

Hmm, if we dropped the inode_requeue_dirtytime(), then we can avoid
taking the writeback list lock.  The net result is that we would have
some inodes still on the b_dirty_time list that were no longer
I_DIRTY_TIME, but since I_DIRTY_TIME wouldn't be set, it's mostly
harmless since when we do iterate over the b_dirty_time list, those
inodes can be quickly identified and skipped over.  (And if the inode
ever gets dirtied for real, then it will get moved onto the b_dirty
list and that will be that.)

The problem with getting a handle on the inode is not just that it is
more CPU intensive, but that can't let the iput_final() call happen
until after we have finished the transaction handle.  We could keep a
linked list of inodes attached to the handle, and then only call iput
on them once ext4_journal_stop(handle) gets called, but that's a
complication I'd like to avoid if at all possible.

Being able to opporunistically write the timestamps when we are
journalling an inode table block is a pretty big win, so if we end up
extending the hold time on inode_hash_lock (only when we come across a
I_DIRTY_TIME inode that we can clear) a tiny bit, there will be a lot
of workloads where I think it's a worthwhile tradeoff.  If we can
avoid entangling the writebakc list lock, does that make you happier
about this approach?

	     	      	       	     	 - Ted
