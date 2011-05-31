From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: use btrfs_ino to access inode number
Date: Tue, 31 May 2011 19:49:40 +0200
Message-ID: <20110531174940.GB12709@twin.jikos.cz>
References: <1306861694-5785-1-git-send-email-dsterba@suse.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306861694-5785-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

both patches are pushed to

git://repo.or.cz/linux-2.6/btrfs-unstable.git #fixes


david

On Tue, May 31, 2011 at 07:08:14PM +0200, David Sterba wrote:
> commit 4cb5300bc ("Btrfs: add mount -o auto_defrag") accesses inode
> number directly while it should use the helper with the new inode
> number allocator.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
