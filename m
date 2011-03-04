From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] a couple of i_nlink fixes in btrfs
Date: Fri, 4 Mar 2011 17:13:53 +0000
Message-ID: <20110304171353.GU22723@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

	a) rename() plays with i_nlink of old_inode; bad, since it's not
locked.  I'd add a variant of btrfs_unlink_inode() that would leave
btrfs_drop_nlink()/btrfs_update_inode() to callers and use it instead.
	b) btrfs_link() doesn't check for i_nlink overflows.  I don't
know if there's anything preventing that many links to a file on btrfs,
but if there is, it's at least worth a comment in there...

	Please, review; patches in followups or in #btrfs in vfs-2.6.git
