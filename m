From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] writeback: Improve busyloop prevention
Date: Fri, 14 Oct 2011 03:18:02 -0400
Message-ID: <20111014071802.GB25687@infradead.org>
References: <1318453043-32057-1-git-send-email-jack@suse.cz>
 <1318453043-32057-2-git-send-email-jack@suse.cz>
 <20111013142638.GB6938@localhost>
 <20111013201354.GC27363@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wu Fengguang <fengguang.wu@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111013201354.GC27363@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

What btrfs does for the btree inode is insane, and I'm pretty sure I
already complained about it.  It really needs to stop registering that
inode with the writeback code and just driver it manually.  Same as
other filesystems do for their "micro-managed" metadata.

