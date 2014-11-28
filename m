Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56285 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaK1FhC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 00:37:02 -0500
Date: Fri, 28 Nov 2014 00:36:56 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>
Subject: Re: [PATCH-v4 2/7] vfs: add support for a lazytime mount option
Message-ID: <20141128053656.GI14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-3-git-send-email-tytso@mit.edu>
 <20141127131421.GE30152@quack.suse.cz>
 <20141127230016.GH14091@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141127230016.GH14091@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 27, 2014 at 06:00:16PM -0500, Theodore Ts'o wrote:
> Well.... it's not quite enough.  The problem is that for ext3 and
> ext4, the actual work of writing the inode happens in dirty_inode(),
> not in write_inode().  Which means we need to do something like this.
> 
> I'm not entirely sure whether or not this is too ugly to live;
> personally, I think my hack of handling this in update_time() might be
> preferable....

.... and this doesn't work because it breaks ext3/ext4's transaction
handling, since the writeback thread could be racing against some
transactional update of the inode.  So I don't see a way of making the
queue_io / move_expired_inodes approach to the 24 hour time being
tractable.

So the alternatives that I can see at this point is either give up on
the 24 hour timeout, or we fall back to handling this in
update_time().

					- Ted
