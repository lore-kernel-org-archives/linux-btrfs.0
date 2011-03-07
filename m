From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] a couple of i_nlink fixes in btrfs
Date: Mon, 07 Mar 2011 11:58:13 -0500
Message-ID: <1299517070-sup-1687@think>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110304171353.GU22723@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Al Viro's message of 2011-03-04 12:13:53 -0500:
>     a) rename() plays with i_nlink of old_inode; bad, since it's not
> locked.  I'd add a variant of btrfs_unlink_inode() that would leave
> btrfs_drop_nlink()/btrfs_update_inode() to callers and use it instead.
>     b) btrfs_link() doesn't check for i_nlink overflows.  I don't
> know if there's anything preventing that many links to a file on btrfs,
> but if there is, it's at least worth a comment in there...
> 
>     Please, review; patches in followups or in #btrfs in vfs-2.6.git

Thanks, these both look good but I'll test here as well.  Are you
planning on pushing for .38?

-chris
