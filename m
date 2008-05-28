From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Drop dcache entry after creating snapshot and subvolume
Date: Wed, 28 May 2008 01:08:53 -0400
Message-ID: <20080528050853.GA23213@infradead.org>
References: <alpine.LNX.1.10.0805280011160.5461@titan.stealer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0805280011160.5461@titan.stealer.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 28, 2008 at 12:41:24AM +0200, Sven Wegener wrote:
> I have a patch (see below) that does an explicit d_drop() on the dentry 
> after looking it up via d_find_alias() and d_lookup(), starting at the root 
> inode. Currently it's for snapshot creation only, subvolume creation needs 
> the same. There doesn't seem to be a kernel function for this case and 
> using the normal d_revalidate method is inefficient as snapshot and 
> subvolume creation is the only place where we need this and the creation is 
> a rare case. Is this the right way to go?

I don't like this manual dropping very much.  Rather the snapshot should
be created using vfs_mkdir or equivalent opencoded bits that actually
turn the negative dentry into the real instanciated one.

Then again it might actually be better to have a separate superblock
for the snapshot to not get a too messy dentry tree, but before
commenting on that I need to actually dig into that area of btrfs again.
