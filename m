Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaKXReb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 12:34:31 -0500
Date: Mon, 24 Nov 2014 18:34:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Message-ID: <20141124173430.GB26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <20141124152101.GA12575@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141124152101.GA12575@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 07:21:01AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 21, 2014 at 02:59:21PM -0500, Theodore Ts'o wrote:
> > We needed to preserve update_time() because btrfs wants to have a
> > special btrfs_root_readonly() check; otherwise we could drop the
> > update_time() inode operation entirely.
> 
> Can't btrfs just set the immutable flag on every inode that is read
> when the root has the BTRFS_ROOT_SUBVOL_RDONLY flag? 

This would lead to change in return code from EROFS to EPERM/EACCESS for
all syscalls that do not pass through permissions() callback. Also, now
each file from a readonly subvol will show the 'i' attribute and there's
now way to determine if the file had had the 'i' attribute before it was
snapshotted.

> That would
> cut down the places that need this check to the ioctl path so that
> we prevent users from clearling the immutable flag.

This means that even the root or capable user are not able to clear the
flag.

Even though the extra btrfs_root_readonly checks are not all great, the
number of surprises that the immutable bit could bring is IMO not great
either.

These callbacks that now implement the extra check:

- update_time
- setattr
- setflags (ioctl)
- setxattr
- removexattr

The btrfs_root_readonly checks in setxattr and removexattr are
unnecessary because they're done through xattr_permisssion. I'll send a
patch to remove them.

'setflags' is an ioctl and all the checks have to be done there.
The generic permission() callback cannot be used here because it would
fail to clear eg. the immutable flag.

'setattr' does limited permission checks (IMMUTABLE and APPEND), nothing
that calls to the filesystem directly or indirectly.

The remaining one is 'update_time'. I'm not sure if the amount of work
the switch to IMUUTABLE bit would need is justified, compared to this
one instance of extra btrfs_root_readonly test. As the VFS layer has no
notion of subvolume it's not able to determine the RO/RW status without
asking the filesystem anyway.
