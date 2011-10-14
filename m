From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] writeback: Improve busyloop prevention
Date: Fri, 14 Oct 2011 15:31:13 -0400
Message-ID: <1318620308-sup-2416@shiny>
References: <1318453043-32057-1-git-send-email-jack@suse.cz> <1318453043-32057-2-git-send-email-jack@suse.cz> <20111013142638.GB6938@localhost> <20111013201354.GC27363@quack.suse.cz> <20111014071802.GB25687@infradead.org>
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20111014071802.GB25687@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-10-14 03:18:02 -0400:
> What btrfs does for the btree inode is insane, and I'm pretty sure I
> already complained about it.  It really needs to stop registering that
> inode with the writeback code and just driver it manually.  Same as
> other filesystems do for their "micro-managed" metadata.
> 

So I think you probably don't like the inode and the part where we
actively decide not to writeback when there isn't much dirty.

Yes, it would be different if btrfs had its own LRU for the btrees, and
if it maintained them such that the LRU understood it was better to kick
out leaves than roots.

I've really wanted to play with this for a while.

-chris
